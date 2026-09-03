module tmr_controller(

    input  logic clk,
    input  logic reset,
    input  logic enable,

    input  logic fault_a,
    input  logic fault_b,
    input  logic fault_c,

    output logic voted_active,
    output logic voted_safe,

    // Flags channels that disagree with the majority
    output logic fault_detect_a,
    output logic fault_detect_b,
    output logic fault_detect_c
    
    
    

);

    // Internal outputs from each redundant controller
    logic active_a, active_b, active_c;
    logic safe_a,   safe_b,   safe_c;


    // Three controller channels run in parallel
    controller ctrl_a (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .fault(fault_a),
        .active(active_a),
        .safe(safe_a)
    );

    controller ctrl_b (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .fault(fault_b),
        .active(active_b),
        .safe(safe_b)
    );

    controller ctrl_c (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .fault(fault_c),
        .active(active_c),
        .safe(safe_c)
    );


    // Majority vote the ACTIVE outputs
    majority_voter vote_active (
        .A(active_a),
        .B(active_b),
        .C(active_c),
        .Vote(voted_active)
    );


    // Majority vote the SAFE outputs
    majority_voter vote_safe (
        .A(safe_a),
        .B(safe_b),
        .C(safe_c),
        .Vote(voted_safe)
    );


    // Compare each channel against the ACTIVE majority
    fault_detector detector (
        .active_a(active_a),
        .active_b(active_b),
        .active_c(active_c),
        .voted_active(voted_active),

        .fault_detect_a(fault_detect_a),
        .fault_detect_b(fault_detect_b),
        .fault_detect_c(fault_detect_c)
    );

endmodule