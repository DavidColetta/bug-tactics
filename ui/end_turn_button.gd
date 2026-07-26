class_name EndTurn
extends Button

static var instance := self

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("turnend")
		$"../../Node2D".spawn_wave(1)

func _ready() -> void:
	instance = self
