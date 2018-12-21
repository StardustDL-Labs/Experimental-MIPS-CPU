`include "../defines.v"

`define State_PC        3'd1
`define State_Decode    3'd2
`define State_ReadRM    3'd3
`define State_ALU       3'd4
`define State_WriteRM   3'd5

/*
0   pc+  		        => pc1
1   read 		        => pc2
2   read 		        => pc3
3   read 		        => pc4
4   read 		        => pc0
5   pc-,decoder+
6   
7   decoder-,readrm+    => readrm1
8   read                => readrm2
9   read                => readrm3
10  read                => readrm4
11  read                => readrm0
12  readrm-,alu+        => alu..  
13  
20  alu-,writerm+       => writerm1
21  write	            => writerm2
22  write	            => writerm3
23  write	            => writerm4
24  write	            => writerm0
25  write-,update pc
*/

module Core(
    input clock,
    input db_clear,
    input [`Addr_Width-1:0] db_maddr,
    output [`Byte_Width-1:0] db_mdata,
    output [`Addr_Width-1:0] db_memdata,
    output reg [3:0] db_valFrom,
    output reg db_count,
    output reg [`Inst_Width-1:0] db_instr
);

reg [2:0] state = 0;
reg [5:0] count = 0;
reg [`Addr_Width-1:0] pc = `ENTRY, npc = `ENTRY + 4;

reg [14:0] memory_addr_a, memory_addr_b;
reg [7:0] memory_data_a;
reg [7:0] memory_data_b;
wire [7:0] memory_q_a, memory_q_b;
reg memory_wren_a = 0;
wire memory_enable = 1;

reg [5:0] reg_addr_a;
reg [5:0] reg_addr_b;
reg [31:0] reg_data_a;
reg [31:0] reg_data_b;
reg reg_enable = 1;
reg reg_wren_a = 0;
reg reg_wren_b = 0;
wire [31:0] reg_q_a, reg_q_b;

assign memory_addr_b = db_maddr;
assign memory_wren_b = 0;
assign db_mdata = memory_q_b;

reg [`Reg_Width-1:0] rsv = 0;
reg [`Reg_Width-1:0] rtv = 0;
reg [`Addr_Width-1:0] memaddr = 0;

