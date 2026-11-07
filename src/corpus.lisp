(in-package #:terminal-parity)

;;; corpus/inputs.sexp    hand-written fixtures (what to do)
;;; corpus/expected.sexp  generated from inputs by the ghostty oracle
;;;
;;; An input fixture:
;;;   (:name "sgr-bold" :cols 10 :rows 3 :features (:alternate-screen)
;;;    :feed "{csi}1mB"
;;;    :then ((:key :arrow-up :modifiers (:ctrl)) (:mouse :left :press 1 2)
;;;           (:focus t) (:paste "x") (:feed "…") (:resize 20 4)))
;;; An expected fixture adds :replies (notation), :encoded (one notation
;;; string per encoding step) and :expect (CANONICAL-SNAPSHOT).

(defun corpus-pathname (name)
  (asdf:system-relative-pathname "terminal-parity" (format nil "corpus/~A" name)))

(defun %read-all (pathname)
  (with-open-file (in pathname :external-format :utf-8)
    (with-standard-io-syntax
      (let ((*read-eval* nil)
            (*package* (find-package '#:cl-user)))
        (loop for form = (read in nil in)
              until (eq form in)
              collect form)))))

(defun load-inputs () (%read-all (corpus-pathname "inputs.sexp")))
(defun load-expected () (%read-all (corpus-pathname "expected.sexp")))

(defun corpus ()
  "The expected fixtures. Signals if the file is missing."
  (load-expected))

(defun fixture-name (fixture) (getf fixture :name))
(defun fixture-features (fixture) (getf fixture :features))

(defun fixture-applicable-p (fixture backend)
  (every (lambda (f) (tp:backend-supports-p backend f)) (fixture-features fixture)))
