(defun run (&optional port)
  "Start the app server w/ a default port"
  (toot:start-server :port port :handler 'http-handler))
  
(defun http-handler (request)
  
  (let ((resp (response-to request)))
    ; (setq status-code 200)
    ; (if (not (null resp))
    ;   (setf status-code (slot-value resp 'status-code)))
    (let ((http (toot:send-headers request
;        :content-type "text/json"
        :status-code 200)))
      (deliver-response http (render resp)))))

(defun deliver-response (stream json)
  (format stream json))
