module tmr_controller_tb;

    // Shared control inputs
    logic clk;
    logic reset;
    logic enable;

    // Independent fault injection inputs
    logic fault_a;
    logic fault_b;
    logic fault_c;

    // Majority-voted outputs
    logic voted_active;
    logic voted_safe;


    // Device under test
    tmr_controller dut (
        .clk(clk),
        .reset(reset),
        .enable(enable),

        .fault_a(fault_a),
        .fault_b(fault_b),
        .fault_c(fault_c),

        .voted_active(voted_active),
        .voted_safe(voted_safe)
    );


    // 10-time-unit clock period
    always #5 clk = ~clk;


    initial begin

        // Initial conditions
        clk     = 0;
        reset   = 1;
        enable  = 0;

        fault_a = 0;
        fault_b = 0;
        fault_c = 0;


        // Reset system into STANDBY
        #10;

        reset  = 0;
        enable = 1;

        // Allow all three controllers to enter ACTIVE
        #10;

        if (voted_active !== 1)
            $fatal(1, "Failed: healthy TMR system should be ACTIVE");

        if (voted_safe !== 0)
            $fatal(1, "Failed: healthy TMR system should not be SAFE");


        // Inject a single fault into controller B
        fault_b = 1;

        #10;

        // One failed channel should be masked by TMR
        if (voted_active !== 1)
            $fatal(1, "Failed: single-channel fault should remain ACTIVE");

        if (voted_safe !== 0)
            $fatal(1, "Failed: single-channel fault should not force SAFE");


        // Inject a second fault into controller C
        fault_c = 1;

        #10;

        // Two failed channels now control the majority
        if (voted_active !== 0)
            $fatal(1, "Failed: two-channel fault should remove ACTIVE majority");

        if (voted_safe !== 1)
            $fatal(1, "Failed: two-channel fault should force SAFE majority");


        $display("PASS: TMR controller tests passed.");
        $finish;

    end

endmodule