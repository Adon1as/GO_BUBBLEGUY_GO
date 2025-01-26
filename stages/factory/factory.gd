extends Node2D

var vault: Marker2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	vault = get_node("DevVault") # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_walk_mob_bubbleable(node:RigidBody2D) -> void:
	
	var bubble:RigidBody2D = get_node("BubbleEffect").duplicate()
	bubble.name += node.name
	add_child(bubble)
	
	var joint = PinJoint2D.new()
	joint.angular_limit_enabled = false
	
	joint.node_a = node.get_path()
	joint.node_b = bubble.get_path()
	
	bubble.global_position = node.global_position 
	joint.global_position = node.global_position 
	 
	add_child(joint)
	joint.name = node.name+"_bubbled"
	
	bubble.freeze = false
	node.gravity_scale = 0.07
	node.to_bubble=false
		
	


func _on_walk_mob_bubble_out(node:RigidBody2D) -> void:
	var joint:PinJoint2D = get_node(node.name+"_bubbled")
	
	get_node(joint.node_b).queue_free()
	joint.queue_free()
	
	node.gravity_scale = 1

func player_won():
	Global.game_result=1
	get_tree().change_scene_to_file("res://global/main_menu.tscn")

func player_lose():
	Global.game_result=-1
	get_tree().change_scene_to_file("res://global/main_menu.tscn")

	
func _on_dead_zone_enemy(wm:WalkMob) -> void:
	player_won()


func _on_dead_zone_player(p:Player) -> void:
	player_lose()


func _on_player_die() -> void:
	player_lose() # Replace with function body.
