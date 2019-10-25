;;;; furcadia-post-splitter.asd

(asdf:defsystem #:furcadia-post-splitter
  :description "Describe furcadia-post-splitter here"
  :author "Your Name <your.name@example.com>"
  :license  "Specify license here"
  :version "0.0.1"
  :serial t
  :depends-on (:phoe-toolbox
               :split-sequence
               :trivial-package-local-nicknames
               :qtools
               :qtcore
               :qtgui
               :qt-libs)
  :components ((:file "furcadia-post-splitter")))
