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

Go to the release section of FuzzyBuddyFarms.

<img width="376" height="153" alt="Screenshot 2026-09-01 at 12 35 23 PM" src="https://github.com/user-attachments/assets/00a3d533-335c-4215-a335-7c946307e2f5" />

Click on the zip file for your hardware architecture and download that zip file. 

<img width="1236" height="515" alt="Screenshot 2026-09-01 at 12 44 04 PM" src="https://github.com/user-attachments/assets/9de708d5-ced2-488c-ae77-b1bba0fc3056" />

For Apple users, it will flash a spooky warning message but don't be alarmed. 

This is just because it is not verified by Apple directly, good news everything is completely open source so you can verify everything yourself. 

Close out of the spooky scary urgent warning message and locate "Privacy and Security", about mid way down in the main menu.

<img width="221" height="110" alt="Screenshot 2026-09-01 at 12 39 22 PM" src="https://github.com/user-attachments/assets/6878a18c-8777-4325-827c-fd9b6a8250c5" />

Scroll all the way down and find:

<img width="479" height="184" alt="Screenshot 2026-09-01 at 12 33 09 PM" src="https://github.com/user-attachments/assets/b4aa33c0-b0a1-43aa-9b72-91390c1b1771" />

Click open anyway and it will open another prompt window. 

Click "Open Anyway" again in the window and then relaunch FuzzyBuddyFarms. It will now open and run the game.

<img width="276" height="355" alt="Screenshot 2026-09-01 at 12 33 20 PM" src="https://github.com/user-attachments/assets/66c7920c-e082-4e64-ad0b-41b2c09adca8" />


# Build From Source

If you don't trust pre-bundled packages or if you want to make your own changes to the source code to have a more unique bee farming experience, you can do so easily by building from source for your machine. Below is a full step by step guide to build from source. Enjoy :)

## macOS (arm64)

If you don't use steam and want to download it directly from github, don't worry it's very easy!

Please ensure you have ```Homebrew``` and ```Odin``` downloaded.

WITH HOMEBREW DOWNLOADED:

Open a new terminal and run:

```
brew install odin
```

If you don't have Homebrew installed, please visit ``` https://odin-lang.org/docs/install/ ``` to install the Odin language or build from source, this is needed so you can build your release as an executable. 

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

Then run to build an executable. This will not build unless you have Odin installed as I mentioned earlier.

```
odin build . -out:FUZZYBUDDYFARMS -o:speed && odin build . -out:FUZZYBUDDYFARMS -o:speed -extra-linker-flags:"-rpath @executable_path"
```
