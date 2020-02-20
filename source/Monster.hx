package;

import Enums.EffectName;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import Enums.SoundType;
import Enums.SpellName;

class Monster extends FlxSprite
{
    public var lifes = new Array<Life>();
    public var isPlayer:Bool = false;
    public var hp:Float;
    public var onMovement:Bool;
    public var spells:Array<Enums.SpellName>;
    
    var _maxHp:Int = Const.MAXHP;
    var _force:Int = Const.FORCE;
    var _isDead:Bool = false;
    var _attackedThisTurn:Bool = false;
    var _isStunned:Bool = false;
    var _teleportCounter:Int = Const.TELEPORTCOUNTER;
    var _tile:Tile;

    // { region Init

    public function new(?path:String=AssetPaths.floor__png, ?tile:Tile, ?health:Float=1, ?player = false)
    {
        hp = health;
        tile.monster = this;
        _tile = tile;
        isPlayer = player;
        onMovement = false;

        // Draw life
        lifes = new Array<Life>();
		for(i in 0 ... _maxHp)
		{
            var l = new Life(this, i);
            lifes[i] = l;
            lifes[i].kill();
        }

        super(_tile.x, _tile.y);

        loadGraphic(path, true, Const.TILESIZE, Const.TILESIZE);

        // Add player animatiom
        animation.add("idle", [0]);
        animation.add("die", [1]);
        animation.add("teleport",[2]);
        if(isPlayer)
        {
            hpCounter();
            animation.play("idle");
            _teleportCounter = -1;
        }
        else
        {
            animation.play("teleport");
        }
    }

    // } end region

    // { region AI
    
    function tick()
    {
        var total = _tile.level.monsters.length;
        var i = total;
        while(i >= 0)
        {
            if(_tile.level.monsters[i] != null)
            {
                if(!_tile.level.monsters[i]._isDead)
                    _tile.level.monsters[i].aiMove();
                else
                    _tile.level.monsters.splice(i, 1);
            }
            i--;
        }
        
        _tile.level.spawnCounter--;
        if(_tile.level.spawnCounter < 0)
        {
            _tile.level.spawnMonster();
            _tile.level.spawnCounter = _tile.level.spawnRate;
            _tile.level.spawnRate--;
        }

        checkMonsterTurn();
    }

    public function aiMove():Void
    {
        if(isPlayer)
            return;
           
        _teleportCounter--;
        if(_teleportCounter == 0)
        {
            activeMonsterAfterTeleport();
            checkMonsterTurn();
            return;
        }
        else if(_isStunned || _teleportCounter > 0)
        {
            _isStunned = false;
            checkMonsterTurn();
            return;
        }

        doStuff();
    }

	function doStuff(?callback):Void
	{
		var neighbors = _tile.getAdjacentPassableNeighbors();
        neighbors = neighbors.filter(function (t) return (t.monster == null || t.monster.isPlayer));
        var playerTile = getPlayerTile();
        if(neighbors.length > 0 && playerTile != null)
		{
			neighbors.sort(function(a, b) return Std.int(a.dist(playerTile)) - Std.int(b.dist(playerTile)));
			var newTile = neighbors[0];
            tryMove(newTile.row - _tile.row, newTile.column - _tile.column, function(){ checkMonsterTurn(); if(callback != null) callback(); });
        }
        else
        {
            checkMonsterTurn();
            if(callback != null) 
                callback();
        }
    }
    
    function getPlayerTile():Tile
    {
        if(_tile.level.player != null)
            return _tile.level.player._tile;
        else
            return null;
    }
    
    function checkMonsterTurn():Void
    {
        for(m in _tile.level.monsters)
        {
            if(m.onMovement)
                return;
        }
        _tile.level.playerTurn = true;
    }

    function activeMonsterAfterTeleport():Void
    {
        animation.play("idle");
        hpCounter();
    }

    // } end region

    // { region Movement

