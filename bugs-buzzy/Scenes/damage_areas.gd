extends Node2D

@export var damage_amount: int = 1
@export var tilemap: TileMap

func _ready():
	create_damage_areas()

func create_damage_areas():
	if not tilemap:
		return
		
	var used_cells = tilemap.get_used_cells(0)
	
	for cell_pos in used_cells:
		# برای هر تایل یک Area2D ایجاد کن
		var area = Area2D.new()
		var collision = CollisionShape2D.new()
		var shape = RectangleShape2D.new()
		
		shape.size = tilemap.tile_set.tile_size
		collision.shape = shape
		area.add_child(collision)
		area.position = tilemap.map_to_local(cell_pos)
		area.body_entered.connect(_on_body_entered)
		add_child(area)

func _on_body_entered(body: Node2D):
	if body.is_in_group("player"):
		body.take_damage(damage_amount)
