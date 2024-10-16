# ========================================================================
# Fetch_test.py
# ========================================================================

from math import ceil
import os

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer
from cocotb.types import Logic, LogicArray

from cocode.sim.tests import gen_tests

# ------------------------------------------------------------------------
# FetchTester
# ------------------------------------------------------------------------

class FetchTester:
  """A wrapper to execute operations on a Fetch Unit"""

  def __init__( self, fetch, p_addr_bits, p_inst_bits, p_opaq_bits ):
    self.fetch = fetch
    self.p_addr_bits = p_addr_bits
    self.p_inst_bits = p_inst_bits
    self.p_opaq_bits = p_opaq_bits
    self.p_len_bits  = ceil(p_inst_bits / 8)

    self.mem_msg_bits = 1 + self.p_addr_bits + self.p_inst_bits \
                          + self.p_opaq_bits + self.p_len_bits

    self.fetch.mem_req_rdy.value  = Logic(0)
    self.fetch.mem_resp_val.value = Logic(0)
    self.fetch.mem_resp_msg.value = LogicArray(["X"] * self.mem_msg_bits)

    self.fetch.D_rdy.value           = Logic(0)
    self.fetch.D_squash.value        = Logic(0)
    self.fetch.D_branch_target.value = LogicArray(["X"] * self.p_addr_bits)
    self.fetch.D_branch_val.value    = Logic(0)

    cocotb.start_soon(Clock(self.fetch.clk, 10, units="ns").start())

  async def reset( self ):
    """Reset the Fetch unit."""
    self.fetch.rst.value = Logic(1)
    for _ in range(3):
      await RisingEdge(self.fetch.clk)
    self.fetch.rst.value = 0

    # Stay #1 ahead of the clock edge
    await Timer(1, "ns")

  async def check( 
    self, 
    rst,
    mem_req_val,
    mem_req_rdy,
    mem_req_msg,
    mem_resp_val,
    mem_resp_rdy,
    mem_resp_msg,
    D_inst,
    D_pc,
    D_val,
    D_rdy,
    D_squash,
    D_branch_target,
    D_branch_val
  ):
    """Check our values in a given cycle"""
    self.fetch.rst.value = rst
    self.fetch.mem_req_rdy.value = mem_req_rdy
    self.fetch.mem_resp_val.value = mem_resp_val
    self.fetch.mem_resp_msg.value = mem_resp_msg
    self.fetch.D_rdy.value = D_rdy
    self.fetch.D_squash.value = D_squash
    self.fetch.D_branch_target.value = D_branch_target
    self.fetch.D_branch_val.value = D_branch_val

    await Timer(8, "ns")

    if mem_req_val:
      assert(self.fetch.mem_req_val.value == mem_req_val)
    if mem_req_msg:
      assert(self.fetch.mem_req_msg.value == mem_req_msg)
    if mem_resp_rdy:
      assert(self.fetch.mem_resp_rdy.value == mem_resp_rdy)

    if D_inst:
      assert(self.fetch.D_inst.value == D_inst)
    if D_pc:
      assert(self.fetch.D_pc.value == D_pc)
    if D_val:
      assert(self.fetch.D_val.value == D_val)

    await Timer(2, "ns")


# ------------------------------------------------------------------------
# test_1_basic
# ------------------------------------------------------------------------

@cocotb.test
async def basic_test(dut):
  t = FetchTester(dut, 32, 32, 8)
  await t.reset()
        #           req req req             resp resp resp            D           D           D   D   D  D           D
        #       rst val rdy msg             val  rdy  msg             inst        pc          val rdy sq b_tar       b_val
  await t.check(0,  1,  0,  0x0_0_00000000, 0,   0,   0x0_0_00000000, 0x00000000, 0x00000000, 0,  0,  0, 0x00000000, 0)
  await t.check(0,  1,  1,  0x0_0_00000000, 0,   1,   0x0_0_00000000, 0x00000000, 0x00000000, 0,  1,  0, 0x00000000, 0)
  await t.check(0,  1,  1,  0x4_0_00000000, 1,   1,   0x0_0_deadbeef, 0xdeadbeef, 0x00000000, 1,  1,  0, 0x00000000, 0)
  await t.check(0,  1,  1,  0x8_0_00000000, 1,   1,   0x4_0_cafef00d, 0xcafef00d, 0x00000004, 1,  1,  0, 0x00000000, 0)

# ------------------------------------------------------------------------
# Run Tests
# ------------------------------------------------------------------------

gen_tests("Fetch_flat", ["hw/fetch/flat/Fetch_flat.v"])