#____________________________________________________________
#
# Intersight Organizations
# GUI Location: System > Organizations
#____________________________________________________________
data "intersight_organization_organization" "map" {
  for_each = { for v in local.data_organizations : v => v }
  name     = each.value
}

resource "intersight_organization_organization" "map" {
  depends_on  = [intersight_resource_group.map]
  for_each    = local.organization
  description = each.value.description != "" ? each.value.description : "${each.value.name} Organization."
  name        = each.value.name
  dynamic "resource_groups" {
    for_each = { for v in each.value.resource_groups : v.name => v }
    content {
      moid        = intersight_resource_group.map[resource_groups.value.name].moid
      object_type = "resource.Group"
    }
  }
  dynamic "tags" {
    for_each = { for v in each.value.tags : v.key => v }
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}

resource "intersight_iam_sharing_rule" "map" {
  depends_on = [intersight_organization_organization.map]
  for_each   = local.shared_organizations
  shared_resource {
    moid        = intersight_organization_organization.map[each.value.org].moid
    object_type = "organization.Organization"
  }
  shared_with_resource {
    moid        = local.organizations_data[each.value.shared].moid
    object_type = "organization.Organization"
  }
}