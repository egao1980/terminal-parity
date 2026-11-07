(in-package #:terminal-parity/tests)

(deftest decode-escapes
  (ok (equalp (par:decode-input "a{esc}b") #(97 27 98)))
  (ok (equalp (par:decode-input "{csi}1m") #(27 91 49 109)))
  (ok (equalp (par:decode-input "{x9b}{{") #(#x9b 123)))
  (ok (equalp (par:decode-input "é") #(#xc3 #xa9)))
  (ok (signals (par:decode-input "{nope}") 'error)))

(deftest encode-round-trips
  (dolist (s '("plain" "{csi}?2004h" "{osc}2;x{bel}" "{x00}{xff}{{" "{esc}OA"))
    (ok (equalp (par:decode-input (par:encode-octets (par:decode-input s)))
                (par:decode-input s))
        s)))

(deftest corpus-loads
  (ok (plusp (length (par:load-inputs))))
  (ok (= (length (par:load-inputs)) (length (par:load-expected))))
  (ok (every #'stringp (mapcar #'par:fixture-name (par:corpus))))
  (ok (= (length (par:corpus))
         (length (remove-duplicates (mapcar #'par:fixture-name (par:corpus))
                                    :test #'string=)))))
