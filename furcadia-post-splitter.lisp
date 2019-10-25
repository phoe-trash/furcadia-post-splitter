;;;; furcadia-post-splitter.lisp

(defpackage #:furcadia-post-splitter
  (:use #:cl
        #:qtools
        #:split-sequence
        #:trivial-package-local-nicknames
        #:named-readtables)
  (:export #:main))

(in-package #:furcadia-post-splitter)

(in-readtable :qtools)

(eval-when (:compile-toplevel :load-toplevel :execute)
  (add-package-local-nickname :φ :phoe-toolbox))

;;; Linebreak

(defun linebreak (string line-length)
  (loop with words = (split-sequence-if #'φ:whitespacep string
                                        :remove-empty-subseqs t)
        with stack = '()
        with length = 0
        for (word next-word) on words
        if (or (null stack) (<= (+ length (length word)) line-length))
          do (push word stack)
             (incf length (1+ (length word)))
        else
          collect (format nil "~{~A~^ ~}" (nreverse stack))
          and do (setf stack (list word)
                       length (length word))
        when (null next-word)
          collect (format nil "~{~A~^ ~}" (nreverse stack))))

;;; Smart quote replacement

(defun replace-smart-quotes (string)
  (loop for i below (length string)
        for char across string
        when (member char '(#\“ #\”))
          do (setf (aref string i) #\")
        finally (return string)))

;;; Widget

(named-readtables:in-readtable :qtools)

(define-widget main-window (qwidget) ())

(define-subwidget (main-window layout) (q+:make-qvboxlayout main-window)
  (q+:set-window-title main-window "Raptor Splitter"))

(define-subwidget (main-window text-edit) (q+:make-qtextedit)
  (q+:add-widget layout text-edit)
  (q+:set-text text-edit "Donations: https://www.paypal.me/phoekrk <3"))

(define-subwidget (main-window button) (q+:make-qpushbutton "Cut")
  (q+:add-widget layout button))

(defparameter *limit* 970)

(define-slot (main-window cut-contents) ()
  (declare (connected button (pressed)))
  (let* ((text (replace-smart-quotes (q+:to-plain-text text-edit)))
         (paragraphs (linebreak text *limit*))
         (result (format nil "~{~A~^ [c]~%~%~}" paragraphs)))
    (q+:set-text text-edit result)
    (let ((cursor (q+:text-cursor text-edit)))
      (q+:move-position cursor (q+:qtextcursor.end))
      (q+:set-text-cursor text-edit cursor))
    (when (> (length text) *limit*)
      (q+:insert-plain-text text-edit " [e]"))))

(defparameter *stylesheet*
  "QTextEdit {
  background-color: #19232D;
  color: #F0F0F0;
  border: 1px solid #32414B;
}

QTextEdit:hover {
  border: 1px solid #148CD2;
  color: #F0F0F0;
}

QTextEdit:selected {
  background: #1464A0;
  color: #32414B;
}")

(defun main ()
  (dolist (i '("smokebase.dll" "smokeqtcore.dll" "smokeqtgui.dll"))
    (cffi:load-foreign-library i))
  (with-main-window (window 'main-window)
    (q+:set-style-sheet qt:*qapplication* *stylesheet*)))
