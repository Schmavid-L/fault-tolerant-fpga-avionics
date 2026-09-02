module controller_tb;

    // -------------------------------------------------
    // TESTBENCH SIGNALS
    // Inputs driven by the testbench
    // Outputs observed from the DUT
    // -------------------------------------------------

    logic clk;
    logic reset;
    logic enable;
    logic fault;

    logic active;
    logic safe;


    // -------------------------------------------------
    // DUT = Device Under Test
    // -------------------------------------------------

    controller dut (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .fault(fault),
        .active(active),
        .safe(safe)
    );


    // -------------------------------------------------
    // CLOCK GENERATOR
    //
    // Toggle clock every 5 time units.
    // Full clock period = 10 time units.
    // -------------------------------------------------

    always #5 clk = ~clk;


    // -------------------------------------------------
    // TEST SEQUENCE
    // -------------------------------------------------

    initial begin

        // Initial conditions
        clk    = 0;
        reset  = 1;
        enable = 0;
        fault  = 0;


        // -------------------------------------------------
        // TEST 1: RESET -> STANDBY
        //
        // Hold reset high across a rising clock edge.
        // STANDBY outputs should be:
        // active = 0
        // safe   = 0
        // -------------------------------------------------

        #10;

        if (active !== 0 || safe !== 0)
            $fatal(1, "Failed: RESET to STANDBY");


        // Release reset
        reset = 0;


        // -------------------------------------------------
        // TEST 2: STANDBY -> ACTIVE
        //
        // enable = 1 requests normal operation.
        // After the next rising edge:
        // active = 1
        // safe   = 0
        // -------------------------------------------------

        enable = 1;
        #10;

        if (active !== 1 || safe !== 0)
            $fatal(1, "Failed: STANDBY to ACTIVE");


        // -------------------------------------------------
        // TEST 3: ACTIVE -> SAFE
        //
        // Inject a fault while ACTIVE.
        // After the next rising edge:
        // active = 0
        // safe   = 1
        // -------------------------------------------------

        fault = 1;
        #10;

        if (active !== 0 || safe !== 1)
            $fatal(1, "Failed: ACTIVE to SAFE");


        // -------------------------------------------------
        // TEST 4: SAFE remains latched
        //
        // Remove the fault.
        // The controller should remain SAFE until reset.
        // -------------------------------------------------

        fault = 0;
        #10;

        if (active !== 0 || safe !== 1)
            $fatal(1, "Failed: SAFE state did not latch");


        // -------------------------------------------------
        // TEST 5: RESET from SAFE -> STANDBY
        //
        // Assert reset again.
        // After the next rising edge:
        // active = 0
        // safe   = 0
        // -------------------------------------------------

        reset = 1;
        #10;

        if (active !== 0 || safe !== 0)
            $fatal(1, "Failed: SAFE to STANDBY reset");


        // -------------------------------------------------
        // ALL TESTS PASSED
        // -------------------------------------------------

        $display("PASS: Controller FSM tests passed.");
        $finish;

    end

endmodule