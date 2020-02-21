package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.tweens.FlxTween;
import Enums.SoundType;
import Enums.SpellName;
import Enums.EffectName;

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
    var _lastMove:FlxPoint;
    var _bonusAttack:Int;
    var _shield:Int;
    var _tile:Tile;

    // { region Init

    public function new(?path:String=AssetPaths.floor__png, ?tile:Tile, ?health:Float=1, ?player = false)
    {
        hp = health;
        tile.monster = this;
        isPlayer = player;
        onMovement = false;
        _lastMove = new FlxPoint(-1, 0);
        _bonusAttack = 0;
        _shield = 0;
        _tile = tile;

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
            _lastMove.set(dx, dy);
            if(_shield > 0)
                _shield--;

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
                                    {
                                        newTile.monster.hit(_force + _bonusAttack);
                                        _bonusAttack = 0;
                                    }
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
        if(_shield > 0)
            return;

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
        else if(spells[index] == SpellName.DASH)
        {
            spellDash(callback);
        }
        else if(spells[index] == SpellName.DIG)
        {
            spellDig(callback);
        }
        else if(spells[index] == SpellName.KINGMAKER)
        {
            spellKingmaker(callback);
        }
        else if(spells[index] == SpellName.ALCHEMY)
        {
            spellAlchemy(callback);
        }
        else if(spells[index] == SpellName.POWER)
        {
            spellPower(callback);
        }
        else if(spells[index] == SpellName.BRAVERY)
        {
            spellBravery(callback);
        }
        else if(spells[index] == SpellName.BOLT)
        {
            spellBolt(callback);
        }
        else if(spells[index] == SpellName.CROSS)
        {
            spellCross(callback);
        }
        else if(spells[index] == SpellName.EX)
        {
            spellEx(callback);
        }


        spells.remove(spells[index]);
        _tile.level.playState.updateSpellsHud();
    }

    function spellWoop(?callback:()->Void):Void
    {
        move(_tile.level.randomPassableTile(), callback);
    }

    function spellQuake(?callback:()->Void):Void
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

    function spellMaelstrom(?callback:()->Void):Void
    {
        for(i in 0 ... _tile.level.monsters.length)
        {
            if(i == _tile.level.monsters.length)
                _tile.level.monsters[i].move(_tile.level.randomPassableTile(), callback);
            else
                _tile.level.monsters[i].move(_tile.level.randomPassableTile(), null);
        }
    }

    function spellMulligan(index:Int, ?callback:()->Void):Void
    {
        spells.remove(spells[index]);
        if(isPlayer)
        {
            _tile.level.playState.updateSpellsHud();
            _tile.level.playState.saveSpells = spells;
        }
        _tile.level.playState.startLevel(hp);
    }

    function spellAura(?callback:()->Void):Void
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

    function spellDash(?callback:()->Void):Void
    {
        var newTile = _tile;
        while(true)
        {
            var testTile = newTile.getNeighbor(Std.int(_lastMove.x), Std.int(_lastMove.y));
            if(testTile.passable && testTile.monster == null)
            {
                newTile = testTile;
            }
            else
            {
                break;
            }
        }
        if(_tile != newTile)
        {
            move(newTile, () -> { 
                for(t in newTile.getAdjacentNeighbors())
                {
                    if(t.monster != null)
                    {
                        _tile.level.addEffect(EffectName.explosion, t, 30);
                        t.monster._isStunned = true;
                        t.monster.hit(1);
                    }
                }
                callback();
            });
        }
        else
        {
            callback();
        }
    }

    function spellDig(?callback:()->Void):Void
    {
        for(i in 1 ... _tile.level.tiles.length -1)
        {
            for(j in 1 ... _tile.level.tiles[i].length -2)
            {
                var t = _tile.level.getTile(i, j);
                if(!t.passable)
                {
                    _tile.level.replaceByFloor(t);
                }
            }
        }
        _tile.level.addEffect(EffectName.heal, _tile, 30);
        heal(2);
        callback();
    }

    function spellKingmaker(?callback:()->Void):Void
    {
        for(m in _tile.level.monsters)
        {
            m.heal(1);
            _tile.level.createTreasure(m._tile);
        }
        callback();
    }

    function spellAlchemy(?callback:()->Void):Void
    {
        for(t in _tile.getAdjacentNeighbors())
        {
            if(!t.passable && _tile.level.inBounds(t.row, t.column))
            {
                _tile.level.replaceByFloor(t);
                _tile.level.createTreasure(_tile.level.getTile(t.row, t.column));
            }
        }
        callback();
    }

    function spellPower(?callback:()->Void):Void
    {
        _bonusAttack = 5;
        callback();
    }

    function spellBravery(?callback:()->Void):Void
    {
        _shield = 2;
        callback();
    }

    function spellBolt(?callback:()->Void):Void
    {
        var effect = EffectName.hBoltEffect;
        if(Math.abs(_lastMove.y) == 1)
            effect = EffectName.vBoltEffect;

        boltTravel(_lastMove, effect, 4);
        callback();
    }

    function spellCross(?callback:()->Void):Void
    {
        var direction = [
            [0, -1],
            [0, 1],
            [-1, 0],
            [1, 0]
        ];
        for(i in 0 ... direction.length)
        {
            var effect = EffectName.hBoltEffect;
            if(Math.abs(direction[i][1]) == 1)
                effect = EffectName.vBoltEffect;

            var dir:FlxPoint = new FlxPoint(direction[i][0], direction[i][1]);
            boltTravel(dir, effect, 2);
        }

        callback();
    }

    function spellEx(?callback:()->Void):Void
    {
        var direction = [
            [-1, -1],
            [-1, 1],
            [1, -1],
            [1, 1]
        ];
        for(i in 0 ... direction.length)
        {
            var dir:FlxPoint = new FlxPoint(direction[i][0], direction[i][1]);
            boltTravel(dir, EffectName.explosion, 2);
        }
        callback();
    }

    function boltTravel(direction:FlxPoint, effect:Enums.EffectName, damage:Int):Void
    {
        var newTile = _tile;
        while(true)
        {
            var testTile = newTile.getNeighbor(Std.int(direction.x), Std.int(direction.y));
            if(testTile.passable)
            {
                newTile = testTile;
                if(newTile.monster != null)
                {
                    newTile.monster.hit(damage);
                }
                _tile.level.addEffect(effect, newTile, 30);
            }
            else
            {
                break;
            }
        }
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
