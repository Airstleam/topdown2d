extends Node2D

var triggered := false

func _on_area_2d_body_entered(body):
	if body.name == "player":
		Global.player_money += 1
		queue_free()
