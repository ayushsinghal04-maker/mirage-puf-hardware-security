# 100MHz System Clock
set_property -dict { PACKAGE_PIN E3    IOSTANDARD LVCMOS33 } [get_ports { clk }];
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports { clk }];

# USB-UART Interface (FTDI Chip on Nexys A7)
set_property -dict { PACKAGE_PIN C4    IOSTANDARD LVCMOS33 } [get_ports { rx }];
set_property -dict { PACKAGE_PIN D4    IOSTANDARD LVCMOS33 } [get_ports { tx }];

# ========================================================
# 1. UPPER PUF RACETRACK (X30 & X34)
# ========================================================
set_property LOC SLICE_X30Y50 [get_cells my_ipuf/upper_puf_inst/carry_chain_gen\[0\].first_stage.carry_a_inst]
set_property LOC SLICE_X34Y50 [get_cells my_ipuf/upper_puf_inst/carry_chain_gen\[0\].first_stage.carry_b_inst]
set_property LOC SLICE_X30Y51 [get_cells my_ipuf/upper_puf_inst/carry_chain_gen\[1\].next_stages.carry_a_inst]
set_property LOC SLICE_X34Y51 [get_cells my_ipuf/upper_puf_inst/carry_chain_gen\[1\].next_stages.carry_b_inst]
set_property LOC SLICE_X30Y52 [get_cells my_ipuf/upper_puf_inst/carry_chain_gen\[2\].next_stages.carry_a_inst]
set_property LOC SLICE_X34Y52 [get_cells my_ipuf/upper_puf_inst/carry_chain_gen\[2\].next_stages.carry_b_inst]
set_property LOC SLICE_X30Y53 [get_cells my_ipuf/upper_puf_inst/carry_chain_gen\[3\].next_stages.carry_a_inst]
set_property LOC SLICE_X34Y53 [get_cells my_ipuf/upper_puf_inst/carry_chain_gen\[3\].next_stages.carry_b_inst]
set_property LOC SLICE_X30Y54 [get_cells my_ipuf/upper_puf_inst/carry_chain_gen\[4\].next_stages.carry_a_inst]
set_property LOC SLICE_X34Y54 [get_cells my_ipuf/upper_puf_inst/carry_chain_gen\[4\].next_stages.carry_b_inst]
set_property LOC SLICE_X30Y55 [get_cells my_ipuf/upper_puf_inst/carry_chain_gen\[5\].next_stages.carry_a_inst]
set_property LOC SLICE_X34Y55 [get_cells my_ipuf/upper_puf_inst/carry_chain_gen\[5\].next_stages.carry_b_inst]
set_property LOC SLICE_X30Y56 [get_cells my_ipuf/upper_puf_inst/carry_chain_gen\[6\].next_stages.carry_a_inst]
set_property LOC SLICE_X34Y56 [get_cells my_ipuf/upper_puf_inst/carry_chain_gen\[6\].next_stages.carry_b_inst]
set_property LOC SLICE_X30Y57 [get_cells my_ipuf/upper_puf_inst/carry_chain_gen\[7\].next_stages.carry_a_inst]
set_property LOC SLICE_X34Y57 [get_cells my_ipuf/upper_puf_inst/carry_chain_gen\[7\].next_stages.carry_b_inst]
set_property LOC SLICE_X30Y58 [get_cells my_ipuf/upper_puf_inst/carry_chain_gen\[8\].next_stages.carry_a_inst]
set_property LOC SLICE_X34Y58 [get_cells my_ipuf/upper_puf_inst/carry_chain_gen\[8\].next_stages.carry_b_inst]
set_property LOC SLICE_X30Y59 [get_cells my_ipuf/upper_puf_inst/carry_chain_gen\[9\].next_stages.carry_a_inst]
set_property LOC SLICE_X34Y59 [get_cells my_ipuf/upper_puf_inst/carry_chain_gen\[9\].next_stages.carry_b_inst]
set_property LOC SLICE_X30Y60 [get_cells my_ipuf/upper_puf_inst/carry_chain_gen\[10\].next_stages.carry_a_inst]
set_property LOC SLICE_X34Y60 [get_cells my_ipuf/upper_puf_inst/carry_chain_gen\[10\].next_stages.carry_b_inst]
set_property LOC SLICE_X30Y61 [get_cells my_ipuf/upper_puf_inst/carry_chain_gen\[11\].next_stages.carry_a_inst]
set_property LOC SLICE_X34Y61 [get_cells my_ipuf/upper_puf_inst/carry_chain_gen\[11\].next_stages.carry_b_inst]
set_property LOC SLICE_X30Y62 [get_cells my_ipuf/upper_puf_inst/carry_chain_gen\[12\].next_stages.carry_a_inst]
set_property LOC SLICE_X34Y62 [get_cells my_ipuf/upper_puf_inst/carry_chain_gen\[12\].next_stages.carry_b_inst]
set_property LOC SLICE_X30Y63 [get_cells my_ipuf/upper_puf_inst/carry_chain_gen\[13\].next_stages.carry_a_inst]
set_property LOC SLICE_X34Y63 [get_cells my_ipuf/upper_puf_inst/carry_chain_gen\[13\].next_stages.carry_b_inst]
set_property LOC SLICE_X30Y64 [get_cells my_ipuf/upper_puf_inst/carry_chain_gen\[14\].next_stages.carry_a_inst]
set_property LOC SLICE_X34Y64 [get_cells my_ipuf/upper_puf_inst/carry_chain_gen\[14\].next_stages.carry_b_inst]
set_property LOC SLICE_X30Y65 [get_cells my_ipuf/upper_puf_inst/carry_chain_gen\[15\].next_stages.carry_a_inst]
set_property LOC SLICE_X34Y65 [get_cells my_ipuf/upper_puf_inst/carry_chain_gen\[15\].next_stages.carry_b_inst]

