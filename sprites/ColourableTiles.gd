extends TileMap
class_name ColourableTiles

func on_ball_collide(ball: Disc, collision: KinematicCollision2D) -> bool:
	# get tile that was hit
	var hit_tile = local_to_map(to_local(collision.get_position()))
	
	var change: Array[Vector2i] = []
	for row in range(-1,2):
		for col in range(-1,2):
			if (BetterTerrain.get_cell(self, 0, hit_tile + Vector2i(row, col)) != -1):
				change.append(hit_tile + Vector2i(row, col))
	
	BetterTerrain.set_cells(self, 0, change, ball.team)
	BetterTerrain.update_terrain_cells(self, 0, change)
	
	# don't destroy the ball
	return false
