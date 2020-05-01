module Project (input CLOCK_50, input [9:0] SW, input [1:0] KEY, output reg [6:0] HEX0, output reg [6:0] HEX1, output reg [6:0] HEX2, output reg [6:0] HEX3, output reg [6:0] HEX4, output reg [6:0] HEX5, output reg [9:0] LEDR,
output VGA_CLK, output VGA_HS, output VGA_VS, output VGA_BLANK_N, output VGA_SYNC_N, output [7:0] VGA_R, output [7:0] VGA_G, output [7:0] VGA_B);
 
 
 wire [2:0] colour;
 wire [7:0] x;
 wire [6:0] y;
 wire writeEn;
 
 // Create an Instance of a VGA controller - there can be only one!
 // Define the number of colours as well as the initial background
 // image file (.MIF) for the controller.
 vga_adapter VGA(
   .resetn(KEY[0]),
   .clock(CLOCK_50),
   .colour(colour),
   .x(x),
   .y(y),
   .plot(writeEn),
   /* Signals for the DAC to drive the monitor. */
   .VGA_R(VGA_R),
   .VGA_G(VGA_G),
   .VGA_B(VGA_B),
   .VGA_HS(VGA_HS),
   .VGA_VS(VGA_VS),
   .VGA_BLANK(VGA_BLANK_N),
   .VGA_SYNC(VGA_SYNC_N),
   .VGA_CLK(VGA_CLK));
  defparam VGA.RESOLUTION = "320x240";
  defparam VGA.MONOCHROME = "FALSE";
  defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
  defparam VGA.BACKGROUND_IMAGE = "calculatorbackgroud.mif";
 
wire  [1:0] rowNum;
assign rowNum = SW[5:4];
wire [7:0] element0, element1, element2, element3, element4, element5, element6, element7, element8;
wire [9:0] matrixState;
 
matrixproject P1 (.clk(CLOCK_50), .resetn(KEY[0]), .go(~KEY[1]), .data_in(SW[2:0]), .operation_in(SW[9:8]),  .led(matrixState[9:0]), .alu0_out(element0), .alu1_out(element1), .alu2_out(element2), .alu3_out(element3), .alu4_out(element4), .alu5_out(element5), .alu6_out(element6), .alu7_out(element7), .alu8_out(element8));
 
wire [6:0] hex0, hex1, hex2, hex3, hex4, hex5, hex00, hex11, hex22, hex33, hex44, hex55, hex000, hex111, hex222, hex333, hex444, hex555;
 
hex_decoder  H0 (.hex_digit(element2[3:0]), .segments(hex0));
hex_decoder  H1 (.hex_digit(element2[7:4]), .segments(hex1));
hex_decoder  H2 (.hex_digit(element1[3:0]), .segments(hex2));
hex_decoder  H3 (.hex_digit(element1[7:4]), .segments(hex3));
hex_decoder  H4 (.hex_digit(element0[3:0]), .segments(hex4));
hex_decoder  H5 (.hex_digit(element0[7:4]), .segments(hex5));
                 	 
hex_decoder  H00 (.hex_digit(element5[3:0]), .segments(hex00));
hex_decoder  H11 (.hex_digit(element5[7:4]), .segments(hex11));
hex_decoder  H22 (.hex_digit(element4[3:0]), .segments(hex22));
hex_decoder  H33 (.hex_digit(element4[7:4]), .segments(hex33));
hex_decoder  H44 (.hex_digit(element3[3:0]), .segments(hex44));
hex_decoder  H55 (.hex_digit(element3[7:4]), .segments(hex55));
 
hex_decoder H000 (.hex_digit(element8[3:0]), .segments(hex000));
hex_decoder H111 (.hex_digit(element8[7:4]), .segments(hex111));
hex_decoder H222 (.hex_digit(element7[3:0]), .segments(hex222));
hex_decoder H333 (.hex_digit(element7[7:4]), .segments(hex333));
hex_decoder H444 (.hex_digit(element6[3:0]), .segments(hex444));
hex_decoder H555 (.hex_digit(element6[7:4]), .segments(hex555));
 
wire fracLevel;
assign fracLevel = SW[4];
wire [7:0] numReal, numImag, denomReal, denomImag;
wire [9:0] complexState;
 
complexproject P2 (.clk(CLOCK_50), .resetn(KEY[0]), .go(~KEY[1]), .data_in(SW[2:0]), .operation_in(SW[9:8]),  .led(complexState[9:0]), .alu1_out(numReal), .alu2_out(numImag), .alu3_out(denomReal), .alu4_out(denomImag));
 
