extends CanvasLayer

@onready var lives_label = $Label

func _ready():
	add_to_group("ui")
	
	if lives_label:
		lives_label.text = "Lives: 3"
		lives_label.modulate = Color.GREEN
	
	print("✅ Game UI Ready!")

func update_lives_display(new_lives):
	if lives_label:
		lives_label.text = "Lives: " + str(new_lives)
		print("Lives: ", new_lives)
		
		if new_lives <= 0:
			show_game_over()

func show_game_over():
	print("🎮 GAME OVER - Showing main menu...")
	
	# منوی اصلی رو پیدا کن و نمایش بده
	var main_menu = get_tree().get_first_node_in_group("menu")
	if main_menu:
		main_menu.visible = true
		# بازی رو متوقف کن
		get_tree().paused = true
		print("✅ menu shown!")
	else:
		print("❌ Main menu not found - reloading as fallback")
		get_tree().reload_current_scene()
