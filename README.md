# proxy-pac-bucket

This Terraform setup creates a secure, scalable infrastructure for hosting and distributing a Proxy Auto-Configuration (PAC) file using AWS services.

### Update the docs:
```bash
cd proxy-pac-bucket-name

# Format your Terraform files (default: terraform/ folder)
make fmt

# Format files in a specific path
make fmt p=modules/networking

# Generate documentation (default: terraform/ folder)
make docs

# Generate docs for a specific path
make docs p=modules/networking
```

The generated `README.md` will contain:
- Your custom header from `.header.md`
- Auto-generated tables of inputs (variables)
- Auto-generated tables of outputs
- Provider requirements
- Resource documentation

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.94.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.94.0 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudfront_distribution.cdn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution) | resource |
| [aws_cloudfront_origin_access_control.oac](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_control) | resource |
| [aws_s3_bucket.my_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_policy.oac_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_object.json_file](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name (dev, staging, prod) | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Name of the project | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | `"us-east-1"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags to apply to resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cdn_url"></a> [cdn\_url](#output\_cdn\_url) | Output the cdn URL |
