extends CanvasLayer
class_name GameOverScreen

const main_scene: PackedScene = preload("res://scenes/main.tscn")

@onready var title: Label = $PanelContainer/MarginContainer/Rows/Title


func set_title(win: bool):
	if win:
		title.text = "YOU WIN!"
		title.modulate = Color.GREEN
	else:
		title.text = "YOU LOSE!"
		title.modulate = Color.RED


func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_packed(main_scene)


func _on_quit_button_pressed() -> void:
	get_tree().quit()
