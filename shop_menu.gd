class_name ShopMenu
extends ItemList

static var instance := self

@export var prefabs: Array[UnitShopData]

func _ready() -> void:
	instance = self
	
	for i in range(item_count):
		set_item_text(i, get_item_text(i)+" $%.2f" % (prefabs[i].cost/100.0))

func _on_shop_menu_item_selected(index: int) -> void:
	attempt_to_buy(index, Combat.Team.PLAYER)

func attempt_to_buy(index: int, team: Combat.Team) -> void:
	if team == Combat.Team.PLAYER:
		if Selection.player_pennies >= prefabs[index].cost:
			spawn_unit(index, Selection.selected_nest)
			Selection.player_pennies -= prefabs[index].cost

func spawn_unit(index: int, nest: Nest) -> void:
	var new_unit = prefabs[index].unit_scene.instantiate() as Unit
	new_unit.X = nest.get_pos().x
	new_unit.Y = nest.get_pos().y
	new_unit.moved = true
	$"../../Combatants".add_child(new_unit)
	deselect_all()
