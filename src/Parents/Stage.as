/**
 * Parent class for all stages
 */
package Parents
{
	import Assets.Player;
	
	import Box2D.Collision.b2AABB;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2World;
	
	import FlashGame.ContactListener;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;

	public class Stage extends MovieClip
	{
		/**Class Member Variables*/
		//constant to determine how much a pixel is in metric units
		public static const metricPixRatio: Number = 20;
		
		/**BOX2D*/
		//number of checks over position and velocity
		private var iterations:int;
		//speed of checks
		private var timeStep:Number;
		
		/**LOGIC*/
		//check if the stage has just been initiated; SEE update()
		private var initial:Boolean;
		//array to hold key presses
		private var keyPresses:Array;
		
		/**WORLD*/
		//world for all objects to exist in
		private static var worldStage:b2World;
		//variable for all images to be held in for camera movement
		private static var images:Sprite;
		
		/**PLAYER*/
		//player body for collision detection
		public static var player:b2Body;
		//the last position the player was (for speed calculation)
		private var lastPos:Point;
		//horizontal speed
		private static var horizontal:Number;
		//vertical speed
		private static var vertical:Number;
		//acceleration
		private var acceleration:Number;
		//is the player jumping
		public static var jumping:Boolean;
		//is the player wall jumping from the right
		public static var rightWall:Boolean;
		//is the player wall jumping from the left
		public static var leftWall:Boolean;
		//how long have they been jumping
		public static var jumpTime:int;
		//current number of times player can jump
		public static const defaultJumpAmount:int = 2;
		//current number of times player can jump
		public static var jumpAmount:int;
		
		
		/**Constructor*/
		public function Stage()
		{
			/**BOX2D*/
			//initiate time
			iterations = 10;
			timeStep = 1/30;
			
			/**LOGIC*/
			initial = true;
			keyPresses = new Array();
			
			/**VISUAL*/
			//initiate images
			images = new Sprite();
			this.addChild(images);
			
			/**EVENT*/
			//update every frame
			this.addEventListener(Event.ENTER_FRAME, update, false, 0, true);

			/**WORLD*/
			var gravity:b2Vec2 = new b2Vec2(0, 85);
			var doSleep:Boolean = true;//don't simulate sleeping bodies
			worldStage = new b2World(gravity, doSleep);
			worldStage.SetContactListener(new ContactListener() );
			
			/**PLAYER*/
			lastPos = new Point();
			horizontal = 0;
			vertical = 0;
			acceleration = 0;
			jumping = false;
			rightWall = false;
			leftWall = false;
			jumpTime = 0;
			jumpAmount = defaultJumpAmount;
			
			/**DEBUGGING*/
			debugDrawing();
		}
		
		/**Stages can update their properties*/
		public function update(e:Event):void{
			//get last position player was in for initial speed calculation
			if(initial){
				lastPos = new Point(player.GetPosition().x, player.GetPosition().y);
				//never need to do it again
				initial = false;
			}
			
			//clear sprites from last frame
			sprites.graphics.clear();
			
			/**CAMERA*/
			centerScreen(player.GetPosition().x, player.GetPosition().y);
			
			/**BOX2D*/
			world.Step(timeStep,iterations,iterations);
			world.ClearForces();
			world.DrawDebugData();
			
			/**OBJECTS*/
			for(var bodies:b2Body = world.GetBodyList(); bodies; bodies = bodies.GetNext() ){
				//if they exist update them
				if(bodies.GetUserData() != null){
					bodies.GetUserData().update();
				}
			}
			
			/**FORCES & KEY PRESSES*/
			var direction:b2Vec2 = new b2Vec2();
			
			for(var i:uint = 0; i < keyPresses.length;i++){
				switch(keyPresses[i]){
					//down arrow
					case Keyboard.DOWN:
						direction.Set(0, 40);
						player.SetAwake(true);
						player.ApplyForce(direction, player.GetPosition() );
						break;
					//up arrow
					case Keyboard.UP:
						//initial jump
						if(jumping == false && !rightWall && !leftWall){
							jumping = true;
							direction.Set(0,-35);
							player.SetAwake(true);
							player.ApplyImpulse(direction, player.GetPosition() );
							Player.STATE = Player.JUMPING;
						}
						//continuing initial jump
						else if(jumping == true && 
								jumpTime <= 5 && 
								jumpAmount == defaultJumpAmount){
							jumpTime++;
							direction.Set(0,-700);
							player.SetAwake(true);
							player.ApplyForce(direction, player.GetPosition() );
						}
						//double jump
						else if(jumping == true &&
								jumpTime <= 5 &&
								jumpAmount < defaultJumpAmount && 
								jumpAmount > 0){
							jumpTime++;
							direction.Set(0,-30);
							player.SetAwake(true);
							player.ApplyImpulse(direction, player.GetPosition() );
						}
						//initial jump off right wall
						else if(rightWall){
							jumping = true;
							direction.Set(-120,-43);
							player.SetAwake(true);
							player.ApplyImpulse(direction, player.GetPosition() );
							Player.STATE = Player.JUMPING;
						}
						//initial jump off left wall
						else if(leftWall){
							jumping = true;
							direction.Set(120,-43);
							player.SetAwake(true);
							player.ApplyImpulse(direction, player.GetPosition() );
							Player.STATE = Player.JUMPING;
						}
						break;
					//left arrow	
					case Keyboard.LEFT:
						//limit speed
						if(horizontal>-3){
							direction.Set(-350,0);
							player.SetAwake(true);
							player.ApplyForce(direction,player.GetPosition());
							Player.playerRotation = -40;
						}
						if(!jumping){
							Player.STATE = Player.L_WALK;
						}
						break;
					//right arrow
					case Keyboard.RIGHT:
						//limit speed
						if(horizontal<3){
							direction.Set(350,0);
							player.SetAwake(true);
							player.ApplyForce(direction,player.GetPosition());
							Player.playerRotation = 40;
						}
						if(!jumping){
							Player.STATE = Player.R_WALK;
						}
						break;
				}
			}
			
			//get current physics
			var currentPos:Point = new Point(player.GetPosition().x, player.GetPosition().y);
			var currentVelocity:Number = currentPos.x - lastPos.x;
			
			//update forces and positions
			acceleration = currentVelocity - horizontal;
			horizontal = currentVelocity;
			vertical = currentPos.y - lastPos.y;
			lastPos = currentPos;
		}
		
		/**Stages always center the screen on the player*/
		private function centerScreen(xPos:Number, yPos:Number):void{
			//get player position and screen size
			var xPos:Number = xPos*metricPixRatio;
			var yPos:Number = yPos*metricPixRatio;
			var stageHeight:Number = stage.stageHeight;
			var stageWidth:Number = stage.stageWidth;
			
			//center screen
			images.x = -1*xPos + stageWidth/2;
			images.y = -1*yPos + stageHeight/2;
		}
		
		/**Stages can detect key presses*/
		public function keyPressed(e:KeyboardEvent):void{
			var inArray:Boolean = false;
			//loop over key presses
			for(var i:uint =0; i< keyPresses.length; i++){
				//check if pressed key is same as a key in the array
				if(keyPresses[i] == e.keyCode){
					inArray = true;
				}
			}
			
			//add to array if wasn't in it
			if(!inArray){
				keyPresses.push(e.keyCode);
			}
		}
		
		/**Stages can detect key releases*/
		public function keyReleased(e:KeyboardEvent):void{
			//loop over key releases
			for(var i:uint=0; i<keyPresses.length;i++){
				//check if released key is in array
				if(keyPresses[i] == e.keyCode){
					//remove it
					keyPresses.splice(i,1);
					i--;
				}
			}
			
			//jumping
			if(e.keyCode == Keyboard.UP){
				jumpTime = 0;
				if(jumpAmount > 0){
					jumpAmount--;
				}
			}
			//movement
			else if(e.keyCode == Keyboard.RIGHT && !jumping || e.keyCode == Keyboard.LEFT && !jumping){
				Player.STATE = Player.IDLE;
			}
		}
		
		/**Get and Set for stageWorld*/
		static public function get world():b2World{ return worldStage; }
		static public function set world(worldStageP:b2World):void{
			if(worldStage == null){
				worldStage = worldStageP;
			}
		}
		
		/**Get and Set for images*/
		static public function get sprites():Sprite{ return images; }
		static public function set sprites(imagesP:Sprite):void{
			if(images == null){
				images = imagesP;
			}
		}
		
		/**Get for Debug*/
		static public function get horizontalSpeed():Number{return horizontal;}
		static public function get verticalSpeed():Number{return vertical;}
		static public function get jumpsRemaining():int{return jumpAmount;}
		static public function get isJumping():Boolean{return jumping;}
		static public function get timeJumping():int{return jumpTime;}
		static public function get rightContact():Boolean{return rightWall;}
		static public function get leftContact():Boolean{return leftWall;}
		
		/**Draws Box2D collision shapes*/
		private function debugDrawing():void{
			var debugDraw:b2DebugDraw = new b2DebugDraw();
			debugDraw.SetSprite(images);
			debugDraw.SetDrawScale(metricPixRatio);
			debugDraw.SetAlpha(0.3);
			debugDraw.SetLineThickness(1.0);
			
			debugDraw.SetFlags(b2DebugDraw.e_shapeBit|b2DebugDraw.e_jointBit);
			worldStage.SetDebugDraw(debugDraw);
		}
	}
}