RC18855_SRC_DIR = ./src/rc18855
RC23408_SRC_DIR = ./src/rc23408
QA_DIR = ./qa
IVERILOG_FLAGS = -g2012 -W all

rc18855_enc_files := $(RC18855_SRC_DIR)/*.sv
rc23408_enc_files := $(RC23408_SRC_DIR)/*.sv

rc18855_dec_files := ./src/rc18855/decoder_8b10b.sv
rc23408_dec_files := ./src/rc23408/decoder_8b10b.sv

enc_tb_files = $(QA_DIR)/enc_8b10b_tb/*.svh $(QA_DIR)/enc_8b10b_tb/*.sv
dec_tb_files = $(QA_DIR)/dec_8b10b_tb/*.svh $(QA_DIR)/dec_8b10b_tb/*.sv

clean:
	rm -rf *.vvp *.vcd ./sim ./synth

enc_rc18855: 
	iverilog $(IVERILOG_FLAGS) ./qa/dec_8b10b_tb/pkg_8b10b.svh $(enc_tb_files) $(rc18855_enc_files) -o enc.vvp

dec_rc18855:
	iverilog $(IVERILOG_FLAGS) ./qa/enc_8b10b_tb/*.svh $(dec_tb_files) $(rc18855_dec_files) -o dec.vvp

enc_rc23408:
	iverilog $(IVERILOG_FLAGS) ./qa/dec_8b10b_tb/pkg_8b10b.svh $(enc_tb_files) $(rc23408_enc_files) -o enc.vvp

dec_rc23408:
	iverilog $(IVERILOG_FLAGS) ./qa/enc_8b10b_tb/*.svh $(dec_tb_files) $(rc23408_dec_files) -o dec.vvp

multilib: clean
	mkdir ./synth; cd ./synth; genus -f ../scripts/multilib/synth.tcl; cd ../

lp: clean
	mkdir ./synth; cd ./synth; genus -f ../scripts/lp/synth.tcl; cd ../

sim: clean
	mkdir ./sim; cd ./sim; xrun -f ../scripts/multilib/xrun_launch_args.txt -f ../scripts/multilib/xrun_lp_args.txt -f ../scripts/multilib/xrun_files.txt; cd ../

.DEFAULT_GOAL := multilib