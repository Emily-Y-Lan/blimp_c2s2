"""A definition of a basic mutable signal


Author: Aidan McNay
Date: September 23rd, 2024
"""

from cocotb.triggers import Timer
from cocotb.types import Logic, LogicArray
from dataclasses import dataclass

@dataclass
class Signal:
    """A representation of a mutable hardware signal."""

    def __init__(self, n_bits = 1):
        self.n_bits = n_bits
        self.changed = False
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
        if name == "value":
            object.__setattr__(self, "changed", True)
        object.__setattr__(self, name, value)

    async def edge(self) -> None:
        """Wait for a change in the signal."""
        while not self.changed:
            await Timer(1, 'step')
        self.changed = False