package;

import flixel.FlxSprite;

class Monster extends FlxSprite
{
    public var lifes = new Array<Life>();
    
    var _hp:Int;
    var _maxHp:Int = 5;
    var _isDead:Bool = false;
    var _attackedThisTurn:Bool = false;
    var _isStunned:Bool = false;
    var _tile:Tile;
    var _isPlayer:Bool = false;
    var _force:Int = 1;

    public function new(?path:String=AssetPaths.floor__png, ?tile:Tile, ?hp:Int=1, ?player = false)
    {
        _hp = hp;
        _tile = tile;
        _isPlayer = player;
        move(_tile);

        // Draw life
        lifes = new Array<Life>();
		for(i in 0 ... _maxHp)
		{
            var l = new Life(this, i);
            lifes[i] = l;
            lifes[i].kill();
        }
        hpCounter();

        super(_tile.x, _tile.y);

        loadGraphic(path, true, Const.TILESIZE, Const.TILESIZE);

        // Add player animatiom
        if(_isPlayer)
        {
            animation.add("idle", [0]);
            animation.add("die", [1]);
            animation.play("idle");
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
		for(i in 0 ... _hp)
		{
            lifes[i].revive();
        }
	}

    public function aiMove()
    {
        if(!_isPlayer)
            doStuff();
    }

	function doStuff():Void
	{
		var neighbors = _tile.getAdjacentPassableNeighbors();
        neighbors = neighbors.filter(function (t) return (t.monster == null || t.monster._isPlayer));
        var playerTile = getPlayerTile();
        if(neighbors.length > 0 && playerTile != null)
		{
			neighbors.sort(function(a, b) return Std.int(a.dist(playerTile)) - Std.int(b.dist(playerTile)));
			var newTile = neighbors[0];
			tryMove(newTile._row - _tile._row, newTile._column - _tile._column);
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
        // Stunned character
        if(_isStunned)
        {
            _isStunned = false;
            return true;
        }

        var newTile = _tile.getNeighbor(dx, dy);
        if(newTile.passable)
        {
            if(newTile.monster == null)
            {
                move(newTile);
            }
            else
            {
                if(_isPlayer != newTile.monster._isPlayer)
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
    }

    function hit(damage:Int):Void
    {
        _hp -= damage;
        hpCounter();
        if(_hp <= 0)
        {
            die();
        }
    }

    function die():Void
    {
        _isDead = true;
        _tile.monster = null;
        if(_isPlayer)
        {
            animation.play("die");
        }
        else 
        {
            kill();
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
        super.doStuff();
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
        super.doStuff();
    }
}