# ========================================================
# 2. UPPER PUF: LIGHTWEIGHT PDLS & ASYMMETRICAL ARBITER
# ========================================================
# Arbiter (Shifted Left to X31 for Coarse Tuning)
set_property BEL A6LUT [get_cells {my_ipuf/upper_puf_inst/nand_a}]
set_property LOC SLICE_X31Y66 [get_cells {my_ipuf/upper_puf_inst/nand_a}]
set_property BEL B6LUT [get_cells {my_ipuf/upper_puf_inst/nand_b}]
set_property LOC SLICE_X31Y66 [get_cells {my_ipuf/upper_puf_inst/nand_b}]

# PDL A (Flush with Track A at X30)
set_property BEL A6LUT [get_cells {my_ipuf/upper_puf_inst/a_b1}]
set_property LOC SLICE_X30Y66 [get_cells {my_ipuf/upper_puf_inst/a_b1}]
set_property BEL B6LUT [get_cells {my_ipuf/upper_puf_inst/a_b2}]
set_property LOC SLICE_X30Y66 [get_cells {my_ipuf/upper_puf_inst/a_b2}]
set_property BEL C6LUT [get_cells {my_ipuf/upper_puf_inst/a_b3}]
set_property LOC SLICE_X30Y66 [get_cells {my_ipuf/upper_puf_inst/a_b3}]
set_property BEL D6LUT [get_cells {my_ipuf/upper_puf_inst/mux_a1}]
set_property LOC SLICE_X30Y66 [get_cells {my_ipuf/upper_puf_inst/mux_a1}]

# PDL B (Flush with Track B at X34)
set_property BEL A6LUT [get_cells {my_ipuf/upper_puf_inst/b_b1}]
set_property LOC SLICE_X34Y66 [get_cells {my_ipuf/upper_puf_inst/b_b1}]
set_property BEL B6LUT [get_cells {my_ipuf/upper_puf_inst/b_b2}]
set_property LOC SLICE_X34Y66 [get_cells {my_ipuf/upper_puf_inst/b_b2}]
set_property BEL C6LUT [get_cells {my_ipuf/upper_puf_inst/b_b3}]
set_property LOC SLICE_X34Y66 [get_cells {my_ipuf/upper_puf_inst/b_b3}]
set_property BEL D6LUT [get_cells {my_ipuf/upper_puf_inst/mux_b1}]
set_property LOC SLICE_X34Y66 [get_cells {my_ipuf/upper_puf_inst/mux_b1}]