wire [6:0] ComplexHex0, ComplexHex1, ComplexHex4, ComplexHex5, ComplexHex00, ComplexHex11, ComplexHex44, ComplexHex55;
 
hex_decoder  H0000 (.hex_digit(numImag[3:0]), .segments(ComplexHex0));
hex_decoder  H1111 (.hex_digit(numImag[7:4]), .segments(ComplexHex1));
hex_decoder  H4444 (.hex_digit(numReal[3:0]), .segments(ComplexHex4));
hex_decoder  H5555 (.hex_digit(numReal[7:4]), .segments(ComplexHex5));
                 	 
hex_decoder  H00000 (.hex_digit(denomImag[3:0]), .segments(ComplexHex00));
hex_decoder  H11111 (.hex_digit(denomImag[7:4]), .segments(ComplexHex11));
hex_decoder  H44444 (.hex_digit(denomReal[3:0]), .segments(ComplexHex44));
hex_decoder  H55555 (.hex_digit(denomReal[7:4]), .segments(ComplexHex55));
 
             	always@(*) begin
                       	case (SW[3])
                               	1'b0: begin
                        	LEDR <= matrixState;
                         	case (rowNum)
                   	 2'b00: begin
                    	 HEX0 <= hex0;
                    	 HEX1 <= hex1;
                    	 HEX2 <= hex2;
                    	 HEX3 <= hex3;
                    	 HEX4 <= hex4;
                    	 HEX5 <= hex5;
                        	 end
                    	2'b01: begin
                    	 HEX0 <= hex00;
                    	 HEX1 <= hex11;
                    	 HEX2 <= hex22;
                    	 HEX3 <= hex33;
                    	 HEX4 <= hex44;
                    	 HEX5 <= hex55;
                        	 end
                   	 2'b10: begin	 
                    	 HEX0 <= hex000;
                    	 HEX1 <= hex111;
                    	 HEX2 <= hex222;
                    	 HEX3 <= hex333;
                    	 HEX4 <= hex444;
                    	 HEX5 <= hex555;
                        	 end
                    	default: begin
  	           	  HEX0 <= hex0;
                    	 HEX1 <= hex1;
                    	 HEX2 <= hex2;
                    	 HEX3 <= hex3;
                    	 HEX4 <= hex4;
                    	 HEX5 <= hex5;
              	 end
                         	endcase
                         	end
 
                         	1'b1: begin
                        	LEDR <= complexState;
                         	case (fracLevel)
                   	 1'b0: begin
                    	 HEX0 <= ComplexHex0;
                    	 HEX1 <= ComplexHex1;
         HEX2 <= 7'b1111111;
         HEX3 <= 7'b1111111;
                    	 HEX4 <= ComplexHex4;
                    	 HEX5 <= ComplexHex5;
                        	 end
                    	 1'b1: begin
                    	 HEX0 <= ComplexHex00;
                    	 HEX1 <= ComplexHex11;
         HEX2 <= 7'b1111111;
         HEX3 <= 7'b1111111;
                    	 HEX4 <= ComplexHex44;
                    	 HEX5 <= ComplexHex55;
                        	 end
                        	 default: begin
  	           	  HEX0 <= ComplexHex0;
                    	 HEX1 <= ComplexHex1;
     	   HEX2 <= 7'b1111111;
         HEX3 <= 7'b1111111;
                    	 HEX4 <= ComplexHex4;
                    	 HEX5 <= ComplexHex5;
              	 end
                	 endcase
             	end
  
                         	endcase
                         	end
endmodule
     	 
 
 
 
module  matrixproject(
 input clk,
 input resetn,
 input go,
 input [2:0] data_in,
 input [1:0] operation_in,
 output [9:0] led,
 output [7:0] alu0_out, alu1_out, alu2_out, alu3_out, alu4_out, alu5_out, alu6_out, alu7_out, alu8_out
 );
 
wire row0el0, row0el1, row0el2, row1el0, row1el1, row1el2, row2el0, row2el1, row2el2, row0el10, row0el11, row0el12, row1el10, row1el11, row1el12, row2el10, row2el11, row2el12;
wire opMSel;
wire compute;
 
