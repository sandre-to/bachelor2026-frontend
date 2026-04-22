class_name StegData
extends TaskData

@export var image_name: String = ""
@export_file("*.jpg", "*.jpeg", "*.png", "*.webp") var real_image_path: String = ""
@export var virtual_directory: String = "/home/pictures"

@export var flag: String = ""
@export var flag_metadata_key: String = "UserComment"

@export var author: String = "Unknown"
@export var software: String = "BunOS Image Exporter"
@export var comment: String = "Look closer"
