//========================================================================
// FLProc.h
//========================================================================
// Definitions for our functional-level processor

#include "asm/assemble.h"
#include "asm/inst.h"
#include "fl/FLProc.h"
#include "fl/parse_elf.h"
#include <format>
#include <iostream>
#include <stdexcept>

//------------------------------------------------------------------------
// Constructor
//------------------------------------------------------------------------

FLProc::FLProc() : pc( 0x200 )
{
  // Add peripherals
  mem.add_peripheral( &terminal );
  mem.add_peripheral( &exit );
};

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
  mem[addr] = assemble( assembly.c_str(), &addr );
}

//------------------------------------------------------------------------
// Execution Step
//------------------------------------------------------------------------

FLTrace FLProc::step()
{
  // Fetch the instruction
  FLInst      inst( mem[pc] );
  inst_name_t inst_name = inst.name();
  uint32_t    inst_pc   = pc;

  switch ( inst_name ) {
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      // add
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    case ADD:
      regs[inst.rd()] = regs[inst.rs1()] + regs[inst.rs2()];
      pc              = pc + 4;
      return FLTrace( inst_pc, inst.rd(), regs[inst.rd()],
                      inst.rd() != 0 );

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      // sub
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    case SUB:
      regs[inst.rd()] = regs[inst.rs1()] - regs[inst.rs2()];
      pc              = pc + 4;
      return FLTrace( inst_pc, inst.rd(), regs[inst.rd()],
                      inst.rd() != 0 );

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      // and
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    case AND:
      regs[inst.rd()] = regs[inst.rs1()] & regs[inst.rs2()];
      pc              = pc + 4;
      return FLTrace( inst_pc, inst.rd(), regs[inst.rd()],
                      inst.rd() != 0 );

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      // or
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    case OR:
      regs[inst.rd()] = regs[inst.rs1()] | regs[inst.rs2()];
      pc              = pc + 4;
      return FLTrace( inst_pc, inst.rd(), regs[inst.rd()],
                      inst.rd() != 0 );

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      // xor
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    case XOR:
      regs[inst.rd()] = regs[inst.rs1()] ^ regs[inst.rs2()];
      pc              = pc + 4;
      return FLTrace( inst_pc, inst.rd(), regs[inst.rd()],
                      inst.rd() != 0 );

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      // slt
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    case SLT:
      regs[inst.rd()] =
          ( (int32_t) regs[inst.rs1()] ) < ( (int32_t) regs[inst.rs2()] );
      pc = pc + 4;
      return FLTrace( inst_pc, inst.rd(), regs[inst.rd()],
                      inst.rd() != 0 );

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      // sltu
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    case SLTU:
      regs[inst.rd()] = regs[inst.rs1()] < regs[inst.rs2()];
      pc              = pc + 4;
      return FLTrace( inst_pc, inst.rd(), regs[inst.rd()],
                      inst.rd() != 0 );

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      // sra
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    case SRA:
      regs[inst.rd()] =
          ( (int32_t) regs[inst.rs1()] ) >> ( regs[inst.rs2()] & 0x1f );
      pc = pc + 4;
      return FLTrace( inst_pc, inst.rd(), regs[inst.rd()],
                      inst.rd() != 0 );

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      // srl
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    case SRL:
      regs[inst.rd()] = regs[inst.rs1()] >> ( regs[inst.rs2()] & 0x1f );
      pc              = pc + 4;
      return FLTrace( inst_pc, inst.rd(), regs[inst.rd()],
                      inst.rd() != 0 );

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      // sll
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    case SLL:
      regs[inst.rd()] = regs[inst.rs1()] << ( regs[inst.rs2()] & 0x1f );
      pc              = pc + 4;
      return FLTrace( inst_pc, inst.rd(), regs[inst.rd()],
                      inst.rd() != 0 );

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      // mul
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    case MUL:
      regs[inst.rd()] = regs[inst.rs1()] * regs[inst.rs2()];
      pc              = pc + 4;
      return FLTrace( inst_pc, inst.rd(), regs[inst.rd()],
                      inst.rd() != 0 );

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      // addi
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    case ADDI:
      regs[inst.rd()] = regs[inst.rs1()] + inst.imm_i();
      pc              = pc + 4;
      return FLTrace( inst_pc, inst.rd(), regs[inst.rd()],
                      inst.rd() != 0 );

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      // andi
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    case ANDI:
      regs[inst.rd()] = regs[inst.rs1()] & inst.imm_i();
      pc              = pc + 4;
      return FLTrace( inst_pc, inst.rd(), regs[inst.rd()],
                      inst.rd() != 0 );

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      // ori
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    case ORI:
      regs[inst.rd()] = regs[inst.rs1()] | inst.imm_i();
      pc              = pc + 4;
      return FLTrace( inst_pc, inst.rd(), regs[inst.rd()],
                      inst.rd() != 0 );

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      // xori
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    case XORI:
      regs[inst.rd()] = regs[inst.rs1()] ^ inst.imm_i();
      pc              = pc + 4;
      return FLTrace( inst_pc, inst.rd(), regs[inst.rd()],
                      inst.rd() != 0 );

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      // slti
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    case SLTI:
      regs[inst.rd()] =
          ( (int32_t) regs[inst.rs1()] ) < ( (int32_t) inst.imm_i() );
      pc = pc + 4;
      return FLTrace( inst_pc, inst.rd(), regs[inst.rd()],
                      inst.rd() != 0 );

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      // sltiu
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    case SLTIU:
      regs[inst.rd()] = regs[inst.rs1()] < inst.imm_i();
      pc              = pc + 4;
      return FLTrace( inst_pc, inst.rd(), regs[inst.rd()],
                      inst.rd() != 0 );

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      // srai
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    case SRAI:
      regs[inst.rd()] = ( (int32_t) regs[inst.rs1()] ) >> inst.imm_is();
      pc              = pc + 4;
      return FLTrace( inst_pc, inst.rd(), regs[inst.rd()],
                      inst.rd() != 0 );

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      // srli
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    case SRLI:
      regs[inst.rd()] = regs[inst.rs1()] >> inst.imm_is();
      pc              = pc + 4;
      return FLTrace( inst_pc, inst.rd(), regs[inst.rd()],
                      inst.rd() != 0 );

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      // slli
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    case SLLI:
      regs[inst.rd()] = regs[inst.rs1()] << inst.imm_is();
      pc              = pc + 4;
      return FLTrace( inst_pc, inst.rd(), regs[inst.rd()],
                      inst.rd() != 0 );

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      // lui
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    case LUI:
      regs[inst.rd()] = inst.imm_u() << 12;
      pc              = pc + 4;
      return FLTrace( inst_pc, inst.rd(), regs[inst.rd()],
                      inst.rd() != 0 );

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      // auipc
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    case AUIPC:
      regs[inst.rd()] = pc + ( inst.imm_u() << 12 );
      pc              = pc + 4;
      return FLTrace( inst_pc, inst.rd(), regs[inst.rd()],
                      inst.rd() != 0 );

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      // lw
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    case LW:
      regs[inst.rd()] = mem.load( regs[inst.rs1()] + inst.imm_i() );
      pc              = pc + 4;
      return FLTrace( inst_pc, inst.rd(), regs[inst.rd()],
                      inst.rd() != 0 );

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      // sw
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    case SW:
      mem.store( regs[inst.rs1()] + inst.imm_s(), regs[inst.rs2()] );
      pc = pc + 4;
      return FLTrace( inst_pc, 0, 0, 0 );

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      // jal
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    case JAL:
      regs[inst.rd()] = pc + 4;
      pc              = pc + inst.imm_j();
      return FLTrace( inst_pc, inst.rd(), inst_pc + 4, inst.rd() != 0 );

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      // jalr
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    case JALR:
      pc              = ( regs[inst.rs1()] + inst.imm_i() ) & 0xfffffffe;
      regs[inst.rd()] = inst_pc + 4;
      return FLTrace( inst_pc, inst.rd(), inst_pc + 4, inst.rd() != 0 );

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      // beq
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    case BEQ:
      if ( regs[inst.rs1()] == regs[inst.rs2()] ) {
        pc = pc + inst.imm_b();
      }
      else {
        pc = pc + 4;
      }
      return FLTrace( inst_pc, 0, 0, 0 );

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      // bne
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    case BNE:
      if ( regs[inst.rs1()] != regs[inst.rs2()] ) {
        pc = pc + inst.imm_b();
      }
      else {
        pc = pc + 4;
      }
      return FLTrace( inst_pc, 0, 0, 0 );

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      // blt
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    case BLT:
      if ( ( (int32_t) regs[inst.rs1()] ) <
           ( (int32_t) regs[inst.rs2()] ) ) {
        pc = pc + inst.imm_b();
      }
      else {
        pc = pc + 4;
      }
      return FLTrace( inst_pc, 0, 0, 0 );

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      // bge
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    case BGE:
      if ( ( (int32_t) regs[inst.rs1()] ) >=
           ( (int32_t) regs[inst.rs2()] ) ) {
        pc = pc + inst.imm_b();
      }
      else {
        pc = pc + 4;
      }
      return FLTrace( inst_pc, 0, 0, 0 );

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      // bltu
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    case BLTU:
      if ( regs[inst.rs1()] < regs[inst.rs2()] ) {
        pc = pc + inst.imm_b();
      }
      else {
        pc = pc + 4;
      }
      return FLTrace( inst_pc, 0, 0, 0 );

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      // bgeu
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    case BGEU:
      if ( regs[inst.rs1()] >= regs[inst.rs2()] ) {
        pc = pc + inst.imm_b();
      }
      else {
        pc = pc + 4;
      }
      return FLTrace( inst_pc, 0, 0, 0 );

    default:
      std::string excp =
          std::format( "Unknown instruction: '{}'", inst.mnemonic() );
      throw std::invalid_argument( excp );
  }
}