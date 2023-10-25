`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.03.2023 10:57:59
// Design Name: ALU FOR MICROCONTROLLER
// Module Name: ALU
// Name - Kaushal Kumar Kumawat
// Roll No.- 21PHC1R15
//////////////////////////////////////////////////////////////////////////////////


module ALU(Operand1,Operand2,E,Mode,CFlags,Out,Flags);

// Dexlaring the ports and their parameters
input [7:0] Operand1,Operand2;
input E; // Enable input for ALU
input [3:0] Mode; // Selecting the mode of operation (Binary encoding IR[7:4])
input [3:0] CFlags; // Current status of the flags (Z,C,S,O - MSB to LSB format)
output [7:0] Out; // Output of the ALU after performing operation
output [3:0] Flags; // Output of ALU for changing flags (Z,C,S,O - MSB to LSB format)

wire Z,S,O;
reg CarryOut;
reg [7:0] Out_ALU;

always @(*)
if (E == 1)
begin
case(Mode) // IR[7:4] = Mode
    4'b0000:    {CarryOut,Out_ALU} = Operand1 + Operand2; // Addition Operation
    4'b0001:    begin  // SUBAM Operation
                        Out_ALU = Operand1 - Operand2;
                        CarryOut = !Out_ALU[7];
                end 
    4'b0010:    Out_ALU = Operand1; // MOVAM 
    4'b0011:    Out_ALU = Operand2; // MOVMA
    4'b0100:    Out_ALU = Operand1 & Operand2; // Bitwise AND Operation
    4'b0101:    Out_ALU = Operand1 | Operand2; // Bitwise OR Operation
    4'b0110:    Out_ALU = Operand1 ^ Operand2; // Bitwise XOR Operation
    4'b0111:    begin // SUBMA Operation
                        Out_ALU = Operand2 - Operand1;
                        CarryOut = !Out_ALU[7];
                end
    4'b1000:    {CarryOut,Out_ALU} = Operand2 + 8'h1; // INCREAMENT Operation       
    4'b1001:    begin // DECREAMENT Operation 
                        Out_ALU = Operand2 - 8'h1;
                        CarryOut = !Out_ALU[7];
                end
    4'b1010:    Out_ALU = (Operand2 << Operand1[2:0]) | (Operand2 >> Operand1[2:0]); // ROTATE LEFT OPERATION
    4'b1011:    Out_ALU = (Operand2 >> Operand1[2:0]) | (Operand2 << Operand1[2:0]); // ROTATE RIGHT OPERATION
    4'B1100:    Out_ALU = Operand2 << Operand1[2:0]; // SHIFT LEFT LOGICAL OPERATION
    4'b1101:    Out_ALU = Operand2 >> Operand1[2:0]; // SHIFT RIGHT LOGICAL OPERATION
    4'b1110:    Out_ALU = Operand2 >>> Operand1[2:0]; // SHIFT RIGHT ARITHMETIC OPERATION
    4'b1111:    begin // COMPLIMENT OPERATION
                      Out_ALU = 8'h0 - Operand2;
                        CarryOut = !Out_ALU[7];
                end  
    default:    Out_ALU = Operand2;  
                
endcase
end

assign O = Out_ALU[7] ^ Out_ALU[6];
assign Z = (Out_ALU == 0)? 1'b1 : 1'b0;
assign S = Out_ALU[7];
assign Flags = {Z,CarryOut,S,O};
assign Out = Out_ALU;
endmodule
