module encoder_8b10b (
  input              DF,
  input              K ,
  input        [7:0] DI,
  output logic       DE,
  output logic [9:0] DO
);

  logic s, de_5b6b, bal_5b6b;
  logic bal_3b4b;
  logic balby;

  encoder_5b6b enc_5b6b (
    .DF (DF      ),
    .K  (K       ),
    .DI (DI[4:0] ),
    .S  (s       ),
    .DE (de_5b6b ),
    .DO (DO[9:4] ),
    .BAL(bal_5b6b)
  );

  encoder_3b4b enc_3b4b (
    .DF (de_5b6b ),
    .S  (s       ),
    .K  (K       ),
    .DI (DI[7:5] ),
    // .DE (de_3b4b ),
    .DO (DO[3:0] ),
    .BAL(bal_3b4b)
  );

  always_comb begin : disp_end
    balby = bal_5b6b ~^ bal_3b4b;

    DE = balby ~^ DF;
  end

endmodule