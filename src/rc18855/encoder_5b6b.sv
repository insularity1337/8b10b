module encoder_5b6b (
  input              DFS6 ,
  input              K    ,
  input        [4:0] D_IN ,
  output logic       S    ,
  output logic       DFS4 ,
  output logic [5:0] D_OUT
);

  logic A, B, C, D, E;
  logic L04, L40, L13, L31, L22;
  logic a, b, c, d, e, i;
  logic NDBS6, PDBS6, BALS6;
  logic NDRS6, PDRS6, CMPLS6;



  always_comb begin : input_map
    {E, D, C, B, A} = D_IN;
  end

  always_comb begin : bit_coding
    L04 = ~A & ~B & ~C & ~D;
    L40 =  A &  B &  C &  D;

    L13 = ( A & ~B & ~C & ~D) |
          (~A &  B & ~C & ~D) |
          (~A & ~B &  C & ~D) |
          (~A & ~B & ~C &  D);

    L31 = (~A &  B &  C &  D) |
          ( A & ~B &  C &  D) |
          ( A &  B & ~C &  D) |
          ( A &  B &  C & ~D);

    L22 = (~A &  B &  C & ~D) |
          (~A & ~B &  C &  D) |
          ( A & ~B & ~C &  D) |
          ( A &  B & ~C & ~D) |
          ( A & ~B &  C & ~D) |
          (~A &  B & ~C &  D);
  end

  always_comb begin : primary_vectors
    a = A;

    b = (B & ~L40) |
        L04;

    c = C |
        L04 |
        (L13 & D & E);

    d = D & ~L40;

    e = (E & ~(L13 & D & E)) |
        (L13 & ~E);

    i = (L22 & (~E | K)) |
        (E & (L04 | L40 | (L13 & ~D)));
  end

  always_comb begin : disparity
    NDBS6 = (~L22 & ~L31 & ~E) |
            (L13 & D & E);

    PDBS6 = (~L22 & ~L13 & E) |
            K;

    BALS6 = ~NDBS6 & ~PDBS6;

    PDRS6 = NDBS6;

    NDRS6 = PDBS6 |
            (L31 & ~D & ~E);

    CMPLS6 = (~DFS6 & PDRS6) |
             ( DFS6 & NDRS6);

    DFS4 = ( DFS6 &  BALS6) |
           (~DFS6 & ~BALS6);
  end

  always_comb begin : s4
    S = (L31 &  D & ~E &  DFS6) |
        (L13 & ~D &  E & ~DFS6);
  end

  always_comb begin : output_map
    D_OUT = /*{i, e, d, c, b, a}*/ {a, b, c, d, e, i} ^ {6{CMPLS6}};
  end

endmodule