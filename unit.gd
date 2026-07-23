class_name Unit
extends Node2D

# position
@export var X = 0:
	set(new_value):
		X = new_value
		_on_position_updated()
@export var Y = 0:
	set(new_value):
		Y = new_value
		_on_position_updated()

func _on_position_updated():
	position.x = X * 32
	position.y = Y * 32

func _ready() -> void:
	_on_position_updated()
