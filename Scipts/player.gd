extends CharacterBody2D


@export var SPEED = 90.0
const JUMP_VELOCITY = -200.0
@export var DASH_VELOCITY: float
@onready var animated_sprite = $AnimatedSprite2D
@onready var timer = $Timer
@onready var jumpSFX = $jumpSFX
@export var SPEED_MODIFIER = 1
@export var MAX_QUICKSAND_SPEED: float

var movementModifiers: Array = []


var addVelocityDebounce: int = 0

#dash
var dashTime = 0
var canDash = false

#quicksand
var isInQuicksand: bool = false
var normalMovement: bool = true

#@onready var animation_player = $AnimationPlayer

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

#shader stuff
#@onready var fisheye = get_viewport().get_camera_2d().find_child("fisheye").material
var targetFisheye: float = 0.01

var previouslyInAir = true


func _physics_process(delta):
	
	if len(movementModifiers) == 0:
		normalMovement = true
	else:
		normalMovement = false
	# Add the gravity.
	addVelocityDebounce = max(0, addVelocityDebounce - 1)
	
	
	
	var inputVector = Input.get_vector("move_left", "move_right", "jump", "down")
	
	if dashTime > 0:
		dashTime -= delta
	
	if is_on_floor() and previouslyInAir:
		$CPUParticles2D.emitting = true
		previouslyInAir = false
	
	if not is_on_floor() and dashTime <= 0 and normalMovement:
		#make falling after dashing slower
		if velocity.y > 0 and not canDash == false:
			velocity.y += gravity * delta * 1.2 * SPEED_MODIFIER
		else:
			velocity.y += gravity * delta * SPEED_MODIFIER
		previouslyInAir = true

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor() and normalMovement:
		jumpSFX.play()
		velocity.y += JUMP_VELOCITY
		
	if (Input.is_action_pressed("jump") and not is_on_floor() and dashTime <= 0 and normalMovement):
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
		
	
	if normalMovement:
		if direction and dashTime <= 0:
			if is_on_floor():
				velocity.x = direction * SPEED * SPEED_MODIFIER
			elif abs(velocity.x) < SPEED * SPEED_MODIFIER or abs(velocity.x + direction*delta*2000) < abs(velocity.x):
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
	
	if not normalMovement:
		if isInQuicksand:
			velocity.y += min(5, 15-velocity.y)
			if Input.is_action_just_pressed("jump"):
				velocity.y += JUMP_VELOCITY * 0.5
			velocity.x += (direction*SPEED - velocity.x) * 0.2
			#quicksand dash
			if Input.is_action_just_pressed("dash"):
				dashTime = 0.05
				velocity.y = 0
				velocity.x = 0
				velocity += inputVector * DASH_VELOCITY
				canDash = false
				
	if movementModifiers.has("whirlwind"):
		velocity *= 0.9
		if Input.is_action_just_pressed("dash") and canDash:
				dashTime = 0.05
				velocity.y = 0
				velocity.x = 0
				velocity += inputVector * DASH_VELOCITY
				canDash = false
	
	#movement damping
	if dashTime <= 0:
		if abs(velocity.x) > SPEED * SPEED_MODIFIER:
			velocity.x *= 0.9
	
	#   DASH
	if Input.is_action_just_pressed("dash") and canDash and normalMovement:
		dashTime = 0.05
		velocity.y = 0
		velocity.x = 0
		velocity += inputVector * DASH_VELOCITY
		canDash = false
		

	move_and_slide()
	
	if Input.is_action_just_pressed("reset"):
		Engine.time_scale = 1.0 
		get_tree().reload_current_scene()
	
	
func enterQuicksand():
	velocity.y = clamp(velocity.y, 1000, MAX_QUICKSAND_SPEED)
	movementModifiers.append("quicksand")
	isInQuicksand = true
	
func exitQuicksand():
	movementModifiers.erase("quicksand")
	isInQuicksand = false

func addModifier(mod: String):
	movementModifiers.append(mod)

func removeModifier(mod: String):
	movementModifiers.erase(mod)

func setVel(vel: Vector2):
	velocity = vel

func addVel(vel: Vector2):
	velocity += vel

