"""An input stream driver.

Author: Aidan McNay
Date: September 23rd, 2024
"""

import cocotb
from cocotb.triggers import FallingEdge
from cocotb.types import Logic, LogicArray, Range

from framework.utils.signal import Signal


class IStream:
    """A class for driving an input val/rdy stream."""

    def __init__(self, n_bits = 32):
        self.n_bits = n_bits
        self.clk = Signal()
        self.istream_val = Signal()
        self.istream_rdy = Signal()
        self.istream_msg = Signal(n_bits)
        self.msgs: list[int] = []
        self._coro = None

        self.istream_val.value = Logic(0)
        self.istream_msg.value = LogicArray(["X" for _ in range(n_bits)])

    def add_msg(self, msg: int):
        """Add a message to the list of things to try"""
        self.msgs.append(msg)

    def start(self) -> None:
        """Start the driver"""
        if self._coro is not None:
            raise RuntimeError("Driver already started")
        self._coro = cocotb.start_soon(self.run())

    def stop(self) -> None:
        """Stop the driver"""
        if self._coro is None:
            raise RuntimeError("Driver never started")
        self._coro.kill()
        self._coro = None

    async def run(self):
        while True:
            await self.clk.edge()
            if self.clk.value == Logic(0):
                if (len(self.msgs) > 0) and (self.istream_rdy.value):
                    new_msg = self.msgs.pop(0)
                    self.istream_val.value = Logic(1)
                    self.istream_msg.value = LogicArray(new_msg, Range(self.n_bits - 1, "downto", 0))
                else:
                    self.istream_val.value = Logic(0)

