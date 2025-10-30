extends CharacterBody2D

signal lives_changed(new_lives)
signal health_changed(new_health)

@onready var sprite = $AnimatedSprite2D
@onready var hurtboxsprite = $Hurtbox/AnimatedSprite2D

var attacking = false
var isgoingleft = false
var lives: int = 3
var health: int = 100

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
	if Input.is_action_just_pressed("attack"):
		attack()
	
	# آپدیت تایمر آسیب‌ناپذیری
	if is_invincible:
		invincibility_timer -= delta
		if invincibility_timer <= 0:
			end_invincibility()
		
		# چشمک زدن برای نشان دادن آسیب‌ناپذیری
		sprite.modulate.a = 0.5 if Engine.get_frames_drawn() % 10 < 5 else 1.0

func attack():
	attacking = true
	hurtboxsprite.play("slash")
	await hurtboxsprite.animation_finished
	attacking = false

func _physics_process(delta: float) -> void:
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
	# تابع check_damage_tiles رو حذف کردیم چون با Area2D کار میکنه

# تابع برای شروع آسیب‌ناپذیری
func start_invincibility():
	is_invincible = true
	invincibility_timer = invincibility_duration
	print("Invincibility started for ", invincibility_duration, " seconds")

# تابع برای پایان آسیب‌ناپذیری
func end_invincibility():
	is_invincible = false
	sprite.modulate.a = 1.0  # برگردون به حالت عادی
	print("Invincibility ended")

# تابع برای دریافت آسیب
func take_damage(amount: int):
	# اگر آسیب‌ناپذیر هست، آسیب نگیر
	if is_invincible:
		print("Player is invincible! No damage taken.")
		return
	
	lose_life()

# تابع برای از دست دادن جان
func lose_life():
	if is_invincible:
		print("Player is invincible! No life lost.")
		return
		
	print("=== PLAYER LOST A LIFE! ===")
	lives -= 1
	print("Lives remaining: ", lives)
	lives_changed.emit(lives)
	
	# شروع آسیب‌ناپذیری بعد از از دست دادن جان
	start_invincibility()
	
	# فقط اگر جان تمام شد، Game Over نشون بده
	if lives <= 0:
		die()

func die():
	print("Game Over! No lives left.")
	# به UI بگو Game Over نشون بده
	get_tree().call_group("ui", "show_game_over")

func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy") and not is_invincible:
		print("Hurtbox touched enemy! Losing life...")
		lose_life()

# تابع جدید برای تشخیص برخورد با damage blocks
func _on_damage_area_body_entered(body):
	if body == self and not is_invincible:  # مطمئن شو این پلیر هست و آسیب‌ناپذیر نیست
		print("💥 Player hit damage area!")
		lose_life()
