// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtop.h for the primary calling header

#include "verilated.h"
#include "verilated_dpi.h"

#include "Vtop__Syms.h"
#include "Vtop___024root.h"

VL_ATTR_COLD void Vtop___024root___eval_static(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_static\n"); );
}

VL_ATTR_COLD void Vtop___024root___eval_initial(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_initial\n"); );
    // Body
    vlSelf->__Vtrigprevexpr___TOP__clk__0 = vlSelf->clk;
}

VL_ATTR_COLD void Vtop___024root___eval_final(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_final\n"); );
}

VL_ATTR_COLD void Vtop___024root___eval_triggers__stl(Vtop___024root* vlSelf);
#ifdef VL_DEBUG
VL_ATTR_COLD void Vtop___024root___dump_triggers__stl(Vtop___024root* vlSelf);
#endif  // VL_DEBUG
VL_ATTR_COLD void Vtop___024root___eval_stl(Vtop___024root* vlSelf);

VL_ATTR_COLD void Vtop___024root___eval_settle(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_settle\n"); );
    // Init
    CData/*0:0*/ __VstlContinue;
    // Body
    vlSelf->__VstlIterCount = 0U;
    __VstlContinue = 1U;
    while (__VstlContinue) {
        __VstlContinue = 0U;
        Vtop___024root___eval_triggers__stl(vlSelf);
        if (vlSelf->__VstlTriggered.any()) {
            __VstlContinue = 1U;
            if (VL_UNLIKELY((0x64U < vlSelf->__VstlIterCount))) {
#ifdef VL_DEBUG
                Vtop___024root___dump_triggers__stl(vlSelf);
#endif
                VL_FATAL_MT("/home/acm289/blimp/playground/gcd/GcdUnit.v", 277, "", "Settle region did not converge.");
            }
            vlSelf->__VstlIterCount = ((IData)(1U) 
                                       + vlSelf->__VstlIterCount);
            Vtop___024root___eval_stl(vlSelf);
        }
    }
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtop___024root___dump_triggers__stl(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___dump_triggers__stl\n"); );
    // Body
    if ((1U & (~ (IData)(vlSelf->__VstlTriggered.any())))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelf->__VstlTriggered.word(0U))) {
        VL_DBG_MSGF("         'stl' region trigger index 0 is active: Internal 'stl' trigger - first iteration\n");
    }
}
#endif  // VL_DEBUG

void Vtop___024root___ico_sequent__TOP__0(Vtop___024root* vlSelf);

