extends Resource
class_name ItemStats

@export var uid: String = ""
@export var Art: AtlasTexture
@export var name: String = ""
@export_multiline var description: String = ""
@export_enum("Equipment","Consumable","Materials") var ItemType: String
@export var isStackable: bool = false
