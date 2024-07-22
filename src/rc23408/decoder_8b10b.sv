module decoder_8b10b (
  input              CLK ,
  input              RSTn,
  // input              RET ,
  input              DVI ,
  input        [9:0] DI  ,
  output logic       DVO ,
  output logic       K   ,
  output logic [7:0] DO  ,
  output logic       VIOL
);

  logic a, b, c, d, e, i, f, g, h, j;

  logic p40, p04, p3x, px3, p22;
  logic p2x, px2;

  logic pdrr6, ndrr6, pdur6, ndur6;
  logic pdrr4, ndrr4, pdur4, ndur4;

  logic k28, kx7;

  logic vkx7;

  logic invr6, invr4;

  logic dvby;

  logic pduby, nduby;

  logic invby;

  logic dv64;

  logic [13:0] false;

  logic a_false, b_false, c_false, d_false, e_false, f_false, g_false, h_false, k_false;

  logic rd;



  always_comb begin : input_map
    {a, b, c, d, e, i, f, g, h, j} = DI;
  end

  always_comb begin : bit_coding
    p40 = a & b & c & d;

    p04 = ~a & ~b & ~c & ~d;

    p3x = (a & b & c    ) |
          (a & b     & d) |
          (a     & c & d) |
          (    b & c & d);

    px3 = (~a & ~b & ~c     ) |
          (~a & ~b      & ~d) |
          (~a      & ~c & ~d) |
          (     ~b & ~c & ~d);

    p2x = (a & b) |
          (a & c) |
          (b & c);

    px2 = (~a & ~b) |
          (~a & ~c) |
          (~b & ~c);

    p22 = ~p3x & ~px3;
  end

  always_comb begin : disparity_r6
    pdrr6 = (px3 & (~e | ~i))                       |
            (~a & ~b & ~c)                          |
            (~e & ~i & (px2 | (~d & ~(a & b & c))));

    ndrr6 = (p3x & (e | i))                         |
            (a & b & c)                             |
            (e & i & (p2x | (d & ~(~a & ~b & ~c))));

    pdur6 = (p3x & (e | i))     |
            (e & i & (d | p2x));

    ndur6 = (px3 & (~e | ~i))      |
            (~e & ~i & (~d | px2));
  end

  always_comb begin : disparity_r4
    pdrr4 = (~f & ~g)           |
            ((f ^ g) & ~h & ~j);

    ndrr4 = (f & g)           |
            ((f ^ g) & h & j);

    pdur4 = (h & j)           |
            (f & g & (h ^ j));

    ndur4 = (~h & ~j)           |
            (~f & ~g & (h ^ j));
  end

  always_comb begin : flags_n_viols
    k28 = ( c &  d &  e &  i) |
          (~c & ~d & ~e & ~i);

    kx7 = (e ^ i) & ((i & g & h & j) | (~i & ~g & ~h & ~j));

    vkx7 = kx7 & p22;

    invr6 = p40             |
            p04             |
            (p3x &  e &  i) |
            (px3 & ~e & ~i);

    invr4 = ((f & g & h & j) | (~f & ~g & ~h & ~j))          |
            ((e & i & f & g & h) | (~e & ~i & ~f & ~g & ~h)) |
            (k28 & ((f & g & h) | (~f & ~g & ~h)))           |
            (~k28 & ((~i & g & h & j) | (i & ~g & ~h & ~j)));

    dv64 = (pdur6 & ndrr4) |
           (ndur6 & pdrr4);

    invby = invr6 | invr4 | vkx7 | dv64;

    dvby = (~rd & (pdrr6 | (pdrr4 & ~ndrr6))) |
           ( rd & (ndrr6 | (ndrr4 & ~pdrr6)));

    pduby = pdur4            |
            (pdur6 & ~ndur4);

    nduby = ndur4            |
            (ndur6 & ~pdur4);
  end

  // always_ff @(posedge CLK) begin : out_flop_k_viol
  //   K    <= k28  | kx7;
  //   VIOL <= dvby | invby;
  // end

  always_comb begin
    K    = k28  | kx7;
    VIOL = dvby | invby;
  end

  always_ff @(negedge RSTn, posedge CLK)
    if (!RSTn)
      rd <= 1'b0;
    else if (DVI)
      rd <= pduby | (rd & ~nduby);

  always_comb begin : false_table
    false[0] = ~a & b & c & ~d & (e ~^ i);

    false[1] = a & ~b & ~c & d & (e ~^ i);

    false[2] = px3 & ~i;

    false[3] = p3x & i;

    false[4] = a & ~b & c & ~d & (e ~^ i);

    false[5] = ~a & b & ~c & d & (e ~^ i);

    false[6] = ~a & ~b & ~e & ~i;

    false[7] = a & b & e & i;

    false[8] = (px3 & (d & i | ~e)) |
               (~c & ~d & ~e & ~i);

    false[9] = (f ^ g) & h & j;

    false[10] = (f ^ g) & ~h & ~j;

    false[11] = f & ~g & (h ~^ j);

    false[12] = ((f ~^ g) & j) |
                (~c & ~d & ~e & ~i & (h ^ j));

    false[13] = k28 | kx7;
  end

  // always_comb begin false_flag
  //   a_false = false[1] | false[3] | false[5] | false[7] | false[8];
  //   b_false = false[0] | false[3] | false[4] | false[7] | false[8];
  //   c_false = false[0] | false[3] | false[5] | false[6] | false[8];
  //   d_false = false[1] | false[3] | false[4] | false[7] | false[8];
  //   e_false = false[1] | false[2] | false[5] | false[6] | false[8];

  //   f_false = false[ 9] | false[12];
  //   g_false = false[10] | false[12];
  //   h_false = false[11] | false[12];

  //   k_false = false[13];
  // end

  assign a_false = false[1] | false[3] | false[5] | false[7] | false[8];
  assign b_false = false[0] | false[3] | false[4] | false[7] | false[8];
  assign c_false = false[0] | false[3] | false[5] | false[6] | false[8];
  assign d_false = false[1] | false[3] | false[4] | false[7] | false[8];
  assign e_false = false[1] | false[2] | false[5] | false[6] | false[8];

  assign f_false = false[ 9] | false[12];
  assign g_false = false[10] | false[12];
  assign h_false = false[11] | false[12];

  assign k_false = false[13];

  // always_ff @(negedge RSTn, posedge CLK) begin : out_flop_dvo
  //   if (!RSTn)
  //     DVO <= 1'b0;
  //   else
  //     DVO <= DVI;
  // end

  always_comb
    DVO = 1'b0;

  // always_ff @(posedge CLK) begin : out_flop_do
  //   DO <= {
  //     h ^ h_false,
  //     g ^ g_false,
  //     f ^ f_false,
  //     e ^ e_false,
  //     d ^ d_false,
  //     c ^ c_false,
  //     b ^ b_false,
  //     a ^ a_false
  //   };
  // end

  always_comb begin
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