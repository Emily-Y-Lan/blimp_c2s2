"""A definition of a basic mutable signal


Author: Aidan McNay
Date: September 23rd, 2024
"""

import asyncio
import cocotb
from cocotb.triggers import Timer
from cocotb.types import Logic, LogicArray
from dataclasses import dataclass

async def forever():
    """A task that runs 'forever'."""
    try:
        await Timer(3600, 'sec')
    except asyncio.CancelledError:
        pass

@dataclass
class Signal:
    """A representation of a mutable hardware signal."""

    def __init__(self, n_bits = 1):
        self.n_bits = n_bits
        self.waiting_for_change = []
        if n_bits <= 0:
            raise Exception("Must have a positive width!")
        if n_bits == 1:
            self.value = Logic()
        else:
            self.value = LogicArray(["X" for _ in range(n_bits)])

    def __len__(self) -> int:
        """Return the width of the signal."""
        return self.n_bits

    def __setattr__(self, name, value) -> None:
        object.__setattr__(self, name, value)
        if name == "value":
            for task in self.waiting_for_change:
                task.cancel()
            self.waiting_for_change = []

    async def edge(self) -> None:
        """Wait for a change in the signal."""
        changed_task = cocotb.create_task(forever())
        self.waiting_for_change.append(changed_task)
        await changed_task