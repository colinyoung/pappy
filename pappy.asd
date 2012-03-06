;;;; pappy.asd

(asdf:defsystem #:pappy
  :serial t
  :depends-on (#:cl-mongo
               #:split-sequence
               #:toot
               #:cl-json
               #:cl-inflector)
  :components ((:file "package")
               (:file "pappy")))

