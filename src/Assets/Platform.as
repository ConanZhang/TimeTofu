/**
 * Code to make platform
 */
package Assets {
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	
	import Parents.Objects;
	import Parents.Stage;
	
	public class Platform extends Objects{
		/**Class Member Variables*/
		//STAGE
		private var stage_Sprite:Sprite = Stage.sprites;
		private var world_Sprite:b2World = Stage.world;
		
		//PROPERTIES
		private var position:Point;
		private var platformClip:MovieClip;
		private var platform_Width:Number;
		private var platform_Height:Number;
		private var platformType:String;
		
		//BOX2D COLLISION & PHYSICS
		private var collisionBody:b2Body;
		private var platformFixture:b2FixtureDef;
		private var platform_Friction:Number;
		private var platform_Density:Number;
		
		/**Constructor*/
		public function Platform(xPos:Number, yPos:Number, width:Number, height:Number, type:String){
			//assign parameters to class member variables
			position = new Point(xPos, yPos);
			platformType = type;
			
			//initialize default private variables
			platform_Width = width;
			platform_Height = height;
			platform_Friction = 0.7;
			platform_Density = 0;
			
			platformFixture = new b2FixtureDef();
			
			make();
		}
		
		/**Makes Platform*/
		public function make():void{
			//Box2D shape
			var platformShape:b2PolygonShape = new b2PolygonShape();
			
			if(platformType == "ground"){
				platformShape.SetAsBox(platform_Width/2, platform_Height/4);
			}
			else if(platformType == "square"){
				platformShape.SetAsBox(platform_Width/2, platform_Height/2);
			}
			else if(platformType =="tall"){
				platformShape.SetAsBox(platform_Width/2.5, platform_Height/2.02);
			}
			else if(platformType == "wide"){
				platformShape.SetAsBox(platform_Width/2, platform_Height/2.75);
			}
			else if(platformType == "b_tall"){
				platformShape.SetAsBox(platform_Width/2, platform_Height/2);
			}
			else if(platformType == "b_wide"){
				platformShape.SetAsBox(platform_Width/2, platform_Height/2);
			}
			else if(platformType == "enemy"){
				platformShape.SetAsBox(platform_Width/2, platform_Height/3);
			}
			
			//Box2D shape properties
			platformFixture.shape = platformShape;
			platformFixture.friction = platform_Friction;
			platformFixture.density = platform_Density;
			platformFixture.userData = new Array("PLATFORM");
			platformFixture.filter.categoryBits = 2;
			
			//player can't wall jump off tall barriers and slide on them
			if(platformType == "b_tall"){
				platformFixture.userData[0] = "NO_JUMP";
				platformFixture.friction = 0
			}
			else if(platformType == "b_wide"){
				platformFixture.userData[0] = "GROUND";
			}
			else if(platformType == "enemy"){
				platformFixture.userData[0] = "ENEMY";
				platformFixture.filter.maskBits = 1;
			}
			//Box2D collision shape
			var platformCollision:b2BodyDef = new b2BodyDef();
			platformCollision.position.Set(position.x + platform_Width/2, position.y + platform_Height/2);
			
			if(platformType == "b_wide"){
				platformCollision.type = b2Body.b2_kinematicBody;
			}
			
			collisionBody = world_Sprite.CreateBody(platformCollision);
			collisionBody.CreateFixture(platformFixture);
			super.body = collisionBody;
			
			//Sprite
			
			if(platformType == "ground"){
				platformClip = new ground();
				platformClip.stop();
				platformClip.width = platform_Width*metricPixRatio;
				platformClip.height = platform_Height*metricPixRatio;
				super.sprite = platformClip;
				Stage.sprites.addChild(platformClip);
			}
			else if(platformType == "square"){
				platformClip = new platform_square();
				platformClip.stop();
				platformClip.width = platform_Width*metricPixRatio;
				platformClip.height = platform_Height*metricPixRatio;
				super.sprite = platformClip;
				Stage.sprites.addChild(platformClip);
			}
			else if(platformType =="tall"){
				platformClip = new platform_tall();
				platformClip.stop();
				platformClip.width = platform_Width*metricPixRatio;
				platformClip.height = platform_Height*metricPixRatio;
				super.sprite = platformClip;
				Stage.sprites.addChild(platformClip);
			}
			else if(platformType == "wide"){
				platformClip = new platform_wide();
				platformClip.stop();
				platformClip.width = platform_Width*metricPixRatio;
				platformClip.height = platform_Height*metricPixRatio;
				super.sprite = platformClip;
				Stage.sprites.addChild(platformClip);
			}
			else if(platformType == "b_tall"){
				platformClip = new barrier_tall();
				platformClip.stop();
				platformClip.width = platform_Width*metricPixRatio;
				platformClip.height = platform_Height*metricPixRatio;
				super.sprite = platformClip;
				Stage.sprites.addChild(platformClip);
			}
			else if(platformType == "b_wide"){
				platformClip = new barrier_wide();
				platformClip.stop();
				platformClip.width = platform_Width*metricPixRatio;
				platformClip.height = platform_Height*metricPixRatio;
				super.sprite = platformClip;
				Stage.sprites.addChild(platformClip);
			}
			else if(platformType == "enemy"){
				platformClip = new spikes();
				platformClip.width = platform_Width*metricPixRatio;
				platformClip.height = platform_Height*metricPixRatio;
				super.sprite = platformClip;
				Stage.sprites.addChild(platformClip);
			}
			
		}
		
		/**Setters*/
		public function set width(width:Number):void{
			platform_Width = width;
		}
		
		public function set height(height:Number):void{
			platform_Height = height;
		}
		
		public function set friction(friction:Number):void{
			platform_Friction = friction;
		}
		
		public function set density(density:Number):void{
			platform_Density = density;
		}
	}
}