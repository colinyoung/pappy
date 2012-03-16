(defparameter *status-code* 200)

(defun run (&optional port)
  "Start the app server w/ a default port"
  (toot:start-server :port port :handler 'http-handler))
  
(defun http-handler (request)
  (setf *REQUEST* request)
  (let ((resp (response-to request)))
    (let ((http (toot:send-headers request
;        :content-type "text/json"
        :status-code *status-code*)))
      (if (eq *status-code* 200)
        (deliver-response http (render resp))
        (deliver-response http "Unauthorized")))))

(defun deliver-response (stream json)
  (format stream json))

(defun unauthorized ()
  (setf *status-code* 401))