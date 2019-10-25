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
  :defsystem-depends-on (:qtools)
  :build-operation "qt-program-op"
  :build-pathname "raptor-splitter"
  :entry-point "furcadia-post-splitter:main"
  :components ((:file "furcadia-post-splitter")))
