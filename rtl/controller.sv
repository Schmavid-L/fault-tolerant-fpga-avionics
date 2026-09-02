module controller(
    input  logic clk,
    input  logic reset,
    input  logic enable,
    input  logic fault,
    output logic active,
    output logic safe
);

    // Controller operating states.
    // STANDBY: waiting for enable
    // ACTIVE:  normal operation
    // SAFE:    latched fault-safe state
    typedef enum logic [1:0] {
        STANDBY = 2'b00,
        ACTIVE  = 2'b01,
        SAFE    = 2'b10
    } state_t;

    // current_state stores the controller's present operating mode.
    // next_state is calculated combinationally and loaded on a clock edge.
    state_t current_state;
    state_t next_state;


    // -------------------------------------------------
    // STATE REGISTER
    //
    // Sequential logic updates the controller state
    // on each rising clock edge.
    // Reset has priority and returns the system to STANDBY.
    // -------------------------------------------------
    always_ff @(posedge clk) begin
        if (reset)
            current_state <= STANDBY;
        else
            current_state <= next_state;
    end


    // -------------------------------------------------
    // NEXT-STATE LOGIC
    //
    // Determines the next operating state from the
    // current state and control inputs.
    //
    // Fault conditions take priority over enable.
    // SAFE remains latched until reset is asserted.
    // -------------------------------------------------
    always_comb begin

        // Default behavior is to remain in the current state.
        next_state = current_state;

        case (current_state)

            STANDBY: begin
                // Enter SAFE immediately if a fault is detected.
                // Otherwise, enable allows normal operation.
                if (fault)
                    next_state = SAFE;
                else if (enable)
                    next_state = ACTIVE;
            end

            ACTIVE: begin
                // Any detected fault forces the controller
                // from normal operation into SAFE mode.
                if (fault)
                    next_state = SAFE;
            end

            SAFE: begin
                // SAFE is intentionally latched.
                // Only reset can return the controller to STANDBY.
            end

            default: begin
                // Recover to a known state if an invalid
                // state encoding is encountered.
                next_state = STANDBY;
            end

        endcase
    end


    // -------------------------------------------------
    // OUTPUT LOGIC
    //
    // Moore-style outputs depend only on current_state.
    // -------------------------------------------------
    always_comb begin

        // Default outputs correspond to STANDBY.
        active = 1'b0;
        safe   = 1'b0;

        case (current_state)

            STANDBY: begin
                // active = 0, safe = 0
            end

            ACTIVE: begin
                active = 1'b1;
            end

            SAFE: begin
                safe = 1'b1;
            end

            default: begin
                active = 1'b0;
                safe   = 1'b0;
            end

        endcase
    end

endmodule