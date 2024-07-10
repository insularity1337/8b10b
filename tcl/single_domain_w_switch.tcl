set_db init_lib_search_path /home/sasha/Downloads/skywater-pdk/libraries
set_db script_search_path   /home/sasha/Downloads/8b10b/tcl
set_db init_hdl_search_path /home/sasha/Downloads/8b10b/src

set low_speed_slow { \
  sky130_fd_sc_ls/latest/timing/sky130_fd_sc_ls__ss_100C_1v60.lib \
}

set_db library $low_speed_slow

read_hdl -language sv { \
  ./rc23408/encoder_3b4b.sv \
  ./rc23408/encoder_5b6b.sv \
  ./rc23408/encoder_8b10b.sv \
  ./rc23408/decoder_8b10b.sv \
  pa_env.sv \
}

read_power_intent \
  -1801 \
  -version 3.1 \
  /home/sasha/Downloads/8b10b/tcl/single_domain_w_switch.upf \
  -module pa_env

elaborate

apply_power_intent

read_sdc sdc.tcl

syn_generic

commit_power_intent

syn_map

syn_opt -incr