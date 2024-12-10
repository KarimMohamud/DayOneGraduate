extends CanvasLayer

@export var health_bar: ProgressBar

func _ready():
	self.hide()

func _on_game_over() -> void:
	print("Game Over!")
	get_tree().paused = true
	self.show()  # Näytetään game over -ikkuna

func _on_retry_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main.tscn")
