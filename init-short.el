;;------------------------------------------------
;; basic
;;------------------------------------------------
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
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

;;------------------------------------------------
;; keybindings
;;------------------------------------------------
(global-set-key (kbd "C-c edf")
		(lambda ()
		  (interactive)
		  (find-file (expand-file-name "init.el" user-emacs-directory))))

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
  :bind (("C-s" . 'swiper)))

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
  (evil-mode 1)
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
	 ("C-x b" . 'helm-buffers-list))
  :config
  (use-package helm-gtags
    :init
    (setenv "GTAGSLIBPATH" "/usr/include")
    :ensure t
    :bind (("C-]" . 'helm-gtags-dwim)
	   ("C-o" . 'helm-gtags-pop-stack)
	   ("C-<f12>" . 'helm-gtags-parse-file))
    :hook ((c-mode . helm-gtags-mode)
	   (c-mode . linum-mode)))
  (use-package helm-projectile
    :ensure t
    :bind (("C-c ss" . 'helm-projectile-ag)
	   ("C-c ff" . 'helm-projectile-find-file))))

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

(add-hook 'prog-mode-hook 'linum-mode)

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

(add-hook 'c-mode-common-hook
	  (lambda ()
	    (setq c-default-style "linux"
		  c-basic-offset 2)
	    (c-set-offset 'arglist-close 0)))

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
  (diminish 'abbrev-mode))

(use-package dracula-theme
  :ensure t
  :config
  (load-theme 'dracula t))

(use-package translate
  :bind ("C-c C-t" . jocoo/translate-word-or-region))