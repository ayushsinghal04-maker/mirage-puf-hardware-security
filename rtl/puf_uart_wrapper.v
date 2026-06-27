`timescale 1ns / 1ps

module puf_uart_wrapper (
    input wire clk,       // 100MHz Artix-7 Clock
    input wire rx,        // UART Receive Pin (from USB)
    output reg tx = 1     // UART Transmit Pin (BOOTS HIGH - IDLE)
);

    // ~~~~~~~~~~~~~~~STATES AND BAUD RATE~~~~~~~~~~~~~~~
    localparam STATE_IDLE  = 0;             // idle state
    localparam STATE_RX    = 1;             // receiver state
    localparam STATE_PUF   = 2;             // PUF running state
    localparam STATE_TX    = 3;             // transmitter state
    
    reg [2:0] state = STATE_IDLE;           // needs only 2 bits, but allocating 3 to allow for more states if needed

    reg [9:0] baud_counter = 0;             // 100,000,000 clock ticks per second/ 115200 bits per second = 868 clock ticks per bit
    reg baud_tick = 0;                      // basically an enable
    
    always @(posedge clk) begin
        if (state == STATE_IDLE && rx == 1) begin       // when state is idle and RX is idle (active low)
            baud_counter <= 434;                        // keep counter at 868/2 (the middle of the counter, where the signal will be stable)
            baud_tick <= 0;                             // enable = 0
        end else if (baud_counter >= 867) begin         // if counter exceeds 867, since we started at 434, it means the counter is at the middle of the pulse
            baud_counter <= 0;                          // reset counter
            baud_tick <= 1;                             // enable = 1 (switched on)
        end else begin
            baud_counter <= baud_counter + 1;           // increase counter
            baud_tick <= 0;                             // enable = 0
        end
    end

    // ~~~~~~~~~~~~~~~REGISTERS, COUNTERS & WIRES~~~~~~~~~~~~~~~
    reg [127:0] active_challenge;
    reg [63:0] full_response;
    reg [7:0]  byte_buffer;
    
    wire puf_result;

    reg puf_trigger = 0;
    always @(posedge clk) begin                 
        puf_trigger <= (state == STATE_PUF) && (baud_counter > 50);         // counter > 50 to give the signal time to settle
    end        
    
    dynamic_ipuf_wrapper my_ipuf (                                          // initialize dynamic_ipuf_wrapper.v
        .trigger(puf_trigger),                                              // Unified Trigger
        .challenge_x(active_challenge[127:64]),                             // Top 64 challenge bits (Upper PDL Dials + Upper Track)
        .challenge_y(active_challenge[63:0]),                               // Bottom 64 challenge bits (Lower PDL Dials + Lower Track)
        .final_response(puf_result)                                         // Final response
    );

    reg [3:0] bit_count = 0;   
    reg [4:0] byte_count = 0;  
    reg [7:0] run_count = 0;   
    
    // ~~~~~~~~~~~~~~~FINITE STATE MACHINE~~~~~~~~~~~~~~~
    always @(posedge clk) begin
        if (baud_tick) begin                                                // if enable=1 
            case (state)                                                
                STATE_IDLE: begin                                           // if idle
                    tx <= 1;                                                // transmitter is idle high
                    if (rx == 0) begin                                      // if receiver is on
                        state <= STATE_RX;                                  // change state to receiving state
                        bit_count <= 0;                                     // instantiate bit count to 0
                    end
                end
                
                STATE_RX: begin                                             // if receiving state
                    if (bit_count < 8) begin                                // if bit count is not yet 8 (1 full byte)
                        byte_buffer <= {rx, byte_buffer[7:1]};              // shift incoming bit to byte_buffer register
                        bit_count <= bit_count + 1;                         // increase bit count
                    end else begin
                        active_challenge <= {active_challenge[119:0], byte_buffer};       // shift all 8 bits inside byte_buffer register into active_challenge register
                        
                        if (byte_count == 15) begin                         // if entire challenge is received
                            state <= STATE_PUF;                             // change state to run PUF state
                            run_count <= 0;                                 // instantiate run count to 0
                        end else begin                                 
                            byte_count <= byte_count + 1;                   // increase byte_count
                            state <= STATE_IDLE;                            // change state back to idle
                        end
                    end
                end
                
                STATE_PUF: begin
                    full_response <= {full_response[62:0], puf_result};         // shift result into full_response register
                    // 
                   active_challenge[119:64] <= {active_challenge[118:64], active_challenge[119] ^ active_challenge[64]};    // SEGMENTED LFSR (Upper Challenge bits (PDL Dials (127:120)) are locked while rest of the challenge (119:64) is mutated
                   active_challenge[55:0] <= {active_challenge[54:0], active_challenge[55] ^ active_challenge[0]};          // similar for lower PUF
                    
                    run_count <= run_count + 1;                                 // increase run count
                    
                    if (run_count == 63) begin                                  // if 64 runs have been finished
                        state <= STATE_TX;                                      // change to transmission state
                        byte_count <= 0;                                        // reset byte count
                        bit_count <= 0;                                         // reset bit count
                    end
                end
                
                STATE_TX: begin                                                 
                    if (bit_count == 0) tx <= 0;                                // if bit count is 0, transmission line = 0V, aka start bit
                    else if (bit_count >= 1 && bit_count <= 8) begin            // if bit count between 1-8
                        tx <= full_response[0];                                 // send LSB of 64 bit response
                        full_response <= {1'b0, full_response[63:1]};           // right shift response
                    end else if (bit_count == 9) begin                          // if bit count reaches 9
                        tx <= 1;                                                // stop bit (transmission stops)
                    end else begin
                        bit_count <= 0;                                         // reset bit count
                        if (byte_count == 7) begin                              // if all 64 bits (8 bytes) have been sent
                            state <= STATE_IDLE;                                // change back to idle state
                            byte_count <= 0;                                    // reset byte count
                        end else begin
                            byte_count <= byte_count + 1;                       // increase byte count
                        end
                    end
                    
                    if (bit_count < 10) bit_count <= bit_count + 1;             // increase bit count till 10
                end
            endcase
        end
    end
endmodule