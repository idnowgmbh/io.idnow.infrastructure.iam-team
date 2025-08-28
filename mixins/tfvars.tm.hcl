
generate_file "envs/sbx/_variables.tfvars" {
  condition = tm_can(global.envs.sbx) && !tm_contains(terramate.stack.tags, "no-terraform")
  content = tm_hclencode(global.envs.sbx.variables)
}

generate_file "envs/sbx-euc1/_variables.tfvars" {
  condition = tm_can(global.envs.sbx-euc1) && !tm_contains(terramate.stack.tags, "no-terraform")
  content = tm_hclencode(global.envs.sbx-euc1.variables)
}

generate_file "envs/sbx-euw3/_variables.tfvars" {
  condition = tm_can(global.envs.sbx-euw3) && !tm_contains(terramate.stack.tags, "no-terraform")
  content = tm_hclencode(global.envs.sbx-euw3.variables)
}

generate_file "envs/sbx/_backend.tfvars" {
  condition = tm_can(global.envs.sbx) && !tm_contains(terramate.stack.tags, "no-terraform")
  content = tm_hclencode(global.envs.sbx.backend)
}

generate_file "envs/sbx-euc1/_backend.tfvars" {
  condition = tm_can(global.envs.sbx-euc1) && !tm_contains(terramate.stack.tags, "no-terraform")
  content = tm_hclencode(global.envs.sbx-euc1.backend)
}

generate_file "envs/sbx-euw3/_backend.tfvars" {
  condition = tm_can(global.envs.sbx-euw3) && !tm_contains(terramate.stack.tags, "no-terraform")
  content = tm_hclencode(global.envs.sbx-euw3.backend)
}

generate_file "envs/off/_variables.tfvars" {
  condition = tm_can(global.envs.off) && !tm_contains(terramate.stack.tags, "no-terraform")
  content = tm_hclencode(global.envs.off.variables)
}

generate_file "envs/off-euc1/_variables.tfvars" {
  condition = tm_can(global.envs.off-euc1) && !tm_contains(terramate.stack.tags, "no-terraform")
  content = tm_hclencode(global.envs.off-euc1.variables)
}

generate_file "envs/off-euw3/_variables.tfvars" {
  condition = tm_can(global.envs.off-euw3) && !tm_contains(terramate.stack.tags, "no-terraform")
  content = tm_hclencode(global.envs.off-euw3.variables)
}

generate_file "envs/off/_backend.tfvars" {
  condition = tm_can(global.envs.off) && !tm_contains(terramate.stack.tags, "no-terraform")
  content = tm_hclencode(global.envs.off.backend)
}

generate_file "envs/off-euc1/_backend.tfvars" {
  condition = tm_can(global.envs.off-euc1) && !tm_contains(terramate.stack.tags, "no-terraform")
  content = tm_hclencode(global.envs.off-euc1.backend)
}

generate_file "envs/off-euw3/_backend.tfvars" {
  condition = tm_can(global.envs.off-euw3) && !tm_contains(terramate.stack.tags, "no-terraform")
  content = tm_hclencode(global.envs.off-euw3.backend)
}

generate_file "envs/prd/_variables.tfvars" {
  condition = tm_can(global.envs.prd) && !tm_contains(terramate.stack.tags, "no-terraform")
  content = tm_hclencode(global.envs.prd.variables)
}

generate_file "envs/prd-euc1/_variables.tfvars" {
  condition = tm_can(global.envs.prd-euc1) && !tm_contains(terramate.stack.tags, "no-terraform")
  content = tm_hclencode(global.envs.prd-euc1.variables)
}

generate_file "envs/prd-euw3/_variables.tfvars" {
  condition = tm_can(global.envs.prd-euw3) && !tm_contains(terramate.stack.tags, "no-terraform")
  content = tm_hclencode(global.envs.prd-euw3.variables)
}

generate_file "envs/prd/_backend.tfvars" {
  condition = tm_can(global.envs.prd) && !tm_contains(terramate.stack.tags, "no-terraform")
  content = tm_hclencode(global.envs.prd.backend)
}

generate_file "envs/prd-euc1/_backend.tfvars" {
  condition = tm_can(global.envs.prd-euc1) && !tm_contains(terramate.stack.tags, "no-terraform")
  content = tm_hclencode(global.envs.prd-euc1.backend)
}

generate_file "envs/prd-euw3/_backend.tfvars" {
  condition = tm_can(global.envs.prd-euw3) && !tm_contains(terramate.stack.tags, "no-terraform")
  content = tm_hclencode(global.envs.prd-euw3.backend)
}

generate_file "envs/playground1/_variables.tfvars" {
  condition = tm_can(global.envs.playground1) && !tm_contains(terramate.stack.tags, "no-terraform")
  content = tm_hclencode(global.envs.playground1.variables)
}

generate_file "envs/playground1-euc1/_variables.tfvars" {
  condition = tm_can(global.envs.playground1-euc1) && !tm_contains(terramate.stack.tags, "no-terraform")
  content = tm_hclencode(global.envs.playground1-euc1.variables)
}

generate_file "envs/playground1-euw3/_variables.tfvars" {
  condition = tm_can(global.envs.playground1-euw3) && !tm_contains(terramate.stack.tags, "no-terraform")
  content = tm_hclencode(global.envs.playground1-euw3.variables)
}