control C1 (
.clk(clk),
.resetn(resetn),
.go(go),
.row0el0(row0el0),
.row0el1(row0el1),
.row0el2(row0el2),
.row1el0(row1el0),
.row1el1(row1el1),
.row1el2(row1el2),
.row2el0(row2el0),
.row2el1(row2el1),
.row2el2(row2el2),
.row0el10(row0el10),
.row0el11(row0el11),
.row0el12(row0el12),
.row1el10(row1el10),
.row1el11(row1el11),
.row1el12(row1el12),
.row2el10(row2el10),
.row2el11(row2el11),
.row2el12(row2el12),
.opMSel(opMSel),
.compute(compute));
 
 
datapath D1(
 .clk(clk),
 .resetn(resetn),
 .operation(operation_in),
 .data_in(data_in),
 .row0el0(row0el0),
 .row0el1(row0el1),
 .row0el2(row0el2),
 .row1el0(row1el0),
 .row1el1(row1el1),
 .row1el2(row1el2),
 .row2el0(row2el0),
 .row2el1(row2el1),
 .row2el2(row2el2),
 .row0el10(row0el10),
 .row0el11(row0el11),
 .row0el12(row0el12),
 .row1el10(row1el10),
 .row1el11(row1el11),
 .row1el12(row1el12),
 .row2el10(row2el10),
 .row2el11(row2el11),
 .row2el12(row2el12),
 .opMSel(opMSel),
  .compute(compute),
 .led(led),
 .alu0_out(alu0_out), .alu1_out(alu1_out), .alu2_out(alu2_out), .alu3_out(alu3_out), .alu4_out(alu4_out), .alu5_out(alu5_out), .alu6_out(alu6_out), .alu7_out(alu7_out), .alu8_out(alu8_out));
 
endmodule
 
 
 
module complexproject(input clk,
 input resetn,
 input go,
 input [2:0] data_in,
 input [1:0] operation_in,
 output [9:0] led,
 output [7:0] alu1_out, alu2_out, alu3_out, alu4_out
 );
 
 wire Re1, Im1, Re2, Im2, opCSel, compute; 
 complexControlPath C1 (.clk(clk), .resetn(resetn), .go(go), .Re1(Re1), .Im1(Im1), .Re2(Re2), .Im2(Im2), .opCSel(opCSel), .compute(compute) );
 complexDataPath D1 ( .clk(clk), .resetn(resetn), .operation(operation_in), .data_in(data_in), .Re1(Re1), .Re2(Re2), .Im1(Im1), .Im2(Im2), .opCSel(opCSel), .compute(compute), .led(led), .alu1_out(alu1_out), .alu2_out(alu2_out), .alu3_out(alu3_out), .alu4_out(alu4_out) );
 
endmodule
 
module control(
input clk,
input resetn,
input go,
output reg row0el0,
output reg row0el1,
output reg row0el2,
output reg row1el0,
output reg row1el1,
output reg row1el2,
output reg row2el0,
output reg row2el1,
output reg row2el2,
output reg row0el10,
output reg row0el11,
output reg row0el12,
output reg row1el10,
output reg row1el11,
output reg row1el12,
output reg row2el10,
output reg row2el11,
output reg row2el12,
output reg opMSel,
output reg compute);
 
 
 reg [6:0] current_state;
 reg [6:0] next_state;
 
 
localparam	 row000 = 6'd0,
 
   Wait3 = 6'd1,
   Wait4 = 6'd2,
   row001 = 6'd3,
   Wait5 = 6'd4,
   row002 = 6'd5,
   Wait6 = 6'd6,
   row010 = 6'd7,
   Wait7 = 6'd8,
   row011 = 6'd9,
   Wait8 = 6'd10,
   row012 = 6'd11,
   Wait9 = 6'd12,
   row020 = 6'd13,
   Wait10 = 6'd14,
   row021 = 6'd15,
   Wait11 = 6'd16,
   row022 = 6'd17,
   row100 = 6'd18,
   Wait12 = 6'd19,
   row101 = 6'd20,
   Wait13 = 6'd21,
   row102 = 6'd22,
   Wait14 = 6'd23,
 
   row110 = 6'd24,
   Wait15 = 6'd25,
   row111 = 6'd26,
   Wait16 = 6'd27,
   row112 = 6'd28,
   Wait17 = 6'd29,
 
   row120 = 6'd30,
   Wait18 = 6'd31,
   row121 = 6'd32,
   Wait19 = 6'd33,
   row122 = 6'd34,
   Wait20 = 6'd35,
   opM = 6'd36,
 
   Wait21 = 6'd37,
   //CYCLE_0 = 6'd38,
   display = 6'd38;
	 
 
