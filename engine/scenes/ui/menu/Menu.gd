extends MarginContainer


# helper functions
func hide_right_panels():
	$HBoxContainer/MarginContainer/Login.visible = false
	$HBoxContainer/MarginContainer/Logon.visible = false

func _on_login_button_pressed():
	hide_right_panels()
	$HBoxContainer/MarginContainer/Login.visible = true

func _on_create_account_button_pressed():
	hide_right_panels()
	$HBoxContainer/MarginContainer/Logon.visible = true
