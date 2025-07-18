extends Control

@onready var player_inv: Inv = preload("res://scene/player/inventory/playerinv.tres")
@onready var player_slots: Array = $PlayerInv/GridContainer.get_children()
	

func _process(delta):
	update_slots()
	for i in range(1, 10):
		if Input.is_action_just_pressed("select_item_%d" % i):
			select_item_by_index(i - 1)
			
			

func update_slots():
	for i in range(min(player_inv.slots.size(), player_slots.size())):
		player_slots[i].update_visual(player_inv.slots[i])


func select_item_by_index(index: int):
	if index < player_inv.slots.size():
		var slot = player_inv.slots[index]
		if slot.item:
			Global.active_item = slot.item
			print("Выбран предмет:", slot.item.name)
		else:
			Global.active_item = null
			print("Слот пустой")
