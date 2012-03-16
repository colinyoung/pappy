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
        (method             (string (toot:request-method request)))
        (params             (toot::get-parameters request))
      )
      
      ; Swap params for POST or PUT BODY parameters if set
      (if (or (string-equal "POST" method) (string-equal "PUT" method))
        (setf params (toot:post-parameters request)))
      
      ; Remove format extension (e.g. ".json")
      (setf dot-position (search "." model))
      (if (not (null dot-position))
        (setf model (subseq model 0 dot-position)))
      (setf model (singular-of model))
      
      ; Generate response based on request method (GET, POST, PUT, DELETE)
      (setf (content resp)
        (cond 
          ((string-equal "GET" method)
            (find-all-or-one model key))
          ((string-equal "POST" method)
            (create-one model params))
          ((string-equal "DELETE" method)
            (delete-one model key))
          ((string-equal "PUT" method)
            (update-one model key params))
          (t "Unsupported")))
      
      resp)))
      
; Access control
(defun filtered-elements (model elements)
  "Filters the elements of an object the way it should be."
  (loop for field in (model-fields model)
    do
      (setf key (string-downcase (string (car (cdr field)))))
      (setf key-present (nth-value 1 (gethash key elements)))
      (if (null key-present)
        (remhash key elements)))
        
  elements)
  
(defun print-hash (key value)
  (format t "key ~a value ~a" key value))

; URI Utilities
(defun pp-query (query)
  (loop for kv in query
    do
    (format t "~a=~a~%" (car kv) (cdr kv))))