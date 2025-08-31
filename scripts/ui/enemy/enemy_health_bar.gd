extends ProgressBar

@onready var hide_timer: Timer = $HideTimer

var fade_tween: Tween

# ---------------------
# Initialize Bars
# ---------------------
func init_health(hp: int):
	max_value = hp
	value = hp
	modulate.a = 1.0
	show()
	hide_timer.start()
	
# ---------------------
# Update Health
# ---------------------
func set_health(hp: int):
	value = hp
	
	# Reset visibility
	if fade_tween and fade_tween.is_valid():
		fade_tween.kill()  # stop old tween if still running
	
	modulate.a = 1.0
	show()
	hide_timer.start()

# ---------------------
# Timer Timeout -> Fade Out
# ---------------------
func _on_hide_timer_timeout() -> void:
	fade_tween = create_tween()
	fade_tween.tween_property(self, "modulate:a", 0.0, 0.5) # fade to transparent
	fade_tween.finished.connect(func ():
		hide()
		modulate.a = 1.0 # reset alpha for next time
	)
