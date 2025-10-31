extends CanvasLayer

@onready var try_again_button = $ColorRect/VBoxContainer/TryAgainButton
@onready var main_menu_button = $ColorRect/VBoxContainer/MainMenuButton
@onready var quit_button = $ColorRect/VBoxContainer/QuitButton

func _ready():
	add_to_group("menu")
	visible = false

func show_game_over():
	print("🎮 GameOverMenu: Showing menu...")
	visible = true

func _on_try_again_pressed():
	print("🔄 Restarting game...")
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_main_menu_pressed():
	print("🏠 Going to main menu...")
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _on_quit_pressed():
	print("👋 Quitting game...")
	get_tree().quit()
