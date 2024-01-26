extends Node2D
class_name GOAP

enum Conditions {
	HUNGRY,               # Наличие голода
	INGREDIENTS_PRESENTS,  # Наличие ингредиентов для еды
	PHONE_NUMBER_PRESENTS,  # Наличие номера пиццерии
	PIZZA_ORDERED,         # Признак заказа пиццы
	FOOD_PRESENTS,         # Наличие еды
}

var state = {
	Conditions.HUNGRY : true,               # Наличие голода
	Conditions.INGREDIENTS_PRESENTS : true,  # Наличие ингредиентов для еды
	Conditions.PHONE_NUMBER_PRESENTS : true,  # Наличие номера пиццерии
	Conditions.PIZZA_ORDERED : false,         # Признак заказа пиццы
	Conditions.FOOD_PRESENTS : false,        # Признак заказа еды
}

var _actions : Array
var goal  #Цель
var goal_val #тру или фолс цели

func _ready():
	ini_actions()
	
	goal = Conditions.HUNGRY
	goal_val = false
	
	var plan = find_plan(goal,goal_val)
	
	if plan == null: return
	
	print("\nПОРЯДОК ДЕЙСТВИЙ")
	for i in plan:
		print(" -",i.id)

func ini_actions():
	var actions : Array = DirAccess.open("res://Actions/").get_files()
	for i in actions:
		_actions.append(load("res://Actions/"+i))

func find_plan(goal,goal_val):
	var plan: Array[Action] = []
	var start_actions: Array[Action] = []
	
	#   Выбираем начальное действие   
	for action in _actions:
		if action.type_completion == goal and action.value_completion == goal_val:
			start_actions.append(action)
	
	for start_action in start_actions:
		var closed = [] #   Уже проверенные дейтсвия
		var open = [start_action] #   Действия которые нужно проверить
		var from = {} #   Откуда какое действие идет
		var G = {start_action: 0} #   Веса действий
		print("начальное действие: ",start_action.id)
		
		while open.size() != 0:
			var curr: Action = min_f(open)    #Выбираем самое дешевое действие
			
			if state[curr.type_condition] == curr.value_condition:    #Проверяем нашли ли мы конец плана
				var point = curr
				while point != start_action:     #Создаем список обратным путем
					plan.append(point)
					point = from[point]
				plan.append(start_action)
				return plan     #Возвращаем список действий
			
			open.erase(curr)
			closed.append(curr)
			
			for action in _actions:     #Перебор действий чтобы найти подходящее
				if closed.has(action): continue
				
				if action.type_completion == curr.type_condition and action.value_completion == curr.value_condition:
					var temp_G = G[curr] + action.weight
					from[action] = curr
					G[action] = temp_G
					if not open.has(action): open.append(action)
		
		print("Нет ни единого решения")
		return null


func min_f(_open):
	var min = null
	for action in _open:
		if min == null or min.weight > (action as Action).weight:
			min = action
	return min
