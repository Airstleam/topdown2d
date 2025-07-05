extends Area2D

@export var damage_fire_ball = 20
@export var speed: float = 100

var direction = Vector2.ZERO

func _physics_process(delta):
	position += speed * direction * delta

func _on_body_entered(body):
	if body.name == "player":
		Global.player_health -= damage_fire_ball
		queue_free()
	else:
		queue_free()
