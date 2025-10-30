extends TileMapLayer

func _ready():
	create_damage_areas()

func create_damage_areas():
	var used_cells = get_used_cells()
	print("🔧 Creating damage areas for ", used_cells.size(), " tiles")
	
	for cell in used_cells:
		var area = Area2D.new()
		var collision = CollisionShape2D.new()
		var shape = RectangleShape2D.new()
		
		# سایز تایل‌ها رو از TileSet والد بگیر
		var parent_tilemap = get_parent()
		if parent_tilemap and parent_tilemap.has_method("get_tile_set"):
			var tile_set = parent_tilemap.tile_set
			if tile_set:
				shape.size = tile_set.tile_size
			else:
				shape.size = Vector2(16, 16)
		else:
			shape.size = Vector2(16, 16)  # سایز پیش‌فرض
			
		collision.shape = shape
		area.add_child(collision)
		
		# موقعیت Area رو تنظیم کن
		area.position = map_to_local(cell) + shape.size / 2
		area.name = "DamageArea_%d_%d" % [cell.x, cell.y]
		
		# سیگنال متصل کن
		area.body_entered.connect(_on_damage_area_body_entered)
		add_child(area)
	
	print("✅ Created ", get_child_count(), " damage areas")

func _on_damage_area_body_entered(body):
	if body.is_in_group("player"):
		print("💥 Damage block hit player at position: ", body.position)
		if body.has_method("lose_life"):
			body.lose_life()