# ========================================================
# 3. LOWER PUF RACETRACK (X38 & X42)
# ========================================================
set_property LOC SLICE_X38Y50 [get_cells my_ipuf/lower_puf_inst/carry_chain_gen\[0\].first_stage.carry_a_inst]
set_property LOC SLICE_X42Y50 [get_cells my_ipuf/lower_puf_inst/carry_chain_gen\[0\].first_stage.carry_b_inst]
set_property LOC SLICE_X38Y51 [get_cells my_ipuf/lower_puf_inst/carry_chain_gen\[1\].next_stages.carry_a_inst]
set_property LOC SLICE_X42Y51 [get_cells my_ipuf/lower_puf_inst/carry_chain_gen\[1\].next_stages.carry_b_inst]
set_property LOC SLICE_X38Y52 [get_cells my_ipuf/lower_puf_inst/carry_chain_gen\[2\].next_stages.carry_a_inst]
set_property LOC SLICE_X42Y52 [get_cells my_ipuf/lower_puf_inst/carry_chain_gen\[2\].next_stages.carry_b_inst]
set_property LOC SLICE_X38Y53 [get_cells my_ipuf/lower_puf_inst/carry_chain_gen\[3\].next_stages.carry_a_inst]
set_property LOC SLICE_X42Y53 [get_cells my_ipuf/lower_puf_inst/carry_chain_gen\[3\].next_stages.carry_b_inst]
set_property LOC SLICE_X38Y54 [get_cells my_ipuf/lower_puf_inst/carry_chain_gen\[4\].next_stages.carry_a_inst]
set_property LOC SLICE_X42Y54 [get_cells my_ipuf/lower_puf_inst/carry_chain_gen\[4\].next_stages.carry_b_inst]
set_property LOC SLICE_X38Y55 [get_cells my_ipuf/lower_puf_inst/carry_chain_gen\[5\].next_stages.carry_a_inst]
set_property LOC SLICE_X42Y55 [get_cells my_ipuf/lower_puf_inst/carry_chain_gen\[5\].next_stages.carry_b_inst]
set_property LOC SLICE_X38Y56 [get_cells my_ipuf/lower_puf_inst/carry_chain_gen\[6\].next_stages.carry_a_inst]
set_property LOC SLICE_X42Y56 [get_cells my_ipuf/lower_puf_inst/carry_chain_gen\[6\].next_stages.carry_b_inst]
set_property LOC SLICE_X38Y57 [get_cells my_ipuf/lower_puf_inst/carry_chain_gen\[7\].next_stages.carry_a_inst]
set_property LOC SLICE_X42Y57 [get_cells my_ipuf/lower_puf_inst/carry_chain_gen\[7\].next_stages.carry_b_inst]
set_property LOC SLICE_X38Y58 [get_cells my_ipuf/lower_puf_inst/carry_chain_gen\[8\].next_stages.carry_a_inst]
set_property LOC SLICE_X42Y58 [get_cells my_ipuf/lower_puf_inst/carry_chain_gen\[8\].next_stages.carry_b_inst]
set_property LOC SLICE_X38Y59 [get_cells my_ipuf/lower_puf_inst/carry_chain_gen\[9\].next_stages.carry_a_inst]
set_property LOC SLICE_X42Y59 [get_cells my_ipuf/lower_puf_inst/carry_chain_gen\[9\].next_stages.carry_b_inst]
set_property LOC SLICE_X38Y60 [get_cells my_ipuf/lower_puf_inst/carry_chain_gen\[10\].next_stages.carry_a_inst]
set_property LOC SLICE_X42Y60 [get_cells my_ipuf/lower_puf_inst/carry_chain_gen\[10\].next_stages.carry_b_inst]
set_property LOC SLICE_X38Y61 [get_cells my_ipuf/lower_puf_inst/carry_chain_gen\[11\].next_stages.carry_a_inst]
set_property LOC SLICE_X42Y61 [get_cells my_ipuf/lower_puf_inst/carry_chain_gen\[11\].next_stages.carry_b_inst]
set_property LOC SLICE_X38Y62 [get_cells my_ipuf/lower_puf_inst/carry_chain_gen\[12\].next_stages.carry_a_inst]
set_property LOC SLICE_X42Y62 [get_cells my_ipuf/lower_puf_inst/carry_chain_gen\[12\].next_stages.carry_b_inst]
set_property LOC SLICE_X38Y63 [get_cells my_ipuf/lower_puf_inst/carry_chain_gen\[13\].next_stages.carry_a_inst]
set_property LOC SLICE_X42Y63 [get_cells my_ipuf/lower_puf_inst/carry_chain_gen\[13\].next_stages.carry_b_inst]
set_property LOC SLICE_X38Y64 [get_cells my_ipuf/lower_puf_inst/carry_chain_gen\[14\].next_stages.carry_a_inst]
set_property LOC SLICE_X42Y64 [get_cells my_ipuf/lower_puf_inst/carry_chain_gen\[14\].next_stages.carry_b_inst]
set_property LOC SLICE_X38Y65 [get_cells my_ipuf/lower_puf_inst/carry_chain_gen\[15\].next_stages.carry_a_inst]
set_property LOC SLICE_X42Y65 [get_cells my_ipuf/lower_puf_inst/carry_chain_gen\[15\].next_stages.carry_b_inst]


