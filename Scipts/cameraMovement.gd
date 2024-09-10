extends Camera2D

@export var player: Node2D

# Called when the node enters the scene tree for the first time.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position = position.lerp(player.position, 5*delta)
