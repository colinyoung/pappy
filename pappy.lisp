;;;; pappy.lisp

(in-package #:pappy)

(use-package :split-sequence)

; Change for your mongo database.
(cl-mongo:db.use "pappy")

(load "library/server.lisp")
(load "library/controller.lisp")
(load "library/model.lisp")
(load "library/view.lisp")

; find either all the objects or one (if there's an optional key, show just that one)
(defun find-all-or-one (model &optional key))

(toot:start-server :port 8080 :handler 'http-handler)
