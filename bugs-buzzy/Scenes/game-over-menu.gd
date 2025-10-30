extends Control

func _ready():
	add_to_group("menu")
	# موقع شروع بازی منو رو مخفی کن
	visible = false
	print("🎯 Menu initialized and hidden")

func show_menu():
	visible = true
	get_tree().paused = true
	print("🔄 Menu shown - Game paused")

func hide_menu():
	visible = false
	get_tree().paused = false
	print("🔄 Menu hidden - Game resumed")
