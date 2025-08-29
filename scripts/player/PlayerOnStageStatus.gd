extends Node
class_name Player_On_Stage_Status

@onready var PlayerSubStats: Player_Sub_Status = $SubStatus

var FinalAttack = 0
var FinalHealthPoints = 0
var FinalDefense = 0
var Defense = 0
var DodgeChance = 0.0
var DamageReduction = 0.0
var CritChance = 0.0
var Critical = 0.0

func _ready() -> void:
	var stats = PlayerSubStats.get_final_stats()
	FinalAttack = stats["Attack"]
	FinalDefense = stats["Defense"]
	FinalHealthPoints = stats["HealthPoints"]
	CritChance = stats["CritChance"]
	DodgeChance = stats["DodgeChance"]
	DamageReduction = stats["DamageReduction"]
	Critical = stats["Critical"]

# ---------------------
# Damage To Enemy
# ---------------------
func _calc_damage() -> int:
	var Roll = round(randf() * 100) / 100.0
	if Roll <= CritChance:   # check against final CritChance
		var CritDamage = FinalAttack * Critical
		print("CRITICAL! Roll:", Roll, "Damage:", CritDamage)
		return int(CritDamage)
	else:
		print("Normal Hit. Roll:", Roll, "Damage:", FinalAttack)
		return int(FinalAttack)

# ---------------------
# Incoming Damage
# ---------------------
func _take_damage(IncomingDamage: int) -> int:
	var Roll = round(randf() * 100) / 100.0
	if Roll <= DodgeChance:
		print("Attack Dodged!")
		return FinalHealthPoints
		
	# Step 2: Apply Damage Reduction %
	var FinalDR = DamageReduction
	var DamageTaken = int(IncomingDamage * (1.0 - FinalDR))
	
	# Step 3: Apply Defense Reduction
	DamageTaken = max(0, DamageTaken - (FinalDefense * 0.75))
	# Step 3: Reduce HP
	FinalHealthPoints = max(0, FinalHealthPoints - DamageTaken)
	return FinalHealthPoints
