extends CharacterBody2D

@export var GravityForce = 200

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GravityForce * delta
	else:
		velocity.y = 0  # stay grounded when on floor
	move_and_slide()
