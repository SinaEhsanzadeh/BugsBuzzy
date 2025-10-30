extends CanvasLayer

@onready var lives_label = $lives_label

func _ready():
	add_to_group("ui")
	
	if lives_label:
		lives_label.text = "Lives: 3"
		lives_label.modulate = Color.GREEN
	
	print("✅ Game UI Ready!")

func update_lives_display(new_lives):
	print("🔄 UI: Updating lives to ", new_lives)
	if lives_label:
		lives_label.text = "Lives: " + str(new_lives)
		
		# تغییر رنگ
		if new_lives == 3:
			lives_label.modulate = Color.GREEN
		elif new_lives == 2:
			lives_label.modulate = Color.YELLOW
		elif new_lives == 1:
			lives_label.modulate = Color.RED

# ✨ این تابع رو می‌تونی حذف کنی یا نگه داری
func show_game_over():
	print("🔄 UI: Game over received")
	# یا می‌تونی اینجا کارهای اضافی انجام بدی
