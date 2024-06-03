module encoder_8b10b_wrapper (
  input        CLK  ,
  input        ARSTN,
  input        K    ,
  input  [7:0] DI   ,
  output [9:0] DO
);

  logic de, rd;

  encoder_8b10b encoder (
    .DF(rd),
    .K (K ),
    .DI(DI),
    .DE(de),
    .DO(DO)
  );

  always_ff @(negedge ARSTN, posedge CLK) begin : running_disparity
    if (!ARSTN)
      rd <= 1'b0;
    else
      rd <= de;
  end

endmodule