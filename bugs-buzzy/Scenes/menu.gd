extends CanvasLayer  # یا Control - بستگی به نوع گره Menu داره

func _ready():
	add_to_group("menu")
	# موقع شروع بازی منو رو مخفی کن
	visible = false

func show_menu():
	visible = true
	print("🎯 Menu is now visible!")
