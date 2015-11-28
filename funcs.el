(require 'dash)
(require 's)

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

(defun meteor-packages-atmosphere ()
  ;; pulls a json file from here https://atmospherejs.com/a/packages
  ;; and saves into the cache
  ;; and returns the name of each package in a list
  ;; as I write, that's nearly 8000 packages
  ;; maybe that's too many? what do
  ;; for now dummy text
  '("nemo64:bootstrap" "iron:router")
  )

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
