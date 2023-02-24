module Ram_tb();

parameter MEM_DEPTH = 256 ;
parameter ADDR_SIZE = 8;
reg clk,rst_n,rx_valid;
reg  [9:0] din;
wire [7:0] dout;
wire tx_valid;

RAM #(.MEM_DEPTH(MEM_DEPTH),.ADDR_SIZE(ADDR_SIZE)) myRam (.clk(clk),.rst_n(rst_n),.rx_valid(rx_valid),.din(din),.dout(dout),.tx_valid(tx_valid));


initial begin
clk = 0;
	forever begin
	#1 clk = ~clk;	
	end
end


initial begin
$readmemb ("mem.dat.txt",myRam.ram_mem);
end

initial begin
din =0;
rx_valid =0; 
rst_n = 0;
#4;
rst_n =1;
#2;

// write in memory operation
din = 10'b0010010110 ;
#3;
rx_valid = 1;
#5;
din = 10'b0101011011 ;

// read from memory operation
#4
din = 10'b1010101110 ;
#8;
din = 10'b1101010101 ; 
#4;
//rst_n = 0;


end

endmodule