// Next state logic aka our state table
always @(*)
begin : state_table        	 
 case (current_state)
	 row000: next_state = go ? Wait3  : row000;
	 Wait3:  next_state = go ? Wait3  : row001;
	 row001: next_state = go ? Wait4  : row001;
	 Wait4:  next_state = go ? Wait4  : row002;
	 row002: next_state = go ? Wait5  : row002;
	 Wait5:  next_state = go ? Wait5  : row010;
	 row010: next_state = go ? Wait6  : row010;
	 Wait6:  next_state = go ? Wait6  : row011;
	 row011: next_state = go ? Wait7  : row011;
	 Wait7:  next_state = go ? Wait7  : row012;
	 row012: next_state = go ? Wait8  : row012;
	 Wait8:  next_state = go ? Wait8  : row020;
	 row020: next_state = go ? Wait9  : row020;
	 Wait9:  next_state = go ? Wait9  : row021;
	 row021: next_state = go ? Wait10 : row021;
	 Wait10: next_state = go ? Wait10 : row022;
	 row022: next_state = go ? Wait11 : row022;
	 Wait11: next_state = go ? Wait11 : row100;
	 row100: next_state = go ? Wait12 : row100;
	 Wait12: next_state = go ? Wait12 : row101;
	 row101: next_state = go ? Wait13 : row101;
	 Wait13: next_state = go ? Wait13 : row102;
	 row102: next_state = go ? Wait14 : row102;
	 Wait14: next_state = go ? Wait14 : row110;
	 row110: next_state = go ? Wait15 : row110;
	 Wait15: next_state = go ? Wait15 : row111;
	 row111: next_state = go ? Wait16 : row111;
	 Wait16: next_state = go ? Wait16 : row112;
	 row112: next_state = go ? Wait17 : row112;
	 Wait17: next_state = go ? Wait17 : row120;
	 row120: next_state = go ? Wait18 : row120;
	 Wait18: next_state = go ? Wait18 : row121;
	 row121: next_state = go ? Wait19 : row121;
	 Wait19: next_state = go ? Wait19 : row122;
	 row122: next_state = go ? Wait20 : row122;
	 Wait20: next_state = go ? Wait20 : opM;
	 opM: next_state = go ? Wait21 : opM;
	 Wait21: next_state = go ? Wait21 : display;
	 //CYCLE_0: next_state = display;
	 display: next_state = row000;	 
 default:    next_state = row000;
 endcase  
end
 
 
 
// Output logic aka all of our datapath control signals
 always @(*)
 begin : enable_signals
	 // By default make all our signals 0 to avoid latches.
	 // This is a different style from using a default statement.
	 // It makes the code easier to read.  If you add other out
	 // signals be sure to assign a default value for them here.
 
 row0el0 = 0;
 row0el1 = 0;
 row0el2 = 0;
 row1el0 = 0;
 row1el1 = 0;
 row1el2 = 0;
 row2el0 = 0;
 row2el1 = 0;
 row2el2 = 0;
 row0el10 = 0;
 row0el11 = 0;
 row0el12 = 0;
 row1el10 = 0;
 row1el11 = 0;
 row1el12 = 0;
 row2el10 = 0;
 row2el11 = 0;
 row2el12 = 0;
 opMSel = 0;
  compute = 0;
 
 
	 case (current_state)
    	 row000: begin
        	 row0el0 = 1'b1;
    	 end
    	 row001: begin
        	 row0el1 = 1'b1;
    	 end
    	 row002: begin
        	 row0el2 = 1'b1;
    	 end
    	 row010: begin
        	 row1el0 = 1'b1;
    	 end
    	 row011: begin
        	 row1el1 = 1'b1;
    	 end
    	 row012: begin
        	 row1el2 = 1'b1;
    	 end
    	 row020: begin
        	 row2el0 = 1'b1;
    	 end
    	 row021: begin
        	 row2el1 = 1'b1;
    	 end
    	 row022: begin
        	 row2el2 = 1'b1;
    	 end
    	 row100: begin
        	 row0el10 = 1'b1;
    	 end
    	 row101: begin
        	 row0el11 = 1'b1;
    	 end
    	 row102: begin
        	 row0el12 = 1'b1;
    	 end
    	 row110: begin
        	 row1el10 = 1'b1;
    	 end
    	 row111: begin
        	 row1el11 = 1'b1;
    	 end
    	 row112: begin
        	 row1el12 = 1'b1;
    	 end
    	 row120: begin
        	 row2el10 = 1'b1;
    	 end
    	 row121: begin
        	 row2el11 = 1'b1;
    	 end
    	 row122: begin
        	 row2el12 = 1'b1;
    	 end
    	 opM: begin
        	 opMSel = 1'b1;
    	 end
    	 //CYCLE_0: begin
     	 //compute = 1'b1;
    	 //end
    	 display: begin
    	 compute = 1'b1;
   	 end
   	 endcase
    end
 
 // current_state registers
 always@(posedge clk)
 begin: state_FFs
	 if (!resetn)
    	 current_state <= row000; //go back to beginning
	 else
    	 current_state <= next_state;
 end // state_FFS
