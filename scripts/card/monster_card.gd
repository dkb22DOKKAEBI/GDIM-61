class_name MonsterCard
extends Card


func get_label_vis() -> bool:
	return selected_label.visible


func get_attack() -> int:
	return int($Attack.text)


func get_health() -> int:
	return int($Health.text)


func take_damage(dmg: int) -> void:
	var new_health = max(0, get_health() - dmg)
	if (new_health == 0):
		die()
	$Health.text = str(new_health)
	
	# Change font to double size and red
	$Health.add_theme_font_size_override("normal_font_size", 40)
	$Health.modulate = Color.RED
	
	# Play animation for health change
	var tween = get_tree().create_tween()
	tween.tween_property($Health, "theme_override_font_sizes/normal_font_size", 16, 1)
	tween.tween_property($Health, "modulate", Color.BLACK, 1)


func die():
	card_slot_on.card_in_slot = null
	queue_free()


func test():
	pass
