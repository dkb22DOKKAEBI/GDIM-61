extends Card

@export var selected_label: Label


func ingredient_card_selected():
	selected_label.visible = !selected_label.visible
