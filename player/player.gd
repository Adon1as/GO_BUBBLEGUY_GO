extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var camera
func _ready() -> void:
	camera = get_child(2)

func _physics_process(delta: float) -> void:
	position.x = clamp(position.x, camera.limit_left, camera.limit_right)
	position.y = clamp(position.y, camera.limit_top, camera.limit_bottom)
	if position.y == camera.limit_bottom:
		die()
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
func die():
	get_tree().change_scene_to_file("res://global/main_menu.tscn")
