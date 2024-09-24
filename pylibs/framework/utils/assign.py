"""A function to bind two cocotb datatypes.

Author: Aidan McNay
Date: September 23rd, 2024
"""

import cocotb
from cocotb.triggers import Edge
from cocotb.types import Logic, LogicArray, Range
from typing import Union

from framework.utils.signal import Signal

def assign(load, driver):
    """Bind two signals together. The second signal is the driver.

    Args:
        driver (Assignable): The driving signal
        load (Assignable): The load signal
    """
    if isinstance(load, cocotb.handle.NonConstantObject):
        # Make sure there's no other drivers
        if len(list(load.drivers())) > 0:
            raise Exception("Trying to assign to an already-driven signal!")
        
    if len(driver) != len(load):
        raise Exception("Can't bind signals of different lengths!")
    
    signal_len = len(driver)

    # Bind the driver and load
    if isinstance(driver, cocotb.handle.NonConstantObject):
        def update():
            if isinstance(load, cocotb.handle.NonConstantObject):
                load.binstr = driver.binstr
            else:
                if signal_len == 1:
                    load.value = Logic(driver.value.binstr)
                else:
                    load.value = LogicArray(driver.value.binstr, Range(signal_len - 1, "downto", 0))
    else:
        def update():
            if isinstance(load, cocotb.handle.NonConstantObject):
                if signal_len == 1:
                    load.value = driver.value
                else:
                    load.value = driver.value
            else:
                load.value = driver.value

    update()
    async def update_trigger():
        while True:
            if isinstance(driver, cocotb.handle.NonConstantObject):
                await Edge(driver)
                update()
            else:
                await driver.edge()
                update()

    cocotb.start_soon(update_trigger())