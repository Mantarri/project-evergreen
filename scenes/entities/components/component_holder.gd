extends Node

class_name ComponentHolder

var components: Dictionary = {}

func _ready() -> void:
	for child in get_children():
		if not child is Component:
			push_error("Non-Component child on ComponentHolder `" + str(self) + "` with type and ID `" + str(child) + "`")
			return
		else:
			components[child.id] = child

func has_component(id: String):
	if components.has(id):
		return true
	else:
		return false

func get_component(id: String, safe: bool = false):
	if not safe:
		return components[id]
	elif has_component(id):
		return components[id]

func has_component_member(component_id: String, member_id: String):
	if components.has(component_id):
		return member_id in components[component_id]

func get_component_member(component_id: String, member_id: String, safe: bool = false):
	if not safe:
		return components[component_id].get(member_id)
	elif has_component(component_id):
		return components[component_id].get(member_id)
