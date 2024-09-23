# =============================================================================
# GcdUnit-test.py
# =============================================================================
# A test of our GCD unit using cocotb

import cocotb

from cocotb.clock import Clock
from cocotb.handle import SimHandleBase
from cocotb.runner import get_runner
from cocotb.triggers import RisingEdge, FallingEdge, ClockCycles
from cocotb.types import LogicArray

from math import gcd
import os
import pytest
import random

random.seed(0xdeadbeef)

from framework.testing.IStream import IStream
from framework.testing.OStream import OStream
from framework.utils.assign import assign

# -----------------------------------------------------------------------------
# Define the tests
# -----------------------------------------------------------------------------

@cocotb.test()
async def simple_test(dut):
    """Provide a simple test for the GCD unit"""
    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())
    
    src = IStream(32)
    snk = OStream(16)

    assign(src.istream_val, dut.istream_val)
    assign(dut.istream_rdy, src.istream_rdy)
    assign(src.istream_msg, dut.istream_msg)

    assign(dut.ostream_val, snk.ostream_val)
    assign(snk.ostream_rdy, dut.ostream_rdy)
    assign(dut.ostream_msg, snk.ostream_msg)

    def add_test(a, b):
        src.add_msg((a << 16) | b)
        snk.add_exp_msg(gcd(a, b))

    add_test(8, 12)

    # Reset the design
    dut.reset.value = 1
    for _ in range(3):
        await RisingEdge(dut.clk)
    dut.reset.value = 0

    # Start the test
    cocotb.start(src.run())
    cocotb.start(snk.run())

    # Wait for the operation to pass through
    while len(snk.exp_msgs) > 0:
        await RisingEdge(dut.clk)
    print("All tests passed")

# @cocotb.test()
# async def random_test(dut):
#     """Test with random inputs"""
#     cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())
#     tester = GCDTester(dut)

#     min_input = 0
#     max_input = (1 << 16) - 1

#     for _ in range(50):
#         a = random.randint(min_input, max_input)
#         b = random.randint(min_input, max_input)
#         tester.add_test(
#             a,
#             b
#         )

#     # Reset the design
#     dut.reset.value = 1
#     for _ in range(3):
#         await RisingEdge(dut.clk)
#     dut.reset.value = 0

#     # Start the test
#     tester.start()

#     # Wait for the operations to pass through
#     while not tester.passed():
#         await RisingEdge(dut.clk)
#     print("All tests passed")

# -----------------------------------------------------------------------------
# Run the tests
# -----------------------------------------------------------------------------

def test_sort_unit():
    """Run the tests with cocotb"""
    sim = "verilator"
    sources = [
        "GcdUnit.v"
    ]

    # Create, build, and run a runner
    runner = get_runner(sim)
    runner.build(
        sources = sources,
        hdl_toplevel = "tut3_verilog_gcd_GcdUnit", # Top-level module to build
        includes = ["."],
        defines = {"SYNTHESIS": "ON"},
        always = True # Always re-build
    )
    runner.test(
        hdl_toplevel = "tut3_verilog_gcd_GcdUnit", # Top-level module to test
        test_module = "GCDUnitCocotb_test", # The Python module to test with
    )