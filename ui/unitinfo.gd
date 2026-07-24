extends Label

var format_str
var unit: Unit:
	set(new_unit):
		unit = new_unit
		update_text()


func update_text():
	text = "Name: " + unit.unit_name 
	text += "\nHealth: " + str(unit.health)
	text += "\nMovement: " + str(unit.num_moves)
	text += "\nType: " + unit.movement_type
	text += "\nVision: " + str(unit.vision)
