package game.visual 
{
	import flash.display.Bitmap;
	import flash.utils.Dictionary;
	import starling.display.MovieClip;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.utils.formatString;
	/**
	 * ...
	 * @author K
	 */
	public class VisualManager 
	{
		
		[Embed(source = "../../lib/textureAtlases/Creeps/gnome/D/GnomeDAnim.png")]
		public static const gnomeDAnimSheet:Class;
		
		[Embed(source = "../../lib/textureAtlases/Creeps/gnome/D/GnomeDAnim.xml", mimeType = "application/octet-stream")]
		public static const gnomeDAnimSheetXML:Class;
		
		[Embed(source = "../../lib/textureAtlases/Creeps/gnome/DL/GnomeDLAnim.png")]
		public static const gnomeDLAnimSheet:Class;
		
		[Embed(source = "../../lib/textureAtlases/Creeps/gnome/DL/GnomeDLAnim.xml", mimeType = "application/octet-stream")]
		public static const gnomeDLAnimSheetXML:Class;
		
		[Embed(source = "../../lib/textureAtlases/Creeps/gnome/L/GnomeLAnim.png")]
		public static const gnomeLAnimSheet:Class;
		
		[Embed(source = "../../lib/textureAtlases/Creeps/gnome/L/GnomeLAnim.xml", mimeType = "application/octet-stream")]
		public static const gnomeLAnimSheetXML:Class;
		
		[Embed(source = "../../lib/textureAtlases/Creeps/gnome/T/GnomeTAnim.png")]
		public static const gnomeTAnimSheet:Class;
		
		[Embed(source = "../../lib/textureAtlases/Creeps/gnome/T/GnomeTAnim.xml", mimeType = "application/octet-stream")]
		public static const gnomeTAnimSheetXML:Class;
		
		[Embed(source = "../../lib/textureAtlases/Creeps/gnome/TL/GnomeTLAnim.png")]
		public static const gnomeTLAnimSheet:Class;
		
		[Embed(source = "../../lib/textureAtlases/Creeps/gnome/TL/GnomeTLAnim.xml", mimeType = "application/octet-stream")]
		public static const gnomeTLAnimSheetXML:Class;
		
		[Embed(source = "../../lib/textureAtlases/Creeps/ork/D/OrkDAnim.png")]
		public static const orkDAnimSheet:Class;
		
		[Embed(source = "../../lib/textureAtlases/Creeps/ork/D/OrkDAnim.xml", mimeType = "application/octet-stream")]
		public static const orkDAnimSheetXML:Class;
		
		[Embed(source = "../../lib/textureAtlases/Creeps/ork/DL/OrkDLAnim.png")]
		public static const orkDLAnimSheet:Class;
		
		[Embed(source = "../../lib/textureAtlases/Creeps/ork/DL/OrkDLAnim.xml", mimeType = "application/octet-stream")]
		public static const orkDLAnimSheetXML:Class;
		
		[Embed(source = "../../lib/textureAtlases/Creeps/ork/L/OrkLAnim.png")]
		public static const orkLAnimSheet:Class;
		
		[Embed(source = "../../lib/textureAtlases/Creeps/ork/L/OrkLAnim.xml", mimeType = "application/octet-stream")]
		public static const orkLAnimSheetXML:Class;
		
		[Embed(source = "../../lib/textureAtlases/Creeps/ork/T/OrkTAnim.png")]
		public static const orkTAnimSheet:Class;
		
		[Embed(source = "../../lib/textureAtlases/Creeps/ork/T/OrkTAnim.xml", mimeType = "application/octet-stream")]
		public static const orkTAnimSheetXML:Class;
		
		[Embed(source = "../../lib/textureAtlases/Creeps/ork/TL/OrkTLAnim.png")]
		public static const orkTLAnimSheet:Class;
		
		[Embed(source = "../../lib/textureAtlases/Creeps/ork/TL/OrkTLAnim.xml", mimeType = "application/octet-stream")]
		public static const orkTLAnimSheetXML:Class;
		
		[Embed(source = "../../lib/textures/map.png")]
		public static const mapTexture:Class;
		
		[Embed(source = "../../lib/textures/tower_1.png")]
		public static const tower_1_texture:Class;
		
		[Embed(source = "../../lib/textures/tower_2.png")]
		public static const tower_2_texture:Class;
		
		[Embed(source = "../../lib/textures/tower_3.png")]
		public static const tower_3_texture:Class;
		
		[Embed(source = "../../lib/textures/button.png")]
		public static const buttonTexture:Class;
		
		[Embed(source = "../../lib/textures/fireLine.png")]
		public static const fireLineTexture:Class;
		
		public function VisualManager() 
		{
			
		}
		
		private static const creepAnimationSkewYPairs:Object = { "DR":"DL", "R":"L", "TR":"TL" };
		public static function gerCreepAnimation(creepType:String, direction:String, fps:Number = 12, pivotCenter:Boolean = true, reverse:Boolean = false, loop:Boolean = false, scale:Number = 1):MovieClip
		{
			var needSkewY:Boolean = creepAnimationSkewYPairs.hasOwnProperty(direction);
			if (needSkewY)
				direction = creepAnimationSkewYPairs[direction];
			
			var	key:String = formatString("{0}{1}Anim", creepType, direction);
			var textureKey:String = formatString("{0}_{1}_", creepType, direction);
				
			var mClip:MovieClip = getMovieClipAnimation(key, textureKey, fps, pivotCenter, reverse, loop, scale);
			
			if (needSkewY)
				mClip.skewY = Math.PI;
				
			return mClip;
		}
		
		public static function getMovieClipAnimation(key:String, textureKey:String = null, fps:Number = 12, pivotCenter:Boolean = true, reverse:Boolean = false, loop:Boolean = false, scale:Number = 1):MovieClip
		{
			var mClip:MovieClip;
			try
			{
				var texture:Texture = _textures[key];
				if (!texture)
				{
					var spriteSheetClass:Class = getSpriteSheet(key);
					var bitmap:Bitmap = new spriteSheetClass();
					_textures[key] = texture = Texture.fromBitmap(bitmap);
				}
				
				var spriteSheetXMLClass:Class = getSpriteSheetXML(key);
				var xml:XML = XML(new spriteSheetXMLClass());
				
				var sTextureAtlas:TextureAtlas = new TextureAtlas(texture, xml);
				
				if (textureKey == null)
					textureKey = key;
				var frames:Vector.<Texture> = sTextureAtlas.getTextures(textureKey);
				if (reverse) frames.reverse();
				
				mClip = new MovieClip(frames, fps);
				if (pivotCenter)
				{
					mClip.alignPivot();
				}
				mClip.loop = loop;
			}
			catch (e:Error)
			{
				Log.add(formatString("game.visual.animations.AnimationsManager:: Can't create animation for key='{0}': {1}", key, e.message));
				
				var textures:Vector.<Texture> = new Vector.<Texture>();
				textures.push(Texture.empty(2, 2));
				
				mClip = new MovieClip(textures, fps);
			}
			
			mClip.scaleX = mClip.scaleY = scale;
			
			return mClip;
		}
			
		public static function getSpriteSheet(name:String):Class
		{
			return VisualManager[name + "Sheet"];
		}
		
		public static function getSpriteSheetXML(name:String):Class
		{
			return VisualManager[name + "SheetXML"];
		}

		private static var _textures:Dictionary = new Dictionary();
		public static function getTexture(className:String):Texture
		{
			var texture:Texture = _textures[className];
			if (texture) return texture;
			
			var classRef:Class = VisualManager[className];
			if (classRef)
			{
				var bitmap:Bitmap = new classRef();
				texture = Texture.fromBitmap(bitmap);
				_textures[className] = texture;
				
				return texture;
			}
			
			return Texture.empty(2, 2);
		}

	}

}