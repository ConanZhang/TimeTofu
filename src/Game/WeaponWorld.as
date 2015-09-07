/**
 * World for testing Box2D
 */
package Game
{
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.media.SoundChannel;
	import flash.net.SharedObject;
	import flash.utils.Timer;
	
	import Assets.BigFlyingEnemy;
	import Assets.BigPlatformEnemy;
	import Assets.FlyingEnemy;
	import Assets.ItemDrop;
	import Assets.Platform;
	import Assets.PlatformEnemy;
	import Assets.Player;
	import Assets.Rain;
	import Assets.SmallFlyingEnemy;
	import Assets.SmallPlatformEnemy;
	
	import Parents.Stage;
	
	public class WeaponWorld extends Stage
	{
		private var screen:FlashGame;
		private var background:Background;
		private var rain:Rain;	
		
		private var enemyAdded:Boolean;
		
		private var settings:SharedObject;
		
		private var enemyAdd:Timer;
		private var ammoAdd:Timer;
		
		private var trapped:Boolean;
		private var test:Timer;
		private var HUD:PlayerHUD;
		
		/**			Constructor
		 * 
		 * Takes in screen it will be added to
		 * 
		 */
		public function WeaponWorld(screenP:FlashGame, debugging:Boolean, pacifist:Boolean, world:int, _hasRain:Boolean, _settings:SharedObject, _musicChannel:SoundChannel, _HUD:PlayerHUD)
		{			
			screen = screenP;
			screen.addChildAt(this,0);
			
			settings = _settings;
			HUD = _HUD;
			super(screen,debugging, 30, 7, pacifist, world, 0, _musicChannel, settings, HUD);
			
			//BACKGROUND
			background = new Background("TutorialWeapons");
			
			//RAIN
			
			trapped = false;
			
			hasRain = _hasRain;
			if(hasRain){
				if(Math.random() > 0.5){
					rain = new Rain(this, 100,900,525,50, Math.random()*(20-10)+10, Math.random()*(8-3)+3, "left");
				}
				else{
					rain = new Rain(this, 100,900,525,50, Math.random()*(20-10)+10, Math.random()*(8-3)+3, "right");
				}
			}
			
			//GROUND & SKY
			var ground:Platform = new Platform(7, 15, 230, 15, "b_wide");
			var sky:Platform = new Platform(7, -110, 230, 15, "b_wide");
			
			//WALLS
			var leftWall:Platform = new Platform(-5,-170, 30, 200, "b_tall");
			var rightWall:Platform = new Platform(200,-170, 30, 200, "b_tall");
			
			var pistolDrop:ItemDrop = new ItemDrop(40, 8, 1.5,1.5, 2,  settings, HUD);	
			var shotgunDrop:ItemDrop = new ItemDrop(55, 8, 2.5,2.5, 3, settings, HUD);	
			var machinegunDrop:ItemDrop = new ItemDrop(80, 8, 2,2, 4, settings, HUD);				
			var heartDrop:ItemDrop = new ItemDrop(95, 8, 1.5,1.5, 1, settings, HUD);				
			var pistolDrop1:ItemDrop = new ItemDrop(110, 8, 1.5,1.5, 2,  settings, HUD);				
			var shotgunDrop1:ItemDrop = new ItemDrop(125, 8, 2.5,2.5, 3,  settings, HUD);				
			var machinegunDrop1:ItemDrop = new ItemDrop(130, 8, 2,2, 4,  settings, HUD);	
			var heartDrop1:ItemDrop = new ItemDrop(135, 8, 1.5,1.5, 1,  settings, HUD);
			
			var endPlatform:Platform = new Platform(185, 5,10, 2, "wide");
			
			var endPlatform1:Platform = new Platform(135, -20, 10, 2, "wide");
			var blockade1:Platform = new Platform(153, -35, 50, 10, "b_wide");

			var endPlatform2:Platform = new Platform(185, -45, 10, 2, "wide");
			var blockade2:Platform = new Platform(130, -60, 50, 10, "b_wide");

			var endPlatform3:Platform = new Platform(135, -70, 10, 2, "wide");
			var blockade3:Platform = new Platform(153, -85, 50, 10, "b_wide");
			
//			test = new Timer(5000);
//			test.addEventListener(TimerEvent.TIMER, testing);
//			test.start();
			


			
			this.addEventListener(Event.ENTER_FRAME, addTargets);
		}
		
		protected function testing(event:TimerEvent):void
		{
			var testEnemy1:PlatformEnemy = new PlatformEnemy(50, 0, 4, 4, 0, 0, settings, HUD);
			var testEnemy2:PlatformEnemy = new PlatformEnemy(55, 0, 4, 4, 0, 0, settings, HUD);
			var testEnemy3:PlatformEnemy = new PlatformEnemy(60, 0, 4, 4, 0, 0, settings, HUD);
			var testEnemy4:PlatformEnemy = new PlatformEnemy(65, 0, 4, 4, 0, 0, settings, HUD);
			var testEnemy5:PlatformEnemy = new PlatformEnemy(70, 0, 4, 4, 0, 0, settings, HUD);
			var testEnemy6:PlatformEnemy = new PlatformEnemy(75, 0, 4, 4, 0, 0, settings, HUD);
			var testEnemy7:PlatformEnemy = new PlatformEnemy(80, 0, 4, 4, 0, 0, settings, HUD);
			var testEnemy8:PlatformEnemy = new PlatformEnemy(85, 0, 4, 4, 0, 0, settings, HUD);
			var testEnemy9:PlatformEnemy = new PlatformEnemy(90, 0, 4, 4, 0, 0, settings, HUD);
			var testEnemy10:PlatformEnemy = new PlatformEnemy(95, 0, 4, 4, 0, 0, settings, HUD);
			test.stop()
		}
		
		protected function addTargets(event:Event):void
		{
			if(player.body.GetPosition().x > 132){
				var blockade:Platform = new Platform(100,-170, 30, 200, "b_tall");
				var blockade1:Platform = new Platform(130, -10, 50, 10, "b_wide");

				enemyAdd = new Timer(7500);
				enemyAdd.addEventListener(TimerEvent.TIMER, addEnemy);
				enemyAdd.start();
				
				ammoAdd = new Timer(15000);
				ammoAdd.addEventListener(TimerEvent.TIMER, addAmmo);
				ammoAdd.start();
				
				var testEnemy1:FlyingEnemy = new FlyingEnemy(170, 8, 2, 3,  settings, HUD);
				
				trapped = true;

				this.removeEventListener(Event.ENTER_FRAME, addTargets);
			}
		}
		
		private function addEnemy(e:TimerEvent):void{
			//test enemies
			if(!paused && Player.playerHealth > 0){
				var randomAdd:Number = Math.random();
				
				if(randomAdd > 0.66 && flyCount < 4){
					var testEnemy1:FlyingEnemy = new FlyingEnemy(Math.random()*190 + 40, Math.random()*-90, 2, 3, settings, HUD);
				}
				else if(randomAdd > 0.33 && bigFlyCount < 3){
					var testEnemy2:BigFlyingEnemy = new BigFlyingEnemy(Math.random()*190 + 40, Math.random()*-90, 4, 5, settings, HUD);
				}
				else if(smallFlyCount < 3){
					var testEnemy3:SmallFlyingEnemy = new SmallFlyingEnemy(Math.random()*190 + 40, Math.random()*-90, 1.5, 1.5, settings, HUD);
				}

				randomAdd = Math.random();
				
				var randomType:Number = Math.random();
				var randomDirection:int;
				if(Math.random() > 0.5){
					randomDirection = 1;
				}
				else{
					randomDirection = 2;
				}
				
				if(randomAdd > 0.66 && platformCount < 4){
					//floats
					if(randomType > 0.66){
						var testEnemy4:PlatformEnemy = new PlatformEnemy(Math.random()*(190-135) + 135, Math.random()*-90, 4, 4, 0, randomDirection, settings, HUD);
					}
						//goes up and down
					else if(randomType > 0.33){
						var testEnemy5:PlatformEnemy = new PlatformEnemy(Math.random()*(190-135) + 135, Math.random()*-90, 4, 4, 1, randomDirection, settings, HUD);
					}
						//goes left and right
					else{
						var testEnemy6:PlatformEnemy = new PlatformEnemy(Math.random()*(190-135) + 135, Math.random()*-90, 4, 4, 2, randomDirection,  settings, HUD);
					}
				}
				else if(randomAdd > 0.33 && bigPlatformCount < 3){
					//floats
					if(randomType > 0.66){
						var testEnemy7:BigPlatformEnemy = new BigPlatformEnemy(Math.random()*(190-135) + 135, Math.random()*-90, 5, 5, 0, randomDirection, settings, HUD);
					}
						//goes up and down
					else if(randomType > 0.33){
						var testEnemy8:BigPlatformEnemy = new BigPlatformEnemy(Math.random()*(190-135) + 135, Math.random()*-90, 5, 5, 1, randomDirection,  settings, HUD);
					}
						//goes left and right
					else{
						var testEnemy9:BigPlatformEnemy = new BigPlatformEnemy(Math.random()*(190-135) + 135, Math.random()*-90, 5, 5, 2, randomDirection, settings, HUD);
					}
				}
				else if(smallPlatformCount < 3){
					//floats
					if(randomType > 0.66){
						var testEnemy10:SmallPlatformEnemy = new SmallPlatformEnemy(Math.random()*(190-135) + 135, Math.random()*-90, 2.25, 2.5, 0, randomDirection, settings, HUD);
					}
						//goes up and down
					else if(randomType > 0.33){
						var testEnemy11:SmallPlatformEnemy = new SmallPlatformEnemy(Math.random()*(190-135) + 135, Math.random()*-90, 2.25, 2.5, 1, randomDirection, settings, HUD);
					}
						//goes left and right
					else{
						var testEnemy12:SmallPlatformEnemy = new SmallPlatformEnemy(Math.random()*(190-135) + 135, Math.random()*-90, 2.25, 2.5, 2, randomDirection, settings, HUD);
					}
				}
				
			}
		}
		
		private function addAmmo(e:TimerEvent):void{
			if(!paused && Player.playerHealth != 0){
				var randomDrop: Number = Math.random();
				
				if(ammunitionCount < 10){
					//pistol ammo
					if(randomDrop < 0.4){
						var pistolDrop:ItemDrop = new ItemDrop(Math.random()*(190-135) + 135, Math.random()*(10-6)+6, 1.5,1.5, 2, settings, HUD);	
					}
						//shotgun ammo
					else if(randomDrop > 0.4 && randomDrop < 0.65){
						var shotgunDrop:ItemDrop = new ItemDrop(Math.random()*(190-135) + 135, Math.random()*(10-6)+6, 2.5,2.5, 3, settings, HUD);	
					}
						//machinegun ammo
					else if(randomDrop > 0.65 && randomDrop < 0.9){
						var machinegunDrop:ItemDrop = new ItemDrop(Math.random()*(190-135) + 135, Math.random()*(10-6)+6, 2,2, 4,  settings, HUD);	
					}
					else{
						var heartDrop1:ItemDrop = new ItemDrop(Math.random()*(190-135) + 135, Math.random()*(10-6)+6, 1.5,1.5, 1, settings, HUD);
					}
				}
			}
		}
		
		public override function removeAddRain():void{
			if(hasRain){
				rain.destroy();
				hasRain = false;
				settings.data.hasRain = "false";
			}
			else{
				if(Math.random() > 0.5){
					rain = new Rain(this, 100,900,525,50, Math.random()*(20-10)+10, Math.random()*(8-3)+3, "left");
				}
				else{
					rain = new Rain(this, 100,900,525,50, Math.random()*(20-10)+10, Math.random()*(8-3)+3, "right");
				}
				hasRain = true;
				settings.data.hasRain = "true";
			}
			
			settings.flush();
		}
		
		public override function childDestroy():void{
			if(trapped){
				if(enemyAdd != null){
					enemyAdd.removeEventListener(TimerEvent.TIMER, addEnemy);
					enemyAdd.stop();
				}
				
				if(ammoAdd != null){
					ammoAdd.removeEventListener(TimerEvent.TIMER, addAmmo);
					ammoAdd.stop();	
				}
			}
			else{
				this.removeEventListener(Event.ENTER_FRAME, addTargets);

			}
		}
	}
}