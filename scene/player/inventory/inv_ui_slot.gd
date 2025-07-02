extends Panel

@onready var item_visual: Sprite2D = $CenterContainer/Panel/item_desplay
@onready var amount_text: Label = $CenterContainer/Panel/Label
@onready var player_inv: Inv = preload("res://scene/player/inventory/playerinv.tres")
@onready var fridge_inv: Inv = preload("res://scene/player/inventory/fridgeinv.tres")

var slot_data: InvSlot
var is_from_player := true
var inv_ui: Node

func update(slot: InvSlot):
	slot_data = slot
	if !slot.item:
		item_visual.visible = false
		amount_text.visible = false
	else:
		item_visual.visible = true
		item_visual.texture = slot.item.texture
		var tex_size = slot.item.texture.get_size()
		var target_size = Vector2(35, 35)
		item_visual.scale = target_size / tex_size
		amount_text.visible = slot.amount > 1
		amount_text.text = str(slot.amount)

func _gui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if slot_data.item:
			Global.active_item = slot_data.item
			
			#move_item_to(fridge_inv.other_inv)
		#else:
			#move_item_to(player_inv.current_inv)

func move_item_to(target_inv: Inv):
	for slot in target_inv.slots:
		if slot.item == null:
			slot.item = slot_data.item
			slot.amount = slot_data.amount
			slot_data.item = null
			slot_data.amount = 0
			inv_ui.update_slots()
			break
