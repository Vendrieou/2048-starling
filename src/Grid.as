package
{
	
	/**
	 * ...
	 * @author Vendrie
	 */
	public class Grid
	{
		
		public function blankGrid()
		{
			var rows:Array = [];
			
			for (var i:int = 0; i < 4; i++)
			{
				rows.push([0, 0, 0, 0]);
			}
			return rows;
		}
		
		public function compare(a:Array, b:Array):Boolean
		{
			for (var i:int = 0; i < 4; i++)
			{
				for (var j:int = 0; j < 4; j++)
				{
					if (a[i][j] != b[i][j])
					{
						return false;
					}
				}
			}
			return true;
		}
		
		public function copyGrid(grid:Array)
		{
			extraGrid: Array = blankGrid();
			for (var i:int = 0; i < 4; i++)
			{
				for (var j:int = 0; j < 4; j++)
				{
					extraGrid[i][j] = grid[i][j];
				}
			}
			return extraGrid;
		}
		
		public function flipGrid(grid:Array)
		{
			for (var i:int = 0; i < 4; i++)
			{
				var row:Array = grid[i];
				grid[i] = row.reversed.toList();
			}
			return grid;
		}
		
		public function transposeGrid(grid:Array)
		{
			var newGrid:Array = blankGrid();
			
			for (var i:int = 0; i < 4; i++)
			{
				for (var j:int = 0; j < 4; j++)
				{
					newGrid[i][j] = grid[j][i];
				}
			}
			return newGrid;
		}
		
		public function addNumber(grid:Array, gridNew:Array)
		{
			var options:Array = [];
			for (var i:int = 0; i < 4; i++)
			{
				for (var j:int = 0; j < 4; j++)
				{
					if (grid[i][j] == 0)
					{
						options.push(Position(i, j));
					}
				}
			}
			
			if (options.length > 0)
			{
				var spotRandomIndex:int = Math.floor(Math.Random() * options.length);
				var spot:Position = options[spotRandomIndex];
				var r:int = Math.floor(Math.Random() * 100);
				grid[spot.x][spot.y] = r > 50 ? 4 : 2;
				gridNew[spot.x][spot.y] = 1;
			}
			
			return grid;
		}
	
	}

}