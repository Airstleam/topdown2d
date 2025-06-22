extends Node2D

@onready var anim = $AnimatedSprite2D



func _on_button_health_pressed():
	if Global.player_money >= 2:
		Global.player_money -= 5
		Global.max_health += 20


func _on_area_2d_body_entered(body):
	if body.name == "player":
		$Texts.visible = true
		$Buttons.visible = true


func _on_area_2d_body_exited(body):
	if body.name == "player":
		$Texts.visible = false
		$Buttons.visible = false


func _on_button_stamina_pressed():
	if Global.player_money >= 2:
		Global.player_money -= 2
		Global.max_stamina += 10


func _on_button_attack_pressed():
	if Global.player_money >= 2:
		Global.player_money -= 10
		Global.player_damage += 2