# ========================================================
# 4. LOWER PUF: DEEP-TAP ARBITERS & LIGHTWEIGHT PDLS 
# (ALL ARBITERS ASYMMETRICALLY SHIFTED TO X39)
# ========================================================

# TAP 1 (1/4 mark - Stage 4 -> Y54)
set_property BEL A6LUT [get_cells {my_ipuf/lower_puf_inst/arb1_a}]
set_property LOC SLICE_X39Y54 [get_cells {my_ipuf/lower_puf_inst/arb1_a}]
set_property BEL B6LUT [get_cells {my_ipuf/lower_puf_inst/arb1_b}]
set_property LOC SLICE_X39Y54 [get_cells {my_ipuf/lower_puf_inst/arb1_b}]

set_property BEL A6LUT [get_cells {my_ipuf/lower_puf_inst/pdl_t1_a/b1}]
set_property LOC SLICE_X38Y54 [get_cells {my_ipuf/lower_puf_inst/pdl_t1_a/b1}]
set_property BEL B6LUT [get_cells {my_ipuf/lower_puf_inst/pdl_t1_a/b2}]
set_property LOC SLICE_X38Y54 [get_cells {my_ipuf/lower_puf_inst/pdl_t1_a/b2}]
set_property BEL C6LUT [get_cells {my_ipuf/lower_puf_inst/pdl_t1_a/b3}]
set_property LOC SLICE_X38Y54 [get_cells {my_ipuf/lower_puf_inst/pdl_t1_a/b3}]
set_property BEL D6LUT [get_cells {my_ipuf/lower_puf_inst/pdl_t1_a/mux}]
set_property LOC SLICE_X38Y54 [get_cells {my_ipuf/lower_puf_inst/pdl_t1_a/mux}]

set_property BEL A6LUT [get_cells {my_ipuf/lower_puf_inst/pdl_t1_b/b1}]
set_property LOC SLICE_X42Y54 [get_cells {my_ipuf/lower_puf_inst/pdl_t1_b/b1}]
set_property BEL B6LUT [get_cells {my_ipuf/lower_puf_inst/pdl_t1_b/b2}]
set_property LOC SLICE_X42Y54 [get_cells {my_ipuf/lower_puf_inst/pdl_t1_b/b2}]
set_property BEL C6LUT [get_cells {my_ipuf/lower_puf_inst/pdl_t1_b/b3}]
set_property LOC SLICE_X42Y54 [get_cells {my_ipuf/lower_puf_inst/pdl_t1_b/b3}]
set_property BEL D6LUT [get_cells {my_ipuf/lower_puf_inst/pdl_t1_b/mux}]
set_property LOC SLICE_X42Y54 [get_cells {my_ipuf/lower_puf_inst/pdl_t1_b/mux}]

# TAP 2 (1/2 mark - Stage 8 -> Y58)
set_property BEL A6LUT [get_cells {my_ipuf/lower_puf_inst/arb2_a}]
set_property LOC SLICE_X39Y58 [get_cells {my_ipuf/lower_puf_inst/arb2_a}]
set_property BEL B6LUT [get_cells {my_ipuf/lower_puf_inst/arb2_b}]
set_property LOC SLICE_X39Y58 [get_cells {my_ipuf/lower_puf_inst/arb2_b}]

set_property BEL A6LUT [get_cells {my_ipuf/lower_puf_inst/pdl_t2_a/b1}]
set_property LOC SLICE_X38Y58 [get_cells {my_ipuf/lower_puf_inst/pdl_t2_a/b1}]
set_property BEL B6LUT [get_cells {my_ipuf/lower_puf_inst/pdl_t2_a/b2}]
set_property LOC SLICE_X38Y58 [get_cells {my_ipuf/lower_puf_inst/pdl_t2_a/b2}]
set_property BEL C6LUT [get_cells {my_ipuf/lower_puf_inst/pdl_t2_a/b3}]
set_property LOC SLICE_X38Y58 [get_cells {my_ipuf/lower_puf_inst/pdl_t2_a/b3}]
set_property BEL D6LUT [get_cells {my_ipuf/lower_puf_inst/pdl_t2_a/mux}]
set_property LOC SLICE_X38Y58 [get_cells {my_ipuf/lower_puf_inst/pdl_t2_a/mux}]

