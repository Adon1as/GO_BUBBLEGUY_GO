extends CharacterBody2D

class_name NewPlayer;

enum PlayerState { IDLE, RUN, JUMP, FALL, HURT }

@onready var debug_label: Label = $DebugLabel
@onready var hurt_timer: Timer = $HurtTimer

const SPEED: float = 200.0
const JUMP_VELOCITY: float = -400.0
const HURT_JUMP_VELOCITY: float = -130.0
const DASH_SPEED_MULTIPLIER: float = 2.5;
const BASE_KNOCKBACK: Vector2 = Vector2(300, -130);

var _state: PlayerState = PlayerState.IDLE;
var _can_dash: bool = true;
var _is_dashing: bool = false;
var _knockback: Vector2 = Vector2.ZERO;




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_debug_label();
	SignalManager.on_enemy_collided_with_player.connect(on_enemy_collided_with_player);
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	#	velocity.y = JUMP_VELOCITY
	#var direction := Input.get_axis("ui_left", "ui_right")
	#print("direction");
	#print(direction);
	#if direction:
	#	velocity.x = direction * SPEED
	#else:
	#	velocity.x = move_toward(velocity.x, 0, SPEED)
	
	get_input();
	
	move_and_slide();
	calculate_states();
	update_debug_label();
	
func update_debug_label() -> void:
	debug_label.text = "state: %s\nVel: %.1f,%.1f\nKnck: %.1f,%.1f" % [PlayerState.keys()[_state], velocity.x, velocity.y, _knockback.x, _knockback.y];
	
func get_input() -> void:
	if _state == PlayerState.HURT: 
		return;
	
	
	#velocity.x = 0; ?
	var direction := Input.get_axis("ui_left", "ui_right");
	if direction == 0:
		velocity.x = 0;
	elif direction < 0:
		velocity.x = -SPEED;
	elif direction > 0:
		velocity.x = SPEED;
	
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY;

func calculate_states() -> void:
	if _state == PlayerState.HURT:
		return;
	
	if is_on_floor() == true:
		if velocity.x == 0:
			set_state(PlayerState.IDLE);
		else:
			set_state(PlayerState.RUN);
	else:
		if velocity.y > 0:
			set_state(PlayerState.FALL);
		else: 
			set_state(PlayerState.JUMP);
	
func set_state(new_state: PlayerState) -> void:
	if new_state == _state:
		return;
	
	if _state == PlayerState.FALL:
		if new_state == PlayerState.IDLE or new_state == PlayerState.RUN:
			#SoundManager.play_clip(sound, SoundManager.SOUND_LAND);
			pass;
		
	_state = new_state;
	match _state:
		PlayerState.IDLE:
			#animation_player.play("idle");
			pass;
		PlayerState.RUN:
			#animation_player.play("run");
			pass;
		PlayerState.JUMP:
			#animation_player.play("jump");
			pass;
		PlayerState.FALL:
			#animation_player.play("fall");
			pass;
		PlayerState.HURT:
			#apply_hurt_jump();
			pass;
			
			
func apply_hurt() -> void:
	
	#velocity.x = SPEED * -1 
	pass;
	
#Custom Signals
func on_enemy_collided_with_player(damage: int, force: float, gl_pos: Vector2) -> void:
	set_state(PlayerState.HURT);
	var direction = -global_position.direction_to(gl_pos);
	var enemy_force = direction * force;
	enemy_force.y = HURT_JUMP_VELOCITY;
	velocity = enemy_force;
	hurt_timer.start();
	move_and_slide();
	

#Nodes Signals
func _on_hit_box_area_entered(area: Area2D) -> void:
	print("player_hit_box_entered");
	var hitBoxParent = area.get_parent();
	if hitBoxParent is EnemyBase:
		print("I have been hit by an enemy :c");
	pass # Replace with function body.


func _on_hit_box_body_entered(body: Node2D) -> void:
	var isEnemy = body is EnemyBase;
	pass # Replace with function body.


func _on_hurt_timer_timeout() -> void:
	set_state(PlayerState.IDLE);
	pass # Replace with function body.
