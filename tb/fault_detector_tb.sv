module fault_detector_tb;

    // Controller outputs being compared
    logic active_a;
    logic active_b;
    logic active_c;

    // Majority-voted ACTIVE result
    logic voted_active;

    // Disagreement flags
    logic fault_detect_a;
    logic fault_detect_b;
    logic fault_detect_c;


    // Device under test
    fault_detector dut (
        .active_a(active_a),
        .active_b(active_b),
        .active_c(active_c),
        .voted_active(voted_active),

        .fault_detect_a(fault_detect_a),
        .fault_detect_b(fault_detect_b),
        .fault_detect_c(fault_detect_c)
    );


    initial begin

        // -----------------------------------------
        // TEST 1: All channels agree on ACTIVE
        // Expected faults: 000
        // -----------------------------------------
        active_a = 1;
        active_b = 1;
        active_c = 1;
        voted_active = 1;

        #10;

        if (fault_detect_a !== 0 ||
            fault_detect_b !== 0 ||
            fault_detect_c !== 0)
            $fatal(1, "Failed: healthy channels incorrectly flagged");


        // -----------------------------------------
        // TEST 2: Channel C disagrees
        // 1 1 0 compared against majority 1
        // Expected faults: 001
        // -----------------------------------------
        active_a = 1;
        active_b = 1;
        active_c = 0;
        voted_active = 1;

        #10;

        if (fault_detect_a !== 0 ||
            fault_detect_b !== 0 ||
            fault_detect_c !== 1)
            $fatal(1, "Failed: channel C disagreement not detected");


        // -----------------------------------------
        // TEST 3: Channel B disagrees
        // 0 1 0 compared against majority 0
        // Expected faults: 010
        // -----------------------------------------
        active_a = 0;
        active_b = 1;
        active_c = 0;
        voted_active = 0;

        #10;

        if (fault_detect_a !== 0 ||
            fault_detect_b !== 1 ||
            fault_detect_c !== 0)
            $fatal(1, "Failed: channel B disagreement not detected");


        // -----------------------------------------
        // TEST 4: Channel A disagrees
        // 1 0 0 compared against majority 0
        // Expected faults: 100
        // -----------------------------------------
        active_a = 1;
        active_b = 0;
        active_c = 0;
        voted_active = 0;

        #10;

        if (fault_detect_a !== 1 ||
            fault_detect_b !== 0 ||
            fault_detect_c !== 0)
            $fatal(1, "Failed: channel A disagreement not detected");


        // -----------------------------------------
        // TEST 5: All channels agree on NOT ACTIVE
        // Expected faults: 000
        // -----------------------------------------
        active_a = 0;
        active_b = 0;
        active_c = 0;
        voted_active = 0;

        #10;

        if (fault_detect_a !== 0 ||
            fault_detect_b !== 0 ||
            fault_detect_c !== 0)
            $fatal(1, "Failed: matching inactive channels incorrectly flagged");


        // -----------------------------------------
        // TEST 6: Two channels disagree with supplied vote
        // 0 1 0 compared against majority input 1
        // Expected faults: 101
        // -----------------------------------------
        active_a = 0;
        active_b = 1;
        active_c = 0;
        voted_active = 1;

        #10;

        if (fault_detect_a !== 1 ||
            fault_detect_b !== 0 ||
            fault_detect_c !== 1)
            $fatal(1, "Failed: multiple channel disagreements not detected");


        $display("PASS: Fault detector tests passed.");
        $finish;

    end

endmodule