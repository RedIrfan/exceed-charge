extends Effect
class_name EffectParticles

@export var particles : GPUParticles3D


func on_spawn(parameters=[]):
	particles.emitting = true
	self.global_rotation = parameters[0]

	if parameters.size() >= 2:
		if parameters[1] is Color:
			particles.draw_pass_1.surface_get_material(0).albedo_color = parameters[1]
		if parameters[1] is Mesh:
			particles.draw_pass_1 = parameters[1]
