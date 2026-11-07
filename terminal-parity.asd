(defsystem "terminal-parity"
  :version "0.3.0"
  :description "Golden terminal-protocol corpus (libghostty-vt as oracle), replayed against any backend"
  :author "egao1980"
  :license "MIT"
  :depends-on ("terminal-protocol")
  :serial t
  :pathname "src"
  :components ((:file "package")
               (:file "notation")
               (:file "canonical")
               (:file "corpus")
               (:file "run"))
  :in-order-to ((test-op (test-op "terminal-parity/tests"))))

(defsystem "terminal-parity/rove"
  :description "DEFINE-PARITY-TESTS: one Rove test per corpus fixture"
  :depends-on ("terminal-parity" "rove")
  :pathname "src"
  :components ((:file "rove")))

(defsystem "terminal-parity/generate"
  :description "Regenerate corpus/expected.sexp from corpus/inputs.sexp with the ghostty oracle"
  :depends-on ("terminal-parity" "terminal-backend-ghostty")
  :pathname "src"
  :components ((:file "generate")))

(defsystem "terminal-parity/tests"
  :depends-on ("terminal-parity" "terminal-parity/rove" "terminal-backend-ghostty" "rove")
  :pathname "tests"
  :serial t
  :components ((:file "package")
               (:file "notation-test")
               (:file "oracle-test"))
  :perform (test-op (o c)
             (unless (symbol-call :rove :run c)
               (error "tests failed for ~A" (component-name c)))))
