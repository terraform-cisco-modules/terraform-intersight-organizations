#____________________________________________________________
#
# Intersight Resource Groups
# GUI Location: System > Resource Groups
#____________________________________________________________
data "intersight_compute_rack_unit" "map" {
  for_each = { for v in local.standalone_resources : v => v }
  serial   = each.value
}

data "intersight_network_element" "map" {
  for_each = { for v in local.fabric_resources : v => v }
  serial   = each.value
}


resource "intersight_resource_group" "map" {
  depends_on = [data.intersight_compute_rack_unit.map, data.intersight_network_element.map]
  for_each = { for k, v in local.resource_group : k => merge(v, {
    selectors = merge(v.selectors, {
      registrations = distinct(concat(
        [for e in v.selectors.fabric_interconnects : data.intersight_network_element.map[e].results[0].registered_device[0].moid],
        [for e in v.selectors.standalone : data.intersight_compute_rack_unit.map[e].results[0].registered_device[0].moid]
      ))
    })
  }) }
  description = each.value.description != "" ? each.value.description : "${each.value.name} Resource Group."
  name        = each.value.name
  qualifier   = "Allow-Selectors"
  lifecycle { ignore_changes = [organizations] }
  dynamic "selectors" {
    for_each = { for v in ["blades", "rackmounts", "registrations"] : v => v if length(each.value.selectors[v]) > 0 }
    content {
      class_id = "resource.Selector"
      selector = length(regexall("blades", selectors.key)
        ) > 0 ? "/api/v1/compute/Blades?$filter=(Serial in ('${trim(join("', '", each.value.selectors[selectors.key]), ", '")}') and ManagementMode eq 'Intersight'" : length(regexall("rackmounts", selectors.key)
        ) > 0 ? "/api/v1/compute/RackUnits?$filter=(Serial in ('${trim(join("', '", each.value.selectors[selectors.key]), ", '")}') and ManagementMode eq 'Intersight'" : length(regexall("registrations", selectors.key)
      ) > 0 ? "/api/v1/asset/DeviceRegistrations?$filter=(Moid in ('${trim(join("', '", each.value.selectors[selectors.key]), ", '")}')" : ""
      object_type = "resource.Selector"
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
