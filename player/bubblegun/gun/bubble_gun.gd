class_name BubbleGun extends Marker2D
## Represents a weapon that spawns and shoots bullets.
## The Cooldown timer controls the cooldown duration between shots.


const BULLET_VELOCITY = 600.0
const BULLET_SCENE = preload("res://player/bubblegun/bullet/bubble_bullet.tscn")

@onready var sound_shoot := $Shoot as AudioStreamPlayer2D
#@onready var timer := $Cooldown as Timer


# This method is only called by Player.gd.
func shoot(direction: float = 1.0) -> bool:
	#if not timer.is_stopped():
	#	return false
	var bullet := BULLET_SCENE.instantiate() as BubbleBullet
	bullet.global_position = global_position
	bullet.linear_velocity = Vector2(direction * BULLET_VELOCITY, -BULLET_VELOCITY/10)

	bullet.set_as_top_level(true)
	add_child(bullet)
	#timer.start()
	return true
