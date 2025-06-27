extends CharacterBody2D

@onready var anim = $AnimatedSprite2D
@onready var animP = $AnimationPlayer
@onready var particle_for_death = $ParticleForDeath


var speed = 20
var health = 100
var damage = 1

var can_move = true
var death = false
var player_in = false


func _physics_process(delta):
	
	if health <= 0:	
		if not death:
			death = true
			die()
		return
		
	if death:
		animP.stop()
	
	if !can_move:
		return
	else:
		var direction = (Global.player_position - position).normalized()
		velocity = direction * speed
		animP.play("move")
		anim.flip_h = direction.x < 0
		
	move_and_slide()	

func die():
	Global.damage = false
	can_move = false
	health = 0
	animP.play("death")
	await animP.animation_finished
	await get_tree().create_timer(4).timeout
	print("You win")
	queue_free()
	
func _on_zone_body_entered(body):
	if body.name == "player":
		player_in = true
		attack()
	
func _on_zone_body_exited(body):
	if body.name == "player":
		player_in = false
	
func attack():
	while player_in:
		player_in = true
		can_move = false
		velocity = Vector2.ZERO	
		animP.play("attack")
		await animP.animation_finished
	can_move = true
	Global.damage = false
	
func take_damage():
	health -= Global.player_damage
	print(health)
	await get_tree().create_timer(1).timeout
	if health <= 0:
		Global.slime_count -= 1
	
func shaking_true():
	if Global.player_is_dead == false:
		Global.damage = true
	else:
		Global.damage = false
	
func shaking_false():
	Global.damage = false


func _on_hit_box_body_entered(body):
	if body.name == "player":
		Global.player_health -= damage
