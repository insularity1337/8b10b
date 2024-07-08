`timescale 1ns/1ns

module pa_env_tb ();

	logic clk = 1'b0;
	logic rstn = 1'b0;
	logic dvi;
	logic ki;
	logic [7:0] di;
	logic dvo;
	logic ko;
	logic [7:0] dout;
	logic viol;

	pa_env dut (
		.CLK (clk),
		.RSTn (rstn),
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

	initial
		#13 rstn = ~rstn;

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
		$supply_off("dut.VDD");
		$supply_off("dut.VSS");
		#10us;
		$supply_on("dut.VDD", 3.3);
		$supply_on("dut.VSS", 0);
		#10us;
		$supply_off("dut.VSS");
		$supply_off("dut.VDD");
	end


  // initial begin
  //   $supply_on("inst.VDD",1.2);
  //   $supply_on("inst.VSS",0.0);
  // end

endmodule