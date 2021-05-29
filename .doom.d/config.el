;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-
;; Place your private configuration here! Remember, you do not need to run 'doom ;; sync' after modifying this file!
(require 'rec-mode)
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Andrea Esposito"
      user-mail-address "esposito_andrea99@hotmail.com")
(setq gnutls-min-prime-bits 512)

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
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;; (setq doom-theme 'doom-one)
;; This instead acivates the dracula theme.
(setq doom-theme 'doom-dracula)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Dropbox/org")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; Set the output theme of HTML code to CSS, thus making it dependent on the
;; actual stylesheet used.
(setq org-html-htmlize-output-type 'css)


;; Here are some additional functions/macros that could help you configure Doom:
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
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
(require 'ox-pandoc)
(require 'org-ref)

(display-battery-mode t)
(setq display-time-string-forms '(year "." month "." day " " 24-hours ":" minutes))
(display-time)

(with-eval-after-load 'ox-latex
  (setq org-latex-pdf-process (list "latexmk -shell-escape -bibtex -f -pdf %f"))
  (add-to-list 'org-latex-classes
               '("notes"
                 "\\documentclass{mynotes}
\\usepackage[utf8]{inputenc}
[NO-DEFAULT-PACKAGES]"
                 ("\\chapter{%s}" . "\\chapter*{%s}")
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                 ("\\paragraph{%s}" . "\\paragraph*{%s}")
                 ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))
  (add-to-list 'org-latex-classes
               '("lncs"
                 "\\documentclass{llncs}
\\usepackage[utf8]{inputenc}
\\usepackage{graphicx}
\\usepackage{hyperref}
[NO-DEFAULT-PACKAGES]"
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                 ("\\paragraph{%s}" . "\\paragraph*{%s}")
                 ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))
  (add-to-list 'org-latex-classes
               '("cvpr"
                 "\\documentclass[10pt,twocolumn,letterpaper]{article}
\\usepackage{cvpr}
\\usepackage{times}
\\usepackage{epsfig}
\\usepackage{graphicx}
\\usepackage{amsmath}
\\usepackage{amssymb}
[NO-DEFAULT-PACKAGES]
\\usepackage[pagebackref=true,breaklinks=true,colorlinks,bookmarks=false]{hyperref}
"
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                 ("\\paragraph{%s}" . "\\paragraph*{%s}")
                 ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))))

(remove-hook! 'mu4e-compose-pre-hook #'org-msg-mode)
;; (add-hook! 'mu4e-compose-mode-hook #'message-mode)
(setq mm-sign-option 'guided)
(setq mu4e-sent-messages-behavior (lambda ()
                                    (if (string= (message-sendmail-envelope-from) "a.esposito39@studenti.uniba.it")
                                        'delete 'sent)))
(add-hook! 'mu4e-compose-mode-hook #'turn-on-auto-fill)

(setq mu4e-headers-date-format "%+4Y-%m-%d")
(setq mu4e-view-html-plaintext-ratio-heuristic most-positive-fixnum)
(setq mu4e-context-policy 'always-ask)
(add-hook 'mu4e-compose-mode-hook 'flyspell-mode)
(setq mu4e-maildir-shortcuts '(("/studentiuniba/Inbox" . ?s)
                               ("/uniba/Inbox" . ?u)
                               ("/hotmail/Inbox" . ?h)))
(set-email-account! "Hotmail"
  '((mu4e-sent-folder       . "/hotmail/Sent")
    (mu4e-drafts-folder     . "/hotmail/Drafts")
    (mu4e-trash-folder      . "/hotmail/Deleted")
    (mu4e-refile-folder     . "/hotmail/Archive")
    (mu4e-get-mail-command  . "mbsync -a")
    (mu4e-update-interval   . 60)
    (smtpmail-smtp-user     . "esposito_andrea99@hotmail.com")
    (user-mail-address      . "esposito_andrea99@hotmail.com")    ;; only needed for mu < 1.4
    (smtpmail-stream-type   . starttls)
    (smtpmail-smtp-server . "smtp.office365.com")
    (smtpmail-smtp-service . 587)
    (mu4e-compose-signature . (concat "Andrea Esposito\n"
                                      "Master’s student in Computer Science\n"
                                      "\n"
                                      "University of Bari “Aldo Moro”\n"
                                      "Department of Computer Science\n"
                                      "Degree Course in Computer Science\n"
                                      "\n"
                                      "Student ID: 735116\n"
                                      "ORCID: 0000-0002-9536-3087\n"
                                      "Personal Home Page: https://espositoandrea.github.io/")))
  t)
(set-email-account! "UniBa"
  '((mu4e-sent-folder       . "/uniba/Sent")
    (mu4e-drafts-folder     . "/uniba/Drafts")
    (mu4e-trash-folder      . "/uniba/Trash")
    (mu4e-refile-folder     . "/uniba/Archive")
    (mu4e-get-mail-command  . "mbsync -a")
    (mu4e-update-interval   . 60)
    (smtpmail-smtp-user     . "andrea.esposito@uniba.it")
    (user-mail-address      . "andrea.esposito@uniba.it")    ;; only needed for mu < 1.4
    (smtpmail-stream-type   . starttls)
    (smtpmail-smtp-server . "smtp.uniba.it")
    (smtpmail-smtp-service . 587)
    (mu4e-compose-signature . (concat "Andrea Esposito\n"
                                      "Master’s student in Computer Science\n"
                                      "\n"
                                      "University of Bari “Aldo Moro”\n"
                                      "Department of Computer Science\n"
                                      "Degree Course in Computer Science\n"
                                      "\n"
                                      "Student ID: 735116\n"
                                      "ORCID: 0000-0002-9536-3087\n"
                                      "Personal Home Page: https://espositoandrea.github.io/")))
  t)
(set-email-account! "Studenti UniBa"
  '((mu4e-trash-folder      . "/studentiuniba/[Gmail]/Cestino")
    (mu4e-refile-folder     . "/studentiuniba/[Gmail]/Archivio")
    (mu4e-drafts-folder     . "/studentiuniba/[Gmail]/Bozze")
    (mu4e-sent-folder       . "/studentiuniba/[Gmail]/Posta inviata")
    (mu4e-get-mail-command  . "mbsync -a")
    (mu4e-update-interval   . 60)
    (smtpmail-smtp-user     . "a.esposito39@studenti.uniba.it")
    (user-mail-address      . "a.esposito39@studenti.uniba.it")    ;; only needed for mu < 1.4
    (smtpmail-stream-type   . starttls)
    (smtpmail-smtp-server . "smtp.gmail.com")
    (smtpmail-smtp-service . 587)
    (mu4e-compose-signature . (concat "Andrea Esposito\n"
                                      "Master’s student in Computer Science\n"
                                      "\n"
                                      "University of Bari “Aldo Moro”\n"
                                      "Department of Computer Science\n"
                                      "Degree Course in Computer Science\n"
                                      "\n"
                                      "Student ID: 735116\n"
                                      "ORCID: 0000-0002-9536-3087\n"
                                      "Personal Home Page: https://espositoandrea.github.io/")))
  t)

;; Telegram

(defun my-telega-chat-mode ()
  (set (make-local-variable 'company-backends)
       (append (list 'telega-company-emoji
                   'telega-company-username
                   'telega-company-botcmd
                   'telega-company-hashtag)
             (when (telega-chat-bot-p telega-chatbuf--chat)
               '(telega-company-botcmd))))
  (company-mode 1))

(add-hook 'telega-chat-mode-hook 'my-telega-chat-mode)

(setq telega-use-images t
      telega-emoji-font-family "Ubuntu")
(telega-notifications-mode 1)
(add-to-list 'evil-emacs-state-modes 'telega-chat-mode)
(add-hook 'telega-chat-mode-hook
  (lambda ()
   (local-set-key (kbd "C-c q") 'telega)))

(map! :leader :desc "Open Telegram client" "o t" #'telega)
(require 'company-posframe)
(company-posframe-mode 1)

(map! :leader :desc "Open Telegram client" "o t" #'telega)
