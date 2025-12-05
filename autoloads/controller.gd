extends Node

@export var nav_container: NavigationContainer
@export var pages: Dictionary[String, PackedScene]

const API_RESOURCES_MANAGE := "https://eat-wise-silk.vercel.app/api/resources/manage/"
const API_FOOD_ITEMS := "https://eat-wise-silk.vercel.app/api/foodItems/"

# TODO: Add login session manager
