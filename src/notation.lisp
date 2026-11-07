(in-package #:terminal-parity)

;;; Byte notation for the corpus: a string whose characters are UTF-8
;;; encoded, plus brace escapes for control bytes:
;;;   {esc} {bel} {bs} {ht} {lf} {cr} {nul} {can} {sub} {del} {st}
;;;   {csi} → ESC [   {osc} → ESC ]   {xHH} → byte HH   {{ → a literal {

(defparameter +names+
  '(("esc" 27) ("bel" 7) ("bs" 8) ("ht" 9) ("lf" 10) ("vt" 11) ("ff" 12)
    ("cr" 13) ("nul" 0) ("can" 24) ("sub" 26) ("del" 127) ("so" 14) ("si" 15)
    ("enq" 5) ("st" 27 92) ("csi" 27 91) ("osc" 27 93) ("dcs" 27 80)))

(defun %utf8 (char)
  (let ((code (char-code char)))
    (cond ((< code #x80) (list code))
          ((< code #x800) (list (logior #xc0 (ash code -6))
                                (logior #x80 (logand code #x3f))))
          ((< code #x10000) (list (logior #xe0 (ash code -12))
                                  (logior #x80 (logand (ash code -6) #x3f))
                                  (logior #x80 (logand code #x3f))))
          (t (list (logior #xf0 (ash code -18))
                   (logior #x80 (logand (ash code -12) #x3f))
                   (logior #x80 (logand (ash code -6) #x3f))
                   (logior #x80 (logand code #x3f)))))))

(defun decode-input (string)
  "Corpus notation → (simple-array (unsigned-byte 8) (*))."
  (let ((out '()) (i 0) (n (length string)))
    (loop while (< i n)
          do (let ((c (char string i)))
               (cond ((and (char= c #\{) (< (1+ i) n) (char= (char string (1+ i)) #\{))
                      (push (char-code #\{) out)
                      (incf i 2))
                     ((char= c #\{)
                      (let* ((close (or (position #\} string :start i)
                                        (error "unterminated { in ~S" string)))
                             (name (string-downcase (subseq string (1+ i) close)))
                             (entry (assoc name +names+ :test #'string=)))
                        (cond (entry (dolist (b (rest entry)) (push b out)))
                              ((and (= (length name) 3) (char= (char name 0) #\x))
                               (push (parse-integer name :start 1 :radix 16) out))
                              (t (error "unknown escape {~A} in ~S" name string)))
                        (setf i (1+ close))))
                     (t (dolist (b (%utf8 c)) (push b out))
                        (incf i)))))
    (coerce (nreverse out) '(simple-array (unsigned-byte 8) (*)))))

(defun encode-octets (octets)
  "Octets → corpus notation. Printable ASCII stays; ESC [ / ESC ] become
{csi} / {osc}; other bytes are named or {xHH}. Non-ASCII is kept as {xHH}
so the notation round-trips byte for byte."
  (with-output-to-string (out)
    (let ((i 0) (n (length octets)))
      (loop while (< i n)
            do (let ((b (aref octets i)))
                 (cond ((and (= b 27) (< (1+ i) n) (= (aref octets (1+ i)) 91))
                        (write-string "{csi}" out) (incf i 2))
                       ((and (= b 27) (< (1+ i) n) (= (aref octets (1+ i)) 93))
                        (write-string "{osc}" out) (incf i 2))
                       ((= b (char-code #\{)) (write-string "{{" out) (incf i))
                       ((<= 32 b 126) (write-char (code-char b) out) (incf i))
                       (t (let ((name (car (find-if (lambda (e) (and (= 2 (length e))
                                                                     (= (second e) b)))
                                                    +names+))))
                            (if name
                                (format out "{~A}" name)
                                (format out "{x~(~2,'0X~)}" b)))
                          (incf i))))))))
