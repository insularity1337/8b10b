module encoder_8b10b (
  input        RD   ,
  input        K    ,
  input  [7:0] D_IN ,
  output [9:0] D_OUT
);

  logic s, dfs4, dfs6;

  encoder_5b6b enc_5b6b (
    .DFS6 (RD        ),
    .K    (K         ),
    .D_IN (D_IN[4:0] ),
    .S    (s         ),
    .DFS4 (dfs4      ),
    .D_OUT(D_OUT[9:4])
  );

  encoder_3b4b enc_3b4b (
    .DFS4 (dfs4      ),
    .K    (K         ),
    .S    (s         ),
    .D_IN (D_IN[7:5] ),
    .DFS6 (dfs6      ),
    .D_OUT(D_OUT[3:0])
  );

endmodule