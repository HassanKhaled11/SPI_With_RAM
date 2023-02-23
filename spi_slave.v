module spi_slave(

input             clk         ,
input             rst_n       ,
input             MOSI        ,
input             SS_n        ,
input             tx_valid    ,
input  reg [7:0]  tx_data     ,

output reg        MISO        ,
output reg        rx_valid    ,
output reg [10:0] rx_data     
);

reg [2:0] current_state, next_state;


parameter IDLE      = 3'b000;
parameter CHK_CMD   = 3'b001;
parameter WRITE     = 3'b010;
parameter READ_ADD  = 3'b011;
parameter READ_DATA = 3'b100;

reg [3:0] counter;
reg add_sent;



//---------------------------------------------------------

always @(posedge clk or negedge rst_n)begin

  if(~rst_n)begin
   next_state <= IDLE;
  end 
  
  else begin
   current_state <= next_state ;
  end

end

//----------------------------------------------------------

always @(*)begin

  case (current_state)

IDLE :   begin
          if(SS_n) begin
            next_state = IDLE;
          end

          else begin
            next_state = CHK_CMD;
          end  
         end



CHK_CMD: begin
          if(SS_n) begin
            next_state  =  IDLE ;
          end

          else if(!SS_n && !MOSI)begin 
            next_state  =  WRITE ;  
          end

          else begin
             if(add_sent)
             next_state = READ_DATA ;
             else
             next_state = READ_ADD ;
          end
         end



WRITE : begin
         if(SS_n) begin
            next_state  =  IDLE ;
         end
         
         else begin
           if(counter != 10)begin
             next_state = WRITE;
           end
           
           else
            next_state = CHK_CMD; 
            
         end
       end
 
READ_ADD :begin
          if(SS_n) begin
            next_state  =  IDLE ;
           end
         
          else begin
           rx_data[counter] = MOSI;
           if(counter != 'd10)begin
           next_state = READ_ADD;
           end
           else begin
           next_state = CHK_CMD; 
           end      
         end
      end
   
READ_DATA :begin
           if(SS_n) begin
            next_state  =  IDLE ;
           end
         
           else begin
            if(counter!=10)
              next_state = READ_DATA;
            else
              next_state = CHK_CMD; 
           end
      end
endcase
end
//------------------------------------------------------

always @(posedge clk)begin
 if(~rst_n)begin
  next_state <= IDLE;
 end 
  
 else begin
   current_state <= next_state ;
 end


  case (current_state)

  IDLE :  begin
          MISO       <= 1'b0      ;
          rx_valid   <= 1'b0      ;
          rx_data    <= 0         ;
          counter    <= 0         ;
          add_sent   <= 1'b0      ;
          end
          
          
   WRITE : begin
           if(counter !=10)begin
           rx_data[counter] <= MOSI;       
           counter <= counter + 1;
           end
           else begin
            counter <= 0;
            rx_valid <= 1'b1;
           end
           end
         
         
    READ_ADD: begin
            if(counter !=10)begin
             rx_data[counter] <= MOSI;       
             counter <= counter + 1;
            end
            else begin
             counter  <= 0;
             rx_valid <= 1'b1;
             add_sent <= 1'b1;
           end
           end
           
     READ_DATA: begin
                 add_sent = 1'b0;
                 if(tx_valid) begin
                    if(counter != 'd10)begin
                     MISO <= tx_data[counter];
                     counter <= counter + 1;
                    end 
                 end        
               end   
  endcase
end


endmodule
