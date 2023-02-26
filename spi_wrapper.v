module spi_wrapper #(parameter  MEM_DEPTH = 'd256 , parameter ADDR_SIZE = 'd8)(
input  top_clk,
input  top_rst_n,
input  top_MOSI,
input  top_SS_n,

output top_MISO 
);


wire       top_tx_valid, top_rx_valid ;   
wire [7:0] top_tx_data;
wire [9:0] top_rx_data;

spi_slave S(.clk(top_clk) ,.rst_n(top_rst_n) , .MOSI(top_MOSI) , .SS_n(top_SS_n) ,
            .tx_valid(top_tx_valid) , .tx_data(top_tx_data) , .rx_valid(top_rx_valid) , .rx_data(top_rx_data) , .MISO(top_MISO));




RAM #(.MEM_DEPTH(MEM_DEPTH),.ADDR_SIZE(ADDR_SIZE)) R(.clk(top_clk),.rst_n(top_rst_n),
	.rx_valid(top_rx_valid),.din(top_rx_data),.dout(top_tx_data),.tx_valid(top_tx_valid));




endmodule