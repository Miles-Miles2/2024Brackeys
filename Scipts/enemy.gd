extends Node2D

@onready var ray_cast_right = $RayCastRight
@onready var ray_cast_left = $RayCastLeft
@onready var slime = $AnimatedSprite2D
@onready var body = $"."
@onready var footsteps = $footsteps

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
#signal animation_done


@export var SPEED = 1500



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
			slime.flip_h = not(slime.flip_h)
			
			
		if ray_cast_left.is_colliding():
			direction = 1
			slime.flip_h = not(slime.flip_h)
			

		body.velocity.x = (SPEED * delta * direction)

		

		body.move_and_slide()


func _on_ground_check_body_exited(collidedBody: Node2D) -> void:
	if (collidedBody.is_in_group("ground")):
		slime.flip_h = not(slime.flip_h)
		direction *= -1
