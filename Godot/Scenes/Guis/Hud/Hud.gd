extends Gui

@onready var animation_player : AnimationPlayer = $AnimationPlayer


func exit():
	await get_tree().create_timer(0.1)
	
	super.exit()


func process(_delta):
	if Input.is_action_just_pressed("action_deck"):
		gm.enter_gui("DeckOn")
