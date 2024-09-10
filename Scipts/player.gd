extends CharacterBody2D


const SPEED = 90.0
const JUMP_VELOCITY = -200.0
@onready var animated_sprite = $AnimatedSprite2D
@onready var timer = $Timer
@onready var jumpSFX = $jumpSFX

var addVelocityDebounce: int = 0

@export var platformSpeedMultiplyer = 1
@export var enemySpeedMultiplyer = 1
#@onready var animation_player = $AnimationPlayer

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

#shader stuff
#@onready var fisheye = get_viewport().get_camera_2d().find_child("fisheye").material
var targetFisheye: float = 0.01

var previouslyInAir = true


func _physics_process(delta):
	# Add the gravity.
	addVelocityDebounce = max(0, addVelocityDebounce - 1)
	
	if is_on_floor() and previouslyInAir:
		$CPUParticles2D.emitting = true
		previouslyInAir = false
	
	if not is_on_floor():
		if velocity.y > 0:
			velocity.y += gravity * delta * 1.2
		else:
			velocity.y += gravity * delta
		previouslyInAir = true

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jumpSFX.play()
		velocity.y += JUMP_VELOCITY
		
	if (Input.is_action_pressed("jump") and not is_on_floor()):
		velocity.y -= gravity*0.4*delta
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
		
		
	if is_on_floor():
		if direction == 0:
			pass
			animated_sprite.play("idle")	
		else:
			pass
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")
		
	
	
	if direction:
		if is_on_floor():
			velocity.x = direction * SPEED
		else:
			if abs(velocity.x + ((direction * SPEED)*0.01)) < SPEED:
				velocity.x += direction * SPEED * 0.1 #min((direction * SPEED)*0.01, direction*SPEED - velocity.x)
			elif abs(velocity.x	 + (direction * SPEED)*0.01) < abs(velocity.x):
				velocity.x += (direction * SPEED)*0.01
		
	else:
		if is_on_floor():
			velocity.x = 0
		else:
			velocity.x *= 0.95

	move_and_slide()
	
	if Input.is_action_just_pressed("reset"):
		Engine.time_scale = 1.0 
		get_tree().reload_current_scene()
	


