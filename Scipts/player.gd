extends CharacterBody2D


@export var SPEED = 90.0
const JUMP_VELOCITY = -200.0
@export var DASH_VELOCITY: float
@onready var animated_sprite = $AnimatedSprite2D
@onready var timer = $Timer
@onready var jumpSFX = $jumpSFX

var addVelocityDebounce: int = 0

var dashTime = 0
var canDash = false

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
	
	var inputVector = Input.get_vector("move_left", "move_right", "jump", "down")
	
	if dashTime > 0:
		dashTime -= delta
	
	if is_on_floor() and previouslyInAir:
		$CPUParticles2D.emitting = true
		previouslyInAir = false
	
	if not is_on_floor() and dashTime <= 0:
		#make falling after dashing slower
		if velocity.y > 0 and not canDash == false:
			velocity.y += gravity * delta * 1.2
		else:
			velocity.y += gravity * delta
		previouslyInAir = true

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jumpSFX.play()
		velocity.y += JUMP_VELOCITY
		
	if (Input.is_action_pressed("jump") and not is_on_floor() and dashTime <= 0):
		velocity.y -= gravity*0.4*delta
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
		
		
	if is_on_floor():
		canDash = true
		if direction == 0:
			pass
			animated_sprite.play("idle")	
		else:
			pass
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")
		
	
	
	if direction and dashTime <= 0:
		if is_on_floor():
			velocity.x = direction * SPEED
		elif abs(velocity.x) < SPEED or abs(velocity.x + direction*delta*2000) < abs(velocity.x):
			velocity.x += direction*delta*1000
			
			#OLD CODE - allow speedup past max speed
			'''
			if abs(velocity.x + (direction * SPEED*0.1)) < SPEED:
				velocity.x += direction * SPEED * 0.1 #min((direction * SPEED)*0.01, direction*SPEED - velocity.x)
			elif abs(velocity.x	 + (direction * SPEED)*0.01) < abs(velocity.x):
				velocity.x += (direction * SPEED)*0.01
			'''
		
	else:
		if is_on_floor() and dashTime <= 0:
			velocity.x = 0
			
	#movement damping
	if dashTime <= 0:
		if abs(velocity.x) > SPEED:
			velocity.x *= 0.9
	
	#   DASH
	if Input.is_action_just_pressed("dash") and canDash:
		dashTime = 0.05
		velocity.y = 0
		velocity.x = 0
		velocity += inputVector * DASH_VELOCITY
		canDash = false

	move_and_slide()
	
	if Input.is_action_just_pressed("reset"):
		Engine.time_scale = 1.0 
		get_tree().reload_current_scene()
	


