# Welcome to Honeyville! :honey_pot: :tada: :honeybee:

## Table of Contents

- [How to play](#how-to-play-honeybee)
- [Download](#download-honeybee)
- [Verify SHA256 Fingerprint](#verify-release-checksum)
  - [Apple Warning bypass](#apple-warning-bypass)
- [Build From Source](#build-from-source)
  - [macOS (Silicon/arm64/Intel/amd64)](#macos-siliconarm64intelamd64)
  - [Windows (amd64 / intel or amd)](#windows-amd64--intel-or-amd)
  - [Linux (amd64/aarch64)](#linux-amd64aarch64)
  - [Linux (arm64/aarch64)](#linux-arm64aarch64)
- [License](#license)
- [Security Policy](#security-policy)


Please go to the Wiki section for a complete guide of the game with tips, key binds, easter eggs, and information on the story-line. A lot of time and passion has gone into this project. I hope you enjoy it! :tada:

I'm the only person building, testing, and improving this game so please be patient lol. I created FuzzyBuddyFarms because I wanted to learn Odin and because I wanted to try to build a real video game. My approach is a little different compared to other conventional video games, the entire game consists of 1 single odin file and only 1 asset. The asset was added as an easter egg and originally I was against using assets but I made one exception. There are no shaders, physics engines, or API calls. Everything is rendered and drawn using Raylib with vector math. This was done intentionally so anyone can play this game on any machine. You can run this game on pretty much any hardware from the past 2 decades.


## How to play :honeybee:

>[!TIP]
>Use your starting money to purchase a bee hive and some flower seeds at the market. 

You spawn into Honeyville with a small plot of land to get started. The starting plot of land is yours to maintain and grow into a bee farm, head to the market and purchase upgrades for your bee farm like bee hives, flowers, trees, and queen bee upgrades. Strategize the best business model for your farm just like real life. Each NPC will purchase honey at different rates, if you need some quick money then sell to whoever but try to remember who pays the most. You can also go to the market or the bank to sell your honey. Keep in mind that different seasons, weather cycles and day/night cycles all have an effect on your honey production and honey value. Honey can be produced from bee hives on your land plots or you can purchase the bee factory to produce honey at a steady constant rate no matter the season, weather or day/night cycle. Make sure to visit the soccer field, race track, fishing pond, or the park for mini games and more!  

# Download :honeybee:

>[!NOTE]
>FuzzyBuddyFarms will be available on steam as well!

| Platform | Download |
|---|---|
| Windows (64bit / Intel or AMD) | `Fuzzy_Buddy_Farms-windows-amd64.zip` |
| macOS (Apple Silicon / M series) | `Fuzzy_Buddy_Farms-macos-arm64.zip` |
| macOS (Intel) | `Fuzzy_Buddy_Farms-macos-amd64.zip` |
| Linux (64bit / Intel or AMD) | `Fuzzy_Buddy_Farms-linux-amd64.zip` |
| Linux ARM64 (Raspberry Pi 3/4/5/400) | `Fuzzy_Buddy_Farms-linux-arm64.zip` |

__Go to the release section of FuzzyBuddyFarms__

<img width="376" height="153" alt="Screenshot 2026-09-01 at 12 35 23 PM" src="https://github.com/user-attachments/assets/00a3d533-335c-4215-a335-7c946307e2f5" />

Click on the zip file for your hardware architecture and download that zip file. Just a heads up, it will flash a spooky warning message but don't be alarmed. This is just because it is not signed with a certificate but good news! Everything is completely open source so you can verify everything yourself! Wow!

# Verify Release Checksum

Each release includes a `checksums.txt` file with SHA256 hashes for every zip. To verify your download hasn't been tampered with:

**macOS / Linux:**

Open the directory where you have FuzzyBuddyFarms saved and run:

```
shasum -a 256 -c checksums.txt
```

Compare the output against the matching line in `checksums.txt`.

**Windows:**

Open the directory where you have FuzzyBuddyFarms saved and run:

```
Get-FileHash .\Fuzzy_Buddy_Farms-windows-amd64.zip -Algorithm SHA256
```

Compare the output against the matching line in `checksums.txt`.


## Apple Warning bypass 

As I mentioned above, your OS will probably display a warning message when you try to execute the program. For Apple users this can be over ridden with the steps below. If you are not comfortable with this option, please download from Steam. 
 
__Close out of the spooky scary urgent warning message and locate "Privacy and Security", about mid way down in the main menu:__

<img width="221" height="110" alt="Screenshot 2026-09-01 at 12 39 22 PM" src="https://github.com/user-attachments/assets/6878a18c-8777-4325-827c-fd9b6a8250c5" />

__Scroll all the way down and find:__

<img width="479" height="184" alt="Screenshot 2026-09-01 at 12 33 09 PM" src="https://github.com/user-attachments/assets/b4aa33c0-b0a1-43aa-9b72-91390c1b1771" />

__Click open anyway and it will open another prompt window:__

Click "Open Anyway" again in the window and then relaunch FuzzyBuddyFarms. It will now open and run the game.

<img width="276" height="355" alt="Screenshot 2026-09-01 at 12 33 20 PM" src="https://github.com/user-attachments/assets/66c7920c-e082-4e64-ad0b-41b2c09adca8" />


# Build From Source

If you don't trust pre-bundled packages or if you want to make your own changes to the source code to have a more unique bee farming experience, you can do so easily by building from source for your machine. Below is a full step by step guide to build from source. Enjoy :)

## macOS (Silicon/arm64/Intel/amd64)

This step by step guide can be used for both M series and Intel chips generations, if you run into any issues please leave report it under ```Issues``` so I can fix the guide. 

If you don't use steam and want to download it directly from github, don't worry it's very easy!

Please ensure you have ```Homebrew```,```Xcodetools```, and ```Odin``` downloaded.

__DOWNLOAD XCODETOOLS VIA CLI(required for intel)__

```
xcode-select --install
```

or you can visit the app store to download xcodetools.

__DOWNLOAD HOMEBREW VIA CLI__

Copy and paste this command into your terminal:

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

__DOWNLOAD HOMEBREW VIA WEB__

If you have any issues, please go to https://brew.sh directly and then continue with the steps below.

__DOWNLOAD ODIN__
After homebrew has been installed, run:

```
cd
brew install odin
```

If you run into issues downloading Odin, visit the website directly for step by step instructions, this is needed so you can build your release as an executable.

``` https://odin-lang.org/docs/install/ ```

Open your terminal and create a directory/folder for FuzzyBuddyFarms to be stored into.

```
cd
mkdir FuzzyBuddyFarms
```

Now clone the repo into that directory/folder.

```
cd FuzzyBuddyFarms
git clone https://github.com/oooFruitSnacks/FuzzyBuddyFarms.git
```

Once the game has downloaded, you can build an executable version to launch as an "app". This way you don't have to open a terminal and type a command every time you want to launch the game. Run this command to build an executable. This will not build unless you have Odin installed as I mentioned earlier.

```
odin build . -out:FUZZYBUDDYFARMS -o:speed && odin build . -out:FUZZYBUDDYFARMS -o:speed -extra-linker-flags:"-rpath @executable_path"
```

Now you can either double click the icon and it will execute as a normal "app" would or you can launch it from the command line with this:

```
./Fuzzy_Buddy_Farms
```

## Windows (amd64 / intel or amd)

Please ensure you have ```MSVC``` compiler installed and ```Windows SDK```.

Download the ```Visual Studio Installer``` then select the workload titled ```Desktop development with C++```

__DOWNLOAD ODIN__

Once you have MSVC and SDK installed, install Odin either with a package manager:

```
winget install --id Odin.Odin
```

or you can grab a release from Odin directly and add the folder to your PATH. If you run into issues or want to know more information about Odin on Windows visit ``` https://odin-lang.org/docs/install/ ``` and follow the Windows guide.

Now run ```vcvarsall.bat x64``` from a blank developer powershell, you can search for the shortcut ```x64 Native Tools Command Prompt for VS2026``` in your ```Start Menu```. The normal windows powershell won't have the MSVC tools needed to successfully complete this operation.

Open a new command prompt and create a directory/folder for FuzzyBuddyFarms to be stored into.

```
cd
mkdir FuzzyBuddyFarms
```

Now clone the repo into that directory.

```
git clone https://github.com/ooofruitsnacks/FuzzyBuddyFarms.git
```

Now within the fuzzybuddyfarms directory/folder, to create an executable version of the game run:

```
odin build . -out:FuzzyBuddyFarms.exe -o:speed
```

Once it finishes, you'll find ```FuzzyBuddyFarms.exe``` sitting in the folder alongside the ```assets``` directory.

Double-click ```Fuzzybuddyfarms.exe``` to launch the game. 

You can also run the game from the command line with 

```
FuzzyBuddyFarms.exe
``` 

>[!WARNING]
>Don't be alarmed if windows also pops up a scary warning when you go to run the exe. This build isn't signed with a Windows code-signing certificate, Windows SmartScreen may show a "Windows protected your PC" warning the first time you launch it. Click **More info**, then **Run anyway** to proceed. This is expected for unsigned open-source software and is safe to bypass here.


## Linux (amd64/aarch64) 

__Debian/Ubuntu Distros__

Please ensure you have ```Odin``` and ```Clang``` downloaded, along with a few system libraries needed for linking.

__DOWNLOAD DEPENDENCIES__

Open a new terminal and run:

```
sudo apt update
sudo apt install -y clang libx11-dev libxrandr-dev libxinerama-dev libxcursor-dev libxi-dev libgl1-mesa-dev libasound2-dev
```

__DOWNLOAD ODIN__

Download the amd64 linux binary from Odin's releases page, extract it and add to your PATH with this command:

```
cd ~
curl -L -o odin.zip https://github.com/odin-lang/Odin/releases/latest/download/odin-linux-amd64-nightly.zip
unzip odin.zip -d odin
echo 'export PATH="$HOME/odin:$PATH"' >> ~/.bashrc
source ~/.bashrc
odin version
```

Please visit ``` https://odin-lang.org/docs/install/ ``` to install the Odin language or build it from source, this is needed so you can build your release as an executable.


Now open your terminal to create a directory/folder for FuzzyBuddyFarms to be stored into.

```
cd
mkdir fuzzybuddyfarms
```

Now run:

```
cd fuzzybuddyfarms
git clone https://github.com/oooFruitSnacks/FuzzyBuddyFarms.git
```

After the game has finished cloning into the directory, run:

```
odin build . -out:FuzzyBuddyFarms -o:speed
```

Once it finishes, you'll find an executable named ```FuzzyBuddyFarms``` in the folder alongside the ```assets``` directory. You can launch it directly from the terminal using:

```
chmod +x FuzzyBuddyFarms
./FuzzyBuddyFarms

```

Or make it executable from your file manager by right-clicking it → Properties → Permissions → "Allow executing file as program" (steps vary slightly by desktop environment), so you can double-click to launch the program.

__Fedora Distros__

work in progress

dnf install clang

## Linux (arm64/aarch64)

__Raspberry Pi 3/4/5/400 supported__

First confirm the OS you are running is a 64bit version with:

```
uname -m
```

If ```aarch64``` is printed back you are good to move onto the next step, if ```armv7l``` is returned then you are using a 32bit OS and you will need to reinstall the 64bit image. You can also target linux_arm32 instead with the flag ```-target=linux_arm32``` to try and cross compile but cross compilation can be finicky with Odin.

Install Clang and system libraries

```
sudo apt update
sudo apt install -y git clang \
  libx11-dev libxrandr-dev libxinerama-dev \
  libxcursor-dev libxi-dev libgl1-mesa-dev libasound2-dev
```

__INSTALL ODIN__

Install the linux arm64 release from Odin via command line:

```
cd ~
curl -L -o odin.zip https://github.com/odin-lang/Odin/releases/latest/download/odin-linux-arm64-nightly.zip
unzip odin.zip -d odin
echo 'export PATH="$HOME/odin:$PATH"' >> ~/.bashrc
source ~/.bashrc
odin version
```

or 

Please visit ``` https://odin-lang.org/docs/install/ ``` to install the Odin language if you have any issues.

If there are no amr64 releases available, build the compiler from source with:

```
sudo apt install -y llvm llvm-dev git-lfs
git clone https://github.com/odin-lang/Odin
cd Odin
git lfs install
git lfs pull
make release-native
echo 'export PATH="$HOME/Odin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

If your ```LLVM``` is outdated please update to the latest release, Odin supports versions 17-22. Please be aware this will take some time to update on Pi hardware so if you don't see anything happen or update for awhile DO NOT START BUTTON MASHING thank you.

Once that has all been installed, run:

```
cd FuzzyBuddyFarms
git clone https://github.com/oooFruitSnacks/FuzzyBuddyFarms.git
```

Now build an executable:

```
odin build . -out:Fuzzy_Buddy_Farms -o:speed
```
__No target flag is needed when building on a Raspberry Pi, Odin will default to the host architecture.__

Now run:

```
chmod +x Fuzzy_Buddy_Farms
./Fuzzy_Buddy_Farms
```

If it fails to run, install the runtime counterparts and then try again:

```
sudo apt install -y libx11-6 libxrandr2 libxinerama1 libxcursor1 libxi6 libgl1 libasound2t64
```

Alternatively if that doesn't work try:

```
MESA_GL_VERSION_OVERRIDE=3.3 ./Fuzzy_Buddy_Farms
```

or 

>[!WARNING]
>THIS METHOD IS VERY SLOW AND BUGGY BUT IT CAN BE USED TO CONFIRM YOU HAVE EVERYTHING INSTALLED PROPERLY TO RUN THE GAME

```
LIBGL_ALWAYS_SOFTWARE=1 ./Fuzzy_Buddy_Farms
```

# License

FuzzyBuddyFarms is licensed under the [GNU General Public License v2.0](LICENSE).

This means you're free to run, study, modify, and redistribute the source code — but any distributed modified versions must also be licensed under GPLv2 and made available in source form. See the [LICENSE](LICENSE) file for the full terms.

# Security Policy

Found a security vulnerability? Please __DON'T__ open a public issue for it — see [SECURITY.md](SECURITY.md) for how to report it responsibly.


Enjoy the game!






