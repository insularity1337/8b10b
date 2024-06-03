set lib_path [concat $env(SKYWATER_PDK)/libraries]

set_db init_lib_search_path $lib_path
set_db script_search_path   ../scripts/multilib
set_db init_hdl_search_path ../src

set_db information_level 11
set_db lp_insert_clock_gating true
set_db lp_insert_discrete_clock_gating_logic true

# zero balanced level shifter cells (asymmetric rise and fall delays)
set hvl { \
  sky130_fd_sc_hvl/latest/timing/sky130_fd_sc_hvl__ss_100C_3v00.lib \
  sky130_fd_sc_hvl/latest/timing/sky130_fd_sc_hvl__ss_100C_3v00_lowhv1v65_lv1v60.lib}

set ls sky130_fd_sc_ls/latest/timing/sky130_fd_sc_ls__ss_100C_1v60.lib
set lp sky130_fd_sc_lp/latest/timing/sky130_fd_sc_lp__ss_100C_1v60.lib

create_library_domain { \
  env_domain \
  enc_domain \
  dec_domain}

set_db [get_db library_domain *env_domain] .library $hvl
set_db [get_db library_domain *enc_domain] .library [concat $ls $lp]
set_db [get_db library_domain *dec_domain] .library $lp

# Disable non-iso lp cells inside encoder domain
get_db \
  lib_cells *lp* \
  -if {(.library == *enc_domain*) && (.is_isolation_cell == false)} \
  -foreach {set_db $object .dont_use true}

# Disable srpg lp cells inside encoder domain
get_db \
  lib_cells *lp* \
  -if {(.library == *enc_domain*) && (.is_flop == true)} \
  -foreach {set_db $object .dont_use false}

get_db \
  lib_cells *lp* \
  -if {(.is_isolation_cell == true) && (.dont_touch == true)} \
  -foreach {set_db "$object" .dont_use false}

read_hdl -sv { \
  ./rc23408/encoder_3b4b.sv \
  ./rc23408/encoder_5b6b.sv \
  ./rc23408/encoder_8b10b.sv \
  ./rc23408/encoder_8b10b_wrapper.sv \
  ./rc23408/decoder_8b10b.sv \
  ./rc23408/decoder_8b10b_wrapper.sv \
  pa_env.sv \
}

read_power_intent \
  -1801 \
  -version 3.1 \
  ../scripts/multilib/top.upf \
  -module pa_env

elaborate

set_db \
  [get_db modules *encoder_8b10b] \
  .lp_clock_gating_min_flops \
  1

set_db \
  [get_db modules *decoder_8b10b] \
  .lp_clock_gating_min_flops \
  1

apply_power_intent

read_sdc sdc.tcl

set_db \
  [get_db designs *pa_env] \
  .library_domain \
  [get_db library_domains *env_domain]

set_db \
  [get_db hinsts *enc] \
  .library_domain \
  [get_db library_domains *enc_domain]

set_db \
  [get_db hinsts *dec] \
  .library_domain \
  [get_db library_domains *dec_domain]

commit_power_intent

syn_generic

syn_map

syn_opt

check_power_structure -detail > lp.cnfrml

write_snapshot \
  -directory ./innovus_import \
  -innovus -tag post_synth \
  pa_env

q