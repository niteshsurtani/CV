% Copyright (C) 2012  Nicola Fontana <ntd at entidi.it>
%
% This program can be redistributed and/or modified under
% the terms of the LaTeX Project Public License, either
% version 1.3 of this license or (at your option) any later
% version. The latest version of this license is in
%   http://www.latex-project.org/lppl.txt
% and version 1.3 or later is part of all LaTeX distributions
% version 2005/12/01 or later.
%
% Based on the original idea by Alessandro Plasmati found at
% http://www.latextemplates.com/template/two-column-one-page-cv
%
% The most relevant changes from his work are:
%
% * this is a class, not a template document;
% * tccv is based on scrartcl (from Koma-script), not on article;
% * the fonts are selected from the PSNFSS collection, so no
%   custom font installation should be required;
% * heavily based the implementation on custom environments and
%   macros, so the document is much easier to read (and customize);
% * it is plain LaTeX/Koma-script, so the CV can be compiled
%   with the usual tools, latex and pdflatex included.
%
% Modified *heavily* (again) by Pooria Azimi:
% https://github.com/pooriaazimi/CV/
%

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{tccv}
              [2012/11/09 v1.0
 Two Column Curriculum Vaitae]

\LoadClass[10pt]{scrartcl}

\setcounter{secnumdepth}{-1}
\RequirePackage[hmargin=1cm,tmargin=0.9cm,bmargin=1.1cm,twocolumn,columnsep=1cm]{geometry}
\RequirePackage{bookman,etoolbox,hyperref,marvosym,needspace,tabularx,xcolor,lipsum,tikz,fourier-orns}

\newcommand{\sectionline}{%
  \noindent
  \begin{center}
  {\color{darkgray}
    \resizebox{0.8\linewidth}{1ex}
    {{%
    {\begin{tikzpicture}
    \node  (C) at (0,0) {};
    \node (D) at (6,0) {};
    \path (C) to [ornament=88] (D);
    \end{tikzpicture}}}}}%
    \end{center}
  }

