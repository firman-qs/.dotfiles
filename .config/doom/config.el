;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;; (setq doom-theme 'gruber-darker)
;; (setq doom-theme 'doom-miramare)
;; (setq doom-theme 'doom-sourcerer)
(setq doom-theme 'doom-gruvbox)
;; (setq doom-theme 'everforest-hard-dark)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

(setq doom-font (font-spec :family "Iosevka Nerd Font" :size 18)
      doom-variable-pitch-font (font-spec :family "Open Sans" :size 18)
      doom-symbol-font (font-spec :family "Iosevka Nerd Font" :size 18)
      doom-serif-font (font-spec :family "Latin Modern Roman" :size 18)
      doom-big-font (font-spec :family "Iosevka Nerd Font" :size 24))

(setq evil-insert-state-cursor '(box "yellow")
      evil-normal-state-cursor '(box "white"))

(setq display-line-numbers-type 'relative) ;; relative line numbering for chad

(global-auto-revert-mode t)  ;; Automatically show changes if the file has changed
(setq scroll-margin 5)
(global-visual-line-mode t)
(column-number-mode 1) ;; show column where the cursor at right now in the statusline.

(with-eval-after-load 'evil
  (define-key evil-motion-state-map (kbd "g C-a") 'evil-numbers/inc-at-pt-incremental)
  (define-key evil-motion-state-map (kbd "g C-x") 'evil-numbers/dec-at-pt-incremental))

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; (map! :lrader
;;       :desc "Switch to perspective NAME"       "p s" #'persp-switch
;;       :desc "Switch to buffer in perspective"  "p b" #'persp-switch-to-buffer
;;       :desc "Switch to next perspective"       "p n" #'persp-next
;;       :desc "Switch to previous perspective"   "p p" #'persp-prev
;;       :desc "Add a buffer current perspective" "p a" #'persp-add-buffer
;;       :desc "Remove perspective by name"       "p r" #'persp-remove-by-name)

(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq LaTeX-indent-level 4)
(setq tex-indent-basic 4)
(setq TeX-brace-indent-level 4)
(setq-default TeX-master nil)
(setq LaTeX-item-indent -2)
;; for compiling with latexmk
(add-hook 'LaTeX-mode-hook
          (lambda () (local-set-key (kbd "M-s") #'TeX-command-run-all)))

(setq delete-by-moving-to-trash t
      trash-directory "~/.local/share/Trash/files/")

(setq doom-modeline-height 23)
(setq doom-modeline-bar-width -1)
(setq doom-modeline-icon nil)
(setq doom-modeline-modal nil)
(setq doom-modeline-modal-icon nil)
(setq doom-modeline-buffer-file-name-style 'relative-from-project)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

(after! org
  (setq org-default-notes-file (expand-file-name "notes.org" org-directory)
        org-ellipsis " 󱞣 "
        org-superstar-headline-bullets-list '("◉" "●" "○" "◆" "●" "○" "◆")
        ;; org-superstar-headline-bullets-list '("✽" "✾" "❆" "❆" "❁" "❅" "✼")
        ;; org-superstar-headline-bullets-list '("◐" "◑" "◒" "◓" "⚈" "⚉" "⊗")
        org-superstar-itembullet-alist '((?+ . ?➤) (?- . ?✦)) ; changes +/- symbols in item lists
        ;; org-superstar-itembullet-alist '((?+ . ?➤) (?- . ?❍)) ; changes +/- symbols in item lists
        org-log-done 'time
        org-hide-emphasis-markers t))

(map! "M-j" #'drag-stuff-down
      "M-k" #'drag-stuff-up
      "M-l" #'drag-stuff-right
      "M-h" #'drag-stuff-left)

(add-to-list 'custom-theme-load-path "~/.dotfiles/.config/doom/themes/everforest")
