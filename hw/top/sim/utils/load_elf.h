// =======================================================================
// load_elf.h
// =======================================================================
// Declare the external functions needed

#ifndef HW_TOP_SIM_UTILS_LOAD_ELF_H
#define HW_TOP_SIM_UTILS_LOAD_ELF_H

#include "svdpi.h"

#ifdef __cplusplus
extern "C"
#endif
    void
    init_mem( const svBitVecVal* addr, const svBitVecVal* data );

#endif  // HW_TOP_SIM_UTILS_LOAD_ELF_H