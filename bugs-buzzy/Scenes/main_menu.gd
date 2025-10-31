extends CanvasLayer

@onready var team_input = $LineEdit
@onready var start_button = $StartButton
@onready var quit_button = $QuitButton
@onready var error_label = $ErrorLabel

func _ready():
	# مخفی کردن پیام خطا
	error_label.visible = false
	
	# وصل کردن سیگنال‌ها
	team_input.connect("text_changed", _on_team_input_changed)
	start_button.connect("pressed", _on_start_pressed)
	quit_button.connect("pressed", _on_quit_pressed)
	
	print("✅ Main Menu Ready!")

func _on_team_input_changed(new_text: String):
	error_label.visible = false  # مخفی کردن خطا موقع تایپ

func _on_start_pressed():
	var team_number_text = team_input.text.strip_edges()
	
	# اعتبارسنجی شماره تیم
	if team_number_text.is_empty():
		show_error("please input team id")
		return
	
	
	print("🎮 Starting game with team: ", team_number_text)
	print(team_number_text)
	start_game(team_number_text)

func show_error(message: String):
	error_label.text = message
	error_label.visible = true

func start_game(team_number_text: String):
	# ✨ استفاده از GameState به جای Global
	GameState.player_team = team_number_text
	
	# رفتن به صحنه بازی
	get_tree().change_scene_to_file("res://Scenes/Main.tscn")

func _on_quit_pressed():
	print("👋 Quitting game...")
	get_tree().quit()
