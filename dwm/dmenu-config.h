/* See LICENSE file for copyright and license details. */
/* Default settings; can be overriden by command line. */

static int topbar = 1;                      /* -b  option; if 0, dmenu appears at bottom     */
/* -fn option overrides fonts[0]; default X11 font or font set */
static const char *fonts[] = {
	"sans:size=11"
};

static const char *prompt      = NULL;      /* -p  option; prompt to the left of input field */
// static const char *colors[SchemeLast][2] = {
// 	/*     fg         bg       */
// 	[SchemeNorm] = { "#bbbbbb", "#222222" },
// 	[SchemeSel] = { "#eeeeee", "#550077" },
// 	[SchemeOut] = { "#000000", "#00ffff" },
// };

// // Lim
// static const char *colors[SchemeLast][2] = {
// 	/*     fg         bg       */
// 	[SchemeNorm] = { "#222222", "#e6e6e6" },
// 	[SchemeSel] = { "#eeeeee", "#6868da" },
// 	[SchemeOut] = { "#000000", "#00ffff" },
// };

// // BellePintosGrande
// static const char *colors[SchemeLast][2] = {
// 	/*     fg         bg       */
// 	[SchemeNorm] = { "#000000", "#afadbf" },
// 	[SchemeSel] = { "#ffffff", "#b24d7a" },
// 	[SchemeOut] = { "#000000", "#00ffff" },
// };

// // Breeze
// static const char *colors[SchemeLast][2] = {
// 	/*     fg         bg       */
// 	[SchemeNorm] = { "#232627", "#eff0f1" },
// 	[SchemeSel] = { "#fcfcfc", "#3daee9" },
// 	[SchemeOut] = { "#000000", "#00ffff" },
// };

// // Breeze Dark
// static const char *colors[SchemeLast][2] = {
// 	/*     fg         bg       */
// 	[SchemeNorm] = { "#fcfcfc", "#2a2e32" },
// 	[SchemeSel] = { "#fcfcfc", "#3daee9" },
// 	[SchemeOut] = { "#000000", "#00ffff" },
// };

// // Breeze Dark but purple
// static const char *colors[SchemeLast][2] = {
// 	/*     fg         bg       */
// 	[SchemeNorm] = { "#fcfcfc", "#1b1e20" }, // #2a2e32
// 	[SchemeSel] = { "#fcfcfc", "#926ee4" },
// 	[SchemeOut] = { "#000000", "#00ffff" },
// };

// // Fluxbox: zimek_green
// // sel bg == #add07e to #718541 (mid #8faa5f)
// // norm bg == #f0efe9 to #bfbeb2 (mid #d7d6cd)
// static const char *colors[SchemeLast][2] = {
// 	/*     fg         bg       */
// 	[SchemeNorm] = { "#232627", "#d7d6cd" },
// 	[SchemeSel] = { "#e7e7e7", "#8faa5f" },
// 	[SchemeOut] = { "#000000", "#00ffff" },
// };

// greybird panel
static const char *colors[SchemeLast][2] = {
	/*     fg         bg       */
	[SchemeNorm] = { "#fcfcfc", "#242424" },
	[SchemeSel] = { "#fcfcfc", "#22558a" },
	[SchemeOut] = { "#000000", "#00ffff" },
};

/* -l option; if nonzero, dmenu uses vertical list with given number of lines */
static unsigned int lines      = 0;

/*
 * Characters not considered part of a word while deleting words
 * for example: " /?\"&[]"
 */
static const char worddelimiters[] = " ";