endmodule
 
 
module datapath(
 input clk,
 input resetn,
 input [1:0] operation,
 input [2:0] data_in,
 input row0el0,
 input row0el1,
 input row0el2,
 input row1el0,
 input row1el1,
 input row1el2,
 input row2el0,
 input row2el1,
 input row2el2,
 input row0el10,
 input row0el11,
 input row0el12,
 input row1el10,
 input row1el11,
 input row1el12,
 input row2el10,
 input row2el11,
 input row2el12,
 input opMSel,
   input compute,
 output reg [9:0] led,
 output  reg [7:0] alu0_out, alu1_out, alu2_out, alu3_out, alu4_out, alu5_out, alu6_out, alu7_out, alu8_out
 );
 
 // input registers
reg [2:0] Matrix0element0, Matrix0element1, Matrix0element2, Matrix0element3, Matrix0element4, Matrix0element5, Matrix0element6, Matrix0element7, Matrix0element8, Matrix1element0, Matrix1element1, Matrix1element2, Matrix1element3, Matrix1element4, Matrix1element5, Matrix1element6, Matrix1element7, Matrix1element8;
 
//operation to be performed
reg [1:0] opM;
 
 
 // Registers with respective input logic
 always@(posedge clk) begin: register
   if(!resetn) begin
   Matrix0element0 <= 0;
   Matrix0element1 <= 0;
   Matrix0element2 <= 0;
   Matrix0element3 <= 0;
   Matrix0element4 <= 0;              	 
   Matrix0element5 <= 0;
   Matrix0element6 <= 0;
   Matrix0element7 <= 0;
   Matrix0element8 <= 0;
   Matrix1element0 <= 0;
   Matrix1element1 <= 0;
   Matrix1element2 <= 0;
   Matrix1element3 <= 0;
   Matrix1element4 <= 0;
   Matrix1element5 <= 0;
   Matrix1element6 <= 0;
   Matrix1element7 <= 0;
   Matrix1element8 <= 0;
 led <= 10'b0;
	 end
	 else begin
       	 if (row0el0)
  begin
          	 Matrix0element0 <= data_in;
  led <= 10'd0;
  end
       	 if (row0el1)
  begin
          	 Matrix0element1 <= data_in;
  led <= 10'd1;
  end
       	 if (row0el2)
  begin
          	 Matrix0element2 <= data_in;
  led <= 10'd2;
  end  
       	 if (row1el0)
  begin
          	 Matrix0element3 <= data_in;
  led <= 10'd3;
  end
       	 if (row1el1)
  begin
          	 Matrix0element4 <= data_in;
  led <= 10'd4;
     	end  	 
       	 if (row1el2)
  begin
          	 Matrix0element5 <= data_in;
  led <= 10'd5;
  end     	 
       	 if (row2el0)
  begin                                        	 
          	 Matrix0element6 <= data_in;
  led <= 10'd6;
  end       	 
       	 if (row2el1) 	
  begin                       	 
          	 Matrix0element7 <= data_in;
  led <= 10'd7;
  end
       	 if (row2el2)	
  begin                              	 
          	 Matrix0element8 <= data_in;
  led <= 10'd8;
  end
       	 if (row0el10) 
  begin
          	 Matrix1element0 <= data_in;
  led <= 10'd9;
  end
       	 if (row0el11)
  begin
          	 Matrix1element1 <= data_in;
  led <= 10'd10;
  end
       	 if (row0el12)
  begin
          	 Matrix1element2 <= data_in;
  led <= 10'd11;
  end
       	 if (row1el10)
  begin
          	 Matrix1element3 <= data_in;
  led <= 10'd12;
  end
       	 if (row1el11)
  begin
          	 Matrix1element4 <= data_in;
  led <= 10'd13;
  end
       	 if (row1el12)
  begin
          	 Matrix1element5 <= data_in; 
  led <= 10'd14;
  end 
       	 if (row2el10)
  begin
          	 Matrix1element6 <= data_in;
  led <= 10'd15;
  end
       	 if (row2el11)
  begin
          	 Matrix1element7 <= data_in;
  led <= 10'd16;
  end
       	 if (row2el12)
  begin
          	 Matrix1element8 <= data_in;
  led <= 10'd17;
  end
   	 end
