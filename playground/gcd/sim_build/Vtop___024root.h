// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vtop.h for the primary calling header

#ifndef VERILATED_VTOP___024ROOT_H_
#define VERILATED_VTOP___024ROOT_H_  // guard

#include "verilated.h"


class Vtop__Syms;

class alignas(VL_CACHE_LINE_BYTES) Vtop___024root final : public VerilatedModule {
  public:

    // DESIGN SPECIFIC STATE
    // Anonymous structures to workaround compiler member-count bugs
    struct {
        VL_IN8(clk,0,0);
        VL_IN8(reset,0,0);
        VL_IN8(istream_val,0,0);
        VL_OUT8(istream_rdy,0,0);
        VL_OUT8(ostream_val,0,0);
        VL_IN8(ostream_rdy,0,0);
        CData/*0:0*/ tut3_verilog_gcd_GcdUnit__DOT__clk;
        CData/*0:0*/ tut3_verilog_gcd_GcdUnit__DOT__reset;
        CData/*0:0*/ tut3_verilog_gcd_GcdUnit__DOT__istream_val;
        CData/*0:0*/ tut3_verilog_gcd_GcdUnit__DOT__istream_rdy;
        CData/*0:0*/ tut3_verilog_gcd_GcdUnit__DOT__ostream_val;
        CData/*0:0*/ tut3_verilog_gcd_GcdUnit__DOT__ostream_rdy;
        CData/*0:0*/ tut3_verilog_gcd_GcdUnit__DOT__a_reg_en;
        CData/*0:0*/ tut3_verilog_gcd_GcdUnit__DOT__b_reg_en;
        CData/*1:0*/ tut3_verilog_gcd_GcdUnit__DOT__a_mux_sel;
        CData/*0:0*/ tut3_verilog_gcd_GcdUnit__DOT__b_mux_sel;
        CData/*0:0*/ tut3_verilog_gcd_GcdUnit__DOT__is_b_zero;
        CData/*0:0*/ tut3_verilog_gcd_GcdUnit__DOT__is_a_lt_b;
        CData/*0:0*/ tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__clk;
        CData/*0:0*/ tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__reset;
        CData/*0:0*/ tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__istream_val;
        CData/*0:0*/ tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__istream_rdy;
        CData/*0:0*/ tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__ostream_val;
        CData/*0:0*/ tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__ostream_rdy;
        CData/*0:0*/ tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__a_reg_en;
        CData/*0:0*/ tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__b_reg_en;
        CData/*1:0*/ tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__a_mux_sel;
        CData/*0:0*/ tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__b_mux_sel;
        CData/*0:0*/ tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__is_b_zero;
        CData/*0:0*/ tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__is_a_lt_b;
        CData/*1:0*/ tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__state_reg;
        CData/*1:0*/ tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__state_next;
        CData/*0:0*/ tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__req_go;
        CData/*0:0*/ tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__resp_go;
        CData/*0:0*/ tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__is_calc_done;
        CData/*0:0*/ tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__do_swap;
        CData/*0:0*/ tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__do_sub;
        CData/*0:0*/ tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__clk;
        CData/*0:0*/ tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__reset;
        CData/*0:0*/ tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_reg_en;
        CData/*0:0*/ tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_reg_en;
        CData/*1:0*/ tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_mux_sel;
        CData/*0:0*/ tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_mux_sel;
        CData/*0:0*/ tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__is_b_zero;
        CData/*0:0*/ tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__is_a_lt_b;
        CData/*1:0*/ tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_mux__DOT__sel;
        CData/*0:0*/ tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_reg__DOT__clk;
        CData/*0:0*/ tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_reg__DOT__reset;
        CData/*0:0*/ tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_reg__DOT__en;
        CData/*0:0*/ tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_mux__DOT__sel;
        CData/*0:0*/ tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_reg__DOT__clk;
        CData/*0:0*/ tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_reg__DOT__reset;
        CData/*0:0*/ tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_reg__DOT__en;
        CData/*0:0*/ tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_lt_b__DOT__out;
        CData/*0:0*/ tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_zero__DOT__out;
        CData/*0:0*/ __Vtrigprevexpr___TOP__clk__0;
        CData/*0:0*/ __VactContinue;
        VL_OUT16(ostream_msg,15,0);
        SData/*15:0*/ tut3_verilog_gcd_GcdUnit__DOT__ostream_msg;
        SData/*15:0*/ tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__ostream_msg;
        SData/*15:0*/ tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__istream_msg_a;
        SData/*15:0*/ tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__istream_msg_b;
        SData/*15:0*/ tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_reg_out;
        SData/*15:0*/ tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__sub_out;
    };
    struct {
        SData/*15:0*/ tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_mux_out;
        SData/*15:0*/ tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_reg_out;
        SData/*15:0*/ tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_mux_out;
        SData/*15:0*/ tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_mux__DOT__in0;
        SData/*15:0*/ tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_mux__DOT__in1;
        SData/*15:0*/ tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_mux__DOT__in2;
        SData/*15:0*/ tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_mux__DOT__out;
        SData/*15:0*/ tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_reg__DOT__q;
        SData/*15:0*/ tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_reg__DOT__d;
        SData/*15:0*/ tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_mux__DOT__in0;
        SData/*15:0*/ tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_mux__DOT__in1;
        SData/*15:0*/ tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_mux__DOT__out;
        SData/*15:0*/ tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_reg__DOT__q;
        SData/*15:0*/ tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_reg__DOT__d;
        SData/*15:0*/ tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_lt_b__DOT__in0;
        SData/*15:0*/ tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_lt_b__DOT__in1;
        SData/*15:0*/ tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_zero__DOT__in;
        SData/*15:0*/ tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__sub__DOT__in0;
        SData/*15:0*/ tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__sub__DOT__in1;
        SData/*15:0*/ tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__sub__DOT__out;
        VL_IN(istream_msg,31,0);
        IData/*31:0*/ tut3_verilog_gcd_GcdUnit__DOT__istream_msg;
        IData/*31:0*/ tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__istream_msg;
        IData/*31:0*/ __VstlIterCount;
        IData/*31:0*/ __VicoIterCount;
        IData/*31:0*/ __VactIterCount;
    };
    VlTriggerVec<1> __VstlTriggered;
    VlTriggerVec<1> __VicoTriggered;
    VlTriggerVec<1> __VactTriggered;
    VlTriggerVec<1> __VnbaTriggered;

