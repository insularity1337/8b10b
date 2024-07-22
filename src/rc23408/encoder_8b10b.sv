module encoder_8b10b (
  input              CLK ,
  input              RSTn,
  // input              RET,
  input              DVI ,
  input              K   ,
  input        [7:0] DI  ,
  output logic       DVO ,
  output logic [9:0] DO
);

  logic rd;

  logic s, de_5b6b, bal_5b6b;
  logic bal_3b4b;
  logic balby;

  logic [5:0] out_high;
  logic [3:0] out_low;

  encoder_5b6b enc_5b6b (
    .DF (rd      ),
    .K  (K       ),
    .DI (DI[4:0] ),
    .S  (s       ),
    .DE (de_5b6b ),
    .DO (out_high),
    .BAL(bal_5b6b)
  );

  encoder_3b4b enc_3b4b (
    .DF (de_5b6b ),
    .S  (s       ),
    .K  (K       ),
    .DI (DI[7:5] ),
    .DO (out_low ),
    .BAL(bal_3b4b)
  );

  always_comb begin : disp_end
    balby = bal_5b6b ~^ bal_3b4b;
  end

  always_ff @(negedge RSTn, posedge CLK)
    if (!RSTn)
      rd <= 1'b0;
    else if (DVI)
      rd <= balby ~^ rd;

  // always_ff @(negedge RSTn, posedge CLK)
  //   if (!RSTn)
  //     DVO <= 1'b0;
  //   else
  //     DVO <= DVI;

  always_comb
    DVO = 1'b0;

  // always_ff @(posedge CLK)
  //   if (DVI)
  //     DO <= {out_high, out_low};

  always_comb
    DO = {out_high, out_low};

endmodule