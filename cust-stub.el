;;; cust-stub.el --- defcustom stub for emacs versions without custom.el

;; Copyright (C) 1997, 1998 Noah S. Friedman

;; Author: Noah Friedman <friedman@splode.com>
;; Maintainer: friedman@splode.com
;; Keywords: extensions
;; Created: 1997-05-28

;; $Id: cust-stub.el,v 1.4 2001/08/31 11:28:54 friedman Exp $

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program; if not, you can either send email to this
;; program's maintainer or write to: The Free Software Foundation,
;; Inc.; 59 Temple Place, Suite 330; Boston, MA 02111-1307, USA.

;;; Commentary:

;; Emacs 19.34 and earlier, and XEmacs 19.14 and earlier, do not have the
;; `defcustom' or `defgroup' forms used for user option customization.
;; As of May 1997, many of my own programs use these forms, so I am
;; including a stub to provide backward-compatibility in earlier versions
;; of emacs.

;;; Code:

(or (featurep 'custom)   (load "custom" t))
(or (featurep 'cus-face) (load "cus-face" t))
(or (featurep 'cus-edit) (load "cus-edit" t))

(defvar cust-stub-keywords
  '(:action :activate :active :append-button-args :args :button
            :button-args :tag-glyph :button-face :button-face-get
            :button-overlay :button-prefix :button-suffix :buttons
            :case-fold :create :children :choice :complete
            :complete-function :convert-widget :delete :delete-at
            :delete-button-args :directory :doc :documentation-indent
            :documentation-property :documentation-shown :entry-format
            :entry-from :entry-to :error :extra-offset :field-overlay
            :format :format-handler :from :get :glyph-down :glyph-inactive
            :glyph-up :greedy :group :doc-overlay :help-echo :inactive
            :indent :initialize :inline :insert-before :insert-button-args
            :keymap :link :load :match :match-alternatives :match-inline
            :menu-tag :menu-tag-get :mouse-down-action :must-match :notify
            :off :off-glyph :off-type :offset :on :on-glyph :on-type
            :options :parent :prefix :prompt-history :prompt-internal
            :prompt-match :prompt-value :deactivate :require :sample-face
            :sample-face-get :sample-overlay :secret :set :sibling-args
            :size :tab-order :tag :tag :to :type :type-error :valid-regexp
            :validate :value :value-create :value-delete :value-face
            :value-get :value-inline :value-pos :value-set
            :value-to-external :value-to-internal :void :widget
            ))



(defmacro cust-stub:public:defcustom (var value doc &rest args)
  (list 'defvar var value doc))

(defmacro cust-stub:public:custom-declare-variable (var value doc &rest args)
  (list 'defvar (eval var) value doc))

(defmacro cust-stub:public:defface (face spec doc &rest args)
  (append (list 'custom-declare-face (list 'quote face) spec doc) args))

;; This is woefully inadequate.
(defun cust-stub:public:custom-declare-face (face spec doc &rest args)
  (make-face face))

(defmacro cust-stub:public:defgroup (&rest args))

;; These are woefully inadequate.
(defun cust-stub:public:custom-declare-face (&rest args) nil)
(defun cust-stub:public:customize-menu-create (&rest args) nil)



(defun cust-stub-make-keywords (&rest syms)
  (while syms
    (set (car syms) (car syms))
    (setq syms (cdr syms))))

(defun cust-stub-install ()
  "Alias cust-stub:public functions if standard custom functions undefined."
  (interactive)
  (apply 'cust-stub-make-keywords cust-stub-keywords)
  (let* ((prefix "cust-stub:public:")
         (len (length prefix))
         (syms (all-completions prefix obarray 'fboundp))
         tem)
    (while syms
      (setq tem (substring (car syms) len))
      (cond ((and (intern-soft tem)
                  (fboundp (intern-soft tem))))
            (t
             (defalias (intern tem) (intern (car syms)))))
      (setq syms (cdr syms)))))



(or (fboundp 'defalias)
    (fset 'defalias 'fset))

(cust-stub-install)
(provide 'cust-stub)

;;; cust-stub.el ends here
