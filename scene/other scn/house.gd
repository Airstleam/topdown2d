extends Node2D

@onready var fridge_inv = preload("res://scene/player/inventory/fridgeinv.tres")
@onready var commode_inv = preload("res://scene/player/inventory/commode.tres")
@onready var cupboard_inv = preload("res://scene/player/inventory/cupboard.tres")

var outside = false

func _ready():
	$AudioStreamPlayer.play()

func _physics_process(delta):
	if outside and Input.is_action_just_pressed("E"):
		$TextHome/AudioStreamPlayer.play()
		$TextHome/AudioStreamPlayer/TimerOpen.start()
		await $TextHome/AudioStreamPlayer/TimerOpen.timeout
		get_tree().change_scene_to_file("res://scene/world.tscn")
		Global.player_position = Vector2(364.0, 282.0)
		Global.in_home = false
	else:
		Global.in_home = true

func _on_area_2d_body_entered(body):
	if body.name == "player":
		$TextHome.visible = true
		outside = true

func _on_area_2d_body_exited(body):
	if body.name == "player":
		$TextHome.visible = false
		outside = false
