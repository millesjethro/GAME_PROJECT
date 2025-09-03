extends Resource
class_name main_status

#Main Stats
@export var Strength: int = 0
@export var Agility: int = 0
@export var Wisdom: int = 0

#Sub Status
@export var Attack = 0
@export var HealthPoints = 0
@export var Defense = 0

#Other Status
@export var Dodge = 0.0
@export var CriticalChance = 0.01
@export var Critcal = 2.0
@export var DamageReduction = 0.0

#Currency
@export var gold = 0
@export var silver = 0
@export var bronze = 0

#Sub Status
var FinalAttack = 0
var FinalHealthPoints = 0
var FinalDefense = 0

# Gear Stats
@export var Armor: Dictionary = {
	"Defense": 0,
	"HealthPoints": 0,
	"Strength": 0,
	"Agility": 0,
	"Wisdom": 0
}
@export var Weapon: Dictionary = {
	"Attack": 0,
	"Strength": 0,
	"Agility": 0,
	"Wisdom": 0
}
@export var StatUp: Dictionary = {
	"Strength": 0,
	"Agility": 0,
	"Wisdom": 0
}

# ----------------------
# Final Stat Calculation
# ----------------------

func calc_final():
	#Health Points
	Strength = Armor["Strength"] + Weapon["Strength"] + StatUp["Strength"]
	Agility = Armor["Agility"] + Weapon["Agility"] + StatUp["Agility"]
	Wisdom = Armor["Wisdom"] + Weapon["Wisdom"] + StatUp["Wisdom"]
	
	FinalHealthPoints = ((Strength * 1.5) + HealthPoints) + Armor["HealthPoints"]
	FinalAttack =  ((Strength + (Agility/2))+Attack) + Weapon["Attack"]
	FinalDefense = ((Strength * 0.5)+(Agility*0.5) + Defense) + Armor["Defense"]
	
	print("Final Defense: ", FinalDefense)
	print("Final Health: ", FinalHealthPoints)
	print("Final Attack: ", FinalAttack)

# ----------------------
# JSON SAVE & LOAD
# ----------------------
func to_dict() -> Dictionary:
	return {
		"gold": gold,
		"silver": silver,
		"bronze": bronze
	}

func from_dict(data: Dictionary) -> void:
	gold = data.get("gold", gold)
	silver = data.get("silver", silver)
	bronze = data.get("bronze", bronze)

# Save to JSON
func save_to_json(file_path: String = "user://player_status.json") -> void:
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	if file:
		var json_text = JSON.stringify(to_dict(), "\t")
		file.store_string(json_text)
		file.close()
		print("✅ Saved to: ", file_path)

# Load from JSON
func load_from_json(file_path: String = "user://player_status.json") -> void:
	if not FileAccess.file_exists(file_path):
		push_error("⚠ No save file found at: " + file_path)
		return
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file:
		var json_text = file.get_as_text()
		var json = JSON.parse_string(json_text)
		if typeof(json) == TYPE_DICTIONARY:
			from_dict(json)
			print("✅ Loaded from: ", file_path)
		else:
			push_error("⚠ Failed to parse JSON!")
		file.close()
