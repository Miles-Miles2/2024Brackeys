extends Area2D

var playerInWhirlwind: bool = false
var player: CharacterBody2D
@onready var suckPos: Node2D = $suckPosition

func _process(delta: float) -> void:
	if playerInWhirlwind:
		if (player.velocity.length() < 20):
			player.addVel((suckPos.global_position - player.global_position).normalized())
		#if player.velocity.length() > 20:
		#	player.setVel(player.velocity.normalized() * 20)


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.addModifier("whirlwind")
		playerInWhirlwind = true
		player = body



func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.removeModifier("whirlwind")
		playerInWhirlwind = false

