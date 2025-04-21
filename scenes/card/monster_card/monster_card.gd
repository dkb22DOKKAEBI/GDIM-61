extends Card

func get_attack() -> int:
	return int($Attack.text)


func get_health() -> int:
	return int($Health.text)


func take_damage(dmg: int) -> void:
	var new_health = max(0, get_health() - dmg)
	$Health.text = str(new_health)
	if (new_health == 0):
		die()


func die():
	card_slot_on.card_in_slot = false
	queue_free()
