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
    collecting
      (process-for-render doc (singular-of collection))))
      
(defun find-one (collection key &optional query)
  "Find one document in a collection."
  (print (format t "find one: ~a" key))
  (db.use "pappy")
  (process-for-render
    (find-one-by-id collection key)
    (singular-of collection)))
      
(defun find-one-by-id (collection key)
  (car (docs (db.find collection (kv "_id" (string-to-oid key))))))
    
(defun create-one (model params) ; params is a list of conses
  "Creates one new object"
  (let
    (
      (doc (make-document))
      (collection (pluralize 2 model))
    )
      (loop for p in params
        do
        (add-element (car p) (cdr p) doc))

      (db.insert collection doc)
      
      (process-for-render doc model)))
      
  
(defun delete-one (model key)
  "Deletes an object"
  (let ((collection (pluralize 2 model)))
    (db.delete collection (find-one-by-id collection key))
    (null (find-one-by-id collection key))))
  
(defun update-one (model key params)
  (let ((collection (pluralize 2 model)))
    (setf doc (find-one-by-id collection key))
    
    ; @todo Mass Assignment Security goes here
    (loop for p in params
      do
      (rm-element (car p) doc)
      (add-element (car p) (cdr p) doc))
      
    (db.save collection doc)
    (process-for-render doc model)))
    
  
(defun process-for-render (doc model)

  ; Get the elements
  (setf doc-hash (filtered-elements model (cl-mongo::elements doc)))
  
  ; Add the ID
  (setf (gethash "_id" doc-hash) (oid-to-string (cl-mongo::doc-id doc)))

  ; Remove some weird _local_id thing that mongo adds.
  (remhash "_local_id" doc-hash)
  
  doc-hash)

(defun model-fields (model)
  "Prints all the fields from a model."
  (gethash model *MODELS*))
  
; Field utility methods
(defun oid-to-string (oid)
  "Converts a BSON ObjectID vector to string."
  (let ((stream (make-string-output-stream)))
  (let* ((arr oid)
    (size (length arr)))
     (dotimes (index size)
 (let ((x (aref arr index)))
   (if (< x 16)
       (format stream "0~1X" x)
       (format stream "~2X" x)))))
  (subseq (string-downcase (get-output-stream-string stream)) 0 24)))
  
(defun string-to-oid (string)
  "Converts a BSON ObjectID to vector (base 16).
  BSON IDs are 24 chars long and consist of 12 base16 integers."
  (if (not (= (length string) 24))
    (return-from string-to-oid nil))
  
  (setf vector (make-array 12))
  (loop for i from 0 to 11
    do
    (setf pos (* i 2))
    (setf bitstr (subseq string pos (+ pos 2)))
    (setf bit (parse-integer bitstr :radix 16))
    (setf (aref vector i) bit))
  (cl-mongo::make-bson-oid :oid vector))
