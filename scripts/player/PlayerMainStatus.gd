extends Node
class_name  Player_Main_Status

#---------------------
# Main Status
#---------------------
@export var Strength = 7
@export var Agility = 6
@export var Intelligence = 4
#---------------------
# Extra Main Status
#---------------------
var ItemAddStrength = 0
var PassiveAddStrength = 0

var ItemAddAgility = 0
var PassiveAddAgility = 0

var ItemAddIntelligence = 0
var PassiveAddIntelligence = 0

# ---------------------
# Final Main Status Calculation
# ---------------------
func _calc_FinalStrength() -> int:
	return Strength + ItemAddStrength + PassiveAddStrength

func _calc_FinalAgility() -> int:
	return Agility + ItemAddAgility + PassiveAddAgility

func _calc_FinalIntelligence() -> int:
	return Intelligence + ItemAddIntelligence + PassiveAddIntelligence

# ---------------------
# Main Status Upgrades
# ---------------------
func _upgrade_Strength(byNumber: int):
	if byNumber == 1:
		Strength += 1
	elif byNumber == 5:
		Strength += 5
	else:
		Strength += 10

func _upgrade_Agility(byNumber: int):
	if byNumber == 1:
		Agility += 1
	elif byNumber == 5:
		Agility += 5
	else:
		Agility += 10

func _upgrade_Intelligence(byNumber: int):
	if byNumber == 1:
		Intelligence += 1
	elif byNumber == 5:
		Intelligence += 5
	else:
		Intelligence += 10


# ---------------------
# Final Main Status Calculation
# ---------------------
func _calc_FinalMainStrength() -> int:
	return Strength + ItemAddStrength + PassiveAddStrength

func _calc_FinalMainAgility() -> int:
	return Agility + ItemAddAgility + PassiveAddAgility

func _calc_FinalMainIntelligence() -> int:
	return Intelligence + ItemAddIntelligence + PassiveAddIntelligence
	
	
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
