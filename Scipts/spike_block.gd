extends Sprite2D


@onready var player: CharacterBody2D
var cooldown: float = 0


func _ready() -> void:
	player = get_tree().get_nodes_in_group("player")[0]
	print(player.name)

var vel: Vector2 = Vector2(0,0)
var dir: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	if cooldown > 0:
		cooldown -= delta
	
	if dir == Vector2.ZERO and cooldown <= 0:
		if abs(position.x - player.position.x) < 10:
			cooldown += 5
			if position.y > player.position.y:
				dir = Vector2(0, -1)
			else:
				dir = Vector2(0,1)
		elif abs(position.y - player.position.y) < 10:
			cooldown += 5
			if position.x > player.position.x:
				dir = Vector2(-1, 0)
			else:
				dir = Vector2(1, 0)
	vel += dir * 0.1
	
	vel = vel.clamp(Vector2(-10, -10), Vector2(10, 10))
	
	position += vel


func _on_collision_body_entered(body: Node2D) -> void:
	print("collided")
	position -= vel
	vel = Vector2.ZERO
	dir = Vector2.ZERO
