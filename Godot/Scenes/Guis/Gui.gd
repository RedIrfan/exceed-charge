extends Control
class_name Gui

signal entered
signal exited

var gm


func _ready():
	self.visible = false


func enter():
	print("entered" + self.name)
	self.visible = true
	
	emit_signal("entered")


func exit():
	print("exited" + self.name)
	self.visible = false
	
	emit_signal("exited")


func process(_delta):
	pass


func physics_process(_delta):
	pass
