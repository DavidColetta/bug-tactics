extends CanvasLayer

func _ready() -> void:
	$UnitInfo.visible = false
	$ActionMenu.visible = false
	$ShopMenu.visible = false
	Events.unit_clicked.connect(show_ui)
	Events.empty_clicked.connect(hide_ui)
	
func show_ui(new_unit):
	$UnitInfo.visible = true
	$UnitInfo.unit = new_unit
	
func hide_ui():
	$UnitInfo.visible = false
	$ActionMenu.visible = false

func _on_action_menu_item_selected(index: int) -> void:
	$ActionMenu.visible = false
	$ActionMenu.deselect_all()
