`timescale 10ns/1ns
// `define INDICATE_TABLE_DIFF

module decoder_10b8b_tb ();

  import dec_10b8b_pkg::*;
  import enc_8b10b_pkg::*;
  import pkg_8b10b::enc_table;
  import pkg_8b10b::enc_byte_name;
  import pkg_8b10b::dec_table;
  import pkg_8b10b::dec_byte_name;

  logic       disp_front  ;
  logic [9:0] d_in        ;
  logic       k           ;
  logic       disp_end    ;
  logic [7:0] d_out       ;
  logic       viol;

  decoder_8b10b dut (
    .DF  (disp_front),
    .DI  (d_in      ),
    .K   (k         ),
    .DE  (disp_end  ),
    .DO  (d_out     ),
    .VIOL(viol      )
  );

  // function automatic int calc_disparity(logic [9:0] foo);
  //   int z = 0;
  //   int o = 0;

  //   for (int i = 0; i < 10; i++)
  //     if (foo[i])
  //       o++;
  //     else
  //       z++;

  //     if (z > o)
  //       return -1;
  //     else if (o > z)
  //       return 1;
  //     else
  //       return 0;
  // endfunction

  // int j;
  // int rdf;
  int rde;
  // int db;

  initial begin
    #10;

    for (int i = 0; i < 2048; i++) begin
      d_in = dec_table[i][11:2];
      rde = signed'(dec_table[i][1:0]);

      if (signed'(dec_table[i][21:20]) == -1)
        disp_front = 1'b0;
      else
        disp_front = 1'b1;

      #1;

      if (dut.VIOL) begin
        if (dut.invby) begin : not_in_table
          // Comparison /w table data
          if (!dec_table[i][23]) begin
            $error("[NOT IN TABLE] Missing WRONG flag in decoder table! Index: %4d. Time: %t", i, $time());
            $finish;
          end

          `ifdef INDICATE_TABLE_DIFF
            // Diff between tables
            if (dec_table[i][23] !== dec_symb[i][10])
              $display("Difference between WRONG & code_err flags! Index: %4d. WRONG: %1b, code_err: %1b", i, dec_table[i][23], dec_symb[i][10]);
          `endif
        end else if (dut.dvby/*dut.dvr6 || dut.dvr4*/) begin : disparity_violation
          if (!dec_table[i][24]) begin
            $error("[DISPARITY] Difference between DUT violation indicator and table DV! Index: %4d. Time: %t", i, $time());
            $finish;
          end

          `ifdef INDICATE_TABLE_DIFF
            // Diff between tables
            if (dec_table[i][24] !== dec_symb[i][11])
              $display("Difference between DV & disp_err flags! Index: %4d. DV: %1b, disp_err: %1b", i, dec_table[i][24], dec_symb[i][11]);
          `endif
        end
      end else begin
        // CHECK WRONG DISPARITY AT END
        if (((rde == -1) && disp_end) || ((rde == 1) && !disp_end)) begin
          $error("[WRONG END DISPARITY] Difference between DUT and table ending disparity! Index: %4d. Time: %t", i, $time());
          $finish;
        end

        `ifdef INDICATE_TABLE_DIFF
          // Diff between tables
          if (((dec_table[i][1:0] == 2'b01) && !dec_symb[i][8]) || ((dec_table[i][1:0] == 2'b11) && dec_symb[i][8]))
            $display("Difference between ending disparities in tables! Index: %4d. RDE: %2d, disp_end: %1b", i, signed'(dec_table[i][1:0]), dec_symb[i][8]);
        `endif

        if (dec_table[i][24] || dec_table[i][23]) begin
          $error("[VIOLATION INDICATION] Missing not in table or violation indication! Index: %4d. Time: %t", i, $time());
          $finish;
        end

        `ifdef INDICATE_TABLE_DIFF
          // Diff between tables
          if ((dec_table[i][24] !== dec_symb[i][11]) || (dec_table[i][23] !== dec_symb[i][10]))
            $display("Difference between wrong symbol and disparity error indiation! Index: %4d. DV: %1b, WRONG: %1b, disp_err: %1b, code_err: %1b", i, dec_table[i][24], dec_table[i][23], dec_symb[i][11], dec_symb[i][10]);
        `endif

        if (k !== dec_table[i][22]) begin
          $error("[CONTROL SYMBOL INDICATION] Missing indication of control symbol! Index: %4d. Time: %t", i, $time());
          $finish;
        end

        `ifdef INDICATE_TABLE_DIFF
          // Diff between tables
          if (dec_table[i][22] !== dec_symb[i][9])
            $display("Difference between K & ctrl_symb! Index: %4d. K: %1b, ctrl_symb: %1b", i, dec_table[i][22], dec_symb[i][9]);
        `endif
      end
    end

    // for (int i = 0; i < 1024; i++) begin
    //   dec_table[i][23] = 1'b1;
    //   dec_table[i][21:20] = 2'b11;
    //   dec_table[i][11:2] = i;
    //   dec_byte_name[i] = "?";

    //   dec_table[1024 + i][23] = 1'b1;
    //   dec_table[1024 + i][21:20] = 2'b01;
    //   dec_table[1024 + i][11:2] = i;
    //   dec_byte_name[1024 + i] = "?";
    // end

    // for (int i = 0; i < 1024; i++) begin
    //   j = unsigned'(enc_table[i][11:2]);
    //   rdf = signed'(enc_table[i][21:20]);
    //   db = calc_disparity(enc_table[i][11:2]);

    //   if (!enc_table[i][23]) begin
    //     if (rdf == -1) begin
    //       dec_table[j] = {1'b0, enc_table[i]};
    //       dec_byte_name[j] = enc_byte_name[i];

    //       if (db != 0) begin
    //         dec_table[1024 + j] = {1'b1, enc_table[i][23:22], 2'b01, enc_table[i][19:0]};
    //         dec_byte_name[1024 + j] = {enc_byte_name[i], " ", "WRONG RDF"};
    //       end
    //     end else begin
    //       dec_table[1024 + j] = {1'b0, enc_table[i]};
    //       dec_byte_name[1024 + j] = enc_byte_name[i];

    //       if (db != 0) begin
    //         dec_table[j] = {1'b1, enc_table[i][23:22], 2'b11, enc_table[i][19:0]};
    //         dec_byte_name[j] = {enc_byte_name[i], " ", "WRONG RDF"};
    //       end
    //     end
    //   end
    // end

    // for (int i = 0; i < 2048; i++)
    //   $display(
    //     "{1'b%1b, 1'b%1b, 1'b%1b, 2'b%2b, 8'b%8b, 10'b%10b, 2'b%b}, // %s",
    //     dec_table[i][24],
    //     dec_table[i][23],
    //     dec_table[i][22],
    //     dec_table[i][21:20],
    //     dec_table[i][19:12],
    //     dec_table[i][11:2],
    //     dec_table[i][1:0],
    //     dec_byte_name[i]
    //   );


  end

  initial begin
    $dumpfile("dec.vcd");
    $dumpvars(0, dut);
  end

endmodule