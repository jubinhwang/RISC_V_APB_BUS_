`timescale 1ns / 1ps

module APB_GPO (
    // global signals
    input  logic        PCLK,
    input  logic        PRESET,
    // APB Interface Signals
    input  logic [ 2:0] PADDR,
    input  logic        PWRITE,
    input  logic        PSEL,
    input  logic        PENABLE,
    input  logic [31:0] PWDATA,
    output logic [31:0] PRDATA,
    output logic        PREADY,
    // external signals ports
    output logic [ 3:0] gpo
);

    logic [3:0] mode;
    logic [3:0] out_data;

    APB_Slave_GPO_Interface U_APB_GPO_Intf (.*);
    apb_gpo U_APB_GPO (.*);

endmodule

module APB_Slave_GPO_Interface (
    // global signals
    input  logic        PCLK,
    input  logic        PRESET,
    // APB Interface Signals
    input  logic [ 2:0] PADDR,
    input  logic        PWRITE,
    input  logic        PSEL,
    input  logic        PENABLE,
    input  logic [31:0] PWDATA,
    output logic [31:0] PRDATA,
    output logic        PREADY,
    // Internal signals
    output logic [ 3:0] mode,
    output logic [ 3:0] out_data
);
    logic [31:0] slv_reg0, slv_reg1;  // slv_reg2, slv_reg3;

    assign mode     = slv_reg0[3:0];
    assign out_data = slv_reg1[3:0];

    always_ff @(posedge PCLK, posedge PRESET) begin
        if (PRESET) begin
            slv_reg0 <= 0;
            slv_reg1 <= 0;
            // slv_reg2 <= 0;
            // slv_reg3 <= 0;
        end else begin
            PREADY <= 1'b0;
            if (PSEL && PENABLE) begin
                PREADY <= 1'b1;
                if (PWRITE) begin
                    case (PADDR[2])
                        1'b0: slv_reg0 <= PWDATA;
                        1'b1: slv_reg1 <= PWDATA;
                        // 2'b10: slv_reg2 <= PWDATA;
                        // 2'b11: slv_reg3 <= PWDATA;
                    endcase
                end else begin
                    case (PADDR[2])
                        1'b0: PRDATA <= slv_reg0;
                        1'b1: PRDATA <= slv_reg1;
                        // 2'b10: PRDATA <= slv_reg2;
                        // 2'b11: PRDATA <= slv_reg3;
                    endcase
                end
            end
        end
    end
endmodule


module apb_gpo (
    input  logic [3:0] mode,
    input  logic [3:0] out_data,
    output logic [3:0] gpo
);
    genvar i;
    generate
        for (i = 0; i < 4; i++) begin
            assign gpo[i] = mode[i] ? out_data[i] : 1'bz;
        end
    endgenerate
    // assign gpo[0] = mode[0] ? out_data[0] : 1'bz;
    // assign gpo[1] = mode[1] ? out_data[1] : 1'bz;
    // assign gpo[2] = mode[2] ? out_data[2] : 1'bz;
    // assign gpo[3] = mode[3] ? out_data[3] : 1'bz;
endmodule
