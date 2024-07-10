module pa_env (
  input              CLK ,
  input              RSTn,
  input              PS_CTRL,
  input              DVI ,
  input              KI  ,
  input        [7:0] DI  ,
  output logic       DVO ,
  output logic       KO  ,
  output logic [7:0] DO  ,
  output logic       VIOL
);

  logic       dv_in   ;
  logic       k_in    ;
  logic [7:0] r_in    ;

  logic       enc_dvo;
  logic [9:0] enc_do ;

  logic       dv_int  ;
  logic [9:0] r_int   ;

  logic       dv_out  ;
  logic       k_out   ;
  logic       viol_out;
  logic [7:0] r_out   ;



  always_ff @(negedge RSTn, posedge CLK)
    if (!RSTn)
      dv_in <= 1'b0;
    else
      dv_in <= DVI;

  always_ff @(posedge CLK) begin
    k_in <= KI;
    r_in <= DI;
  end

  encoder_8b10b enc (
    .CLK (CLK    ),
    .RSTn(RSTn   ),
    .DVI (dv_in  ),
    .K   (k_in   ),
    .DI  (r_in   ),
    .DVO (enc_dvo),
    .DO  (enc_do )
  );

  always_ff @(negedge RSTn, posedge CLK)
    if (!RSTn)
      dv_int <= 1'b0;
    else
      dv_int <= enc_dvo;

  always_ff @(posedge CLK)
    r_int <= enc_do;

  decoder_8b10b dec (
    .CLK (CLK     ),
    .RSTn(RSTn    ),
    .DVI (dv_int  ),
    .DI  (r_int   ),
    .DVO (dv_out  ),
    .K   (k_out   ),
    .DO  (r_out   ),
    .VIOL(viol_out)
  );

  always_ff @(negedge RSTn, posedge CLK)
    if (!RSTn)
      DVO <= 1'b0;
    else
      DVO <= dv_out;

  always_ff @(posedge CLK) begin
    KO   <= k_out;
    VIOL <= viol_out;
    DO   <= r_out;
  end

endmodule