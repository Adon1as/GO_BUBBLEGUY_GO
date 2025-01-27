extends Node
class_name PlayerTimer

@onready var dash := $dash as Timer
@onready var delay_dmg := $delay_dmg as Timer
@onready var knockback := $knockback as Timer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
