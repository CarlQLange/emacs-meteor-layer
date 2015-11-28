(require 'evil)

(defun meteor-goto-template-helper ()
  (spacemacs-buffer/message "Cake"))

(define-minor-mode meteor-mode
  :lighter: " Meteor")

(evil-leader/set-key
  "mth" (meteor-goto-template-helper))

(provide 'meteor)