    function tryMove(dx:Int, dy:Int, callback:()->Void):Void
    {
        var newTile = _tile.getNeighbor(dx, dy);
        if(newTile.passable)
        {
            if(newTile.monster == null)
            {
                if(isPlayer)
                {
                    _tile.level.playerTurn = false;
                }

                move(newTile, callback);
            }
            else
            {
                if(isPlayer != newTile.monster.isPlayer)
                {
                    if(isPlayer)
                    {
                        _tile.level.playerTurn = false;
                    }

                    _attackedThisTurn = true;
                    newTile.monster._isStunned = true;

                    var origin = this.getPosition();
                    var destination = newTile.monster.getPosition();
                    onMovement = true;
                    FlxTween.tween(this, { x: destination.x, y: destination.y }, Const.MOVEMENTSPEED/2, { onComplete: function(_)
                        {
                            FlxG.camera.shake(0.01, 0.2);
                            FlxTween.tween(this, { x: origin.x, y: origin.y }, Const.MOVEMENTSPEED/2, { onComplete: function(_)
                                {
                                    if(newTile.monster != null)
                                        newTile.monster.hit(_force);
                                    onMovement = false;
                                    if(callback != null)
                                        callback();
                                }});
                        }});   
                }
            }
        }
    }

    function move(newTile:Tile, callback:()->Void):Void
    {
        if(_tile != null)
        {
            _tile.monster = null;
        }
        _tile = newTile;
        newTile.monster = this;

        onMovement = true;
        FlxTween.tween(this, { x: _tile.x, y: _tile.y }, Const.MOVEMENTSPEED, { onComplete: function(_)
            {        
                // Check exit tile
                _tile.stepOn(this);
                onMovement = false;

                if(_tile.isExit && isPlayer)
                    return;
                
                if(callback != null)
                    callback();
            }}); 
    }

    // } end region

    // { region Health

	function hpCounter()
    {
        // remove old life
        for(l in lifes)
        {
            l.kill();
        }

        // add lifes
        for(i in 0 ... Std.int(hp))
        {
            lifes[i].revive();
        }
    }

    function heal(recover:Float):Void
    {
        hp = Math.min(_maxHp, hp+recover);
        hpCounter();
    }

    function hit(damage:Int):Void
    {
        if(isPlayer)
            _tile.level.playState.playSound(SoundType.hit1);
        else
            _tile.level.playState.playSound(SoundType.hit2);

        hp -= damage;
        hpCounter();
        if(hp <= 0.5)
        {
            die();
        }
    }

    function die():Void
    {
        _isDead = true;
        _tile.monster = null;
        if(isPlayer)
        {
            animation.play("die");
            _tile.level.playState.addScores(false);
            _tile.level.playState.showGameOver();
        }
        else 
        {
            kill();
            _tile.level.playState.addScore(Const.POINTSBYKILLNGENEMIES);
        }
    }

    // } end region

    // { region Spells

    public function initSpell()
    {
        if(_tile.level.playState.saveSpells != null)
            spells = _tile.level.playState.saveSpells;
        else 
        {
            spells = new Array<Enums.SpellName>();
            for(i in 1 ... Const.STARTNBSPELLS)
            {
                addSpell();
            }
        }
    }

    public function addSpell()
    {
        if(spells == null)
            initSpell();

        if(spells.length >= Const.MAXSPELLS)
            return;

        var allSpells = SpellName.createAll();
        var newSpell = FlxG.random.int(0, allSpells.length-1);
        spells.push(allSpells[newSpell]);

        if(isPlayer)
            _tile.level.playState.updateSpellsHud();
    }

    function castSpell(index:Int, callback:()->Void):Void
    {
        _tile.level.playState.playSound(SoundType.spell);

        if(spells[index] == SpellName.WOOP)
        {
            spellWoop(callback);
        }
        else if(spells[index] == SpellName.QUAKE)
        {
            spellQuake(callback);
        }
        else if(spells[index] == SpellName.MAELSTROM)
        {
            spellMaelstrom(callback);
        }
        else if(spells[index] == SpellName.MULLIGAN)
        {
            spellMulligan(index, callback);
            return;
        }
        else if(spells[index] == SpellName.AURA)
        {
            spellAura(callback);
        }

        spells.remove(spells[index]);
        _tile.level.playState.updateSpellsHud();
    }

