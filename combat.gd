class_name Combat
extends Node

static var units = Navigation.units

# static var retaliation_modifier := 0.9

#enum UnitSpecies {INFANTRY, RECON, ANTIAIR, TANK, ARTILLERY, BOMBER, FIGHTER, BCOPTER} # 8 species

enum UnitTypes {Swarm, Crawler, Air}

enum Team {PLAYER, ENEMY, NEUTRAL}

static func get_absolute_distance_between_units(Unit1: Unit, Unit2: Unit) -> int:
	return abs(Unit1.X - Unit2.X) + abs(Unit1.Y - Unit2.Y)

static func make_unit_attack_other_unit(Unit1: Unit, Unit2: Unit):
	var damage_to_deal = ceil(Unit1.DAMAGE_TO_TYPES[Unit2.Type] * ((Unit1.HP + 10) / 110.0) )
	Unit2.HP -= damage_to_deal
	var retaliation_damage = ceil(Unit2.DAMAGE_TO_TYPES[Unit1.Type] * ((Unit2.HP + 10) / 110.0) )
	if retaliation_damage > 0:
		Unit1.HP -= retaliation_damage

func _ready() -> void:
	pass
	#$UI/ActionMenu.item_selected.connect()
