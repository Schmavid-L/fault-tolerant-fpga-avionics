module controller(
    input  logic clk,
    input  logic reset,
    input  logic enable,
    input  logic fault,
    output logic active,
    output logic safe
);

    typedef enum logic [1:0] {
        STANDBY = 2'b00,
        ACTIVE  = 2'b01,
        SAFE    = 2'b10
    } state_t;

    state_t current_state;
    state_t next_state;


    // 1. STATE REGISTER
    always_ff @(posedge clk) begin
        if (reset)
            current_state <= STANDBY;
        else
            current_state <= next_state;
    end


    // 2. NEXT-STATE LOGIC
    always_comb begin

        // Default: stay in current state
        next_state = current_state;

        case (current_state)

            STANDBY: begin
                // Fault has priority over enable
                if (fault)
                    next_state = SAFE;
                else if (enable)
                    next_state = ACTIVE;
            end

            ACTIVE: begin
                // Any fault forces safe mode
                if (fault)
                    next_state = SAFE;
            end

            SAFE: begin
                // Stay SAFE until reset
            end

            default: begin
                next_state = STANDBY;
            end

        endcase
    end


    // 3. OUTPUT LOGIC
    always_comb begin

        // Defaults
        active = 1'b0;
        safe   = 1'b0;

        case (current_state)

            STANDBY: begin
                // active=0, safe=0
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