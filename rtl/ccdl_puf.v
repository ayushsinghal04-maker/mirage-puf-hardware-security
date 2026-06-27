`timescale 1ns / 1ps

(* KEEP_HIERARCHY = "TRUE" *)                   // do not optimize
module ccdl_puf (
    input wire trigger,                         // start signal
    input wire [63:0] challenge,                // 64 bit challenge 
    output wire response                        // output
);

    (* KEEP = "TRUE" *) wire [64:0] chain_a;    // carry chain-A
    (* KEEP = "TRUE" *) wire [64:0] chain_b;    // carry chain-B

    assign chain_a[0] = trigger;                // assign trigger to first slice
    assign chain_b[0] = trigger;
    
    // ~~~~~~~~~~~~~~~CARRY CHAINS~~~~~~~~~~~~~~~
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : carry_chain_gen          // each block contains 4 stages. therefore, 64 bits require 16 blocks
            
            if (i == 0) begin : first_stage                             // THE STARTING LINE
                (* DONT_TOUCH = "TRUE" *)                               // do not optimize
                CARRY4 carry_a_inst (                                   // RACETRACK A
                    .CO(chain_a[4:1]),                                  // carry out (4 bits per stage)
                    .O(),                                               // sum of the stage (Trash it)
                    .CI(1'b0),                                          // Carry in, must be 0 for the first stage
                    .CYINIT(chain_a[0]),                                // Trigger set to 0 at the start
                    .DI(chain_b[3:0]),                                  // Crossover path from Chain B
                    .S(challenge[3:0])                                  // mux to switch lanes
                );

                (* DONT_TOUCH = "TRUE" *)                               // do not optimize
                CARRY4 carry_b_inst (                                   // RACETRACK B 
                    .O(),                                               // sum of the stage (Trash it)
                    .CI(1'b0),                                          // Must be 0 for the first stage
                    .CYINIT(chain_b[0]),                                // Trigger set to 0 at the start
                    .DI(chain_a[3:0]),                                  // Crossover path from Chain A
                    .S(challenge[3:0])                                  // Same exact challenge bit so they swap symmetrically
                );
                
            end else begin : next_stages                                // THE REST OF THE TRACKS
                (* DONT_TOUCH = "TRUE" *)                               // do not optimize
                CARRY4 carry_a_inst (                                   // RACETRACK A
                    .CO(chain_a[(i*4)+4 : (i*4)+1]),                    // carry out (4 bits per stage)
                    .O(),                                               // sum of the stage (Trash it)
                    .CI(chain_a[i*4]),                                  // carry in (fast lane)
                    .CYINIT(1'b0),                                      // carry initialization (keep it disabled)
                    .DI(chain_b[(i*4)+3 : i*4]),                        // Crossover lane (slow lane, connected to chain B)
                    .S(challenge[(i*4)+3 : i*4])                        // mux to switch lanes
                );

                // RIGHT RACETRACK - THE REST OF THE TRACK
                (* DONT_TOUCH = "TRUE" *)                               // do not optimize
                CARRY4 carry_b_inst (                                   // RACETRACK A
                    .CO(chain_b[(i*4)+4 : (i*4)+1]),                    // carry out (4 bits per stage)
                    .O(),                                               // sum of the stage (Trash it
                    .CI(chain_b[i*4]),                                  // carry in (fast lane)
                    .CYINIT(1'b0),                                      // carry initialization (keep it disabled)
                    .DI(chain_a[(i*4)+3 : i*4]),                        // Crossover lane (slow lane, connected to chain A)
                    .S(challenge[(i*4)+3 : i*4])                        // mux to switch lanes
                );
            end
        end
    endgenerate
    
    
    // ~~~~~~~~~~~~~~~LIGHTWEIGHT PROGRAMMABLE DELAY LINE~~~~~~~~~~~~~~~
    // CHAIN A (4 States)
    wire a_d0 = chain_a[64];
    wire a_d1, a_d2, a_d3;
    
    (* DONT_TOUCH = "TRUE" *) LUT1 #(.INIT(2'b10)) a_b1 (.O(a_d1), .I0(a_d0));                  // buffer
    (* DONT_TOUCH = "TRUE" *) LUT1 #(.INIT(2'b10)) a_b2 (.O(a_d2), .I0(a_d1));
    (* DONT_TOUCH = "TRUE" *) LUT1 #(.INIT(2'b10)) a_b3 (.O(a_d3), .I0(a_d2));
    
    wire chain_a_delayed;
    wire [1:0] tune_a = challenge[57:56];                                                       // Use 2-bits of challenge (56 and 57) to decide PDL for Chain A
    
    (* DONT_TOUCH = "TRUE" *) LUT6 #(.INIT(64'hF0AA_CC88_F0AA_CC88)) mux_a1 (
        .O(chain_a_delayed), .I0(a_d0), .I1(a_d1), .I2(a_d2), .I3(a_d3), .I4(tune_a[0]), .I5(tune_a[1])                 // Mux for selecting combination of delays, feeds into arbiter   
    );

    // CHAIN B (4 States)
    wire b_d0 = chain_b[64];
    wire b_d1, b_d2, b_d3;
    
    (* DONT_TOUCH = "TRUE" *) LUT1 #(.INIT(2'b10)) b_b1 (.O(b_d1), .I0(b_d0));                  // buffer
    (* DONT_TOUCH = "TRUE" *) LUT1 #(.INIT(2'b10)) b_b2 (.O(b_d2), .I0(b_d1));
    (* DONT_TOUCH = "TRUE" *) LUT1 #(.INIT(2'b10)) b_b3 (.O(b_d3), .I0(b_d2));
    
    wire chain_b_delayed;
    wire [1:0] tune_b = challenge[61:60];                                                       // Use 2-bits of challenge (60 and 61) to decide PDL for Chain B
    
    (* DONT_TOUCH = "TRUE" *) LUT6 #(.INIT(64'hF0AA_CC88_F0AA_CC88)) mux_b1 (
        .O(chain_b_delayed), .I0(b_d0), .I1(b_d1), .I2(b_d2), .I3(b_d3), .I4(tune_b[0]), .I5(tune_b[1])             // Mux for selecting combination of delays, feeds into arbiter
    );


    // ~~~~~~~~~~~~~~~THE ARBITER (SR-LATCH)~~~~~~~~~~~~~~~
    wire nand_a_out, nand_b_out;
    (* DONT_TOUCH = "TRUE" *) LUT2 #(.INIT(4'b0111)) nand_a (.O(nand_a_out), .I0(chain_a_delayed), .I1(nand_b_out));
    (* DONT_TOUCH = "TRUE" *) LUT2 #(.INIT(4'b0111)) nand_b (.O(nand_b_out), .I0(chain_b_delayed), .I1(nand_a_out));
    assign response = nand_a_out; 

endmodule