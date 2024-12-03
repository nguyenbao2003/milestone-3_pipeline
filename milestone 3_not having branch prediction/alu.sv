module alu(
  input  logic [31:0]   i_operand_a, i_operand_b,  // rs1_data, rs2_data
  input  logic				op_a_sel, op_b_sel      ,	
  input  logic [31:0] 	pc                      ,
  input	logic	[31:0] 	ImmExtE                 ,
  input  logic [3:0]  	i_alu_op                ,  // ALU Selection
  input	logic				br_less                 ,
  input  logic          br_equal                ,
  input  logic          br_sel                  ,
  input  logic [6:0]    OP                      ,
  input  logic [2:0]    funct3                  ,
  //checker
  output logic [31:0] operand_a, operand_b,
  output logic        o_br_sel_final             ,
  output logic [31:0] 	o_alu_data  			      // ALU 32-bit Output
//output logic        	CarryOut     			      // Carry Out Flag
);

  logic [31:0]   o_alu_data_temp;
//logic [32:0]   tmp;
//  logic [31:0]   operand_a, operand_b;
  logic [31:0]   shift_temp;	

//always_comb begin
//  tmp = {1'b0, i_operand_a} + {1'b0, i_operand_b};
//  CarryOut  = tmp[32];
//end

  assign operand_a = (op_a_sel)? pc : i_operand_a;
  assign operand_b = (op_b_sel)? ImmExtE : i_operand_b;
  
  always_comb begin
    if (OP == 7'b1100011) // branch
      case(funct3)
	     3'b000:   o_br_sel_final = (br_equal)? 1'b1 : 1'b0; //beq
		  3'b001:   o_br_sel_final = (~br_equal)? 1'b1 : 1'b0; //bne
		  3'b100:   o_br_sel_final = (br_less)? 1'b1 : 1'b0;  //blt
		  3'b101:   o_br_sel_final = (!br_less | br_equal)? 1'b1 : 1'b0;  //bge
		  3'b110:   o_br_sel_final = (br_less)? 1'b1 : 1'b0;  //bltu
		  3'b111:   o_br_sel_final = (!br_less | br_equal)? 1'b1 : 1'b0; //bgeu
		  default : o_br_sel_final =  1'b0;
      endcase
	 else begin
	   o_br_sel_final = br_sel;
	 end
  end
 
  always_comb begin
    shift_temp = operand_a; // Extend operand_a to 32-bits
      case(i_alu_op)
        4'b0000: o_alu_data_temp =   operand_a + operand_b;  // add
        4'b0001: o_alu_data_temp =   operand_a + ~operand_b + 1;  // sub
        4'b0010: o_alu_data_temp =   operand_a & operand_b;	  // and, andi
        4'b0011: o_alu_data_temp =   operand_a | operand_b;   // or, ori
//      4'b0100: o_alu_data_temp =   operand_a << operand_b;   // sll, sli		
		  4'b0100: begin   //sll, slli
		    if (operand_b[0]) shift_temp = {shift_temp[30:0], 1'b0};
          if (operand_b[1]) shift_temp = {shift_temp[29:0], 2'b00};
          if (operand_b[2]) shift_temp = {shift_temp[27:0], 4'b0000};
          if (operand_b[3]) shift_temp = {shift_temp[23:0], 8'b00000000};
          if (operand_b[4]) shift_temp = {shift_temp[15:0], 16'b0000000000000000};
          o_alu_data_temp = shift_temp;
        end 
        4'b0101: o_alu_data_temp =	(br_less) ? 32'd1 : 32'd0 ; // slt, slti
//		  4'b0111: o_alu_data_temp =  	operand_a >>> operand_b;    // sra, srai
		  4'b0111: begin
		    if (operand_b[0]) shift_temp = {shift_temp[31], shift_temp[31:1]};
          if (operand_b[1]) shift_temp = {{2{shift_temp[31]}}, shift_temp[31:2]};
          if (operand_b[2]) shift_temp = {{4{shift_temp[31]}}, shift_temp[31:4]};
          if (operand_b[3]) shift_temp = {{8{shift_temp[31]}}, shift_temp[31:8]};
          if (operand_b[4]) shift_temp = {{16{shift_temp[31]}}, shift_temp[31:16]};
          o_alu_data_temp = shift_temp;
		  end
        4'b1000: o_alu_data_temp =   (br_less) ? 32'd1 : 32'd0; // sltu, sltiu
        4'b1010: o_alu_data_temp =   operand_a ^ operand_b; // xor
//      4'b01011: o_alu_data_temp =  	operand_a >> operand_b; // srl, srli
        4'b1011: begin
		    if (operand_b[0]) shift_temp = {1'b0, shift_temp[31:1]};
          if (operand_b[1]) shift_temp = {2'b00, shift_temp[31:2]};
          if (operand_b[2]) shift_temp = {4'b0000, shift_temp[31:4]};
          if (operand_b[3]) shift_temp = {8'b00000000, shift_temp[31:8]};
          if (operand_b[4]) shift_temp = {16'b0000000000000000, shift_temp[31:16]};
          o_alu_data_temp = shift_temp;
		  end
		  4'b1100: o_alu_data_temp = operand_b; // lui
        default:  o_alu_data_temp = 32'b0;
		endcase
	end
	
	always_comb begin
	  o_alu_data = o_alu_data_temp;
	end
    
endmodule 
