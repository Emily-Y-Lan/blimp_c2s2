// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Symbol table implementation internals

#include "Vtop__Syms.h"
#include "Vtop.h"
#include "Vtop___024root.h"

// FUNCTIONS
Vtop__Syms::~Vtop__Syms()
{

    // Tear down scope hierarchy
    __Vhier.remove(0, &__Vscope_tut3_verilog_gcd_GcdUnit);
    __Vhier.remove(&__Vscope_tut3_verilog_gcd_GcdUnit, &__Vscope_tut3_verilog_gcd_GcdUnit__ctrl);
    __Vhier.remove(&__Vscope_tut3_verilog_gcd_GcdUnit, &__Vscope_tut3_verilog_gcd_GcdUnit__dpath);
    __Vhier.remove(&__Vscope_tut3_verilog_gcd_GcdUnit__dpath, &__Vscope_tut3_verilog_gcd_GcdUnit__dpath__a_lt_b);
    __Vhier.remove(&__Vscope_tut3_verilog_gcd_GcdUnit__dpath, &__Vscope_tut3_verilog_gcd_GcdUnit__dpath__a_mux);
    __Vhier.remove(&__Vscope_tut3_verilog_gcd_GcdUnit__dpath, &__Vscope_tut3_verilog_gcd_GcdUnit__dpath__a_reg);
    __Vhier.remove(&__Vscope_tut3_verilog_gcd_GcdUnit__dpath, &__Vscope_tut3_verilog_gcd_GcdUnit__dpath__b_mux);
    __Vhier.remove(&__Vscope_tut3_verilog_gcd_GcdUnit__dpath, &__Vscope_tut3_verilog_gcd_GcdUnit__dpath__b_reg);
    __Vhier.remove(&__Vscope_tut3_verilog_gcd_GcdUnit__dpath, &__Vscope_tut3_verilog_gcd_GcdUnit__dpath__b_zero);
    __Vhier.remove(&__Vscope_tut3_verilog_gcd_GcdUnit__dpath, &__Vscope_tut3_verilog_gcd_GcdUnit__dpath__sub);

}

