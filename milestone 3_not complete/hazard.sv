//module hazard (
//    // Inputs
//    input logic [4:0] rs1_addr_E,       // Source register 1 address in Execute stage
//    input logic [4:0] rs2_addr_E,       // Source register 2 address in Execute stage
//    input logic [4:0] rd_addr_M,        // Destination register address in Memory stage
//    input logic [4:0] rd_addr_W,        // Destination register address in Write-back stage
//    input logic [4:0] rs1_addr_D,       // Source register 1 address in Decode stage
//    input logic [4:0] rs2_addr_D,       // Source register 2 address in Decode stage
//    input logic [4:0] rd_addr_E,        // Destination register address in Execute stage
//    input logic [1:0] wb_sel_E,         // Write-back selection in Execute stage
//    input logic       rd_wren_M,        // Register write enable in Memory stage
//    input logic       rd_wren_W,        // Register write enable in Write-back stage
//    input logic       br_sel,         // Program counter selection in Execute stage
//
//    // Outputs
//    output  logic  StallF,          // Stall signal for Fetch stage
//    output  logic  StallD,          // Stall signal for Decode stage
//    output  logic  FlushE,          // Flush signal for Execute stage
//    output  logic  FlushD,          // Flush signal for Decode stage
//    output  logic [1:0] forward_A_E, // Forwarding control for ALU operand A
//    output  logic [1:0] forward_B_E  // Forwarding control for ALU operand B
//);
//
//    // Internal register for Load-Use Stall
//    reg lw_stall;
//
//    // Forwarding logic for ALU operand A
//    always @(*) begin
//        if ((rs1_addr_E == rd_addr_M) && rd_wren_M && (rs1_addr_E != 5'b0)) begin
//            forward_A_E = 2'b10; // Forward from Memory stage
//        end else if ((rs1_addr_E == rd_addr_W) && rd_wren_W && (rs1_addr_E != 5'b0)) begin
//            forward_A_E = 2'b01; // Forward from Write-back stage
//        end else begin
//            forward_A_E = 2'b00; // No forwarding
//        end
//    end
//
//    // Forwarding logic for ALU operand B
//    always @(*) begin
//        if ((rs2_addr_E == rd_addr_M) && rd_wren_M && (rs2_addr_E != 5'b0)) begin
//            forward_B_E = 2'b10; // Forward from Memory stage
//        end else if ((rs2_addr_E == rd_addr_W) && rd_wren_W && (rs2_addr_E != 5'b0)) begin
//            forward_B_E = 2'b01; // Forward from Write-back stage
//        end else begin
//            forward_B_E = 2'b00; // No forwarding
//        end
//    end
//
//    // Hazard detection and stall/flush logic
//    always @(*) begin
//        // Detect Load-Use Hazard
//        lw_stall = (wb_sel_E[0] & ((rs1_addr_D == rd_addr_E) | (rs2_addr_D == rd_addr_E)));
//
//        // Set stall and flush signals
//        StallF  = lw_stall;
//        StallD  = lw_stall;
//        FlushE  = lw_stall | br_sel;
//        FlushD  = br_sel;
//    end
//endmodule
module hazard (
    // Inputs
	 input logic i_rst,
    input logic [4:0] rs1_addr_E,       // Source register 1 address in Execute stage
    input logic [4:0] rs2_addr_E,       // Source register 2 address in Execute stage
    input logic [4:0] rd_addr_M,        // Destination register address in Memory stage
    input logic [4:0] rd_addr_W,        // Destination register address in Write-back stage
    input logic [4:0] rs1_addr_D,       // Source register 1 address in Decode stage
    input logic [4:0] rs2_addr_D,       // Source register 2 address in Decode stage
    input logic [4:0] rd_addr_E,        // Destination register address in Execute stage
    input logic [1:0] wb_sel_E,         // Write-back selection in Execute stage
    input logic       rd_wren_M,        // Register write enable in Memory stage
    input logic       rd_wren_W,        // Register write enable in Write-back stage
    input logic       br_sel,         // Program counter selection in Execute stage

    // Outputs
    output  logic  StallF,          // Stall signal for Fetch stage
    output  logic  StallD,          // Stall signal for Decode stage
    output  logic  FlushE,          // Flush signal for Execute stage
    output  logic  FlushD,          // Flush signal for Decode stage
    output  logic [1:0] forward_A_E, // Forwarding control for ALU operand A
    output  logic [1:0] forward_B_E  // Forwarding control for ALU operand B
);
  logic lw_stall;
    // Forwarding logic for ALU Operand A
    assign forward_A_E = (i_rst == 1'b1) ? 2'b00 : 
                         ((rd_wren_M == 1'b1) && (rd_addr_M != 5'h00) && (rd_addr_M == rs1_addr_E)) ? 2'b10 :
                         ((rd_wren_W == 1'b1) && (rd_addr_W != 5'h00) && (rd_addr_W == rs1_addr_E)) ? 2'b01 : 
                         2'b00;

    // Forwarding logic for ALU Operand B
    assign forward_B_E = (i_rst == 1'b1) ? 2'b00 : 
                         ((rd_wren_M == 1'b1) && (rd_addr_M != 5'h00) && (rd_addr_M == rs2_addr_E)) ? 2'b10 :
                         ((rd_wren_W == 1'b1) && (rd_addr_W != 5'h00) && (rd_addr_W == rs2_addr_E)) ? 2'b01 : 
                         2'b00;
always_comb begin
        // Detect Load-Use Hazard
        lw_stall = (wb_sel_E[0] & ((rs1_addr_D == rd_addr_E) | (rs2_addr_D == rd_addr_E)));

        // Set stall and flush signals
        StallF  = lw_stall;
        StallD  = lw_stall;
        FlushE  = lw_stall | br_sel;
        FlushD  = br_sel;
    end
endmodule

