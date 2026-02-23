extends Node
class_name CannonCooldown

@onready var burst_inner_timer: Timer = $BurstInnerTimer
@onready var burst_between_timer: Timer = $BurstBetweenTimer
var remaining_burst: int = 0
var stats: CannonStats: set = set_stats

func _ready() -> void:
	burst_between_timer.timeout.connect(reload)


func set_stats(new_stats: CannonStats) -> void:
	stats = new_stats
	if !stats: return
	reload()
	burst_between_timer.wait_time = stats.burst_between_delay
	burst_inner_timer.wait_time = stats.burst_inner_delay



func reload() -> void:
	if !stats: return
	if !burst_between_timer.is_stopped():
		burst_between_timer.stop()
	remaining_burst = stats.burst_size


func can_fire(amount: int) -> int:
	if !stats: return 0
	if !burst_inner_timer.is_stopped(): return 0
	return min(remaining_burst, amount)


func fire(amount: int) -> int:
	var can_fire_amount = can_fire(amount)
	if can_fire_amount <= 0:
		return 0
	remaining_burst -= can_fire_amount
	burst_inner_timer.start()
	if burst_between_timer.is_stopped():
		burst_between_timer.start()
	
	return can_fire_amount
