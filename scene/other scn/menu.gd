extends Node2D

func _ready():
	$AudioStreamPlayer.play()

func _process(delta):
	Engine.time_scale = 1
	$AnimatedSprite2D.play("Down_idle")
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
	elif Input.is_action_just_pressed("play"):
		get_tree().change_scene_to_file("res://scene/world.tscn")


func _on_exit_pressed():
	get_tree().quit()


func _on_play_pressed():
	get_tree().change_scene_to_file("res://scene/world.tscn")
