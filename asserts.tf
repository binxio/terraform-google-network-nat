#######################################################################################################
#
# Terraform does not have a easy way to check if the input parameters are in the correct format.
# On top of that, terraform will sometimes produce a valid plan but then fail during apply.
# To handle these errors beforehad, we're using the 'file' hack to throw errors on known mistakes.
#
#######################################################################################################
locals {
  # Regular expressions
  regex_router_nat_name = "[a-zA-Z0-9][a-zA-Z0-9\\-\\.]*[a-zA-Z0-9]+"
  max_size_name         = 63

  # Terraform assertion hack
  assert_head = "\n\n-------------------------- /!\\ ASSERTION FAILED /!\\ --------------------------\n\n"
  assert_foot = "\n\n-------------------------- /!\\ ^^^^^^^^^^^^^^^^ /!\\ --------------------------\n"
  asserts = {
    for router_nat, settings in local.router_nats : router_nat => merge({
      router_nat_name_too_long = length(settings.region) > local.max_size_name ? file(format("%sNAT [%s]'s generated name is too long:\n%s\n%s > %s chars!%s", local.assert_head, router_nat, settings.region, length(settings.region), local.max_size_name, local.assert_foot)) : "ok"
      router_nat_name_regex    = length(regexall("^${local.regex_router_nat_name}$", settings.region)) == 0 ? file(format("%sNAT [%s]'s generated name [%s] does not match regex ^%s$%s", local.assert_head, router_nat, settings.region, local.regex_router_nat_name, local.assert_foot)) : "ok"

      ### Add additional checks
    })
  }
}
