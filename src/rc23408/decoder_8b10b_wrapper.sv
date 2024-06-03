module decoder_8b10b_wrapper (
  input        CLK  ,
  input        ARSTN,
  input  [9:0] DI   ,
  output       K    ,
  output       VIOL ,
  output [7:0] DO
);

  logic de, rd;

  decoder_8b10b decoder (
    .DF  (rd  ),
    .DI  (DI  ),
    .K   (K   ),
    .DE  (de  ),
    .DO  (DO  ),
    .VIOL(VIOL)
  );

  always_ff @(negedge ARSTN, posedge CLK) begin : running_disparity
    if (!ARSTN)
      rd <= 1'b0;
    else
      rd <= de;
  end

endmodule