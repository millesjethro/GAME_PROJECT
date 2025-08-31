extends CharacterBody2D

var player: CharacterBody2D
@onready var mainStatus = $MainStatus
@export var GravityForce = 200
@onready var hpShow = $EnemyHealthBar

func _ready() -> void:
	hpShow.init_health(mainStatus.Health)
	mainStatus.died.connect(_on_enemy_died)
	
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GravityForce * delta
	else:
		velocity.y = 0  # stay grounded when on floor
	move_and_slide()

func _on_take_damage_area_entered(area: Area2D) -> void:
	if area.is_in_group("AreaDealDamage"):
		var parent = area.get_parent()
		player = parent
		if parent.has_node("PlayerStatus/OnStageStatus"):
			var player_stats = parent.get_node("PlayerStatus/OnStageStatus")
			var damage = player_stats.calc_damage()
			print("Damage: ", damage)
			var currentHp = mainStatus.take_damage(damage)
			print("Current Hp: ", currentHp)
			hpShow.set_health(currentHp)

func _on_enemy_died(gold_amount: int) -> void:
	if player.has_node("PlayerGold"):
		print("gold added")
		var gold = player.get_node("PlayerGold")
		gold.add_gold(gold_amount)
