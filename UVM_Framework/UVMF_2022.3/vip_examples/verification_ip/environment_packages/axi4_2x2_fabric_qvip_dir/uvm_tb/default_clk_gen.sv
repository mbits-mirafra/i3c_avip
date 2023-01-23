//
// File: default_clk_gen.sv
//
// Generated from Mentor VIP Configurator (20191003)
// Generated using Mentor VIP Library ( 2019.4 : 10/16/2019:13:47 )
//
module default_clk_gen
(
    output reg  CLK
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
