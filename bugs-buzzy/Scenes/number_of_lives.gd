extends CanvasLayer

@onready var lives_label = $Label

func _ready():
	add_to_group("ui")
	
	print("🔍 Debugging GameUI structure...")
	print("lives_label is null: ", lives_label == null)
	
	# چک کن کل ساختار گره‌ها
	print("All children of GameUI:")
	for i in range(get_child_count()):
		var child = get_child(i)
		print(" - ", child.name, " (", child.get_class(), ")")
	
	# سعی کن Label رو با مسیرهای مختلف پیدا کنی
	var possible_paths = ["Label", "GameUI/Label", "../Label", "CanvasLayer/Label"]
	for path in possible_paths:
		var node = get_node_or_null(path)
		if node:
			print("✅ Found node at path '", path, "': ", node.name)
			lives_label = node
			break
	
	if lives_label:
		lives_label.text = "Lives: 3"
		lives_label.modulate = Color.GREEN
		print("✅ Label setup complete!")
	else:
		print("❌ Could not find Label anywhere!")
		# ایجاد یک Label جدید موقت
		create_temp_label()
	
	print("✅ Game UI Ready!")

func create_temp_label():
	var temp_label = Label.new()
	temp_label.text = "Lives: 3 (TEMP)"
	temp_label.position = Vector2(50, 50)
	add_child(temp_label)
	lives_label = temp_label
	print("🔄 Created temporary label")

func update_lives_display(new_lives):
	if lives_label:
		lives_label.text = "Lives: " + str(new_lives)
		print("Lives updated: ", new_lives)
		
		if new_lives <= 0:
			show_game_over()
	else:
		print("❌ Cannot update lives - label is null")

func show_game_over():
	print("🎮 GAME OVER - Showing main menu...")
	var main_menu = get_tree().get_first_node_in_group("menu")
	if main_menu:
		main_menu.visible = true
		get_tree().paused = true
		print("✅ Menu shown!")
	else:
		print("❌ Main menu not found")
