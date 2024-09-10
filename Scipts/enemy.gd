extends Node2D

@onready var ray_cast_right = $enemyBody2D/RayCastRight
@onready var ray_cast_left = $enemyBody2D/RayCastLeft
@onready var slime = $enemyBody2D/AnimatedSprite2D
@onready var body = $enemyBody2D
@onready var footsteps = $footsteps

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
#signal animation_done


@export var SPEED = 1500

@export var speedMult: float = 1



var direction = 1
var delay = 0
	
func _physics_process(delta):
	if delay < 0.5:
		delay += delta
	else:
		if not body.is_on_floor():
			body.velocity.y += gravity * delta
		
		if ray_cast_right.is_colliding():
			direction = -1
			slime.flip_h = true
			
			
		if ray_cast_left.is_colliding():
			direction = 1
			slime.flip_h = false
			

		body.velocity.x = (SPEED * speedMult * delta * direction)
		
		if speedMult > 1:
			slime.speed_scale = 1.7
			footsteps.pitch_scale = 1.7
		elif speedMult < 1:
			slime.speed_scale = .8
			footsteps.pitch_scale = .8
			
		else:
			slime.speed_scale = 1
			footsteps.pitch_scale = 1
		

		body.move_and_slide()


func _on_ground_check_body_exited(collidedBody: Node2D) -> void:
	if (collidedBody.is_in_group("ground")) and speedMult <= 1:
		slime.flip_h = not(slime.flip_h)
		direction *= -1
