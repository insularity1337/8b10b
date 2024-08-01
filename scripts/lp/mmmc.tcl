create_library_set \
  -name slow_cold_lib \
  -timing { \
    sky130_fd_sc_lp/latest/timing/sky130_fd_sc_lp__ss_n40C_1v55.lib \
    sky130_fd_sc_lp/latest/timing/sky130_fd_sc_lp__ss_n40C_1v60.lib \
    sky130_fd_sc_lp/latest/timing/sky130_fd_sc_lp__ss_n40C_1v65.lib}

create_library_set \
  -name slow_hot_lib \
  -timing sky130_fd_sc_lp/latest/timing/sky130_fd_sc_lp__ss_100C_1v60.lib

create_library_set \
  -name fast_cold_lib \
  -timing { \
    sky130_fd_sc_lp/latest/timing/sky130_fd_sc_lp__ff_n40C_1v56.lib \
    sky130_fd_sc_lp/latest/timing/sky130_fd_sc_lp__ff_n40C_1v76.lib \
    sky130_fd_sc_lp/latest/timing/sky130_fd_sc_lp__ff_n40C_1v95.lib \
    sky130_fd_sc_lp/latest/timing/sky130_fd_sc_lp__ff_n40C_2v05.lib}

create_library_set \
  -name fast_hot_lib \
  -timing sky130_fd_sc_lp/latest/timing/sky130_fd_sc_lp__ff_100C_1v95.lib



#
# Virtual operating conditions
#
create_opcond \
  -name vnom_cold \
  -process 1.0 \
  -voltage 1.6 \
  -temperature -40

create_opcond \
  -name vboost_cold \
  -process 1.0 \
  -voltage 1.95 \
  -temperature -40

create_opcond \
  -name vnom_hot \
  -process 1.0 \
  -voltage 1.6 \
  -temperature 100

create_opcond \
  -name vboost_hot \
  -process 1.0 \
  -voltage 1.95 \
  -temperature 100



#
# Timing conditions
#

# Slow & low temperature
create_timing_condition \
  -name slow_vnom_hot \
  -library_sets slow_hot_lib \
  -opcond vnom_hot

create_timing_condition \
  -name slow_vnom_cold \
  -library_sets slow_cold_lib \
  -opcond vnom_cold

create_timing_condition \
  -name fast_vboost_cold \
  -library_sets fast_cold_lib \
  -opcond vboost_cold

create_timing_condition \
  -name fast_vboost_hot \
  -library_sets fast_hot_lib \
  -opcond vboost_hot



#
# RC corners
#
set captbl_path [concat $env(SKYWATER_PDK)/libraries/sky130_fd_sc_lp/latest/lp.captbl]

create_rc_corner \
  -name rc_typ_cold \
  -temperature -40 \
  -cap_table $captbl_path

create_rc_corner \
  -name rc_typ_hot \
  -temperature -100 \
  -cap_table $captbl_path



#
# Delay corners
#

# "slow" corners
create_delay_corner \
  -name slow_vnom_hot_typ_rc \
  -early_timing_condition slow_vnom_hot \
  -late_timing_condition slow_vnom_hot \
  -early_rc_corner rc_typ_hot \
  -late_rc_corner rc_typ_hot

create_delay_corner \
  -name slow_vnom_cold_typ_rc \
  -early_timing_condition slow_vnom_cold \
  -late_timing_condition slow_vnom_cold \
  -early_rc_corner rc_typ_cold \
  -late_rc_corner rc_typ_cold

# "fast" corners
create_delay_corner \
  -name fast_vboost_cold_typ_rc \
  -early_timing_condition fast_vboost_cold \
  -late_timing_condition fast_vboost_cold \
  -early_rc_corner rc_typ_cold \
  -late_rc_corner rc_typ_cold

create_delay_corner \
  -name fast_vboost_hot_typ_rc \
  -early_timing_condition fast_vboost_hot \
  -late_timing_condition fast_vboost_hot \
  -early_rc_corner rc_typ_hot \
  -late_rc_corner rc_typ_hot



#
# Constraint modes
#
create_constraint_mode \
  -name setup_10Mb \
  -sdc_files ../scripts/lp/10Mb.sdc

create_constraint_mode \
  -name hold_10Mb \
  -sdc_files ../scripts/lp/10Mb.sdc

create_constraint_mode \
  -name setup_100Mb \
  -sdc_files ../scripts/lp/100Mb.sdc

create_constraint_mode \
  -name hold_100Mb \
  -sdc_files ../scripts/lp/100Mb.sdc



#
# Analysis views
#

# Setup views
create_analysis_view \
  -name setup_10Mb_slow_hot_vnom \
  -constraint_mode setup_10Mb \
  -delay_corner slow_vnom_hot_typ_rc

create_analysis_view \
  -name setup_10Mb_slow_cold_vnom \
  -constraint_mode setup_10Mb \
  -delay_corner slow_vnom_cold_typ_rc

create_analysis_view \
  -name setup_100Mb_slow_hot_vnom \
  -constraint_mode setup_100Mb \
  -delay_corner slow_vnom_hot_typ_rc

create_analysis_view \
  -name setup_100Mb_slow_cold_vnom \
  -constraint_mode setup_100Mb \
  -delay_corner slow_vnom_cold_typ_rc


# Hold views
create_analysis_view \
  -name hold_10Mb_fast_cold_vboost \
  -constraint_mode hold_10Mb \
  -delay_corner fast_vboost_cold_typ_rc

create_analysis_view \
  -name hold_10Mb_fast_hot_vboost \
  -constraint_mode hold_10Mb \
  -delay_corner fast_vboost_hot_typ_rc

create_analysis_view \
  -name hold_100Mb_fast_cold_vboost \
  -constraint_mode hold_100Mb \
  -delay_corner fast_vboost_cold_typ_rc

create_analysis_view \
  -name hold_100Mb_fast_hot_vboost \
  -constraint_mode hold_100Mb \
  -delay_corner fast_vboost_hot_typ_rc



#
# Analysis view
#
set_analysis_view \
  -setup { \
    setup_100Mb_slow_hot_vnom \
    setup_100Mb_slow_cold_vnom \
    setup_10Mb_slow_hot_vnom \
    setup_10Mb_slow_cold_vnom} \
  -hold { \
    hold_100Mb_fast_cold_vboost \
    hold_100Mb_fast_hot_vboost \
    hold_10Mb_fast_cold_vboost \
    hold_10Mb_fast_hot_vboost}