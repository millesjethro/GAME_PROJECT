extends ProgressBar
class_name PlayerHpBar

@onready var DamageBar: ProgressBar = $DamageBar
@onready var DamageBarTimer: Timer = $DamageBarTimer
@onready var HealthRemain: Label = $HealthRemain 
var _target_hp: int

# ---------------------
# Initialize Bars
# ---------------------
func init_health(hp: int):
	max_value = hp
	value = hp
	DamageBar.max_value = hp
	DamageBar.value = hp
	HealthRemain.text = "HEALTH: %d/%d" % [value, max_value]
# ---------------------
# Update Health
# ---------------------
func set_health(hp: int):
	value = hp
	_target_hp = hp  # store target for DamageBar
	DamageBarTimer.start() # wait before tweening
	HealthRemain.text = "HEALTH: %d/%d" % [value, max_value]

# ---------------------
# Tween after timer
# ---------------------
func on_damage_bar_timer_timeout() -> void:
	if DamageBar == null:
		return

	var tween := get_tree().create_tween()
	tween.tween_property(DamageBar, "value", _target_hp, 0.5) \
		.set_ease(Tween.EASE_OUT) \
		.set_trans(Tween.TRANS_QUAD)
