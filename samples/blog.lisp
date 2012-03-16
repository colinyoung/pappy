; Blog (sample project)
; ---------------------

(ql:quickload "pappy")

(in-package #:pappy)

; Models
; ------
(defmodel :post
  (str :title)
  (text :body)
  (many :comments))

(defmodel :comment
  (text :body)
  (one :user))

(defmodel :user
  (str :first_name)
  (str :last_name)
  (str :email))
  
; Controller filters
; ------------------
; Much like Rails before_filters, these get called before every request.
; If they change the global *status-code* variable to a non-200 value,
; the action (read, create, etc) won't be performed and an error 
; message will be delivered.

(defun is-user ()
  "Tells if the current request is a user request."
  (loop for p in (toot::get-parameters *REQUEST*)
    do
      (if (string-equal (car p) "user_id")
        ; find user
        (let 
          ((user (find-one-by-id "user" (cdr p))))
          ; a user must be found or they aren't authorized
          (if (null user) (unauthorized))))))
  
(defun print-parameters ()
  (pp-query (toot::get-parameters *REQUEST*)))
  
; Controllers
; -----------

(controller :comments
    :read 'print-parameters
    :update 'is-user
    :delete 'is-user)
    
(controller :posts
    :update 'is-user
    :delete 'is-user)    
  
; Special functions
; -----------------

; (defun post-editp (user post)
;   (equal (post user) user))

; Run the server
; --------------

(run 3000)