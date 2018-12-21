`include "../../defines.v"

module Alu(
    input enable,
    input [`Addr_Width-1:0] pc,
    input [`Data_Width-1:0] in0,
    input [`Data_Width-1:0] in1,
    input [`Imm_Width-1:0] imm,
    input [`Alu_Type_Width-1:0] control,
    output reg [`Data_Width-1:0] val0,
    output reg [`Data_Width-1:0] val1,
    output reg [`Addr_Width-1:0] baddr
);

always @ (*)
begin
    if (enable) begin
        case (control)
            `Alu_None: begin
                val0 <= 0;
                val1 <= 0;
                baddr <= 0;
            end
            `Alu_Add: begin
                val0 <= in0 + in1;
                val1 <= 0;
                baddr <= 0;
            end
            `Alu_Sub: begin
                val0 <= in0 - in1;
                val1 <= 0;
                baddr <= 0;
            end
            `Alu_And: begin
                val0 <= in0 & in1;
                val1 <= 0;
                baddr <= 0;
            end
            `Alu_Or: begin
                val0 <= in0 | in1;
                val1 <= 0;
                baddr <= 0;
            end
            `Alu_Xor: begin
                val0 <= in0 ^ in1;
                val1 <= 0;
                baddr <= 0;
            end
            `Alu_Nor: begin
                val0 <= ~(in0 | in1);
                val1 <= 0;
                baddr <= 0;
            end
            `Alu_Mul: begin
                val0 <= in0 * in1;
                val1 <= 0;
                baddr <= 0;
            end
            `Alu_Multu: begin
                {val0, val1} <= in0 * in1;
                baddr <= 0;
            end
            `Alu_Divu: begin
                val0 <= in0 % in1;
                val1 <= in0 / in1;
                baddr <= 0;
            end
            `Alu_Div: begin
                val0 <= $signed(in0) % $signed(in1);
                val1 <= $signed(in0) / $signed(in1);
                baddr <= 0;
            end
            `Alu_Mult: begin
                {val0, val1} <= $signed(in0) * $signed(in1);
                baddr <= 0;
            end
            `Alu_Sll: begin
                val0 <= in0 << in1;
                val1 <= 0;
                baddr <= 0;
            end
            `Alu_Srl: begin
                val0 <= in0 >> in1;
                val1 <= 0;
                baddr <= 0;
            end
            `Alu_Sra: begin
                val0 <= $signed(in0) >>> in1;
                val1 <= 0;
                baddr <= 0;
            end
            `Alu_Lui: begin
                val0 <= in0 << 16;
                val1 <= 0;
                baddr <= 0;
            end
            `Alu_Beq: begin
                val0 <= in0 == in1;
                val1 <= 0;
                baddr <= pc + 4 + ({{16{imm[15]}},imm} << 2);
            end
            `Alu_Bne: begin
                val0 <= in0 != in1;
                val1 <= 0;
                baddr <= pc + 4 + ({{16{imm[15]}},imm} << 2);
            end
            `Alu_Bgez: begin
                val0 <= in0 >= 0;
                val1 <= 0;
                baddr <= pc + 4 + ({{16{imm[15]}},imm} << 2);
            end
            `Alu_Bgtz: begin
                val0 <= in0 > 0;
                val1 <= 0;
                baddr <= pc + 4 + ({{16{imm[15]}},imm} << 2);
            end
            `Alu_Blez: begin
                val0 <= in0 <= 0;
                val1 <= 0;
                baddr <= pc + 4 + ({{16{imm[15]}},imm} << 2);
            end
            `Alu_Bltz: begin
                val0 <= in0 < 0;
                val1 <= 0;
                baddr <= pc + 4 + ({{16{imm[15]}},imm} << 2);
            end
            `Alu_Jal: begin
                val0 <= 0;
                val1 <= pc + 8;
                baddr <= 0;
            end
            `Alu_Bgezal: begin
                val0 <= in0 >= 0;
                val1 <= pc + 8;
                baddr <= pc + 4 + ({{16{imm[15]}},imm} << 2);
            end
            `Alu_Bltzal: begin
                val0 <= in0 < 0;
                val1 <= pc + 8;
                baddr <= pc + 4 + ({{16{imm[15]}},imm} << 2);
            end
            `Alu_In1: begin
                val0 <= in1;
                val1 <= 0;
                baddr <= 0;
            end
            `Alu_In0: begin
                val0 <= in0;
                val1 <= 0;
                baddr <= 0;
            end
            `Alu_Slt: begin
                val0 <= $signed(in0) < $signed(in1) ? 1 : 0;
                val1 <= 0;
                baddr <= 0;
            end
        endcase
    end
end

endmodule
