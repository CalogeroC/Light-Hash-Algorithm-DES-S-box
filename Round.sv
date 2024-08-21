/* The Round module computes a round on the vector h such that h_out[i] = (h_in[i+2] ^ sbox_out) << floor(i/2) */
module Round (
    input [3 : 0] sbox_out, 
    input [7 : 0] [3 : 0] h_in, 
    output reg [7 : 0] [3 : 0]  h_out 
);

/* xor_res is a register used to store the result of the xor before the circular shift */
reg [3 : 0] xor_res; 

    always @(*) begin        
        xor_res = h_in[2] ^ sbox_out;
        h_out[0] = xor_res;

        xor_res = h_in[3] ^ sbox_out;
        h_out[1] = xor_res;

        xor_res = h_in[4] ^ sbox_out;
        h_out[2] = (xor_res << 1) | (xor_res >> 3);

        xor_res = h_in[5] ^ sbox_out;
        h_out[3] = (xor_res << 1) | (xor_res >> 3);
       
        xor_res = h_in[6] ^ sbox_out;
        h_out[4] = (xor_res << 2) | (xor_res >> 2);
      

        xor_res = h_in[7] ^ sbox_out;
        h_out[5] = (xor_res << 2) | (xor_res >> 2);
        

        xor_res = h_in[0] ^ sbox_out;
        h_out[6] = (xor_res << 3) | (xor_res >> 1);

        xor_res = h_in[1] ^ sbox_out;
        h_out[7] = (xor_res << 3) | (xor_res >> 1);
    end
    
endmodule
