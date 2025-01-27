extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if GameManager.game_result == 1:
		won() # Replace with function body.
	elif GameManager.game_result == -1:
		lose()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_new_game_pressed() -> void:
	get_tree().change_scene_to_file("res://stages/factory/factory.tscn")


func _on_credits_pressed() -> void:
	pass # Replace with function body.


func _on_exit_pressed() -> void:
	get_tree().quit() # Replace with function body.

func lose():
	var label:Label = get_node("title")
	label.text = "YOU LOST"
	label.self_modulate = Color.RED
	
func won():
	var label:Label = get_node("title")
	label.text = "YOU WIN"
	label.self_modulate = Color.DARK_GREEN


func _on_credites_pressed() -> void:
	pass # Replace with function body.