    // INTERNAL VARIABLES
    Vtop__Syms* const vlSymsp;

    // PARAMETERS
    static constexpr CData/*1:0*/ tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__STATE_IDLE = 0U;
    static constexpr CData/*1:0*/ tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__STATE_CALC = 1U;
    static constexpr CData/*1:0*/ tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__STATE_DONE = 2U;
    static constexpr CData/*1:0*/ tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__a_x = 0U;
    static constexpr CData/*1:0*/ tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__a_ld = 0U;
    static constexpr CData/*1:0*/ tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__a_b = 1U;
    static constexpr CData/*1:0*/ tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__a_sub = 2U;
    static constexpr CData/*0:0*/ tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__b_x = 0U;
    static constexpr CData/*0:0*/ tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__b_ld = 0U;
    static constexpr CData/*0:0*/ tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__b_a = 1U;
    static constexpr IData/*31:0*/ tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__c_nbits = 0x00000010U;
    static constexpr IData/*31:0*/ tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_mux__DOT__p_nbits = 0x00000010U;
    static constexpr IData/*31:0*/ tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_reg__DOT__p_nbits = 0x00000010U;
    static constexpr IData/*31:0*/ tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_mux__DOT__p_nbits = 0x00000010U;
    static constexpr IData/*31:0*/ tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_reg__DOT__p_nbits = 0x00000010U;
    static constexpr IData/*31:0*/ tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_lt_b__DOT__p_nbits = 0x00000010U;
    static constexpr IData/*31:0*/ tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_zero__DOT__p_nbits = 0x00000010U;
    static constexpr IData/*31:0*/ tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__sub__DOT__p_nbits = 0x00000010U;

    // CONSTRUCTORS
    Vtop___024root(Vtop__Syms* symsp, const char* v__name);
    ~Vtop___024root();
    VL_UNCOPYABLE(Vtop___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
};


#endif  // guard
