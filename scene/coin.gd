extends Node2D

@onready var animP = $AnimationPlayer

func _on_area_2d_body_entered(body):
	if body.name == "player":
		$Area2D/CollisionShape2D.disabled = true
		animP.play("Up")
		Global.player_money += 1
		await animP.animation_finished
		queue_free()