end
 // Registers with respective input logic for operation
 always@ (posedge clk) begin: x
   if(!resetn)
	 opM <= 2'b00; //addition by default
 else begin
    if (opMSel) begin
  	 
  opM <= operation;
  //led <= 10'd1023;
	end
   end
end
 
wire [7:0] alu0wire, alu1wire, alu2wire, alu3wire, alu4wire, alu5wire, alu6wire, alu7wire, alu8wire;
 
//The 9 ALUs for each element in the resulting matrix of the computation
 
//alu0_out (first element of resulting matrix)
ALU alu0 (Matrix0element0, Matrix1element0, Matrix0element0, Matrix1element0, Matrix0element1, Matrix1element3, Matrix0element2, Matrix1element6, Matrix0element0, Matrix0element1, Matrix0element2, Matrix1element0, Matrix1element1, Matrix1element2, opM, alu0wire);
 
//alu1_out (second element of resulting matrix)
ALU alu1 (Matrix0element1, Matrix1element1, Matrix0element0, Matrix1element1, Matrix0element1, Matrix1element4, Matrix0element2, Matrix1element7, Matrix0element0, Matrix0element1, Matrix0element2, Matrix1element0, Matrix1element1, Matrix1element2, opM, alu1wire);
 
//alu2_out (third element of resulting matrix)
ALU alu2 (Matrix0element2, Matrix1element2, Matrix0element0, Matrix1element2, Matrix0element1, Matrix1element5, Matrix0element2, Matrix1element8, Matrix0element0, Matrix0element1, Matrix0element2, Matrix1element0, Matrix1element1, Matrix1element2, opM, alu2wire);
 
//alu3_out (fourth element of resulting matrix)
ALU alu3 (Matrix0element3, Matrix1element3, Matrix0element3, Matrix1element0, Matrix0element4, Matrix1element3, Matrix0element5, Matrix1element6, Matrix0element0, Matrix0element1, Matrix0element2, Matrix1element0, Matrix1element1, Matrix1element2, opM, alu3wire);
 
//alu4_out (fifth element of resulting matrix)
ALU alu4 (Matrix0element4, Matrix1element4, Matrix0element3, Matrix1element1, Matrix0element4, Matrix1element4, Matrix0element5, Matrix1element7, Matrix0element0, Matrix0element1, Matrix0element2, Matrix1element0, Matrix1element1, Matrix1element2, opM, alu4wire);
 
//alu5_out (sixth element of resulting matrix)
ALU alu5 (Matrix0element5, Matrix1element5, Matrix0element3, Matrix1element2, Matrix0element4, Matrix1element5, Matrix0element5, Matrix1element8, Matrix0element0, Matrix0element1, Matrix0element2, Matrix1element0, Matrix1element1, Matrix1element2, opM, alu5wire);
 
//alu6_out (seventh element of resulting matrix)
ALU alu6 (Matrix0element6, Matrix1element6, Matrix0element6, Matrix1element0, Matrix0element7, Matrix1element3, Matrix0element8, Matrix1element6, Matrix0element0, Matrix0element1, Matrix0element2, Matrix1element0, Matrix1element1, Matrix1element2, opM, alu6wire);
 
//alu7_out (eighth element of resulting matrix)
ALU alu7 (Matrix0element7, Matrix1element7, Matrix0element6, Matrix1element1, Matrix0element7, Matrix1element4, Matrix0element8, Matrix1element7, Matrix0element0, Matrix0element1, Matrix0element2, Matrix1element0, Matrix1element1, Matrix1element2, opM, alu7wire);
 
//alu8_out (ninth element of resulting matrix)
ALU alu8 (Matrix0element8, Matrix1element8, Matrix0element6, Matrix1element2, Matrix0element7, Matrix1element5, Matrix0element8, Matrix1element8, Matrix0element0, Matrix0element1, Matrix0element2, Matrix1element0, Matrix1element1, Matrix1element2, opM, alu8wire);
 
always@(posedge clk) begin
   if (!resetn)
  begin
	 alu0_out <= 8'b0000000;
	 alu1_out <= 8'b0000000;
	 alu2_out <= 8'b0000000;
	 alu3_out <= 8'b0000000;
	 alu4_out <= 8'b0000000;
	 alu5_out <= 8'b0000000;
	 alu6_out <= 8'b0000000;
	 alu7_out <= 8'b0000000;
	 alu8_out <= 8'b0000000;
   end
   if (compute)
  begin
   alu0_out <= alu0wire;
	 alu1_out <= alu1wire;
	 alu2_out <= alu2wire;
	 alu3_out <= alu3wire;
	 alu4_out <= alu4wire;
	 alu5_out <= alu5wire;
	 alu6_out <= alu6wire;
	 alu7_out <= alu7wire;
	 alu8_out <= alu8wire;
 end
