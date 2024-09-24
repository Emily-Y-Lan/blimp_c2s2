"""An output stream sink.

Author: Aidan McNay
Date: September 23rd, 2024
"""

import cocotb
from cocotb.triggers import FallingEdge
from cocotb.types import Logic, LogicArray, Range

from framework.utils.signal import Signal


class OStream:
    """Monitors the output of the sort unit"""

    def __init__(self, n_bits = 32):
        """Initialize the monitor"""
        self.n_bits = n_bits
        self.clk = Signal()
        self.ostream_val = Signal()
        self.ostream_rdy = Signal()
        self.ostream_msg = Signal(n_bits)
        self.exp_msgs = []
        self._coro = None

        self.ostream_rdy.value = 0

    def add_exp_msg(self, msg) -> None:
        """Add to the expected messages to receive"""
        self.exp_msgs.append(msg)

    def start(self) -> None:
        """Start the monitor"""
        if self._coro is not None:
            raise RuntimeError("Monitor already started")
        self._coro = cocotb.start_soon(self.run())

    def stop(self) -> None:
        """Stop monitor"""
        if self._coro is None:
            raise RuntimeError("Monitor never started")
        self._coro.kill()
        self._coro = None

    def passed(self) -> bool:
        """Whether the design passed - same as having no more messages"""
        return len(self.exp_msgs) == 0

    async def run(self):
        while True:
            await self.clk.edge()
            if self.clk.value == Logic(0):
                if self.ostream_val.value == Logic(1):
                    if len(self.exp_msgs) == 0:
                        raise Exception("Didn't expect a message")
                    exp_msg = self.exp_msgs.pop(0)
                    assert self.ostream_msg.value.integer == exp_msg
                    self.ostream_rdy.value = Logic(1)
                else:
                    self.ostream_rdy.value = Logic(0)

