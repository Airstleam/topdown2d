extends Control
class_name InvForMoveItem

@onready var player_inv: Inv = preload("res://scene/player/inventory/playerinv.tres")
var other_inv: Inv = null

@onready var player_slots: Array = $PlayerInv/GridContainer.get_children()
@onready var other_slots: Array = $OtherInv/GridContainer.get_children()

func set_other_inventory(inv: Inv):
	other_inv = inv
	Global.is_open_some_inv = true


func _process(delta):
	update_slots()
	for i in range(1, 10):
		if Input.is_action_just_pressed("select_item_%d" % i):
			select_item_by_index(i - 1)

func update_slots():
	for i in range(min(player_inv.slots.size(), player_slots.size())):
		player_slots[i].init(player_inv.slots[i], true, self)
		
	if Global.is_open_some_inv and other_inv != null:
		for i in range(min(other_inv.slots.size(), other_slots.size())):
			other_slots[i].init(other_inv.slots[i], false, self)


func select_item_by_index(index: int):
	if index < player_inv.slots.size():
		var slot = player_inv.slots[index]
		if slot.item:
			Global.active_item = slot.item
			print("Выбран предмет:", slot.item.name)
		else:
			Global.active_item = null
			print("Слот пустой")
