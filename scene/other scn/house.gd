extends Node2D

var outside = false

func _ready():
	$AudioStreamPlayer.play()

func _physics_process(delta):
	if outside and Input.is_action_just_pressed("E"):
		get_tree().change_scene_to_file("res://scene/world.tscn")
		Global.player_position = Vector2(362.0, 274.0)

func _on_area_2d_body_entered(body):
	if body.name == "player":
		$Label.visible = true
		outside = true
		


func _on_area_2d_body_exited(body):
	if body.name == "player":
		$Label.visible = false
		outside = false
