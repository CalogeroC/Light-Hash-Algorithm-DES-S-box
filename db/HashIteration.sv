/* Taken as input a byte M, the HashIteration module performs Round operation over the vector h four times and returns the new vector h_out */
module HashIteration (
    input [7 : 0] M,
    input [7 : 0] [3 : 0] h,
    output [7 : 0] [3 : 0] h_out
);

/* The register sbox_out is used to store the output of the SBox */
reg [3 : 0] sbox_out;

/* Wire used to store the value of M6 */
wire [5 : 0] M6;

/* M6 vector used to access the SBox */
assign M6 = {M[5], M[7]^M[2], M[3], M[0], M[4]^M[1], M[6]};

/* Instantiation of the SBox module */
SBox sbox(
    .in (M6),
    .out (sbox_out)
);

/* Auxiliaries wires used to store results of intermediate rounds */
wire [7 : 0] [3 : 0] r1_out;
wire [7 : 0] [3 : 0] r2_out;
wire [7 : 0] [3 : 0] r3_out;


//Instantiation of the four Round which must be executed
Round round1 (
    .sbox_out(sbox_out),
    .h_in(h),
    .h_out(r1_out)
);

Round round2 (
    .sbox_out(sbox_out),
    .h_in(r1_out),
    .h_out(r2_out)
);

Round round3 (
    .sbox_out(sbox_out),
    .h_in(r2_out),
    .h_out(r3_out)
);

Round round4 (
    .sbox_out(sbox_out),
    .h_in(r3_out),
    .h_out(h_out)
);

endmodule