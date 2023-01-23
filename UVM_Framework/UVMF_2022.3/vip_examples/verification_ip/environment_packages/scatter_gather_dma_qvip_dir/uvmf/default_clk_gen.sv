//
// File: default_clk_gen.sv
//
// Generated from Mentor VIP Configurator (20201007)
// Generated using Mentor VIP Library ( 2020.4 : 10/16/2020:13:17 )
//
module default_clk_gen
(
    output reg  CLK
);
    
    timeunit 1ps;
    timeprecision 1ps;
    
    initial
    begin
        CLK = 0;
        forever
        begin
            #5000 CLK = ~CLK;
        end
    end
    

endmodule: default_clk_gen
