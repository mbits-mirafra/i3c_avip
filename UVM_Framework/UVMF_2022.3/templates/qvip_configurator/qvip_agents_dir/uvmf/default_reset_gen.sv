//
// File: default_reset_gen.sv
//
// Generated from Mentor VIP Configurator (20200402)
// Generated using Mentor VIP Library ( 2020.2 : 04/19/2020:18:58 )
//
module default_reset_gen
(
    output reg  RESET,
    input  reg  CLK_IN
);
    
    initial
    begin
        RESET = 1;
        
        RESET = ~RESET;
        
        repeat ( 2 )
        begin
            @(posedge CLK_IN);
        end
        
        RESET = ~RESET;
    end
    

endmodule: default_reset_gen
