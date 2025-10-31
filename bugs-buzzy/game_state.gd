extends Node

# متغیرهای جهانی بازی
var player_team: int = 0
var current_level: int = 1
var player_score: int = 0

func _ready():
	# این گره نباید با تغییر صحنه حذف بشه
	process_mode = Node.PROCESS_MODE_ALWAYS

# تابع برای ریست کردن بازی
func reset_game():
	player_team = 0
	current_level = 1
	player_score = 0
