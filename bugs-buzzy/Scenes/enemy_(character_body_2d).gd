extends CharacterBody2D

@export var speed: int = 50
@export var patrol_range: float = 30.0
@export var damage_amount: int = 10

var start_position: Vector2
var direction: int = 1

func _ready():
	start_position = position
	$AnimatedSprite2D.play("walk")
	add_to_group("enemies")
	print("Enemy ready!")

func _physics_process(delta):
	patrol_movement(delta)
	move_and_slide()
	check_player_collision()

func check_player_collision():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider != null and collider.is_in_group("player"):
			print("ENEMY: Collided with player! Calling lose_life...")
			
			# اینجا باید lose_life رو صدا بزنی نه take_damage
			if collider.has_method("lose_life"):
				print("ENEMY: lose_life method exists! Calling it...")
				collider.lose_life()
			else:
				print("ENEMY: ERROR - lose_life method not found!")

func patrol_movement(_delta):
	if position.x > start_position.x + patrol_range:
		direction = -1
	elif position.x < start_position.x - patrol_range:
		direction = 1
		
	if direction == -1:
		$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.flip_h = true
		
	velocity.x = direction * speed
	velocity.y = 0
