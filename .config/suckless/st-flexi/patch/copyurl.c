/* select and copy the previous url on screen (do nothing if there's no url).
 * known bug: doesn't handle urls that span multiple lines (wontfix), depends on multiline "getsel()"
 * known bug: only finds first url on line (mightfix)
 */
void
copyurl(const Arg *arg) {
	/* () and [] can appear in urls, but excluding them here will reduce false
	 * positives when figuring out where a given url ends.
	 */
	static char URLCHARS[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
		"abcdefghijklmnopqrstuvwxyz"
		"0123456789-._~:/?#@!$&'*+,;=%";

	int i, row, startrow;
	char *linestr = calloc(term.col+1, sizeof(Rune));
	char *c, *match = NULL;

	row = (sel.ob.x >= 0 && sel.nb.y > 0) ? sel.nb.y-1 : term.bot;
	LIMIT(row, term.top, term.bot);
	startrow = row;

	/* find the start of the last url before selection */
	do {
		for (i = 0; i < term.col; ++i) {
			linestr[i] = term.line[row][i].u;
		}
		linestr[term.col] = '\0';
		if ((match = strstr(linestr, "http://"))
				|| (match = strstr(linestr, "https://")))
			break;
		if (--row < term.top)
			row = term.bot;
	} while (row != startrow);

	if (match) {
		/* must happen before trim */
		selclear();
		sel.ob.x = strlen(linestr) - strlen(match);

		/* trim the rest of the line from the url match */
		for (c = match; *c != '\0'; ++c)
			if (!strchr(URLCHARS, *c)) {
				*c = '\0';
				break;
			}

		/* select and copy */
		sel.mode = 1;
		sel.type = SEL_REGULAR;
		sel.oe.x = sel.ob.x + strlen(match)-1;
		sel.ob.y = sel.oe.y = row;
		selnormalize();
		tsetdirt(sel.nb.y, sel.ne.y);
		xsetsel(getsel());
		xclipcopy();
	}

	free(linestr);
}
