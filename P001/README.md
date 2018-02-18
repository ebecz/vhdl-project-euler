# P001 

This is the [P001](https://projecteuler.net/problem=1) Problem from project euler.

The block [P001.vhdl] which solve this problem has the following signals:

| signal  | Description |
| ------------- | ------------- |
| input [16]  | Input Reference of the number bellow which we are going to find the sum of all multiples of 3 or 5 |
| clk  | Clock  |
| rst_n  | Inverted Reset  |
| busy  | Busy Output - Meaning the result is not ready |
| result [32]  | When the busy goes down, the result is available at this output |

The main.vhdl file is used in simulation context to feed the block.
