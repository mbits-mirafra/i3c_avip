//
// File: default_reset_gen.sv
//
// Generated from Mentor VIP Configurator (20201007)
// Generated using Mentor VIP Library ( 2020.4 : 10/16/2020:13:17 )
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
        
        repeat ( 5 )
        begin
            @(negedge CLK_IN);
        end
        
        RESET = ~RESET;
    end
    

endmodule: default_reset_gen
