extends Control

@onready var player_inv: Inv = preload("res://scene/player/inventory/playerinv.tres")
@onready var fridge_inv: Inv = preload("res://scene/player/inventory/fridgeinv.tres")
@onready var player_slots: Array = $PlayerInv/GridContainer.get_children()
@onready var fridge_slots: Array = $FridgeInv/GridContainer.get_children()

var current_inv: Inv = null
var other_inv: Inv = null

func _process(delta):
	for i in range(1, 10):
		if Input.is_action_just_pressed("select_item_%d" % i):
			select_item_by_index(i - 1)

func _ready():
	player_inv.update.connect(update_slots)
	current_inv = player_inv
	update_slots()
	
func update_slots():
	for i in range(min(player_inv.slots.size(), player_slots.size())):
		#player_slots[i].inv_ui = self
		player_slots[i].update(player_inv.slots[i])

	#for i in range(min(other_inv.slots.size(), fridge_slots.size())):
		#fridge_slots[i].inv_ui = self
		#fridge_slots[i].update(other_inv.slots[i])

func select_item_by_index(index: int):
	if index < player_inv.slots.size():
		var slot = player_inv.slots[index]
		if slot.item:
			Global.active_item = slot.item
			print("Выбран предмет:", slot.item.name)
		else:
			Global.active_item = null
			print("Слот пустой")
