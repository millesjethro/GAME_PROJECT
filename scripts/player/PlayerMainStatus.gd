extends Node
class_name  Player_Main_Status

#---------------------
# Main Status
#---------------------
@export var Strength = 7
@export var Agility = 6
@export var Intelligence = 4

func _ready() -> void:
	_load_status()
	
func _on_status_change():
	_save_status()

func _save_status():
	var config = ConfigFile.new()
	config.set_value("MainStatus", "Strength", Strength)
	config.set_value("MainStatus", "Agility", Agility)
	config.set_value("MainStatus", "Intelligence", Intelligence)
	config.save("user://PlayerStatus.cfg")

func _load_status():
	var config = ConfigFile.new()
	var err = config.load("user://PlayerStatus.cfg")
	if err == OK:
		Strength = config.get_value("MainStatus", "Strength", 0)
		Agility = config.get_value("MainStatus", "Agility", 0)
		Intelligence = config.get_value("MainStatus", "Intelligence", 0)
