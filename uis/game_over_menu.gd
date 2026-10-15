extends Control


func game_over() -> void:
	visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = true


func _restart() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()


func _quit() -> void:
	get_tree().quit()


func _on_restart_button_pressed() -> void:
	_restart()


func _on_quit_button_pressed() -> void:
	_quit()
