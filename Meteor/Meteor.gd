extends Area2D

var pMeteorEffect := preload("res://Meteor/MeteorEffect.tscn")

export var minSpeed: float = 1
export var maxSpeed: float = 5
export var minRotationRate: float = -20
export var maxRotationRate: float = 20

export var life: int = 20

var speed: float = 0
var rotationRate: float = 0
var playerInArea: Player = null

func _ready():
	speed = rand_range(minSpeed, maxSpeed)
	rotationRate = rand_range(minRotationRate, maxRotationRate)

func _process(delta):
	if playerInArea != null:
		playerInArea.damage(1)

# meteor rotate
func _physics_process(delta):
	rotation_degrees += rotationRate * delta
	position.y += speed + delta

func damage(amount: int):
	if life <= 0:
		return
	life -= amount
	if  life <= 0:
		var effect := pMeteorEffect.instance()
		effect.position = position
		get_parent().add_child(effect)
		
		Signals.emit_signal("on_score_increment", 2)
		
		queue_free()

# viewport outside object delete
func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()

# meteor damage
func _on_Meteor_area_entered(area: Area2D) -> void:
	if area is Player:
		playerInArea = area

# meteor area damage
func _on_Meteor_area_exited(area: Area2D) -> void:
	if area is Player:
		playerInArea = null
