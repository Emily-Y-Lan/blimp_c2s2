// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtop.h for the primary calling header

#include "verilated.h"
#include "verilated_dpi.h"

#include "Vtop__Syms.h"
#include "Vtop__Syms.h"
#include "Vtop___024root.h"

// Parameter definitions for Vtop___024root
constexpr CData/*1:0*/ Vtop___024root::tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__STATE_IDLE;
constexpr CData/*1:0*/ Vtop___024root::tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__STATE_CALC;
constexpr CData/*1:0*/ Vtop___024root::tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__STATE_DONE;
constexpr CData/*1:0*/ Vtop___024root::tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__a_x;
constexpr CData/*1:0*/ Vtop___024root::tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__a_ld;
constexpr CData/*1:0*/ Vtop___024root::tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__a_b;
constexpr CData/*1:0*/ Vtop___024root::tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__a_sub;
constexpr CData/*0:0*/ Vtop___024root::tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__b_x;
constexpr CData/*0:0*/ Vtop___024root::tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__b_ld;
constexpr CData/*0:0*/ Vtop___024root::tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__b_a;
constexpr IData/*31:0*/ Vtop___024root::tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__c_nbits;
constexpr IData/*31:0*/ Vtop___024root::tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_mux__DOT__p_nbits;
constexpr IData/*31:0*/ Vtop___024root::tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_reg__DOT__p_nbits;
constexpr IData/*31:0*/ Vtop___024root::tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_mux__DOT__p_nbits;
constexpr IData/*31:0*/ Vtop___024root::tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_reg__DOT__p_nbits;
constexpr IData/*31:0*/ Vtop___024root::tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_lt_b__DOT__p_nbits;
constexpr IData/*31:0*/ Vtop___024root::tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_zero__DOT__p_nbits;
constexpr IData/*31:0*/ Vtop___024root::tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__sub__DOT__p_nbits;


void Vtop___024root___ctor_var_reset(Vtop___024root* vlSelf);

Vtop___024root::Vtop___024root(Vtop__Syms* symsp, const char* v__name)
    : VerilatedModule{v__name}
    , vlSymsp{symsp}
 {
    // Reset structure values
    Vtop___024root___ctor_var_reset(this);
}

void Vtop___024root::__Vconfigure(bool first) {
    if (false && first) {}  // Prevent unused
}

Vtop___024root::~Vtop___024root() {
}
