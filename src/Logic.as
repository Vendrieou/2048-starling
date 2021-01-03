package 
{
	/**
	 * ...
	 * @author Vendrie
	 */
	public class Logic 
	{
		
		public function new_game(n: int):Array 
		{
			var matrix : Array = [];
			var newArr : Array = [];
			for (var i:int = 0; i < n; i++) {
				matrix.push(newArr);
			}
			matrix = add_two(matrix);
			matrix = add_two(matrix);
			return matrix;
		}
//
//###########
//# Task 1b #
//###########
//
//# [Marking Scheme]
//# Points to note:
//# Must ensure that it is created on a zero entry
//# 1 mark for creating the correct loop

	public function add_two(mat: Array):Array 
	{
		var a : int = randomInt(0, (mat.length - 1));
		var b : int = randomInt(0, (mat.length - 1));
		while (mat[a][b] != 0) {
			a = randomInt(0, (mat.length - 1));
			b = randomInt(0, (mat.length - 1));
		}
		
		mat[a][b] = 2;
		return mat;
	}

//###########
//# Task 1c #
//###########

//# [Marking Scheme]
//# Points to note:
//# Matrix elements must be equal but not identical
//# 0 marks for completely wrong solutions
//# 1 mark for getting only one condition correct
//# 2 marks for getting two of the three conditions
//# 3 marks for correct checking
	
	public function game_state(mat: Array):String 
	{
		//# check for win cell
        for (var i:int = 0; i < mat.length; i++) {
			for (var j:int = 0; j < mat[0].length; j++) {
				if (mat[i][j] == 2048){
					return 'win'
				}
			}
		}
		
		//# check for any zero entries
		for (var o:int = 0; o < mat.length; o++) {
			for (var p:int = 0; p < mat[0].length; p++) {
				if (mat[o][p] == 0){
					return 'not over';
				}
			}
		}
		
		//# check for same cells that touch each other
        for (var k:int = 0; k < mat.length - 1; k++) {
			// intentionally reduced to check the row on the right and below
			// more elegant to use exceptions but most likely this will be their solution
			for (var l:int = 0; l < mat[0].length - 1; l++) {
				if (mat[k][l] == mat[k + 1][l] || mat[k][l + 1] == mat[k][l]) {
					return 'not over';
				}
			}
		}
	
		// # to check the left/right entries on the last row
		for (var m:int = 0; m < mat.lenght - 1; m++) {
			if (mat[mat.length-1][m] == mat[mat.length-1][m+1]) {
				return 'not over';
			}
		}

		// # check up/down entries on last column
		for (var n:int = 0; n < mat.length-1; n++) {
			if (mat[n][mat.length-1] == mat[n+1][mat.length-1]) {
				return 'not over'
			}
		}
        
		return 'lose'
	}

//###########
//# Task 2a #
//###########
//
//# [Marking Scheme]
//# Points to note:
//# 0 marks for completely incorrect solutions
//# 1 mark for solutions that show general understanding
//# 2 marks for correct solutions that work for all sizes of matrices

	public function reverse(mat: Array):Array
	{
		var newGame : Array = [];
		for (var i:int = 0; i < mat.length; i++) {
			newGame.push([]);
			for (var j:int = 0; j < mat[0].length; j++) {
				newGame[i].push(mat[i][mat[0].length - j - 1]);
			}
		}
		return newGame;
	}

//###########
//# Task 2b #
//###########
//
//# [Marking Scheme]
//# Points to note:
//# 0 marks for completely incorrect solutions
//# 1 mark for solutions that show general understanding
//# 2 marks for correct solutions that work for all sizes of matrices


	public function transpose(mat: Array):Array
	{
		var newGame : Array = [];
		for (var i:int = 0; i < mat[0].length; i++) {
			newGame.push([]);
			for (var j:int = 0; j < mat.length; j++) {
				newGame[i].push(mat[j][i]);
			}
		}
		return newGame;
	}
	
//##########
//# Task 3 #
//##########
//
//# [Marking Scheme]
//# Points to note:
//# The way to do movement is compress -> merge -> compress again
//# Basically if they can solve one side, and use transpose and reverse correctly they should
//# be able to solve the entire thing just by flipping the matrix around
//# No idea how to grade this one at the moment. I have it pegged to 8 (which gives you like,
//# 2 per up/down/left/right?) But if you get one correct likely to get all correct so...
//# Check the down one. Reverse/transpose if ordered wrongly will give you wrong result.
	
		public function cover_up(mat: Array):Object
		{
			var newGame: Array = [];
			var done : Boolean = false;

			for (var j:int = 0; j < 4; j++) {
				var partial_new : Array = [];
				for (var i:int = 0; i < 4; i++) {
					partial_new.push(0);
				}
				newGame.push(partial_new);
			}
			done = false;
			
			for (var k:int = 0; k < 4; k++){
				var count : int = 0;
				for (var l:int = 0; l < 4; l++){
					if (mat[k][l] != 0){
						newGame[k][count] = mat[k][l];
						if (l != count) {
							done = true;
							count += 1;
						}
					}
				}
			}
			
			return { newGame: newGame, done: done };
		}

		public function merge(mat: Array, done: Boolean):Object
		{
			for (var i:int = 0; i < 4; i++)
			{
				for (var j:int = 0; j < 4 - 1; j++)
				{
					if (mat[i][j] == mat[i][j + 1] && mat[i][j] != 0)
					{
						mat[i][j] *= 2;
						mat[i][j + 1] = 0;
						done = true;	
					}
					
					
				}
			}
			
			return { mat: mat, done: done }
		}

		public function up(game: Array):Object
		{
			// return matrix after shifting up
			game = transpose(game);
			
			var done : Boolean = false;
			var dataCoverUp : Object = cover_up(game);
			game = dataCoverUp.newGame;
			done = dataCoverUp.done;
			
			// merge
			var dataMerge : Object = merge(game, done);
			game = dataMerge.mat;
			done = dataMerge.done;
			
			game = dataCoverUp.newGame;
			game = transpose(game);
			return { game: game, done: done };
		}

		public function down(game:Array):Object
		{
			// keyboard down
			game = reverse(transpose(game));
			
			var done : Boolean = false;
			var dataCoverUp : Object = cover_up(game);
			game = dataCoverUp.newGame;
			done = dataCoverUp.done;
			
			// merge
			var dataMerge : Object = merge(game, done);
			game = dataMerge.mat;
			done = dataMerge.done;
			
			game = dataCoverUp.newGame;
			game = transpose(reverse(game));
			return { game: game, done: done };
		}

		public function left(game:Array):Object
		{
			// return matrix after shifting left
			var done : Boolean = false;
			var dataCoverUp : Object = cover_up(game);
			game = dataCoverUp.newGame;
			done = dataCoverUp.done;
			
			// merge
			var dataMerge : Object = merge(game, done);
			game = dataMerge.mat;
			done = dataMerge.done;
			
			game = dataCoverUp.newGame;
			return { game: game, done: done};
		}
			
		public function right(game:Array):Object
		{
			// return matrix after shifting right
			var done : Boolean = false;
			var dataCoverUp : Object = cover_up(game);
			game = reverse(game);
			game = dataCoverUp.newGame;
			done = dataCoverUp.done;
			
			// merge
			var dataMerge : Object = merge(game, done);
			game = dataMerge.mat;
			done = dataMerge.done;
			
			game = dataCoverUp.newGame;
			game = reverse(game);
			return { game:game, done: done };
		}
	
	
		private function randomInt(minVal:int, maxVal:int):int {
		  return minVal + Math.floor(Math.random() * (maxVal + 1 - minVal));
		}
	}

}