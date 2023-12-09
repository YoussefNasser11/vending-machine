module vending_machine (clk,reset,coin_in_en,coin_val,PENCIL_out,money_out,extra_money);

input clk,reset,coin_in_en,coin_val;
output reg PENCIL_out,money_out,extra_money;

localparam IDLE = 3'b000;
localparam TWO_CENT = 3'b001;
localparam TEN_CENT = 3'b010;
localparam PENCIL = 3'b011;
localparam EXTRA_MONEY = 3'b100;

reg [2:0] current_state;
reg [2:0] next_state;
reg [3:0] acc_coins;


always @(posedge clk or negedge reset)
    begin
        if(!reset)
                current_state <= IDLE;
        else
                current_state <= next_state;
 end


  always @(posedge clk or negedge reset) 
    begin
    if (!reset) 
      acc_coins <= 4'b0000;
    else 
      if (coin_in_en) 
        acc_coins <= acc_coins + 1'b1;
      
    
  end

always @(*)
     begin
        case (current_state)
          IDLE: 
            if  (coin_in_en)
                 begin
                    if  (coin_val) 
                        next_state = TEN_CENT;
                     else 
                         next_state = TWO_CENT;
                 end        
            else
                next_state = IDLE;         
                 
           TWO_CENT:
                if  (acc_coins >= 4'b0110 )
                    next_state = PENCIL;
                else 
                    next_state = TWO_CENT;
           TEN_CENT:
                if  (acc_coins >= 4'b0110 )
                    next_state = PENCIL;
                else 
                    next_state = TEN_CENT;                    
           
           PENCIL:
                if  (acc_coins > 4'b0110 )
                next_state = EXTRA_MONEY; 
                else 
                next_state = IDLE; 
           EXTRA_MONEY:
                    if ( (acc_coins - 2) > 0)
                    next_state = EXTRA_MONEY;
                    else
                    next_state = IDLE;
            default: 
                 next_state = IDLE;
        endcase
 end   

always @(*) 
    begin
        PENCIL_out    = 1'b0;
        money_out     = 1'b0;
        extra_money   = 1'b0;        
    case (current_state)    
       IDLE: begin
          PENCIL_out    = 1'b0;
          money_out     = 1'b0;
          extra_money   = 1'b0;
       end
       TWO_CENT:begin
          PENCIL_out    = 1'b0;
          money_out     = (acc_coins > 4'b0110) ? 1'b1 : 1'b0 ;
          extra_money   = 1'b0;      end
       TEN_CENT:begin
          PENCIL_out    = 1'b0;
          money_out     = (acc_coins > 4'b0110) ? 1'b1 : 1'b0 ;
          extra_money   = 1'b0;       end
       PENCIL:begin
          PENCIL_out    = 1'b1;
          money_out     = 1'b0;
          extra_money   = 1'b0;        end
       EXTRA_MONEY: begin
          PENCIL_out    = 1'b0;
          money_out     = 1'b1;
          extra_money   = 1'b1;       
       end
        default: begin
          PENCIL_out    = 1'b0;
          money_out     = 1'b0;
          extra_money   = 1'b0;        
        end
    endcase
 end


endmodule

