set_db init_lib_search_path /home/sasha/Downloads/skywater-pdk/libraries
set_db script_search_path   /home/sasha/Downloads/8b10b/tcl
set_db init_hdl_search_path /home/sasha/Downloads/8b10b/src

# set_db library sky130_fd_sc_hvl/latest/timing/sky130_fd_sc_hvl__tt_025C_3v30.lib

set_db information_level 11
set_db use_power_ground_pin_from_lef true
set_db lp_insert_clock_gating true 

read_mmmc /home/sasha/Downloads/8b10b/scripts/sd/mmmc.tcl

set_db lef_library { \
  sky130_fd_sc_hvl/latest/tech/sky130_fd_sc_hvl.tlef \
  sky130_fd_sc_hvl/latest/cells/a21oi/sky130_fd_sc_hvl__a21oi_1.lef \
  sky130_fd_sc_hvl/latest/cells/a21o/sky130_fd_sc_hvl__a21o_1.lef \
  sky130_fd_sc_hvl/latest/cells/a22oi/sky130_fd_sc_hvl__a22oi_1.lef \
  sky130_fd_sc_hvl/latest/cells/a22o/sky130_fd_sc_hvl__a22o_1.lef \
  sky130_fd_sc_hvl/latest/cells/and2/sky130_fd_sc_hvl__and2_1.lef \
  sky130_fd_sc_hvl/latest/cells/and3/sky130_fd_sc_hvl__and3_1.lef \
  sky130_fd_sc_hvl/latest/cells/buf/sky130_fd_sc_hvl__buf_16.lef \
  sky130_fd_sc_hvl/latest/cells/buf/sky130_fd_sc_hvl__buf_1.lef \
  sky130_fd_sc_hvl/latest/cells/buf/sky130_fd_sc_hvl__buf_2.lef \
  sky130_fd_sc_hvl/latest/cells/buf/sky130_fd_sc_hvl__buf_32.lef \
  sky130_fd_sc_hvl/latest/cells/buf/sky130_fd_sc_hvl__buf_4.lef \
  sky130_fd_sc_hvl/latest/cells/buf/sky130_fd_sc_hvl__buf_8.lef \
  sky130_fd_sc_hvl/latest/cells/conb/sky130_fd_sc_hvl__conb_1.lef \
  sky130_fd_sc_hvl/latest/cells/decap/sky130_fd_sc_hvl__decap_4.lef \
  sky130_fd_sc_hvl/latest/cells/decap/sky130_fd_sc_hvl__decap_8.lef \
  sky130_fd_sc_hvl/latest/cells/dfrbp/sky130_fd_sc_hvl__dfrbp_1.lef \
  sky130_fd_sc_hvl/latest/cells/dfrtp/sky130_fd_sc_hvl__dfrtp_1.lef \
  sky130_fd_sc_hvl/latest/cells/dfsbp/sky130_fd_sc_hvl__dfsbp_1.lef \
  sky130_fd_sc_hvl/latest/cells/dfstp/sky130_fd_sc_hvl__dfstp_1.lef \
  sky130_fd_sc_hvl/latest/cells/dfxbp/sky130_fd_sc_hvl__dfxbp_1.lef \
  sky130_fd_sc_hvl/latest/cells/dfxtp/sky130_fd_sc_hvl__dfxtp_1.lef \
  sky130_fd_sc_hvl/latest/cells/diode/sky130_fd_sc_hvl__diode_2.lef \
  sky130_fd_sc_hvl/latest/cells/dlclkp/sky130_fd_sc_hvl__dlclkp_1.lef \
  sky130_fd_sc_hvl/latest/cells/dlrtp/sky130_fd_sc_hvl__dlrtp_1.lef \
  sky130_fd_sc_hvl/latest/cells/dlxtp/sky130_fd_sc_hvl__dlxtp_1.lef \
  sky130_fd_sc_hvl/latest/cells/einvn/sky130_fd_sc_hvl__einvn_1.lef \
  sky130_fd_sc_hvl/latest/cells/einvp/sky130_fd_sc_hvl__einvp_1.lef \
  sky130_fd_sc_hvl/latest/cells/fill/sky130_fd_sc_hvl__fill_1.lef \
  sky130_fd_sc_hvl/latest/cells/fill/sky130_fd_sc_hvl__fill_2.lef \
  sky130_fd_sc_hvl/latest/cells/fill/sky130_fd_sc_hvl__fill_4.lef \
  sky130_fd_sc_hvl/latest/cells/fill/sky130_fd_sc_hvl__fill_8.lef \
  sky130_fd_sc_hvl/latest/cells/inv/sky130_fd_sc_hvl__inv_16.lef \
  sky130_fd_sc_hvl/latest/cells/inv/sky130_fd_sc_hvl__inv_1.lef \
  sky130_fd_sc_hvl/latest/cells/inv/sky130_fd_sc_hvl__inv_2.lef \
  sky130_fd_sc_hvl/latest/cells/inv/sky130_fd_sc_hvl__inv_4.lef \
  sky130_fd_sc_hvl/latest/cells/inv/sky130_fd_sc_hvl__inv_8.lef \
  sky130_fd_sc_hvl/latest/cells/lsbufhv2hv_hl/sky130_fd_sc_hvl__lsbufhv2hv_hl_1.lef \
  sky130_fd_sc_hvl/latest/cells/lsbufhv2hv_lh/sky130_fd_sc_hvl__lsbufhv2hv_lh_1.lef \
  sky130_fd_sc_hvl/latest/cells/lsbufhv2lv_simple/sky130_fd_sc_hvl__lsbufhv2lv_simple_1.lef \
  sky130_fd_sc_hvl/latest/cells/lsbufhv2lv/sky130_fd_sc_hvl__lsbufhv2lv_1.lef \
  sky130_fd_sc_hvl/latest/cells/lsbuflv2hv_clkiso_hlkg/sky130_fd_sc_hvl__lsbuflv2hv_clkiso_hlkg_3.lef \
  sky130_fd_sc_hvl/latest/cells/lsbuflv2hv_isosrchvaon/sky130_fd_sc_hvl__lsbuflv2hv_isosrchvaon_1.lef \
  sky130_fd_sc_hvl/latest/cells/lsbuflv2hv/sky130_fd_sc_hvl__lsbuflv2hv_1.lef \
  sky130_fd_sc_hvl/latest/cells/lsbuflv2hv_symmetric/sky130_fd_sc_hvl__lsbuflv2hv_symmetric_1.lef \
  sky130_fd_sc_hvl/latest/cells/mux2/sky130_fd_sc_hvl__mux2_1.lef \
  sky130_fd_sc_hvl/latest/cells/mux4/sky130_fd_sc_hvl__mux4_1.lef \
  sky130_fd_sc_hvl/latest/cells/nand2/sky130_fd_sc_hvl__nand2_1.lef \
  sky130_fd_sc_hvl/latest/cells/nand3/sky130_fd_sc_hvl__nand3_1.lef \
  sky130_fd_sc_hvl/latest/cells/nor2/sky130_fd_sc_hvl__nor2_1.lef \
  sky130_fd_sc_hvl/latest/cells/nor3/sky130_fd_sc_hvl__nor3_1.lef \
  sky130_fd_sc_hvl/latest/cells/o21ai/sky130_fd_sc_hvl__o21ai_1.lef \
  sky130_fd_sc_hvl/latest/cells/o21a/sky130_fd_sc_hvl__o21a_1.lef \
  sky130_fd_sc_hvl/latest/cells/o22ai/sky130_fd_sc_hvl__o22ai_1.lef \
  sky130_fd_sc_hvl/latest/cells/o22a/sky130_fd_sc_hvl__o22a_1.lef \
  sky130_fd_sc_hvl/latest/cells/or2/sky130_fd_sc_hvl__or2_1.lef \
  sky130_fd_sc_hvl/latest/cells/or3/sky130_fd_sc_hvl__or3_1.lef \
  sky130_fd_sc_hvl/latest/cells/probec_p/sky130_fd_sc_hvl__probec_p_8.lef \
  sky130_fd_sc_hvl/latest/cells/probe_p/sky130_fd_sc_hvl__probe_p_8.lef \
  sky130_fd_sc_hvl/latest/cells/schmittbuf/sky130_fd_sc_hvl__schmittbuf_1.lef \
  sky130_fd_sc_hvl/latest/cells/sdfrbp/sky130_fd_sc_hvl__sdfrbp_1.lef \
  sky130_fd_sc_hvl/latest/cells/sdfrtp/sky130_fd_sc_hvl__sdfrtp_1.lef \
  sky130_fd_sc_hvl/latest/cells/sdfsbp/sky130_fd_sc_hvl__sdfsbp_1.lef \
  sky130_fd_sc_hvl/latest/cells/sdfstp/sky130_fd_sc_hvl__sdfstp_1.lef \
  sky130_fd_sc_hvl/latest/cells/sdfxbp/sky130_fd_sc_hvl__sdfxbp_1.lef \
  sky130_fd_sc_hvl/latest/cells/sdfxtp/sky130_fd_sc_hvl__sdfxtp_1.lef \
  sky130_fd_sc_hvl/latest/cells/sdlclkp/sky130_fd_sc_hvl__sdlclkp_1.lef \
  sky130_fd_sc_hvl/latest/cells/sdlxtp/sky130_fd_sc_hvl__sdlxtp_1.lef \
  sky130_fd_sc_hvl/latest/cells/xnor2/sky130_fd_sc_hvl__xnor2_1.lef \
  sky130_fd_sc_hvl/latest/cells/xor2/sky130_fd_sc_hvl__xor2_1.lef \
}

read_hdl -language sv { \
  ./rc23408/encoder_3b4b.sv \
  ./rc23408/encoder_5b6b.sv \
  ./rc23408/encoder_8b10b.sv \
  ./rc23408/decoder_8b10b.sv \
  pa_env.sv \
}

read_power_intent \
  -1801 \
  /home/sasha/Downloads/8b10b/scripts/sd/single_domain.upf \
  -module pa_env

elaborate

set_db [get_db hinsts *enc] .ungroup_ok false

apply_power_intent

source \
  -verbose \
  /home/sasha/Downloads/8b10b/scripts/sd/floorplan.tcl

init_design

syn_generic -physical

commit_power_intent

syn_map -physical

syn_opt

write_snapshot \
  -innovus \
  -tag post_synth \
  -directory ./innovus \
  pa_env