module decoder_8b10b_wrapper (
  input              CLK ,
  input              RSTn,
`ifdef BEH_SIM
  input              PS_CTRL,
`endif
  input              DVI ,
  input        [9:0] DI  ,
  output logic       DVO ,
  output logic       K   ,
  output logic [7:0] DO  ,
  output logic       VIOL
);

  logic k, viol;
  logic [7:0] dout;

  always_ff @(posedge CLK) begin : out_flop_k_viol
    K    <= k;
    VIOL <= viol;
  end

  always_ff @(negedge RSTn, posedge CLK) begin : out_flop_dvo
    if (!RSTn)
      DVO <= 1'b0;
    else
      DVO <= DVI;
  end

  always_ff @(posedge CLK) begin : out_flop_do
    if (DVI)
      DO <= dout;
  end

  decoder_8b10b decoder_core (
    .CLK  (CLK ),
    .RSTn (RSTn),
    .DVI  (DVI ),
    .DI   (DI  ),
    .DVO  (    ),
    .K    (k   ),
    .DO   (dout),
    .VIOL (viol)
  );

endmodule