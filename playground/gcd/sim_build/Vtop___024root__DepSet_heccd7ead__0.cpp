// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtop.h for the primary calling header

#include "verilated.h"
#include "verilated_dpi.h"

#include "Vtop__Syms.h"
#include "Vtop___024root.h"

extern const VlUnpacked<CData/*0:0*/, 16> Vtop__ConstPool__TABLE_h09fed229_0;
extern const VlUnpacked<CData/*0:0*/, 16> Vtop__ConstPool__TABLE_hdd48603f_0;
extern const VlUnpacked<CData/*0:0*/, 16> Vtop__ConstPool__TABLE_h9aef1b65_0;
extern const VlUnpacked<CData/*0:0*/, 16> Vtop__ConstPool__TABLE_h00ea721b_0;
extern const VlUnpacked<CData/*1:0*/, 16> Vtop__ConstPool__TABLE_hfcc82a61_0;
extern const VlUnpacked<CData/*0:0*/, 16> Vtop__ConstPool__TABLE_hfc195d6e_0;
extern const VlUnpacked<CData/*1:0*/, 32> Vtop__ConstPool__TABLE_h6b4dffe9_0;

VL_INLINE_OPT void Vtop___024root___ico_sequent__TOP__0(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___ico_sequent__TOP__0\n"); );
    // Init
    CData/*4:0*/ __Vtableidx1;
    __Vtableidx1 = 0;
    CData/*3:0*/ __Vtableidx2;
    __Vtableidx2 = 0;
    // Body
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__istream_val 
        = vlSelf->istream_val;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__istream_msg 
        = vlSelf->istream_msg;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ostream_rdy 
        = vlSelf->ostream_rdy;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__clk = vlSelf->clk;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__reset = vlSelf->reset;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__istream_msg_b 
        = (0xffffU & vlSelf->istream_msg);
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__istream_msg_a 
        = (vlSelf->istream_msg >> 0x10U);
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_reg_out 
        = vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_reg__DOT__q;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_reg_out 
        = vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_reg__DOT__q;
    vlSelf->ostream_msg = (0xffffU & ((IData)(vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_reg__DOT__q) 
                                      - (IData)(vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_reg__DOT__q)));
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__is_b_zero 
        = (0U == (IData)(vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_reg__DOT__q));
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__is_a_lt_b 
        = ((IData)(vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_reg__DOT__q) 
           < (IData)(vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_reg__DOT__q));
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__istream_val 
        = vlSelf->tut3_verilog_gcd_GcdUnit__DOT__istream_val;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__istream_msg 
        = vlSelf->tut3_verilog_gcd_GcdUnit__DOT__istream_msg;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__ostream_rdy 
        = vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ostream_rdy;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__clk 
        = vlSelf->tut3_verilog_gcd_GcdUnit__DOT__clk;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__clk 
        = vlSelf->tut3_verilog_gcd_GcdUnit__DOT__clk;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__reset 
        = vlSelf->tut3_verilog_gcd_GcdUnit__DOT__reset;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__reset 
        = vlSelf->tut3_verilog_gcd_GcdUnit__DOT__reset;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_mux__DOT__in0 
        = vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__istream_msg_b;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_mux__DOT__in0 
        = vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__istream_msg_a;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_mux__DOT__in1 
        = vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_reg_out;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_lt_b__DOT__in0 
        = vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_reg_out;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__sub__DOT__in0 
        = vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_reg_out;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_mux__DOT__in1 
        = vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_reg_out;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_lt_b__DOT__in1 
        = vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_reg_out;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_zero__DOT__in 
        = vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_reg_out;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__sub__DOT__in1 
        = vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_reg_out;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_mux__DOT__in2 
        = vlSelf->ostream_msg;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ostream_msg 
        = vlSelf->ostream_msg;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__ostream_msg 
        = vlSelf->ostream_msg;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__sub_out 
        = vlSelf->ostream_msg;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__sub__DOT__out 
        = vlSelf->ostream_msg;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__is_b_zero 
        = vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__is_b_zero;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__is_b_zero 
        = vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__is_b_zero;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_zero__DOT__out 
        = vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__is_b_zero;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__do_sub 
        = (1U & (~ (IData)(vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__is_b_zero)));
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__is_a_lt_b 
        = vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__is_a_lt_b;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__is_a_lt_b 
        = vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__is_a_lt_b;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__do_swap 
        = vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__is_a_lt_b;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_lt_b__DOT__out 
        = vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__is_a_lt_b;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__is_calc_done 
        = ((~ (IData)(vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__is_a_lt_b)) 
           & (IData)(vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__is_b_zero));
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_reg__DOT__clk 
        = vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__clk;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_reg__DOT__clk 
        = vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__clk;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_reg__DOT__reset 
        = vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__reset;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_reg__DOT__reset 
        = vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__reset;
    __Vtableidx2 = (((IData)(vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__do_sub) 
                     << 3U) | (((IData)(vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__is_a_lt_b) 
                                << 2U) | (IData)(vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__state_reg)));
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__istream_rdy 
        = Vtop__ConstPool__TABLE_h09fed229_0[__Vtableidx2];
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__ostream_val 
        = Vtop__ConstPool__TABLE_hdd48603f_0[__Vtableidx2];
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__a_reg_en 
        = Vtop__ConstPool__TABLE_h9aef1b65_0[__Vtableidx2];
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__b_reg_en 
        = Vtop__ConstPool__TABLE_h00ea721b_0[__Vtableidx2];
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__a_mux_sel 
        = Vtop__ConstPool__TABLE_hfcc82a61_0[__Vtableidx2];
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__b_mux_sel 
        = Vtop__ConstPool__TABLE_hfc195d6e_0[__Vtableidx2];
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__a_reg_en 
        = vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__a_reg_en;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__b_reg_en 
        = vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__b_reg_en;
    vlSelf->istream_rdy = vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__istream_rdy;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__req_go 
        = ((IData)(vlSelf->istream_val) & (IData)(vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__istream_rdy));
    vlSelf->ostream_val = vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__ostream_val;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__resp_go 
        = ((IData)(vlSelf->ostream_rdy) & (IData)(vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__ostream_val));
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__b_mux_sel 
        = vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__b_mux_sel;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__a_mux_sel 
        = vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__a_mux_sel;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_reg_en 
        = vlSelf->tut3_verilog_gcd_GcdUnit__DOT__a_reg_en;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_reg_en 
        = vlSelf->tut3_verilog_gcd_GcdUnit__DOT__b_reg_en;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__istream_rdy 
        = vlSelf->istream_rdy;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ostream_val 
        = vlSelf->ostream_val;
    __Vtableidx1 = (((IData)(vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__resp_go) 
                     << 4U) | (((IData)(vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__is_calc_done) 
                                << 3U) | (((IData)(vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__req_go) 
                                           << 2U) | (IData)(vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__state_reg))));
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__state_next 
        = Vtop__ConstPool__TABLE_h6b4dffe9_0[__Vtableidx1];
    if (vlSelf->tut3_verilog_gcd_GcdUnit__DOT__b_mux_sel) {
        vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_mux_sel = 1U;
        vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_mux__DOT__out 
            = ((IData)(vlSelf->tut3_verilog_gcd_GcdUnit__DOT__b_mux_sel)
                ? (IData)(vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_reg_out)
                : 0U);
    } else {
        vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_mux_sel = 0U;
        vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_mux__DOT__out 
            = vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__istream_msg_b;
    }
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_mux_sel 
        = vlSelf->tut3_verilog_gcd_GcdUnit__DOT__a_mux_sel;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_mux__DOT__out 
        = ((0U == (IData)(vlSelf->tut3_verilog_gcd_GcdUnit__DOT__a_mux_sel))
            ? (IData)(vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__istream_msg_a)
            : ((1U == (IData)(vlSelf->tut3_verilog_gcd_GcdUnit__DOT__a_mux_sel))
                ? (IData)(vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_reg_out)
                : ((2U == (IData)(vlSelf->tut3_verilog_gcd_GcdUnit__DOT__a_mux_sel))
                    ? (IData)(vlSelf->ostream_msg) : 0U)));
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_reg__DOT__en 
        = vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_reg_en;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_reg__DOT__en 
        = vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_reg_en;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_mux__DOT__sel 
        = vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_mux_sel;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_mux_out 
        = vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_mux__DOT__out;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_mux__DOT__sel 
        = vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_mux_sel;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_mux_out 
        = vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_mux__DOT__out;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_reg__DOT__d 
        = vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_mux_out;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_reg__DOT__d 
        = vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_mux_out;
}

