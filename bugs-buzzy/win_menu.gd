extends CanvasLayer

@onready var play_again_button = $ColorRect/VBoxContainer/PlayAgainButton
@onready var quit_button = $ColorRect/VBoxContainer/QuitButton

func _ready():
	add_to_group("win_menu")
	visible = false
	
	if play_again_button:
		play_again_button.connect("pressed", _on_play_again_pressed)
	if quit_button:
		quit_button.connect("pressed", _on_quit_pressed)

func show_win_screen():
	print("🎊 Win menu shown!")
	visible = true
	get_tree().paused = true

func _on_play_again_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_quit_pressed():
	get_tree().quit()
