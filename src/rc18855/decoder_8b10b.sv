module decoder_8b10b (
  input              DF  ,
  input        [9:0] DI  ,
  output logic       K   ,
  output logic       DE  ,
  output logic [7:0] DO  ,
  output logic       VIOL
);

  logic a, b, c, d, e, i, f, g, h, j;

  logic p04, p40, p13, p31, p22;

  logic pdbr6, pdur6, ndbr6, ndur6, pdrr6, ndrr6, pder6, nder6;
  logic pdbr4, pdur4, ndrr4, ndbr4, ndur4, pdrr4, nder4;

  logic k28, kx7;
  logic invby, dvr6, invr6, dvr4;

  logic a_false, b_false, c_false, d_false, e_false, f_false, g_false, h_false;
  logic [13:0] false;



  always_comb begin : input_map
    {a, b, c, d, e, i, f, g, h, j} = DI;
  end

  always_comb begin : bit_coding
    p04 = ~a & ~b & ~c & ~d;
    p40 =  a &  b &  c &  d;

    p13 = ( a & ~b & ~c & ~d) |
          (~a &  b & ~c & ~d) |
          (~a & ~b &  c & ~d) |
          (~a & ~b & ~c &  d);

    p31 = (~a &  b &  c &  d) |
          ( a & ~b &  c &  d) |
          ( a &  b & ~c &  d) |
          ( a &  b &  c & ~d);

    p22 = (~a &  b &  c & ~d) |
          (~a & ~b &  c &  d) |
          ( a & ~b & ~c &  d) |
          ( a &  b & ~c & ~d) |
          ( a & ~b &  c & ~d) |
          (~a &  b & ~c &  d);
  end

  always_comb begin : disparity_r6
    pdbr6 = (p31 & (e | i)) |
            (p22 & e & i)   |
            p40;

    pdur6 = pdbr6       |
            (d & e & i);

    ndbr6 = (p13 & (~e | ~i)) |
            (p22 & ~e & ~i)   |
            p04;

    ndur6 = ndbr6          |
            (~d & ~e & ~i);

    pdrr6 = ndbr6          |
            (~a & ~b & ~c);

    ndrr6 = pdbr6 |
            (a & b & c);

    pder6 = (DF & ~ndur6) |
            pdur6;

    nder6 = (~DF & ~pdur6) |
            ndur6;

    dvr6 = ( DF & ndrr6) |
           (~DF & pdrr6);
  end

  always_comb begin : disparity_r4
    pdbr4 = (f & g & (h | j)) |
            ((f | g) & h & j);

    pdur4 = pdbr4   |
            (h & j);

    ndrr4 = pdbr4   |
            (f & g);

    ndbr4 = (~f & ~g & (~h | ~j)) |
            ((~f | ~g) & ~h & ~j);

    ndur4 = ndbr4     |
            (~h & ~j);

    pdrr4 = ndbr4 |
            (~f & ~g);

    DE = (pder6 & ~ndur4) |
         pdur4;

    nder4 = (nder6 & ~pdur4) |
            ndur4;

    dvr4 = ( DF & ~ndur6 & ndrr4) |
           (~DF & ~pdur6 & pdrr4);
  end

  always_comb begin : flags_n_viols
    invr6 = p40             |
            p04             |
            (p31 & e & i)   |
            (p13 & ~e & ~i);

    k28 = ( c &  d &  e &  i) |
          (~c & ~d & ~e & ~i);

    kx7 = (e ^ i) & ((i & g & h & j) | (~i & ~g & ~h & ~j));

    K = k28 | kx7;

    invby = invr6                                            |
            ((f & g & h & j) | (~f & ~g & ~h & ~j))          |
            ((e & i & f & g & h) | (~e & ~i & ~f & ~g & ~h)) |
            (~k28 & ((~i & g & h & j) | (i & ~g & ~h & ~j))) |
            (k28 & ((f & g & h) | (~f & ~g & ~h)))           |
            (kx7 & ~pdbr6 & ~ndbr6)                          |
            (pdur6 & ndrr4)                                  |
            (ndur6 & pdrr4);

    VIOL = invby | dvr6 | dvr4;
  end

  always_comb begin : false_table
    false[0] = p22 & b & c & (e ~^ i);

    false[1] = p22 & ~b & ~c & (e ~^ i);

    false[2] = p13 & ~i;

    false[3] = p31 & i;

    false[4] = p22 & a & c & (e ~^ i);

    false[5] = p22 & ~a & ~c & (e ~^ i);

    false[6] = ~a & ~b  & ~e & ~i;

    false[7] = a & b & e & i;

    false[8] = p13 & (d & i | ~e) |
               (~c & ~d & ~e & ~i);

    false[9] = ~f & ~h & ~j;

    false[10] = f & h & j;

    false[11] = g & h & j;

    false[12] = ~g & ~h & ~j;

    false[13] = (~f & ~g & h & j) |
                (f & g & j) |
                (~f & ~g & ~h) |
                (k28 & ~i & (h ^ j));
  end

  // always_comb begin : false_flag
  //   a_false = false[1] | false[3] | false[5] | false[7] | false[8];
  //   b_false = false[0] | false[3] | false[4] | false[7] | false[8];
  //   c_false = false[0] | false[3] | false[5] | false[6] | false[8];
  //   d_false = false[1] | false[3] | false[4] | false[7] | false[8];
  //   e_false = false[1] | false[2] | false[5] | false[6] | false[8];

  //   f_false = false[10] | false[11] | false[13];
  //   g_false = false[ 9] | false[12] | false[13];
  //   h_false = false[10] | false[12] | false[13];
  // end

  assign a_false = false[1] | false[3] | false[5] | false[7] | false[8];
  assign b_false = false[0] | false[3] | false[4] | false[7] | false[8];
  assign c_false = false[0] | false[3] | false[5] | false[6] | false[8];
  assign d_false = false[1] | false[3] | false[4] | false[7] | false[8];
  assign e_false = false[1] | false[2] | false[5] | false[6] | false[8];

  assign f_false = false[10] | false[11] | false[13];
  assign g_false = false[ 9] | false[12] | false[13];
  assign h_false = false[10] | false[12] | false[13];

  always_comb begin : output_map
    DO = {
      h ^ h_false,
      g ^ g_false,
      f ^ f_false,
      e ^ e_false,
      d ^ d_false,
      c ^ c_false,
      b ^ b_false,
      a ^ a_false
    };
  end

endmodule