`timescale 1ns/1ns

module pa_env_tb ();

	logic clk = 1'b0;
	logic rstn = 1'b0;
	logic dvi;
	logic ki = 1'b0;
	logic [7:0] di;
	logic dvo;
	logic ko;
	logic [7:0] dout;
	logic viol;

	logic ps_ctrl;
	logic iso_enc;

	pa_env dut (
		.CLK (clk),
		.RSTn (rstn),
		.PS_CTRL (ps_ctrl),
		.ISO_ENC (iso_enc),
		.DVI (dvi),
		.KI (ki),
		.DI (di),
		.DVO (dvo),
		.KO (ko),
		.DO (dout),
		.VIOL (viol)
	);

	initial
		forever
			#5 clk = ~clk;

	initial begin
		repeat(10)
			@(posedge clk);

		dvi <= 1'b1;
		di <= $urandom_range(0, 255);
		@(posedge clk);
		dvi <= 1'b0;
		di <= 8'h00;
	end

	initial begin
		$supply_on("dut.VDD_ENC", 1.8);
		$supply_on("dut.VDD", 3.3);
		$supply_on("dut.VSS", 0);
		#13 rstn = ~rstn;
		#10us;
		ps_ctrl = 1'b0;
		iso_enc = 1'b1;
		#10us;
		ps_ctrl = 1'b1;
		rstn = ~rstn;
		#20;
		rstn = ~rstn;
		#10us;
		@(posedge clk);
		dvi <= 1'b1;
		@(posedge clk);
		dvi <= 1'b0;
		#10us;
		iso_enc = 1'b0;
		#100ns;
		ps_ctrl = 1'b0;

		// $supply_off("dut.VDD");
		// $supply_off("dut.VSS");
		// #10us;
		// #10us;
		// $supply_off("dut.VSS");
		// $supply_off("dut.VDD");
	end


  // initial begin
  //   $supply_on("inst.VDD",1.2);
  //   $supply_on("inst.VSS",0.0);
  // end

endmodule