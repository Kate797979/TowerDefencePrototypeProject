package game.visual.towerShop 
{
	import game.data.TowerInfo;
	import game.visual.VisualManager;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.QuadBatch;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	import starling.utils.Color;
	/**
	 * ...
	 * @author K
	 */
	public class TowerButton extends Sprite
	{
		private const _buttonWidth:Number = 70;
		private const _buttonHeight:Number = 80;
		
		private var _towerInfo:TowerInfo;
		
		private var _backContainer:Sprite;
		private var _backOverImageContainer:Sprite;
		 
		
		public function TowerButton(towerInfo:TowerInfo) 
		{
			useHandCursor = true;
			
			_towerInfo = towerInfo;
			
			createBack();
			createOver();

			addEventListener(TouchEvent.TOUCH, touchEventHandler);
		}
		
		private function touchEventHandler(e:TouchEvent):void 
		{
			var targetDO:DisplayObject = e.target as DisplayObject;
			
			var hoverTouch:Touch = e.getTouch(targetDO, TouchPhase.HOVER);
			if (hoverTouch)
			{
				if (!_overActivated)
					onOver();
			}
			else
			{
				if (_overActivated)
					onOut();
			}
			
			var touch:Touch = e.getTouch(targetDO);
			
			if (touch && touch.phase == TouchPhase.ENDED)
			{
				if (targetDO.hitTest(touch.getLocation(targetDO)))
				{
					dispatchEvent(new TowerEvent(TowerEvent.TRIGGED, _towerInfo));
				}
			}
 			
		}
		
		private var _overActivated:Boolean = false;
		
		private function onOver():void
		{
			if (!_overActivated)
			{
				_overActivated = true;
				
				_backOverImageContainer.visible = true;
				
				dispatchEvent(new TowerEvent(TowerEvent.OVER, _towerInfo));
			}
		}
		
		private function onOut():void
		{
			if (_overActivated)
			{
				_overActivated = false;
				
				_backOverImageContainer.visible = false;

				dispatchEvent(new TowerEvent(TowerEvent.OUT, _towerInfo));
			}
		}
		
		private function createBack():void
		{
			_backContainer = new Sprite();
			addChild(_backContainer);
			
			///////////////// Рисуем бек для кнопки
			var backQuadBatch:QuadBatch = new QuadBatch();
			
			var backQuad:Quad = new Quad(_buttonWidth, _buttonHeight);
		    backQuad.setVertexColor(0, Color.BLACK);
		    backQuadBatch.addQuad(backQuad);
			
			var topEdgeQuad:Quad = new Quad(_buttonWidth, 2, Color.WHITE);
			backQuadBatch.addQuad(topEdgeQuad);
			
			var leftEdgeQuad:Quad = new Quad(2, _buttonHeight, Color.WHITE);
			backQuadBatch.addQuad(leftEdgeQuad);
			
			var bottomEdgeQuad:Quad = new Quad(_buttonWidth, 2, Color.SILVER);
			bottomEdgeQuad.y = _buttonHeight - 2;
			backQuadBatch.addQuad(bottomEdgeQuad);
			
			var rightEdgeQuad:Quad = new Quad(2, _buttonHeight, Color.SILVER);
			rightEdgeQuad.x = _buttonWidth - 2;
			backQuadBatch.addQuad(rightEdgeQuad);

			backQuadBatch.alignPivot();
			
		    _backContainer.addChild(backQuadBatch);
  		   ////////////
		   
			var towerTextureId:String = _towerInfo.type + "_texture";
			
			var tTexture:Texture = VisualManager.getTexture(towerTextureId);
			var tImage:Image = new Image(tTexture);
			
			tImage.alignPivot();
			
			var scale:Number = Math.min(_buttonWidth / tImage.width, _buttonHeight / tImage.height);
			tImage.scaleX = tImage.scaleY = scale;
			
			_backContainer.addChild(tImage);
			///////////////////////
		}
		
		private function createOver():void 
		{
			_backOverImageContainer = new Sprite();
			addChildAt(_backOverImageContainer, 0);
			
			_backOverImageContainer.visible = false;
			
			///////////////// Рисуем over для кнопки
			var overQuadBatch:QuadBatch = new QuadBatch();
			
			var topEdgeQuad:Quad = new Quad(_buttonWidth + 4, 2, Color.GRAY);
			overQuadBatch.addQuad(topEdgeQuad);
			
			var leftEdgeQuad:Quad = new Quad(2, _buttonHeight + 4, Color.GRAY);
			overQuadBatch.addQuad(leftEdgeQuad);
			
			var bottomEdgeQuad:Quad = new Quad(_buttonWidth + 4, 2, Color.GRAY);
			bottomEdgeQuad.y = _buttonHeight + 2;
			overQuadBatch.addQuad(bottomEdgeQuad);
			
			var rightEdgeQuad:Quad = new Quad(2, _buttonHeight + 4, Color.GRAY);
			rightEdgeQuad.x = _buttonWidth + 2;
			overQuadBatch.addQuad(rightEdgeQuad);

			overQuadBatch.alignPivot();
			
		    _backOverImageContainer.addChild(overQuadBatch);
  		    ////////////
			
		}
		
		public function get towerInfo():TowerInfo 
		{
			return _towerInfo;
		}
		
	}

}