module cmem_large(q,clk,cen,wen,a,d);
   input clk, cen, wen;
   input [5:0] a;
   input [15:0] d;
   output [15:0] q;

   cmem memory(.Q(q), .CLK(clk), .CEN(cen), .WEN(wen), .A(a), .D(d));
   
endmodule