\newcolumntype{L}[1]{>{\raggedright\let\newline\\\arraybackslash\hspace{0pt}}m{#1}}
\newcolumntype{C}[1]{>{\centering\let\newline\\\arraybackslash\hspace{0pt}}m{#1}}
\newcolumntype{R}[1]{>{\raggedleft\let\newline\\\arraybackslash\hspace{0pt}}m{#1}}



% Capitalize words of at least a minimum length (default to 3 chars).
% The text is capitalized before being expanded.
%
% This macro uses Lua to do the job but fails gracefully (that is,
% return the text as is) if \directlua is not available.
%
% |[
% \ucwords[optional: miminum length]{text}
% ]|
\newcommand\ucwords[2][3]{%
    % Fails gracefully if not in LuaLaTeX
    \providecommand\directlua[1]{#2}%
    \directlua{%
	local minlen=tonumber("#1")
	local src="\luaescapestring{\unexpanded{#2}}"
	local dst={}
	for w in src:gmatch('[^\string\%s]+') do
	    if w:len() >= minlen then w = w:sub(1,1):upper()..w:sub(2) end
	    table.insert(dst, w)
	end
	tex.print(dst)}}

\pagestyle{empty}
\setlength\parindent{0pt}
\color[HTML]{303030} % Default foreground color
\definecolor{link}{HTML}{457291} % Hyperlinks
\hypersetup{colorlinks,breaklinks,urlcolor=link,linkcolor=link}
\setkomafont{disposition}{\color[HTML]{801010}}
\setkomafont{section}{\scshape\Large\mdseries}

% In tccv \part must contain the subject of the curriculum vitae.
% The command will start a new page and output in onecolumn the
% subject (first and last name) with the hardcoded text
% "Curriculum vitae" under it.
\renewcommand\part[1]{%
    \twocolumn[%
    \begin{center}
		\vskip-\lastskip%
		{\usekomafont{part} #1} \medskip\\
		{\Large Curriculum Vit\ae}
		\bigskip\\
	\end{center}
	\vspace{-0.7cm}
	\hfill \href{http://bit.ly/pooria-azimi-cv}{http://bit.ly/pooria-azimi-cv}
	\vspace{-0.55cm}	
	\center{
		\hrulefill\hspace{0.2cm}
		\floweroneleft\floweroneright
		\hspace{0.2cm} \hrulefill}
	\vspace{0.3cm}	
	\bigskip\\
    ]}

% Overrides the \section command to capitalize every
% word for cosmetic purposes and draws a rule under it.
\makeatletter
\let\old@section\section
\renewcommand\section[2][]{%
    \old@section[#1]{\ucwords{#2}}%
    \newdimen\raising%
    \raising=\dimexpr-0.7\baselineskip\relax%
    \vskip\raising\hrule height 0.4pt\vskip-\raising}
\makeatother

% Allow conditionals based on the job name. This can usually be set
% from a command-line argument: check fausto.en.tex for an example.
%
% |[
% \ifjob{jobname}{content if matches}{content if does not match}
% ]|
\newcommand\ifjob[3]{%
    \edef\JOBNAME{\jobname}%
    \edef\PIVOT{\detokenize{#1}}%
    \ifdefstrequal{\JOBNAME}{\PIVOT}{#2}{#3}%
}



% |[
% \item{date range}{company}{title}{technologies}{description}
% ]|
\newenvironment{project_list}{%
    \newcommand*\inskip{}
    \renewcommand\item[5]{%
		\inskip%
		{\raggedleft ##1\\*[3pt]}
    	\ifstrempty{##2}{}{##2\\*[3pt]}
		{\Large\bf ##3}
		\begingroup
			\par
			\vspace{2pt}
			\leftskip0.8em
			##4%
		    \ifstrempty{##5}{}{\color[HTML]{666666}\\[3pt]{\it(##5)}}%
			\par
		\endgroup
		\medskip
		\renewcommand\inskip{\bigskip}
    }
}
{\bigskip}


% |[
% \item{title}{technologies}
% ]|
\newenvironment{oneline_projects}{%
    \newcommand*\inskip{}
    \renewcommand\item[2]{%
		{\Large\bf ##1}\\[2pt]
		{\color[HTML]{666666}\it (##2)}
		\medskip\\
		\renewcommand\inskip{\bigskip}
    }
}
{\bigskip}


% |[
% \item{course}{year}
% ]|
\newenvironment{ta}{%
    \newcommand*\inskip{}%
    {\Large Teacher Assistant}%
    \vspace{2pt}%
    \renewcommand\item[2]{%
		\medskip%
		\hspace{8pt}{\large\bf ##1}\hfill{\color[HTML]{777777}{\sf(##2)}}%
    	\vspace{2pt}%
		\renewcommand\inskip{\bigskip}%
	}%
}
%\bigskip

% |[
% \item{date range}{conference}{subject}
% ]|
\newenvironment{presenter}{%
    \newcommand*\inskip{}%
    {\Large Presenter}%
    \vspace{4pt}%
    \renewcommand\item[3]{%
    	\hspace{5pt}{\sf\color[HTML]{777777}##2\hfill (##1)\\[3pt]}%
    	\hspace{4pt}{\large\bf ##3}%
		\vspace{9pt}%
		\renewcommand\inskip{\bigskip}%
    }%
}
{\bigskip}
    
    
% |[
% \item{subject}{specialized_topic}
% ]|
\newenvironment{research_interest}{%
    \newcommand*\inskip{}
    \renewcommand\item[2]{%
		\inskip%
		{\Large\bf ##1}
		\ifstrempty{##2}{}{\\*[0.3pt] {\it ({##2}) } }
		\renewcommand\inskip{\bigskip}
    }
}


% |[
% \item{fact}{description}
% ]|
\newenvironment{factlist}{%
    \newdimen\unbaseline
    \unbaseline=\dimexpr-\baselinestretch\baselineskip\relax
    \renewcommand\item[2]{%
		\textsc{##1} & {\raggedright ##2\medskip\\}\\[\unbaseline]
    }
    \tabularx{\linewidth}{rX}
}
{\endtabularx}









%%
%% End of file `tccv.cls'.
