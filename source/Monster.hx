package;

import flixel.FlxG;
import flixel.FlxSprite;

class Monster extends FlxSprite
{
    public var lifes = new Array<Life>();
    public var isPlayer:Bool = false;
    public var hp:Float;
    
    var _maxHp:Int = Const.MAXHP;
    var _force:Int = Const.FORCE;
    var _isDead:Bool = false;
    var _attackedThisTurn:Bool = false;
    var _isStunned:Bool = false;
    var _teleportCounter:Int = Const.TELEPORTCOUNTER;
    var _tile:Tile;

    public function new(?path:String=AssetPaths.floor__png, ?tile:Tile, ?health:Float=1, ?player = false)
    {
        hp = health;
        _tile = tile;
        isPlayer = player;
        move(_tile);

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
            _teleportCounter = 0;
        }
        else
        {
            animation.play("teleport");
        }
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
    }

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

    public function aiMove():Void
    {
        if(isPlayer)
            return;
           
        _teleportCounter--;
        if(_isStunned || _teleportCounter > 0)
        {
            _isStunned = false;
            return;
        }
        else if(_teleportCounter == 0)
        {
            activeMonsterAfterTeleport();
            return;
        }

        doStuff();
    }

	function doStuff():Void
	{
		var neighbors = _tile.getAdjacentPassableNeighbors();
        neighbors = neighbors.filter(function (t) return (t.monster == null || t.monster.isPlayer));
        var playerTile = getPlayerTile();
        if(neighbors.length > 0 && playerTile != null)
		{
			neighbors.sort(function(a, b) return Std.int(a.dist(playerTile)) - Std.int(b.dist(playerTile)));
			var newTile = neighbors[0];
			tryMove(newTile.row - _tile.row, newTile.column - _tile.column);
		}
    }
    
    function getPlayerTile():Tile
    {
        if(_tile.level.player != null)
            return _tile.level.player._tile;
        else
            return null;
    }

    function tryMove(dx:Int, dy:Int):Bool
    {
        var newTile = _tile.getNeighbor(dx, dy);
        if(newTile.passable)
        {
            if(newTile.monster == null ||
                (newTile.monster != null && newTile.monster._teleportCounter > 0))
            {
                move(newTile);
            }
            else
            {
                if(isPlayer != newTile.monster.isPlayer)
                {
                    _attackedThisTurn = true;
                    newTile.monster._isStunned = true;

                    newTile.monster.hit(_force);
                }
            }
            return true;
        }
        return false;
    }

    function activeMonsterAfterTeleport()
    {
        animation.play("idle");
        hpCounter();
    }

    function move(tile:Tile):Void
    {
        if(_tile != null)
        {
            _tile.monster = null;
        }
        _tile = tile;
        tile.monster = this;

        x = _tile.x;
        y = _tile.y;

        // move life UI
        for(l in lifes)
            l.moveLife();

        // Check exit tile
        _tile.stepOn(this);
    }

    function heal(recover:Float):Void
    {
        hp = Math.min(_maxHp, hp+recover);
        hpCounter();
    }

    function hit(damage:Int):Void
    {
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
            _tile.level.playState.showGameOver();
        }
        else 
        {
            kill();
            _tile.level.playState.addScore(Const.POINTSBYKILLNGENEMIES);
        }
    }

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
			i --;
        }
        
        _tile.level.spwanCounter--;
        if(_tile.level.spwanCounter < 0)
        {
            _tile.level.spawnMonster();
            _tile.level.spwanCounter = _tile.level.spawnRate;
            _tile.level.spawnRate--;
        }
	}
}

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

    override function doStuff():Void
    {
        _attackedThisTurn = false;
        super.doStuff();

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

    override function doStuff():Void
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

    override function doStuff():Void
    {
        var neighbors = _tile.getAdjacentNeighbors().filter(function (t) return !t.passable && _tile.level.inBounds(t.row, t.column));
		if(neighbors.length > 0)
		{
            _tile.level.replaceByFloor(neighbors[0]);
			heal(0.5);
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

    override function doStuff():Void
    {
        var neighbors = _tile.getAdjacentPassableNeighbors();
		if(neighbors.length > 0)
		{
            var r = FlxG.random.int(0, neighbors.length-1);
			tryMove(neighbors[r].row - _tile.row, neighbors[r].column - _tile.column);
		}
    }
}