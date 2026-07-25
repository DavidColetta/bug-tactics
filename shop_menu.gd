class_name ShopMenu
extends ItemList

static var instance := self

@export var prefabs: Array[PackedScene]

func _ready() -> void:
	instance = self

func _on_shop_menu_item_selected(index: int) -> void:
	var new_unit = prefabs[index].instantiate() as Unit
	new_unit.X = Selection.selected_nest.get_pos().x
	new_unit.Y = Selection.selected_nest.get_pos().y
	new_unit.moved = true
	$"../../Combatants".add_child(new_unit)
	deselect_all()
