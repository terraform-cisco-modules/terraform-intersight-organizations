locals {
  #____________________________________________________________
  #
  # local defaults and name suffix/prefix
  #____________________________________________________________
  defaults = yamldecode(file("${path.module}/defaults.yaml"))
  model    = { for org in local.org_keys : org => var.model[org] }
  org_keys = sort(keys(var.model))
  #____________________________________________________________
  #
  # Intersight - Organizations
  #____________________________________________________________
  organization = { for k, v in local.model : k => merge(local.defaults, v, {
    name            = k
    resource_groups = [for e in lookup(v, "resource_groups", []) : merge(local.defaults.resource_groups, e)]
    tags            = lookup(v, "tags", var.global_settings.tags)
  }) if lookup(v, "create_organization", false) == true }
  shared_organizations = { for k, v in local.organization : k => {
    organizations_to_share_with = v.organizations_to_share_with
  } if length(v.organizations_to_share_with) > 0 }
  data_organizations = flatten([for k, v in local.organization : [for e in v.organizations_to_share_with : e if contains(local.org_keys, e) == false]])
  organizations_data = merge({ for k, v in intersight_organization_organization.map : k => v }, {
    for k, v in data.intersight_organization_organization.map : k => v.results
  })
  #____________________________________________________________
  #
  # Intersight - Resource Groups
  #____________________________________________________________
  resource_group = {
    for i in flatten([for k, value in local.organization : [for v in lookup(value, "resource_groups", []) : merge(v, {
      tags = lookup(v, "tags", var.global_settings.tags)
      selectors = {
        blades               = lookup(lookup(v.resources, "sub_targets", {}), "blades", [])
        fabric_interconnects = lookup(v.resources, "fabric_interconnects", [])
        rackmounts           = lookup(lookup(v.resources, "sub_targets", {}), "rackmounts", [])
        registrations        = concat(lookup(v.resources, "fabric_interconnects", []), lookup(v.resources, "standalone", []))
        standalone           = lookup(v.resources, "standalone", [])
      }
      })
  ]]) : i.name => i }
  fabric_resources     = flatten([for k, v in local.resource_group : lookup(v.resources, "fabric_interconnects", [])])
  standalone_resources = flatten([for k, v in local.resource_group : lookup(v.resources, "standalone", [])])
}