void Vtop___024root___eval_ico(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_ico\n"); );
    // Body
    if ((1ULL & vlSelf->__VicoTriggered.word(0U))) {
        Vtop___024root___ico_sequent__TOP__0(vlSelf);
    }
}

void Vtop___024root___eval_act(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_act\n"); );
}

VL_INLINE_OPT void Vtop___024root___nba_sequent__TOP__0(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___nba_sequent__TOP__0\n"); );
    // Init
    CData/*4:0*/ __Vtableidx1;
    __Vtableidx1 = 0;
    CData/*3:0*/ __Vtableidx2;
    __Vtableidx2 = 0;
    // Body
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__state_reg 
        = ((IData)(vlSelf->reset) ? 0U : (IData)(vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__state_next));
    if (vlSelf->tut3_verilog_gcd_GcdUnit__DOT__a_reg_en) {
        vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_reg__DOT__q 
            = vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_mux_out;
    }
    if (vlSelf->tut3_verilog_gcd_GcdUnit__DOT__b_reg_en) {
        vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_reg__DOT__q 
            = vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_mux_out;
    }
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_reg_out 
        = vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_reg__DOT__q;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_reg_out 
        = vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_reg__DOT__q;
    vlSelf->ostream_msg = (0xffffU & ((IData)(vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_reg__DOT__q) 
                                      - (IData)(vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_reg__DOT__q)));
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__is_b_zero 
        = (0U == (IData)(vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_reg__DOT__q));
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__is_a_lt_b 
        = ((IData)(vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_reg__DOT__q) 
           < (IData)(vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_reg__DOT__q));
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_mux__DOT__in1 
        = vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_reg_out;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_lt_b__DOT__in0 
        = vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_reg_out;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__sub__DOT__in0 
        = vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_reg_out;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_mux__DOT__in1 
        = vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_reg_out;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_lt_b__DOT__in1 
        = vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_reg_out;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_zero__DOT__in 
        = vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_reg_out;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__sub__DOT__in1 
        = vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_reg_out;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_mux__DOT__in2 
        = vlSelf->ostream_msg;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ostream_msg 
        = vlSelf->ostream_msg;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__ostream_msg 
        = vlSelf->ostream_msg;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__sub_out 
        = vlSelf->ostream_msg;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__sub__DOT__out 
        = vlSelf->ostream_msg;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__is_b_zero 
        = vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__is_b_zero;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__is_b_zero 
        = vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__is_b_zero;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_zero__DOT__out 
        = vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__is_b_zero;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__do_sub 
        = (1U & (~ (IData)(vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__is_b_zero)));
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__is_a_lt_b 
        = vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__is_a_lt_b;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__is_a_lt_b 
        = vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__is_a_lt_b;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__do_swap 
        = vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__is_a_lt_b;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_lt_b__DOT__out 
        = vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__is_a_lt_b;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__is_calc_done 
        = ((~ (IData)(vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__is_a_lt_b)) 
           & (IData)(vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__is_b_zero));
    __Vtableidx2 = (((IData)(vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__do_sub) 
                     << 3U) | (((IData)(vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__is_a_lt_b) 
                                << 2U) | (IData)(vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__state_reg)));
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__istream_rdy 
        = Vtop__ConstPool__TABLE_h09fed229_0[__Vtableidx2];
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__ostream_val 
        = Vtop__ConstPool__TABLE_hdd48603f_0[__Vtableidx2];
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__a_reg_en 
        = Vtop__ConstPool__TABLE_h9aef1b65_0[__Vtableidx2];
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__b_reg_en 
        = Vtop__ConstPool__TABLE_h00ea721b_0[__Vtableidx2];
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__a_mux_sel 
        = Vtop__ConstPool__TABLE_hfcc82a61_0[__Vtableidx2];
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__b_mux_sel 
        = Vtop__ConstPool__TABLE_hfc195d6e_0[__Vtableidx2];
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__a_reg_en 
        = vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__a_reg_en;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__b_reg_en 
        = vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__b_reg_en;
    vlSelf->istream_rdy = vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__istream_rdy;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__req_go 
        = ((IData)(vlSelf->istream_val) & (IData)(vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__istream_rdy));
    vlSelf->ostream_val = vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__ostream_val;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__resp_go 
        = ((IData)(vlSelf->ostream_rdy) & (IData)(vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__ostream_val));
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__b_mux_sel 
        = vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__b_mux_sel;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__a_mux_sel 
        = vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__a_mux_sel;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_reg_en 
        = vlSelf->tut3_verilog_gcd_GcdUnit__DOT__a_reg_en;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_reg_en 
        = vlSelf->tut3_verilog_gcd_GcdUnit__DOT__b_reg_en;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__istream_rdy 
        = vlSelf->istream_rdy;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ostream_val 
        = vlSelf->ostream_val;
    __Vtableidx1 = (((IData)(vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__resp_go) 
                     << 4U) | (((IData)(vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__is_calc_done) 
                                << 3U) | (((IData)(vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__req_go) 
                                           << 2U) | (IData)(vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__state_reg))));
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__ctrl__DOT__state_next 
        = Vtop__ConstPool__TABLE_h6b4dffe9_0[__Vtableidx1];
    if (vlSelf->tut3_verilog_gcd_GcdUnit__DOT__b_mux_sel) {
        vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_mux_sel = 1U;
        vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_mux__DOT__out 
            = ((IData)(vlSelf->tut3_verilog_gcd_GcdUnit__DOT__b_mux_sel)
                ? (IData)(vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_reg_out)
                : 0U);
    } else {
        vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_mux_sel = 0U;
        vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_mux__DOT__out 
            = vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__istream_msg_b;
    }
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_mux_sel 
        = vlSelf->tut3_verilog_gcd_GcdUnit__DOT__a_mux_sel;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_mux__DOT__out 
        = ((0U == (IData)(vlSelf->tut3_verilog_gcd_GcdUnit__DOT__a_mux_sel))
            ? (IData)(vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__istream_msg_a)
            : ((1U == (IData)(vlSelf->tut3_verilog_gcd_GcdUnit__DOT__a_mux_sel))
                ? (IData)(vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_reg_out)
                : ((2U == (IData)(vlSelf->tut3_verilog_gcd_GcdUnit__DOT__a_mux_sel))
                    ? (IData)(vlSelf->ostream_msg) : 0U)));
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_reg__DOT__en 
        = vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_reg_en;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_reg__DOT__en 
        = vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_reg_en;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_mux__DOT__sel 
        = vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_mux_sel;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_mux_out 
        = vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_mux__DOT__out;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_mux__DOT__sel 
        = vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_mux_sel;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_mux_out 
        = vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_mux__DOT__out;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_reg__DOT__d 
        = vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__b_mux_out;
    vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_reg__DOT__d 
        = vlSelf->tut3_verilog_gcd_GcdUnit__DOT__dpath__DOT__a_mux_out;
}

