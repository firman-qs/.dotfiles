-- Abbreviations used in this article and the LuaSnip docs
local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local extras = require("luasnip.extras")
local l = extras.lambda
local rep = extras.rep
local p = extras.partial
local m = extras.match
local n = extras.nonempty
local dl = extras.dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local conds = require("luasnip.extras.expand_conditions")
local postfix = require("luasnip.extras.postfix").postfix
local types = require("luasnip.util.types")
local parse = require("luasnip.util.parser").parse_snippet
local ms = ls.multi_snippet
local k = require("luasnip.nodes.key_indexer").new_key

require("luasnip").config.setup({
   ext_opts = {
      [types.choiceNode] = {
         active = {
            virt_text = { { "●", "GruvboxOrange" } },
         },
      },
      [types.insertNode] = {
         active = {
            virt_text = { { "●", "GruvboxBlue" } },
         },
      },
   },
})

local get_visual = function(args, parent)
   if #parent.snippet.env.LS_SELECT_RAW > 0 then
      return sn(nil, i(1, parent.snippet.env.LS_SELECT_RAW))
   else -- If LS_SELECT_RAW is empty, return a blank insert node
      return sn(nil, i(1))
   end
end

return {
   s(
      { trig = "tii", dscr = "Expands 'tii' into LaTeX's textit{} command." },
      fmta("\\textit{<>}", {
         d(1, get_visual),
      })
   ),
   s(
      { trig = "([^%a])mm" },
      fmta("<>$<>$", { f(function(_, snip)
         return snip.captures[1]
      end), d(1, get_visual) })
   ),
   s(
      { trig = "beginintikzpicture", dscr = "inkscape generated figure with text" },
      fmta(
         [[
			\begin{center}
				\begin{tikzpicture}
					\draw (0, 0) node[inner sep=0] {\incsvg{./figures/}{<>};
					\draw (1, 1) node {<>};
				\end{tikzpicture}
				\captionof{figure}{<>}
				\label{<>}
			\end{center}
         <>
         ]],
         { i(1, "figure file name"), i(2, "text in figure"), i(3, "figure caption"), i(4, "figure label"), i(0) }
      )
   ),
   s(
      { trig = "begininfigure", dscr = "inkscape generated figure" },
      fmta(
         [[
         \begin{figure}[h]
            \centering
				\incsvg{./figures/}{<>}
				\caption{<>}
				\label{<>}
			\end{figure}
			<>
         ]],
         { i(1, "figure file name"), i(2, "figure caption"), i(3, "figure label"), i(0) }
      )
   ),
   s(
      { trig = "setup times new roman", dscr = "setup times new roman-like font" },
      fmta(
         [[
         \usepackage{tgtermes}
			\renewcommand{\sfdefault}{ptm}
			<>
         ]],
         { i(0) }
      )
   ),
   s(
      { trig = "setup inkscape for latex", dscr = "setup inkscape for latex" },
      fmta(
         [[
         \usepackage{caption}
			\usepackage{tikz}
			\newcommand{\incsvg}[2]{%
				\def\svgwidth{0.9\columnwidth}
				\graphicspath{{#1}}
				\input{#2.pdf_tex}
			}
         <>
         ]],
         { i(0) }
      )
   ),
}
