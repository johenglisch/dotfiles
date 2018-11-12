/* See LICENSE file for copyright and license details. */

#include <X11/XF86keysym.h>

// PATCH DEPENDENCIES:
//  * https://dwm.suckless.org/patches/systray/

/* appearance */
static const char *fonts[] = {
    "DejaVu Sans Mono:size=11"
};
static const char dmenufont[]       = "DejaVu Sans Mono:size=11";
static const char normbordercolor[] = "#444444";
static const char normbgcolor[]     = "#222222";
static const char normfgcolor[]     = "#bbbbbb";
static const char selbordercolor[]  = "#005577";
static const char selbgcolor[]      = "#005577";
static const char selfgcolor[]      = "#eeeeee";
static const unsigned int borderpx  = 2;        /* border pixel of windows */
static const unsigned int snap      = 32;       /* snap pixel */
static const unsigned int systraypinning = 0;   /* 0: sloppy systray follows selected monitor, >0: pin systray to monitor X */
static const unsigned int systrayspacing = 2;   /* systray spacing */
static const int systraypinningfailfirst = 1;   /* 1: if pinning fails, display systray on the first monitor, 0: display systray on the last monitor*/
static const int showsystray        = 1;        /* 0 means no systray */
static const int showbar            = 1;        /* 0 means no bar */
static const int topbar             = 1;        /* 0 means bottom bar */

/* tagging */
static const char *tags[] = { "1", "2", "3", "4", "5", "6", "7", "8", "9" };

static const Rule rules[] = {
    /* xprop(1):
     *   WM_CLASS(STRING) = instance, class
     *   WM_NAME(STRING) = title
     */
    /* class       instance   title  tags mask  isfloating  monitor */
    { "qjackctl",  NULL,      NULL,  0,         1,          -1 },
};

/* layout(s) */
static const float A_E_S_T_H_E_T_I_C = 0.6180;
static const float mfact     = A_E_S_T_H_E_T_I_C; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 1;    /* 1 means respect size hints in tiled resizals */

static const Layout layouts[] = {
    /* symbol     arrange function */
    { "[]=",      tile },    /* first entry is default */
    { "><>",      NULL },    /* no layout function means floating behavior */
    { "[M]",      monocle },
};

/* key definitions */
#define MODKEY Mod4Mask
#define TAGKEYS(SWITCH_KEY,TOGGLE_KEY,TAG) \
{ MODKEY,           SWITCH_KEY,      view,           {.ui = 1 << TAG} }, \
{ MODKEY|ShiftMask, SWITCH_KEY,      tag,            {.ui = 1 << TAG} }, \
{ MODKEY,           TOGGLE_KEY,      toggleview,     {.ui = 1 << TAG} }, \
{ MODKEY|ShiftMask, TOGGLE_KEY,      toggletag,      {.ui = 1 << TAG} }

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[] = { "dmenu_run", "-m", dmenumon, "-fn", dmenufont, "-nb", normbgcolor, "-nf", normfgcolor, "-sb", selbgcolor, "-sf", selfgcolor, NULL };
static const char *termcmd[]  = { "st", NULL };
static const char *slockcmd[] = { "slock", NULL };

static const char *browsercmd[]    = { "firefox", NULL };
static const char *pvt_browsercmd[]    = { "firefox", "--private-window", NULL };
static const char *mailreadercmd[] = { "thunderbird", NULL };

static const char *mpc_stop[]   = { "mpc", "stop", NULL };
static const char *mpc_toggle[] = { "mpc", "toggle", NULL };
static const char *mpc_prev[]   = { "mpc", "prev", NULL };
static const char *mpc_next[]   = { "mpc", "next", NULL };

static const char *vol_mute[] = { "pulsemixer", "--toggle-mute", NULL};
static const char *vol_up[]   = { "pulsemixer", "--change-volume", "+5", "--unmute", NULL};
static const char *vol_down[] = { "pulsemixer", "--change-volume", "-5", "--unmute", NULL};

