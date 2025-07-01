extends StaticBody2D

var board = preload("res://scene/collactables/board.tscn")
@onready var audio_stream_player = $AudioStreamPlayer


var health = 3

func _process(delta):
	if health <= 0:
		death()
		
func death():
	if !audio_stream_player.playing:
		audio_stream_player.play()
	await get_tree().create_timer(audio_stream_player.stream.get_length()).timeout
	var board_res = board.instantiate()
	get_tree().current_scene.add_child(board_res)
	board_res.global_position = global_position
	queue_free()
		
func take_damage_tree():
	print(health)
	health -= Global.player_damage_ax
		
