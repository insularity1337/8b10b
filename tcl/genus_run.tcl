set_db init_lib_search_path /home/sasha/Downloads/skywater-pdk/libraries
set_db script_search_path   /home/sasha/Downloads/8b10b/tcl
set_db init_hdl_search_path /home/sasha/Downloads/8b10b/src

set high_voltage_slow { \
  sky130_fd_sc_hvl/latest/timing/sky130_fd_sc_hvl__ss_100C_3v00.lib \
  sky130_fd_sc_hvl/latest/timing/sky130_fd_sc_hvl__ss_100C_3v00_lowhv1v65_lv1v60.lib \
}

set low_speed_slow { \
  sky130_fd_sc_ls/latest/timing/sky130_fd_sc_ls__ss_100C_1v60.lib \
}

set low_power_slow { \
  sky130_fd_sc_lp/latest/timing/sky130_fd_sc_lp__ss_100C_1v60.lib \
}

create_library_domain { \
  top_domain \
  encoder_domain \
  decoder_domain \
}

set_db [get_db library_domain *top_domain] .library $high_voltage_slow
set_db [get_db library_domain *encoder_domain] .library $low_speed_slow
set_db [get_db library_domain *decoder_domain] .library $low_power_slow

read_hdl -language sv { \
  ./rc23408/encoder_3b4b.sv \
  ./rc23408/encoder_5b6b.sv \
  ./rc23408/encoder_8b10b.sv \
  ./rc23408/decoder_8b10b.sv \
  pa_env.sv \
}

elaborate

read_sdc sdc.tcl

set_db \
  [get_db designs *pa_env] \
  .library_domain \
  [get_db library_domains *top_domain]

set_db \
  [get_db modules *encoder_8b10b] \
  .library_domain \
  [get_db library_domains *encoder_domain]

set_db \
  [get_db modules *decoder_8b10b] \
  .library_domain \
  [get_db library_domains *decoder_domain]

syn_generic

syn_map