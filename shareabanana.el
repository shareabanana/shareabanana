(defun share-a-banana (name recipient)
	"Share a banana with your friend!"
	(interactive
	 (list (read-string
					(concat "Your Name (default " (user-full-name) "): ")  nil nil (user-full-name))
				 (read-string "Recipient: ")))
	(message-mail recipient (concat name " has shared a banana with you!"))
	(message-goto-body)
	(insert
	 (concat
		"<img src='http://shareabanana.com/img/bananas/banana_" (number-to-string (random 8)) ".png' /><br>"
		"Share bananas with your friends at <a href='http://shareabanana.com/'>shareabanana.com</a>."))
	(message-send-and-exit)
	(message "Banana Sent!"))
