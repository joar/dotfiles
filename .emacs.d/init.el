(require 'package)

(global-auto-revert-mode 1)

(add-hook 'after-init-hook
   (lambda ()
     (progn
       (load-theme 'solarized-light t)
       )))

;; Installed packages
(defvar package-lisxt
  '(graphviz-dot-mode
    request-deferred
    org-pomodoro ;; https://github.com/lolownia/org-pomodoro
    focus-autosave-mode
    ob-ipython
    solarized-theme
    smooth-scrolling)
  "A list of packages to ensure are installed at launch.")

;; Package archives
(add-to-list 'package-archives
	     '("melpa-stable" . "http://melpa-stable.milkbox.net/packages/") t)
(add-to-list 'package-archives
	     '("melpa" . "http://melpa.milkbox.net/packages/") t)

(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

;; (dolist (pkg package-list)
;;  (unless (package-installed-p pkg)
;;    (package-install pkg)))


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

;; File where customize-* stores settings
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)


;; org-mode
;; -----------------------------------------------------------------------

;; Show babel-generated inline images automatically
(add-hook 'org-babel-after-execute-hook 'bh/display-inline-images 'append)

(defun bh/display-inline-images ()
  (condition-case nil
      (org-display-inline-images)
    (error nil)))

(require 'org)

(add-hook 'org-mode-hook
	  (lambda ()
	    (define-key (current-local-map) (kbd "C-c l") 'org-store-link)
	    (define-key global-map (kbd "C-c c") 'org-capture)))

(add-to-list 'org-src-lang-modes '("ipython" . python))

(customize-set-variable 'org-agenda-files (list "~/Dropbox/Documents/org/5m/clock/clock.org"))
(customize-set-variable 'python-shell-interpreter "python3")

(setq org-capture-templates
      '(("j" "Journal entry" item (file+datetree "~/Dropbox/Documents/org/5m/journal/journal.org")
	 "* %a \n %i%U: %?")))

(define-key global-map (kbd "C-c a") 'org-agenda)

(add-to-list 'exec-path "~/.local/bin")

;; Automaticall save changed buffers when li
(add-hook 'focus-out-hook (lambda () (save-some-buffers t nil)))

(org-babel-do-load-languages
 'org-babel-load-languages
 '((ipython . t)
   (sh . t)
   ;; other languages..
   ))


;; Mouse scrolling
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1) ((control) . nil)))
(setq mouse-wheel-progressive-speed nil)

;; Smooth scrolling
(require 'smooth-scrolling)
(smooth-scrolling-mode 1)
