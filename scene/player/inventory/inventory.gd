extends Resource

class_name Inv

signal update #сигнал, который будет посылаться, когда инвентарь меняется (например, для UI)

@export var slots: Array[InvSlot] #массив слотов (ячейки)

func insert(item: InvItem): #вставить предмет в инвентарь
	var itemslots = slots.filter(func (slot): return slot.item == item) #Находит все слоты, в которых уже лежит этот предмет.
	if !itemslots.is_empty():
		itemslots[0].amount += 1 #Если такой слот есть — просто увеличивает amount
	else:
		var emptyslots = slots.filter(func(slot): return slot.item == null)
		if !emptyslots.is_empty():
			emptyslots[0].item = item
			emptyslots[0].amount = 1
	update.emit() #Это сигнал, который можно подключить к интерфейсу (UI), чтобы сказать: "Инвентарь обновился!
