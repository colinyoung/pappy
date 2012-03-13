(use-package :cl-mongo)

(defun defmodel (&rest args)
  "Defines a model. The first argument is the model
  name, the rest are fields."
  (let ((model (string (car args))) (fields (cdr args)))
    ; Ensure the collection is created in mongo
    ; (db.create-collection model)
    ; for some reason this doesn't work?
    
    ; Update indexes as needed
    (loop for field in fields
      do (db.ensure-index model (string (cdr (cdr field)))))
      
    ; (re)define the fields for this class
      
    ))
  
; (setf *types* '(string text number date many one))

(defun str (field)
  (list :string field))
  
(defun text (field)
  (list :text field))
  
(defun num (field)
  (list :number field))
  
(defun date (field)
  (list :date field))
  
(defun many (field)
  (list :many field))
  
(defun one (field)
  (list :one field))