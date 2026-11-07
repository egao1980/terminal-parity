(in-package #:terminal-parity/tests)

;;; The oracle must reproduce its own corpus: this catches a libghostty-vt
;;; upgrade that changes behaviour, and a stale expected.sexp.
(terminal-parity/rove:define-parity-tests ghostty
  (make-instance 'terminal-backend-ghostty:ghostty-backend))
