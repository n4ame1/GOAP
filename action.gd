extends Resource
class_name Action

# Действие "Позвонить в пиццерию и сделать заказ"
@export var id: String #Идентификатор действия, по которому мы его сможем потом определить.

@export_category("completion-exit")
@export var type_completion: GOAP.Conditions
@export var value_completion: bool

@export_category("condition-enter")
@export var type_condition: GOAP.Conditions
@export var value_condition: bool

@export var weight: int = 1