generate_file "envs/playground1/_backend.tfvars" {
  condition = tm_can(global.envs.playground1) && !tm_contains(terramate.stack.tags, "no-terraform")
  content = tm_hclencode(global.envs.playground1.backend)
}

generate_file "envs/playground1-euc1/_backend.tfvars" {
  condition = tm_can(global.envs.playground1-euc1) && !tm_contains(terramate.stack.tags, "no-terraform")
  content = tm_hclencode(global.envs.playground1-euc1.backend)
}

generate_file "envs/playground1-euw3/_backend.tfvars" {
  condition = tm_can(global.envs.playground1-euw3) && !tm_contains(terramate.stack.tags, "no-terraform")
  content = tm_hclencode(global.envs.playground1-euw3.backend)
}

generate_file "envs/playground2/_variables.tfvars" {
  condition = tm_can(global.envs.playground2) && !tm_contains(terramate.stack.tags, "no-terraform")
  content = tm_hclencode(global.envs.playground2.variables)
}

generate_file "envs/playground2-euc1/_variables.tfvars" {
  condition = tm_can(global.envs.playground2-euc1) && !tm_contains(terramate.stack.tags, "no-terraform")
  content = tm_hclencode(global.envs.playground2-euc1.variables)
}

generate_file "envs/playground2-euw3/_variables.tfvars" {
  condition = tm_can(global.envs.playground2-euw3) && !tm_contains(terramate.stack.tags, "no-terraform")
  content = tm_hclencode(global.envs.playground2-euw3.variables)
}

generate_file "envs/playground2/_backend.tfvars" {
  condition = tm_can(global.envs.playground2) && !tm_contains(terramate.stack.tags, "no-terraform")
  content = tm_hclencode(global.envs.playground2.backend)
}

generate_file "envs/playground2-euc1/_backend.tfvars" {
  condition = tm_can(global.envs.playground2-euc1) && !tm_contains(terramate.stack.tags, "no-terraform")
  content = tm_hclencode(global.envs.playground2-euc1.backend)
}

generate_file "envs/playground2-euw3/_backend.tfvars" {
  condition = tm_can(global.envs.playground2-euw3) && !tm_contains(terramate.stack.tags, "no-terraform")
  content = tm_hclencode(global.envs.playground2-euw3.backend)
}

generate_file "envs/dev/_variables.tfvars" {
  condition = tm_can(global.envs.dev) && !tm_contains(terramate.stack.tags, "no-terraform")
  content = tm_hclencode(global.envs.dev.variables)
}

generate_file "envs/dev-euc1/_variables.tfvars" {
  condition = tm_can(global.envs.dev-euc1) && !tm_contains(terramate.stack.tags, "no-terraform")
  content = tm_hclencode(global.envs.dev-euc1.variables)
}

generate_file "envs/dev-euw3/_variables.tfvars" {
  condition = tm_can(global.envs.dev-euw3) && !tm_contains(terramate.stack.tags, "no-terraform")
  content = tm_hclencode(global.envs.dev-euw3.variables)
}

generate_file "envs/dev/_backend.tfvars" {
  condition = tm_can(global.envs.dev) && !tm_contains(terramate.stack.tags, "no-terraform")
  content = tm_hclencode(global.envs.dev.backend)
}

generate_file "envs/dev-euc1/_backend.tfvars" {
  condition = tm_can(global.envs.dev-euc1) && !tm_contains(terramate.stack.tags, "no-terraform")
  content = tm_hclencode(global.envs.dev-euc1.backend)
}

generate_file "envs/dev-euw3/_backend.tfvars" {
  condition = tm_can(global.envs.dev-euw3) && !tm_contains(terramate.stack.tags, "no-terraform")
  content = tm_hclencode(global.envs.dev-euw3.backend)
}

generate_file "envs/tst/_variables.tfvars" {
  condition = tm_can(global.envs.tst) && !tm_contains(terramate.stack.tags, "no-terraform")
  content = tm_hclencode(global.envs.tst.variables)
}

generate_file "envs/tst-euc1/_variables.tfvars" {
  condition = tm_can(global.envs.tst-euc1) && !tm_contains(terramate.stack.tags, "no-terraform")
  content = tm_hclencode(global.envs.tst-euc1.variables)
}

generate_file "envs/tst-euw3/_variables.tfvars" {
  condition = tm_can(global.envs.tst-euw3) && !tm_contains(terramate.stack.tags, "no-terraform")
  content = tm_hclencode(global.envs.tst-euw3.variables)
}

generate_file "envs/tst/_backend.tfvars" {
  condition = tm_can(global.envs.tst) && !tm_contains(terramate.stack.tags, "no-terraform")
  content = tm_hclencode(global.envs.tst.backend)
}

generate_file "envs/tst-euc1/_backend.tfvars" {
  condition = tm_can(global.envs.tst-euc1) && !tm_contains(terramate.stack.tags, "no-terraform")
  content = tm_hclencode(global.envs.tst-euc1.backend)
}

generate_file "envs/tst-euw3/_backend.tfvars" {
  condition = tm_can(global.envs.tst-euw3) && !tm_contains(terramate.stack.tags, "no-terraform")
  content = tm_hclencode(global.envs.tst-euw3.backend)
}
