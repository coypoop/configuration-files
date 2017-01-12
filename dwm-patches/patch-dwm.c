--- dwm.c.orig	2015-11-08 22:39:37.000000000 +0000
+++ dwm.c
@@ -266,6 +266,8 @@ static Display *dpy;
 static Drw *drw;
 static Monitor *mons, *selmon;
 static Window root;
+static int globalborder ;
+static int globalborder ;
 
 /* configuration, allows nested code to access above variables */
 #include "config.h"
@@ -1294,10 +1296,16 @@ resizeclient(Client *c, int x, int y, in
 {
 	XWindowChanges wc;
 
-	c->oldx = c->x; c->x = wc.x = x;
-	c->oldy = c->y; c->y = wc.y = y;
-	c->oldw = c->w; c->w = wc.width = w;
-	c->oldh = c->h; c->h = wc.height = h;
+	if(c->isfloating || selmon->lt[selmon->sellt]->arrange == NULL ) { globalborder = 0 ; }
+	else {
+		if (selmon->lt[selmon->sellt]->arrange == monocle) { globalborder = 0 - borderpx ; }
+		else { globalborder = gappx ; }
+	}
+
+	c->oldx = c->x; c->x = wc.x = x + globalborder;
+	c->oldy = c->y; c->y = wc.y = y + globalborder;
+	c->oldw = c->w; c->w = wc.width = w - 2 * globalborder;
+	c->oldh = c->h; c->h = wc.height = h - 2 * globalborder;
 	wc.border_width = c->bw;
 	XConfigureWindow(dpy, c->win, CWX|CWY|CWWidth|CWHeight|CWBorderWidth, &wc);
 	configure(c);
@@ -1681,11 +1689,11 @@ tile(Monitor *m)
 		if (i < m->nmaster) {
 			h = (m->wh - my) / (MIN(n, m->nmaster) - i);
 			resize(c, m->wx, m->wy + my, mw - (2*c->bw), h - (2*c->bw), 0);
-			my += HEIGHT(c);
+			my += HEIGHT(c) + 2 * globalborder;
 		} else {
 			h = (m->wh - ty) / (n - i);
 			resize(c, m->wx + mw, m->wy + ty, m->ww - mw - (2*c->bw), h - (2*c->bw), 0);
-			ty += HEIGHT(c);
+			ty += HEIGHT(c) + 2 * globalborder;
 		}
 }
 
