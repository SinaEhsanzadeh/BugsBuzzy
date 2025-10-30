# یک TileMap جدا برای مناطق آسیب‌زننده
extends TileMap

func _ready():
	# سیگنال برای چک کردن موقعیت پلیر
	set_process(true)

func _process(delta):
	if has_node("../Player"):
		var player = get_node("../Player")
		var player_cell = local_to_map(player.position)
		
		# چک کن پلیر روی کدوم تایل هست
		var tile_id = get_cell_source_id(0, player_cell)
		if tile_id == 5:  # اگر روی تایل آسیب‌زننده هست
			player.take_damage(1)