reg [`Inst_Width-1:0] instr = 0;
reg [`Data_Width-1:0] memdata = 0;
reg [`Data_Width-1:0] outdata = 0;

wire wrm_enable_mem0 = decoder_wTo == `wTo_Memw || decoder_wTo == `wTo_Memh || decoder_wTo == `wTo_Memb;
wire wrm_enable_mem1 = decoder_wTo == `wTo_Memw || decoder_wTo == `wTo_Memh;
wire wrm_enable_mem2 = decoder_wTo == `wTo_Memw;
wire wrm_enable_mem3 = decoder_wTo == `wTo_Memw;
wire wrm_enable_reg = decoder_wTo == `wTo_Reg;

/*always @ (posedge clock)
begin
    if (db_clear) begin
        count <= 0;
    end
    else begin
    if (count == 6'd25)
    begin
        count <= 0;
    end
    else
    begin
        count <= count + 1;
    end
    end
end*/

always @ (negedge clock)
begin
    if (db_clear) begin
        count <= 0;
    end
    else begin
    if (count == 6'd25)
    begin
        count <= 0;
    end
    else
    begin
        count <= count + 1;
    end
    end
    if (db_clear) begin
        pc <= `ENTRY;
        npc <= `ENTRY + 4;
    end
    else begin
    case (count)
        0: begin
            state <= `State_PC;
            db_instr <= 0;
            db_count <= 0;
            memory_addr_a <= pc;
            memory_wren_a <= 0;
        end
        1: begin
            instr[7:0] <= memory_q_a;
            memory_addr_a <= pc + 1;
        end
        2: begin
            instr[15:8] <= memory_q_a;
            memory_addr_a <= pc + 2;
        end
        3: begin
            instr[23:16] <= memory_q_a;
            memory_addr_a <= pc + 3;
        end
        4: begin
            instr[31:24] <= memory_q_a;
            memory_addr_a <= 0;
        end
        5: begin
            decoder_instr <= instr;
            db_instr <= instr;
            db_count <= 1;
            state <= `State_Decode;
        end
        6: begin
            db_valFrom[1:0] <= decoder_regTo;
            if (decoder_alubFrom == `alubFrom_Acc) begin
                reg_addr_a <= `Reg_Hi;
                reg_addr_b <= `Reg_Lo;
            end
            else begin
                reg_addr_a <= decoder_rs;
                reg_addr_b <= decoder_rt;
            end
            reg_wren_a <= 0;
            reg_wren_b <= 0;
            state <= `State_ReadRM;
        end
        7: begin
            rsv <= reg_q_a;
            rtv <= reg_q_b;
            memaddr <= reg_q_a + {{16{decoder_imm[15]}},decoder_imm};
            memory_addr_a <= reg_q_a + {{16{decoder_imm[15]}},decoder_imm};
            memory_wren_a <= 0;
        end
        8: begin
            memdata[7:0] <= memory_q_a;
            memory_addr_a <= memaddr + 1;
        end
        9: begin
            memdata[15:8] <= memory_q_a;
            memory_addr_a <= memaddr + 2;
        end
        10: begin
            memdata[23:16] <= memory_q_a;
            memory_addr_a <= memaddr + 3;
        end
        11: begin
            memdata[31:24] <= memory_q_a;
            memory_addr_a <= 0;
        end
        12: begin
            alu_pc <= pc;
            alu_in0 <= rsv;
            alu_imm <= decoder_imm;
            case (decoder_alubFrom)
                `alubFrom_Reg : begin
                    alu_in0 <= rsv;
                    alu_in1 <= rtv;
                end
                `alubFrom_Imm : begin
                    alu_in0 <= rsv;
                    alu_in1 <= decoder_sext ? {{16{decoder_imm[15]}},decoder_imm} : {{16{1'b0}},decoder_imm};
                end
                `alubFrom_Shamt : begin
                    alu_in0 <= rsv;
                    alu_in1 <= decoder_shamt;
                end
                `alubFrom_Acc : begin
                    alu_in0 <= rsv; // hi
                    alu_in1 <= rtv; // lo
                end
            endcase
            alu_control <= decoder_aluType;
            state <= `State_ALU;
        end
        19: begin
            case (decoder_valFrom)
                `valFrom_Alu : outdata <= alu_val0;
                `valFrom_Membu : outdata <= {{24{1'b0}},memdata[7:0]};
                `valFrom_Memhu : outdata <= {{16{1'b0}},memdata[15:0]};
                `valFrom_Memb  : outdata <= {{24{memdata[7]}},memdata[7:0]};
                `valFrom_Memh  : outdata <= {{16{memdata[15]}},memdata[15:0]};
                `valFrom_Memw  : outdata <= memdata;
            endcase
            state <= `State_WriteRM;
        end
        20: begin
            db_memdata <= outdata;
            if (wrm_enable_reg) begin
                memory_addr_a <= 0;
                memory_data_a <= 0;
                memory_wren_a <= 0;
                case (decoder_regTo)
                    `regTo_Acc: begin
                        reg_addr_a <= `Reg_Hi;
                        reg_data_a <= alu_val0;
                        reg_wren_a <= 1;
                        reg_addr_b <= `Reg_Lo;
                        reg_data_b <= alu_val1;
                        reg_wren_b <= 1;
                    end
                    `regTo_Hi: begin
                        reg_addr_a <= `Reg_Hi;
                        reg_data_a <= alu_val0;
                        reg_wren_a <= 1;
                        reg_addr_b <= 0;
                        reg_data_b <= 0;
                        reg_wren_b <= 0;
                    end
                    `regTo_Lo: begin
                        reg_addr_a <= `Reg_Lo;
                        reg_data_a <= alu_val0;
                        reg_wren_a <= 1;
                        reg_addr_b <= 0;
                        reg_data_b <= 0;
                        reg_wren_b <= 0;
                    end
                    `regTo_Al: begin
                        reg_addr_a <= 31;
                        reg_data_a <= alu_val1; // val0 is condition
                        reg_wren_a <= 1;
                        reg_addr_b <= 0;
                        reg_data_b <= 0;
                        reg_wren_b <= 0;
                    end
                    `regTo_Rt: begin
                        reg_addr_a <= decoder_rt;
                        reg_data_a <= outdata;
                        reg_wren_a <= 1;
                        reg_addr_b <= 0;
                        reg_data_b <= 0;
                        reg_wren_b <= 0;
                    end
                    `regTo_Rd: begin
                        reg_addr_a <= decoder_rd;
                        reg_data_a <= outdata;
                        reg_wren_a <= 1;
                        reg_addr_b <= 0;
                        reg_data_b <= 0;
                        reg_wren_b <= 0;
                    end
                endcase
            end
            else if (wrm_enable_mem0) begin
                reg_addr_a <= 0;
                reg_data_a <= 0;
                reg_wren_a <= 0;
                reg_addr_b <= 0;
                reg_data_b <= 0;
                reg_wren_b <= 0;
                memory_addr_a <= memaddr;
                memory_data_a <= outdata[7:0];
                memory_wren_a <= 1;
            end
        end
        21: begin
            if (wrm_enable_mem1) begin
                memory_addr_a <= memaddr + 1;
                memory_data_a <= outdata[15:8];
                memory_wren_a <= 1;
            end
        end
        22: begin
            if (wrm_enable_mem2) begin
                memory_addr_a <= memaddr + 2;
                memory_data_a <= outdata[23:16];
                memory_wren_a <= 1;
            end
        end
        23: begin
            if (wrm_enable_mem3) begin
                memory_addr_a <= memaddr + 3;
                memory_data_a <= outdata[31:24];
                memory_wren_a <= 1;
            end
        end
        24: begin
            memory_addr_a <= 0;
            memory_data_a <= 0;
            memory_wren_a <= 0;
            reg_addr_a <= 0;
            reg_data_a <= 0;
            reg_wren_a <= 0;
            reg_addr_b <= 0;
            reg_data_b <= 0;
            reg_wren_b <= 0;
        end
        25: begin
            case (decoder_pcFrom)
                `pcFrom_Plus4: begin
                    pc <= npc;
                    npc <= npc + 4;
                end
                `pcFrom_Jaddr: begin
                    pc <= npc;
                    npc <= (npc & 32'hf0000000) | {{4{1'b0}},decoder_jmm,2'b00};
                end
                `pcFrom_Jraddr: begin
                    pc <= npc;
                    npc <= rsv;
                end
                `pcFrom_Baddr: begin
                    if (alu_val0) begin // condition
                        pc <= npc;
                        npc <= alu_baddr;
                    end
                    else begin
                        pc <= npc;
                        npc <= npc + 4;
                    end
                end
                default: begin
                    pc <= 32'hffffffff;
                end
            endcase
        end
    endcase
    end
end

wire decoder_enable = state == `State_Decode;
reg [`Inst_Width-1:0] decoder_instr;
wire [`Opcode_Width-1:0] decoder_opcode;
wire [`Rs_Width-1:0] decoder_rs;
wire [`Rs_Width-1:0] decoder_rt;
wire [`Rs_Width-1:0] decoder_rd;
wire [`Shamt_Width-1:0] decoder_shamt;
wire [`Funct_Width-1:0] decoder_funct;
wire [`Imm_Width-1:0] decoder_imm;
wire [`Jmm_Width-1:0] decoder_jmm;
wire [2:0] decoder_wTo;
wire [2:0] decoder_regTo;
wire [2:0] decoder_valFrom;
wire decoder_sext;
wire [`Alu_Type_Width-1:0] decoder_aluType;
wire [1:0] decoder_alubFrom;
wire [2:0] decoder_pcFrom;

wire alu_enable = state == `State_ALU;
reg [`Addr_Width-1:0] alu_pc;
reg [`Data_Width-1:0] alu_in0;
reg [`Data_Width-1:0] alu_in1;
reg [`Imm_Width-1:0] alu_imm;
reg [`Alu_Type_Width-1:0] alu_control;
wire [`Data_Width-1:0] alu_val0;
wire [`Data_Width-1:0] alu_val1;
wire [`Addr_Width-1:0] alu_baddr;

Memory memory(
	.address_a(memory_addr_a),
	.address_b(memory_addr_b),
	.clock(clock),
	.data_a(memory_data_a),
	.data_b(memory_data_b),
	.enable(memory_enable),
	.wren_a(memory_wren_a),
	.wren_b(memory_wren_b),
	.q_a(memory_q_a),
	.q_b(memory_q_b)
);

Register register(
	.address_a(reg_addr_a),
	.address_b(reg_addr_b),
	.clock(clock),
	.data_a(reg_data_a),
	.data_b(reg_data_b),
	.enable(reg_enable),
	.wren_a(reg_wren_a),
	.wren_b(reg_wren_b),
	.q_a(reg_q_a),
	.q_b(reg_q_b));

Decoder decoder(
    .enable(decoder_enable),
    .instr(decoder_instr),
    .opcode(decoder_opcode),
    .rs(decoder_rs),
    .rt(decoder_rt),
    .rd(decoder_rd),
    .shamt(decoder_shamt),
    .funct(decoder_funct),
    .imm(decoder_imm),
    .jmm(decoder_jmm),
    .wTo(decoder_wTo),
    .regTo(decoder_regTo),
    .valFrom(decoder_valFrom),
    .sext(decoder_sext),
    .aluType(decoder_aluType),
    .alubFrom(decoder_alubFrom),
    .pcFrom(decoder_pcFrom)
);

Alu alu(
    .enable(alu_enable),
    .pc(alu_pc),
    .in0(alu_in0),
    .in1(alu_in1),
    .imm(alu_imm),
    .control(alu_control),
    .val0(alu_val0),
    .val1(alu_val1),
    .baddr(alu_baddr)
);

endmodule
