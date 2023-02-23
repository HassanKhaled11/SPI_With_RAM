module spi_slave_tb();

reg clk,rst_n,MOSI,SS_n,tx_valid;
reg  [7:0] tx_data;
wire [9:0] rx_data;
wire MISO,rx_valid; 

spi_slave s1(.clk(clk),.rst_n(rst_n),.MOSI(MOSI),
   .SS_n(SS_n),.tx_data(tx_data),.tx_valid(tx_valid),
   .rx_valid(rx_valid),.rx_data(rx_data),.MISO(MISO));


integer i;

initial begin
clk = 0;
forever begin
#1 clk = ~ clk;
end
end

initial begin
SS_n = 1'b0;
MOSI = 1'b0;
rst_n = 0;
#2;
rst_n = 1;
#3
for(i =0 ; i < 12 ; i = i +1)begin
@(negedge clk);
MOSI = $random;
#2;
end

MOSI = 1'b1;
#5;
for(i =0 ; i < 12 ; i = i +1)begin
@(negedge clk);
MOSI = $random;
#2;
end
tx_valid = 1'b1;
tx_data = $random;


end
endmodule
