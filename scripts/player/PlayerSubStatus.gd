extends Node

# ----------------------
# Main Stats Values
# ----------------------
var Strength: int
var Agility: int
var Intelligence: int

# ---------------------
# Base Values
# ---------------------
var Attack = 15
var Defense = 7
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


func GettingValues(value: Dictionary):
	print("STR: ",value["Strength"]," AGI: ",value["Agility"]," INT: ",value["Intelligence"])
	Strength = value["Strength"]
	Agility = value["Agility"]
	Intelligence = value["Intelligence"]

# ----------------------------
# Final Sub Stats Calculation
# ----------------------------
func calc_FinalAttack() -> int:
	return Attack \
		+ int((Agility + Strength) * 0.75) \
		+ ItemAddAttack \
		+ PassiveAddAttack

func calc_FinalDefense() -> int:
	return Defense \
		+ int((Strength + (Agility * 0.15)) * 1.3) \
		+ ItemAddDefense \
		+ PassiveAddDefense

func calc_FinalHealthPoints() -> int:
	return HealthPoints \
		+ int(Strength * 1.5) \
		+ ItemAddHealth \
		+ PassiveAddHealth

func calc_Final_CriticalChance() -> float:
	var BaseCritChance = CriticalChance + (Agility / 300.0)
	var FinalCritChance = BaseCritChance + ItemAddCritChance + PassiveAddCritChance
	return min(1.0, FinalCritChance)   # hard cap at 100%

func calc_DodgeChance() -> float:
	var BaseDodge = (Agility / 3.0) / 100.0   # scale with agility
	var FinalDodge = Dodge + BaseDodge + ItemAddDodge + PassiveAddDodge
	return min(0.7, FinalDodge)   # cap at 70%

func calc_DamageReduction() -> float:
	var FinalDR = DamageReduction + ItemAddDR + PassiveAddDR
	return min(0.40, FinalDR)   # cap at 40%

func calc_Critical() -> float:
	var BaseCritical = (Agility / 4.0) / 100.0 
	var FinalCritical = Dodge + BaseCritical + ItemAddCritical + PassiveAddCritical
	return FinalCritical
