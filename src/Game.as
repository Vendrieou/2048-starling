package
{
	import flash.filesystem.File;
	import flash.ui.Keyboard;
	import starling.assets.AssetManager;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.KeyboardEvent;
	import starling.text.TextField;
	
	/**
	 * ...
	 * @author your_name
	 */
	public class Game extends Sprite
	{
		private var assetsManager:AssetManager;
		
		private var blockPlayer:Image;
		private var circleList:Vector.<Image> = new Vector.<Image>();
		private var circleSpeed:int = 10;
		private var circleVertical:int = 0;
		
		private var jump:Boolean = false;
		private var speedUp:int;
		
		public function Game()
		{
			var appDir:File = File.applicationDirectory;
			//SET ASSETS MANAGER
			
			assetsManager = new AssetManager();
			assetsManager.enqueue(appDir.resolvePath("image"));
			
			assetsManager.loadQueue(startGame);
		}
		
		private function startGame():void
		{
			//create player
			blockPlayer = new Image(assetsManager.getTexture("block"));
			blockPlayer.pivotY = blockPlayer.height;
			blockPlayer.x = 100;
			blockPlayer.y = 600;
			addChild(blockPlayer);
			
			// circle
			for (var i:int = 0; i < 1; i++)
			{
				var circleItem:Image = new Image(assetsManager.getTexture("circle"));
				circleItem.visible = false;
				circleItem.x = 1024;
				circleItem.y = 0;
				addChild(circleItem);
				circleList.push(circleItem);
			}
			
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, pressKeyboard);
			this.stage.addEventListener(KeyboardEvent.KEY_UP, upKeyboard);
			this.addEventListener(EnterFrameEvent.ENTER_FRAME, enterFrame);
		}
		
		private function enterFrame(e:EnterFrameEvent):void
		{
			
			if (jump == true)
			{
				blockPlayer.y -= speedUp;
				
				if (blockPlayer.y >= 601)
				{
					jump = false;
				}
				if (speedUp > -10)
				{
					speedUp--;
				}
			}
			// circle
			for (var i:int = 0; i < circleList.length; i++)
			{
				if (circleList[i].visible == false)
				{
					circleList[i].visible = true;
					circleVertical = 550;
					circleList[i].y = circleVertical;
				}
				if (circleList[i].x <= 0)
				{
					circleList[i].x = this.stage.width + (Math.floor(Math.random() * (800 - 200 + 1)) + 200);
					if ((Math.floor(Math.random() * (4 - 1 + 1)) + 1) % 2 == 0)
					{
						circleList[i].y = 465;
					}
					else
					{
						circleList[i].y = 550;
					}
				}
				
				if (circleList[i].visible == true)
				{
					circleList[i].x -= 6;
				}
				
				// stop process
				if (circleList[i].bounds.intersects(blockPlayer.bounds) == true || circleList[i].y >= 650)
				{
					this.stage.starling.stop();
				}
			}
		
		}
		
		private function pressKeyboard(e:KeyboardEvent):void
		{
			if (jump == true) return;
			if (e.keyCode == Keyboard.UP)
			{
				jump = true;
				speedUp = 20;
			}
			else if (e.keyCode == Keyboard.DOWN)
			{
				blockPlayer.scaleY = 0.5;
			}
		}
		
		private function upKeyboard(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.DOWN)
			{
				blockPlayer.scaleY = 1;
			}
		}
		
		private function moveLeft(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.DOWN)
			{
				blockPlayer.scaleY = 1;
			}
		}
		
		//private function moveRight(e:KeyboardEvent):void 
		//{
		//}
		//
		//private function moveUp(e:KeyboardEvent):void 
		//{
		//}
		//
		//private function moveDown(e:KeyboardEvent):void 
		//{
		//}
		
		//===== logic ======
		
		public function operate(row:Array, score:int, sharedPref):Array
		{
			row = slide(row);
			var result:Array = combine(row, score, sharedPref);
			var sc:int = result[0];
			row = result[1];
			row = slide(row);
			
			// warn!('from func ${sc}');
			return [sc, row];
		}
		
		public function filtered(row:Array):Array
		{
			var temp:Array = [];
			for (var i:int = 0; i < row.length; i++)
			{
				if (row[i] != 0)
				{
					temp.add(row[i]);
				}
			}
			return temp;
		}
		
		public function slide(row:Array):Array
		{
			var arr:Array = filter(row);
			var missing:int = 4 - arr.length;
			var zeroes:Array = zeroArray(missing);
			arr = zeroes + arr;
			
			return arr;
		}
		
		public function zeroArray(length:int):Array
		{
			var zeroes:Array = [];
			for (var i:int = 0; i < length; i++)
			{
				zeroes.add(0);
			}
			return zeroes;
		}
		
		public function combine(row:Array, score:int, sharedPref):Array
		{
			for (var i:int = 3; i >= 1; i--)
			{
				var a:int = row[i];
				var b:int = row[i - 1];
				if (a == b)
				{
					row[i] = a + b;
					score += row[i];
					var sc:int = sharedPref.getInt('high_score');
					
					if (sc == null)
					{
						sharedPref.setInt('high_score', score);
					}
					else
					{
						if (score > sc)
						{
							sharedPref.setInt('high_score', score);
						}
					}
					row[i - 1] = 0;
					
				}
			}
			return [score, row];
		}
		
		public function isGameWon(grid:Array):Boolean
		{
			for (var i:int = 0; i < 4; i++)
			{
				for (var j:int = 0; j < 4; j++)
				{
					if (grid[i][j] == 2048)
					{
						return true;
					}
				}
			}
			return false;
		}
		
		public function isGameOver(grid:Array)
		{
			for (var i:int = 0; i < 4; i++)
			{
				for (var j:int = 0; j < 4; j++)
				{
					if (grid[i][j] == 0)
					{
						return false;
					}
					if (i != 3 && grid[i][j] == grid[i + 1][j])
					{
						return false;
					}
					if (j != 3 && grid[i][j] == grid[i][j + 1])
					{
						return false;
					}
				}
			}
			return true;
		}
	
	}
}