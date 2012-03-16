; utilities here
(defun make-keyword (name) (values (intern (string-upcase name) "KEYWORD")))