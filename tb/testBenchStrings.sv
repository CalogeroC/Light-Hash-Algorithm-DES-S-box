/*This module is used to test module with string that differs each other*/

module testBenchString;

    reg clk = 1'b0; 
    always #10 clk = !clk; 
  
    reg reset = 1'b0;
    event reset_deassertion; 
  
    reg M_valid;
    reg [63:0] input_lenght;
    reg hash_ready;
    reg [7 : 0] M;
    reg [31 : 0] digest;


    lightHashDES test_light_hash (
        .clk    (clk)
        ,.reset (reset)
        ,.M_valid   (M_valid)
        ,.M (M)
        ,.input_lenght  (input_lenght)  
        ,.hash_ready    (hash_ready)
        ,.digest    (digest)
    );

    initial begin
        #12.8 reset = 1'b1; 
        -> reset_deassertion; 
    end
     
    initial begin 
        reg [31 : 0] temp; // This is a support register
        logic[15:0] i;
        

        integer fd_test_vector,fd_results,r; 
        string test_string_1,test_string,py_digest_string,digest_string; //Support strings

        localparam empty_digest = 32'hb4d92c3f;
        localparam one_char_digest = 32'h4b76d630;

        @(reset_deassertion); 

        //Opening the file that contain test_vector
        fd_test_vector=$fopen("./tv/testbench.txt","r");
        if(fd_test_vector)$display("Test_vector file opened successfully");
        else $display("Sorry, the file containing the test_vectors could not be opened");

        //Opening the file that contain computed digest in python
        fd_results=$fopen("./tv/test_results.txt","r");
        if(fd_results)$display("Test_results file opened successfully");
        else $display("Sorry, the file containing the ecpected digest could not be opened");
       
        /*Test with empty string,we expect to have the initial vector*/
        begin: EMPTY_TEST
            $display("\n***EMPTY TEST START***\n");
            
            @(posedge clk);
            M_valid = 1'b1;
            input_lenght = 64'd0;
            r=$fgets(test_string,fd_test_vector);
            
            @(posedge clk);
            M_valid = 1'b0;
            
            @(posedge clk);
            @(posedge clk);
            

            if(hash_ready)
                begin
                $display("Digest result of empty test: %b", digest);
                $fgets(py_digest_string,fd_results);
                $display("Digest of the empty string python: %s",py_digest_string);
                digest_string=$sformatf("%b", digest);
                $display("test result: %s",(digest_string.compare(py_digest_string))?"Successful: the digest is the same as that obtained with python":"Failure");
                $display("test result: %s", empty_digest === digest ? "Successful" : "Failure" );
                $display("***EMPTY TEST END***\n");
            end
        end: EMPTY_TEST

        /*Test case with a string that contain only one char (A)*/
        begin: ONE_CHAR_TEST
            $display("***ONE CHAR TEST (A) START***\n");
    
            @(posedge clk);
            M_valid = 1'b1;
            input_lenght = 64'd1;
            r=$fgets(test_string,fd_test_vector);
            M =test_string.getc(0);
      
            @(posedge clk);
            M_valid = 1'b0;
            
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);

            if(hash_ready)
                begin
                    $display("Digest result of one char test (A): %b", digest);
                    $fgets(py_digest_string,fd_results);
                    $display("Digest of one char test python: %s",py_digest_string);
                    digest_string=$sformatf("%b", digest);
                    $display("test result: %s",(digest_string.compare(py_digest_string))?"Successful: the digest is the same as that obtained with python":"Failure");
                    $display("test result: %s", one_char_digest === digest ? "Successful" : "Failure" );
                    $display("***ONE CHAR TEST (A) END***\n");
                end
        end: ONE_CHAR_TEST
        
        /* If we give in input same strings to the module, we expect to have the same digest.*/
        begin: SAME_STRING_SAME_HASH
            @(posedge clk);
            $display("***TEST SAME MESSAGE SAME HASH START***\n");
            @(posedge clk);

            input_lenght = 64'd21;
            r=$fgets(test_string_1,fd_test_vector);

            for (i = 0; i < input_lenght ; i++) begin
                M = test_string_1.getc(i);
                M_valid = 1'b1;
                @(posedge clk);
            end
            
            M_valid = 1'b0;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);

            if(hash_ready)begin 
                $display("Digest of the test_string: %b", digest);
                $fgets(py_digest_string,fd_results);
                $display("Digest of the test_string python: %s",py_digest_string);
                digest_string=$sformatf("%b", digest);
                $display("test result: %s",(digest_string.compare(py_digest_string))?"Successful: the digest is the same as that obtained with python":"Failure");
                temp = digest;
            end

            input_lenght = 64'd21;
            $fgets(test_string,fd_test_vector);

            for (i = 0; i < input_lenght ; i++) begin
                M = test_string.getc(i);
                M_valid = 1'b1;
                @(posedge clk);
                M_valid = 1'b0;
                @(posedge clk);
            end
            
            M_valid = 1'b0;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);

            if(hash_ready)begin
                $display("Digest of the test_string: %b", digest);
                $fgets(py_digest_string,fd_results);
                $display("Digest of the test_string python: %s",py_digest_string);
                digest_string=$sformatf("%b", digest);
                $display("test result: %s",(digest_string.compare(py_digest_string))?"Successful: the digest is the same as that obtained with python":"Failure");
                $display("test result: %s", temp == digest ? "Successful: same strings have the same digest" : "Failure");
                temp <= digest;
            end
        $display("***TEST SAME MESSAGE SAME HASH END***\n");
        end: SAME_STRING_SAME_HASH

        /* If we give in input different strings to the module, we expect to have different digest.*/
        begin: DIFFERENT_STRING_DIFFERENT_HASH_TEST
            
            @(posedge clk);
            $display("***DIFFERENT MESSAGE DIFFERENT HASH BEGIN***\n");
            @(posedge clk);
            
            input_lenght = 64'd21;
            for (i = 0; i < input_lenght ; i++) begin
                M = test_string_1.getc(i);
                M_valid = 1'b1;
                @(posedge clk);
            end
            M_valid = 1'b0;
            @(posedge clk)
            @(posedge clk)
            @(posedge clk);
            if(hash_ready)begin 
                $display("Digest of the test_string_1: %b", digest);
                temp = digest;
            end

            @(posedge clk);
            input_lenght = 64'd21;
            r=$fgets(test_string,fd_test_vector);
            for (i = 0; i < input_lenght ; i++) begin
                M = test_string.getc(i);
                M_valid = 1'b1;
                @(posedge clk);
            end
            M_valid = 1'b0;
            @(posedge clk)
            @(posedge clk)
            @(posedge clk);

            if(hash_ready)begin
                $display("Digest of the test_string: %b", digest);
                $fgets(py_digest_string,fd_results);
                $display("Digest of the test_string python: %s",py_digest_string);
                digest_string=$sformatf("%b", digest);
                $display("test result: %s",(digest_string.compare(py_digest_string))?"Successful: the digest is the same as that obtained with python":"Failure");
                $display("test result: %s", temp !== digest ? "Successful: different strings different digest" : "Failure" );
            end
            $display("***DIFFERENT MESSAGE DIFFERENT HASH END***\n");
        end: DIFFERENT_STRING_DIFFERENT_HASH_TEST
        
        begin: DIFFERENT_STRING_DIFFERENT_HASH_TEST_2
            
            @(posedge clk);
            $display("***DIFFERENT MESSAGE DIFFERENT HASH BEGIN 2***\n");
            @(posedge clk);
            
            input_lenght = 64'd21;
            for (i = 0; i < input_lenght ; i++) begin
                M = test_string_1.getc(i);
                M_valid = 1'b1;
                @(posedge clk);
            end
            M_valid = 1'b0;
            @(posedge clk)
            @(posedge clk)
            @(posedge clk);
            if(hash_ready)begin 
                $display("Digest of the test_string_1: %b", digest);
                temp = digest;
            end

            @(posedge clk);
            input_lenght = 64'd20;
            r=$fgets(test_string,fd_test_vector);
            for (i = 0; i < input_lenght ; i++) begin
                M = test_string.getc(i);
                M_valid = 1'b1;
                @(posedge clk);
            end
            M_valid = 1'b0;
            @(posedge clk)
            @(posedge clk)
            @(posedge clk);

            if(hash_ready)begin
                $display("Digest of the test_string: %b", digest);
                $fgets(py_digest_string,fd_results);
                $display("Digest of the test_string python: %s",py_digest_string);
                digest_string=$sformatf("%b", digest);
                $display("test result: %s",(digest_string.compare(py_digest_string))?"Successful: the digest is the same as that obtained with python":"Failure");
                $display("test result: %s", temp !== digest ? "Successful: different strings different digest" : "Failure" );
            end
        $display("***DIFFERENT MESSAGE DIFFERENT HASH END***\n");
        end: DIFFERENT_STRING_DIFFERENT_HASH_TEST_2

        $fclose(fd_test_vector);
        $fclose(fd_results);
    $stop;
    end
endmodule