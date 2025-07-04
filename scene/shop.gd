extends Node2D

@onready var anim = $AnimatedSprite2D
	


func _on_area_2d_body_entered(body):
	if body.name == "player":
		$ShopMenu.visible = true


func _on_area_2d_body_exited(body):
	if body.name == "player":
		$ShopMenu.visible = false
