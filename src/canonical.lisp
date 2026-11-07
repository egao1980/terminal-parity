(in-package #:terminal-parity)

;;; Canonical snapshot: a readable, EQUAL-comparable plist built only from
;;; protocol calls. Default cells are left out, so a corpus entry lists only
;;; what a sequence changed.

(defparameter *parity-modes*
  '(:insert :cursor-keys :origin :wraparound :cursor-visible :keypad-keys
    :mouse-event-x10 :mouse-event-normal :mouse-event-button :mouse-event-any
    :focus-event :mouse-format-sgr :alt-screen-save-cursor-clear :bracketed-paste)
  "Modes whose values every snapshot records.")

(defun %color (c)
  (if (tp:rgb-p c) (list (tp:rgb-r c) (tp:rgb-g c) (tp:rgb-b c)) c))

(defun %style-diff (style)
  "Non-default slots of STYLE as a plist, in a fixed order."
  (let ((d tp:+default-style+) (out '()))
    (flet ((add (key value default)
             (unless (equalp value default)
               (push key out) (push value out))))
      (add :fg (%color (tp:style-foreground style)) :default)
      (add :bg (%color (tp:style-background style)) :default)
      (add :ul-color (%color (tp:style-underline-color style)) :default)
      (add :bold (tp:style-bold style) nil)
      (add :faint (tp:style-faint style) nil)
      (add :italic (tp:style-italic style) nil)
      (add :blink (tp:style-blink style) nil)
      (add :inverse (tp:style-inverse style) nil)
      (add :invisible (tp:style-invisible style) nil)
      (add :strike (tp:style-strikethrough style) nil)
      (add :overline (tp:style-overline style) nil)
      (add :underline (tp:style-underline style) nil)
      (add :link (tp:style-hyperlink style) (tp:style-hyperlink d)))
    (nreverse out)))

(defun canonical-snapshot (terminal)
  "→ (:LINES … :CURSOR (x y visible-p) :TITLE … :PWD … :SCREEN …
      :MODES (set-mode …) :CELLS ((x y text width style-diff) …))"
  (let* ((snap (tp:terminal-snapshot terminal))
         (cursor (getf snap :cursor))
         (cells '()))
    (loop for row across (getf snap :cells)
          for y from 0
          do (loop for cell across row
                   for x from 0
                   for diff = (%style-diff (tp:cell-style cell))
                   when (or diff (not (eq (tp:cell-width cell) :narrow)))
                     do (push (list x y (tp:cell-text cell) (tp:cell-width cell) diff)
                              cells)))
    (list :lines (getf snap :lines)
          :cursor (when cursor
                    (list (tp:cursor-x cursor) (tp:cursor-y cursor)
                          (tp:cursor-visible-p cursor)))
          :title (getf snap :title)
          :pwd (getf snap :pwd)
          :screen (getf snap :screen)
          :modes (remove-if-not (lambda (m) (tp:terminal-mode terminal m)) *parity-modes*)
          :cells (nreverse cells))))
