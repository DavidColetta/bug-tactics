class_name Combat
extends Node

static var units = Navigation.units

# static var retaliation_modifier := 0.9

#enum UnitSpecies {INFANTRY, RECON, ANTIAIR, TANK, ARTILLERY, BOMBER, FIGHTER, BCOPTER} # 8 species

enum UnitTypes {Swarm, Crawler, Air}

static func get_absolute_distance_between_units(Unit1: Unit, Unit2: Unit) -> int:
	return abs(Unit1.X - Unit2.X) + abs(Unit1.Y - Unit2.Y)

static func make_unit_attack_other_unit(Unit1: Unit, Unit2: Unit):
	Unit2.HP -= ceil(Unit1.DAMAGE_TO_TYPES[Unit2.Type] * ((Unit1.HP + 10) / 110.0) )
	Unit1.HP -= ceil(Unit2.DAMAGE_TO_TYPES[Unit1.Type] * ((Unit2.HP + 10) / 110.0) )
