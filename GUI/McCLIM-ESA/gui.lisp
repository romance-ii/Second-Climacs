(cl:in-package #:climacs-esa-gui)

(defclass info-pane (esa:info-pane)
  ()
  (:default-initargs
   :height 20 :max-height 20 :min-height 20
   :display-function 'display-info
   :incremental-redisplay t))

(defun display-info (frame pane)
  (declare (ignore frame))
  (format pane "Pane name: ~s" (clim:pane-name (esa:master-pane pane))))

(defclass minibuffer-pane (esa:minibuffer-pane)
  ()
  (:default-initargs
   :height 20 :max-height 20 :min-height 20))

(clim:define-command-table global-climacs-table
  :inherit-from
  (esa:global-esa-table
   esa-io:esa-io-table))

(clim:define-application-frame climacs (esa:esa-frame-mixin
					clim:standard-application-frame)
  ((%views :initarg :views :reader views)
   (%buffers :initarg :buffers :reader esa:buffers)
   (%current-view :initarg :current-view :accessor current-view))
  (:panes
   (window (let* ((my-pane (clim:make-pane 'text-pane
					   :lines '()
					   :width 900 :height 400
					   :display-time nil
					   :command-table 'global-climacs-table))
		  (my-info-pane (clim:make-pane 'info-pane
						:master-pane my-pane
						:width 900)))
	     (setf (esa:windows clim:*application-frame*) (list my-pane))
	     (clim:vertically ()
	       (clim:scrolling ()
		 my-pane)
	       my-info-pane)))
   (minibuffer (clim:make-pane 'minibuffer-pane :width 900)))
  (:layouts
   (default (clim:vertically (:scroll-bars nil)
	      window
	      minibuffer)))
  (:top-level (esa:esa-top-level)))

(defun climacs ()
  (clim:run-frame-top-level
   (clim:make-application-frame
    'climacs
    :views '()
    :buffers '())))
