extends CanvasLayer

@onready var team_input = $ColorRect/VBoxContainer/LineEdit
@onready var start_button = $ColorRect/VBoxContainer/StartButton
@onready var quit_button = $ColorRect/VBoxContainer/QuitButton
@onready var error_label = $ColorRect/VBoxContainer/ErrorLabel

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
		show_error("❌ لطفاً شماره تیم را وارد کنید")
		return
	
	if not team_number_text.is_valid_int():
		show_error("❌ شماره تیم باید عدد باشد")
		return
	
	var team_num = team_number_text.to_int()
	if team_num <= 0:
		show_error("❌ شماره تیم باید بزرگتر از صفر باشد")
		return
	
	print("🎮 Starting game with team: ", team_num)
	start_game(team_num)

func show_error(message: String):
	error_label.text = message
	error_label.visible = true

func start_game(team_number: int):
	# ✨ استفاده از GameState به جای Global
	GameState.player_team = team_number
	
	# رفتن به صحنه بازی
	get_tree().change_scene_to_file("res://Scenes/Main.tscn")

func _on_quit_pressed():
	print("👋 Quitting game...")
	get_tree().quit()
