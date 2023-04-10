class_name Boss
extends Enemy

signal phase_changed(to_amount)

@export var PHASES_HEALTH_AMOUNT : Array[int] = [50]

var boss_phase : int = 1


func process_damage(damage:float):
	super.process_damage(damage)
	
	if boss_phase < PHASES_HEALTH_AMOUNT.size() + 1:
		if health <= PHASES_HEALTH_AMOUNT[boss_phase-1]:
			boss_phase += 1


