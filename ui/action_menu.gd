class_name ActionMenu
extends TextureRect

static var instance := self
static var attack_btn
static var capture_btn
static var back_btn
static var wait_btn

func _ready() -> void:
	instance = self
	attack_btn = $ButtonContainer/Attack
	capture_btn = $ButtonContainer/Capture
	back_btn = $ButtonContainer/Back
	wait_btn = $ButtonContainer/Wait
