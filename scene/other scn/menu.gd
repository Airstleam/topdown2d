extends Node2D

func _ready():
	$AudioStreamPlayer.play()

func _process(delta):
	Engine.time_scale = 1
	$AnimatedSprite2D.play("Down_idle")
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
	elif Input.is_action_just_pressed("play"):
		if Global.in_home == false:
			get_tree().change_scene_to_file("res://scene/world.tscn")
		elif Global.in_home == true:
			get_tree().change_scene_to_file("res://scene/other scn/house.tscn")


func _on_exit_pressed():
	get_tree().quit()


func _on_play_pressed():
	if Global.in_home == false:
		get_tree().change_scene_to_file("res://scene/world.tscn")
	elif Global.in_home == true:
		get_tree().change_scene_to_file("res://scene/other scn/house.tscn")
