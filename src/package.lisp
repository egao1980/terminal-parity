(defpackage #:terminal-parity
  (:use #:cl)
  (:local-nicknames (#:tp #:terminal-protocol))
  (:export #:decode-input
           #:encode-octets
           #:canonical-snapshot
           #:*parity-modes*
           #:load-inputs
           #:load-expected
           #:corpus
           #:fixture-name
           #:fixture-features
           #:fixture-applicable-p
           #:run-fixture
           #:check-fixture
           #:parity-mismatch
           #:parity-mismatch-fixture
           #:parity-mismatch-expected
           #:parity-mismatch-actual
           #:corpus-pathname))
