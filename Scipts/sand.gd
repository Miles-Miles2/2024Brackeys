extends Node2D






func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.enterQuicksand()
		print("player in quicksand")
		body.SPEED_MODIFIER *= 0.2


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.exitQuicksand()
		body.SPEED_MODIFIER *= 5
