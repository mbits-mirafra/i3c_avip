//
// File: default_clk_gen.sv
//
// Generated from Mentor VIP Configurator (20160818)
// Generated using Mentor VIP Library ( 10_5b : 09/04/2016:09:24 )
//
module default_clk_gen
(
    output reg CLK
);
    
    timeunit 1ns;
    timeprecision 1ns;
    
    initial
    begin
        CLK = 0;
        forever
        begin
            #1 CLK = ~CLK;
        end
    end
    

endmodule: default_clk_gen
