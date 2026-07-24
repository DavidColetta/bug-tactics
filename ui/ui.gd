extends CanvasLayer

func _ready() -> void:
	visible = false
	Events.unit_clicked.connect(show_ui)
	Events.empty_clicked.connect(hide_ui)
	
func show_ui(new_unit):
	visible = true
	$UnitInfo.unit = new_unit
	
func hide_ui():
	visible = false
