extends Area2D

signal enemy
signal player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body as Player:
		GameManeger._on_dead_zone_player()
	if body as WalkMob:
		GameManeger._on_dead_zone_enemy()
