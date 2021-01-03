package
{
	import flash.filesystem.File;
	import flash.ui.Keyboard;
	import starling.assets.AssetManager;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.display.Quad;
	import starling.events.EnterFrameEvent;
	import starling.events.KeyboardEvent;
	import starling.text.TextField;
	
	/**
	 * ...
	 * @author vendrie
	 */
	public class Game extends Sprite
	{
		private var assetsManager:AssetManager;
		
		private var grid_cells : Array = [];
		private var history_matrixs : Array = [];
		private var matrix = new Logic().new_game(4);
		
		public var logic : Logic = new Logic();
		
		public function Game()
		{
			//var appDir:File = File.applicationDirectory;
			//SET ASSETS MANAGER
			
			assetsManager = new AssetManager();
			//assetsManager.enqueue(appDir.resolvePath("image"));
			//
			assetsManager.loadQueue(startGame);
		}
		
		private function startGame():void
		{
			// create background		
			var gridBackground:Quad = new Quad(500, 500, 0xFFa2917d);
			addChild(gridBackground);			
			
			for (var i:int = 0; i < 4; i++) {
				var grid_row : Array = [];
				
				for (var j:int = 0; j < 4; j++) {
					var grid:Quad = new Quad(100, 100, 0xffffff);
					grid.x = 10 + (i * 120);
					grid.y = 10 + (j * 120);
					addChild(grid);
					
					var text:TextField = new TextField(0,0);
					text.width = 120 + (i * 240);
					text.height= 120 + (j * 240);
					text.text = "0";
					text.padding = 260;
					addChild(label);
					
					grid_row.push(text);
				}
				grid_cells.push(grid_row);
			}
		}
			
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, pressKeyboard);
			//this.stage.addEventListener(KeyboardEvent.KEY_UP, upKeyboard);
			this.addEventListener(EnterFrameEvent.ENTER_FRAME, enterFrame);
		}

		// update grid cells function
		public function update_grid_cells():void 
		{
			for (var i:int = 0; i < 4; i++) {
				for (var j:int = 0; j < 4; j++) {
					var new_number : int = matrix[i][j];
					if (new_number == 0) {
						grid_cells[i][j].text = "";
					} 
					else {
						grid_cells[i][j].text = new_number.toString();
						//background color
					}
					
				}
			}
		}
		
		public function pressKeyboard(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.B && history_matrixs.length > 1) {
				matrix = history_matrixs.pop();
				update_grid_cells();
			} else if (e.keyCode) {
				if (done) {
					// is Win
					if (logic.game_state(matrix) == "win") {
						var winText : TextField = new TextField(250, 250);
						winText.text = "You Win";
						winText.x = 250;
						winText.y = 250;
						addChild(winText);
					}
					
					// is Lose
					if (logic.game_state(matrix) == "lose") {
						var loseText : TextField = new TextField(250, 250);
						loseText.text = "You Lose";
						loseText.x = 250;
						loseText.y = 250;
						addChild(loseText);
					}
					
				}
			}
		}

		
		//private function enterFrame(e:EnterFrameEvent):void
		//{
			//
			////if (jump == true)
			////{
				////blockPlayer.y -= speedUp;
				////
				////if (blockPlayer.y >= 601)
				////{
					////jump = false;
				////}
				////if (speedUp > -10)
				////{
					////speedUp--;
				////}
			////}
			////// circle
			////for (var i:int = 0; i < circleList.length; i++)
			////{
				////if (circleList[i].visible == false)
				////{
					////circleList[i].visible = true;
					////circleVertical = 550;
					////circleList[i].y = circleVertical;
				////}
				////if (circleList[i].x <= 0)
				////{
					////circleList[i].x = this.stage.width + (Math.floor(Math.random() * (800 - 200 + 1)) + 200);
					////if ((Math.floor(Math.random() * (4 - 1 + 1)) + 1) % 2 == 0)
					////{
						////circleList[i].y = 465;
					////}
					////else
					////{
						////circleList[i].y = 550;
					////}
				////}
				////
				////if (circleList[i].visible == true)
				////{
					////circleList[i].x -= 6;
				////}
				////
				////// stop process
				////if (circleList[i].bounds.intersects(blockPlayer.bounds) == true || circleList[i].y >= 650)
				////{
					////this.stage.starling.stop();
				////}
			////}
		//
		//}
		//
	
			//for (var i:int = 0; i < 4; i++)
			//{
				//for (var j:int = 0; j < 4; j++)
				//{
					//if (grid[i][j] == 0)
					//{
						//return false;
					//}
					//if (i != 3 && grid[i][j] == grid[i + 1][j])
					//{
						//return false;
					//}
					//if (j != 3 && grid[i][j] == grid[i][j + 1])
					//{
						//return false;
					//}
				//}
			//}
			//return true;
		//}
	}
}
