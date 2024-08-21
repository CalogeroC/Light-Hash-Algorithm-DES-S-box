 /* 
    This module performs a light hash function based on DES s-box, it takes a string as input and returns the 32-bit digest of the given string.
    The module processes a single byte of the input string in 1 clock cycle.

    It takes in input:
        (-) clk signal
        (-) M_valid: is set if the input byte is valid and stable
        (-) reset: if unset perform an async reset 
        (-) M: bytes of the string to be processed
        (-) input_lengh: lenght of the string that has to be processed

    The modules has the following output:
        (-) hash_ready: set if the digest is valid and stable
        (-) digest_out: contains the computed digest 
 */


module lightHashDES(
    input clk, 
    input reset,
    input M_valid,
    input [7 : 0] M,
    input [63 : 0] input_lenght,
    output reg hash_ready, 
    output reg [31 : 0] digest
);

/* Initial values (IV) of the digest */
localparam Iv_H0 = 4'hF;
localparam Iv_H1 = 4'h3;
localparam Iv_H2 = 4'hC;
localparam Iv_H3 = 4'h2;
localparam Iv_H4 = 4'h9;
localparam Iv_H5 = 4'hD;
localparam Iv_H6 = 4'h4;
localparam Iv_H7 = 4'hB;    

/* busy is a binary variable that is set when a computation of a digest is performed. Otherwise, is unset when the module is not computing a digest.*/
reg busy;

/* Register used to keep trace of the remaining bytes to process. After each byte computation the counter variable is decreased by one. */
reg [63:0] counter;

/* The temp_M register is used to temporary store the value of the actual byte that has to be processed */
reg [7 : 0] temp_M;

/* M_valid_temp register is used to temporary store the value of M_valid */
reg M_valid_temp;

/* The H register is used to store the temporary value of the digest */
reg [7 : 0] [3 : 0]  H;

/* Wire used to feedback the output of the HashIteration in H*/
wire [7 : 0] [3 : 0] feedback;

/* Wires used for condition upon the state of FSA */
wire init_state;
wire compute_state;
wire final_state;

/* In the initial state the vector H is restored for a new processing activity */
assign init_state = busy === 0 && M_valid; 

/* In the compute state a digest is computing */
assign compute_state = busy === 1 && counter > 0;

/* FIn the final state the digest is ready and stable in output */
assign final_state = busy === 1 && counter === 0;  

/* Instantiation of HashIteration module */
HashIteration main(
    .M(temp_M), 
    .h(H),
    .h_out(feedback)
);

always @(posedge clk or negedge reset) begin
        
        //IDLE state 
        if (!reset) begin 
            hash_ready <= 0;
            busy <= 0;

        //INIT state
        end else if(init_state) begin 
            counter <= input_lenght;
            busy <= 1;
            hash_ready <= 0;
            temp_M <= M;
            M_valid_temp <= M_valid;

            H[0] <= Iv_H0;
            H[1] <= Iv_H1;
            H[2] <= Iv_H2;
            H[3] <= Iv_H3;
            H[4] <= Iv_H4;
            H[5] <= Iv_H5;
            H[6] <= Iv_H6;
            H[7] <= Iv_H7;
       
        //COMPUTE state
        end else if(compute_state) begin 
            //The input is processed only if is valid
            if(M_valid_temp === 1)begin 
                counter <= (counter - 1);
                H <= feedback;
            end
            //Keep sampling the next byte
                temp_M <= M;
                M_valid_temp <= M_valid;

        //FINAL state    
        end else if(final_state) begin 
            hash_ready <= 1; 
            busy <= 0;
            digest <= H;

        //WRONG state: perform nothing    
        end else begin 
            #0;
        end
    end
    
endmodule

