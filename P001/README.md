# P001 

This is the [P001](https://projecteuler.net/problem=1) Problem from project euler.

The block [P001.vhdl] which solve this problem has the following signals:

| signal  | Description |
| ------------- | ------------- |
| ext_ref [16]  | Input Reference of the number bellow which we are going to find the sum, changes this will trigger the block to start doing the calculations  |
| clk  | Clock Input  |
| busy  | Busy Output - Meaning the result is not ready |
| result [32]  | When the bussy goes down, the result is available at this output |

The main.vhdl file is used in simulation context to feed the block.
