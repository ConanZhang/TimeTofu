/**
 * HUD for screen.
 */ 
package FlashGame
{
	import Assets.Player;
	import Assets.Weapon;
	
	import Parents.Stage;
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	public class PlayerHUD extends Sprite
	{
		
		private var screen:Sprite;
		
		//health
		private var heart1:MovieClip;
		private var heart2:MovieClip;
		private var heart3:MovieClip;

		//slow motion bar
		private var slowMotionBar:Shape;
		private var slowBarClip:MovieClip;
		
		//fade
		private var fadeClip:MovieClip;
		
		//ammo
		private var ammoCount:TextField;
		
		/**Constructor*/
		public function PlayerHUD(screenP:Sprite)
		{
			screen = screenP;
			screen.addChild(this);
			
			fadeClip = new slowscreen();
			
			fadeClip.alpha = 0;
			
			fadeClip.width = 300;
			fadeClip.height = 300;
			
			fadeClip.x = 350;
			fadeClip.y = 262.5;
			
			this.addChild(fadeClip);
			
			//health
			heart1 = new heart();
			heart2 = new heart();
			heart3 = new heart();
			
			heart1.height = 40;
			heart1.width = 40;
			heart2.height = 40;
			heart2.width = 40;
			heart3.height = 40;
			heart3.width = 40;
			
			heart1.x = 560;
			heart1.y = 80;
			heart2.x = 610;
			heart2.y = 80;
			heart3.x = 660;
			heart3.y = 80;
			
			this.addChild(heart1);
			this.addChild(heart2);
			this.addChild(heart3);
			
			heart1.gotoAndStop("idle");
			heart2.gotoAndStop("idle");
			heart3.gotoAndStop("idle");
			
			
			//slow motion bar
			slowMotionBar = new Shape();
			slowMotionBar.graphics.clear();
			slowMotionBar.graphics.beginFill(0xff0000);
			slowMotionBar.graphics.drawRect(450, 25, Stage.slowBarWidth, 20);
			slowMotionBar.graphics.endFill();
			
			this.addChild(slowMotionBar);
			
			slowBarClip = new slowbar();
			slowBarClip.width = 230;
			slowBarClip.height = 45;
			
			slowBarClip.x = 565;
			slowBarClip.y = 33;
			
			this.addChild(slowBarClip);
			
			//ammunition
			ammoCount = new TextField();
			ammoCount.height = 500;
			ammoCount.x = 600;
			ammoCount.y = 450;
			ammoCount.textColor = 0xff0000;
			this.addChild(ammoCount);
		}
		
		/**Called in stage update*/
		public function updateHUD():void{
			//VISUAL fade effect
			if(fadeClip.alpha < 0.2 && Stage.usingSlowMotion && Stage.slowMotionAmount > 0){
				fadeClip.alpha+=0.02;
			}
			else if(fadeClip.alpha > 0 && !Stage.usingSlowMotion || Stage.slowMotionAmount <= 0 && fadeClip.alpha > 0){
				fadeClip.alpha-=0.02;
			}
			
			//health
			if(Player.playerHealth == 2){
				heart1.gotoAndStop("dying");
			}
			else if(Player.playerHealth == 1){
				heart2.gotoAndStop("dying");
			}
			else if(Player.playerHealth == 0){
				heart3.gotoAndStop("dying");
			}
			
			//slow motion bar
			slowMotionBar.graphics.clear();
			slowMotionBar.graphics.beginFill(0xff0000);
			slowMotionBar.graphics.drawRect(450, 25, Stage.slowBarWidth, 20);
			slowMotionBar.graphics.endFill();
			
			//ammo
			ammoCount.text = Weapon.weaponType + "\n" +
							 "Ammo: " + Weapon.weaponAmmo;
		}
	}
			
}
