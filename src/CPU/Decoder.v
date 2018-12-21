`include "../defines.v"

module Decoder(
    input enable,
    input [`Inst_Width-1:0] instr,
    output [`Opcode_Width-1:0] opcode,
    output [`Rs_Width-1:0] rs,
    output [`Rs_Width-1:0] rt,
    output [`Rs_Width-1:0] rd,
    output [`Shamt_Width-1:0] shamt,
    output [`Funct_Width-1:0] funct,
    output [`Imm_Width-1:0] imm,
    output [`Jmm_Width-1:0] jmm,
    output reg [2:0] wTo,
    output reg [2:0] regTo,
    output reg [2:0] valFrom,
    output reg sext,
    output reg [`Alu_Type_Width-1:0] aluType,
    output reg [1:0] alubFrom,
    output reg [2:0] pcFrom
);

assign opcode = instr[`Opcode_Interval];
assign rs = instr[`Rs_Interval];
assign rt = instr[`Rt_Interval];
assign rd = instr[`Rd_Interval];
assign shamt = instr[`Shamt_Interval];
assign funct = instr[`Funct_Interval];
assign imm = instr[`Imm_Interval];
assign jmm = instr[`Jmm_Interval];

always @(instr or enable) begin
    if (enable) begin
        case (opcode)
            `Op_Special: begin
                case (funct)
                    `Ft_Add: begin  // trap not complete
                        wTo <= `wTo_Reg;
                        regTo <= `regTo_Rd;
                        valFrom <= `valFrom_Alu;
                        sext <= 1;
                        aluType <= `Alu_Add;
                        alubFrom <= `alubFrom_Reg;
                        pcFrom <= `pcFrom_Plus4;
                    end
                    `Ft_Sub: begin  // trap not complete
                        wTo <= `wTo_Reg;
                        regTo <= `regTo_Rd;
                        valFrom <= `valFrom_Alu;
                        sext <= 1;
                        aluType <= `Alu_Sub;
                        alubFrom <= `alubFrom_Reg;
                        pcFrom <= `pcFrom_Plus4;
                    end
                    `Ft_Addu: begin
                        wTo <= `wTo_Reg;
                        regTo <= `regTo_Rd;
                        valFrom <= `valFrom_Alu;
                        sext <= 1;
                        aluType <= `Alu_Add;
                        alubFrom <= `alubFrom_Reg;
                        pcFrom <= `pcFrom_Plus4;
                    end
                    `Ft_Subu: begin
                        wTo <= `wTo_Reg;
                        regTo <= `regTo_Rd;
                        valFrom <= `valFrom_Alu;
                        sext <= 1;
                        aluType <= `Alu_Sub;
                        alubFrom <= `alubFrom_Reg;
                        pcFrom <= `pcFrom_Plus4;
                    end
                    `Ft_And: begin
                        wTo <= `wTo_Reg;
                        regTo <= `regTo_Rd;
                        valFrom <= `valFrom_Alu;
                        sext <= 0;
                        aluType <= `Alu_And;
                        alubFrom <= `alubFrom_Reg;
                        pcFrom <= `pcFrom_Plus4;
                    end
                    `Ft_Or: begin
                        wTo <= `wTo_Reg;
                        regTo <= `regTo_Rd;
                        valFrom <= `valFrom_Alu;
                        sext <= 0;
                        aluType <= `Alu_Or;
                        alubFrom <= `alubFrom_Reg;
                        pcFrom <= `pcFrom_Plus4;
                    end
                    `Ft_Xor: begin
                        wTo <= `wTo_Reg;
                        regTo <= `regTo_Rd;
                        valFrom <= `valFrom_Alu;
                        sext <= 0;
                        aluType <= `Alu_Xor;
                        alubFrom <= `alubFrom_Reg;
                        pcFrom <= `pcFrom_Plus4;
                    end
                    `Ft_Nor: begin
                        wTo <= `wTo_Reg;
                        regTo <= `regTo_Rd;
                        valFrom <= `valFrom_Alu;
                        sext <= 0;
                        aluType <= `Alu_Nor;
                        alubFrom <= `alubFrom_Reg;
                        pcFrom <= `pcFrom_Plus4;
                    end
                    `Ft_Slt: begin  // trap not complete
                        wTo <= `wTo_Reg;
                        regTo <= `regTo_Rd;
                        valFrom <= `valFrom_Alu;
                        sext <= 0;
                        aluType <= `Alu_Slt;
                        alubFrom <= `alubFrom_Reg;
                        pcFrom <= `pcFrom_Plus4;
                    end
                    `Ft_Sltu: begin
                        wTo <= `wTo_Reg;
                        regTo <= `regTo_Rd;
                        valFrom <= `valFrom_Alu;
                        sext <= 0;
                        aluType <= `Alu_Slt;
                        alubFrom <= `alubFrom_Reg;
                        pcFrom <= `pcFrom_Plus4;
                    end
                    `Ft_Sll: begin
                        wTo <= `wTo_Reg;
                        regTo <= `regTo_Rd;
                        valFrom <= `valFrom_Alu;
                        sext <= 0;
                        aluType <= `Alu_Sll;
                        alubFrom <= `alubFrom_Shamt;
                        pcFrom <= `pcFrom_Plus4;
                    end
                    `Ft_Sra: begin
                        wTo <= `wTo_Reg;
                        regTo <= `regTo_Rd;
                        valFrom <= `valFrom_Alu;
                        sext <= 0;
                        aluType <= `Alu_Sra;
                        alubFrom <= `alubFrom_Shamt;
                        pcFrom <= `pcFrom_Plus4;
                    end
                    `Ft_Srl: begin
                        wTo <= `wTo_Reg;
                        regTo <= `regTo_Rd;
                        valFrom <= `valFrom_Alu;
                        sext <= 0;
                        aluType <= `Alu_Srl;
                        alubFrom <= `alubFrom_Shamt;
                        pcFrom <= `pcFrom_Plus4;
                    end
                    `Ft_Sllv: begin
                        wTo <= `wTo_Reg;
                        regTo <= `regTo_Rd;
                        valFrom <= `valFrom_Alu;
                        sext <= 0;
                        aluType <= `Alu_Sll;
                        alubFrom <= `alubFrom_Reg; // rs
                        pcFrom <= `pcFrom_Plus4;
                    end
                    `Ft_Srav: begin
                        wTo <= `wTo_Reg;
                        regTo <= `regTo_Rd;
                        valFrom <= `valFrom_Alu;
                        sext <= 0;
                        aluType <= `Alu_Sra;
                        alubFrom <= `alubFrom_Reg; // rs
                        pcFrom <= `pcFrom_Plus4;
                    end
                    `Ft_Srlv: begin
                        wTo <= `wTo_Reg;
                        regTo <= `regTo_Rd;
                        valFrom <= `valFrom_Alu;
                        sext <= 0;
                        aluType <= `Alu_Srl;
                        alubFrom <= `alubFrom_Reg; // rs
                        pcFrom <= `pcFrom_Plus4;
                    end
                    `Ft_Jr: begin
                        wTo <= `wTo_None;
                        regTo <= `regTo_None;
                        valFrom <= `valFrom_None;
                        sext <= 0;
                        aluType <= `Alu_None;
                        alubFrom <= `alubFrom_None;
                        pcFrom <= `pcFrom_Jraddr;
                    end
                    `Ft_Jalr: begin
                        wTo <= `wTo_Reg;
                        regTo <= `regTo_Al;
                        valFrom <= `valFrom_Alu;
                        sext <= 0;
                        aluType <= `Alu_Jal;
                        alubFrom <= `alubFrom_None;
                        pcFrom <= `pcFrom_Jraddr;
                    end
                    `Ft_Mult: begin
                        wTo <= `wTo_Reg;
                        regTo <= `regTo_Acc;
                        valFrom <= `valFrom_Alu;
                        sext <= 0;
                        aluType <= `Alu_Mult;
                        alubFrom <= `alubFrom_Reg;
                        pcFrom <= `pcFrom_Plus4;
                    end
                    `Ft_Div: begin
                        wTo <= `wTo_Reg;
                        regTo <= `regTo_Acc;
                        valFrom <= `valFrom_Alu;
                        sext <= 0;
                        aluType <= `Alu_Div;
                        alubFrom <= `alubFrom_Reg;
                        pcFrom <= `pcFrom_Plus4;
                    end
                    `Ft_Multu: begin
                        wTo <= `wTo_Reg;
                        regTo <= `regTo_Acc;
                        valFrom <= `valFrom_Alu;
                        sext <= 0;
                        aluType <= `Alu_Multu;
                        alubFrom <= `alubFrom_Reg;
                        pcFrom <= `pcFrom_Plus4;
                    end
                    `Ft_Divu: begin
                        wTo <= `wTo_Reg;
                        regTo <= `regTo_Acc;
                        valFrom <= `valFrom_Alu;
                        sext <= 0;
                        aluType <= `Alu_Divu;
                        alubFrom <= `alubFrom_Reg;
                        pcFrom <= `pcFrom_Plus4;
                    end
                    `Ft_Mfhi: begin
                        wTo <= `wTo_Reg;
                        regTo <= `regTo_Rd;
                        valFrom <= `valFrom_Alu;
                        sext <= 0;
                        aluType <= `Alu_In0; // hi
                        alubFrom <= `alubFrom_Acc;
                        pcFrom <= `pcFrom_Plus4;
                    end
                    `Ft_Mthi: begin
                        wTo <= `wTo_Reg;
                        regTo <= `regTo_Hi;
                        valFrom <= `valFrom_Alu;
                        sext <= 0;
                        aluType <= `Alu_In0; // rs
                        alubFrom <= `alubFrom_Reg;
                        pcFrom <= `pcFrom_Plus4;
                    end
                    `Ft_Mflo: begin
                        wTo <= `wTo_Reg;
                        regTo <= `regTo_Rd;
                        valFrom <= `valFrom_Alu;
                        sext <= 0;
                        aluType <= `Alu_In1; // lo
                        alubFrom <= `alubFrom_Acc;
                        pcFrom <= `pcFrom_Plus4;
                    end
                    `Ft_Mtlo: begin
                        wTo <= `wTo_Reg;
                        regTo <= `regTo_Lo;
                        valFrom <= `valFrom_Alu;
                        sext <= 0;
                        aluType <= `Alu_In0; // rs
                        alubFrom <= `alubFrom_Reg;
                        pcFrom <= `pcFrom_Plus4;
                    end
                endcase
            end
            `Op_Special2: begin
                case (funct)
                    `Ft_Mul: begin
                        wTo <= `wTo_Reg;
                        regTo <= `regTo_Rd;
                        valFrom <= `valFrom_Alu;
                        sext <= 0;
                        aluType <= `Alu_Mul;
                        alubFrom <= `alubFrom_Reg;
                        pcFrom <= `pcFrom_Plus4;
                    end
                endcase
            end
            `Op_Addi: begin // trap not complete
                wTo <= `wTo_Reg;
                regTo <= `regTo_Rt;
                valFrom <= `valFrom_Alu;
                sext <= 1;
                aluType <= `Alu_Add;
                alubFrom <= `alubFrom_Imm;
                pcFrom <= `pcFrom_Plus4;
            end
            `Op_Addiu: begin
                wTo <= `wTo_Reg;
                regTo <= `regTo_Rt;
                valFrom <= `valFrom_Alu;
                sext <= 1;
                aluType <= `Alu_Add;
                alubFrom <= `alubFrom_Imm;
                pcFrom <= `pcFrom_Plus4;
            end
            `Op_Andi: begin
                wTo <= `wTo_Reg;
                regTo <= `regTo_Rt;
                valFrom <= `valFrom_Alu;
                sext <= 0;
                aluType <= `Alu_And;
                alubFrom <= `alubFrom_Imm;
                pcFrom <= `pcFrom_Plus4;
            end
            `Op_Ori: begin
                wTo <= `wTo_Reg;
                regTo <= `regTo_Rt;
                valFrom <= `valFrom_Alu;
                sext <= 0;
                aluType <= `Alu_Or;
                alubFrom <= `alubFrom_Imm;
                pcFrom <= `pcFrom_Plus4;
            end
            `Op_Xori: begin
                wTo <= `wTo_Reg;
                regTo <= `regTo_Rt;
                valFrom <= `valFrom_Alu;
                sext <= 0;
                aluType <= `Alu_Xor;
                alubFrom <= `alubFrom_Imm;
                pcFrom <= `pcFrom_Plus4;
            end
            `Op_Slti: begin // trap not complete
                wTo <= `wTo_Reg;
                regTo <= `regTo_Rt;
                valFrom <= `valFrom_Alu;
                sext <= 1;
                aluType <= `Alu_Slt;
                alubFrom <= `alubFrom_Imm;
                pcFrom <= `pcFrom_Plus4;
            end
            `Op_Sltiu: begin
                wTo <= `wTo_Reg;
                regTo <= `regTo_Rt;
                valFrom <= `valFrom_Alu;
                sext <= 1;
                aluType <= `Alu_Slt;
                alubFrom <= `alubFrom_Imm;
                pcFrom <= `pcFrom_Plus4;
            end
            `Op_Lui: begin
                wTo <= `wTo_Reg;
                regTo <= `regTo_Rt;
                valFrom <= `valFrom_Alu;
                sext <= 0;
                aluType <= `Alu_Lui;
                alubFrom <= `alubFrom_Imm;
                pcFrom <= `pcFrom_Plus4;
            end
            `Op_Beq: begin
                wTo <= `wTo_None;
                regTo <= `regTo_None;
                valFrom <= `valFrom_None;
                sext <= 0;
                aluType <= `Alu_Beq;
                alubFrom <= `alubFrom_Reg;
                pcFrom <= `pcFrom_Baddr;
            end
            `Op_Bne: begin
                wTo <= `wTo_None;
                regTo <= `regTo_None;
                valFrom <= `valFrom_None;
                sext <= 0;
                aluType <= `Alu_Bne;
                alubFrom <= `alubFrom_Reg;
                pcFrom <= `pcFrom_Baddr;
            end
            `Op_Blez: begin
                wTo <= `wTo_None;
                regTo <= `regTo_None;
                valFrom <= `valFrom_None;
                sext <= 0;
                aluType <= `Alu_Blez;
                alubFrom <= `alubFrom_None;
                pcFrom <= `pcFrom_Baddr;
            end
            `Op_Bgtz: begin
                wTo <= `wTo_None;
                regTo <= `regTo_None;
                valFrom <= `valFrom_None;
                sext <= 0;
                aluType <= `Alu_Bgtz;
                alubFrom <= `alubFrom_None;
                pcFrom <= `pcFrom_Baddr;
            end
            `Op_Bgez: begin
                case (rt)
                    5'h01: begin // bgez
                        wTo <= `wTo_None;
                        regTo <= `regTo_None;
                        valFrom <= `valFrom_None;
                        sext <= 0;
                        aluType <= `Alu_Bgez;
                        alubFrom <= `alubFrom_None;
                        pcFrom <= `pcFrom_Baddr;
                    end
                    5'h11: begin // bgezal
                        wTo <= `wTo_Reg;
                        regTo <= `regTo_Al;
                        valFrom <= `valFrom_Alu;
                        sext <= 0;
                        aluType <= `Alu_Bgezal;
                        alubFrom <= `alubFrom_None;
                        pcFrom <= `pcFrom_Baddr;
                    end
                    5'h00: begin // bltz
                        wTo <= `wTo_None;
                        regTo <= `regTo_None;
                        valFrom <= `valFrom_None;
                        sext <= 0;
                        aluType <= `Alu_Bltz;
                        alubFrom <= `alubFrom_None;
                        pcFrom <= `pcFrom_Baddr;
                    end
                    5'h20: begin // bltzal
                        wTo <= `wTo_Reg;
                        regTo <= `regTo_Al;
                        valFrom <= `valFrom_Alu;
                        sext <= 0;
                        aluType <= `Alu_Bltzal;
                        alubFrom <= `alubFrom_None;
                        pcFrom <= `pcFrom_Baddr;
                    end
                endcase
            end
            `Op_J: begin
                wTo <= `wTo_None;
                regTo <= `regTo_None;
                valFrom <= `valFrom_None;
                sext <= 0;
                aluType <= `Alu_None;
                alubFrom <= `alubFrom_None;
                pcFrom <= `pcFrom_Jaddr;
            end
            `Op_Jal: begin
                wTo <= `wTo_Reg;
                regTo <= `regTo_Al;
                valFrom <= `valFrom_Alu;
                sext <= 0;
                aluType <= `Alu_Jal;
                alubFrom <= `alubFrom_None;
                pcFrom <= `pcFrom_Jaddr;
            end
            `Op_Lbu: begin
                wTo <= `wTo_Reg;
                regTo <= `regTo_Rt;
                valFrom <= `valFrom_Membu;
                sext <= 0;
                aluType <= `Alu_None;
                alubFrom <= `alubFrom_None;
                pcFrom <= `pcFrom_Plus4;
            end
            `Op_Lhu: begin
                wTo <= `wTo_Reg;
                regTo <= `regTo_Rt;
                valFrom <= `valFrom_Memhu;
                sext <= 0;
                aluType <= `Alu_None;
                alubFrom <= `alubFrom_None;
                pcFrom <= `pcFrom_Plus4;
            end
            `Op_Lb: begin
                wTo <= `wTo_Reg;
                regTo <= `regTo_Rt;
                valFrom <= `valFrom_Memb;
                sext <= 0;
                aluType <= `Alu_None;
                alubFrom <= `alubFrom_None;
                pcFrom <= `pcFrom_Plus4;
            end
            `Op_Lh: begin
                wTo <= `wTo_Reg;
                regTo <= `regTo_Rt;
                valFrom <= `valFrom_Memh;
                sext <= 0;
                aluType <= `Alu_None;
                alubFrom <= `alubFrom_None;
                pcFrom <= `pcFrom_Plus4;
            end
            `Op_Lw: begin
                wTo <= `wTo_Reg;
                regTo <= `regTo_Rt;
                valFrom <= `valFrom_Memw;
                sext <= 0;
                aluType <= `Alu_None;
                alubFrom <= `alubFrom_None;
                pcFrom <= `pcFrom_Plus4;
            end
            `Op_Sb: begin
                wTo <= `wTo_Memb;
                regTo <= `regTo_None;
                valFrom <= `valFrom_Alu;
                sext <= 0;
                aluType <= `Alu_In1;
                alubFrom <= `alubFrom_Reg; // for rt
                pcFrom <= `pcFrom_Plus4;
            end
            `Op_Sh: begin
                wTo <= `wTo_Memh;
                regTo <= `regTo_None;
                valFrom <= `valFrom_Alu;
                sext <= 0;
                aluType <= `Alu_In1;
                alubFrom <= `alubFrom_Reg; // for rt
                pcFrom <= `pcFrom_Plus4;
            end
            `Op_Sw: begin
                wTo <= `wTo_Memw;
                regTo <= `regTo_None;
                valFrom <= `valFrom_Alu;
                sext <= 0;
                aluType <= `Alu_In1;
                alubFrom <= `alubFrom_Reg; // for rt
                pcFrom <= `pcFrom_Plus4;
            end
        endcase
    end
end

endmodule
