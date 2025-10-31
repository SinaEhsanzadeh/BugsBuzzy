extends CanvasLayer

@onready var play_again_button = $PlayAgainButton
@onready var main_menu_button = $MainMenuButton
@onready var quit_button = $QuitButton
@onready var hash_label = $HashLabel  # اضافه کردن لیبل برای نمایش هش

func _ready():
	add_to_group("win_menu")
	visible = false
	
	if play_again_button:
		play_again_button.connect("pressed", _on_play_again_pressed)
	if quit_button:
		quit_button.connect("pressed", _on_quit_pressed)

func show_win_screen():
	print("🎊 Win menu shown!")
	
	# تولید و نمایش هش
	var hash_result = generate_hash_for_current_game()
	if hash_label:
		hash_label.text = "you'r code: " + hash_result
		hash_label.visible = true
	
	visible = true


func generate_hash_for_current_game() -> String:
	# استفاده از شماره تیم از GameState و یک کلید خصوصی
	var solver_group_id = str(GameState.player_team)
	var private_key = "SUMMBGVE"  # این کلید را تغییر دهید یا از جای امنی بخوانید
	
	return generate_hash(solver_group_id, private_key)

func generate_hash(solver_group_id: String, private_key: String) -> String:
	var combined := solver_group_id + ":" + private_key
	print(combined)
	var raw := combined.sha256_buffer()
	var b64 := Marshalls.raw_to_base64(raw)
	b64 = b64.replace("+", "-").replace("/", "_").replace("=", "")
	if b64.length() >= 10:
		return b64.substr(0, 10)
	else:
		return b64 + "-".repeat(10 - b64.length())

func _on_play_again_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_quit_pressed():
	get_tree().quit()


func _on_quit_button_pressed() -> void:
	pass # Replace with function body.


func _on_play_again_button_pressed() -> void:
	pass # Replace with function body.


func _on_main_menu_button_pressed() -> void:
	print("🏠 Going to main menu...")
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
