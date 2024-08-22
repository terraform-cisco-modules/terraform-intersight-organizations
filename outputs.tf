#__________________________________________________________
#
# Organizations / Resource Groups
#__________________________________________________________

output "organizations" {
  description = "Moids of the Organizations."
  value = merge({ for v in sort(keys(intersight_organization_organization.map)) : v => intersight_organization_organization.map[v].moid },
  { for k in sort(keys(data.intersight_organization_organization.map)) : k => data.intersight_organization_organization.map[k].results[0].moid })
}
output "resource_groups" {
  description = "Moids of the Resource Groups."
  value       = { for v in sort(keys(intersight_resource_group.map)) : v => intersight_resource_group.map[v].moid }
}
