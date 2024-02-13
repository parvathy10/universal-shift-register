module universal_shift_register(
    input [3:0] data_in,
    input [1:0] ctrl,
    output reg [3:0] y1, y2, load
);
    always @(*) begin
        case(ctrl)
            2'b01: begin //left shift 
                y1[1] <= data_in[0];
                y1[2] <= data_in[1];
                y1[3] <= data_in[2];
                y1[0] <= 1'b0;
            end
            2'b10: begin //right shift 
                y1[2] <= data_in[3];
                y1[1] <= data_in[2];
                y1[0] <= data_in[1];
                y1[3] <= 1'b0;
            end
            2'b11: //parallel loading
                y1 = data_in;
            default: y1 <= 4'b0000; 
        endcase
    end

endmodule

module tb_uni_sr;
    logic [3:0] in_data;
    logic [1:0] ctrl;
    logic [3:0] out_data;
    int infile, outfile;
    int count;

    // Instantiate universal_shift_register module
    universal_shift_register shift_reg (
        .data_in(in_data), 
        .ctrl(ctrl),
        .y1(out_data),
        .y2(), // Output y2 not used
        .load(load)
    );

    initial begin
        // Open the input file in read mode
        infile = $fopen("inputt_filee.txt", "r");
        if (infile != 0)
            $display("File opened");
        else
            $display("File not opened");

        // Create a new output file in write mode
        outfile = $fopen("outputt_filee.txt", "w");

        // Read inputs from the input file and perform operations
        while (!$feof(infile)) begin
            count = $fscanf(infile, "%b %b", in_data, ctrl); // Scan each input value
            #10;
            $fwrite(outfile, "Input is: %b\nOperation is %b: %b\n", in_data, ctrl, out_data);
            #10;
        end

        $display("Output file written");
        $fclose(outfile); // Close output file
        $fclose(infile); // Close input file
    end
endmodule
