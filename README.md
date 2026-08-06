# Welcome to Honeyville! :honey_pot: :tada: :honeybee:

Please go to the Wiki section for a complete guide of the game with tips, key binds, easter eggs, and information on the story-line. I'm only one person building this game so please be patient lol. This is my first video game I've made in the odin language and it has been a lot of fun so far. I hope you enjoy it! :tada:

## How to play :honeybee:

You spawn into Honeyville with a small plot of land to get started. The starting plot of land is yours to maintain and grow into a bee farm, head to the market and purchase upgrades for your bee farm like bee hives, flowers, trees, and queen bee upgrades.
>[!TIP]
>Use your starting money to purchase a bee hive and some flower seeds.

Strategize the best business model for your farm just like real life. Each NPC will purchase honey at different rates, if you need some quick $ then sell to whoever but try to remember who pays the most. You can also go to the market or the bank to sell your honey. Keep in mind that different seasons, weather cycles and day/night cycles all have an effect on your honey production and honey value. Honey can be produced from bee hives on your land plots or you can purchase the bee factory to produce honey at a steady constant rate no matter the season, weather or day/night cycle. 

# Installation and setup :honeybee:

### Dependencies

It's recommended to have Homebrew and Odin installed. If you have Homebrew installed already, paste this into your terminal.

```
brew install odin
```

Please use these links to download them:

Homebrew: https://brew.sh 

Odin: https://odin-lang.org/docs/install/ 

## Clone repo / installation

Open your terminal and create a directory/folder for FuzzyBuddyFarms to be stored into.

```
cd
mkdir fuzzybuddyfarms
```

Now clone the repo into that directory/folder.

```
cd fuzzybuddyfarms
git clone https://github.com/ooofruitsnacks/FuzzyBuddyFarms.git
```

# How to run game

### CLI Version:

Open your terminal and paste this command.

```
cd fuzzybuddyfarms
odin run fuzzybuddyfarms.odin -file
```


### Executable Version:

Alternatively you can build the executable version as a shortcut, instead of having to use the command line to launch the game every time. 

```
cd fuzzybuddyfarms
odin build bee_farmv52.odin -file -out:FUZZYBUDDYFARMS -o:speed && odin build bee_farmv52.odin -file -out:FUZZYBUDDYFARMS -o:speed -extra-linker-flags:"-rpath @executable_path"```
```

Copy and paste or click and drag this executable program to your desired location. You can place it on your desktop or use it as an app. 
