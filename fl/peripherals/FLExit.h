//========================================================================
// FLExit.h
//========================================================================
// A memory-mapped peripheral for terminating the simulation

#ifndef FL_EXIT_H
#define FL_EXIT_H

#include "fl/FLPeripheral.h"

class FLExit : public FLPeripheral {
  //----------------------------------------------------------------------
  // Address Ranges
  //----------------------------------------------------------------------

  std::vector<address_range_t> address_ranges = {
      { 0xFFFFFFFF, 0xFFFFFFFF, W },  // exit
  };

  //----------------------------------------------------------------------
  // Accessors
  //----------------------------------------------------------------------

  void read( uint32_t addr, uint32_t* data ) override;
  void write( uint32_t addr, uint32_t data ) override;
  const std::vector<address_range_t>& get_address_ranges() override
  {
    return address_ranges;
  }
};

#endif  // FL_TERMINAL_H
