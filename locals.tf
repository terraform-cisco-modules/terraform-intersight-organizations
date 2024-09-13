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
  shared_organizations = { for i in flatten(
    [for k, v in local.organization : [for e in v.organizations_to_share_with : { org = k, shared = e }] if length(v.organizations_to_share_with) > 0
  ]) : "${i.org}/${i.shared}" => i }
  #data_organizations = distinct(concat(flatten([for k, v in local.organization : [
  #  for e in v.organizations_to_share_with : e if contains(keys(local.organization), e) == false
  #]]), [for e in local.org_keys : e if contains(keys(local.organization), e) == false]))
  organizations_data = merge(
    { for e in data.intersight_organization_organization.map.results : e.name => e },
    { for k, v in intersight_organization_organization.map : k => v }
  )
  #____________________________________________________________
  #
  # Intersight - Resource Groups
  #____________________________________________________________
  resource_group = {
    for i in flatten([for k, value in local.organization : [for v in lookup(value, "resource_groups", []) : merge(v, {
      tags = lookup(v, "tags", var.global_settings.tags)
      selectors = {
        blades     = lookup(lookup(v.resources, "sub_targets", {}), "blades", [])
        rackmounts = lookup(lookup(v.resources, "sub_targets", {}), "rackmounts", [])
        targets    = lookup(v.resources, "targets", [])
      }
      })
  ]]) : i.name => i }
  target_resources = flatten([for k, v in local.resource_group : lookup(v.resources, "targets", [])])
}