extends RigidBody2D
class_name WalkMob

var deal_damage = true
var damage = 1
var in_bubble = false
var to_bubble = false
var timer: Timer 
signal bubble_out 
signal bubbleable 

func _ready() -> void:
	timer = get_node("Timer")

func _process(delta: float) -> void:
	pass
		


func _on_timer_timeout() -> void:
	GameManager._on_walk_mob_bubble_out(self)
	#emit_signal("bubble_out", self)
	