Vtop__Syms::Vtop__Syms(VerilatedContext* contextp, const char* namep, Vtop* modelp)
    : VerilatedSyms{contextp}
    // Setup internal state of the Syms class
    , __Vm_modelp{modelp}
    // Setup module instances
    , TOP{this, namep}
{
    // Configure time unit / time precision
    _vm_contextp__->timeunit(-12);
    _vm_contextp__->timeprecision(-12);
    // Setup each module's pointers to their submodules
    // Setup each module's pointer back to symbol table (for public functions)
    TOP.__Vconfigure(true);
    // Setup scopes
    __Vscope_TOP.configure(this, name(), "TOP", "TOP", 0, VerilatedScope::SCOPE_OTHER);
    __Vscope_tut3_verilog_gcd_GcdUnit.configure(this, name(), "tut3_verilog_gcd_GcdUnit", "tut3_verilog_gcd_GcdUnit", -12, VerilatedScope::SCOPE_MODULE);
    __Vscope_tut3_verilog_gcd_GcdUnit__ctrl.configure(this, name(), "tut3_verilog_gcd_GcdUnit.ctrl", "ctrl", -12, VerilatedScope::SCOPE_MODULE);
    __Vscope_tut3_verilog_gcd_GcdUnit__dpath.configure(this, name(), "tut3_verilog_gcd_GcdUnit.dpath", "dpath", -12, VerilatedScope::SCOPE_MODULE);
    __Vscope_tut3_verilog_gcd_GcdUnit__dpath__a_lt_b.configure(this, name(), "tut3_verilog_gcd_GcdUnit.dpath.a_lt_b", "a_lt_b", -12, VerilatedScope::SCOPE_MODULE);
    __Vscope_tut3_verilog_gcd_GcdUnit__dpath__a_mux.configure(this, name(), "tut3_verilog_gcd_GcdUnit.dpath.a_mux", "a_mux", -12, VerilatedScope::SCOPE_MODULE);
    __Vscope_tut3_verilog_gcd_GcdUnit__dpath__a_reg.configure(this, name(), "tut3_verilog_gcd_GcdUnit.dpath.a_reg", "a_reg", -12, VerilatedScope::SCOPE_MODULE);
    __Vscope_tut3_verilog_gcd_GcdUnit__dpath__b_mux.configure(this, name(), "tut3_verilog_gcd_GcdUnit.dpath.b_mux", "b_mux", -12, VerilatedScope::SCOPE_MODULE);
    __Vscope_tut3_verilog_gcd_GcdUnit__dpath__b_reg.configure(this, name(), "tut3_verilog_gcd_GcdUnit.dpath.b_reg", "b_reg", -12, VerilatedScope::SCOPE_MODULE);
    __Vscope_tut3_verilog_gcd_GcdUnit__dpath__b_zero.configure(this, name(), "tut3_verilog_gcd_GcdUnit.dpath.b_zero", "b_zero", -12, VerilatedScope::SCOPE_MODULE);
    __Vscope_tut3_verilog_gcd_GcdUnit__dpath__sub.configure(this, name(), "tut3_verilog_gcd_GcdUnit.dpath.sub", "sub", -12, VerilatedScope::SCOPE_MODULE);

    // Set up scope hierarchy
    __Vhier.add(0, &__Vscope_tut3_verilog_gcd_GcdUnit);
    __Vhier.add(&__Vscope_tut3_verilog_gcd_GcdUnit, &__Vscope_tut3_verilog_gcd_GcdUnit__ctrl);
    __Vhier.add(&__Vscope_tut3_verilog_gcd_GcdUnit, &__Vscope_tut3_verilog_gcd_GcdUnit__dpath);
    __Vhier.add(&__Vscope_tut3_verilog_gcd_GcdUnit__dpath, &__Vscope_tut3_verilog_gcd_GcdUnit__dpath__a_lt_b);
    __Vhier.add(&__Vscope_tut3_verilog_gcd_GcdUnit__dpath, &__Vscope_tut3_verilog_gcd_GcdUnit__dpath__a_mux);
    __Vhier.add(&__Vscope_tut3_verilog_gcd_GcdUnit__dpath, &__Vscope_tut3_verilog_gcd_GcdUnit__dpath__a_reg);
    __Vhier.add(&__Vscope_tut3_verilog_gcd_GcdUnit__dpath, &__Vscope_tut3_verilog_gcd_GcdUnit__dpath__b_mux);
    __Vhier.add(&__Vscope_tut3_verilog_gcd_GcdUnit__dpath, &__Vscope_tut3_verilog_gcd_GcdUnit__dpath__b_reg);
    __Vhier.add(&__Vscope_tut3_verilog_gcd_GcdUnit__dpath, &__Vscope_tut3_verilog_gcd_GcdUnit__dpath__b_zero);
    __Vhier.add(&__Vscope_tut3_verilog_gcd_GcdUnit__dpath, &__Vscope_tut3_verilog_gcd_GcdUnit__dpath__sub);

    // Setup export functions
    for (int __Vfinal = 0; __Vfinal < 2; ++__Vfinal) {
        __Vscope_TOP.varInsert(__Vfinal,"clk", &(TOP.clk), false, VLVT_UINT8,VLVD_IN|VLVF_PUB_RW,0);
        __Vscope_TOP.varInsert(__Vfinal,"istream_msg", &(TOP.istream_msg), false, VLVT_UINT32,VLVD_IN|VLVF_PUB_RW,1 ,31,0);
        __Vscope_TOP.varInsert(__Vfinal,"istream_rdy", &(TOP.istream_rdy), false, VLVT_UINT8,VLVD_OUT|VLVF_PUB_RW,0);
        __Vscope_TOP.varInsert(__Vfinal,"istream_val", &(TOP.istream_val), false, VLVT_UINT8,VLVD_IN|VLVF_PUB_RW,0);
        __Vscope_TOP.varInsert(__Vfinal,"ostream_msg", &(TOP.ostream_msg), false, VLVT_UINT16,VLVD_OUT|VLVF_PUB_RW,1 ,15,0);
        __Vscope_TOP.varInsert(__Vfinal,"ostream_rdy", &(TOP.ostream_rdy), false, VLVT_UINT8,VLVD_IN|VLVF_PUB_RW,0);
        __Vscope_TOP.varInsert(__Vfinal,"ostream_val", &(TOP.ostream_val), false, VLVT_UINT8,VLVD_OUT|VLVF_PUB_RW,0);
        __Vscope_TOP.varInsert(__Vfinal,"reset", &(TOP.reset), false, VLVT_UINT8,VLVD_IN|VLVF_PUB_RW,0);
        __Vscope_tut3_verilog_gcd_GcdUnit.varInsert(__Vfinal,"a_mux_sel", &(TOP.tut3_verilog_gcd_GcdUnit__DOT__a_mux_sel), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,1 ,1,0);
        __Vscope_tut3_verilog_gcd_GcdUnit.varInsert(__Vfinal,"a_reg_en", &(TOP.tut3_verilog_gcd_GcdUnit__DOT__a_reg_en), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
        __Vscope_tut3_verilog_gcd_GcdUnit.varInsert(__Vfinal,"b_mux_sel", &(TOP.tut3_verilog_gcd_GcdUnit__DOT__b_mux_sel), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
        __Vscope_tut3_verilog_gcd_GcdUnit.varInsert(__Vfinal,"b_reg_en", &(TOP.tut3_verilog_gcd_GcdUnit__DOT__b_reg_en), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
        __Vscope_tut3_verilog_gcd_GcdUnit.varInsert(__Vfinal,"clk", &(TOP.tut3_verilog_gcd_GcdUnit__DOT__clk), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
        __Vscope_tut3_verilog_gcd_GcdUnit.varInsert(__Vfinal,"is_a_lt_b", &(TOP.tut3_verilog_gcd_GcdUnit__DOT__is_a_lt_b), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
        __Vscope_tut3_verilog_gcd_GcdUnit.varInsert(__Vfinal,"is_b_zero", &(TOP.tut3_verilog_gcd_GcdUnit__DOT__is_b_zero), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
        __Vscope_tut3_verilog_gcd_GcdUnit.varInsert(__Vfinal,"istream_msg", &(TOP.tut3_verilog_gcd_GcdUnit__DOT__istream_msg), false, VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,1 ,31,0);
        __Vscope_tut3_verilog_gcd_GcdUnit.varInsert(__Vfinal,"istream_rdy", &(TOP.tut3_verilog_gcd_GcdUnit__DOT__istream_rdy), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
        __Vscope_tut3_verilog_gcd_GcdUnit.varInsert(__Vfinal,"istream_val", &(TOP.tut3_verilog_gcd_GcdUnit__DOT__istream_val), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
        __Vscope_tut3_verilog_gcd_GcdUnit.varInsert(__Vfinal,"ostream_msg", &(TOP.tut3_verilog_gcd_GcdUnit__DOT__ostream_msg), false, VLVT_UINT16,VLVD_NODIR|VLVF_PUB_RW,1 ,15,0);
        __Vscope_tut3_verilog_gcd_GcdUnit.varInsert(__Vfinal,"ostream_rdy", &(TOP.tut3_verilog_gcd_GcdUnit__DOT__ostream_rdy), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
        __Vscope_tut3_verilog_gcd_GcdUnit.varInsert(__Vfinal,"ostream_val", &(TOP.tut3_verilog_gcd_GcdUnit__DOT__ostream_val), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
        __Vscope_tut3_verilog_gcd_GcdUnit.varInsert(__Vfinal,"reset", &(TOP.tut3_verilog_gcd_GcdUnit__DOT__reset), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
        __Vscope_tut3_verilog_gcd_GcdUnit__ctrl.varInsert(__Vfinal,"STATE_CALC", const_cast<void*>(static_cast<const void*>(&(TOP.tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__STATE_CALC))), true, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,1 ,1,0);
        __Vscope_tut3_verilog_gcd_GcdUnit__ctrl.varInsert(__Vfinal,"STATE_DONE", const_cast<void*>(static_cast<const void*>(&(TOP.tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__STATE_DONE))), true, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,1 ,1,0);
        __Vscope_tut3_verilog_gcd_GcdUnit__ctrl.varInsert(__Vfinal,"STATE_IDLE", const_cast<void*>(static_cast<const void*>(&(TOP.tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__STATE_IDLE))), true, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,1 ,1,0);
        __Vscope_tut3_verilog_gcd_GcdUnit__ctrl.varInsert(__Vfinal,"a_b", const_cast<void*>(static_cast<const void*>(&(TOP.tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__a_b))), true, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,1 ,1,0);
        __Vscope_tut3_verilog_gcd_GcdUnit__ctrl.varInsert(__Vfinal,"a_ld", const_cast<void*>(static_cast<const void*>(&(TOP.tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__a_ld))), true, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,1 ,1,0);
        __Vscope_tut3_verilog_gcd_GcdUnit__ctrl.varInsert(__Vfinal,"a_mux_sel", &(TOP.tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__a_mux_sel), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,1 ,1,0);
        __Vscope_tut3_verilog_gcd_GcdUnit__ctrl.varInsert(__Vfinal,"a_reg_en", &(TOP.tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__a_reg_en), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
        __Vscope_tut3_verilog_gcd_GcdUnit__ctrl.varInsert(__Vfinal,"a_sub", const_cast<void*>(static_cast<const void*>(&(TOP.tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__a_sub))), true, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,1 ,1,0);
        __Vscope_tut3_verilog_gcd_GcdUnit__ctrl.varInsert(__Vfinal,"a_x", const_cast<void*>(static_cast<const void*>(&(TOP.tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__a_x))), true, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,1 ,1,0);
        __Vscope_tut3_verilog_gcd_GcdUnit__ctrl.varInsert(__Vfinal,"b_a", const_cast<void*>(static_cast<const void*>(&(TOP.tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__b_a))), true, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,1 ,0,0);
        __Vscope_tut3_verilog_gcd_GcdUnit__ctrl.varInsert(__Vfinal,"b_ld", const_cast<void*>(static_cast<const void*>(&(TOP.tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__b_ld))), true, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,1 ,0,0);
        __Vscope_tut3_verilog_gcd_GcdUnit__ctrl.varInsert(__Vfinal,"b_mux_sel", &(TOP.tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__b_mux_sel), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
        __Vscope_tut3_verilog_gcd_GcdUnit__ctrl.varInsert(__Vfinal,"b_reg_en", &(TOP.tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__b_reg_en), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
        __Vscope_tut3_verilog_gcd_GcdUnit__ctrl.varInsert(__Vfinal,"b_x", const_cast<void*>(static_cast<const void*>(&(TOP.tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__b_x))), true, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,1 ,0,0);
        __Vscope_tut3_verilog_gcd_GcdUnit__ctrl.varInsert(__Vfinal,"clk", &(TOP.tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__clk), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
        __Vscope_tut3_verilog_gcd_GcdUnit__ctrl.varInsert(__Vfinal,"do_sub", &(TOP.tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__do_sub), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
        __Vscope_tut3_verilog_gcd_GcdUnit__ctrl.varInsert(__Vfinal,"do_swap", &(TOP.tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__do_swap), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
        __Vscope_tut3_verilog_gcd_GcdUnit__ctrl.varInsert(__Vfinal,"is_a_lt_b", &(TOP.tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__is_a_lt_b), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
        __Vscope_tut3_verilog_gcd_GcdUnit__ctrl.varInsert(__Vfinal,"is_b_zero", &(TOP.tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__is_b_zero), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
        __Vscope_tut3_verilog_gcd_GcdUnit__ctrl.varInsert(__Vfinal,"is_calc_done", &(TOP.tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__is_calc_done), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
        __Vscope_tut3_verilog_gcd_GcdUnit__ctrl.varInsert(__Vfinal,"istream_rdy", &(TOP.tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__istream_rdy), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
        __Vscope_tut3_verilog_gcd_GcdUnit__ctrl.varInsert(__Vfinal,"istream_val", &(TOP.tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__istream_val), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
        __Vscope_tut3_verilog_gcd_GcdUnit__ctrl.varInsert(__Vfinal,"ostream_rdy", &(TOP.tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__ostream_rdy), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
        __Vscope_tut3_verilog_gcd_GcdUnit__ctrl.varInsert(__Vfinal,"ostream_val", &(TOP.tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__ostream_val), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
        __Vscope_tut3_verilog_gcd_GcdUnit__ctrl.varInsert(__Vfinal,"req_go", &(TOP.tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__req_go), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
        __Vscope_tut3_verilog_gcd_GcdUnit__ctrl.varInsert(__Vfinal,"reset", &(TOP.tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__reset), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
        __Vscope_tut3_verilog_gcd_GcdUnit__ctrl.varInsert(__Vfinal,"resp_go", &(TOP.tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__resp_go), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
        __Vscope_tut3_verilog_gcd_GcdUnit__ctrl.varInsert(__Vfinal,"state_next", &(TOP.tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__state_next), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,1 ,1,0);
        __Vscope_tut3_verilog_gcd_GcdUnit__ctrl.varInsert(__Vfinal,"state_reg", &(TOP.tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__state_reg), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,1 ,1,0);
        __Vscope_tut3_verilog_gcd_GcdUnit__dpath.varInsert(__Vfinal,"a_mux_out", &(TOP.tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_mux_out), false, VLVT_UINT16,VLVD_NODIR|VLVF_PUB_RW,1 ,15,0);
        __Vscope_tut3_verilog_gcd_GcdUnit__dpath.varInsert(__Vfinal,"a_mux_sel", &(TOP.tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_mux_sel), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,1 ,1,0);
        __Vscope_tut3_verilog_gcd_GcdUnit__dpath.varInsert(__Vfinal,"a_reg_en", &(TOP.tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_reg_en), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
        __Vscope_tut3_verilog_gcd_GcdUnit__dpath.varInsert(__Vfinal,"a_reg_out", &(TOP.tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_reg_out), false, VLVT_UINT16,VLVD_NODIR|VLVF_PUB_RW,1 ,15,0);
        __Vscope_tut3_verilog_gcd_GcdUnit__dpath.varInsert(__Vfinal,"b_mux_out", &(TOP.tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_mux_out), false, VLVT_UINT16,VLVD_NODIR|VLVF_PUB_RW,1 ,15,0);
        __Vscope_tut3_verilog_gcd_GcdUnit__dpath.varInsert(__Vfinal,"b_mux_sel", &(TOP.tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_mux_sel), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
        __Vscope_tut3_verilog_gcd_GcdUnit__dpath.varInsert(__Vfinal,"b_reg_en", &(TOP.tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_reg_en), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
        __Vscope_tut3_verilog_gcd_GcdUnit__dpath.varInsert(__Vfinal,"b_reg_out", &(TOP.tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_reg_out), false, VLVT_UINT16,VLVD_NODIR|VLVF_PUB_RW,1 ,15,0);
        __Vscope_tut3_verilog_gcd_GcdUnit__dpath.varInsert(__Vfinal,"c_nbits", const_cast<void*>(static_cast<const void*>(&(TOP.tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__c_nbits))), true, VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,1 ,31,0);
        __Vscope_tut3_verilog_gcd_GcdUnit__dpath.varInsert(__Vfinal,"clk", &(TOP.tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__clk), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
        __Vscope_tut3_verilog_gcd_GcdUnit__dpath.varInsert(__Vfinal,"is_a_lt_b", &(TOP.tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__is_a_lt_b), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
        __Vscope_tut3_verilog_gcd_GcdUnit__dpath.varInsert(__Vfinal,"is_b_zero", &(TOP.tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__is_b_zero), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
        __Vscope_tut3_verilog_gcd_GcdUnit__dpath.varInsert(__Vfinal,"istream_msg", &(TOP.tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__istream_msg), false, VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,1 ,31,0);
        __Vscope_tut3_verilog_gcd_GcdUnit__dpath.varInsert(__Vfinal,"istream_msg_a", &(TOP.tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__istream_msg_a), false, VLVT_UINT16,VLVD_NODIR|VLVF_PUB_RW,1 ,15,0);
        __Vscope_tut3_verilog_gcd_GcdUnit__dpath.varInsert(__Vfinal,"istream_msg_b", &(TOP.tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__istream_msg_b), false, VLVT_UINT16,VLVD_NODIR|VLVF_PUB_RW,1 ,15,0);
        __Vscope_tut3_verilog_gcd_GcdUnit__dpath.varInsert(__Vfinal,"ostream_msg", &(TOP.tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__ostream_msg), false, VLVT_UINT16,VLVD_NODIR|VLVF_PUB_RW,1 ,15,0);
        __Vscope_tut3_verilog_gcd_GcdUnit__dpath.varInsert(__Vfinal,"reset", &(TOP.tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__reset), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
        __Vscope_tut3_verilog_gcd_GcdUnit__dpath.varInsert(__Vfinal,"sub_out", &(TOP.tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__sub_out), false, VLVT_UINT16,VLVD_NODIR|VLVF_PUB_RW,1 ,15,0);
        __Vscope_tut3_verilog_gcd_GcdUnit__dpath__a_lt_b.varInsert(__Vfinal,"in0", &(TOP.tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_lt_b__DOT__in0), false, VLVT_UINT16,VLVD_NODIR|VLVF_PUB_RW,1 ,15,0);
        __Vscope_tut3_verilog_gcd_GcdUnit__dpath__a_lt_b.varInsert(__Vfinal,"in1", &(TOP.tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_lt_b__DOT__in1), false, VLVT_UINT16,VLVD_NODIR|VLVF_PUB_RW,1 ,15,0);
        __Vscope_tut3_verilog_gcd_GcdUnit__dpath__a_lt_b.varInsert(__Vfinal,"out", &(TOP.tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_lt_b__DOT__out), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
        __Vscope_tut3_verilog_gcd_GcdUnit__dpath__a_lt_b.varInsert(__Vfinal,"p_nbits", const_cast<void*>(static_cast<const void*>(&(TOP.tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_lt_b__DOT__p_nbits))), true, VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,1 ,31,0);
        __Vscope_tut3_verilog_gcd_GcdUnit__dpath__a_mux.varInsert(__Vfinal,"in0", &(TOP.tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_mux__DOT__in0), false, VLVT_UINT16,VLVD_NODIR|VLVF_PUB_RW,1 ,15,0);
        __Vscope_tut3_verilog_gcd_GcdUnit__dpath__a_mux.varInsert(__Vfinal,"in1", &(TOP.tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_mux__DOT__in1), false, VLVT_UINT16,VLVD_NODIR|VLVF_PUB_RW,1 ,15,0);
        __Vscope_tut3_verilog_gcd_GcdUnit__dpath__a_mux.varInsert(__Vfinal,"in2", &(TOP.tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_mux__DOT__in2), false, VLVT_UINT16,VLVD_NODIR|VLVF_PUB_RW,1 ,15,0);
        __Vscope_tut3_verilog_gcd_GcdUnit__dpath__a_mux.varInsert(__Vfinal,"out", &(TOP.tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_mux__DOT__out), false, VLVT_UINT16,VLVD_NODIR|VLVF_PUB_RW,1 ,15,0);
        __Vscope_tut3_verilog_gcd_GcdUnit__dpath__a_mux.varInsert(__Vfinal,"p_nbits", const_cast<void*>(static_cast<const void*>(&(TOP.tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_mux__DOT__p_nbits))), true, VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,1 ,31,0);
        __Vscope_tut3_verilog_gcd_GcdUnit__dpath__a_mux.varInsert(__Vfinal,"sel", &(TOP.tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_mux__DOT__sel), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,1 ,1,0);
        __Vscope_tut3_verilog_gcd_GcdUnit__dpath__a_reg.varInsert(__Vfinal,"clk", &(TOP.tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_reg__DOT__clk), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
        __Vscope_tut3_verilog_gcd_GcdUnit__dpath__a_reg.varInsert(__Vfinal,"d", &(TOP.tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_reg__DOT__d), false, VLVT_UINT16,VLVD_NODIR|VLVF_PUB_RW,1 ,15,0);
        __Vscope_tut3_verilog_gcd_GcdUnit__dpath__a_reg.varInsert(__Vfinal,"en", &(TOP.tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_reg__DOT__en), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
        __Vscope_tut3_verilog_gcd_GcdUnit__dpath__a_reg.varInsert(__Vfinal,"p_nbits", const_cast<void*>(static_cast<const void*>(&(TOP.tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_reg__DOT__p_nbits))), true, VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,1 ,31,0);
        __Vscope_tut3_verilog_gcd_GcdUnit__dpath__a_reg.varInsert(__Vfinal,"q", &(TOP.tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_reg__DOT__q), false, VLVT_UINT16,VLVD_NODIR|VLVF_PUB_RW,1 ,15,0);
        __Vscope_tut3_verilog_gcd_GcdUnit__dpath__a_reg.varInsert(__Vfinal,"reset", &(TOP.tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_reg__DOT__reset), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
        __Vscope_tut3_verilog_gcd_GcdUnit__dpath__b_mux.varInsert(__Vfinal,"in0", &(TOP.tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_mux__DOT__in0), false, VLVT_UINT16,VLVD_NODIR|VLVF_PUB_RW,1 ,15,0);
        __Vscope_tut3_verilog_gcd_GcdUnit__dpath__b_mux.varInsert(__Vfinal,"in1", &(TOP.tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_mux__DOT__in1), false, VLVT_UINT16,VLVD_NODIR|VLVF_PUB_RW,1 ,15,0);
        __Vscope_tut3_verilog_gcd_GcdUnit__dpath__b_mux.varInsert(__Vfinal,"out", &(TOP.tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_mux__DOT__out), false, VLVT_UINT16,VLVD_NODIR|VLVF_PUB_RW,1 ,15,0);
        __Vscope_tut3_verilog_gcd_GcdUnit__dpath__b_mux.varInsert(__Vfinal,"p_nbits", const_cast<void*>(static_cast<const void*>(&(TOP.tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_mux__DOT__p_nbits))), true, VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,1 ,31,0);
        __Vscope_tut3_verilog_gcd_GcdUnit__dpath__b_mux.varInsert(__Vfinal,"sel", &(TOP.tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_mux__DOT__sel), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
        __Vscope_tut3_verilog_gcd_GcdUnit__dpath__b_reg.varInsert(__Vfinal,"clk", &(TOP.tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_reg__DOT__clk), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
        __Vscope_tut3_verilog_gcd_GcdUnit__dpath__b_reg.varInsert(__Vfinal,"d", &(TOP.tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_reg__DOT__d), false, VLVT_UINT16,VLVD_NODIR|VLVF_PUB_RW,1 ,15,0);
        __Vscope_tut3_verilog_gcd_GcdUnit__dpath__b_reg.varInsert(__Vfinal,"en", &(TOP.tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_reg__DOT__en), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
        __Vscope_tut3_verilog_gcd_GcdUnit__dpath__b_reg.varInsert(__Vfinal,"p_nbits", const_cast<void*>(static_cast<const void*>(&(TOP.tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_reg__DOT__p_nbits))), true, VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,1 ,31,0);
        __Vscope_tut3_verilog_gcd_GcdUnit__dpath__b_reg.varInsert(__Vfinal,"q", &(TOP.tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_reg__DOT__q), false, VLVT_UINT16,VLVD_NODIR|VLVF_PUB_RW,1 ,15,0);
        __Vscope_tut3_verilog_gcd_GcdUnit__dpath__b_reg.varInsert(__Vfinal,"reset", &(TOP.tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_reg__DOT__reset), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
        __Vscope_tut3_verilog_gcd_GcdUnit__dpath__b_zero.varInsert(__Vfinal,"in", &(TOP.tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_zero__DOT__in), false, VLVT_UINT16,VLVD_NODIR|VLVF_PUB_RW,1 ,15,0);
        __Vscope_tut3_verilog_gcd_GcdUnit__dpath__b_zero.varInsert(__Vfinal,"out", &(TOP.tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_zero__DOT__out), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
        __Vscope_tut3_verilog_gcd_GcdUnit__dpath__b_zero.varInsert(__Vfinal,"p_nbits", const_cast<void*>(static_cast<const void*>(&(TOP.tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_zero__DOT__p_nbits))), true, VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,1 ,31,0);
        __Vscope_tut3_verilog_gcd_GcdUnit__dpath__sub.varInsert(__Vfinal,"in0", &(TOP.tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__sub__DOT__in0), false, VLVT_UINT16,VLVD_NODIR|VLVF_PUB_RW,1 ,15,0);
        __Vscope_tut3_verilog_gcd_GcdUnit__dpath__sub.varInsert(__Vfinal,"in1", &(TOP.tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__sub__DOT__in1), false, VLVT_UINT16,VLVD_NODIR|VLVF_PUB_RW,1 ,15,0);
        __Vscope_tut3_verilog_gcd_GcdUnit__dpath__sub.varInsert(__Vfinal,"out", &(TOP.tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__sub__DOT__out), false, VLVT_UINT16,VLVD_NODIR|VLVF_PUB_RW,1 ,15,0);
        __Vscope_tut3_verilog_gcd_GcdUnit__dpath__sub.varInsert(__Vfinal,"p_nbits", const_cast<void*>(static_cast<const void*>(&(TOP.tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__sub__DOT__p_nbits))), true, VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,1 ,31,0);
    }
}
