;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "John Doe"
      user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "Iosevka" :size 18))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-dracula)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type nil)

(defun custom/unset-company-maps (&rest unused)
  "Set default mappings (outside of company).
    Arguments (UNUSED) are ignored."
  (general-def
    :states 'insert
    :keymaps 'override
    "<down>" nil
    "<up>"   nil
    "RET"    nil
    [return] nil
    "C-n"    nil
    "C-p"    nil
    "C-j"    nil
    "C-k"    nil
    "C-h"    nil
    "C-u"    nil
    "C-d"    nil
    "C-s"    nil
    "C-S-s"   (cond ((featurep! :completion helm) nil)
                    ((featurep! :completion ivy)  nil))
    "C-SPC"   nil
    "TAB"     nil
    [tab]     nil
    [backtab] nil))

(defun custom/set-company-maps (&rest unused)
  "Set maps for when you're inside company completion.
    Arguments (UNUSED) are ignored."
  (general-def
    :states 'insert
    :keymaps 'override
    "<down>" #'company-select-next
    "<up>" #'company-select-previous
    "RET" #'company-complete
    [return] #'company-complete
    "C-w"     nil  ; don't interfere with `evil-delete-backward-word'
    "C-n"     #'company-select-next
    "C-p"     #'company-select-previous
    "C-j"     #'company-select-next
    "C-k"     #'company-select-previous
    "C-h"     #'company-show-doc-buffer
    "C-u"     #'company-previous-page
    "C-d"     #'company-next-page
    "C-s"     #'company-filter-candidates
    "C-S-s"   (cond ((featurep! :completion helm) #'helm-company)
                    ((featurep! :completion ivy)  #'counsel-company))
    "C-SPC"   #'company-complete-common
    "TAB"     #'company-complete-common-or-cycle
    [tab]     #'company-complete-common-or-cycle
    [backtab] #'company-select-previous    ))

(after! cider
  (setq cider-repl-pop-to-buffer-on-connect nil)
  (set-popup-rule! "^\\*cider*" :size 0.45 :side 'right :ttl t :select t :quit t)
  (add-hook 'company-completion-started-hook 'custom/set-company-maps)
  (add-hook 'company-completion-finished-hook 'custom/unset-company-maps)
  (add-hook 'company-completion-cancelled-hook 'custom/unset-company-maps)
  (advice-remove 'cider-eval-last-sexp 'evil-collection-cider-last-sexp)
  (advice-remove 'cider-eval-last-sexp-and-replace 'evil-collection-cider-last-sexp)
  (advice-remove 'cider-eval-last-sexp-to-repl 'evil-collection-cider-last-sexp))

(defun try-convert (out)
  (shell-command-on-region
   (region-beginning) (region-end)
   (format "convert.clj %s " out)
   nil "REPLACE" nil t))

(defun convert-to-edn  () (interactive) (try-convert "edn"))
(defun convert-to-json () (interactive) (try-convert "json"))
(defun convert-to-yaml () (interactive) (try-convert "yaml"))

(map!
 (:leader
   (:map (clojure-mode-map clojurescript-mode-map)
     "(" #'paredit-backward-up
     ")" #'paredit-forward-up
     (:prefix ("a" . "apply")
       "y" #'convert-to-yaml
       "j" #'convert-to-json
       "e" #'convert-to-edn
       "n" #'neotree-toggle
       "u" #'clojure-unwind-all
       "l" #'clojure-thread-last-all
       "f" #'clojure-thread-first-all)
     (:prefix ("w" . "window")
       "<right>" #'evil-window-right
       "<up>"    #'evil-window-up
       "<down>"  #'evil-window-down
       "<left>"  #'evil-window-left)
     (:prefix ("y" . "paredit")
       "j" #'paredit-join-sexps
       "c" #'paredit-split-sexp
       "s" #'paredit-splice-sexp
       "d" #'paredit-kill
       "<" #'paredit-backward-slurp-sexp
       ">" #'paredit-backward-barf-sexp
       "." #'paredit-forward-slurp-sexp
       "," #'paredit-forward-barf-sexp
       "r" #'paredit-raise-sexp
       "w" #'paredit-wrap-sexp
       "[" #'paredit-wrap-square
       "'" #'paredit-meta-doublequote
       "{" #'paredit-wrap-curly)
     (:prefix ("e" . "eval")
       "p" #'cider-pprint-eval-last-sexp-to-repl
       "b" #'cider-eval-buffer
       "f" #'cider-eval-defun-at-point
       "y" #'cider-eval-sexp-at-point
       "F" #'cider-insert-defun-in-repl
       "e" #'cider-eval-last-sexp
       "E" #'cider-insert-last-sexp-in-repl
       "r" #'cider-eval-region
       "R" #'cider-insert-region-in-repl
       "u" #'cider-undef
       ";" #'cider-pprint-eval-last-sexp-to-comment))))

(add-to-list 'initial-frame-alist '(fullscreen . maximized))
(add-to-list 'default-frame-alist '(fullscreen . fullheight))

(setq cider-repl-pop-to-buffer-on-connect nil)

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.
