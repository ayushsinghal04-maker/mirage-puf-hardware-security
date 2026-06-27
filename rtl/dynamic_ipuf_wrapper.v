`timescale 1ns / 1ps

module dynamic_ipuf_wrapper(
    input wire trigger,                 // Unified Phase Trigger (from FSM)
    input wire [63:0] challenge_x,      // Upper PUF challenge
    input wire [63:0] challenge_y,      // Lower PUF challenge
    output wire final_response          // The cryptographically secure output
);

    // ~~~~~~~~~~~~~~~THE DEEP-TAP LOWER PUF (Fires Instantly)~~~~~~~~~~~~~~~
    wire [3:0] deep_tap_mask;

    deep_tap_lower_puf lower_puf_inst (                 // instantiatiing deep tap lower PUF
        .trigger(trigger),
        .challenge(challenge_y),
        .multi_bit_response(deep_tap_mask)
    );

    // ~~~~~~~~~~~~~~~THE MULTI-BIT AVALANCHE MUTATOR~~~~~~~~~~~~~~~
    // Bits 63:56 (The PDL Dials) bypass the mutator entirely to preserve calibration.
    // Bits 55:0 (The Racetrack) receive the 4 injected quantum bits spaced evenly across the physical carry chain.
    wire [63:0] mutated_challenge_x;
    
    assign mutated_challenge_x = {
        challenge_x[63:56],                                         // PDL Dials (Locked)
        challenge_x[55:55],                                         // 1 bit buffer
        (challenge_x[54] ^ deep_tap_mask[3]), challenge_x[53:37],   // Tap 3 injects at bit 54 (end of track)
        (challenge_x[36] ^ deep_tap_mask[2]), challenge_x[35:19],   // Tap 2 injects at bit 36
        (challenge_x[18] ^ deep_tap_mask[1]), challenge_x[17:1],    // Tap 1 injects at bit 18
        (challenge_x[0]  ^ deep_tap_mask[0])                        // Tap 0 injects at the starting line
    };
    
    // ~~~~~~~~~~~~~~~ASYNCHRONOUS TRIGGER STAGGER (~10ns Delay)~~~~~~~~~~~~~~~
    // Gives the Lower PUF time to race and settle all 4 physical arbiters (just a bunch of buffers)
    wire t1, t2, t3, t4, t5, t6, trigger_upper;
    
    (* DONT_TOUCH = "TRUE" *) LUT1 #(.INIT(2'b10)) trig_d1 (.O(t1), .I0(trigger));
    (* DONT_TOUCH = "TRUE" *) LUT1 #(.INIT(2'b10)) trig_d2 (.O(t2), .I0(t1));
    (* DONT_TOUCH = "TRUE" *) LUT1 #(.INIT(2'b10)) trig_d3 (.O(t3), .I0(t2));
    (* DONT_TOUCH = "TRUE" *) LUT1 #(.INIT(2'b10)) trig_d4 (.O(t4), .I0(t3));
    (* DONT_TOUCH = "TRUE" *) LUT1 #(.INIT(2'b10)) trig_d5 (.O(t5), .I0(t4));
    (* DONT_TOUCH = "TRUE" *) LUT1 #(.INIT(2'b10)) trig_d6 (.O(t6), .I0(t5));
    (* DONT_TOUCH = "TRUE" *) LUT1 #(.INIT(2'b10)) trig_d7 (.O(trigger_upper), .I0(t6));

    // ~~~~~~~~~~~~~~~THE UPPER PUF~~~~~~~~~~~~~~~
    // Standard 1-bit output PUF (defined in ccdl_puf.v) using the mutated challenge
    ccdl_puf upper_puf_inst (
        .trigger(trigger_upper),
        .challenge(mutated_challenge_x),
        .response(final_response)
    );

endmodule