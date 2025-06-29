extends Node2D

func _on_area_2d_body_entered(body):
	if body.name == "player":
		$Area2D/CollisionShape2D.disabled = true
		Global.player_board += 1
		queue_free()