set_property BEL A6LUT [get_cells {my_ipuf/lower_puf_inst/pdl_t2_b/b1}]
set_property LOC SLICE_X42Y58 [get_cells {my_ipuf/lower_puf_inst/pdl_t2_b/b1}]
set_property BEL B6LUT [get_cells {my_ipuf/lower_puf_inst/pdl_t2_b/b2}]
set_property LOC SLICE_X42Y58 [get_cells {my_ipuf/lower_puf_inst/pdl_t2_b/b2}]
set_property BEL C6LUT [get_cells {my_ipuf/lower_puf_inst/pdl_t2_b/b3}]
set_property LOC SLICE_X42Y58 [get_cells {my_ipuf/lower_puf_inst/pdl_t2_b/b3}]
set_property BEL D6LUT [get_cells {my_ipuf/lower_puf_inst/pdl_t2_b/mux}]
set_property LOC SLICE_X42Y58 [get_cells {my_ipuf/lower_puf_inst/pdl_t2_b/mux}]

# TAP 3 (3/4 mark - Stage 12 -> Y62)
set_property BEL A6LUT [get_cells {my_ipuf/lower_puf_inst/arb3_a}]
set_property LOC SLICE_X39Y62 [get_cells {my_ipuf/lower_puf_inst/arb3_a}]
set_property BEL B6LUT [get_cells {my_ipuf/lower_puf_inst/arb3_b}]
set_property LOC SLICE_X39Y62 [get_cells {my_ipuf/lower_puf_inst/arb3_b}]

set_property BEL A6LUT [get_cells {my_ipuf/lower_puf_inst/pdl_t3_a/b1}]
set_property LOC SLICE_X38Y62 [get_cells {my_ipuf/lower_puf_inst/pdl_t3_a/b1}]
set_property BEL B6LUT [get_cells {my_ipuf/lower_puf_inst/pdl_t3_a/b2}]
set_property LOC SLICE_X38Y62 [get_cells {my_ipuf/lower_puf_inst/pdl_t3_a/b2}]
set_property BEL C6LUT [get_cells {my_ipuf/lower_puf_inst/pdl_t3_a/b3}]
set_property LOC SLICE_X38Y62 [get_cells {my_ipuf/lower_puf_inst/pdl_t3_a/b3}]
set_property BEL D6LUT [get_cells {my_ipuf/lower_puf_inst/pdl_t3_a/mux}]
set_property LOC SLICE_X38Y62 [get_cells {my_ipuf/lower_puf_inst/pdl_t3_a/mux}]

set_property BEL A6LUT [get_cells {my_ipuf/lower_puf_inst/pdl_t3_b/b1}]
set_property LOC SLICE_X42Y62 [get_cells {my_ipuf/lower_puf_inst/pdl_t3_b/b1}]
set_property BEL B6LUT [get_cells {my_ipuf/lower_puf_inst/pdl_t3_b/b2}]
set_property LOC SLICE_X42Y62 [get_cells {my_ipuf/lower_puf_inst/pdl_t3_b/b2}]
set_property BEL C6LUT [get_cells {my_ipuf/lower_puf_inst/pdl_t3_b/b3}]
set_property LOC SLICE_X42Y62 [get_cells {my_ipuf/lower_puf_inst/pdl_t3_b/b3}]
set_property BEL D6LUT [get_cells {my_ipuf/lower_puf_inst/pdl_t3_b/mux}]
set_property LOC SLICE_X42Y62 [get_cells {my_ipuf/lower_puf_inst/pdl_t3_b/mux}]

# TAP 4 (Finish Line - Stage 16 -> Y66)
set_property BEL A6LUT [get_cells {my_ipuf/lower_puf_inst/arb4_a}]
set_property LOC SLICE_X39Y66 [get_cells {my_ipuf/lower_puf_inst/arb4_a}]
set_property BEL B6LUT [get_cells {my_ipuf/lower_puf_inst/arb4_b}]
set_property LOC SLICE_X39Y66 [get_cells {my_ipuf/lower_puf_inst/arb4_b}]