    function spellWoop(?callback:()->Void)
    {
        move(_tile.level.randomPassableTile(), callback);
    }

    function spellQuake(?callback:()->Void)
    {
        for(x in _tile.level.tiles)
        {
            for(t in x)
            {
                if(t == null)
                    continue;

                if(t.monster != null)
                {
                    var numWalls = 4 - t.getAdjacentPassableNeighbors().length;
                    t.monster.hit(numWalls);
                }
            }
        }
        FlxG.camera.shake(0.015, 0.2, callback);
    }

    function spellMaelstrom(?callback:()->Void)
    {
        for(i in 0 ... _tile.level.monsters.length)
        {
            if(i == _tile.level.monsters.length)
                _tile.level.monsters[i].move(_tile.level.randomPassableTile(), callback);
            else
                _tile.level.monsters[i].move(_tile.level.randomPassableTile(), null);
        }
    }

    function spellMulligan(index:Int, ?callback:()->Void)
    {
        spells.remove(spells[index]);
        if(isPlayer)
        {
            _tile.level.playState.updateSpellsHud();
            _tile.level.playState.saveSpells = spells;
        }
        _tile.level.playState.startLevel(hp);
    }

    function spellAura(?callback:()->Void)
    {
        for(t in _tile.getAdjacentNeighbors())
        {
            if(t.monster != null)
                t.monster.heal(1);
        }
        _tile.level.addEffect(EffectName.heal, _tile, 30);
        heal(1);
        
        callback();
    }

    // } end region
}

// { region Monsters

class Bird extends Monster
{
    public function new(?tile:Tile)
    {
        super(AssetPaths.bird__png, tile, 3);
    }
}

class Snake extends Monster
{
    public function new(?tile:Tile)
    {
        super(AssetPaths.snake__png, tile, 1);
    }

    override function doStuff(?callback):Void
    {
        _attackedThisTurn = false;
        super.doStuff(function() {
            repeatStuff();
        });
    }
    function repeatStuff():Void
    {
        if(!_attackedThisTurn)
        {
            super.doStuff();
        }
    }
}

class Blobby extends Monster
{
    public function new(?tile:Tile)
    {
        super(AssetPaths.blobby__png, tile, 2);
    }

    override function doStuff(?callback):Void
    {
        var startedStunned = _isStunned;
        super.doStuff();
        if(!startedStunned)
        {
            _isStunned = true;
        }
    }
}

class Eater extends Monster
{
    public function new(?tile:Tile)
    {
        super(AssetPaths.eater__png, tile, 1);
    }

    override function doStuff(?callback):Void
    {
        var neighbors = _tile.getAdjacentNeighbors().filter(function (t) return !t.passable && _tile.level.inBounds(t.row, t.column));
		if(neighbors.length > 0)
		{
            var origin = this.getPosition();
            var destination = neighbors[0].getPosition();
            onMovement = true;
            FlxTween.tween(this, { x: destination.x, y: destination.y }, Const.MOVEMENTSPEED/2, { onComplete: function(_)
                {
                    FlxTween.tween(this, { x: origin.x, y: origin.y }, Const.MOVEMENTSPEED/2, { onComplete: function(_)
                        {
                            _tile.level.replaceByFloor(neighbors[0]);
			                heal(0.5);
                            onMovement = false;
                            checkMonsterTurn();
                        }});
                }});               
		}
		else 
		{
			super.doStuff();
		}
    }
}

class Jester extends Monster
{
    public function new(?tile:Tile)
    {
        super(AssetPaths.jester__png, tile, 2);
    }

    override function doStuff(?callback):Void
    {
        var neighbors = _tile.getAdjacentPassableNeighbors();
		if(neighbors.length > 0)
		{
            var r = FlxG.random.int(0, neighbors.length-1);
			tryMove(neighbors[r].row - _tile.row, neighbors[r].column - _tile.column, function(){ checkMonsterTurn(); });
		}
    }
}

// } end region
