`timescale 1ns/1ns

module pa_env_tb ();

  logic       clk  = 1'b0;
  logic       rstn = 1'b0;
  logic       dvi        ;
  logic       ki   = 1'b0;
  logic [7:0] di         ;
  logic       dvo        ;
  logic       ko         ;
  logic [7:0] dout       ;
  logic       viol       ;

  logic enc_ps_ctrl       ;
  logic dec_ps_ctrl       ;
  logic enc_iso           ;
  logic dec_iso           ;
  logic enc_ret     = 1'b0;
  logic dec_ret     = 1'b0;

  pa_env dut (
    .CLK (clk ),
    .RSTn(rstn),
    .DVI (dvi ),
    .KI  (ki  ),
    .DI  (di  ),
    .DVO (dvo ),
    .KO  (ko  ),
    .DO  (dout),
    .VIOL(viol),
    .ENC_PS_CTRL(enc_ps_ctrl),
    .DEC_PS_CTRL(dec_ps_ctrl),
    .ENC_ISO    (enc_iso    ),
    .ENC_RET    (enc_ret    ),
    .DEC_ISO    (dec_iso    ),
    .DEC_RET    (dec_ret    )
  );

  initial
    forever
      #5 clk = ~clk;

  initial begin
    $supply_on("dut.EVDD", 1.8);
    $supply_on("dut.DVDD", 1.4);
    $supply_on("dut.VDD_AON", 3.3);
    $supply_on("dut.VSS", 0);

    #13 rstn = ~rstn;

    #10us;
    enc_ps_ctrl = 1'b0;
    dec_ps_ctrl = 1'b0;
    enc_iso = 1'b1;
    dec_iso = 1'b1;
    #10us;
    enc_ps_ctrl = 1'b1;
    dec_ps_ctrl = 1'b1;
    rstn = ~rstn;
    #20;
    rstn = ~rstn;
    #10us;

    @(posedge clk);
    dvi <= 1'b1;
    di <= 8'hAA;

    @(posedge clk);
    dvi <= 1'b0;
    di <= 8'h00;

    #10us;
    enc_ret = 1'b1;
    dec_ret = 1'b1;
    #100ns;
    enc_iso = 1'b0;
    dec_iso = 1'b0;
    #100ns;
    enc_ps_ctrl = 1'b0;
    dec_ps_ctrl = 1'b0;
    #10us;
    $supply_on("dut.EVDD", 3.7);
    #1us;
    enc_ps_ctrl = 1'b1;
    dec_ps_ctrl = 1'b1;
    #100ns;
    enc_ret = 1'b0;
    dec_ret = 1'b0;
    #100ns;
    enc_iso = 1'b1;
    dec_iso = 1'b1;
    $supply_on("dut.VDD_AON", 5.0);

    // $supply_off("dut.VDD");
    // $supply_off("dut.VSS");
    // #10us;
    // #10us;
    // $supply_off("dut.VSS");
    // $supply_off("dut.VDD");
  end

endmodule