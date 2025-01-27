extends Node


var game_result = 0

const BUBBLE_EFFECT = preload("res://player/bubblegun/effect/bubble_effect.tscn")


func _on_walk_mob_bubbleable(node:RigidBody2D) -> void:
	
	var bubble:BubbleEffect = BUBBLE_EFFECT.instantiate() as BubbleEffect
	bubble.name += node.name
	#bubble.set_as_top_level(true)
	get_tree().current_scene.add_child(bubble)
	
	var joint = PinJoint2D.new()
	joint.angular_limit_enabled = false
	
	joint.node_a = node.get_path()
	joint.node_b = bubble.get_path()
	
	bubble.global_position = node.global_position 
	joint.global_position = node.global_position 
	 
	get_tree().current_scene.add_child(joint)
	joint.name = node.name+"_bubbled"
	
	#bubble.freeze = false
	node.gravity_scale = 0.07
	node.to_bubble=false
		
	


func _on_walk_mob_bubble_out(node:RigidBody2D) -> void:
	var joint:PinJoint2D = get_tree().current_scene.get_node(node.name+"_bubbled")
	
	get_tree().current_scene.get_node(joint.node_b).queue_free()
	joint.queue_free()
	
	node.gravity_scale = 1

func player_won():
	game_result=1
	get_tree().change_scene_to_file("res://global/main_menu.tscn")

func player_lose():
	game_result=-1
	get_tree().change_scene_to_file("res://global/main_menu.tscn")


func _on_dead_zone_enemy() -> void:
	player_won()


func _on_dead_zone_player() -> void:
	player_lose()


func _on_player_die() -> void:
	player_lose() 
