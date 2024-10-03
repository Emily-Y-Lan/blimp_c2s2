# ========================================================================
# FifoTest.py
# ========================================================================

import os
import pytest

import cocotb
from cocotb.clock import Clock
from cocotb.runner import get_runner
from cocotb.triggers import RisingEdge, Timer
from cocotb.types import Logic, LogicArray

# ------------------------------------------------------------------------
# FifoTester
# ------------------------------------------------------------------------

class FifoTester:
  """A wrapper to execute operations on a Fifo"""

  def __init__( self, fifo ):
    self.fifo = fifo
    self.fifo.push.value = Logic(0)
    self.fifo.pop.value = Logic(0)

    cocotb.start_soon(Clock(self.fifo.clk, 10, units="ns").start())

  async def reset( self ):
    """Reset the FIFO."""
    self.fifo.rst.value = Logic(1)
    for _ in range(3):
      await RisingEdge(self.fifo.clk)
    self.fifo.rst.value = 0

    # Stay #1 ahead of the clock edge
    await Timer(1, "ns")

  async def check( 
    self, 
    rst,
    push,
    pop,
    empty,
    full,
    wdata,
    rdata
  ):
    """Check our values in a given cycle"""
    self.fifo.rst.value = rst
    self.fifo.push.value = push
    self.fifo.pop.value = pop
    self.fifo.wdata.value = wdata

    await Timer(8, "ns")

    print("{:b} {:b} {:b} {:s} > {:b} {:b} {:s}".format(
      self.fifo.rst.value.integer,
      self.fifo.push.value.integer,
      self.fifo.pop.value.integer,
      self.fifo.wdata.value.binstr,
      self.fifo.empty.value.integer,
      self.fifo.full.value.integer,
      self.fifo.rdata.value.binstr
    ))

    assert(self.fifo.empty.value == empty)
    assert(self.fifo.full.value == full)
    assert(self.fifo.rdata.value == rdata)

    await Timer(2, "ns")


# ------------------------------------------------------------------------
# test_1_basic
# ------------------------------------------------------------------------

@cocotb.test
async def basic_test(dut):
  t = FifoTester(dut)
  await t.reset()

  #              rst push pop empty full       wdata       rdata
  await t.check(   0,   0,  0,    1,   0, 0x00000000, 0x00000000 )
  await t.check(   0,   1,  0,    1,   0, 0xdeadbeef, 0x00000000 )
  await t.check(   0,   1,  0,    0,   0, 0xcafef00d, 0xdeadbeef )
  await t.check(   0,   0,  0,    0,   0, 0x00000000, 0xdeadbeef )
  await t.check(   0,   0,  1,    0,   0, 0x00000000, 0xdeadbeef )
  await t.check(   0,   0,  1,    0,   0, 0x00000000, 0xcafef00d )
  await t.check(   0,   0,  0,    1,   0, 0x00000000, 0x00000000 )

# ------------------------------------------------------------------------
# Run Tests
# ------------------------------------------------------------------------
  
tests = [
  "basic_test"
]

@pytest.mark.parametrize("test", tests)
def test_fifo(test, top_dir, build_dir, test_dir, waves):
    """Run a given test on the FIFO."""
    sim = "verilator"
    sources = ["hw/common/Fifo.v"]

    # Create, build, and run a runner
    runner = get_runner(sim)
    runner.build(
        sources = sources,
        hdl_toplevel = "Fifo", # Top-level module to build
        includes = top_dir,
        build_dir = build_dir,
        build_args = [f"--dump-file {test}.vcd"],
        waves = waves
    )
    runner.test(
        hdl_toplevel = "Fifo", # Top-level module to test
        test_module = "hw.common.test.Fifo_test", # The Python module to test with
        test_dir = test_dir,
        testcase = test,
        waves = waves
    )