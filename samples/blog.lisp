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

; (defmodel :comment
;   ((text :body)
;   (user :many)))
;   
; (defmodel :user
;   ((str :first_name)
;   (str :last_name)
;   (str :email)))
  
; Controllers
; -----------
; (controller :post :all
;   ((:update post-editp)
;   (:delete post-editp)))
; 
; (controller :comment :all
;   ((:update is-user)
;   (:delete is-user)))
;   
; (controller :user :all
;   ((:update is-user)
;   (:delete is-user)))
  
; Special functions
; -----------------

; (defun post-editp (user post)
;   (equal (post user) user))

; Run the server
; --------------

(run 3000)