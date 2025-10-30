extends TileMap

# میزان آسیب تایل
@export var damage_amount: int = 10

func _ready():
	# وقتی پلییر وارد تایل شد
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D):
	if body.is_in_group("player"):
		# به پلییر آسیب بزن
		body.take_damage(damage_amount)
