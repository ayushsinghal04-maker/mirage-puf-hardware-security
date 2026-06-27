# Mirage PUF: FPGA Implementation & Machine Learning Resistance Characterization

Official hardware implementation and verification pipeline for the **Mirage PUF**, a structural hardware countermeasure designed to eliminate machine learning learnability at the architectural level.

## Architecture Overview
Standard FPGA routing cannot guarantee the symmetric delay paths that traditional arbiter PUFs require. The Mirage PUF circumvents this by utilizing dedicated Xilinx **CARRY4 primitives** to achieve matched propagation delays within the reconfigurable fabric. 

A secondary carry chain tapped at four physical depths captures its own unobservable, transient analog state. This state generates a dynamic **avalanche mask** that mutates the primary challenge vector mid-evaluation, rendering the true challenge permanently inaccessible to external modeling attacks.

### Key Characteristics & Silicon Metrics
* **Core Footprint:** Highly lightweight, consuming only 32 LUTs and 64 CARRY4 primitives.
* **Randomness:** Achieves a near-ideal **49.99% Inter-Challenge Hamming Distance**.
* **Reliability:** Exhibits an **Intra-Die HD of 1.37%** at ambient conditions without post-processing or on-chip ECC.
* **ML Attack Ceiling:** Under a white-box threat model with full architectural knowledge, Gradient Boosting (LightGBM/XGBoost) and Deep Neural Network (MLP) estimators are strictly capped at a **56.20% prediction accuracy** (statistically indistinguishable from random guessing).

## Repository Structure
* `/rtl`: Core Verilog modules for the dual-track delay lines, SR-latch arbiters, and the 10ns asynchronous hardware stagger layout.
* `/automation`: Python data acquisition scripts for automated challenge-response pair (CRP) extraction via a 115,200 bps UART link.
* `/verification`: Python ML pipeline utilizing Scikit-Learn, LightGBM, and XGBoost to evaluate mathematical cloneability and predictive modeling resistance.

## Publications & Authors
* **Title:** Mirage PUF: FPGA Implementation and Machine Learning Resistance Characterization
* **Authors:** Aditya Malpani, Ayush Singhal, Abhishek Ray, Amit Kumar
* **Institution:** Pandit Deendayal Energy University
* **Verified Record:** [ORCID Profile](https://orcid.org/0009-0001-5399-1691)
