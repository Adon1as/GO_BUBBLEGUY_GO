extends CharacterBody2D

class_name EnemyBase;

@export var _force: float = 120.0;
@export var _damage: int = 1;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	


func _on_hit_box_area_entered(area: Area2D) -> void:
	print("enemy_hit_box_entered");
	var hitBoxParent = area.get_parent();
	if hitBoxParent is NewPlayer:
		print("The Player has collided with me D:");
		#emit signal along with damage
		SignalManager.on_enemy_collided_with_player.emit(_damage, _force, global_position);
	pass # Replace with function body.
