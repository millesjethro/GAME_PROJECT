extends Node
class_name  Player_Status

#---------------------
# Main Status
#---------------------
@export var Strength = 5
@export var Agility = 5
@export var Intelligence = 5

#---------------------
# Sub Status
#---------------------
var Attack = 0
var Defense = 0
var HeatlthPoints = 0

func _on_status_change():
	_save_status()

func _calc_damage() -> int:
	Attack = (Agility + Strength) * 0.75
	return Attack
	
func _calc_health() -> int:
	HeatlthPoints = Strength * 1.5
	return HeatlthPoints

func _calc_attack_speed() -> int:
	var jump_force = Agility * 1.25
	var knockback_force = Agility * 1.15
	return jump_force

func _save_status():
	var config = ConfigFile.new()
	config.set_value("Player", "Strength", Strength)
	config.set_value("Player", "Agility", Agility)
	config.set_value("Player", "Intelligence", Intelligence)
	config.save("user://player_stats.cfg")

func _load_status():
	var config = ConfigFile.new()
	var err = config.load("user://player_stats.cfg")
	if err == OK:
		Strength = config.get_value("Player", "Strength", 0)
		Agility = config.get_value("Player", "Agility", 0)
		Intelligence = config.get_value("Player", "Intelligence", 0)
