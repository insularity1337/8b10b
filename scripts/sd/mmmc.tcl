create_library_set \
  -name hvl_ss_1v65_100C \
  -timing { \
    sky130_fd_sc_hvl/latest/timing/sky130_fd_sc_hvl__ss_100C_1v65.lib \
  }

create_library_set \
  -name hvl_ff_5v5_n40C \
  -timing { \
    sky130_fd_sc_hvl/latest/timing/sky130_fd_sc_hvl__ff_n40C_5v50.lib \
  }

create_library_set \
  -name hvl_tt_3v3_25C \
  -timing { \
    sky130_fd_sc_hvl/latest/timing/sky130_fd_sc_hvl__tt_025C_3v30.lib \
  }



create_opcond \
  -name opcond_1v65_100C \
  -process 1.0 \
  -voltage 1.65 \
  -temperature 100

create_opcond \
  -name opcond_5v5_n40C \
  -process 1.0 \
  -voltage 5.5 \
  -temperature -40

create_opcond \
  -name opcond_3v3_25C \
  -process 1.0 \
  -voltage 3.3 \
  -temperature 25



create_timing_condition \
  -name tcond_hvl_slow \
  -library_sets hvl_ss_1v65_100C \
  -opcond opcond_1v65_100C

create_timing_condition \
  -name tcond_hvl_fast \
  -library_sets hvl_ff_5v5_n40C \
  -opcond opcond_5v5_n40C

create_timing_condition \
  -name tcond_hvl_typ \
  -library_sets hvl_tt_3v3_25C \
  -opcond opcond_3v3_25C



create_rc_corner \
  -name def_rc_corner \
  -cap_table /home/sasha/hvl.captbl \
  -temperature 100 \
  -pre_route_cap 1.0 \
  -pre_route_res 1.0 \
  -post_route_cap {1.0 1.0 1.0} \
  -post_route_res {1.0 1.0 1.0} \
  -post_route_cross_cap {1.0 1.0 1.0} \
  -pre_route_clock_cap 1.0 \
  -pre_route_clock_res 1.0 \
  -post_route_clock_cap {1.0 1.0 1.0} \
  -post_route_clock_res {1.0 1.0 1.0}



create_delay_corner \
  -name slow_delay_corner \
  -early_timing_condition tcond_hvl_slow \
  -late_timing_condition tcond_hvl_slow \
  -early_rc_corner def_rc_corner \
  -late_rc_corner def_rc_corner

create_delay_corner \
  -name fast_delay_corner \
  -early_timing_condition tcond_hvl_fast \
  -late_timing_condition tcond_hvl_fast \
  -early_rc_corner def_rc_corner \
  -late_rc_corner def_rc_corner

create_delay_corner \
  -name typ_delay_corner \
  -early_timing_condition tcond_hvl_typ \
  -late_timing_condition tcond_hvl_typ \
  -early_rc_corner def_rc_corner \
  -late_rc_corner def_rc_corner



create_constraint_mode \
  -name func_10Mb \
  -sdc_files {/home/sasha/Downloads/8b10b/tcl/mode_10Mb.sdc}

create_constraint_mode \
  -name func_100Mb \
  -sdc_files {/home/sasha/Downloads/8b10b/tcl/mode_100Mb.sdc}



create_analysis_view \
  -name setup_10Mb_view \
  -constraint_mode func_10Mb \
  -delay_corner slow_delay_corner

create_analysis_view \
  -name setup_100Mb_view \
  -constraint_mode func_100Mb \
  -delay_corner slow_delay_corner

create_analysis_view \
  -name hold_10Mb_view \
  -constraint_mode func_10Mb \
  -delay_corner fast_delay_corner

create_analysis_view \
  -name hold_100Mb_view \
  -constraint_mode func_100Mb \
  -delay_corner fast_delay_corner

create_analysis_view \
  -name typ_10Mb_view \
  -constraint_mode func_10Mb \
  -delay_corner typ_delay_corner

create_analysis_view \
  -name typ_100Mb_view \
  -constraint_mode func_100Mb \
  -delay_corner typ_delay_corner



set_analysis_view \
  -setup { \
    setup_100Mb_view \
    setup_10Mb_view \
    typ_100Mb_view \
    typ_10Mb_view \
  } \
  -hold { \
    hold_100Mb_view \
    hold_10Mb_view \
    typ_100Mb_view \
    typ_10Mb_view \
  }