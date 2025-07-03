extends Node2D

@onready var fridge_inv = preload("res://scene/player/inventory/fridgeinv.tres")
@onready var commode_inv = preload("res://scene/player/inventory/commode.tres")
@onready var cupboard_inv = preload("res://scene/player/inventory/cupboard.tres")



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
		$FridgeRepository/Inv_UI.set_other_inventory(fridge_inv)
		$FridgeRepository/Inv_UI/OtherInv.visible = true
		#Global.is_open_some_inv = true



func _on_fridge_repository_body_exited(body):
	if body.name == "player":
		$FridgeRepository/Inv_UI.other_inv = null
		$FridgeRepository/Inv_UI/OtherInv.visible = false


func _on_cupboard_repository_body_entered(body):
	if body.name == "player":
		$CommodeRepository/Inv_UI.set_other_inventory(cupboard_inv)
		$CupboardRepository/Inv_UI/OtherInv.visible = true

func _on_cupboard_repository_body_exited(body):
	if body.name == "player":
		$CommodeRepository/Inv_UI.other_inv = null
		$CupboardRepository/Inv_UI/OtherInv.visible = false


func _on_commode_repository_body_entered(body):
	if body.name == "player":
		$CommodeRepository/Inv_UI/OtherInv.visible = true



func _on_commode_repository_body_exited(body):
	if body.name == "player":
		$CommodeRepository/Inv_UI.other_inv = null
		$CommodeRepository/Inv_UI/OtherInv.visible = false
