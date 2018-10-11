//------------------------------------------------------------------------------
// MIPS register file
//   width: 32 bits
//   depth: 32 words (reg[0] is static zero register)
//   2 asynchronous read ports
//   1 synchronous, positive edge triggered write port
//------------------------------------------------------------------------------

module regfile
(
output[31:0]	ReadData1,	// Contents of first register read
output[31:0]	ReadData2,	// Contents of second register read
input[31:0]	WriteData,	// Contents to write to register
input[4:0]	ReadRegister1,	// Address of first register to read
input[4:0]	ReadRegister2,	// Address of second register to read
input[4:0]	WriteRegister,	// Address of register to write
input		RegWrite,	// Enable writing of register when High
input		Clk		// Clock (Positive Edge Triggered)
);


  wire[31:0] regFile[31:0];
  wire[31:0] decoded;

  assign ReadData1 = regFile[ReadRegister1];
  assign ReadData2 = regFile[ReadRegister2];


  decoder1to32 decoder(.out(decoded), .enable(RegWrite), .address(WriteRegister));

  register32zero register(.q(regFile[0]), .d(WriteData), .wrenable(decoded[0]), .clk(Clk));

  genvar i;
  generate
    for(i=1; i<32; i=i+1) begin
      register32 register(.q(regFile[i]), .d(WriteData), .wrenable(decoded[i]), .clk(Clk));
    end
  endgenerate
endmodule
