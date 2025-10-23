`timescale 1ns / 1ps

module tb_RV32I ();

    logic clk;
    logic reset;
    logic [3:0] gpo;

    MCU dut (.*);

    always #5 clk = ~clk;

    initial begin
        #00 clk = 0;
        reset = 1;
        #10 reset = 0;
        #4000;
        $stop;
    end
endmodule
