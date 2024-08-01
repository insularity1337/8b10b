set lib_path [concat $env(SKYWATER_PDK)/libraries]

set_db init_lib_search_path $lib_path
set_db script_search_path   ../scripts/lp
set_db init_hdl_search_path ../src

set_db information_level 11
set_db use_power_ground_pin_from_lef true
set_db lp_insert_clock_gating true 

read_mmmc ../scripts/lp/mmmc.tcl

set lp_tech_lef [find [get_db init_lib_search_path]/sky130_fd_sc_lp/ -name "*.tlef"]

set lp_cell_lef [find \
  [get_db init_lib_search_path]/sky130_fd_sc_lp/ \
  -name "*.lef" ! -name "*magic*" ! -name "*tap*" ! -name "*fill*" ! -name "*dly*" ! -name "*decap*" ! -name "*bus*" ! -name "*diode*"]

read_physical -lefs [list {*}$lp_tech_lef {*}$lp_cell_lef]

set rc23408_src [find [get_db init_hdl_search_path]/rc23408 -name "*.sv"]

read_hdl \
  -language sv \
  [list {*}$rc23408_src pa_env.sv]

read_power_intent \
  -1801 \
  ../scripts/lp/top.upf \
  -module pa_env

elaborate

apply_power_intent

source \
  -verbose \
  ../scripts/lp/floorplan.tcl

init_design

get_db lib_cells {*tap* *fill* *dly* *decap* *bus* *diode*} -foreach {set_db $object .avoid true}

set_db [get_db lib_cells *a2111*] .avoid true

get_db \
  lib_cells *lp* \
  -if {(.is_isolation_cell == true) && (.dont_touch == true)} \
  -foreach {set_db "$object" .dont_use false}

get_db \
  lib_cells * \
  -if {(.clock_gating_integrated_cell ne "")} \
  -foreach {set_db $object .dont_use false}

commit_power_intent

syn_generic -physical

syn_map -physical

syn_opt

# report_timing \
    -fields { \
        "timing_point" \
        "flags" \
        "arc" \
        "edge" \
        "cell" \
        "fanout" \
        "load" \
        "transition" \
        "delay" \
        "arrival" \
        "lib_set" \
        "user_derate" \
        "user_mean_derate" \
        "user_sigma_derate" \
        "total_derate" \
        "incr_derate" \
        "aocv_derate" \
        "socv_derate" \
        "stage_count" \
        "power_domain" \
        "wire_length" \
        "instance_location" \
        "pin_location" \
        "module" \
        "voltage"} \
    -from pa_env/enc/DO_reg[0]/CLK \
    -to pa_env/r_int_reg[0]/D

check_power_structure \
  -detail \
  > lp.cnfrml

write_reports \
  -directory post_synth_rpt \
  -tag pa_env

write_snapshot \
  -directory ./innovus_import \
  -innovus -tag post_synth

write_sdf > pa_env.sdf

q