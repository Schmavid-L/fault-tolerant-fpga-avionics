`timescale 1ns / 1ps

module basys3_top(
    input clk,
    input reset,
    input enable,
    input fault_a,
    input fault_b,
    input fault_c,
    output voted_active,
    output voted_safe,
    output fault_detect_a,
    output fault_detect_b,
    output fault_detect_c
    );
    
    tmr_controller c01 (
    
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .fault_a(fault_a),
    .fault_b(fault_b),
    .fault_c(fault_c),
    .voted_active(voted_active),
    .voted_safe(voted_safe),
    .fault_detect_a(fault_detect_a),
    .fault_detect_b(fault_detect_b),
    .fault_detect_c(fault_detect_c)

    
    
    );
    
    
    
endmodule
