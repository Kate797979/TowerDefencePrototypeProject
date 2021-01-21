package game.visual.towerShop 
{
	import game.data.TowerInfo;
	import starling.display.Quad;
	import starling.display.QuadBatch;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.utils.Color;
	import starling.utils.formatString;
	import starling.utils.HAlign;
	/**
	 * ...
	 * @author K
	 */
	public class TowerToolTip extends Sprite 
	{
		private const _toolTipWidth:Number = 140;
		private const _toolTipHeight:Number = 160;
		
		private var _backImageContainer:Sprite;
		private var _textFieldsContainer:Sprite;
		
		public function TowerToolTip() 
		{
			_backImageContainer = new Sprite();
			addChild(_backImageContainer);
			
			createBack();
			createTextFields();
		}
		
		private function createBack():void 
		{
			///////////////// Рисуем бек для кнопки
			var backQuadBatch:QuadBatch = new QuadBatch();
			
			var backQuad:Quad = new Quad(_toolTipWidth, _toolTipHeight);
		    backQuad.setVertexColor(2, Color.BLACK);
		    backQuadBatch.addQuad(backQuad);
			
			var leftEdgeQuad:Quad = new Quad(2, _toolTipHeight, Color.WHITE);
			backQuadBatch.addQuad(leftEdgeQuad);
			
			var bottomEdgeQuad:Quad = new Quad(_toolTipWidth, 2, Color.WHITE);
			bottomEdgeQuad.y = _toolTipHeight - 2;
			backQuadBatch.addQuad(bottomEdgeQuad);
			
			var topEdgeQuad:Quad = new Quad(_toolTipWidth, 2, Color.GRAY);
			backQuadBatch.addQuad(topEdgeQuad);
			
			var rightEdgeQuad:Quad = new Quad(2, _toolTipHeight, Color.GRAY);
			rightEdgeQuad.x = _toolTipWidth - 2;
			backQuadBatch.addQuad(rightEdgeQuad);

			backQuadBatch.alignPivot();
			
		    _backImageContainer.addChild(backQuadBatch);
  		    ////////////
		}
		
		private var _nameTextField:TextField;
		private var _costValueTextField:TextField; 
		private var _rangeValueTextField:TextField;
		private var _demageValueTextField:TextField;
		private var _demageTypeValueTextField:TextField;
		private function createTextFields():void
		{
			_textFieldsContainer = new Sprite();
			addChild(_textFieldsContainer);
			
			var textX:Number = 5;
			var textY:Number = 2;
			var textWidth:Number = 70;
			var textHeight:Number = 22;
			var textYInterval:Number = textHeight;
			
			/////////Наименование башни
			_nameTextField = createTextField("", Color.GRAY, _toolTipWidth - textX * 2, textHeight, textX, textY, 18, HAlign.CENTER);
			
			_textFieldsContainer.addChild(_nameTextField);
			//////////////////
			
			//////////Формируем текстовые поля для вывода информации о цене башни
			textY = _nameTextField.y + textYInterval + 4;
			
			var costTextBox:TextField = createTextField("Cost:", Color.BLACK, textWidth, textHeight, textX, textY, 16);
			_textFieldsContainer.addChild(costTextBox);
			
			_costValueTextField = createTextField("$50", Color.WHITE, textWidth, textHeight, textX + textWidth, textY, 18);
			_textFieldsContainer.addChild(_costValueTextField);
			////////////////////////////////////////
			
			//////////Формируем текстовые поля для вывода информации радиусе атаки
			textY = costTextBox.y + textYInterval;
			
			var rangeTextBox:TextField = createTextField("Range:", Color.BLACK, textWidth, textHeight, textX, textY, 16);
			_textFieldsContainer.addChild(rangeTextBox);
			
			_rangeValueTextField = createTextField("1.5", Color.WHITE, textWidth, textHeight, textX + textWidth, textY, 18);
			_textFieldsContainer.addChild(_rangeValueTextField);
			////////////////////////////////////////
			
			//////////Формируем текстовые поля для вывода информации об уроне
			textY = rangeTextBox.y + textYInterval;
			
			var damageTextBox:TextField = createTextField("Damage:", Color.BLACK, textWidth, textHeight, textX, textY, 16);
			_textFieldsContainer.addChild(damageTextBox);
			
			_demageValueTextField = createTextField("4", Color.WHITE, textWidth, textHeight, textX + textWidth, textY, 18);
			_textFieldsContainer.addChild(_demageValueTextField);
			////////////////////////////////////////
			
			//////////Формируем текстовые поля для вывода информации об уроне
			textY = damageTextBox.y + textYInterval;
			
			var damageTypeTextBox:TextField = createTextField("Damage type:", Color.BLACK, textWidth, textHeight * 2, textX, textY, 16);
			_textFieldsContainer.addChild(damageTypeTextBox);
			
			_demageTypeValueTextField = createTextField("HP", Color.WHITE, textWidth, textHeight, textX + textWidth, textY + textHeight, 16);
			_textFieldsContainer.addChild(_demageTypeValueTextField);
			////////////////////////////////////////
			
			_textFieldsContainer.alignPivot();
		}
		
		private function createTextField(text:String, color:uint, width:Number, height:Number, x:Number, y:Number, fontSize:Number = 16, hAlign:String = HAlign.LEFT):TextField
		{
			var tField:TextField = new TextField(width, height, text, "Times New Roman", fontSize, color, true);
			
			tField.x = x;
			tField.y = y;
			tField.hAlign = hAlign;
			
			return tField;
		}
		
		public function show(posX:Number, posY:Number, towerInfo:TowerInfo):void
		{
			_nameTextField.text = towerInfo.name;
			_costValueTextField.text =  formatString("${0}", towerInfo.cost);
			_rangeValueTextField.text = towerInfo.range.toString();
			_demageValueTextField.text = towerInfo.damage.toString();
			_demageTypeValueTextField.text = towerInfo.damageType;
			
			this.x = posX;
			this.y = posY;
			
			this.visible = true;
		}
		
		public function hide():void
		{
			this.visible = false;
		}
		
	}

}