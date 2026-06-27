`timescale 1ns / 1ps

module top_puf (
    input wire clk,      // 100MHz system clock from Nexys A7
    input wire rx,       // UART Receive
    output reg tx        // UART Transmit
);

    // --- BAUD GENERATOR (115200 bps @ 100MHz) ---
    parameter CLK_FREQ = 100000000;
    parameter BAUD_RATE = 115200;
    parameter BAUD_LIMIT = CLK_FREQ / BAUD_RATE; // 868 cycles

    reg [9:0] baud_counter = 0;
    reg baud_tick = 0;

    // --- FSM STATES ---
    localparam STATE_IDLE = 2'd0;
    localparam STATE_RX   = 2'd1;
    localparam STATE_PUF  = 2'd2;
    localparam STATE_TX   = 2'd3;

    reg [1:0] state = STATE_IDLE;
    reg [3:0] bit_count = 0;
    reg [4:0] byte_count = 0;
    reg [7:0] byte_buffer = 0;
    
    reg [127:0] active_challenge = 0;
    reg [127:0] full_response = 0;
    reg [6:0] run_count = 0;

    // --- PUF CONNECTION ---
    wire puf_result;
    wire puf_trigger;

    // Sub-cycle physical trigger: Waits 50 cycles for challenge bits to settle, then pulses high
    assign puf_trigger = (state == STATE_PUF) && (baud_counter > 50) && (baud_counter < 400);

    ccdl_puf my_puf (
        .trigger(puf_trigger),
        .challenge(active_challenge),
        .response(puf_result)
    );

    // --- BAUD CLOCKING ---
    always @(posedge clk) begin
        if (state == STATE_IDLE && rx == 1) begin
            baud_counter <= BAUD_LIMIT / 2; // Phase shift to sample center of bit
            baud_tick <= 0;
        end else if (baud_counter == BAUD_LIMIT - 1) begin
            baud_counter <= 0;
            baud_tick <= 1;
        end else begin
            baud_counter <= baud_counter + 1;
            baud_tick <= 0;
        end
    end

    // --- MAIN STATE MACHINE ---
    always @(posedge clk) begin
        if (baud_tick) begin
            case (state)
                STATE_IDLE: begin
                    tx <= 1; // Hold line high to prevent framing errors
                    if (rx == 0) begin
                        state <= STATE_RX;
                        bit_count <= 0;
                    end
                end
                
                STATE_RX: begin
                    if (bit_count < 8) begin
                        byte_buffer <= {rx, byte_buffer[7:1]}; // LSB first
                        bit_count <= bit_count + 1;
                    end else begin
                        active_challenge <= {active_challenge[119:0], byte_buffer}; // Pack bytes left
                        if (byte_count == 15) begin
                            state <= STATE_PUF;
                            run_count <= 0;
                        end else begin
                            byte_count <= byte_count + 1;
                            state <= STATE_IDLE;
                        end
                    end
                end
                
                STATE_PUF: begin
                    // Latch the winner of the race
                    full_response <= {full_response[126:0], puf_result};
                    // Mutate the challenge slightly for the next race
                    active_challenge <= {active_challenge[126:0], active_challenge[127] ^ puf_result};
                    run_count <= run_count + 1;
                    
                    if (run_count == 127) begin
                        state <= STATE_TX;
                        byte_count <= 0;
                        bit_count <= 0;
                    end
                end
                
                STATE_TX: begin
                    if (bit_count == 0) tx <= 0; // Start Bit
                    else if (bit_count >= 1 && bit_count <= 8) begin
                        tx <= full_response[127]; // Send MSB first for response
                        full_response <= {full_response[126:0], 1'b0};
                    end else if (bit_count == 9) begin
                        tx <= 1; // Stop Bit
                    end else begin
                        bit_count <= 0;
                        if (byte_count == 15) begin
                            state <= STATE_IDLE; // Done transmitting 16 bytes
                            byte_count <= 0;
                        end else begin
                            byte_count <= byte_count + 1;
                        end
                    end
                    if (bit_count < 10) bit_count <= bit_count + 1;
                end
            endcase
        end
    end
endmodule