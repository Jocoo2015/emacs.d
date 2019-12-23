;;------------------------------------------------
;; basic
;;------------------------------------------------
(require 'package)
;; (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(setq package-archives '(("gnu"   . "http://elpa.emacs-china.org/gnu/")
                         ("melpa" . "http://elpa.emacs-china.org/melpa/")))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

(setq
 custom-file (expand-file-name "custom.el" user-emacs-directory)
 backup-directory-alist `((".*" . ,temporary-file-directory))
 auto-save-file-name-transforms `((".*" ,temporary-file-directory t))
 inhibit-startup-message t)

(when (file-exists-p custom-file)
  (load custom-file))

(show-paren-mode t)
(electric-pair-mode t)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(set-default-font "Fira Code-11")
(defalias 'yes-or-no-p 'y-or-n-p)

(load (concat user-emacs-directory "lisp/editing.el"))
;; (load (concat user-emacs-directory "lisp/whitespace-config.el"))

;;------------------------------------------------
;; keybindings
;;------------------------------------------------
(global-set-key (kbd "C-c edf")
                (lambda ()
                  (interactive)
                  (find-file user-init-file)))

(global-set-key (kbd "C-c .") 'ffap)

;;------------------------------------------------
;; packages
;;------------------------------------------------
(use-package magit
  :ensure t
  :bind (("C-x g" . 'magit-status)))

(use-package expand-region
  :ensure t
  :bind (("C-=" . er/expand-region)))

(use-package swiper
  :ensure t
  :bind (("C-s"   . 'isearch-forward)
	 ("C-c /" . 'swiper)
	 ("C-c *" . 'swiper-thing-at-point)))

(use-package company
  :ensure t
  :config
  (global-company-mode t))

(use-package yasnippet
  :ensure t
  :config
  (yas-global-mode t)
  (use-package yasnippet-snippets :ensure t))

(use-package iedit
  :ensure t)

(use-package evil
  :ensure t
  :config
  ;; (evil-mode 1)
  (define-key evil-motion-state-map (kbd "C-]") nil)
  (define-key evil-motion-state-map (kbd "C-o") nil))

(use-package projectile
  :ensure t
  :bind-keymap
  ("C-c p" . projectile-command-map))

(use-package helm
  :ensure t
  :bind (("M-x" . 'helm-M-x)
         ("C-x C-f" . 'helm-find-files)
         ("C-x b" . 'helm-buffers-list)
	 ("C-c C-r" . 'helm-recentf))
  :config
  (use-package helm-gtags
    :init
    (setenv "GTAGSLIBPATH" "/usr/include")
    :ensure t
    :bind (("C-]" . 'helm-gtags-dwim)
           ("C-o" . 'helm-gtags-pop-stack)
           ("C-<f12>" . 'helm-semantic-or-imenu))
    :hook (
           ;;(c-mode . helm-gtags-mode)
           (c-mode . linum-mode)))
  (use-package helm-etags-plus
    :ensure t
    :bind (("C-]" . 'helm-etags-plus-select)
           ("C-o" . 'helm-etags-plus-history-go-back)
           ("M-<left>" . 'helm-etags-plus-history-go-back)
           ("M-<right>" . 'helm-etags-plus-history-go-forward)))
  (use-package helm-projectile
    :ensure t
    :bind (("C-c ss" . 'helm-projectile-ag)
           ("C-c ff" . 'helm-projectile-find-file)
           ("C-c fof". 'helm-projectile-find-other-file))))

(use-package flycheck
  :ensure t)

(use-package kotlin-mode
  :ensure t)

(use-package org-bullets
  :init (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
  :ensure t)

(use-package which-key
  :ensure t
  :config
  (which-key-mode 1))

(add-hook 'prog-mode-hook
	  (lambda ()
	    (linum-mode t)
	    (eldoc-mode t)
	    (setq show-trailing-whitespace t)))

(use-package avy
  :ensure t
  :bind (("C-c jJ" . 'avy-goto-char)
         ("C-c jj" . 'avy-goto-char-2)
         ("C-c jb" . 'avy-pop-mark)
         ("C-c jl" . 'avy-goto-line)))

(use-package winum
  :init
  (windmove-default-keybindings)
  :ensure t
  :config
  (winum-mode)
  (winum-set-keymap-prefix (kbd "C-c")))

(use-package diminish
  :ensure t
  :config
  (diminish 'which-key-mode)
  (diminish 'undo-tree-mode)
  (diminish 'yas-minor-mode)
  (diminish 'company-mode)
  (diminish 'company-mode)
  (diminish 'auto-revert-mode)
  (diminish 'eldoc-mode)
  (diminish 'helm-gtags-mode)
  (diminish 'abbrev-mode)
  (diminish 'clang-format+-mode))

(use-package dracula-theme
  :ensure t
  :config
  (load-theme 'dracula t))

(use-package translate
  :bind ("C-c C-t" . jocoo/translate-word-or-region))

(use-package multiple-cursors
  :ensure t
  :bind (("C-S-c C-S-c" . 'mc/edit-lines)
         ("C->" . 'mc/mark-next-like-this)
         ("C-<" . 'mc/mark-previous-like-this)
         ("C-c C-<" . 'mc/mark-all-like-this)))

(use-package restclient
  :ensure t
  :mode ("\\.rest\\'" . restclient-mode))

(use-package recentf
  :ensure t
  :config
  (recentf-mode 1)
  (setq recentf-max-menu-items 30)
  (setq recentf-max-saved-items 200)
  :bind ("C-c C-r" . 'helm-recentf))

(use-package paredit
  :ensure t
  :hook ((emacs-lisp-mode lisp-interaction-mode clojure-mode) . paredit-mode))

;; format
(use-package clang-format+
  :ensure t)

(add-hook 'c-mode-common-hook
	  (lambda ()
	    (setq c-default-style "linux"
                  c-basic-offset 2)
	    (c-set-offset 'arglist-close 0)
	    (setq-local clang-format-style "Google")
	    (local-set-key (kbd "C-c \\") 'clang-format-buffer)
	    (clang-format+-mode 1)))

(use-package cider
  :ensure t
  :config
  (setq cider-repl-display-help-banner nil)
  (use-package clj-refactor
    :ensure t
    :config
    (cljr-add-keybindings-with-prefix "C-c C-m"))
  :hook (clojure-mode . clj-refactor-mode))

(add-hook 'clojure-mode-hook
	  (lambda ()
	    (local-set-key (kbd "C-c \\") 'cider-format-buffer)))

(use-package rtags
  :ensure t)

(use-package emacs-surround
  :bind ("C-q" . 'emacs-surround))

(use-package java-imports
  :ensure t
  :config
  (setq java-imports-find-block-function 'java-imports-find-place-sorted-block)
  (define-key java-mode-map (kbd "M-I") 'java-imports-add-import-dwim)
  (add-hook 'java-mode-hook 'java-imports-scan-file))
