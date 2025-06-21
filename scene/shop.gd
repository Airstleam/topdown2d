extends Node2D

@onready var anim = $AnimatedSprite2D

func _ready():
	pass


func _on_button_health_pressed():
	if Global.player_money >= 2:
		Global.player_money -= 2
		Global.max_health += 20


func _on_area_2d_body_entered(body):
	if body.name == "player":
		$Node2D.visible = true


func _on_area_2d_body_exited(body):
	if body.name == "player":
		$Node2D.visible = false
