# Welcome to Honeyville! :honey_pot: :tada: :honeybee:

Please go to the Wiki section for a complete guide of the game with tips, key binds, easter eggs, and information on the story-line. 

I'm the only person building, testing, and improving this game so please be patient lol. I created FuzzyBuddyFarms because I wanted to learn Odin and because I wanted to try to build a real video game. My approach is a little different compared to other conventional video games, the entire game consists of 1 single odin file and only 1 asset. The asset was added as an easter egg and originally I was against using assets but I made one exception. There are no shaders, physics engines, or API calls. Everything is rendered and drawn using Raylib with vector math. This was done intentionally so anyone can play this game on any machine. You can run this game on pretty much any hardware from the past 2 decades.

A lot of time and passion has gone into this project, I hope you enjoy it! :tada:

## How to play :honeybee:

>[!TIP]
>Use your starting money to purchase a bee hive and some flower seeds at the market. 

You spawn into Honeyville with a small plot of land to get started. The starting plot of land is yours to maintain and grow into a bee farm, head to the market and purchase upgrades for your bee farm like bee hives, flowers, trees, and queen bee upgrades. Strategize the best business model for your farm just like real life. Each NPC will purchase honey at different rates, if you need some quick money then sell to whoever but try to remember who pays the most. You can also go to the market or the bank to sell your honey. Keep in mind that different seasons, weather cycles and day/night cycles all have an effect on your honey production and honey value. Honey can be produced from bee hives on your land plots or you can purchase the bee factory to produce honey at a steady constant rate no matter the season, weather or day/night cycle. Make sure to visit the soccer field, race track, fishing pond, or the park for mini games and more!  

# Download :honeybee:

>[!NOTE]
>FuzzyBuddyFarms will be available on steam as well! 

## Clone repo

If you don't use steam and want to download it directly from github, don't worry it's very easy! 

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

Once the game has downloaded, you can build an executable version to launch as an "app". This way you don't have to open a terminal and type a command every time you want to launch the game.

```
cd fuzzybuddyfarms
```

and then run

```
odin build . -out:FUZZYBUDDYFARMS -o:speed && odin build . -out:FUZZYBUDDYFARMS -o:speed -extra-linker-flags:"-rpath @executable_path"
```
