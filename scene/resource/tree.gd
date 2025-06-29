extends StaticBody2D

var board = preload("res://scene/collactables/board.tscn")

var health = 3

func _process(delta):
	if health <= 0:
		death()
		
func death():
	var board_res = board.instantiate()
	get_tree().current_scene.add_child(board_res)
	board_res.global_position = global_position
	queue_free()
		
func take_damage_tree():
	print(health)
	health -= Global.player_damage_ax
		
