`ifndef __DEFINES__
`define __DEFINES__

`define Addr_Width          32
`define Inst_Width          32
`define Reg_Width           32
`define Data_Width          32
`define Byte_Width          8
`define Reg_Addr_Width      6

`define Reg_Hi              6'd32
`define Reg_Lo              6'd33

`define Opcode_Interval     31:26
`define Opcode_Width        6
`define Rs_Interval         25:21
`define Rt_Interval         20:16
`define Rd_Interval         15:11
`define Rs_Width            5
`define Shamt_Interval      10:6
`define Shamt_Width         5
`define Funct_Interval      5:0
`define Funct_Width         6
`define Imm_Interval        15:0
`define Imm_Width           16
`define Jmm_Interval        25:0
`define Jmm_Width           26

`define Op_Addi             6'h08
`define Op_Addiu            6'h09
`define Op_Andi             6'h0c
`define Op_Ori              6'h0d
`define Op_Xori             6'h0e
`define Op_Lui              6'h0f
`define Op_Lb               6'h20
`define Op_Lh               6'h21
`define Op_Lw               6'h23
`define Op_Lbu              6'h24
`define Op_Lhu              6'h25
`define Op_Sb               6'h28
`define Op_Sh               6'h29
`define Op_Sw               6'h2b
`define Op_Beq              6'h04
`define Op_Bne              6'h05
`define Op_Bgez             6'h01
`define Op_Bgezal           6'h01
`define Op_Bltz             6'h01
`define Op_Bltzal           6'h01
`define Op_Bgtz             6'h07
`define Op_Blez             6'h06
`define Op_Slti             6'h0a
`define Op_Sltiu            6'h0b
`define Op_Special          6'h00
`define Op_Special2         6'h1c
`define Op_J                6'h02
`define Op_Jal              6'h03

`define Ft_Mult             6'h18
`define Ft_Multu            6'h19
`define Ft_Div              6'h1a
`define Ft_Divu             6'h1b
`define Ft_Mfhi             6'h10
`define Ft_Mthi             6'h11
`define Ft_Mflo             6'h12
`define Ft_Mtlo             6'h13
`define Ft_Add              6'h20
`define Ft_Addu             6'h21
`define Ft_Sub              6'h22
`define Ft_Subu             6'h23
`define Ft_And              6'h24
`define Ft_Or               6'h25
`define Ft_Xor              6'h26
`define Ft_Nor              6'h27
`define Ft_Slt              6'h2a
`define Ft_Sltu             6'h2b
`define Ft_Sll              6'h00
`define Ft_Srl              6'h02
`define Ft_Sra              6'h03
`define Ft_Sllv             6'h04
`define Ft_Srlv             6'h06
`define Ft_Srav             6'h07
`define Ft_Jr               6'h08
`define Ft_Jalr             6'h09
// `define Ft_Syscall          6'h0c
// `define Ft_Break            6'h0d
`define Ft_Mul              6'h02


`define Alu_Type_Width      5
`define Alu_None            5'd00
`define Alu_Add             5'd01
`define Alu_Sub             5'd02
`define Alu_Mul             5'd03
`define Alu_Divu            5'd04
`define Alu_And             5'd05
`define Alu_Or              5'd06
`define Alu_Xor             5'd07
`define Alu_Nor             5'd08
`define Alu_Sll             5'd09
`define Alu_Srl             5'd10
`define Alu_Sra             5'd11
`define Alu_Lui             5'd12
`define Alu_Beq             5'd13
`define Alu_Bne             5'd14
`define Alu_Bgez            5'd15
`define Alu_Bgtz            5'd16
`define Alu_Blez            5'd17
`define Alu_Bltz            5'd18
`define Alu_Multu           5'd19
`define Alu_Jal             5'd20
`define Alu_Bgezal          5'd21
`define Alu_Bltzal          5'd22
`define Alu_In1             5'd23
`define Alu_Slt             5'd24
`define Alu_Div             5'd25
`define Alu_Mult            5'd26
`define Alu_In0             5'd27

// For write
`define wTo_None            3'd0
`define wTo_Reg             3'd5
`define wTo_Memw            3'd4
`define wTo_Memh            3'd2
`define wTo_Memb            3'd1

// For write
`define valFrom_None        3'd0
`define valFrom_Alu         3'd0
`define valFrom_Membu       3'd1
`define valFrom_Memhu       3'd2
`define valFrom_Memb        3'd3
`define valFrom_Memh        3'd4
`define valFrom_Memw        3'd5

// For write
`define regTo_None          3'd0
`define regTo_Rt            3'd0
`define regTo_Rd            3'd1
`define regTo_Acc           3'd2
`define regTo_Al            3'd3
`define regTo_Hi            3'd4
`define regTo_Lo            3'd5

// For write
`define mAddr_None          32'd0

// For alu
`define alubFrom_None       2'd0
`define alubFrom_Reg        2'd0
`define alubFrom_Imm        2'd1
`define alubFrom_Shamt      2'd2
`define alubFrom_Acc        2'd3

`define pcFrom_Plus4        3'd0
`define pcFrom_Jaddr        3'd1
`define pcFrom_Jraddr       3'd2
`define pcFrom_Baddr        3'd3
`define pcFrom_Baladdr      3'd4

`define ENTRY               32'h0100

`endif