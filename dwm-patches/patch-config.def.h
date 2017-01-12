--- config.def.h.orig	2015-11-08 22:39:37.000000000 +0000
+++ config.def.h
@@ -4,7 +4,7 @@
 static const char *fonts[] = {
 	"monospace:size=10"
 };
-static const char dmenufont[]       = "monospace:size=10";
+static const char dmenufont[]       = "Bitstream Vera Sans mono:size=10";
 static const char normbordercolor[] = "#444444";
 static const char normbgcolor[]     = "#222222";
 static const char normfgcolor[]     = "#bbbbbb";
@@ -12,6 +12,7 @@ static const char selbordercolor[]  = "#
 static const char selbgcolor[]      = "#005577";
 static const char selfgcolor[]      = "#eeeeee";
 static const unsigned int borderpx  = 1;        /* border pixel of windows */
+static const unsigned int gappx	    = 6;	/* gap pixel between windows */
 static const unsigned int snap      = 32;       /* snap pixel */
 static const int showbar            = 1;        /* 0 means no bar */
 static const int topbar             = 1;        /* 0 means bottom bar */
@@ -26,7 +27,6 @@ static const Rule rules[] = {
 	 */
 	/* class      instance    title       tags mask     isfloating   monitor */
 	{ "Gimp",     NULL,       NULL,       0,            1,           -1 },
-	{ "Firefox",  NULL,       NULL,       1 << 8,       0,           -1 },
 };
 
 /* layout(s) */
@@ -42,7 +42,7 @@ static const Layout layouts[] = {
 };
 
 /* key definitions */
-#define MODKEY Mod1Mask
+#define MODKEY Mod4Mask
 #define TAGKEYS(KEY,TAG) \
 	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
 	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
@@ -55,10 +55,20 @@ static const Layout layouts[] = {
 /* commands */
 static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
 static const char *dmenucmd[] = { "dmenu_run", "-m", dmenumon, "-fn", dmenufont, "-nb", normbgcolor, "-nf", normfgcolor, "-sb", selbgcolor, "-sf", selfgcolor, NULL };
-static const char *termcmd[]  = { "st", NULL };
+static const char *termcmd[]  = { "urxvt", NULL };
+static const char *wallpaper[] = { "wallpaper", NULL };
+static const char *voldn[] = { "voldn", NULL };
+static const char *volup[] = { "volup", NULL };
+static const char *firefox[] = { "firefox", NULL };
+static const char *pangoterm[] = { "pangoterm", NULL };
 
 static Key keys[] = {
 	/* modifier                     key        function        argument */
+	{ MODKEY|ShiftMask,             XK_a,      spawn,          {.v = volup } },
+	{ MODKEY|ShiftMask,             XK_s,      spawn,          {.v = voldn } },
+	{ MODKEY|ShiftMask,             XK_f,      spawn,          {.v = wallpaper } },
+	{ MODKEY,                       XK_F1,     spawn,          {.v = firefox } },
+        { MODKEY|ShiftMask,             XK_t,      spawn,          {.v = pangoterm } },
 	{ MODKEY,                       XK_p,      spawn,          {.v = dmenucmd } },
 	{ MODKEY|ShiftMask,             XK_Return, spawn,          {.v = termcmd } },
 	{ MODKEY,                       XK_b,      togglebar,      {0} },