end  	 
endmodule
 
module ALU (input [2:0] el0, input [2:0] el1, input [2:0] el2, input [2:0] el3, input [2:0] el4, input [2:0] el5, input [2:0] el6, input [2:0] el7,
input [2:0] vector0el0, input [2:0] vector0el1, input [2:0] vector0el2, input [2:0] vector1el0, input [2:0] vector1el1, input [2:0] vector1el2,
input [1:0] operation, output reg [7:0] alu_out);
 
 always @(*) begin
	 case (operation)
    	 2'b00: alu_out <= el0 + el1; //performs addition
 
    	 2'b01: alu_out <= el0 - el1; //performs subtraction
 
    	 2'b10: alu_out <= (el2*el3) + (el4*el5) + (el6*el7); //performs multiplication
	
	
	
	2'b11: alu_out <= (vector0el0*vector1el0) + (vector0el1*vector1el1) + (vector0el2*vector1el2); //dot product of two top rows
   
    	 default: alu_out <= 8'b00000000;
	 endcase
 end
endmodule
 
 
 
module complexControlPath (
input clk,
input resetn,
input go,
output reg Re1,
output reg Im1,
output reg Re2,
output reg Im2,
output reg opCSel,
output reg compute);
 
reg [3:0] current_state;
reg [3:0] next_state;
 
 
localparam	 real1 = 4'd0,
  Wait1 = 4'd1,
    imag1 = 4'd2,
    Wait2 = 4'd3,
    real2 = 4'd4,
    Wait3 = 4'd5,
    imag2 = 4'd6,
    Wait4 = 4'd7,
    opC = 4'd8,
    Wait5 = 4'd9,
    display = 4'd10;
	 
// Next state logic aka our state table
always @(*)
begin : state_table        	 
 case (current_state)
	 real1: next_state = go ? Wait1  :  real1;
	 Wait1:  next_state = go ? Wait1  : imag1;
	 imag1: next_state = go ? Wait2  : imag1;
	 Wait2:  next_state = go ? Wait2  : real2 ;
	 real2: next_state = go ? Wait3  : real2;
	 Wait3:  next_state = go ? Wait3  : imag2;
	 imag2: next_state = go ? Wait4  : imag2;
	 Wait4:  next_state = go ? Wait4  : opC;
	 opC: next_state = go ? Wait5  : opC;
	 Wait5:  next_state = go ? Wait5  : display;
	 display: next_state = real1;	 
 default:    next_state = real1;
 endcase  
end
 
 
 
// Output logic aka all of our datapath control signals
 always @(*)
 begin : enable_signals
	 // By default make all our signals 0 to avoid latches.
	 // This is a different style from using a default statement.
	 // It makes the code easier to read.  If you add other out
	 // signals be sure to assign a default value for them here.
 
 Re1 = 0;
 Re2 = 0;
 Im1 = 0;
 Im2 = 0;
 opCSel = 0;
 compute = 0; 
 
	 case (current_state)
    	 real1: begin
        	 Re1 = 1'b1;
    	 end
    	 real2: begin
        	 Re2 = 1'b1;
    	 end
    	 imag1: begin
        	 Im1 = 1'b1;
    	 end
    	 imag2: begin
        	 Im2 = 1'b1;
    	 end
    	 opC: begin
        	 opCSel = 1'b1;
    	 end
    	 display: begin
     compute = 1'b1;
   	 end
   	 endcase
    end
 
 // current_state registers
 always@(posedge clk)
 begin: state_FFs
	 if (!resetn)
    	 current_state <= real1; //go back to beginning
	 else
    	 current_state <= next_state;
 end // state_FFS
endmodule
 
 
 
module complexDataPath (
 input clk,
 input resetn,
 input [1:0] operation,
 input [2:0] data_in,
 input Re1,
 input Re2,
 input Im1,
 input Im2,
 input opCSel,
   input compute,
 output reg [9:0] led,
 output  reg [7:0] alu1_out, alu2_out, alu3_out, alu4_out);
 
 // input registers
reg [2:0] realComp1, realComp2, imagComp1, imagComp2;
 
