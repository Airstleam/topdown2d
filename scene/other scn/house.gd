extends Node2D

@onready var fridge_inv = preload("res://scene/player/inventory/fridgeinv.tres")

var outside = false

func _ready():
	$AudioStreamPlayer.play()

func _physics_process(delta):
	if outside and Input.is_action_just_pressed("E"):
		get_tree().change_scene_to_file("res://scene/world.tscn")
		Global.player_position = Vector2(364.0, 282.0)
		Global.in_home = false
	else:
		Global.in_home = true

func _on_area_2d_body_entered(body):
	if body.name == "player":
		$Label.visible = true
		outside = true

func _on_area_2d_body_exited(body):
	if body.name == "player":
		$Label.visible = false
		outside = false


func _on_fridge_repository_body_entered(body):
	if body.name == "player":
		Global.open_fridge = true
		$FridgeRepository/Inv_UI/FridgeInv.visible = true


func _on_fridge_repository_body_exited(body):
	if body.name == "player":
		Global.open_fridge = false
		$FridgeRepository/Inv_UI/FridgeInv.visible = false



func _on_cupboard_repository_body_entered(body):
	pass # Replace with function body.


func _on_cupboard_repository_body_exited(body):
	pass # Replace with function body.


func _on_commode_repository_body_entered(body):
	pass # Replace with function body.


func _on_commode_repository_body_exited(body):
	pass # Replace with function body.
