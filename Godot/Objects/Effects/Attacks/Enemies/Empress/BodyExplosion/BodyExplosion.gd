extends EffectAttack


func on_spawn(params={}):
	params['body'].visible = false
	params['body']._on_dead()
	
	super.on_spawn(params)
