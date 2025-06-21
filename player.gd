extends CharacterBody2D

enum{
	DOWN,
	UP,
	LEFT,
	RIGHT
}

@onready var anim = $AnimatedSprite2D
@onready var animP = $AnimationPlayer
@onready var stamina_bar = $CanvasLayer/stamina_bar
@onready var hp_bar = $CanvasLayer/hp_bar
@onready var money_text = $CanvasLayer/MoneyText


var idle_dir = DOWN
var can_move = true

var speed = 100
var max_stamina = 100
var stamina_minus = 30
var stamina_regen = 10

var heal_amount = 2
var heal_interval = 1
var max_health = Global.max_health
var is_healing = false
var is_pause

func _ready():
	Engine.time_scale = 1
	position = Global.player_position
	$CanvasLayer/PauseMenu.visible = false

func _physics_process(delta):
	money_text.text = str(Global.player_money) + "$"
	#buttons
	if Input.is_action_just_pressed("exit"):
		is_pause = !is_pause
		$CanvasLayer/PauseMenu.visible = is_pause
		Engine.time_scale = 0 if is_pause else 1
		can_move = not is_pause
	if Global.resume:
		is_pause = false
		can_move = true
		$CanvasLayer/PauseMenu.visible = false
		Engine.time_scale = 1
		Global.resume = false
	if Global.save:
		save_game()
	if Global.load:
		load_game()
	
	healing()
	$CanvasLayer/speed.text = "speed: " + str(speed)
	$CanvasLayer/stamina.text = "stamina: " + str(roundi(Global.player_stamina))
	$CanvasLayer/health.text = "health: " + str(Global.player_health)
	hp_bar.value = Global.player_health
	stamina_bar.value = Global.player_stamina
	stats()
	run(delta)
	if Global.player_health <= 0:
		die()
	
	if is_healing:
		$Node2D/health_plus.visible = true
	else:
		$Node2D/health_plus.visible = false
		
	if !can_move:
		return

	
	if Input.is_action_just_pressed("attack"):
		attack()
	elif Input.is_action_pressed("up"):
		up_move()
	elif Input.is_action_pressed("down"):
		down_move()
	elif Input.is_action_pressed("left"):
		left_move()
	elif Input.is_action_pressed("right"):
		right_move()
	else:
		idle()
		
	move_and_slide()
	Global.player_position = position

func die():
	Global.player_health = 0
	can_move = false
	animP.play("Death")
	await animP.animation_finished
	self.queue_free()
	Global.end = true

func run(delta):
	if Input.is_action_pressed("run") and Global.player_stamina > 0:
		speed = 150
		Global.player_stamina -= stamina_minus * delta
		if Global.player_stamina <= 0:
			Global.player_stamina = 0
			speed = 100
	else:
		speed = 100
		Global.player_stamina += stamina_regen * delta
		if Global.player_stamina >= max_stamina:
			Global.player_stamina = max_stamina
		

func healing():
	if is_healing:
		return
		
	is_healing = true
	
	while Global.player_health < max_health:
		$Node2D/AnimationHeal.play("heal_animation")
		await get_tree().create_timer(heal_interval).timeout
		Global.player_health += heal_amount
		if Global.player_health > max_health:
			Global.player_health = max_health
		hp_bar.value = Global.player_health
		
	is_healing = false

func up_move():
	animP.play("Up")
	velocity = Vector2(0, -speed)
	idle_dir = UP

func down_move():	
	animP.play("Down")
	velocity = Vector2(0, speed)
	idle_dir = DOWN

func left_move():
	anim.flip_h = true
	animP.play("Front")
	velocity = Vector2(-speed, 0)
	idle_dir = LEFT
	
func right_move():
	anim.flip_h = false
	animP.play("Front")
	velocity = Vector2(speed, 0)
	idle_dir = RIGHT
	
func idle():
	velocity = Vector2.ZERO
	if velocity == Vector2.ZERO:
		match idle_dir:
			DOWN:
				animP.play("Down_idle")
			UP:
				animP.play("Up_idle")
			RIGHT:
				anim.flip_h = false
				animP.play("Front_idle")
			LEFT:
				anim.flip_h = true
				animP.play("Front_idle")


func attack():
	can_move = false
	velocity = Vector2.ZERO
	if velocity == Vector2.ZERO:
		match idle_dir:
			DOWN:
				animP.play("Attack_down")
			UP:
				animP.play("Attack_up")
			RIGHT:
				
				animP.play("Attack_right")
			LEFT:
				anim.flip_h = true
				animP.play("Attack_left")
				
	await animP.animation_finished
	can_move = true

func stats():
	if Input.is_action_just_pressed("stats_text") and $CanvasLayer/speed.visible == false:
		$CanvasLayer/speed.visible = true
		$CanvasLayer/stamina.visible = true
		$CanvasLayer/health.visible = true
		$PointLight2D.visible = true
	elif Input.is_action_just_pressed("stats_text") and $CanvasLayer/speed.visible == true:
		$CanvasLayer/speed.visible = false
		$CanvasLayer/stamina.visible = false
		$CanvasLayer/health.visible = false
		$PointLight2D.visible = false
	
func _on_hitbox_body_entered(body):
	if body.has_method("take_damage"):
		var is_crit = randf() < 0.2
		var original_damage = Global.player_damage
		
		Global.player_damage *= 2 if is_crit else 1
		body.take_damage()
		
		var damage_to_display = Global.player_damage
		
		await get_tree().process_frame
		Global.player_damage = original_damage
		Global.damage_to_display = damage_to_display

var save_path = "user://savegame.save"

func save_game():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(Global.days_count)
	file.store_var(position.x)
	file.store_var(position.y)
	Global.save = false
	
func load_game():
	var file = FileAccess.open(save_path, FileAccess.READ)
	Global.days_count = file.get_var(Global.days_count)
	position.x = file.get_var(position.x)
	position.y = file.get_var(position.y)
	Global.load = false
