package game.visual 
{
	import game.data.towers.TowerInfo;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.QuadBatch;
	import starling.display.Sprite;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author ...
	 */
	public class TowerButton extends Sprite
	{
		private const _textureWidth:Number = 70;
		private const _textureHeight:Number = 80;
		
		private var _towerInfo:TowerInfo;
		private var _towerTextureId:String;
		
		public function TowerButton(towerInfo:TowerInfo) 
		{
			useHandCursor = true;
			
			_towerInfo = towerInfo;
			
			var qb:QuadBatch = new QuadBatch();
			
			var q:Quad = new Quad(_textureWidth, _textureHeight);
			q.pivotX = q.width >> 1;
			q.pivotY = q.height >> 1;
		    q.setVertexColor(0, 0x000000);
		    qb.addQuad(q);
		    addChild(qb);
  
		   ////////////
			_towerTextureId = _towerInfo.type + "_texture";
			
			var tTexture:Texture = VisualManager.getTexture(_towerTextureId);
			var tImage:Image = new Image(tTexture);
			
			tImage.pivotX = tImage.width / 2;
			tImage.pivotY = tImage.height / 2;
			
			var scale:Number = Math.min(_textureWidth / tImage.width, _textureHeight / tImage.height);
			tImage.scaleX = tImage.scaleY = scale;
			
			addChild(tImage);
			///////////////////////
		}
		
		public function get towerInfo():TowerInfo 
		{
			return _towerInfo;
		}
		
		public function get towerTextureId():String 
		{
			return _towerTextureId;
		}
		
	}

}