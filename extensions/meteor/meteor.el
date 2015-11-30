(require 'evil)
(require 'dash)
(require 's)

(define-minor-mode meteor-mode
  :lighter: " Meteor")

(defun meteor-run ()
  ;; runs the meteor app in the current direvtory and outputs info into an async *meteor* buffer
  (interactive)
  (async-shell-command "meteor run" "*Meteor*"))

(defun meteor-find-packages-file ()
  ".meteor/packages")

(defun meteor-add-package ()
  ;; adds a package to the current dir's meteor project.
  (interactive)
  (helm :sources '(helm-source-meteor-packages-atmosphere)))

(defun meteor-remove-package ()
  ;; removes a package from the current dir's meteor project
  (interactive)
  (helm :sources '(helm-source-meteor-packages-installed)))

(defun meteor-add-package-named (pkgname)
  (async-shell-command (format "meteor add %S" pkgname) "*Meteor-Package-Output*"))

(defun meteor-remove-package-named (pkgname)
  (async-shell-command (format "meteor remove %S" pkgname) "*Meteor-Package-Output*"))

(defun meteor-packages-installed ()
  (let ((packages-file (meteor-find-packages-file)))
    (--remove (s-starts-with-p "#" it)
              (with-temp-buffer
                (insert-file-contents packages-file)
                (goto-char (point-min))
                (split-string (buffer-string) "\n" t)))))

(defun meteor-refresh-package-cache ()
  ;; TODO
  ;; pulls a json file from here https://atmospherejs.com/a/packages
  ;; and saves into the cache at ~/.emacs.d/.cache/meteor/packages.json
  )

(defun meteor--get-package-metadata (x)
  (list
   (cdr (assoc 'name x))))
   ;;TODO add description to package install list
   ;;(cdr (assoc 'description (assoc 'latestVersion x)))))

(defun meteor-packages-atmosphere ()
  ;; reads the package json and returns useful metadata
  '("nemo64:bootstrap" "iron:router")
  (let ((packages-obj (json-read-file "~/.emacs.d/.cache/meteor/packages.json")))
    (mapcar 'meteor--get-package-metadata packages-obj)))

(defvar helm-source-meteor-packages-installed
  '((name . "Meteor Installed Packages")
    (header-name . "Meteor Installed Packages")
    (volatile)
    (candidates . meteor-packages-installed)
    (action . (("Remove Package" . meteor-remove-package-named)))))

(defvar helm-source-meteor-packages-atmosphere
  '((name . "Meteor Packages from Atmosphere")
    (header-name . "Meteor Packages from Atmosphere")
    (candidates . meteor-packages-atmosphere)
    (action . (("Add Package" . meteor-add-package-named)))))

(provide 'meteor)
