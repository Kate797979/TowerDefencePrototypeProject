package game.visual 
{
	
	import flash.utils.getTimer;
	import game.core.commands.ParallelCommand;
	import game.data.levels.Level;
	import game.GameManager;
	import game.data.towers.TowerInfo;
	import game.visual.creep.CreepEvent;
	import game.visual.creep.CreepStates;
	import game.visual.towerShop.TowerEvent;
	import game.visual.towerShop.TowerToolTip;
	import game.visual.wave.Wave;
	import game.visual.wave.WaveEvent;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.Color;
	import starling.utils.formatString;
	import starling.utils.HAlign;
	/**
	 * ...
	 * @author K
	 */
	public class GameStage extends Sprite
	{
		private static var _instance:GameStage;
		
		private var _gameLayer:GameLayer;
		private var _interfaceLayer:Sprite;
		private var _startGameLayer:Sprite;
		
		private var _fundsValueTextField:TextField;
		private var _livesValueTextField:TextField;
		private var _waveValueTextField:TextField;
		private var _nextWaveIntervalValueTextField:TextField;
		private var _levelValueTextField:TextField;
		
		private var _gamePlaing:Boolean = false;
		private var _restartGame:Boolean = false;
		
		public function GameStage() 
		{
			if (_instance != null)
				throw new Error("multiply instances PlanarView");
				
			_instance = this;
		}
		
		public function init():void
		{
			_gameLayer = new GameLayer();
			addChild(_gameLayer);
			
			_interfaceLayer = new Sprite();
			addChild(_interfaceLayer);
			
			createInfoTextFields();
			createTowerButtons();
			createStartGameLayer();
			
			showStartGameLayer();
		}
		
		private function startGameLevel(level:Level):void
		{
			if (_gameFail || _gameWin)
			{
				clearAll();
				resetGame();
			}
			
			_currentLevel = GameManager.levels.currentLevel = level;
			_gamePlaing = true;
			
			_gameLayer.currentLevel = _currentLevel;
				
			//////////////////////Рисуем сетку карты
			if (GameManager.showMapField)
				_gameLayer.drawMap(_currentLevel.map);
			/////////////////////////////////////////
			
			_levelValueTextField.text = _currentLevel.index.toString();
			_livesValueTextField.text = GameManager.player.lives.toString();
			_fundsValueTextField.text = formatString("${0}", GameManager.player.funds.toString());
			_waveValueTextField.text = formatString("{0}/{1}", _currentLevel.waves.currentWaveIndex + 1, _currentLevel.waves.wavesCount);
			_nextWaveIntervalValueTextField.text = formatString("{0}", Math.max(0, _currentLevel.waves.nextWaveInterval));
			
			initDeltaTime();
			
			subscribeEvents();
		}
		
		private function subscribeEvents():void
		{
			_currentLevel.waves.addEventListener(WaveEvent.NEXT_WAVE_NEED_STARTED, nextWaveStartedEventHandler);
			_currentLevel.waves.addEventListener(WaveEvent.NEXT_WAVE_INTERVAL_CHANGED, nextWaveIntervalChangedEventHandler);
			_currentLevel.waves.addEventListener(WaveEvent.ALL_WAVES_COMPLETED, allWavesCompleteHandler);
			
			addEventListener(EnterFrameEvent.ENTER_FRAME, enterFrameEventHandler);
		}
		
		private function unsubscribeEvents():void
		{
			_currentLevel.waves.removeEventListener(WaveEvent.NEXT_WAVE_NEED_STARTED, nextWaveStartedEventHandler);
			_currentLevel.waves.removeEventListener(WaveEvent.NEXT_WAVE_INTERVAL_CHANGED, nextWaveIntervalChangedEventHandler);
			_currentLevel.waves.removeEventListener(WaveEvent.ALL_WAVES_COMPLETED, allWavesCompleteHandler);
			
			removeEventListener(EnterFrameEvent.ENTER_FRAME, enterFrameEventHandler);
		}
		
		private function nextWaveIntervalChangedEventHandler(e:WaveEvent):void 
		{
			_nextWaveIntervalValueTextField.text = formatString("{0}", Math.max(0, _currentLevel.waves.nextWaveInterval));
		}
		
		private var _wavesCreepsMoveCommands:Vector.<ParallelCommand> = new Vector.<ParallelCommand>();
		private function nextWaveStartedEventHandler(e:WaveEvent):void 
		{
			_currentLevel.waves.startNextWave();
			
			_waveValueTextField.text = formatString("{0}/{1}", _currentLevel.waves.currentWaveIndex + 1, _currentLevel.waves.wavesCount);

			var wave:Wave = _currentLevel.waves.currentWave;
			
			wave.addEventListener(CreepEvent.STATE_CHANGED, onCreepStateChanged);
			
			var creepsMoveParallelCommand:ParallelCommand = wave.createWaveMoveCommand(_gameLayer, _currentLevel.map);
			_wavesCreepsMoveCommands.push(creepsMoveParallelCommand);
			creepsMoveParallelCommand.start(function ():void
			{
				_wavesCreepsMoveCommands.splice(_wavesCreepsMoveCommands.indexOf(this), 1);
			});
		}
		
		private function onCreepStateChanged(e:CreepEvent):void 
		{
			if (e.creep.state == CreepStates.COMPLETED)
			{
				GameManager.player.lives--;
				
				_livesValueTextField.text = GameManager.player.lives.toString();
				
				if (GameManager.player.lives == 0)//Проиграли
				{
					onGameFail();
				}
				
			}
			else if (e.creep.state == CreepStates.KILLED)
			{
				addPlayerFunds(e.creep.wave.waveInfo.creepReward);
			}
		}
		
		private function allWavesCompleteHandler(e:WaveEvent):void 
		{
			onGameWin();
		}
		
		private function onGameWin():void
		{
			_gameWin = true;
			
			stopAll();

			showStartGameLayer();
		}
		
		private function onGameFail():void
		{
			_gameFail = true;
			
			stopAll();
			
			showStartGameLayer();
		}
		
		private function resetGame():void 
		{
			if (_currentLevel != null)
			{
				_gameFail = false;
				_gameWin = false;
				
				GameManager.resetGame();
			}
		}
		
		private function clearAll():void
		{
			_gameLayer.clearAll();
		}
		
		private function stopAll():void
		{
			unsubscribeEvents();
				
			var wavesCreepsMoveCommands:Vector.<ParallelCommand> = _wavesCreepsMoveCommands.slice();
			for each(var creepsMoveParallelCommand:ParallelCommand in wavesCreepsMoveCommands)
			{
				creepsMoveParallelCommand.stop();
			}
			
		}
		
		private var _deltaTime:Number = 0;//В секундах
		private function enterFrameEventHandler(e:EnterFrameEvent):void 
		{
			if (_gamePlaing)
			{
				var dTime:Number = getDeltaTime();
				_deltaTime += dTime;
				if (_deltaTime >= 1)
				{
					var secDelta:int = Math.floor(_deltaTime);
					_deltaTime -= secDelta;
					
					_currentLevel.waves.nextWaveInterval -= secDelta;
					_nextWaveIntervalValueTextField.text = formatString("{0}", Math.max(0, _currentLevel.waves.nextWaveInterval));
				}
				
				_gameLayer.update(dTime);
			}
		}
		
		private function initDeltaTime():void
		{
			_deltaTime = 0;
			_lastTime = getTimer() / 1000;
			_currentTime = _lastTime;
		}
		
		private var _lastTime:Number = 0;
		private var _currentTime:Number = 0;
		private function getDeltaTime():Number
		{
			_lastTime = _currentTime;
			_currentTime = getTimer() / 1000;
			
			return _currentTime - _lastTime; 
		}
		
		private var _startGameButton:Button;
		private var _startGameTextField:TextField;
		private function createStartGameLayer():void
		{
			_startGameLayer = new Sprite();
			addChild(_startGameLayer);
			
			var fadeQuadr:Quad = new Quad(GameManager.gameWidth, GameManager.gameHeight, 0x00063c);
			fadeQuadr.alpha = 0.65;
			_startGameLayer.addChild(fadeQuadr);
			
			////////Формируем текстовое поле
			_startGameTextField = new TextField(300, 200, "HELLO!\n\nI'm Kate.\nHelp me to kill my enemies!", "Times New Roman", 24, Color.WHITE, true);
			
			_startGameTextField.x = 250;
			_startGameTextField.y = 150;
			
			_startGameLayer.addChild(_startGameTextField);
			/////////////////////////////
			
			/////////////Формируем кнопку для старта игры
			_startGameButton = new Button(VisualManager.getTexture("buttonTexture"), "Start Game");
			
			_startGameButton.alignPivot();
			
			_startGameButton.x = GameManager.gameWidth / 2;
			_startGameButton.y = GameManager.gameHeight * 2 / 3;
			
			_startGameLayer.addChild(_startGameButton);
			
			_startGameButton.addEventListener(Event.TRIGGERED, startGameButtonTrigged);
			////////////////////////////////////
			
			_startGameLayer.alpha = 0;
			_startGameLayer.visible = false;
		}
		
		private var _gameFail:Boolean = false;
		private var _gameWin:Boolean = false;
		private var _currentLevel:Level;
		private function startGameButtonTrigged(e:Event):void 
		{
			hideStartGameLayer();
			
			startGameLevel(_gameFail || _gameWin ? _currentLevel : GameManager.levels.getNextLevel());
		}
		
		private function showStartGameLayer(onComplete:Function = null):void
		{
			_startGameButton.text = _restartGame ? "Restart" : "Start game";
			_startGameTextField.text = _gameFail ? "OOPS...\n\nLevel is failed...\nTry again!" :
				_gameWin ? "My congratulations!\n\n Thanks for your help!\n;-)" :
				"HELLO!\n\nI'm Kate.\nHelp me to kill my enemies!";
			
			if (!_restartGame)
				_restartGame = true;
			
			_startGameLayer.alpha = 0;
			_startGameLayer.visible = true;
			
			/////////
			var showTween:Tween = new Tween(_startGameLayer, 0.75);
			
			showTween.onComplete = onComplete;
			showTween.fadeTo(1);
			
			Starling.juggler.add(showTween);
			/////////////
		}
		
		private function hideStartGameLayer(onComplete:Function = null):void
		{
			var hideTween:Tween = new Tween(_startGameLayer, 0.75);
			hideTween.onComplete = function ():void
			{
				_startGameLayer.visible = false;
				
				if (onComplete != null)
					onComplete();
			}
			hideTween.fadeTo(0);
			
			Starling.juggler.add(hideTween);
		}
			
		private function createInfoTextFields():void
		{
			var textX:Number = 30;
			var textY:Number = 10;
			var textHeight:Number = 25;
			
			//////////Текущий уровень
			var levelTextField:TextField = createTextField("Level:", Color.WHITE, 70, textHeight, textX, textY, 18, HAlign.RIGHT);
			_interfaceLayer.addChild(levelTextField);
			
			_levelValueTextField = createTextField("", Color.TEAL, 50, textHeight, levelTextField.x + levelTextField.width, textY, 20);
			_interfaceLayer.addChild(_levelValueTextField);
			////////////////////////////////////////
			
			//////////Жизни  игрока
			textX = _levelValueTextField.x + _levelValueTextField.width + 30;
			
			var livesTextField:TextField = createTextField("Lives:", Color.WHITE, 70, textHeight, textX, textY, 18, HAlign.RIGHT);
			_interfaceLayer.addChild(livesTextField);
			
			_livesValueTextField = createTextField("", Color.LIME, 50, textHeight, livesTextField.x + livesTextField.width, textY, 20);
			_interfaceLayer.addChild(_livesValueTextField);
			////////////////////////////////////////
			
			//////////Средства игрока
			textX = _livesValueTextField.x + _livesValueTextField.width + 30;
			
			var fundsTextField:TextField = createTextField("Funds:", Color.WHITE, 70, textHeight, textX, textY, 18, HAlign.RIGHT);
			_interfaceLayer.addChild(fundsTextField);
			
			_fundsValueTextField = createTextField("", Color.YELLOW, 50, textHeight, fundsTextField.x + fundsTextField.width, textY, 20);
			_interfaceLayer.addChild(_fundsValueTextField);
			////////////////////////////////////////
			
			//////////Текущая волна
			textX = 30;
			textY += textHeight;
			
			var waveTextField:TextField = createTextField("Wave:", Color.WHITE, 70, textHeight, textX, textY, 18, HAlign.RIGHT);
			_interfaceLayer.addChild(waveTextField);
			
			_waveValueTextField = createTextField("", Color.BLUE, 50, textHeight, waveTextField.x + waveTextField.width, textY, 20);
			_interfaceLayer.addChild(_waveValueTextField);
			////////////////////////////////////////
			
			//////////Временной интервал, через который появится следующая волна
			textX = _waveValueTextField.x + _waveValueTextField.width + 10;
			
			var nextWaveIntervalTextField:TextField = createTextField("Next wave:", Color.WHITE, 90, textHeight, textX, textY, 18, HAlign.RIGHT);
			_interfaceLayer.addChild(nextWaveIntervalTextField);
			
			_nextWaveIntervalValueTextField = createTextField("", Color.RED, 50, textHeight, nextWaveIntervalTextField.x + nextWaveIntervalTextField.width, textY, 20);
			_interfaceLayer.addChild(_nextWaveIntervalValueTextField);
			////////////////////////////////////////
		}
		
		private function createTextField(text:String, color:uint, width:Number, height:Number, x:Number, y:Number, fontSize:Number = 18, hAlign:String = HAlign.LEFT):TextField
		{
			var tField:TextField = new TextField(width, height, text, "Times New Roman", fontSize, color, true);
			
			tField.x = x;
			tField.y = y;
			tField.hAlign = hAlign;
			
			return tField;
		}
		
		private var _towerToolTip:TowerToolTip;
		private function createTowerButtons():void
		{
			//////////Формируем кнопки для добавления башен
			var towers:Array = GameManager.towers;
			var towersButtons:Vector.<TowerButton> = new Vector.<TowerButton>();
			var tButton:TowerButton;
			for each (var tInfo:TowerInfo in towers)
			{
				tButton = new TowerButton(tInfo);
				towersButtons.push(tButton);
				
				tButton.addEventListener(TowerEvent.OVER, towerButtonEventHandler);
				tButton.addEventListener(TowerEvent.OUT, towerButtonEventHandler);
				tButton.addEventListener(TowerEvent.TRIGGED, towerButtonEventHandler);
			}
			
			var topOffset:Number = 170;
			var rightOffset:Number = 60;
			var buttonsInterval:Number = 20;
			for (var i:int =  0; i < towersButtons.length; i++)
			{
				tButton = towersButtons[i];
				
				tButton.x = GameManager.gameWidth - rightOffset;
				tButton.y = topOffset + i * (tButton.height + buttonsInterval);
				
				_interfaceLayer.addChild(tButton);
			}
			///////////////////////////////////////////////
			
			//////Формируем тултип для вывода информации  о башнях
			_towerToolTip = new TowerToolTip();
			_interfaceLayer.addChild(_towerToolTip);
			_towerToolTip.hide();
			//////////////////////
		}
		
		private function towerButtonEventHandler(e:TowerEvent):void 
		{
			var tButton:TowerButton;
			switch (e.type)
			{
				case TowerEvent.OVER:
					tButton = e.target as TowerButton;
					
					var ttX:Number = tButton.x - tButton.width / 2 - _towerToolTip.width / 2 - 10;
					var ttY:Number = tButton.y + (_towerToolTip.height - tButton.height) / 2;
					
					_towerToolTip.show(ttX, ttY, e.towerInfo);
					break;
				case TowerEvent.OUT:
					_towerToolTip.hide();
					break;
				case TowerEvent.TRIGGED:
					if (GameManager.player.funds >= e.towerInfo.cost && !_gameLayer.towerDragging)
					{
						addPlayerFunds(-e.towerInfo.cost);
						
						tButton = e.target as TowerButton;
						_gameLayer.startDragTower(e.towerInfo, tButton.x - tButton.width / 2, tButton.y);
					}
					break;
			}
		}
		
		private function addPlayerFunds(summ:Number):void
		{
			GameManager.player.funds += summ;
			_fundsValueTextField.text = formatString("${0}", GameManager.player.funds.toString());
		}
		
		public static function getInstance():GameStage
		{
			if (_instance == null)
				throw new Error("GameStage instance does not exists");

			return _instance;
		}
		
	}

}