(in-package #:terminal-parity)

(define-condition parity-mismatch (error)
  ((fixture :initarg :fixture :reader parity-mismatch-fixture)
   (part :initarg :part :reader parity-mismatch-part)
   (expected :initarg :expected :reader parity-mismatch-expected)
   (actual :initarg :actual :reader parity-mismatch-actual))
  (:report (lambda (c s)
             (format s "Parity mismatch in ~A (~A):~%  expected ~S~%  actual   ~S"
                     (fixture-name (parity-mismatch-fixture c))
                     (parity-mismatch-part c)
                     (parity-mismatch-expected c)
                     (parity-mismatch-actual c)))))

(defun %feed (terminal notation split)
  (let ((bytes (decode-input notation)))
    (if split
        (loop for b across bytes
              do (tp:terminal-feed terminal (make-array 1 :element-type '(unsigned-byte 8)
                                                          :initial-element b)))
        (tp:terminal-feed terminal bytes))))

(defun %step (terminal step split)
  "Run one :THEN step. → notation of the bytes an encoding step produced,
or NIL for a state step."
  (destructuring-bind (kind &rest args) step
    (ecase kind
      (:feed (%feed terminal (first args) split) nil)
      (:resize (tp:terminal-resize terminal (first args) (second args)) nil)
      (:key (encode-octets (apply #'tp:encode-key terminal args)))
      (:mouse (encode-octets (apply #'tp:encode-mouse terminal args)))
      (:focus (encode-octets (tp:encode-focus terminal (first args))))
      (:paste (encode-octets (tp:encode-paste terminal
                                              (map 'string #'code-char
                                                   (decode-input (first args)))))))))

(defun run-fixture (fixture backend &key split)
  "Replay FIXTURE's inputs on BACKEND. With SPLIT, every :FEED goes in one
byte at a time. → plist (:REPLIES … :ENCODED … :EXPECT …), the same shape
as an expected fixture."
  (tp:with-terminal (terminal :backend backend
                              :cols (getf fixture :cols 20)
                              :rows (getf fixture :rows 5))
    (let ((px (getf fixture :cell-pixels)))
      (when px
        (tp:terminal-resize terminal (getf fixture :cols 20) (getf fixture :rows 5)
                            :cell-width-px (first px) :cell-height-px (second px))))
    (when (getf fixture :feed)
      (%feed terminal (getf fixture :feed) split))
    (let ((encoded (loop for step in (getf fixture :then)
                         for out = (%step terminal step split)
                         when out collect out)))
      (list :replies (encode-octets (tp:terminal-take-replies terminal))
            :encoded encoded
            :expect (canonical-snapshot terminal)))))

(defun check-fixture (fixture backend)
  "Signal PARITY-MISMATCH unless BACKEND reproduces FIXTURE, both fed whole
and fed byte by byte. → T."
  (dolist (split '(nil t))
    (let ((actual (run-fixture fixture backend :split split)))
      (dolist (part '(:expect :replies :encoded))
        (unless (equal (getf actual part) (getf fixture part))
          (error 'parity-mismatch :fixture fixture
                                  :part (if split (list part :split) part)
                                  :expected (getf fixture part)
                                  :actual (getf actual part))))))
  t)