static Key keys[] = {
    /* modifier          key         function  argument */
    { MODKEY,            XK_p,       spawn,    {.v = dmenucmd } },
    { MODKEY,            XK_Return,  spawn,    {.v = termcmd } },
    { MODKEY,            XK_b,       spawn,    {.v = browsercmd } },
    { MODKEY|ShiftMask,  XK_b,       spawn,    {.v = pvt_browsercmd } },
    { MODKEY,            XK_i,       spawn,    {.v = mailreadercmd } },

    { 0,       XF86XK_ScreenSaver,  spawn,  {.v = slockcmd } },
    { MODKEY,  XK_Escape,           spawn,  {.v = slockcmd } },

    { MODKEY,  XK_Up,             spawn,  {.v = mpc_stop } },
    { MODKEY,  XK_Down,           spawn,  {.v = mpc_toggle } },
    { MODKEY,  XK_Left,           spawn,  {.v = mpc_prev } },
    { MODKEY,  XK_Right,          spawn,  {.v = mpc_next } },

    { 0,       XF86XK_AudioStop,  spawn,  {.v = mpc_stop } },
    { 0,       XF86XK_AudioPlay,  spawn,  {.v = mpc_toggle } },
    { 0,       XF86XK_AudioPrev,  spawn,  {.v = mpc_prev } },
    { 0,       XF86XK_AudioNext,  spawn,  {.v = mpc_next } },

    { MODKEY,  XK_Home,                  spawn,  {.v = vol_mute } },
    { MODKEY,  XK_Prior,                 spawn,  {.v = vol_up } },
    { MODKEY,  XK_Next,                  spawn,  {.v = vol_down } },

    { 0,       XF86XK_AudioMute,         spawn,  {.v = vol_mute } },
    { 0,       XF86XK_AudioRaiseVolume,  spawn,  {.v = vol_up } },
    { 0,       XF86XK_AudioLowerVolume,  spawn,  {.v = vol_down } },

    { MODKEY|ShiftMask,  XK_f,      togglebar,      {0} },
    { MODKEY,            XK_j,      focusstack,     {.i = +1 } },
    { MODKEY,            XK_k,      focusstack,     {.i = -1 } },
    { MODKEY,            XK_s,      incnmaster,     {.i = +1 } },
    { MODKEY,            XK_d,      incnmaster,     {.i = -1 } },
    { MODKEY,            XK_h,      setmfact,       {.f = -0.05} },
    { MODKEY,            XK_l,      setmfact,       {.f = +0.05} },
    { MODKEY|ShiftMask,  XK_Return, zoom,           {0} },
    { MODKEY,            XK_Tab,    view,           {0} },
    { MODKEY|ShiftMask,  XK_c,      killclient,     {0} },
    { MODKEY,            XK_t,      setlayout,      {.v = &layouts[0]} },
    { MODKEY,            XK_f,      setlayout,      {.v = &layouts[1]} },
    { MODKEY,            XK_m,      setlayout,      {.v = &layouts[2]} },
    { MODKEY,            XK_space,  setlayout,      {0} },
    { MODKEY|ShiftMask,  XK_space,  togglefloating, {0} },
    { MODKEY,            XK_0,      view,           {.ui = ~0 } },
    { MODKEY|ShiftMask,  XK_0,      tag,            {.ui = ~0 } },
    { MODKEY,            XK_comma,  focusmon,       {.i = -1 } },
    { MODKEY,            XK_period, focusmon,       {.i = +1 } },
    { MODKEY|ShiftMask,  XK_comma,  tagmon,         {.i = -1 } },
    { MODKEY|ShiftMask,  XK_period, tagmon,         {.i = +1 } },
    TAGKEYS(XK_1, XK_F1, 0),
    TAGKEYS(XK_2, XK_F2, 1),
    TAGKEYS(XK_3, XK_F3, 2),
    TAGKEYS(XK_4, XK_F4, 3),
    TAGKEYS(XK_5, XK_F5, 4),
    TAGKEYS(XK_6, XK_F6, 5),
    TAGKEYS(XK_7, XK_F7, 6),
    TAGKEYS(XK_8, XK_F8, 7),
    TAGKEYS(XK_9, XK_F9, 8),
    { MODKEY|ShiftMask,  XK_q,      quit,           {0} },
};

/* button definitions */
/* click can be ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static Button buttons[] = {
    /* click                event mask      button          function        argument */
    { ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
    { ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
    { ClkWinTitle,          0,              Button2,        zoom,           {0} },
    { ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
    { ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
    { ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
    { ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
    { ClkTagBar,            0,              Button1,        view,           {0} },
    { ClkTagBar,            0,              Button3,        toggleview,     {0} },
    { ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
    { ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};
