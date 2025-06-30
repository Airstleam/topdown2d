extends Node2D

@export var item: InvItem
var player = null

func _on_area_2d_body_entered(body):
	if body.name == "player":
		player = body
		$Area2D/CollisionShape2D.disabled = true
		Global.player_gold += 1
		playercollect()
		queue_free()

func playercollect():
	player.collect(item)
