
# Module `terraform-google-network-nat`

Core Version Constraints:
* `>= 0.13`

Provider Requirements:
* **google (`hashicorp/google`):** (any version)

## Input Variables
* `environment` (required): Company environment for which the resources are created (e.g. dev, tst, acc, prd, all).
* `owner` (required): Owner of the resource. This variable is used to set the 'owner' label. Will be used as default for each subnet, but can be overridden using the subnet settings.
* `project` (required): Company project name.
* `router_nat_defaults` (required)
* `router_nat_subnetwork_defaults` (required)
* `router_nats` (required): Map of router_nats to be created. The key will be used for the router_nat name so it should describe the router_nat purpose. The value can be a map with the following keys to override default settings:
  * nat_ip_allocate_option
  * source_subnetwork_ip_ranges_to_nat
  * router
  * nat_ips
  * drain_nat_ips
  * network
  * subnetwork
  * min_ports_per_vm
  * udp_idle_timeout_sec
  * icmp_idle_timeout_sec
  * tcp_established_idle_timeout_sec
  * tcp_transitory_idle_timeout_sec
  * log_config
  * region
  * project


## Output Values
* `map`: outputs for all router_nats created
* `router_map`: outputs for all router created
* `router_nat_defaults`: The generic defaults used for router_nat settings
* `router_nat_subnetwork_defaults`: The generic defaults used for router_nat subnetwork settings

## Managed Resources
* `google_compute_router.map` from `google`
* `google_compute_router_nat.map` from `google`

## Creating a new release
After adding your changed and committing the code to GIT, you will need to add a new tag.
```
git tag vx.x.x
git push --tag
```
If your changes might be breaking current implementations of this module, make sure to bump the major version up by 1.

If you want to see which tags are already there, you can use the following command:
```
git tag --list
```
Required APIs
=============
For the VPC services to deploy, the following APIs should be enabled in your project:
 * cloudresourcemanager.googleapis.com
 * compute.googleapis.com
 * servicenetworking.googleapis.com

Testing
=======
This module comes with [terratest](https://github.com/gruntwork-io/terratest) scripts for both unit testing and integration testing.
A Makefile is provided to run the tests using docker, but you can also run the tests directly on your machine if you have terratest installed.

### Run with make
Make sure to set GOOGLE_CLOUD_PROJECT to the right project and GOOGLE_CREDENTIALS to the right credentials json file
You can now run the tests with docker:
```
make test
```

### Run locally
From the module directory, run:
```
cd test && TF_VAR_owner=$(id -nu) go test
```
