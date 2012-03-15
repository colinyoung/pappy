(defclass response ()
  ((content
      :initform ""
      :accessor content)
    (status-code
      :initform 200
      :accessor status-code)))
  
(defun render (resp)
    (json:encode-json-to-string (content resp)))
  
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
        (model              (nth 1 (path-elements path)))
        (key                (nth 2 (path-elements path)))
        (resp               (make-instance 'response))
      )
      
      (setf dot-position (search "." model))
      (if (not (null dot-position))
        (setf model (subseq model 0 dot-position)))
      (setf model (singular-of model))
      
      (setf (content resp) (find-all-or-one model key))
      
      resp)))
