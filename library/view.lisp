(defclass Response ()
  ((value)
    (status-code
      :initform 200
      :accessor :status-code)))

(defun deliver-response (resp json)
  (format resp json))
  
(defun render (response)
  (if (null response) (return-from render ""))
  (json:encode-json-to-string (slot-value response 'value)))
  
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
