extends CharacterBody2D
class_name Player

const SPEED = 100.0
const JUMP_VELOCITY = -400.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var sprite_2d: Sprite2D = $Sprite2D

enum PlayerStates { IDLE, RUN }

signal die

var timers: PLayerTimer
var gun
var last_valid_direction = 1
var health_points = 3
var stamina_points = 2

var in_dash = false
var in_knockback = false
var in_delay_dmg = false

var _state: PlayerStates = PlayerStates.IDLE;

#TODO revert logic
var knockback_origin = Vector2.ZERO

func _ready() -> void:
	gun = get_node("Sprite2D/BubbleGun")
	timers = get_node("PlayerTimer")

func _physics_process(delta: float) -> void:
	if timers.knockback.is_stopped():
		process_action(delta)
		collider_manger()
		process_moviment(delta)
	else:
		knockback(delta)
	sprite_maneger()
		
func process_moviment(delta: float):
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction > 0:
		animated_sprite_2d.flip_h = false;
	elif direction < 0:
		animated_sprite_2d.flip_h = true;
	
	if direction:
		velocity.x = direction * SPEED
		if direction != 0:
			last_valid_direction = direction
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	
		
	move_and_slide()	
	
	if velocity.x != 0:
		set_state(PlayerStates.RUN);
	else:
		set_state(PlayerStates.IDLE);


func set_state(new_state: PlayerStates) -> void:
	if _state == new_state:
		return;
	
	_state = new_state;
	match _state:
		PlayerStates.IDLE:
			animated_sprite_2d.play("idle");
		PlayerStates.RUN:
			animated_sprite_2d.play("run");

func process_action(delta: float):
	if Input.is_action_just_pressed("ui_base_ranged"):
		gun.shoot(sprite_2d.scale.x)
	if !timers.dash.is_stopped():		
		global_position.x += SPEED* 1.5 * last_valid_direction * delta
		velocity.y *= 0
	elif Input.is_action_just_pressed("ui_base_melee"):
		timers.dash.start()		

#TODO refector with singal maneger
func collider_manger():
	for i in get_slide_collision_count():
		var collider = get_slide_collision(i).get_collider()
		if "deal_damage" in collider:
			timers.knockback.start()
			knockback_origin = position.direction_to(collider.position)
			if timers.dash.is_stopped():
				health_maneger(-collider.damage)

func health_maneger(hp:int):
	if hp > 0 or timers.delay_dmg.is_stopped():
		health_points += hp
		timers.delay_dmg.start()
	if health_points < 1:
		emit_signal("die")
	
func stamina_maneger():
	pass


#TODO do this like a human, usig animation
func sprite_maneger():
	if not is_zero_approx(velocity.x):
		if velocity.x > 0.0:
			sprite_2d.scale.x = 0.2
		else:
			sprite_2d.scale.x = -0.2
	if !timers.delay_dmg.is_stopped():
		sprite_2d.visible = !sprite_2d.visible
	else:
		sprite_2d.visible = true
	
#TODO use this to base explosion script
func knockback(delta: float):
	global_position += SPEED* -0.75 * knockback_origin.normalized() * delta


func _on_dash_timeout() -> void:
	var in_dash = false


func _on_delay_dmg_timeout() -> void:
	var in_knockback = false


func _on_knockback_timeout() -> void:
	knockback_origin = Vector2.ZERO
