extends CharacterBody2D
class_name Player

const SPEED = 200.0
const JUMP_VELOCITY = -400.0

enum PlayerStates { IDLE, RUN }
signal die


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var gun: BubbleGun = animated_sprite_2d.get_node("BubbleGun")
@onready var timers: PlayerTimer = $PlayerTimer

var health_points = 3
var stamina_points = 2

var knockback_origin = Vector2.ZERO
var _state: PlayerStates = PlayerStates.IDLE;

func _physics_process(delta: float) -> void:
	
	if timers.knockback.is_stopped():
		process_moviment(delta)
		process_action(delta)
		process_collision()
	else:
		knockback(delta)
		
	process_animation()
		
func process_moviment(delta: float):
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if timers.dash.is_stopped():
		var direction := Input.get_axis("ui_left", "ui_right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	else:
		velocity.x = SPEED * 2.5 * animated_sprite_2d.scale.x
		velocity.y *= 0
		
	move_and_slide()	
	
func process_animation():
	if velocity.x != 0:
		set_state(PlayerStates.RUN);
	else:
		set_state(PlayerStates.IDLE);
	
	if not is_zero_approx(velocity.x):
		if velocity.x > 0.0:
			animated_sprite_2d.scale.x = 1;
		else:
			animated_sprite_2d.scale.x = -1;
	if !timers.delay_dmg.is_stopped():
		animated_sprite_2d.visible = !animated_sprite_2d.visible
	else:
		animated_sprite_2d.visible = true

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
		gun.shoot(animated_sprite_2d.scale.x)
	elif Input.is_action_just_pressed("ui_base_melee") and timers.dash.is_stopped():
		timers.dash.start()

#TODO refector
func process_collision():
	for i in get_slide_collision_count():
		var collider = get_slide_collision(i).get_collider()
		if "deal_damage" in collider and timers.dash.time_left < 0.1:
			timers.knockback.start()
			knockback_origin = position.direction_to(collider.position)
			if timers.dash.is_stopped():
				process_health(-collider.damage)

func process_health(hp:int):
	if hp > 0 or timers.delay_dmg.is_stopped():
		health_points += hp
		timers.delay_dmg.start()
		
	if health_points < 1:
		#emit_signal("die")
		GameManeger._on_player_die()
	
func process_stamina():
	pass

	
#TODO use this to base explosion script
func knockback(delta: float):
	global_position += SPEED* -0.75 * knockback_origin.normalized() * delta


func _on_dash_timeout() -> void:
	velocity *= 0


func _on_delay_dmg_timeout() -> void:
	pass


func _on_knockback_timeout() -> void:
	knockback_origin = Vector2.ZERO
