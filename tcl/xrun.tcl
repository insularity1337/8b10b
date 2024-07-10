xrun \
	-64bit \
	-gui \
	-lps_1801 ../tcl/single_domain_w_switch.upf \
	-lps_common_option \
	-lps_dut_top pa_env_tb/dut \
	-faccess \
	+rwc \
	./pa_env_tb.sv \
	../src/pa_env.sv \
	../src/rc23408/decoder_8b10b.sv \
	../src/rc23408/encoder_3b4b.sv \
	../src/rc23408/encoder_5b6b.sv \
	../src/rc23408/encoder_8b10b.sv
