(defpackage #:terminal-parity/rove
  (:use #:cl)
  (:export #:define-parity-tests))

(in-package #:terminal-parity/rove)

(defmacro define-parity-tests (name backend-form)
  "Define one Rove test per corpus fixture, NAME/<fixture-name>, replaying it
on the backend BACKEND-FORM evaluates to. Fixtures needing features the
backend lacks are skipped."
  `(progn
     ,@(loop for fixture in (terminal-parity:corpus)
             for test = (intern (format nil "~A/~:@(~A~)" name (terminal-parity:fixture-name fixture)))
             collect `(rove:deftest ,test
                        (let ((backend ,backend-form)
                              (fixture ',fixture))
                          (if (terminal-parity:fixture-applicable-p fixture backend)
                              (rove:ok (handler-case (terminal-parity:check-fixture fixture backend)
                                         (terminal-parity:parity-mismatch (c)
                                           (format *error-output* "~&~A~%" c)
                                           nil))
                                       ,(terminal-parity:fixture-name fixture))
                              (rove:skip (format nil "needs ~S"
                                                 (terminal-parity:fixture-features fixture)))))))))
