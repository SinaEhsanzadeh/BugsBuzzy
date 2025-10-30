extends CharacterBody2D

signal lives_changed(new_lives)
signal health_changed(new_health)

@onready var sprite = $AnimatedSprite2D
@onready var hurtboxsprite = $Hurtbox/AnimatedSprite2D

var attacking = false
var isgoingleft = false
var lives: int = 3
var health: int = 100
var is_dead: bool = false

# متغیرهای جدید برای آسیب‌ناپذیری
var is_invincible: bool = false
var invincibility_timer: float = 0.0
var invincibility_duration: float = 3.0  # 3 ثانیه

const SPEED = 200.0
const JUMP_VELOCITY = -300.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	print("Player initialized with lives: ", lives)
	add_to_group("player")
	lives_changed.emit(lives)
	health_changed.emit(health)

func _process(delta):
	if is_dead:
		return
	
	if Input.is_action_just_pressed("attack"):
		attack()
	
	# آپدیت تایمر آسیب‌ناپذیری
	if is_invincible:
		invincibility_timer -= delta
		if invincibility_timer <= 0:
			end_invincibility()
		
		# چشمک زدن برای نشان دادن آسیب‌ناپذیری
		sprite.modulate.a = 0.5 if Engine.get_frames_drawn() % 10 < 5 else 1.0

func _physics_process(delta: float) -> void:
	if is_dead:
		return
	
	if not is_on_floor():
		velocity.y += gravity * delta
		if not attacking:
			sprite.play("jump")

	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		if not attacking:
			sprite.play("jump")
		velocity.y = JUMP_VELOCITY
	
	var direction := Input.get_axis("ui_left", "ui_right")        
	if direction and not attacking:
		velocity.x = direction * SPEED
		if is_on_floor():
			sprite.play("move")
			
		if direction < 0 and not isgoingleft:
			self.scale.x = -1
			isgoingleft = true
		
		if direction > 0 and isgoingleft:
			self.scale.x = -1
			isgoingleft = false
			
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if is_on_floor() and not attacking:
			sprite.play("default")

	move_and_slide()

func play_death_animation():
	is_dead = true
	velocity = Vector2.ZERO
	
	print("💀 DEATH: Starting death sequence...")
	
	# UI رو آپدیت کن
	get_tree().call_group("ui", "update_lives_display", 0)
	
	# انیمیشن رو پلی کن
	print("🎬 DEATH: Playing death animation...")
	sprite.play("death")
	
	# صبر کن انیمیشن تموم بشه
	await get_tree().create_timer(2.0).timeout
	print("✅ DEATH: Death animation finished")
	
	# حالا گیم اور رو صدا بزن
	show_game_over()

func show_game_over():
	print("🎮 PLAYER: Showing game over menu...")
	
	var main_menu = get_tree().get_first_node_in_group("menu")
	if main_menu:
		main_menu.visible = true
		get_tree().paused = true
		print("✅ Game over menu shown!")
	else:
		print("❌ Main menu not found")

func attack():
	if is_dead:
		return
	attacking = true
	hurtboxsprite.play("slash")
	await hurtboxsprite.animation_finished
	attacking = false

func start_invincibility():
	is_invincible = true
	invincibility_timer = invincibility_duration
	print("Invincibility started for ", invincibility_duration, " seconds")

func end_invincibility():
	is_invincible = false
	sprite.modulate.a = 1.0
	print("Invincibility ended")

func take_damage(amount: int):
	if is_dead:
		return
	if is_invincible:
		print("Player is invincible! No damage taken.")
		return
	
	lose_life()

func lose_life():
	if is_dead:
		return
	if is_invincible:
		print("Player is invincible! No life lost.")
		return
		
	print("=== PLAYER LOST A LIFE! ===")
	lives -= 1
	print("Lives remaining: ", lives)
	
	# UI رو آپدیت کن
	get_tree().call_group("ui", "update_lives_display", lives)
	lives_changed.emit(lives)
	
	if lives > 0:
		start_invincibility()
	else:
		# فقط انیمیشن مرگ رو شروع کن
		play_death_animation()

func _on_hurtbox_area_entered(area: Area2D) -> void:
	if is_dead:
		return
	if area.is_in_group("enemy") and not is_invincible:
		print("Hurtbox touched enemy! Losing life...")
		lose_life()

func _on_damage_area_body_entered(body):
	if is_dead:
		return
	if body == self and not is_invincible:
		print("💥 Player hit damage area!")
		lose_life()
