module encoder_3b4b (
  input              DFS4 ,
  input              K    ,
  input              S    ,
  input        [2:0] D_IN ,
  output logic       DFS6 ,
  output logic [3:0] D_OUT
);

  logic F, G, H;
  logic f, g, h, j;
  logic NDBS4, PDBS4, BALS4;
  logic NDRS4, PDRS4, CMPLS4;


  always_comb begin : input_map
    {H, G, F} = D_IN;
  end

  always_comb begin : primary_vectors
    f = F & ~(F & G & H & (S | K));

    g = G |
        (~F & ~G & ~H);

    h = H;

    j = ((F ^ G) & ~H) |
        (F & G & H & (S | K));
  end

  always_comb begin : disparity
    NDBS4 = ~F & ~G;

    PDBS4 = F & G & H;

    BALS4 = ~NDBS4 & ~PDBS4;

    PDRS4 = NDBS4 |
            ((F ^ G) & K);

    NDRS4 = F & G;

    CMPLS4 = (~DFS4 & PDRS4) |
             ( DFS4 & NDRS4);

    DFS6 = ( DFS4 &  BALS4) |
           (~DFS4 & ~BALS4);
  end

  always_comb begin : output_map
    D_OUT = /*{j, h, g, f}*/ {f, g, h, j} ^ {4{CMPLS4}};
  end

endmodule