(defgroup docker-machine nil
  "Docker Machine management"
  :prefix "docker-machine-")

(defcustom docker-machine-executable
  "docker-machine"
  "Path to the docker-machine executable"
  :type 'string
  :group 'docker-machine)

(defcustom docker-machine-name-face
  :type 'face
  :group 'docker-machine)


(defvar docker-machine-mode-map
  (let ((map (make-sparse-keymap)))
    (set-keymap-parent map widget-keymap)
    (define-key map (kbd "g") 'docker-machine--create-page)
    map)
  "Keymap for docker-machine major mode.")

(define-derived-mode docker-machine-mode special-mode "Docker-Machine"
  "A major mode for viewing a list of Docker machines."
  )

(defvar docker-machine-mode--machine-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "RET") 'docker-machine--placeholder)
    (define-key map (kbd "i") 'docker-machine--inspect)
    map))

(defun docker-machine--machines ()
  "List the known Docker Machines"
  (loop for line in (cdr (process-lines docker-machine-executable "ls"))
        for machine = (split-string line "[[:space:]]+" t)
        collect machine))

(defun docker-machine--names ()
  (mapcar #'first (docker-machine--machines)))

(defun docker-machine--env (machine)
  "Set up the environment variables to allow the Docker client to
communicate with the specified machine."
  (shell))

(defun docker-machine--select ()
  )

(defun docker-machine--info ()
  "Display information about the selected docker-machine."
  (interactive)
  )




;(define-key docker-machine "s" 'docker-machine--select)
(define-key docker-machine-mode-map "i" docker-machine--info)
;(define-key docker-machine-mode-map "n" docker-machine--)
;(define-key docker-machine-mode-map "D" docker-machine--)
;(define-key docker-machine-mode-map "u" docker-machine--)
;(define-key docker-machine-mode-map "c" docker-machine--)
;

(defun docker-machine--machine-at-point (posn)
  )

(defun docker-machine--placeholder ()
  (interactive)
  (message "Selected Docker machine: %s"
           (get-text-property
            (point)
            'docker-machine--machine-name)))


(defun docker-machine--inspect ()
  (interactive)
  (let ((machine-name (get-text-property
                       (point)
                       'docker-machine--machine-name)))
    (if machine-name
        (let ((buf (get-buffer-create "*docker-machine inspect*")))
          (shell-command (concat docker-machine-executable " "
                                 "inspect "
                                 machine-name)
                         buf)
          (unless (get-buffer-window buf)
            (set-window-buffer
             (split-window-sensibly)
             buf)))
      (message "No machine at point."))))

(defun docker-machine--write-inspect-page ())

(defun docker-machine--write-page (machines)
  (loop for (name active driver state url) in machines
        do
        (add-text-properties
         (point)
         (progn
           (insert (format "%s\t%s\n" name driver))
           (point))
         `(docker-machine--machine-name
           ,name
           mouse-face highlight
           font-lock-face docker-machine-name-face
           keymap ,docker-machine-mode--machine-map))))

(defun docker-machine--create-page (&optional machines)
  (unless machines (setq machines (docker-machine--machines)))
  (let ((buf (get-buffer-create "*docker-machine ls*")))
    (save-excursion
      (set-buffer buf)
      (setq buffer-read-only nil)
      (erase-buffer)
      (docker-machine--write-page machines)
      (setq buffer-read-only 't))
    (unless (get-buffer-window buf)
      (set-window-buffer
       (split-window-sensibly)
       buf))))


(docker-machine--create-page )


;(provide 'docker-machine)
