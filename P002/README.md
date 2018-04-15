# P002

This is the [P002](https://projecteuler.net/problem=2) Problem from project euler.

The block [P002.vhdl] which solve this problem has the following signals:

| signal  | Description |
| ------------- | ------------- |
| ext_ref [32]  | Input Reference of the limit which we will compute the fibonancy sequence, changes this will trigger the block to start doing the calculations  |
| clk  | Clock Input  |
| busy  | Busy Output - Meaning the result is not ready |
| error  | Error Output - High when a overflow happened - the process continues even with a error |
| result [32]  | When the bussy goes down, the result is available at this output |

The main.vhdl file is used in simulation context to feed the block.
