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
					if (circleList[i].x <= 0){
						circleList[i].x = this.stage.width + (Math.floor(Math.random() * (800 - 200 + 1)) + 200);
						if((Math.floor(Math.random() * (4 - 1 + 1)) + 1) % 2 == 0){
							circleList[i].y = 465;
						} else {
							circleList[i].y = 550;
						}
					}
					
					if (circleList[i].visible == true){
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
	}
}