extends Node2D

@onready var lives_label = $CanvasLayer/Label
var current_lives: int = 3

func _ready():
	lives_label.text = "Lives: 3"
	lives_label.modulate = Color.GREEN
	
	# هر فریم چک کن
	set_process(true)

func _process(delta):
	var player = get_tree().get_first_node_in_group("player")
	if player and player.has_method("lose_life"):
		# اگر تعداد جان تغییر کرد، UI رو آپدیت کن
		if player.lives != current_lives:
			current_lives = player.lives
			update_lives_display(current_lives)

func update_lives_display(new_lives):
	print("Lives changed to: ", new_lives)
	lives_label.text = "Lives: " + str(new_lives)
	
	if new_lives == 3:
		lives_label.modulate = Color.GREEN
	elif new_lives == 2:
		lives_label.modulate = Color.YELLOW
	elif new_lives == 1:
		lives_label.modulate = Color.RED
	else:
		lives_label.modulate = Color.DARK_RED
