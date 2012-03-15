(use-package :cl-mongo)

; Set up model fields memory storage
(defparameter *MODELS* (make-hash-table))

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
    (setf (gethash model *MODELS*) fields)))

; FIELD DEFINITIONS

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
  
(defun oid-to-string (oid)
  (let ((stream (make-string-output-stream)))
  (let* ((arr oid)
    (size (length arr)))
     (dotimes (index size)
 (let ((x (aref arr index)))
   (if (< x 10) 
       (format stream (string-trim " " (format nil "0~1X" x)))
       (format stream (string-trim " " (format nil "~2X" x)))))))
  (get-output-stream-string stream)))
  
(defun string-to-oid (string)
  (setf vector (make-array 12))
  (loop for i from 0 to 11
    do
    (setf pos (* i 2))
    (setf bitstr (subseq string pos (+ pos 2)))
    (setf bit (parse-integer bitstr :radix 16))
    (setf (aref vector i) bit))
  (cl-mongo::make-bson-oid :oid vector))
  
; DATABASE METHODS
(defun find-all-or-one (model &optional key query)
  "Find either all the objects or one (if there's an optional key, show just that one)"
  (let ((collection (pluralize 2 model)))
    (if (or (null key) (string-equal "" key))
      (find-all collection query)
      (find-one collection key))))
      
(defun find-all (collection &optional query)
  "Find all objects in a collection."
  (db.use "pappy")
  (loop for doc in (docs (db.find collection :all))
   do
      (setf doc-hash (cl-mongo::elements doc))
      (setf (gethash '_id doc-hash) (oid-to-string (cl-mongo::doc-id doc)))
      (print (cl-mongo::doc-id doc))
    collecting
      doc-hash))
      
(defun find-one (collection key &optional query)
  "Find one document in a collection."
  (print (format t "find one: ~a" key))
  (db.use "pappy")
  (car (docs (db.find collection
    (kv "_id" (string-to-oid key))))))

(defun model-fields (model)
  "Prints all the fields from a model."
  (gethash model *MODELS*))