/**
 * Code for Box2D contact listener.
 */
package Game
{
	import flash.media.Sound;
	import flash.media.SoundTransform;
	import flash.net.SharedObject;
	
	import Assets.Player;
	
	import Box2D.Collision.b2Manifold;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2ContactListener;
	import Box2D.Dynamics.Contacts.b2Contact;
	
	import Parents.Stage;
	
	public class ContactListener extends b2ContactListener
	{
		private var settings:SharedObject;
		private var HUD:PlayerHUD;
		private var player:Player;
		private var arena:Stage;
		
		/**Constructor DOES NOTHING*/
		public function ContactListener(_arena:Stage, _settings:SharedObject, _HUD:PlayerHUD, _player:Player)
		{
			arena = _arena;
			settings = _settings;
			HUD = _HUD;
			player = _player;
		}
		
		/**Collision begins*/
		override public function BeginContact(contact:b2Contact):void{
			var userDataA:* = contact.GetFixtureA().GetUserData()[0];
			var userDataB:* = contact.GetFixtureB().GetUserData()[0];
			/**Jumping*/
			if(userDataA == "PLAYER" &&
			   userDataB != "ENEMY" && 
			   userDataB != "ITEM" &&
			   userDataB != "DEAD" &&
			   userDataB != "NO_JUMP"){
				var playerDataA:* = contact.GetFixtureA().GetUserData()[1];
				
				if(playerDataA == "FOOT"){
					player.jumping = false;
					arena.airJumping = false;
					arena.jumpTime = 0;
					arena.jumpAmount = arena.defaultJumpAmount;
					arena.floor = true;
					player.STATE = player.IDLE;
				}
				else if(playerDataA == "RIGHT"){
					player.jumping = false;
					arena.airJumping = false;
					arena.jumpTime = 0;
					arena.jumpAmount = arena.defaultJumpAmount;
					arena.rightWall = true;
					player.STATE = player.R_WALL;
				}
				else if(playerDataA == "LEFT"){
					player.jumping = false;
					arena.airJumping = false;
					arena.jumpTime = 0;
					arena.jumpAmount = arena.defaultJumpAmount;
					arena.leftWall = true;
					player.STATE = player.L_WALL;
				}
			}
			else if(userDataB == "PLAYER" &&
				    userDataA != "ENEMY" && 
					userDataA != "ITEM" &&
					userDataA != "DEAD" &&
					userDataA != "NO_JUMP"){
				
				var playerDataB:* = contact.GetFixtureB().GetUserData()[1];
				
				if(playerDataB == "FOOT"){
					player.jumping = false;
					arena.airJumping = false;
					arena.jumpTime = 0;
					arena.jumpAmount = arena.defaultJumpAmount;
					arena.floor = true;
					player.STATE = player.IDLE;
				}
				else if(playerDataB == "RIGHT"){
					player.jumping = false;
					arena.airJumping = false;
					arena.jumpTime = 0;
					arena.jumpAmount = arena.defaultJumpAmount;
					arena.rightWall = true;
					player.STATE = player.R_WALL;
				}
				else if(playerDataB == "LEFT"){
					player.jumping = false;
					arena.airJumping = false;
					arena.jumpTime = 0;
					arena.jumpAmount = arena.defaultJumpAmount;
					arena.leftWall = true;
					player.STATE = player.L_WALL;
				}
			}
			
			/**Enemy contact*/
			if(userDataA == "PLAYER" && userDataB == "ENEMY"){
				if(contact.GetFixtureA().GetUserData()[1] == "BODY"){
					//take away health
					if(player.playerInvulnerable == 0 && !HUD.slowMotion && player.playerHealth != 0){
						player.playerInvulnerable = 50;
						player.playerHealth--;
						HUD.heartDamaged = true;
						
						var hit1:Sound = new Hit;
						hit1.play(0, 0, new SoundTransform(settings.data.effectsVolume));
												
						//flinch
						if(contact.GetFixtureA().GetBody().GetPosition().x < contact.GetFixtureB().GetBody().GetPosition().x){
							player.body.SetLinearVelocity( new b2Vec2(-75, 0) );
							arena.flinchTime = 12;
							player.STATE = player.FLINCH;
						}
						else if(contact.GetFixtureA().GetBody().GetPosition().x > contact.GetFixtureB().GetBody().GetPosition().x){
							player.body.SetLinearVelocity( new b2Vec2(75, 0) );
							arena.flinchTime = 12;
							player.STATE = player.FLINCH;
						}
						
					}
						//if using slow motion, but don't have any
					else if(HUD.slowMotion && HUD.slowAmount <=0){
						if(player.playerInvulnerable == 0 && player.playerHealth != 0){
							player.playerInvulnerable = 50;
							player.playerHealth--;
							HUD.heartDamaged = true;
							
							var hit2:Sound = new Hit;
							hit2.play(0, 0, new SoundTransform(settings.data.effectsVolume));
															
							//flinch
							if(contact.GetFixtureB().GetBody().GetPosition().x < contact.GetFixtureA().GetBody().GetPosition().x){
								player.body.SetLinearVelocity( new b2Vec2(-75, 0) );
								arena.flinchTime = 12;
								player.STATE = player.FLINCH;
							}
							else if(contact.GetFixtureB().GetBody().GetPosition().x > contact.GetFixtureA().GetBody().GetPosition().x){
								player.body.SetLinearVelocity( new b2Vec2(75, 0) );
								arena.flinchTime = 12;
								player.STATE = player.FLINCH;
							}
						}
					}
					else if(HUD.slowMotion && HUD.slowAmount > 0){
						player.STATE = player.DODGE;
					}
				}
				
			}
			else if(userDataA == "ENEMY" && userDataB == "PLAYER"){
				if(contact.GetFixtureB().GetUserData()[1] == "BODY"){
					//take away health
					if(player.playerInvulnerable == 0 && !HUD.slowMotion && player.playerHealth != 0){
						player.playerInvulnerable = 50;
						player.playerHealth--;
						HUD.heartDamaged = true;
						
						var hit3:Sound = new Hit;
						hit3.play(0, 0, new SoundTransform(settings.data.effectsVolume));
						
						//flinch
						if(contact.GetFixtureB().GetBody().GetPosition().x < contact.GetFixtureA().GetBody().GetPosition().x){
							player.body.SetLinearVelocity( new b2Vec2(-75, 0) );
							arena.flinchTime = 12;
							player.STATE = player.FLINCH;
						}
						else if(contact.GetFixtureB().GetBody().GetPosition().x > contact.GetFixtureA().GetBody().GetPosition().x){
							player.body.SetLinearVelocity( new b2Vec2(75, 0) );
							arena.flinchTime = 12;
							player.STATE = player.FLINCH;
						}
						
					}
						//if using slow motion, but don't have any
					else if(HUD.slowMotion && HUD.slowAmount <=0){
						if(player.playerInvulnerable == 0 && player.playerHealth != 0){
							player.playerInvulnerable = 50;
							player.playerHealth--;
							HUD.heartDamaged = true;
							
							var hit4:Sound = new Hit;
							hit4.play(0, 0, new SoundTransform(settings.data.effectsVolume));
							
							//flinch
							if(contact.GetFixtureB().GetBody().GetPosition().x < contact.GetFixtureA().GetBody().GetPosition().x){
								player.body.SetLinearVelocity( new b2Vec2(-75, 0) );
								arena.flinchTime = 12;
								player.STATE = player.FLINCH;
							}
							else if(contact.GetFixtureB().GetBody().GetPosition().x > contact.GetFixtureA().GetBody().GetPosition().x){
								player.body.SetLinearVelocity( new b2Vec2(75, 0) );
								arena.flinchTime = 12;
								player.STATE = player.FLINCH;
							}
						}
					}
					else if(HUD.slowMotion && HUD.slowAmount > 0){
						player.STATE = player.DODGE;
					}
				}
			}
			
			/**Platform Enemy AI*/
			if(userDataA == "ENEMY" &&
				userDataB != "ITEM" &&
				userDataB != "DEAD"){
				var enemyDataA:* = contact.GetFixtureA().GetUserData()[1];
				
				if(userDataB != "GROUND" && userDataB != "NO_JUMP"){
					if(enemyDataA == "BOTTOM"){
						contact.GetFixtureA().GetUserData()[1] ="BOTTOM_ON";
					}
					else if(enemyDataA == "TOP"){
						contact.GetFixtureA().GetUserData()[1] ="TOP_ON";
					}
					else if(enemyDataA == "RIGHT"){
						contact.GetFixtureA().GetUserData()[1] ="RIGHT_ON";
					}
					else if(enemyDataA == "LEFT"){
						contact.GetFixtureA().GetUserData()[1] ="LEFT_ON";
					}
				}
				else{					
					if(enemyDataA == "BOTTOM"){
						contact.GetFixtureA().GetUserData()[1] ="BOTTOM_S";
					}
					else if(enemyDataA == "TOP"){
						contact.GetFixtureA().GetUserData()[1] ="TOP_S";
					}
					else if(enemyDataA == "RIGHT"){
						contact.GetFixtureA().GetUserData()[1] ="RIGHT_S";
					}
					else if(enemyDataA == "LEFT"){
						contact.GetFixtureA().GetUserData()[1] ="LEFT_S";
					}				
				}
								
			}
			else if(userDataB == "ENEMY" &&
				userDataA != "ITEM" &&
				userDataA != "DEAD"){
				
				var enemyDataB:* = contact.GetFixtureA().GetUserData()[1];

				if(userDataA != "GROUND" && userDataA != "NO_JUMP"){
					
					if(enemyDataB == "BOTTOM"){
						contact.GetFixtureB().GetUserData()[1] ="BOTTOM_ON";
					}
					else if(enemyDataB == "TOP"){
						contact.GetFixtureB().GetUserData()[1] ="TOP_ON";
					}
					else if(enemyDataB == "RIGHT"){
						contact.GetFixtureB().GetUserData()[1] ="RIGHT_ON";
					}
					else if(enemyDataB == "LEFT"){
						contact.GetFixtureB().GetUserData()[1] ="LEFT_ON";
					}
				}
				else{
					if(enemyDataB == "BOTTOM"){
						contact.GetFixtureB().GetUserData()[1] ="BOTTOM_S";
					}
					else if(enemyDataB == "TOP"){
						contact.GetFixtureB().GetUserData()[1] ="TOP_S";
					}
					else if(enemyDataB == "RIGHT"){
						contact.GetFixtureB().GetUserData()[1] ="RIGHT_S";
					}
					else if(enemyDataB == "LEFT"){
						contact.GetFixtureB().GetUserData()[1] ="LEFT_S";
					}
				}
				
			}
			
			/**Bullet Damage*/
			if(userDataA == "BULLET"){
				var bulletDataA:* = contact.GetFixtureA().GetUserData()[1];
				
				//1 damage
				if(bulletDataA == "PISTOL" || bulletDataA == "MACHINEGUN"){
					contact.GetFixtureA().GetUserData()[0] ="DEAD";
					if(userDataB == "ENEMY"){
						contact.GetFixtureB().GetUserData().push(1);
						var monsterHit:Sound = new MonsterHit;
						if(HUD.slowMotion && HUD.slowAmount > 0){
							monsterHit.play(0, 0, new SoundTransform(settings.data.effectsVolume*0.15));
						}
						else{
							monsterHit.play(0, 0, new SoundTransform(settings.data.effectsVolume));
						}						}
				}
				//2 damage
				else if(bulletDataA == "SHOTGUN"){
					contact.GetFixtureA().GetUserData()[0] ="DEAD";
					if(userDataB == "ENEMY"){
						contact.GetFixtureB().GetUserData().push(2);
						var monsterHit1:Sound = new MonsterHit;
						if(HUD.slowMotion && HUD.slowAmount > 0){
							monsterHit1.play(0, 0, new SoundTransform(settings.data.effectsVolume*0.15));
						}
						else{
							monsterHit1.play(0, 0, new SoundTransform(settings.data.effectsVolume));
						}						}
				}
			}
			else if(userDataB == "BULLET"){
				var bulletDataB:* = contact.GetFixtureB().GetUserData()[1];
				
				//1 damage
				if(bulletDataB == "PISTOL" || bulletDataB == "MACHINEGUN"){
					contact.GetFixtureB().GetUserData()[0] ="DEAD";
					if(userDataA == "ENEMY"){
						contact.GetFixtureA().GetUserData().push(1);
						var monsterHit2:Sound = new MonsterHit;
						if(HUD.slowMotion && HUD.slowAmount > 0){
							monsterHit2.play(0, 0, new SoundTransform(settings.data.effectsVolume*0.15));
						}
						else{
							monsterHit2.play(0, 0, new SoundTransform(settings.data.effectsVolume));
						}						
					}
				}
				//2 damage
				else if(bulletDataB == "SHOTGUN"){
					contact.GetFixtureB().GetUserData()[0] ="DEAD";
					if(userDataA == "ENEMY"){
						contact.GetFixtureA().GetUserData().push(2);
						var monsterHit3:Sound = new MonsterHit;
						if(HUD.slowMotion && HUD.slowAmount > 0){
							monsterHit3.play(0, 0, new SoundTransform(settings.data.effectsVolume*0.15));
						}
						else{
							monsterHit3.play(0, 0, new SoundTransform(settings.data.effectsVolume));
						}						}
				}
			}
			
			/**Item Drop Collected*/
			if(userDataA == "ITEM" && userDataB == "PLAYER"){
				contact.GetFixtureA().GetUserData()[0] = "DEAD";
			}
			else if(userDataA == "PLAYER" && userDataB == "ITEM"){
				contact.GetFixtureB().GetUserData()[0] ="DEAD";
			}
		}
		
		/**Collison ends*/
		override public function EndContact(contact:b2Contact):void{
			var userDataA:* = contact.GetFixtureA().GetUserData()[0];
			var userDataB:* = contact.GetFixtureB().GetUserData()[0];
			
			/**Jumping*/
			if(userDataA == "PLAYER" &&
			   userDataB != "ENEMY" && 
			   userDataB != "NO_JUMP" && 
			   userDataB != "DEAD"){
				
				var playerDataA:* = contact.GetFixtureA().GetUserData()[1];
				
				if(playerDataA == "FOOT"){
					player.jumping = true;
					player.STATE = player.JUMPING;
					arena.floor = false;
				}
				else if(playerDataA == "RIGHT"){
					arena.rightWall = false;
					if(!arena.floor){
						player.jumping = true;
						player.STATE = player.JUMPING;
					}
				}
				else if(playerDataA == "LEFT"){
					arena.leftWall = false;
					if(!arena.floor){
						player.jumping = true;
						player.STATE = player.JUMPING;
					}
				}
			}
			else if(userDataB == "PLAYER" &&
					userDataA != "ENEMY" && 
					userDataA != "NO_JUMP" && 
					userDataA != "DEAD"){
				
				var playerDataB:* = contact.GetFixtureB().GetUserData()[1];
				
				if(playerDataB == "FOOT"){
					player.jumping = true;
					arena.floor = false;
					player.STATE = player.JUMPING;
				}
				else if(playerDataB == "RIGHT"){
					arena.rightWall = false;
					if(!arena.floor){
						player.jumping = true;
						player.STATE = player.JUMPING;
					}
				}
				else if(playerDataB == "LEFT"){
					arena.leftWall = false;
					player.jumping = true;
					if(!arena.floor){
						player.jumping = true;
						player.STATE = player.JUMPING;
					}
				}
			}
			
			/**Platform Enemy AI*/
			if(userDataA == "ENEMY" &&
				userDataB != "ITEM" &&
				userDataB != "DEAD"){
				
				var enemyDataA:* = contact.GetFixtureA().GetUserData()[1];
				
				if(enemyDataA == "BOTTOM_ON" || enemyDataA == "BOTTOM_S"){
					contact.GetFixtureA().GetUserData()[1] ="BOTTOM";
				}
				else if(enemyDataA == "RIGHT_ON" || enemyDataA == "RIGHT_S"){
					contact.GetFixtureA().GetUserData()[1] ="RIGHT";
				}
				else if(enemyDataA == "LEFT_ON" || enemyDataA == "LEFT_S"){
					contact.GetFixtureA().GetUserData()[1] ="LEFT";
				}
				else if(enemyDataA == "TOP_ON" || enemyDataA == "TOP_S"){
					contact.GetFixtureA().GetUserData()[1] ="TOP";
				}
			}
			else if(userDataB == "ENEMY" &&
				userDataA != "ITEM" &&
				userDataA != "DEAD"){
				
				var enemyDataB:* = contact.GetFixtureA().GetUserData()[1];
				
				if(enemyDataB == "BOTTOM_ON" || enemyDataB == "BOTTOM_S"){
					contact.GetFixtureB().GetUserData()[1] ="BOTTOM";
				}
				else if(enemyDataB == "RIGHT_ON" || enemyDataB == "RIGHT_S"){
					contact.GetFixtureB().GetUserData()[1] ="RIGHT";
				}
				else if(enemyDataB == "LEFT_ON" || enemyDataB == "LEFT_S"){
					contact.GetFixtureB().GetUserData()[1] ="LEFT";
				}
				else if(enemyDataB == "TOP_ON" || enemyDataB == "TOP_S"){
					contact.GetFixtureB().GetUserData()[1] ="TOP";
				}
			}
		}
		
		override public function PreSolve(contact:b2Contact, oldManifold:b2Manifold):void{
			var userDataA:* = contact.GetFixtureA().GetUserData()[0];
			var userDataB:* = contact.GetFixtureB().GetUserData()[0];
			
			//disable contact between player and enemy for invulnerability
			if(userDataA == "PLAYER" && userDataB == "ENEMY" ||
			   userDataA == "ENEMY" && userDataB == "PLAYER"){
				
				contact.SetEnabled(false);
			}
		}
	}
}