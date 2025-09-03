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
	"DamageReduction": 0,
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
@export var Accessories: Dictionary = {
	"DamageReduction": 0,
	"Critical": 0,
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

func calc_others():
	Dodge = min(75, ((Agility * 0.035) + (Wisdom * 0.035))) / 100
	CriticalChance = min(100, (Agility * 0.125)) / 100
	DamageReduction = Armor["DamageReduction"] + Accessories["DamageReduction"]
	Critcal += (Accessories["Critical"]/100)

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

# Save to compressed package
func save_to_package(file_path: String = "user://player_save.pkg") -> void:
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	if file:
		var data = to_dict()
		var json_text = JSON.stringify(data)
		var bytes = json_text.to_utf8_buffer()
		var compressed = bytes.compress(FileAccess.COMPRESSION_ZSTD)  # compress
		file.store_buffer(compressed)
		file.close()
		print("✅ Saved to package:", file_path)

# Load from compressed package
func load_from_package(file_path: String = "user://player_save.pkg") -> void:
	if not FileAccess.file_exists(file_path):
		push_error("⚠ No save file found at: " + file_path)
		return
	
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file:
		var compressed = file.get_buffer(file.get_length())
		var bytes = compressed.decompress_dynamic(-1, FileAccess.COMPRESSION_ZSTD)  # decompress
		
		var json_text = bytes.get_string_from_utf8()
		var json = JSON.parse_string(json_text)
		
		if typeof(json) == TYPE_DICTIONARY:
			from_dict(json)
			print("✅ Loaded package:", file_path)
		else:
			push_error("⚠ Failed to parse package!")
		
		file.close()
