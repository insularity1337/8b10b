module encoder_8b10b_wrapper (
  input              CLK ,
  input              RSTn,
`ifdef BEH_SIM
  input              PS_CTRL,
`endif
  input              DVI ,
  input              K   ,
  input        [7:0] DI  ,
  output logic       DVO ,
  output logic [9:0] DO
);

  logic [9:0] dout;

  encoder_8b10b encoder_core (
    .CLK  (CLK ),
    .RSTn (RSTn),
    .DVI  (DVI ),
    .K    (K   ),
    .DI   (DI  ),
    .DVO  (    ),
    .DO   (dout)
  );

  always_ff @(negedge RSTn, posedge CLK)
    if (!RSTn)
      DVO <= 1'b0;
    else
      DVO <= DVI;

  always_ff @(posedge CLK)
    if (DVI)
      DO <= dout;

endmodule