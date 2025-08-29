extends Node
class_name Player_Sub_Status
@onready var MainStats: Player_Main_Status = $MainStats

# ---------------------
# Base Values
# ---------------------
var Attack = 15
var Defense = 6
var HealthPoints = 150
var Dodge = 0.0
var CriticalChance = 0.0  # 1% base
var Critcal = 2.0
var DamageReduction = 0.0
# ---------------------
# Extra Modifiers
# ---------------------
var ItemAddAttack = 0
var PassiveAddAttack = 0

var ItemAddDefense = 0
var PassiveAddDefense = 0

var ItemAddHealth = 0
var PassiveAddHealth = 0

var ItemAddCritChance = 0.0
var PassiveAddCritChance = 0.0

var ItemAddDodge = 0.0
var PassiveAddDodge = 0.0

var ItemAddDR = 0.0
var PassiveAddDR = 0.0

var ItemAddCritical = 0.0
var PassiveAddCritical = 0.0
# ----------------------------
# SnapShot Of Sub Status
# ----------------------------
func get_final_stats() -> Dictionary:
	return {
		"Attack": _calc_FinalAttack(),
		"Defense": _calc_FinalDefense(),
		"HealthPoints": _calc_FinalHealthPoints(),
		"CritChance": _calc_Final_CriticalChance(),
		"DodgeChance": _calc_DodgeChance(),
		"DamageReduction": _calc_DamageReduction(),
		"Critical": _calc_Critical()
	}

# ----------------------------
# Final Sub Stats Calculation
# ----------------------------
func _calc_FinalAttack() -> int:
	return Attack \
		+ int((MainStats.Agility + MainStats.Strength) * 0.75) \
		+ ItemAddAttack \
		+ PassiveAddAttack

func _calc_FinalDefense() -> int:
	return Defense \
		+ int((MainStats.Strength + (MainStats.Agility * 0.15)) * 1.3) \
		+ ItemAddDefense \
		+ PassiveAddDefense

func _calc_FinalHealthPoints() -> int:
	return HealthPoints \
		+ int(MainStats.Strength * 1.5) \
		+ ItemAddHealth \
		+ PassiveAddHealth

func _calc_Final_CriticalChance() -> float:
	var BaseCritChance = CriticalChance + (MainStats.Agility / 300.0)
	var FinalCritChance = BaseCritChance + ItemAddCritChance + PassiveAddCritChance
	return min(1.0, FinalCritChance)   # hard cap at 100%

func _calc_DodgeChance() -> float:
	var BaseDodge = (MainStats.Agility / 3.0) / 100.0   # scale with agility
	var FinalDodge = Dodge + BaseDodge + ItemAddDodge + PassiveAddDodge
	return min(0.7, FinalDodge)   # cap at 70%

func _calc_DamageReduction() -> float:
	var FinalDR = DamageReduction + ItemAddDR + PassiveAddDR
	return min(0.40, FinalDR)   # cap at 40%

func _calc_Critical() -> float:
	var BaseCritical = (MainStats.Agility / 4.0) / 100.0 
	var FinalCritical = Dodge + BaseCritical + ItemAddCritical + PassiveAddCritical
	return FinalCritical
