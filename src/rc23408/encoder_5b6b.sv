module encoder_5b6b (
  input              DF ,
  input              K  ,
  input        [4:0] DI ,
  output logic       S  ,
  output logic       DE ,
  output logic [5:0] DO ,
  output logic       BAL
);

  logic A, B, C, D, E;
  logic a, b, c, d, e, i;

  logic l03, l30, l12, l21;

  logic pdr, ndr, bal, cmpl;



  always_comb begin : input_map
    {E, D, C, B, A} = DI;
  end

  always_comb begin : bit_coding
    l03 = ~A & ~B & ~C;
    l30 =  A &  B &  C;

    l12 = ( A & ~B & ~C) |
          (~A &  B & ~C) |
          (~A & ~B &  C);

    l21 = (~A &  B &  C) |
          ( A & ~B &  C) |
          ( A &  B & ~C);
  end

  always_comb begin : primary_vectors
    a = A;

    b = (B & ~(l30 & D)) |
        (l03 & ~D);

    c = C                |
        (l03 & (~D | E));

    d = D & ~(l30 & D);

    e = (E & ~(l03 & D)) |
        (l12 & ~D & ~E)  |
        (l03 & D & ~E);

    i = (l21 & ~D & ~E)       |
        (l12 & ((D ^ E) | K)) |
        (l03 & ~D & E)        |
        (l30 & D & E);
  end

  always_comb begin : disparity
    pdr = (l03 & (D | ~E)) |
          (l30 & D & ~E)   |
          (l12 & ~D & ~E);

    ndr = (l30 & (~D | E)) |
          (l03 & ~D & E)   |
          (l21 & D & E)    |
          K;

    cmpl = (~DF & pdr) |
           ( DF & ndr);

    BAL = (l21 & (~D | ~E))    |
          (l12 & ~K & (D | E)) |
          (l30 & ~D & ~E);

    DE = BAL ~^ DF;
  end

  always_comb begin : s_calc
    S = (l21 &  D & ~E &  DF) |
        (l12 & ~D &  E & ~DF);
  end

  always_comb begin : output_map
    DO = {a, b, c, d, e, i} ^ {6{cmpl}};
  end

endmodule