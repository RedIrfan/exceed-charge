@tool
extends Panel

enum STATUSES{
	HEALTH,
	DEFENSE,
	AGILITY,
	ATTACK_DAMAGE,
	ATTACK_SPEED
}

const PIP_TEXTURES = [
	preload('res://Assets/Menus/MainMenu/Health.png'),
	preload('res://Assets/Menus/MainMenu/Defense.png'),
	preload('res://Assets/Menus/MainMenu/Agility.png'),
	preload('res://Assets/Menus/MainMenu/AttackDamage.png'),
	preload('res://Assets/Menus/MainMenu/AttackSpeed.png'),
]

@export var status : STATUSES : set = set_status

@onready var label : Label = $Label
@onready var pip_rect : TextureRect = $TextureRect


func _ready():
	pip_rect = $TextureRect
	set_status(status)


func _process(_delta):
	label.rotation = (self.rotation * -1)


func set_status(new_status:STATUSES):
	status = new_status
	$TextureRect.texture = PIP_TEXTURES[status]
