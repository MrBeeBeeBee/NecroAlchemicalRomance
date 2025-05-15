extends Area2D

signal playerInteractable

func interact():
	emit_signal("playerInteractable")