void Vtop___024root___eval_nba(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_nba\n"); );
    // Body
    if ((1ULL & vlSelf->__VnbaTriggered.word(0U))) {
        Vtop___024root___nba_sequent__TOP__0(vlSelf);
    }
}

void Vtop___024root___eval_triggers__ico(Vtop___024root* vlSelf);
#ifdef VL_DEBUG
VL_ATTR_COLD void Vtop___024root___dump_triggers__ico(Vtop___024root* vlSelf);
#endif  // VL_DEBUG
void Vtop___024root___eval_triggers__act(Vtop___024root* vlSelf);
#ifdef VL_DEBUG
VL_ATTR_COLD void Vtop___024root___dump_triggers__act(Vtop___024root* vlSelf);
#endif  // VL_DEBUG
#ifdef VL_DEBUG
VL_ATTR_COLD void Vtop___024root___dump_triggers__nba(Vtop___024root* vlSelf);
#endif  // VL_DEBUG

void Vtop___024root___eval(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval\n"); );
    // Init
    CData/*0:0*/ __VicoContinue;
    VlTriggerVec<1> __VpreTriggered;
    IData/*31:0*/ __VnbaIterCount;
    CData/*0:0*/ __VnbaContinue;
    // Body
    vlSelf->__VicoIterCount = 0U;
    __VicoContinue = 1U;
    while (__VicoContinue) {
        __VicoContinue = 0U;
        Vtop___024root___eval_triggers__ico(vlSelf);
        if (vlSelf->__VicoTriggered.any()) {
            __VicoContinue = 1U;
            if (VL_UNLIKELY((0x64U < vlSelf->__VicoIterCount))) {
#ifdef VL_DEBUG
                Vtop___024root___dump_triggers__ico(vlSelf);
#endif
                VL_FATAL_MT("/home/acm289/blimp/playground/gcd/GcdUnit.v", 277, "", "Input combinational region did not converge.");
            }
            vlSelf->__VicoIterCount = ((IData)(1U) 
                                       + vlSelf->__VicoIterCount);
            Vtop___024root___eval_ico(vlSelf);
        }
    }
    __VnbaIterCount = 0U;
    __VnbaContinue = 1U;
    while (__VnbaContinue) {
        __VnbaContinue = 0U;
        vlSelf->__VnbaTriggered.clear();
        vlSelf->__VactIterCount = 0U;
        vlSelf->__VactContinue = 1U;
        while (vlSelf->__VactContinue) {
            vlSelf->__VactContinue = 0U;
            Vtop___024root___eval_triggers__act(vlSelf);
            if (vlSelf->__VactTriggered.any()) {
                vlSelf->__VactContinue = 1U;
                if (VL_UNLIKELY((0x64U < vlSelf->__VactIterCount))) {
#ifdef VL_DEBUG
                    Vtop___024root___dump_triggers__act(vlSelf);
#endif
                    VL_FATAL_MT("/home/acm289/blimp/playground/gcd/GcdUnit.v", 277, "", "Active region did not converge.");
                }
                vlSelf->__VactIterCount = ((IData)(1U) 
                                           + vlSelf->__VactIterCount);
                __VpreTriggered.andNot(vlSelf->__VactTriggered, vlSelf->__VnbaTriggered);
                vlSelf->__VnbaTriggered.thisOr(vlSelf->__VactTriggered);
                Vtop___024root___eval_act(vlSelf);
            }
        }
        if (vlSelf->__VnbaTriggered.any()) {
            __VnbaContinue = 1U;
            if (VL_UNLIKELY((0x64U < __VnbaIterCount))) {
#ifdef VL_DEBUG
                Vtop___024root___dump_triggers__nba(vlSelf);
#endif
                VL_FATAL_MT("/home/acm289/blimp/playground/gcd/GcdUnit.v", 277, "", "NBA region did not converge.");
            }
            __VnbaIterCount = ((IData)(1U) + __VnbaIterCount);
            Vtop___024root___eval_nba(vlSelf);
        }
    }
}

#ifdef VL_DEBUG
void Vtop___024root___eval_debug_assertions(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_debug_assertions\n"); );
    // Body
    if (VL_UNLIKELY((vlSelf->clk & 0xfeU))) {
        Verilated::overWidthError("clk");}
    if (VL_UNLIKELY((vlSelf->reset & 0xfeU))) {
        Verilated::overWidthError("reset");}
    if (VL_UNLIKELY((vlSelf->istream_val & 0xfeU))) {
        Verilated::overWidthError("istream_val");}
    if (VL_UNLIKELY((vlSelf->ostream_rdy & 0xfeU))) {
        Verilated::overWidthError("ostream_rdy");}
}
#endif  // VL_DEBUG
