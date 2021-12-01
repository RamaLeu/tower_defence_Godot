extends Control

signal pause_button(button)


func _on_Quit_pressed():
	emit_signal("pause_button", "quit")


func _on_Continue_pressed():
	emit_signal("pause_button", "continue")


func _on_Settings_pressed():
	emit_signal("pause_button", "settings")