set_property BEL A6LUT [get_cells {my_ipuf/lower_puf_inst/pdl_t4_a/b1}]
set_property LOC SLICE_X38Y66 [get_cells {my_ipuf/lower_puf_inst/pdl_t4_a/b1}]
set_property BEL B6LUT [get_cells {my_ipuf/lower_puf_inst/pdl_t4_a/b2}]
set_property LOC SLICE_X38Y66 [get_cells {my_ipuf/lower_puf_inst/pdl_t4_a/b2}]
set_property BEL C6LUT [get_cells {my_ipuf/lower_puf_inst/pdl_t4_a/b3}]
set_property LOC SLICE_X38Y66 [get_cells {my_ipuf/lower_puf_inst/pdl_t4_a/b3}]
set_property BEL D6LUT [get_cells {my_ipuf/lower_puf_inst/pdl_t4_a/mux}]
set_property LOC SLICE_X38Y66 [get_cells {my_ipuf/lower_puf_inst/pdl_t4_a/mux}]

set_property BEL A6LUT [get_cells {my_ipuf/lower_puf_inst/pdl_t4_b/b1}]
set_property LOC SLICE_X42Y66 [get_cells {my_ipuf/lower_puf_inst/pdl_t4_b/b1}]
set_property BEL B6LUT [get_cells {my_ipuf/lower_puf_inst/pdl_t4_b/b2}]
set_property LOC SLICE_X42Y66 [get_cells {my_ipuf/lower_puf_inst/pdl_t4_b/b2}]
set_property BEL C6LUT [get_cells {my_ipuf/lower_puf_inst/pdl_t4_b/b3}]
set_property LOC SLICE_X42Y66 [get_cells {my_ipuf/lower_puf_inst/pdl_t4_b/b3}]
set_property BEL D6LUT [get_cells {my_ipuf/lower_puf_inst/pdl_t4_b/mux}]
set_property LOC SLICE_X42Y66 [get_cells {my_ipuf/lower_puf_inst/pdl_t4_b/mux}]


# ========================================================
# 5. UNIFIED TRIGGER PLACEMENT
# ========================================================
set_property LOC SLICE_X36Y49 [get_cells {puf_trigger_reg}]

# Asynchronous Trigger Stagger
set_property BEL A6LUT [get_cells {my_ipuf/trig_d1}]
set_property LOC SLICE_X36Y49 [get_cells {my_ipuf/trig_d1}]
set_property BEL B6LUT [get_cells {my_ipuf/trig_d2}]
set_property LOC SLICE_X36Y49 [get_cells {my_ipuf/trig_d2}]
set_property BEL C6LUT [get_cells {my_ipuf/trig_d3}]
set_property LOC SLICE_X36Y49 [get_cells {my_ipuf/trig_d3}]
set_property BEL D6LUT [get_cells {my_ipuf/trig_d4}]
set_property LOC SLICE_X36Y49 [get_cells {my_ipuf/trig_d4}]

set_property BEL A6LUT [get_cells {my_ipuf/trig_d5}]
set_property LOC SLICE_X36Y50 [get_cells {my_ipuf/trig_d5}]
set_property BEL B6LUT [get_cells {my_ipuf/trig_d6}]
set_property LOC SLICE_X36Y50 [get_cells {my_ipuf/trig_d6}]
set_property BEL C6LUT [get_cells {my_ipuf/trig_d7}]
set_property LOC SLICE_X36Y50 [get_cells {my_ipuf/trig_d7}]


# ========================================================
# 6. PUF ARBITER DRC BYPASS (FOR BOTH PUFS + DEEP TAPS)
# ========================================================
set_property SEVERITY {Warning} [get_drc_checks LUTLP-1]
set_property ALLOW_COMBINATORIAL_LOOPS TRUE [get_nets -hierarchical *nand_a_out*]
set_property ALLOW_COMBINATORIAL_LOOPS TRUE [get_nets -hierarchical *nand_b_out*]
set_property ALLOW_COMBINATORIAL_LOOPS TRUE [get_nets -hierarchical *nand_a1*]
set_property ALLOW_COMBINATORIAL_LOOPS TRUE [get_nets -hierarchical *nand_b1*]
set_property ALLOW_COMBINATORIAL_LOOPS TRUE [get_nets -hierarchical *nand_a2*]
set_property ALLOW_COMBINATORIAL_LOOPS TRUE [get_nets -hierarchical *nand_b2*]
set_property ALLOW_COMBINATORIAL_LOOPS TRUE [get_nets -hierarchical *nand_a3*]
set_property ALLOW_COMBINATORIAL_LOOPS TRUE [get_nets -hierarchical *nand_b3*]
set_property ALLOW_COMBINATORIAL_LOOPS TRUE [get_nets -hierarchical *nand_a4*]
set_property ALLOW_COMBINATORIAL_LOOPS TRUE [get_nets -hierarchical *nand_b4*]