;;;; pappy.lisp

(in-package #:pappy)

(use-package :split-sequence)

; Change for your mongo database.
(cl-mongo:db.use "pappy")

(load "library/utilities.lisp")
(load "library/server.lisp")
(load "library/controller.lisp")
(load "library/model.lisp")
(load "library/view.lisp")

(defun setup ()
  (defparameter *REQUEST* nil)
  ; Set up model fields memory storage
  (defparameter *MODELS* (make-hash-table))
  ; Set up controller callback functions memory storage
  (defparameter *CONTROLLERS* (make-hash-table)))
