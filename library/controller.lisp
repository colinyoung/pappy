(use-package :cl-mongo)

; Create a controller
(defun controller (controller &key create read update delete)
  (setup)
  
  (setf hash (make-hash-table))
  (if (not (null create)) (setf (gethash :create hash) create))
  (if (not (null read))   (setf (gethash :read hash)     read))
  (if (not (null update)) (setf (gethash :update hash) update))
  (if (not (null delete)) (setf (gethash :delete hash) delete))
  
  (setf (gethash controller *CONTROLLERS*) hash))
  
(defun run-controller (method controller-name)
  (setf controller (gethash (make-keyword controller-name) *CONTROLLERS*))
  (if (null controller) (return-from run-controller nil))
  (setf function (gethash (make-keyword (http-to-crud method)) controller))  
  (when (not (null function))
    (funcall function)))
    
(defun http-to-crud (http-method)
  "Converts HTTP Method to CRUD keyword"
  (cond
    ((string-equal http-method "POST")    "create")    
    ((string-equal http-method "GET")     "read")
    ((string-equal http-method "PUT")     "update")    
    ((string-equal http-method "DELETE")  "delete")
    (t nil)))
    