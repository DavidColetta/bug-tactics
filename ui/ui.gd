extends CanvasLayer
class_name UI

static var instance := self

func _ready() -> void:
	instance = self
	$UnitInfo.visible = false
	ActionMenu.instance.visible = false
	$ShopMenu.visible = false
	Events.unit_clicked.connect(show_ui)
	Events.empty_clicked.connect(hide_ui)
	
func show_ui(new_unit):
	$UnitInfo.visible = true
	$UnitInfo.unit = new_unit
	
func hide_ui():
	$UnitInfo.visible = false
	ActionMenu.instance.visible = false

func _on_action_menu_button_pressed():
	ActionMenu.instance.visible = false
