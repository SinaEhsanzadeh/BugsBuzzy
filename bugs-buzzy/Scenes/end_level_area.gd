extends Area2D

func _ready():
	body_entered.connect(_on_body_entered)
	print("🎯 EndLevelArea ready at position: ", global_position)

func _on_body_entered(body):
	print("🎯 EndLevelArea: Body entered - ", body.name)
	if body.is_in_group("player"):
		print("🎉 Player reached the end level!")
		if body.has_method("win_game"):
			body.win_game()
		else:
			print("❌ Player doesn't have win_game method!")
