extends CanvasLayer

@onready var try_again_button = $ColorRect/VBoxContainer/TryAgainButton
@onready var main_menu_button = $ColorRect/VBoxContainer/MainMenuButton
@onready var quit_button = $ColorRect/VBoxContainer/QuitButton

func _ready():
	add_to_group("menu")  # ✨ این خط خیلی مهمه!
	visible = false
	
	# مطمئن شو دکمه‌ها وجود دارن
	if try_again_button:
		try_again_button.connect("pressed", _on_try_again_pressed)
	else:
		print("❌ TryAgainButton not found")
	
	if main_menu_button:
		main_menu_button.connect("pressed", _on_main_menu_pressed)
	else:
		print("❌ MainMenuButton not found")
	
	if quit_button:
		quit_button.connect("pressed", _on_quit_pressed)
	else:
		print("❌ QuitButton not found")
	
	print("✅ GameOverMenu ready!")

func show_game_over():
	print("🎮 GameOverMenu: Showing menu...")
	visible = true
	get_tree().paused = true

func _on_try_again_pressed():
	print("🔄 Restarting game...")
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_main_menu_pressed():
	print("🏠 Going to main menu...")
	get_tree().paused = false
	# اگر صحنه منوی اصلی داری، اسمش رو اینجا بذار
	# get_tree().change_scene_to_file("res://main_menu.tscn")
	get_tree().reload_current_scene()  # موقتاً

func _on_quit_pressed():
	print("👋 Quitting game...")
	get_tree().quit()
