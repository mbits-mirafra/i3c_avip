//
// File: default_reset_gen.sv
//
// Generated from Mentor VIP Configurator (20160818)
// Generated using Mentor VIP Library ( 10_5b : 09/04/2016:09:24 )
//
module default_reset_gen
(
    output reg RST,
    input  reg CLK
);
    
    initial
    begin
        RST = 1;
        
        repeat ( 0 )
        begin
            @(negedge CLK);
        end
        
        RST = ~RST;
        
        repeat ( 5 )
        begin
            @(negedge CLK);
        end
        
        RST = ~RST;
    end
    

endmodule: default_reset_gen
