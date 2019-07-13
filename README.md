# Configure Hosting for a Static Site in Azure with Terraform

I have been working on migrating several of my existing sites hosted on WordPress and DokuWiwi to static sites and work with both Azure and Terraform quite a bit in my day job so figured it would make sense to build a TF project to configure all the hosting parts. I had seen several of the pieces in various places but could not find a complete implementation so decided it would make sense to make this available for others to use as well.

## Structure

In order to be able to use a custom domain and related SSL certificate with a static site hosted on Azure it is necessary to add a bit more infrastructure than simply dropping everything in a storage account.

The `ad` module creates a service principal that is used by the DNS Challenge feature in the ACME certificate creation.

The `dns` module is configured so that other entries besides those necessary to host the static site can be maintained including A, CNAME, and TXT records. MX records still need some work. (See the TODO List). This module also creates a dns_editor AD role scoped to the dns zone that is created and assigns the service principal created in the AD module to the role.

The `ssl` module creates an Azure Key Vault, a Let's Encrypt based TLS certificate, and then stores the certificate in the key vault where it can be referenced by the CDN.

There is also a little project in the `utility` folder for generating a TLS private key to be used in creation of the certificate.

## Known Issues

In it's current state there appears to be a bug in either Terraform or one of the providers (ACME or AzureAD) that is causing an error when the `acme_certificate` resource is processed that ends up causing a panic in the runtime. The workaround is to plan/apply the ad and dns modules first, and then the ssl module.

```
terraform apply -target module.ad -target module.dns
terraform apply -target module.ssl
```

## TODO List

 - Update MX Record creation to use a dynamic block. (My initial attempts did not work for unknown reasons)
 - Add Storage Account
 - Add CDN