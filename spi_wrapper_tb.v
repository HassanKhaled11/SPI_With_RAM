module spi_wrapper_tb();

parameter top_MEM_DEPTH = 256;
parameter top_ADDR_SIZE = 8;

reg  top_clk_tb, top_rst_n_tb, top_MOSI_tb, top_SS_n_tb ;
wire top_MISO_tb;


spi_wrapper #(.MEM_DEPTH(top_MEM_DEPTH) ,.ADDR_SIZE(top_ADDR_SIZE)) SW (.top_clk(top_clk_tb) ,
              .top_rst_n(top_rst_n_tb) , .top_MOSI(top_MOSI_tb), .top_SS_n(top_SS_n_tb) ,.top_MISO(top_MISO_tb));

integer i;

initial begin
top_clk_tb = 0;

forever begin
#1 top_clk_tb = ~ top_clk_tb; 
end
end



initial begin
$readmemb ("mem.dat.txt",SW.R.ram_mem);
end
 

initial begin 
top_rst_n_tb = 0;
#3;
top_rst_n_tb = 1;
end


initial begin

// Address  for the write operation  (0011000110)    198 
  
top_SS_n_tb = 1'b0;  
top_MOSI_tb = 1'b0;
#8;
top_MOSI_tb = 1'b0;
#2;
top_MOSI_tb = 1'b1;
#2;
top_MOSI_tb = 1'b1;          
#2;
top_MOSI_tb = 1'b0;          //0010101010    location 170
#2;
top_MOSI_tb = 1'b0;
#2;
top_MOSI_tb = 1'b0;
#2;
top_MOSI_tb = 1'b1;
#2;
top_MOSI_tb = 1'b1;
#2;
top_MOSI_tb = 1'b0;
#2;
top_MOSI_tb = 1'b0;
#6;

//------ Write data 10001111 in location 198 ----------

top_MOSI_tb = 1'b1;
#2;
top_MOSI_tb = 1'b1;                 
#2;
top_MOSI_tb = 1'b1;                
#2;
top_MOSI_tb = 1'b1;
#2;
top_MOSI_tb = 1'b0;
#2;
top_MOSI_tb = 1'b0;
#2;
top_MOSI_tb = 1'b0;
#2;
top_MOSI_tb = 1'b1;
#2;
top_MOSI_tb = 1'b1;
#2;
top_MOSI_tb = 1'b0;
#1;

//---------- Read from location 198--------------

top_MOSI_tb = 1'b1;
#6;
top_MOSI_tb = 1'b0;
#2;
top_MOSI_tb = 1'b1;
#2;
top_MOSI_tb = 1'b0;           //1011000110      location priveously prevoiusly filled in write op
#2;
top_MOSI_tb = 1'b1;          
#2;
top_MOSI_tb = 1'b0;           //1010101010         location 170 
#2;
top_MOSI_tb = 1'b1;
#2;
top_MOSI_tb = 1'b0;
#2;
top_MOSI_tb = 1'b1;
#2;
top_MOSI_tb = 1'b0;
#2;
top_MOSI_tb = 1'b1;


//-------------Read Data----------------

top_MOSI_tb = 1'b0;
#6;
top_MOSI_tb = 1'b1;
#2;
top_MOSI_tb = 1'b1;
#2;
top_MOSI_tb = 1'b0;
#2;
top_MOSI_tb = 1'b0;
#2;
top_MOSI_tb = 1'b0;
#2;
top_MOSI_tb = 1'b1;
#2;
top_MOSI_tb = 1'b0;
#2;
top_MOSI_tb = 1'b1;
#2;
top_MOSI_tb = 1'b1;
#6;


/*#50;
top_SS_n_tb = 1'b1;
#10;
top_SS_n_tb = 1'b0;


//------------------------------ TestCase 2-----------------------

// ----Address  for the write operation 0011000110 (198)---
  
top_MOSI_tb = 1'b0;
#8;
top_MOSI_tb = 1'b0;
#2;
top_MOSI_tb = 1'b1;
#2;
top_MOSI_tb = 1'b1;          
#2;
top_MOSI_tb = 1'b0;          
#2;
top_MOSI_tb = 1'b0;
#2;
top_MOSI_tb = 1'b0;
#2;
top_MOSI_tb = 1'b1;
#2;
top_MOSI_tb = 1'b1;
#2;
top_MOSI_tb = 1'b0;
#2;
top_MOSI_tb = 1'b0;
#6;

//------ Write data 1001110101 in location 198 ----------------

top_MOSI_tb = 1'b1;
#2;
top_MOSI_tb = 1'b0;                 
#2;
top_MOSI_tb = 1'b1;                
#2;
top_MOSI_tb = 1'b0;
#2;
top_MOSI_tb = 1'b1;
#2;
top_MOSI_tb = 1'b1;
#2;
top_MOSI_tb = 1'b1;
#2;
top_MOSI_tb = 1'b0;
#2;
top_MOSI_tb = 1'b0;
#2;
top_MOSI_tb = 1'b1;
#1;

//---- Read from location 198 previously filled in write operation ---

top_MOSI_tb = 1'b1;
#6;
top_MOSI_tb = 1'b0;
#2;
top_MOSI_tb = 1'b1;
#2;
top_MOSI_tb = 1'b1;           //1011000110      location 198
#2;
top_MOSI_tb = 1'b0;          
#2;
top_MOSI_tb = 1'b0;           
#2;
top_MOSI_tb = 1'b0;
#2;
top_MOSI_tb = 1'b1;
#2;
top_MOSI_tb = 1'b1;
#2;
top_MOSI_tb = 1'b0;
#2;
top_MOSI_tb = 1'b1;


//------Read Data----------------------------------   

top_MOSI_tb = 1'b0;
#6;
top_MOSI_tb = 1'b1;              
#2;
top_MOSI_tb = 1'b1;
#2;
top_MOSI_tb = 1'b0;
#2;
top_MOSI_tb = 1'b0;
#2;
top_MOSI_tb = 1'b0;
#2;
top_MOSI_tb = 1'b1;
#2;
top_MOSI_tb = 1'b0;
#2;
top_MOSI_tb = 1'b1;      // last two bits 11 are indication for enabling read operation and the  
#2;                      // other 8 are dumb
top_MOSI_tb = 1'b1;
#6;
*/
end 

endmodule