VL_ATTR_COLD void Vtop___024root___eval_stl(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_stl\n"); );
    // Body
    if ((1ULL & vlSelf->__VstlTriggered.word(0U))) {
        Vtop___024root___ico_sequent__TOP__0(vlSelf);
    }
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtop___024root___dump_triggers__ico(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___dump_triggers__ico\n"); );
    // Body
    if ((1U & (~ (IData)(vlSelf->__VicoTriggered.any())))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelf->__VicoTriggered.word(0U))) {
        VL_DBG_MSGF("         'ico' region trigger index 0 is active: Internal 'ico' trigger - first iteration\n");
    }
}
#endif  // VL_DEBUG

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtop___024root___dump_triggers__act(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___dump_triggers__act\n"); );
    // Body
    if ((1U & (~ (IData)(vlSelf->__VactTriggered.any())))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelf->__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 0 is active: @(posedge clk)\n");
    }
}
#endif  // VL_DEBUG

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtop___024root___dump_triggers__nba(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___dump_triggers__nba\n"); );
    // Body
    if ((1U & (~ (IData)(vlSelf->__VnbaTriggered.any())))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelf->__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 0 is active: @(posedge clk)\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void Vtop___024root___ctor_var_reset(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___ctor_var_reset\n"); );
    // Body
    vlSelf->clk = VL_RAND_RESET_I(1);
    vlSelf->reset = VL_RAND_RESET_I(1);
    vlSelf->istream_val = VL_RAND_RESET_I(1);
    vlSelf->istream_rdy = VL_RAND_RESET_I(1);
    vlSelf->istream_msg = VL_RAND_RESET_I(32);
    vlSelf->ostream_val = VL_RAND_RESET_I(1);
    vlSelf->ostream_rdy = VL_RAND_RESET_I(1);
    vlSelf->ostream_msg = VL_RAND_RESET_I(16);
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__clk = VL_RAND_RESET_I(1);
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__reset = VL_RAND_RESET_I(1);
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__istream_val = VL_RAND_RESET_I(1);
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__istream_rdy = VL_RAND_RESET_I(1);
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__istream_msg = VL_RAND_RESET_I(32);
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ostream_val = VL_RAND_RESET_I(1);
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ostream_rdy = VL_RAND_RESET_I(1);
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ostream_msg = VL_RAND_RESET_I(16);
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__a_reg_en = VL_RAND_RESET_I(1);
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__b_reg_en = VL_RAND_RESET_I(1);
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__a_mux_sel = VL_RAND_RESET_I(2);
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__b_mux_sel = VL_RAND_RESET_I(1);
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__is_b_zero = VL_RAND_RESET_I(1);
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__is_a_lt_b = VL_RAND_RESET_I(1);
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__clk = VL_RAND_RESET_I(1);
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__reset = VL_RAND_RESET_I(1);
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__istream_val = VL_RAND_RESET_I(1);
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__istream_rdy = VL_RAND_RESET_I(1);
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__ostream_val = VL_RAND_RESET_I(1);
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__ostream_rdy = VL_RAND_RESET_I(1);
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__a_reg_en = VL_RAND_RESET_I(1);
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__b_reg_en = VL_RAND_RESET_I(1);
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__a_mux_sel = VL_RAND_RESET_I(2);
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__b_mux_sel = VL_RAND_RESET_I(1);
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__is_b_zero = VL_RAND_RESET_I(1);
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__is_a_lt_b = VL_RAND_RESET_I(1);
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__state_reg = VL_RAND_RESET_I(2);
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__state_next = VL_RAND_RESET_I(2);
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__req_go = VL_RAND_RESET_I(1);
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__resp_go = VL_RAND_RESET_I(1);
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__is_calc_done = VL_RAND_RESET_I(1);
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__do_swap = VL_RAND_RESET_I(1);
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__do_sub = VL_RAND_RESET_I(1);
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__clk = VL_RAND_RESET_I(1);
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__reset = VL_RAND_RESET_I(1);
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__istream_msg = VL_RAND_RESET_I(32);
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__ostream_msg = VL_RAND_RESET_I(16);
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_reg_en = VL_RAND_RESET_I(1);
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_reg_en = VL_RAND_RESET_I(1);
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_mux_sel = VL_RAND_RESET_I(2);
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_mux_sel = VL_RAND_RESET_I(1);
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__is_b_zero = VL_RAND_RESET_I(1);
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__is_a_lt_b = VL_RAND_RESET_I(1);
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__istream_msg_a = VL_RAND_RESET_I(16);
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__istream_msg_b = VL_RAND_RESET_I(16);
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_reg_out = VL_RAND_RESET_I(16);
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__sub_out = VL_RAND_RESET_I(16);
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_mux_out = VL_RAND_RESET_I(16);
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_reg_out = VL_RAND_RESET_I(16);
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_mux_out = VL_RAND_RESET_I(16);
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_mux__DOT__in0 = VL_RAND_RESET_I(16);
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_mux__DOT__in1 = VL_RAND_RESET_I(16);
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_mux__DOT__in2 = VL_RAND_RESET_I(16);
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_mux__DOT__sel = VL_RAND_RESET_I(2);
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_mux__DOT__out = VL_RAND_RESET_I(16);
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_reg__DOT__clk = VL_RAND_RESET_I(1);
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_reg__DOT__reset = VL_RAND_RESET_I(1);
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_reg__DOT__q = VL_RAND_RESET_I(16);
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_reg__DOT__d = VL_RAND_RESET_I(16);
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_reg__DOT__en = VL_RAND_RESET_I(1);
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_mux__DOT__in0 = VL_RAND_RESET_I(16);
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_mux__DOT__in1 = VL_RAND_RESET_I(16);
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_mux__DOT__sel = VL_RAND_RESET_I(1);
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_mux__DOT__out = VL_RAND_RESET_I(16);
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_reg__DOT__clk = VL_RAND_RESET_I(1);
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_reg__DOT__reset = VL_RAND_RESET_I(1);
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_reg__DOT__q = VL_RAND_RESET_I(16);
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_reg__DOT__d = VL_RAND_RESET_I(16);
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_reg__DOT__en = VL_RAND_RESET_I(1);
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_lt_b__DOT__in0 = VL_RAND_RESET_I(16);
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_lt_b__DOT__in1 = VL_RAND_RESET_I(16);
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_lt_b__DOT__out = VL_RAND_RESET_I(1);
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_zero__DOT__in = VL_RAND_RESET_I(16);
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_zero__DOT__out = VL_RAND_RESET_I(1);
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__sub__DOT__in0 = VL_RAND_RESET_I(16);
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__sub__DOT__in1 = VL_RAND_RESET_I(16);
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__sub__DOT__out = VL_RAND_RESET_I(16);
    vlSelf->__Vtrigprevexpr___TOP__clk__0 = VL_RAND_RESET_I(1);
}
