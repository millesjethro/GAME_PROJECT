extends Node
# ---------------------
# Finalized Stats
# ---------------------
var FinalAttack: int = 0
var FinalHealthPoints: int = 0
var FinalDefense: int = 0
var DodgeChance: float = 0.0
var DamageReduction: float = 0.0
var CritChance: float = 0.0
var Critical: float = 0.0

# ---------------------
# Setup
# ---------------------
func _ready():
	pass
# ---------------------
# Recalculate Final Stats
# ---------------------
func _calc_stats(value: Dictionary) -> void:
	FinalAttack       = value["FinalAttack"]
	FinalDefense      = value["FinalDefense"]
	FinalHealthPoints = value["FinalHealthPoints"]
	CritChance        = value["CritChance"]
	DodgeChance       = value["DodgeChance"]
	DamageReduction   = value["DamageReduction"]
	Critical          = value["Critical"]

# ---------------------
# Damage To Enemy
# ---------------------
func calc_damage() -> int:
	var roll = randf()  # already returns [0, 1), no need for round()
	if roll <= CritChance:
		return int(FinalAttack * Critical)
	return FinalAttack

# ---------------------
# Incoming Damage
# ---------------------
func _take_damage(incoming_damage: int) -> int:
	# Step 1: Dodge roll
	if randf() <= DodgeChance:
		print("Dodge!")
		return FinalHealthPoints  # no damage taken
	# Step 2: Apply Damage Reduction
	var damage_taken = int(incoming_damage * (1.0 - DamageReduction))
	# Step 3: Apply Defense Reduction
	damage_taken = max(0, damage_taken - int(FinalDefense * 0.75))
	# Step 4: Reduce HP
	FinalHealthPoints = max(0, FinalHealthPoints - damage_taken)
	return FinalHealthPoints
