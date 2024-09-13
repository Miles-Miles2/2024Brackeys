extends Node2D

@onready var arrow = $CharacterBody2D
@onready var player = $"../Player"
@onready var timer = $Timer


func _physics_process(delta):
	
	var arrow_y = arrow.position.y
	var player_y = player.position.y

	if player_y == arrow_y:
		print(arrow_y)
		print(player_y)
		
	
	
func arrow_shoot():

	timer.start()
	print("shhot")
	
