(require 'package)

;; Installed packages
(defvar package-list
  '(evil
    org-trello
    request-deferred
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
 '(org-export-headline-levels 6)
 '(org-latex-classes
   (quote
    (("org-article" "
\\documentclass[a4paper,
                koma,
                DIV=15,
                BCOR=15mm,
                listings-sv,
                tocdepths,tocdepthss,tocdepthsss]{org-article}

\\usepackage{minted}
\\usemintedstyle{solarizedlight}
%\\newminted{common-lisp}{fontsize=10}

% Set fonts
\\usepackage{fontspec}

\\setromanfont{Gentium}
\\setromanfont[BoldFont={Gentium Basic Bold},
                ItalicFont={Gentium Basic Italic}]{Gentium Basic}
\\setsansfont{Charis SIL}
\\setmonofont{Inconsolata}

% Fix minted lineno size
\\renewcommand{\\theFancyVerbLine}{\\sffamily
    \\textcolor[rgb]{0,0,0}{\\scriptsize
        \\oldstylenums{\\arabic{FancyVerbLine}}
    }
}

[NO-DEFAULT-PACKAGES]
[PACKAGES]
[EXTRA]"
      ("\\section{%s}" . "\\section*{%s}")
      ("\\subsection{%s}" . "\\subsection*{%s}")
      ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
      ("\\paragraph{%s}" . "\\paragraph*{%s}")
      ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))))
 '(org-latex-default-class "org-article")
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
 '(solarized-use-variable-pitch nil)
 '(tool-bar-mode nil))


(add-hook 'org-mode-hook
	  (lambda ()
	    (define-key (current-local-map) (kbd "C-c l") 'org-store-link)))


(add-hook 'after-init-hook
	  (lambda ()
	    (progn
	      (load-theme 'solarized-light t))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Inconsolata" :foundry "unknown" :slant normal :weight normal :height 120 :width normal)))))
