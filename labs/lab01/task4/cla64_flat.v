// cla64_flat.v
//
// Flat 64-bit carry-lookahead adder.
//
// P[i] = A[i] ^ B[i]
// G[i] = A[i] & B[i]
//
// Each c[k] is calculated directly from all preceding P/G signals:
// Ck = G(k-1)
//    | P(k-1)G(k-2)
//    | P(k-1)P(k-2)G(k-3)
//    | ...
//    | P(k-1)...P0Cin
//
// Every assign has an explicit #(2) delay.

module cla64_flat(

  input  [63:0] a,
  input  [63:0] b,
  input         cin,
  output [63:0] sum,
  output        cout

);

  wire [63:0] p, g;

  // c[1] through c[64]
  // c[0] is represented by cin.
  wire [64:1] c;


  // ============================================================
  // STEP 1: PROPAGATE AND GENERATE
  // ============================================================

  genvar i;

  generate
    for (i = 0; i < 64; i = i + 1) begin : gen_pg

      xor #(2) (p[i], a[i], b[i]);
      and #(2) (g[i], a[i], b[i]);

    end
  endgenerate


  // ============================================================
  // DIRECT CLA CARRY FUNCTION
  //
  // For c[k], generate:
  //
  // g[k-1]
  // | p[k-1] & g[k-2]
  // | p[k-1] & p[k-2] & g[k-3]
  // | ...
  // | p[k-1] & ... & p[0] & cin
  //
  // This is NOT using c[k-1], so there is no carry ripple.
  // ============================================================

  function automatic carry_value;

    input integer k;

    integer j;
    reg p_product;
    reg result;

    begin

      result = g[k-1];

      p_product = 1'b1;

      for (j = k-2; j >= 0; j = j - 1) begin

        p_product = p_product & p[j];

        result = result | (p_product & g[j]);

      end

      p_product = 1'b1;

      for (j = k-1; j >= 0; j = j - 1) begin

        p_product = p_product & p[j];

      end

      result = result | (p_product & cin);

      carry_value = result;

    end

  endfunction


  // ============================================================
  // STEP 2: ALL 64 DIRECT CARRY EQUATIONS
  // ============================================================

  assign #(2) c[1]  = carry_value(1);
  assign #(2) c[2]  = carry_value(2);
  assign #(2) c[3]  = carry_value(3);
  assign #(2) c[4]  = carry_value(4);
  assign #(2) c[5]  = carry_value(5);
  assign #(2) c[6]  = carry_value(6);
  assign #(2) c[7]  = carry_value(7);
  assign #(2) c[8]  = carry_value(8);
  assign #(2) c[9]  = carry_value(9);
  assign #(2) c[10] = carry_value(10);
  assign #(2) c[11] = carry_value(11);
  assign #(2) c[12] = carry_value(12);
  assign #(2) c[13] = carry_value(13);
  assign #(2) c[14] = carry_value(14);
  assign #(2) c[15] = carry_value(15);
  assign #(2) c[16] = carry_value(16);
  assign #(2) c[17] = carry_value(17);
  assign #(2) c[18] = carry_value(18);
  assign #(2) c[19] = carry_value(19);
  assign #(2) c[20] = carry_value(20);
  assign #(2) c[21] = carry_value(21);
  assign #(2) c[22] = carry_value(22);
  assign #(2) c[23] = carry_value(23);
  assign #(2) c[24] = carry_value(24);
  assign #(2) c[25] = carry_value(25);
  assign #(2) c[26] = carry_value(26);
  assign #(2) c[27] = carry_value(27);
  assign #(2) c[28] = carry_value(28);
  assign #(2) c[29] = carry_value(29);
  assign #(2) c[30] = carry_value(30);
  assign #(2) c[31] = carry_value(31);
  assign #(2) c[32] = carry_value(32);
  assign #(2) c[33] = carry_value(33);
  assign #(2) c[34] = carry_value(34);
  assign #(2) c[35] = carry_value(35);
  assign #(2) c[36] = carry_value(36);
  assign #(2) c[37] = carry_value(37);
  assign #(2) c[38] = carry_value(38);
  assign #(2) c[39] = carry_value(39);
  assign #(2) c[40] = carry_value(40);
  assign #(2) c[41] = carry_value(41);
  assign #(2) c[42] = carry_value(42);
  assign #(2) c[43] = carry_value(43);
  assign #(2) c[44] = carry_value(44);
  assign #(2) c[45] = carry_value(45);
  assign #(2) c[46] = carry_value(46);
  assign #(2) c[47] = carry_value(47);
  assign #(2) c[48] = carry_value(48);
  assign #(2) c[49] = carry_value(49);
  assign #(2) c[50] = carry_value(50);
  assign #(2) c[51] = carry_value(51);
  assign #(2) c[52] = carry_value(52);
  assign #(2) c[53] = carry_value(53);
  assign #(2) c[54] = carry_value(54);
  assign #(2) c[55] = carry_value(55);
  assign #(2) c[56] = carry_value(56);
  assign #(2) c[57] = carry_value(57);
  assign #(2) c[58] = carry_value(58);
  assign #(2) c[59] = carry_value(59);
  assign #(2) c[60] = carry_value(60);
  assign #(2) c[61] = carry_value(61);
  assign #(2) c[62] = carry_value(62);
  assign #(2) c[63] = carry_value(63);
  assign #(2) c[64] = carry_value(64);


  // ============================================================
  // STEP 3: OUTPUT CARRY
  // ============================================================

  assign #(2) cout = c[64];


  // ============================================================
  // STEP 4: SUM
  //
  // sum[0] = p[0] ^ cin
  // sum[i] = p[i] ^ c[i]
  // ============================================================

  assign #(2) sum[0] = p[0] ^ cin;

  assign #(2) sum[1] = p[1] ^ c[1];
  assign #(2) sum[2] = p[2] ^ c[2];
  assign #(2) sum[3] = p[3] ^ c[3];
  assign #(2) sum[4] = p[4] ^ c[4];
  assign #(2) sum[5] = p[5] ^ c[5];
  assign #(2) sum[6] = p[6] ^ c[6];
  assign #(2) sum[7] = p[7] ^ c[7];
  assign #(2) sum[8] = p[8] ^ c[8];
  assign #(2) sum[9] = p[9] ^ c[9];
  assign #(2) sum[10] = p[10] ^ c[10];
  assign #(2) sum[11] = p[11] ^ c[11];
  assign #(2) sum[12] = p[12] ^ c[12];
  assign #(2) sum[13] = p[13] ^ c[13];
  assign #(2) sum[14] = p[14] ^ c[14];
  assign #(2) sum[15] = p[15] ^ c[15];
  assign #(2) sum[16] = p[16] ^ c[16];
  assign #(2) sum[17] = p[17] ^ c[17];
  assign #(2) sum[18] = p[18] ^ c[18];
  assign #(2) sum[19] = p[19] ^ c[19];
  assign #(2) sum[20] = p[20] ^ c[20];
  assign #(2) sum[21] = p[21] ^ c[21];
  assign #(2) sum[22] = p[22] ^ c[22];
  assign #(2) sum[23] = p[23] ^ c[23];
  assign #(2) sum[24] = p[24] ^ c[24];
  assign #(2) sum[25] = p[25] ^ c[25];
  assign #(2) sum[26] = p[26] ^ c[26];
  assign #(2) sum[27] = p[27] ^ c[27];
  assign #(2) sum[28] = p[28] ^ c[28];
  assign #(2) sum[29] = p[29] ^ c[29];
  assign #(2) sum[30] = p[30] ^ c[30];
  assign #(2) sum[31] = p[31] ^ c[31];
  assign #(2) sum[32] = p[32] ^ c[32];
  assign #(2) sum[33] = p[33] ^ c[33];
  assign #(2) sum[34] = p[34] ^ c[34];
  assign #(2) sum[35] = p[35] ^ c[35];
  assign #(2) sum[36] = p[36] ^ c[36];
  assign #(2) sum[37] = p[37] ^ c[37];
  assign #(2) sum[38] = p[38] ^ c[38];
  assign #(2) sum[39] = p[39] ^ c[39];
  assign #(2) sum[40] = p[40] ^ c[40];
  assign #(2) sum[41] = p[41] ^ c[41];
  assign #(2) sum[42] = p[42] ^ c[42];
  assign #(2) sum[43] = p[43] ^ c[43];
  assign #(2) sum[44] = p[44] ^ c[44];
  assign #(2) sum[45] = p[45] ^ c[45];
  assign #(2) sum[46] = p[46] ^ c[46];
  assign #(2) sum[47] = p[47] ^ c[47];
  assign #(2) sum[48] = p[48] ^ c[48];
  assign #(2) sum[49] = p[49] ^ c[49];
  assign #(2) sum[50] = p[50] ^ c[50];
  assign #(2) sum[51] = p[51] ^ c[51];
  assign #(2) sum[52] = p[52] ^ c[52];
  assign #(2) sum[53] = p[53] ^ c[53];
  assign #(2) sum[54] = p[54] ^ c[54];
  assign #(2) sum[55] = p[55] ^ c[55];
  assign #(2) sum[56] = p[56] ^ c[56];
  assign #(2) sum[57] = p[57] ^ c[57];
  assign #(2) sum[58] = p[58] ^ c[58];
  assign #(2) sum[59] = p[59] ^ c[59];
  assign #(2) sum[60] = p[60] ^ c[60];
  assign #(2) sum[61] = p[61] ^ c[61];
  assign #(2) sum[62] = p[62] ^ c[62];
  assign #(2) sum[63] = p[63] ^ c[63];

endmodule