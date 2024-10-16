# ========================================================================
# Fifo_test.py
# ========================================================================

import os

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer
from cocotb.types import Logic

from cocode.sim.tests import gen_tests

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

    if empty:
      assert(self.fifo.empty.value == empty)
    if full:
      assert(self.fifo.full.value == full)
    if rdata:
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
# test_2_full
# ------------------------------------------------------------------------

@cocotb.test
async def full_test(dut):
  t = FifoTester(dut)
  depth = int(os.environ["p_depth"])
  await t.reset()

  #              rst push pop empty full       wdata  rdata
  await t.check(   0,   0,  0,    1,   0, 0x00000000,  None )

  # Push until full
  for i in range(depth):
    empty = (i == 0)
    rdata = 0x00000000 if empty else 0xdeadbeef
    await t.check( 0, 1, 0, empty, 0, 0xdeadbeef, rdata)
  
  #              rst push pop empty full       wdata       rdata
  await t.check(   0,   0,  0,    0,   1, 0x00000000, 0xdeadbeef )

  # Pop until empty
  for i in range(depth):
    full = (i == 0)
    await t.check( 0, 0, 1, 0, full, 0x00000000, 0xdeadbeef)

  #              rst push pop empty full       wdata  rdata
  await t.check(   0,   0,  0,    1,   0, 0x00000000,  None )

# ------------------------------------------------------------------------
# Run Tests
# ------------------------------------------------------------------------

params_to_try = [
  {"p_depth": "2"},
  {"p_depth": "8"},
  {"p_depth": "32"},
]

gen_tests("Fifo", ["hw/common/Fifo.v"], params_to_try)
