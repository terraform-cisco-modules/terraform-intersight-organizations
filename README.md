<!-- BEGIN_TF_DOCS -->
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Developed by: Cisco](https://img.shields.io/badge/Developed%20by-Cisco-blue)](https://developer.cisco.com)

# Terraform Intersight - Organizations Module

A Terraform module to configure Intersight Organizations.

### NOTE: THIS MODULE IS DESIGNED TO BE CONSUMED USING "EASY IMM"

### A comprehensive example using this module is available below:

## [Easy IMM](https://github.com/terraform-cisco-modules/easy-imm)

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.3.0 |
| <a name="requirement_intersight"></a> [intersight](#requirement\_intersight) | >=1.0.54 |
## Providers

| Name | Version |
|------|---------|
| <a name="provider_intersight"></a> [intersight](#provider\_intersight) | 1.0.52 |
## Modules

No modules.
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_global_settings"></a> [global\_settings](#input\_global\_settings) | YAML to HCL Data - global\_settings. | `any` | n/a | yes |
| <a name="input_model"></a> [model](#input\_model) | YAML to HCL Data - model. | `any` | n/a | yes |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_organizations"></a> [organizations](#output\_organizations) | Moids of the Organizations. |
| <a name="output_resource_groups"></a> [resource\_groups](#output\_resource\_groups) | Moids of the Resource Groups. |
## Resources

| Name | Type |
|------|------|
| [intersight_iam_sharing_rule.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/iam_sharing_rule) | resource |
| [intersight_organization_organization.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/organization_organization) | resource |
| [intersight_resource_group.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/resource_group) | resource |
| [intersight_asset_target.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/asset_target) | data source |
| [intersight_organization_organization.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/organization_organization) | data source |
<!-- END_TF_DOCS -->