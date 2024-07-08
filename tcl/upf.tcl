set_design_top pa_env

set_scope .

# Top level supply ports
create_supply_port VDD
create_supply_port VSS
create_supply_port VDD_E
create_supply_port VDD_D

# Subdomains supply ports
create_supply_port enc/VDD
create_supply_port dec/VDD

# Top level supply nets
create_supply_net VDD_E
create_supply_net VDD_D

# Connection of top level supply nets
connect_supply_net VDD_E -ports {VDD_E enc/VDD}
connect_supply_net VDD_D -ports {VDD_D enc/VDD}

# Top-level power domain
create_supply_set env_ss \
  -function {power VDD} \
  -function {ground VSS}

create_power_domain env_pd \
  -elements {.} \
  -supply {primary env_ss}

# Encoder power domain
create_supply_set enc_ss \
  -function {power VDD_E} \
  -function {ground VSS}

create_power_domain enc_pd \
  -elements {./enc} \
  -supply {primary enc_ss}

# Decoder power domain
create_supply_set dec_ss \
  -function {power VDD_D} \
  -function {ground VSS}

create_power_domain dec_pd \
  -elements {./dec} \
  -supply {primary dec_ss}

#
# Power-aware environment
#
add_power_state \
  -supply env_pd.primary \
  -state {ON  -supply_expr {power == {FULL_ON, 3.3} && ground == {FULL_ON, 0.0}} -simstate NORMAL} \
  -state {OFF -supply_expr {power == OFF            && ground == {FULL_ON, 0.0}} -simstate NORMAL}

#
# Encoder environment
#
add_power_state \
  -supply enc_pd.primary \
  -state {ON  -supply_expr {power == {FULL_ON, 1.8} && ground == {FULL_ON, 0.0}} -simstate NORMAL} \
  -state {OFF -supply_expr {power == OFF            && ground == {FULL_ON, 0.0}} -simstate NORMAL}

#
# Decoder environment
#
add_power_state \
  -supply dec_pd.primary \
  -state {ON  -supply_expr {power == {FULL_ON, 1.8} && ground == {FULL_ON, 0.0}} -simstate NORMAL} \
  -state {OFF -supply_expr {power == OFF            && ground == {FULL_ON, 0.0}} -simstate NORMAL}



# # Retention strategy
# set_retention dec_retention \
#   -domain dec_pd \
#   -elements {inst:pa_env/dec/DO_reg[*]}