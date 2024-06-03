#!/bin/sh

xrun \
  -64bit \
  -gui \
  -lps_1801 ../scripts/sd/single_domain.upf \
  -lps_common_option \
  -lps_dig_lsr \
  -lps_logfile lps.log \
  -lps_verbose 5 \
  -lps_dut_top pa_env_tb/dut \
  -faccess \
  +rwc \
  ./pa_env_tb.sv \
  ../src/pa_env.sv \
  ../src/rc23408/decoder_8b10b.sv \
  ../src/rc23408/encoder_3b4b.sv \
  ../src/rc23408/encoder_5b6b.sv \
  ../src/rc23408/encoder_8b10b.sv