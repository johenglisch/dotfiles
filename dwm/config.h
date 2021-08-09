/* See LICENSE file for copyright and license details. */

/* appearance */
static const unsigned int borderpx  = 2;        /* border pixel of windows */
static const unsigned int gappx     = 6;        /* gaps between windows */
static const unsigned int snap      = 8;        /* snap pixel */
static const int showbar            = 1;        /* 0 means no bar */
static const int topbar             = 1;        /* 0 means bottom bar */
static const char *fonts[]          = { "sans:size=10" };
static const char dmenufont[]       = "sans:size=10";
static const char col_gray1[]       = "#222222";
static const char col_gray2[]       = "#444444";
static const char col_gray3[]       = "#bbbbbb";
static const char col_gray4[]       = "#eeeeee";
static const char col_purple[]      = "#550077";
static const char col_green[]       = "#00ff00";
static const char *colors[][3]      = {
	/*               fg         bg           border   */
	[SchemeNorm] = { col_gray3, col_gray1,   col_gray2 },
	[SchemeSel]  = { col_gray4, col_purple,  col_green },
};

/* tagging */
static const char *tags[] = { "1", "2", "3", "4", "5", "6", "7", "8", "9" };

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class      instance    title  tags mask  isfloating   monitor */
	{ "qjackctl",  NULL,      NULL,  0,         1,          -1 },
	{ "QjackCtl",  NULL,      NULL,  0,         1,          -1 },
	{ "st",        "scratch", NULL,  0,         1,          -1 },
	{ "skype",     NULL,      NULL,  0,         0,          -1 },
};

/* layout(s) */
static const float mfact     = 0.55; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 1;    /* 1 means respect size hints in tiled resizals */

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[]=",      tile },    /* first entry is default */
	{ "><>",      NULL },    /* no layout function means floating behavior */
	{ "[M]",      monocle },
};

/* custom function declarations */

static void togglefullscreen(const Arg *arg);

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
static const char *dmenucmd[] = { "dmenu_run", "-m", dmenumon, "-fn", dmenufont, "-nb", col_gray1, "-nf", col_gray3, "-sb", col_purple, "-sf", col_gray4, NULL };
static const char *termcmd[]  = { "kitty", "-1", NULL };

static Key keys[] = {
	/* modifier          key        function          argument */
	{ MODKEY,            XK_p,      spawn,            {.v = dmenucmd } },
	{ MODKEY,            XK_Return, spawn,            {.v = termcmd } },
	//{ MODKEY,            XK_b,      togglebar,        {0} },
	{ MODKEY,            XK_j,      focusstack,       {.i = +1 } },
	{ MODKEY,            XK_k,      focusstack,       {.i = -1 } },
	{ MODKEY,            XK_s,      incnmaster,       {.i = +1 } },
	{ MODKEY,            XK_d,      incnmaster,       {.i = -1 } },
	{ MODKEY,            XK_h,      setmfact,         {.f = -0.05} },
	{ MODKEY,            XK_l,      setmfact,         {.f = +0.05} },
	{ MODKEY|ShiftMask,  XK_Return, zoom,             {0} },
	{ MODKEY,            XK_Tab,    view,             {0} },
	{ MODKEY|ShiftMask,  XK_c,      killclient,       {0} },
	{ MODKEY,            XK_t,      setlayout,        {.v = &layouts[0]} },
	{ MODKEY,            XK_f,      setlayout,        {.v = &layouts[1]} },
	{ MODKEY,            XK_m,      setlayout,        {.v = &layouts[2]} },
	//{ MODKEY,            XK_space,  setlayout,        {0} },
	{ MODKEY|ShiftMask,  XK_space,  togglefloating,   {0} },
	{ MODKEY|ShiftMask,  XK_f,      togglefullscreen, {0} },
	{ MODKEY,            XK_0,      view,             {.ui = ~0 } },
	{ MODKEY|ShiftMask,  XK_0,      tag,              {.ui = ~0 } },
	{ MODKEY,            XK_comma,  focusmon,         {.i = -1 } },
	{ MODKEY,            XK_period, focusmon,         {.i = +1 } },
	{ MODKEY|ShiftMask,  XK_comma,  tagmon,           {.i = -1 } },
	{ MODKEY|ShiftMask,  XK_period, tagmon,           {.i = +1 } },
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

/* custom functions */

static void
togglefullscreen(const Arg *arg)
{
	if (!selmon->sel)
		return;
	setfullscreen(selmon->sel, !selmon->sel->isfullscreen);
}


/* vim: set noet ts=4 sts=4 sw=4: */
