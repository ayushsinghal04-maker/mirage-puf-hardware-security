`timescale 1ns / 1ps

(* KEEP_HIERARCHY = "TRUE" *)                                           // do not optimize
module deep_tap_lower_puf (
    input wire trigger,
    input wire [63:0] challenge,
    output wire [3:0] multi_bit_response                                // 4-bit extracted mask
);

    (* KEEP = "TRUE" *) wire [64:0] chain_a;
    (* KEEP = "TRUE" *) wire [64:0] chain_b;

    assign chain_a[0] = trigger;
    assign chain_b[0] = trigger;

    // ~~~~~~~~~~~~~~~CARRY CHAINS (EXACTLY THE SAME AS IN ccdl_puf.v)~~~~~~~~~~~~~~~
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : carry_chain_gen
            if (i == 0) begin : first_stage
                (* DONT_TOUCH = "TRUE" *) CARRY4 carry_a_inst (.CO(chain_a[4:1]), .O(), .CI(1'b0), .CYINIT(chain_a[0]), .DI(chain_b[3:0]), .S(challenge[3:0]));
                (* DONT_TOUCH = "TRUE" *) CARRY4 carry_b_inst (.CO(chain_b[4:1]), .O(), .CI(1'b0), .CYINIT(chain_b[0]), .DI(chain_a[3:0]), .S(challenge[3:0]));
            end else begin : next_stages
                (* DONT_TOUCH = "TRUE" *) CARRY4 carry_a_inst (.CO(chain_a[(i*4)+4 : (i*4)+1]), .O(), .CI(chain_a[i*4]), .CYINIT(1'b0), .DI(chain_b[(i*4)+3 : i*4]), .S(challenge[(i*4)+3 : i*4]));
                (* DONT_TOUCH = "TRUE" *) CARRY4 carry_b_inst (.CO(chain_b[(i*4)+4 : (i*4)+1]), .O(), .CI(chain_b[i*4]), .CYINIT(1'b0), .DI(chain_a[(i*4)+3 : i*4]), .S(challenge[(i*4)+3 : i*4]));
            end
        end
    endgenerate


    // ~~~~~~~~~~~~~~~WIRE TAPPING~~~~~~~~~~~~~~~)
    wire [1:0] tune_a = challenge[57:56];                   // Common for all Chain A PDLs
    wire [1:0] tune_b = challenge[61:60];                   // Common for all Chain B PDLs

    wire t1_a_delayed, t1_b_delayed;                        // DEEP-TAP 1: 1/4 Mark (Bit 16)
    lightweight_pdl pdl_t1_a (.in_sig(chain_a[16]), .tune(tune_a), .out_sig(t1_a_delayed));
    lightweight_pdl pdl_t1_b (.in_sig(chain_b[16]), .tune(tune_b), .out_sig(t1_b_delayed));
    
    wire nand_a1, nand_b1;                                  // intermediate arbiter (same as final arbiter in ccdl_puf.v)
    (* DONT_TOUCH = "TRUE" *) LUT2 #(.INIT(4'b0111)) arb1_a (.O(nand_a1), .I0(t1_a_delayed), .I1(nand_b1));
    (* DONT_TOUCH = "TRUE" *) LUT2 #(.INIT(4'b0111)) arb1_b (.O(nand_b1), .I0(t1_b_delayed), .I1(nand_a1));
    assign multi_bit_response[0] = nand_a1;

    wire t2_a_delayed, t2_b_delayed;                        // DEEP-TAP 2: 2/4 Mark (Bit 32)
    lightweight_pdl pdl_t2_a (.in_sig(chain_a[32]), .tune(tune_a), .out_sig(t2_a_delayed));
    lightweight_pdl pdl_t2_b (.in_sig(chain_b[32]), .tune(tune_b), .out_sig(t2_b_delayed));
    
    wire nand_a2, nand_b2;                                  // intermediate arbiter (same as final arbiter in ccdl_puf.v
    (* DONT_TOUCH = "TRUE" *) LUT2 #(.INIT(4'b0111)) arb2_a (.O(nand_a2), .I0(t2_a_delayed), .I1(nand_b2));
    (* DONT_TOUCH = "TRUE" *) LUT2 #(.INIT(4'b0111)) arb2_b (.O(nand_b2), .I0(t2_b_delayed), .I1(nand_a2));
    assign multi_bit_response[1] = nand_a2;

    wire t3_a_delayed, t3_b_delayed;                        // DEEP-TAP 3: 3/4 Mark (Bit 48)
    lightweight_pdl pdl_t3_a (.in_sig(chain_a[48]), .tune(tune_a), .out_sig(t3_a_delayed));
    lightweight_pdl pdl_t3_b (.in_sig(chain_b[48]), .tune(tune_b), .out_sig(t3_b_delayed));
    
    wire nand_a3, nand_b3;                                  // intermediate arbiter (same as final arbiter in ccdl_puf.v
    (* DONT_TOUCH = "TRUE" *) LUT2 #(.INIT(4'b0111)) arb3_a (.O(nand_a3), .I0(t3_a_delayed), .I1(nand_b3));
    (* DONT_TOUCH = "TRUE" *) LUT2 #(.INIT(4'b0111)) arb3_b (.O(nand_b3), .I0(t3_b_delayed), .I1(nand_a3));
    assign multi_bit_response[2] = nand_a3;

    wire t4_a_delayed, t4_b_delayed;                        // DEEP-TAP 4: 4/4 Mark (Bit 64)
    lightweight_pdl pdl_t4_a (.in_sig(chain_a[64]), .tune(tune_a), .out_sig(t4_a_delayed));
    lightweight_pdl pdl_t4_b (.in_sig(chain_b[64]), .tune(tune_b), .out_sig(t4_b_delayed));
    
    wire nand_a4, nand_b4;                                  // intermediate arbiter (same as final arbiter in ccdl_puf.v
    (* DONT_TOUCH = "TRUE" *) LUT2 #(.INIT(4'b0111)) arb4_a (.O(nand_a4), .I0(t4_a_delayed), .I1(nand_b4));
    (* DONT_TOUCH = "TRUE" *) LUT2 #(.INIT(4'b0111)) arb4_b (.O(nand_b4), .I0(t4_b_delayed), .I1(nand_a4));
    assign multi_bit_response[3] = nand_a4;

endmodule


// ~~~~~~~~~~~~~~~PDL MODULE (4 STATES)~~~~~~~~~~~~~~~
// same as the pdls in ccdl_puf.v
(* KEEP_HIERARCHY = "TRUE" *)               // do not optimize
module lightweight_pdl (
    input wire in_sig,
    input wire [1:0] tune,
    output wire out_sig
);
    wire d1, d2, d3;

    (* DONT_TOUCH = "TRUE" *) LUT1 #(.INIT(2'b10)) b1 (.O(d1), .I0(in_sig));
    (* DONT_TOUCH = "TRUE" *) LUT1 #(.INIT(2'b10)) b2 (.O(d2), .I0(d1));
    (* DONT_TOUCH = "TRUE" *) LUT1 #(.INIT(2'b10)) b3 (.O(d3), .I0(d2));
    
    (* DONT_TOUCH = "TRUE" *) LUT6 #(.INIT(64'hF0AA_CC88_F0AA_CC88)) mux (
        .O(out_sig), .I0(in_sig), .I1(d1), .I2(d2), .I3(d3), .I4(tune[0]), .I5(tune[1])
    );
endmodule