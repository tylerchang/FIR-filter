/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : U-2022.12-SP7
// Date      : Sat Nov 23 16:46:09 2024
/////////////////////////////////////////////////////////////


module cmem_large ( q, clk, cen, wen, a, d );
  output [15:0] q;
  input [5:0] a;
  input [15:0] d;
  input clk, cen, wen;
  wire   n1, n2, n3, n4, n5, n6, n7, n8;

  cmem memory ( .Q(q), .A({n7, n6, n5, n4, n3, n2}), .D(d), .CLK(clk), .CEN(n1), .WEN(n8) );
  CLKBUFX2TS U1 ( .A(a[4]), .Y(n6) );
  CLKBUFX2TS U2 ( .A(a[3]), .Y(n5) );
  CLKBUFX2TS U3 ( .A(cen), .Y(n1) );
  CLKBUFX2TS U4 ( .A(a[0]), .Y(n2) );
  CLKBUFX2TS U5 ( .A(a[5]), .Y(n7) );
  CLKBUFX2TS U6 ( .A(wen), .Y(n8) );
  CLKBUFX2TS U7 ( .A(a[2]), .Y(n4) );
  CLKBUFX2TS U8 ( .A(a[1]), .Y(n3) );
endmodule

