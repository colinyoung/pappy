(defun start-server (&optional port)
  "Start the app server w/ a default port"
  (toot:start-server :port port :handler 'http-handler))
  
(defun http-handler (request)
  (let ((response (response-to request)))
    (setf status-code 200)
    (if (not (null response))
      (setf status-code (slot-value response 'status-code)))
    (let ((resp (toot:send-headers request
        :content-type "application/json"
        :status-code status-code)))
      (deliver-response resp (render response)))))