module encoder_3b4b (
  input              DF ,
  input              S  ,
  input              K  ,
  input        [2:0] DI ,
  // output logic       DE ,
  output logic [3:0] DO ,
  output logic       BAL
);

  logic F, G, H;
  logic f, g, h, j;

  logic pdr, ndr, cmpl;



  always_comb begin : input_map
    {H, G, F} = DI;
  end

  always_comb begin : primary_vectors
    f = F & ~(F & G & H & (S | K));

    g = G         |
        (~F & ~H);

    h = H;

    j = ((F ^ G) & ~H)        |
        (F & G & H & (S | K));
  end

  always_comb begin : disparity
    pdr = (~F & ~G)     |
          ((F ^ G) & K);

    ndr = F & G;

    BAL = (F ^ G)      |
          (F & G & ~H);

    cmpl = (~DF & pdr) |
           ( DF & ndr);
  end

  always_comb begin : output_map
    DO = {f, g, h, j} ^ {4{cmpl}};
  end

endmodule