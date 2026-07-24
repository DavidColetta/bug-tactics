class_name Combat
extends Node

var units = Navigation.units

static var retaliation_modifier := 0.9

#enum UnitSpecies {INFANTRY, RECON, ANTIAIR, TANK, ARTILLERY, BOMBER, FIGHTER, BCOPTER} # 8 species

enum UnitTypes {Swarm, Crawlers, Air}

func get_distance_between_units(Unit1: Unit, Unit2: Unit) -> int:
	return abs(Unit1.X - Unit2.X) + abs(Unit1.Y - Unit2.Y)

func make_unit_attack_other_unit(Unit1: Unit, Unit2: Unit):
	Unit2.HP -= Unit1.DAMAGE_TO_TYPES[Unit2.Type]
	Unit1.HP -= Unit2.DAMAGE_TO_TYPES[Unit1.Type] * retaliation_modifier
