//========================================================================
// FLProc.h
//========================================================================
// Definitions for our functional-level processor

#include "asm/assemble.h"
#include "asm/inst.h"
#include "fl/FLProc.h"
#include <format>
#include <stdexcept>

//------------------------------------------------------------------------
// Constructor
//------------------------------------------------------------------------

FLProc::FLProc() : pc( 0x200 ) {};

//------------------------------------------------------------------------
// Reset
//------------------------------------------------------------------------

void FLProc::reset()
{
  pc = 0x200;
  mem.clear();
}

//------------------------------------------------------------------------
// Initialize Memory
//------------------------------------------------------------------------

void FLProc::init( uint32_t addr, uint32_t inst )
{
  mem[addr] = inst;
}
void FLProc::init( uint32_t addr, std::string assembly )
{
  mem[addr] = assemble( assembly.c_str(), addr );
}

//------------------------------------------------------------------------
// Execution Step
//------------------------------------------------------------------------

FLTrace FLProc::step()
{
  // Fetch the instruction
  FLInst      inst( mem[pc] );
  inst_name_t inst_name = inst.name();
  uint32_t    old_pc    = pc;

  switch ( inst_name ) {
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      // add
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    case ADD:
      regs[inst.rd()] = regs[inst.rs1()] + regs[inst.rs2()];
      pc              = pc + 4;
      return FLTrace( old_pc, inst.rd(), regs[inst.rd()],
                      inst.rd() != 0 );

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      // addi
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    case ADDI:
      regs[inst.rd()] = regs[inst.rs1()] + inst.imm_i();
      pc              = pc + 4;
      return FLTrace( old_pc, inst.rd(), regs[inst.rd()],
                      inst.rd() != 0 );

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      // mul
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    case MUL:
      regs[inst.rd()] = regs[inst.rs1()] * regs[inst.rs2()];
      pc              = pc + 4;
      return FLTrace( old_pc, inst.rd(), regs[inst.rd()],
                      inst.rd() != 0 );

      // TODO: Add more instructions!

    default:
      std::string excp =
          std::format( "Unknown instruction: '{}'", inst.mnemonic() );
      throw std::invalid_argument( excp );
  }
}