//operation to be performed
reg [1:0] opC;
 
 
 // Registers with respective input logic
 always@(posedge clk) begin: register
   if(!resetn) begin
   realComp1<= 0;
   imagComp1 <= 0;
   realComp2 <= 0;
   imagComp2 <= 0;
 
 led <= 0;
	 end
	 else begin
       	 if (Re1)
        	begin
    realComp1 <= data_in;
    led <= 10'd0;
    end
       	 if (Im1)
    begin
    imagComp1 <= data_in;
    led <= 10'd1;
    end
       	 if (Re2)
        	begin
    realComp2 <= data_in;
    led <= 10'd2;
    end  
       	 if (Im2)
        	begin
    imagComp2 <= data_in;
    led <= 10'd3;
    end
   	end
end
 
 // Registers with respective input logic for operation
 always@ (posedge clk) begin: x
   if(!resetn)
	 opC <= 2'b00; //addition by default
 else begin
   if (opCSel)
  	 begin
   opC <= operation;
   //led <= 10'b1111111111;
   end
 	end
end
 
wire [7:0] alu1wire, alu2wire, alu3wire, alu4wire;
 
//The ALUs to calculate each new number based on the operation
 
complexALU alu1 (realComp1, imagComp1, realComp2, imagComp2, opC, alu1wire, alu2wire, alu3wire, alu4wire);
 
 
always@(posedge clk) begin
   if (!resetn)
  begin
	 alu1_out <= 8'b00000000;
	 alu2_out <= 8'b00000000;
	 alu3_out <= 8'b00000000;
	 alu4_out <= 8'b00000000; 
   end
   if (compute)
  begin
	 alu1_out <= alu1wire;
	 alu2_out <= alu2wire;
	 alu3_out <= alu3wire;
	 alu4_out <= alu4wire; 
 end
end  	 
endmodule
 
 
 
module complexALU (input [2:0] realComp1, input [2:0] imagComp1, input [2:0] realComp2, input [2:0] imagComp2, input [1:0] opC, output reg [7:0] alu_out1, output reg [7:0] alu_out2, output reg [7:0] alu_out3, output reg [7:0] alu_out4);
 
 always @(*) begin
	 case (opC)
    	 2'b00:  begin
   alu_out1 <= realComp1 + realComp2; //performs addition
   alu_out2 <= imagComp1 + imagComp2;
   alu_out3 <= 8'd1;
   alu_out4 <= 8'd0;
   
    end
    	 
  2'b01:  begin
   alu_out1 <= realComp1 - realComp2; //performs subtraction
   alu_out2 <= imagComp1 - imagComp2;
    alu_out3 <= 8'd1;
   alu_out4 <= 8'd0;
   end
 
  	2'b10:  begin
 	alu_out1 <= (realComp1*realComp2) - (imagComp1*imagComp2); //performs multiplication
   alu_out2 <= (realComp2*imagComp1) + (realComp1*imagComp2);
    alu_out3 <= 8'd1;
   alu_out4 <= 8'd0;
   end
	  
  2'b11:  begin
   alu_out1 <= (realComp1*realComp2) + (imagComp1*imagComp2); //performs division
   alu_out2 <= (realComp2*imagComp1) - (realComp1*imagComp2);
    alu_out3 <= (realComp2*realComp2) + (imagComp2*imagComp2);
   alu_out4 <= 8'd0;
   end
 
    	 default: begin
	alu_out1 <= 8'b00000000;
	alu_out2 <= 8'b00000000;
	alu_out3 <= 8'b00000000;
	alu_out4 <= 8'b00000000;
	end
	 endcase
 end
endmodule
 
 
 
 
module hex_decoder (hex_digit, segments);
 input [3:0] hex_digit;
 output reg [6:0] segments;
 
 always @(*) begin: y
	 case (hex_digit)
    	 4'h0: segments = 7'b100_0000;
    	 4'h1: segments = 7'b111_1001;
    	 4'h2: segments = 7'b010_0100;
    	 4'h3: segments = 7'b011_0000;
    	 4'h4: segments = 7'b001_1001;
    	 4'h5: segments = 7'b001_0010;
    	 4'h6: segments = 7'b000_0010;
    	 4'h7: segments = 7'b111_1000;
    	 4'h8: segments = 7'b000_0000;
    	 4'h9: segments = 7'b001_1000;
    	 4'hA: segments = 7'b000_1000;
    	 4'hB: segments = 7'b000_0011;
    	 4'hC: segments = 7'b100_0110;
    	 4'hD: segments = 7'b010_0001;
    	 4'hE: segments = 7'b000_0110;
    	 4'hF: segments = 7'b000_1110;
    	 default: segments = 7'h7f;
	 endcase
 end
endmodule
 
 
 
 
 
 
