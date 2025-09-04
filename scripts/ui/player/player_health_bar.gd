extends AnimatedSprite2D

@onready var labelText = $health_left
var max_hp: int = 0

func _ready() -> void:
	set_frame_and_progress(0, 0) # start full

func init_hp(health: int):
	max_hp = health
	set_hp(health) # show correct frame at start

func set_hp(health: int):
	if max_hp <= 0:
		return

	# Calculate percentage (0–100)
	var hp_percent: float = clamp(float(health) / float(max_hp) * 100.0, 0.0, 100.0)

	# Update label text
	labelText.text = "%d%%" % int(hp_percent)

	# Map percentage to frame (0 = 100%, 11 = 0%)
	var frame_index: int = 11 - int(round(hp_percent / 10.0))
	set_frame_and_progress(frame_index, 0)
	
		# --- Shake effect ---
	shake_icon()

func shake_icon():
	var tween := get_tree().create_tween()
	var original_pos := position
	# small horizontal shake
	tween.tween_property(self, "position", original_pos + Vector2(5, 0), 0.05).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "position", original_pos - Vector2(5, 0), 0.05).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "position", original_pos, 0.05).set_trans(Tween.TRANS_SINE)
