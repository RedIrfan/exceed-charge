extends ScanArea


func check_area(area):
	if area.is_in_group("LockTargetable"):
		return true
	return false
