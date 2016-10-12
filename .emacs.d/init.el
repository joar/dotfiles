(require 'package)

(global-auto-revert-mode 1)

;; Installed packages
(defvar package-list
  '(graphviz-dot-mode
    request-deferred
    org-pomodoro ;; https://github.com/lolownia/org-pomodoro
    solarized-theme)
  "A list of packages to ensure are installed at launch.")

;; Package archives
(add-to-list 'package-archives
	     '("melpa-stable" . "http://melpa-stable.milkbox.net/packages/") t)
(add-to-list 'package-archives
	     '("melpa" . "http://melpa.milkbox.net/packages/") t)

(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))


;; org-trello
;; from http://stackoverflow.com/a/13946304/202522
(defvar auto-minor-mode-alist ()
  "Alist of filename patterns vs correpsonding minor mode functions, see `auto-mode-alist'
All elements of this alist are checked, meaning you can enable multiple minor modes for the same regexp.")

(add-to-list 'auto-minor-mode-alist
      '("\\.trello.org$" . org-trello-mode))

(defun enable-minor-mode-based-on-extension ()
  "check file name against auto-minor-mode-alist to enable minor modes
the checking happens for all pairs in auto-minor-mode-alist"
  (when buffer-file-name
    (let ((name buffer-file-name)
          (remote-id (file-remote-p buffer-file-name))
          (alist auto-minor-mode-alist))
      ;; Remove backup-suffixes from file name.
      (setq name (file-name-sans-versions name))
      ;; Remove remote file name identification.
      (when (and (stringp remote-id)
                 (string-match-p (regexp-quote remote-id) name))
        (setq name (substring name (match-end 0))))
      (while (and alist (caar alist) (cdar alist))
        (if (string-match (caar alist) name)
            (funcall (cdar alist) 1))
        (setq alist (cdr alist))))))

(add-hook 'find-file-hook 'enable-minor-mode-based-on-extension)

;; Initialize evil-mode
;; (evil-mode 1)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (solarized-light)))
 '(custom-safe-themes
   (quote
    ("d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" default)))
 '(inhibit-startup-screen t)
 '(org-babel-load-languages (quote ((emacs-lisp . t) (dot . t))))
 '(org-confirm-babel-evaluate nil)
 '(org-export-headline-levels 6)
 '(org-latex-classes
   (quote
    (("org-article" "
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

\\usemintedstyle{solarizedlight}

% Disabled: Replaced by [minted] arg to org-article.cls
%\\usepackage{minted}
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
      ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))))
 '(org-latex-default-class "org-article")
 '(org-latex-with-hyperref nil)
 '(org-latex-listings (quote minted))
 '(org-latex-minted-options
(quote
 (("breaklines" "true")
  ("linenos" "")
  ("frame" "lines"))))
'(org-latex-pdf-process
(quote
 ("latexmk -xelatex -interaction=nonstopmode -shell-escape -output-directory=%o %f")))
 '(org-src-fontify-natively t)
'(org-src-lang-modes
(quote
 (("ocaml" . tuareg)
  ("elisp" . emacs-lisp)
  ("ditaa" . artist)
  ("asymptote" . asy)
  ("dot" . graphviz-dot)
  ("sqlite" . sql)
  ("calc" . fundamental)
  ("C" . c)
  ("cpp" . c++)
  ("C++" . c++)
  ("screen" . shell-script))))
 '(org-startup-with-inline-images t)
 '(solarized-use-variable-pitch nil)
 '(tool-bar-mode nil))

(add-hook 'org-babel-after-execute-hook 'bh/display-inline-images 'append)

(defun bh/display-inline-images ()
  (condition-case nil
      (org-display-inline-images)
    (error nil)))

(add-hook 'org-mode-hook
	  (lambda ()
	    (define-key (current-local-map) (kbd "C-c l") 'org-store-link)))


(add-hook 'after-init-hook
	  (lambda ()
	    (progn
	      (load-theme 'solarized-light t)
	      )))


(load "graphviz-dot-mode")



(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Inconsolata" :foundry "unknown" :slant normal :weight normal :height 120 :width normal)))))
