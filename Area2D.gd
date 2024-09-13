extends Area2D

@onready var mumms = get_tree().get_nodes_in_group("mummy")
@onready var gemsfx = $AnimationPlayer

func _on_body_entered(body):
	gemsfx.play("pickup")
	for x in mumms:
		x.crystal_collected = true
