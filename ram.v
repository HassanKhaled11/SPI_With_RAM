module RAM #(parameter  MEM_DEPTH = 'd256 , parameter ADDR_SIZE = 'd8)
(                                                  
input               clk,
input             rst_n,
input [9:0]         din,
input          rx_valid,

output reg [7:0]    dout,
output reg      tx_valid);

reg [2:0] current_state,next_state;                          

parameter IDLE =          3'b000;
parameter WRITE_ADDR =    3'b001;
parameter WRITE_DATA =    3'b010;  
parameter READ_ADDR    =  3'b011;
parameter READ_DATA    =  3'b100;


reg [ADDR_SIZE-1:0] temp_address, read_address ,write_address;
reg flag , h_flag;


reg [7:0] ram_mem [MEM_DEPTH-1 : 0];


always @(posedge clk or negedge rst_n) begin
	if (~rst_n) begin
	current_state <= IDLE;	
	end
	else 
	current_state <= next_state;	
end




always @(*) begin

  case(current_state)

     IDLE: begin 
     if(rx_valid)begin

            if (!din[9]) begin
            	 next_state = WRITE_ADDR;
             end

            else begin
           	  next_state = READ_ADDR;
             end
            end
         
       else
           next_state = IDLE;
            end


    WRITE_ADDR: begin
               if(din[9:8] == 2'b01)begin
               next_state = WRITE_DATA;
               end 
               
               end
               
               
    WRITE_DATA: begin
               next_state = IDLE; 
                end           


    READ_ADDR : begin 
                if(din[9:8] == 2'b11)
                next_state = READ_DATA;
                
                else begin
                next_state = READ_ADDR;  
                end
              end
                
      READ_DATA: begin
                  next_state = IDLE;
                 end            
  endcase

  end

  always @(posedge clk) begin
   
   case(current_state) 

  IDLE:      begin
             dout     <= 8'b0;
             tx_valid <= 1'b0;
             temp_address <= 0;
             read_address <= 0;
             write_address <= 0;
             flag <= 0;
             h_flag <= 0;
             end 

  WRITE_ADDR: begin
                 if(din[9:8] == 2'b00 && flag == 1'b0)begin
                 write_address <= din[7:0];
                  flag <= 1'b1;
                   end
                 end
            

   
  WRITE_DATA: begin
                 ram_mem[write_address] <= din[7:0];
               end



  READ_ADDR: begin   
              
              if(din[9:8] == 2'b10 && flag == 1'b0)begin
              read_address <= din[7:0] ;
              flag <=1;    
            end
            end


 READ_DATA: begin       
           if(!h_flag)  begin                   
           tx_valid <= 1'b1;
           dout <= ram_mem[read_address];
           h_flag <= 1'b1;
         end
            end       

   endcase 
  end

endmodule
