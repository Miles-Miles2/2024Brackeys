extends Node2D

@onready var ray_cast_right = $enemyBody2D/RayCastRight
@onready var ray_cast_left = $enemyBody2D/RayCastLeft
@onready var slime = $enemyBody2D/AnimatedSprite2D
@onready var body = $enemyBody2D
@onready var footsteps = $footsteps
@onready var player = $"../Player"

@export var crystal_collected = false

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
#signal animation_done


@export var SPEED = 1500
var gemspeed = 1


var direction = -1
var delay = 0
	
func _physics_process(delta):
	
	
	var mummy_x = body.global_position.x
	var player_x = player.global_position.x
	

	if delay < 0.5:
		delay += delta
	else:
		if not body.is_on_floor():
			body.velocity.y += gravity * delta
		
		if not(crystal_collected):
			if ray_cast_right.is_colliding():
				direction = -1
				slime.flip_h = not(slime.flip_h)
				
				
			if ray_cast_left.is_colliding():
				direction = 1
				slime.flip_h = not(slime.flip_h)
				
		
		else:
			gemspeed = 2
			if (player_x < mummy_x):
				direction = -1
				slime.flip_h = false
				
				
			elif (player_x > mummy_x):
				direction = 1
				slime.flip_h = true
			
		body.velocity.x = ((SPEED * gemspeed) * delta * direction)
			

		

		body.move_and_slide()



