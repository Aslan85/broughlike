package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;

class Level extends FlxTypedGroup<FlxSprite>
{
	public var tiles = new Array<Array<Tile>>();
	public var treasures = new Array<Treasure>();	
	public var monsters = new Array<Monster>();
	public var player:Player;

	public var spawnCounter:Int;
	public var spawnRate:Int;

	public var playState:PlayState;
	public var playerTurn:Bool;

    public function new(state:PlayState, difficulty:Int, startLife:Float)
    {
		super();

		playState = state;

		spawnRate = 15;
		spawnCounter = spawnRate;

		// Create Level
		generateLevel();
		addMonsters(difficulty);
		addPlayer(startLife);

		// Add Exit tile
		replaceByExit(randomPassableTile());

		// Add treasures
		generateTreasures();

		// Set player turn
		playerTurn = true;
	}

    function generateLevel():Void
    {
		// Create all tiles
        var b = 0;
		do
		{
			b = generateTiles();
		} while(b != randomPassableTile().getConnectedTiles().length);

		for (i in 0...Const.NUMTILES)
		{
			for (j in 0...Const.NUMTILES)
			{
				add(tiles[i][j]);
			}
		}
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
					tiles[i][j] = new Tile.Wall(i, j, this);
				}
				else
				{
                    tiles[i][j] = new Tile.Floor(i, j, this);
                    passableTiles++;
				}
			}
		}
		return passableTiles;
	}
	
	function generateTreasures():Void
	{
		// Add treasure on tiles
		for (i in 0...3)
		{
			var tile:Tile;
			do
			{
				tile = randomPassableTile();
			} while(tile.isExit || tile.hasTreasure != null); // avoid to spawn the treasure on an exit
			var treasure = new Treasure(tile);
			add(treasure);
			treasures.push(treasure);
			tile.hasTreasure = treasure;
		}
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
			return new Tile.Wall(x, y, this);
    }

	public function replaceByFloor(where:Tile):Void
	{
		var floor =  new Tile.Floor(where.row, where.column, this);
		tiles[where.row][where.column].loadGraphicFromSprite(floor);
		tiles[where.row][where.column] = floor;
	}

	public function replaceByExit(where:Tile):Void
	{
		var exit =  new Tile.Exit(where.row, where.column, this);
		tiles[where.row][where.column].loadGraphicFromSprite(exit);
		tiles[where.row][where.column] = exit;
	}

	public function randomPassableTile():Tile
	{
		var t:Tile;
		do
		{
			t = getTile(FlxG.random.int(0, Const.NUMTILES), FlxG.random.int(0, Const.NUMTILES));
		} while(!t.passable || t.monster != null || t.isExit);
			
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
		//randomEnemy = 1;
		var monster:Monster;
		switch(randomEnemy)
		{
			case 0: monster = new Monster.Bird(randomPassableTile());
			case 1: monster = new Monster.Snake(randomPassableTile());
			case 2: monster = new Monster.Blobby(randomPassableTile());
			case 3: monster = new Monster.Eater(randomPassableTile());
			case 4: monster = new Monster.Jester(randomPassableTile());
			default : monster = new Monster.Bird(randomPassableTile());
		}
		monsters.push(monster);
		add(monster);

		for (i in 0...monster.lifes.length)
		{
			add(monster.lifes[i]);
		}
	}

	function addPlayer(life:Float)
	{
		var t:Tile;
		do
		{
			t = randomPassableTile();
		} while(t.hasTreasure != null); // avoid to spawn the player on a treasure
		player = new Player(t, life);

		add(player);
		for (i in 0...player.lifes.length)
		{
			add(player.lifes[i]);
		}
	}
}
