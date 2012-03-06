(ql:quickload "cl-mongo")
(ql:quickload "toot")
(ql:quickload "cl-json")
(ql:quickload "cl-inflector")
(ql:quickload "split-sequence")

(defpackage :pappy
  (:documentation "A simple API built for mobile apps.")
  (:use :cl
        :cl-mongo
        :split-sequence
        :toot
        :json
        :cl-inflector))
        
; (in-package :pappy)

(use-package :cl-inflector)
(use-package :split-sequence)

(defun deliver-response (resp json)
  (format resp json))
  
(defun render (response)
  (json:encode-json-to-string response))
  
(defun path-elements (path)
  (split-sequence #\/ path))

; Handles routing to models
(defun response-to (request)
  (let
    (
      (path (puri:uri-path (toot:request-uri request)))
    )
    (let
      (
        (model (singular-of (nth 1 (path-elements path))))
        (key                (nth 2 (path-elements path)))
      )
      (find-all-or-one model key))))

; find either all the objects or one (if there's an optional key, show just that one)
(defun find-all-or-one (model &optional key))

(defun http-handler (request)
  (let ((resp (toot:send-headers request)))
    (deliver-response resp (render (response-to request)))))

(toot:start-server :port 8080 :handler 'http-handler)
