
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Inconsolata" :foundry "unknown" :slant normal :weight normal :height 120 :width normal)))))


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(solarized-light))
 '(custom-safe-themes
   '("4c56af497ddf0e30f65a7232a8ee21b3d62a8c332c6b268c81e9ea99b11da0d3" "d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" default))
 '(inhibit-startup-screen t)
 '(org-agenda-files '("~/Dropbox/Documents/org/5m/clock/clock.org"))
 '(org-babel-load-languages '((emacs-lisp . t) (dot . t) (shell . t) (python . t)))
 '(org-confirm-babel-evaluate nil)
 '(org-export-headline-levels 6)
 '(org-file-apps
   '((auto-mode . emacs)
     ("\\.mm\\'" . default)
     ("\\.x?html?\\'" . default)
     ("\\.pdf\\'" . system)))
 '(org-latex-classes
   '(("org-article" "
\\documentclass[a4paper,
                koma,
                utopia,
                DIV=15,
                BCOR=15mm,
                listings-sv,
                minted,
                titlepage=false,
                % Pass options to hyperref
                colorlinks=true,  % false = boxed links; true = colored links
                linkcolor=black,  % Internal links
                urlcolor=black    % External links
                ]{org-article}

% Disabled: Replaced by [minted] arg to org-article.cls
%\\usepackage{minted}
\\usemintedstyle{solarizedlight}

%\\newminted{common-lisp}{fontsize=10}

% Allow symbols
\\usepackage[T1]{fontenc}

% Set fonts
%\\usepackage{fontspec}

% Disabled: Replaced by [utopia] arg to org-article.cls
%\\setromanfont{Gentium Basic Bold}
%\\setromanfont[BoldFont={Gentium Basic Bold},
%                ItalicFont={Gentium Basic Italic}]{Gentium Basic}
%\\setsansfont{Charis SIL}
%\\setmonofont{Inconsolata}

% Fix minted lineno size
\\renewcommand{\\theFancyVerbLine}{\\sffamily
    \\textcolor[rgb]{0,0,0}{\\scriptsize
        \\oldstylenums{\\arabic{FancyVerbLine}}
    }
}

% Disabled: Set ToC fonts
%\\usepackage{tocloft}
%\\renewcommand*{\\cftsecfont}{\\sffamily\\bfseries}
%\\renewcommand*{\\cftsecpagefont}{\\sffamily\\bfseries}
%\\renewcommand*{\\cftsubsecfont}{\\tocmainfont}
%\\renewcommand*{\\cftsubsecpagefont}{\\tocmainfont}

% http://tex.stackexchange.com/a/136000/23121
%\\setuptoc{toc}{leveldown}

% NO-DEFAULT-PACKAGES
[NO-DEFAULT-PACKAGES]
% PACKAGES
[PACKAGES]
% EXTRA
[EXTRA]
% END"
      ("\\section{%s}" . "\\section*{%s}")
      ("\\subsection{%s}" . "\\subsection*{%s}")
      ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
      ("\\paragraph{%s}" . "\\paragraph*{%s}")
      ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))))
 '(org-latex-default-class "org-article")
 '(org-latex-default-packages-alist
   '(("AUTO" "inputenc" t
      ("pdflatex"))
     ("T1" "fontenc" t
      ("pdflatex"))
     ("" "graphicx" t nil)
     ("" "longtable" nil nil)
     ("" "wrapfig" nil nil)
     ("" "rotating" nil nil)
     ("normalem" "ulem" t nil)
     ("" "amsmath" t nil)
     ("" "amssymb" t nil)
     ("" "capt-of" nil nil)
     ("" "hyperref" nil nil)
     ("" "minted" nil nil)))
 '(org-latex-hyperref-template nil)
 '(org-latex-listings 'minted)
 '(org-latex-minted-options
   '(("breaklines" "true")
     ("linenos" "false")
     ("frame" "lines")))
 '(org-latex-pdf-process
   '("latexmk -f -gg -xelatex -interaction=nonstopmode -shell-escape -output-directory=%o %f"))
 '(org-src-fontify-natively t)
 '(org-src-lang-modes
   '(("ocaml" . tuareg)
     ("elisp" . emacs-lisp)
     ("ditaa" . artist)
     ("asymptote" . asy)
     ("dot" . graphviz-dot)
     ("sqlite" . sql)
     ("calc" . fundamental)
     ("C" . c)
     ("cpp" . c++)
     ("C++" . c++)
     ("screen" . shell-script)
     ("bash" . shell-script)
     ("shell" . shell-script)))
 '(org-startup-with-inline-images t)
 '(package-selected-packages
   '(ox-gist orderless vertico marginalia consult flymake-shellcheck flycheck use-package ox-reveal gist smooth-scrolling solarized-theme request-deferred htmlize graphviz-dot-mode focus-autosave-mode))
 '(python-shell-interpreter "python3")
 '(solarized-use-variable-pitch nil)
 '(tool-bar-mode nil)
 '(visible-bell t))
