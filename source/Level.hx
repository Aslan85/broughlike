package;

import flixel.FlxG;
import Tile.Wall;
import Tile.Floor;

class Level
{
	public var tiles = new Array<Array<Tile>>();	
	public var monsters = new Array<Monster>();
	public var player:Player;

	public var spwanCounter:Int;
	public var spawnRate:Int;

	public var playState:PlayState;

    public function new(state:PlayState, difficulty:Int)
    {
		playState = state;

		spawnRate = 15;
		spwanCounter = spawnRate;

		generateLevel();
		addMonsters(difficulty);
		addPlayer();
    }

    function generateLevel():Void
    {
        var b = 0;
		do
		{
            b = generateTiles();
		} while(b != randomPassableTile().getConnectedTiles().length);
    }

    function generateTiles():Int
    {
        var passableTiles = 0;
        for (i in 0...Const.NUMTILES) { tiles[i] = []; tiles[i][Const.NUMTILES] = null; }
		for (i in 0...Const.NUMTILES)
		{
			for (j in 0...Const.NUMTILES)
			{
				if(FlxG.random.float() < 0.3 || !inBounds(i, j))
				{
					tiles[i][j] = new Wall(i, j, this);
				}
				else
				{
                    tiles[i][j] = new Floor(i, j, this);
                    passableTiles++;
				}
			}
		}
		return passableTiles;
    }

	public function inBounds(x:Int, y:Int):Bool
	{
		return x>0 && y>0 && x < Const.NUMTILES-1 && y < Const.NUMTILES-1;
	}

	public function getTile(x:Int, y:Int):Tile
	{
		if(inBounds(x,y))
			return tiles[x][y];
    	else
			return new Wall(x, y, this);
    }

	public function replaceByFloor(where:Tile):Void
	{
		var floor =  new Floor(where.row, where.column, this);
		tiles[where.row][where.column].loadGraphicFromSprite(floor);
		tiles[where.row][where.column] = floor;
	}

	public function randomPassableTile():Tile
	{
		var t:Tile;
		do
		{
			t = getTile(FlxG.random.int(0, Const.NUMTILES), FlxG.random.int(0, Const.NUMTILES));
		} while(!t.passable || t.monster != null);
			
		return t;
	}
	
	function addMonsters(level:Int)
	{
		var numMonsters = level+1;
		for (i in 0...numMonsters)
		{
			spawnMonster();
		}
	}
	
	public function spawnMonster()
	{
		var randomEnemy = FlxG.random.int(0, 4);
		switch(randomEnemy)
		{
			case 0: var monster = new Monster.Bird(randomPassableTile()); monsters.push(monster);
			case 1: var monster = new Monster.Snake(randomPassableTile()); monsters.push(monster);
			case 2: var monster = new Monster.Blobby(randomPassableTile()); monsters.push(monster);
			case 3: var monster = new Monster.Eater(randomPassableTile()); monsters.push(monster);
			case 4: var monster = new Monster.Jester(randomPassableTile()); monsters.push(monster);
			default : var monster = new Monster.Bird(randomPassableTile()); monsters.push(monster);
		}
	}

	function addPlayer()
	{
		player = new Player(randomPassableTile());
		monsters.push(player);
	}
}
