extends Panel

@onready var item_visual: Sprite2D = $CenterContainer/Panel/item_desplay
@onready var amount_text: Label = $CenterContainer/Panel/Label
var slot_data: InvSlot

func update(slot: InvSlot):
	slot_data = slot
	if !slot.item:
		item_visual.visible = false
		amount_text.visible = false
	else:
		item_visual.visible = true
		item_visual.texture = slot.item.texture
		amount_text.visible = slot.amount > 1
		amount_text.text = str(slot.amount)

func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if slot_data.item:
			Global.active_item = slot_data.item
			print("Активный предмет:", slot_data.item.name)
