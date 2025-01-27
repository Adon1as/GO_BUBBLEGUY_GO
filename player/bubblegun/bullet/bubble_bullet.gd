extends RigidBody2D
class_name BubbleBullet

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node) -> void:
	if "bubbleable" in body:
		body.timer.start()
		GameManeger._on_walk_mob_bubbleable(body) 
		
	queue_free()
