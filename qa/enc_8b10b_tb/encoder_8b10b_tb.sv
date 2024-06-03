// `timescale 1ns/1ns

module encoder_8b10b_tb ();

  // import enc_8b10b_pkg::*;
  import pkg_8b10b::enc_table;

  logic       disp_front;
  int         disp_end  ;
  logic       k         ;
  logic [7:0] d_in      ;
  logic [9:0] d_out     ;
  logic       de        ;

  // encoder_8b10b dut (
  //   .RD   (disp_front),
  //   .K    (k         ),
  //   .D_IN (d_in      ),
  //   .D_OUT(d_out     )
  // );

  encoder_8b10b dut (
    .DF(disp_front),
    .K (k         ),
    .DI(d_in      ),
    .DE(de        ),
    .DO(d_out     )
  );

  int rdf,rde;
  int wrong;

  initial begin
    #10;

    for (int i = 0; i < 1024; i++) begin
      rdf = signed'(enc_table[i][21:20]);
      rde = signed'(enc_table[i][ 1: 0]);
      wrong = enc_table[i][23];

      if (rdf == -1)
        disp_front = 1'b0;
      else
        disp_front = 1'b1;

      k = enc_table[i][22];
      d_in = enc_table[i][19:12];

      #1;

      if ((d_out !== enc_table[i][11:2]) && !wrong) begin
        $error("WRONG ENCODING");
        $display("\nindex+5: %d\n", i+5);
        $finish;
      end

      if (de/*dut.dfs6*/ == 1'b1)
        disp_end = 1;
      else
        disp_end = -1;

      if ((disp_end !== rde) && !wrong) begin
        $error("WRONG DISPARITY");
        $display("Table disparity: %2d\tcoder disparity: %2d", rde, disp_end);
        $finish;
      end
    end
  end

  initial begin
    $dumpfile("enc.vcd");
    $dumpvars(0, dut);
  end

endmodule