//========================================================================
// FLProc.h
//========================================================================
// Definitions for our functional-level processor

#include "FLInst.h"
#include "FLProc.h"
#include <format>
#include <stdexcept>

//------------------------------------------------------------------------
// Constructor
//------------------------------------------------------------------------

FLProc::FLProc() : pc( 0x200 ) {};

//------------------------------------------------------------------------
// Initialize Memory
//------------------------------------------------------------------------

void FLProc::init( uint32_t addr, uint32_t inst )
{
  mem.init( addr, inst );
}
void FLProc::init( uint32_t addr, std::string assembly )
{
  mem.init( addr, assembly );
}

//------------------------------------------------------------------------
// Execution Step
//------------------------------------------------------------------------

FLTrace FLProc::step()
{
  // Fetch the instruction
  FLInst inst( mem[pc] );

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // add
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if ( inst.name() == "add" ) {
    regs[inst.rd()] = regs[inst.rs1()] + regs[inst.rs2()];
    uint32_t old_pc = pc;
    pc              = pc + 4;
    return FLTrace( old_pc, inst.rd(), regs[inst.rd()], true );
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // addi
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if ( inst.name() == "addi" ) {
    regs[inst.rd()] = regs[inst.rs1()] + inst.imm_i();
    uint32_t old_pc = pc;
    pc              = pc + 4;
    return FLTrace( old_pc, inst.rd(), regs[inst.rd()], true );
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // mul
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if ( inst.name() == "mul" ) {
    regs[inst.rd()] = regs[inst.rs1()] * regs[inst.rs2()];
    uint32_t old_pc = pc;
    pc              = pc + 4;
    return FLTrace( old_pc, inst.rd(), regs[inst.rd()], true );
  }

  // TODO: Add more instructions!

  std::string excp =
      std::format( "Unknown instruction: '{}'", inst.name() );
  throw std::invalid_argument( excp );
}