# Welcome to Honeyville! :honey_pot: :tada: :honeybee:

Please go to the Wiki section for a complete guide of the game with tips, key binds, easter eggs, and information on the story-line. A lot of time and passion has gone into this project. I hope you enjoy it! :tada:

I'm the only person building this game so please be patient lol. I created FuzzyBuddyFarms because I wanted to learn Odin and because I wanted to try to build a real video game. My approach is a little different compared to other conventional video games. Everything is rendered and drawn using Raylib with vector math. This was done intentionally so anyone can play this game on any machine. You can run this game on pretty much any hardware from the past 2 decades.

https://github.com/user-attachments/assets/7fbb42ac-bae3-456c-bd60-c6c6c5f8df02

## Table of Contents

- [How to play](#how-to-play-honeybee)
- [Download](#download-honeybee)
- [Verify SHA256 Fingerprint](#verify-release-checksum)
  - [Apple Warning bypass](#apple-warning-bypass)
- [Build From Source](#build-from-source)
  - [macOS (Silicon/arm64/Intel/amd64)](#macos-siliconarm64intelamd64)
  - [Windows (amd64 / intel or amd)](#windows-amd64--intel-or-amd)
  - [Linux](#linux)
    - [Linux (amd64/aarch64)](#linux-amd64aarch64)
    - [Linux (arm64/aarch64)](#linux-arm64aarch64)
- [License](#license)
- [Security Policy](#security-policy)

## Linux Quick Jump T.O.C.

| Distribution | Jump to |
|---|---|
| Debian, Ubuntu, Kubuntu, Pop!_OS, Mint | [Debian / Ubuntu family](#debian--ubuntu-family) |
| Fedora, Nobara | [Fedora](#fedora) |
| Arch, EndeavourOS | [Arch Linux](#arch-linux) |
| Manjaro | [Manjaro](#manjaro) |
| Gentoo | [Gentoo](#gentoo) |
| SteamOS / Steam Deck | [SteamOS](#steamos--steam-deck) |
| Raspberry Pi OS | [Raspberry Pi](#linux-arm64aarch64) |

## How to play :honeybee:

>[!TIP]
>Use your starting money to purchase a bee hive and some flower seeds at the market. 

You spawn into Honeyville with a small plot of land to get started. The starting plot of land is yours to maintain and grow into a bee farm, head to the market and purchase upgrades for your bee farm like bee hives, flowers, trees, and queen bee upgrades. Strategize the best business model for your farm just like real life. Each NPC will purchase honey at different rates, if you need some quick money then sell to whoever but try to remember who pays the most. You can also go to the market or the bank to sell your honey. Keep in mind that different seasons, weather cycles and day/night cycles all have an effect on your honey production and honey value. Honey can be produced from bee hives on your land plots or you can purchase the bee factory to produce honey at a steady constant rate no matter the season, weather or day/night cycle. Make sure to visit the soccer field, race track, fishing pond, or the park for mini games and more!  

# Download :honeybee:

>[!NOTE]
>FuzzyBuddyFarms will be available on steam as well!

| Platform | Download | Distro |
|---|---|---|
| Windows (64bit / Intel or AMD) | `Fuzzy_Buddy_Farms-windows-amd64.zip` | n/a |
| macOS (Apple Silicon / M series) | `Fuzzy_Buddy_Farms-macos-arm64.zip` | n/a |
| macOS (Intel) | `Fuzzy_Buddy_Farms-macos-amd64.zip` | n/a |
| Linux (64bit / Intel or AMD) | `Fuzzy_Buddy_Farms-linux-amd64.zip` | Arch, Fedora, Gentoo, Manjaro, Kubuntu, SteamOS |
| Linux ARM64 | `Fuzzy_Buddy_Farms-linux-arm64.zip` | Ubuntu, Fedora, Nobara, RaspberryPiOS - Trixie |
| Linux ARM64 - RaspberryPi | `Fuzzy_Buddy_Farms-raspberrypi-arm64` | RaspberryPiOS (Bookworm & Trixie - optimized for Bookworm builds with outdated deps/packages. Trixie can run `Fuzzy_Buddy_Farms-linux-arm64.zip` as well. )

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

Now clone the repo.

```
git clone https://github.com/oooFruitSnacks/FuzzyBuddyFarms.git
```

Once the game has downloaded, you can build an executable version to launch as an "app". This way you don't have to open a terminal and type a command every time you want to launch the game. Run this command to build an executable. This will not build unless you have Odin installed as I mentioned earlier.

```
cd FuzzyBuddyFarms
odin build . -out:Fuzzy_Buddy_Farms -o:speed && odin build . -out:Fuzzy_Buddy_Farms -o:speed -extra-linker-flags:"-rpath @executable_path"
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

Now clone the repo.

```
git clone https://github.com/ooofruitsnacks/FuzzyBuddyFarms.git
cd fuzzybuddyfarms
```

Now within the fuzzybuddyfarms directory/folder, to create an executable version of the game run:

```
odin build . -out:Fuzzy_Buddy_Farms.exe -o:speed
```

Once it finishes, you'll find ```Fuzzy_Buddy_Farms.exe``` sitting in the folder alongside the ```assets``` directory.

Double-click ```Fuzzy_Buddy_Farms.exe``` to launch the game. 

You can also run the game from the command line with 

```
Fuzzy_Buddy_Farms.exe
``` 

>[!WARNING]
>Don't be alarmed if windows also pops up a scary warning when you go to run the exe. This build isn't signed with a Windows code-signing certificate, Windows SmartScreen may show a "Windows protected your PC" warning the first time you launch it. Click **More info**, then **Run anyway** to proceed. This is expected for unsigned open-source software and is safe to bypass here.


## Linux 

__Pick your desired distro__

| Distribution | Jump to |
|---|---|
| Debian, Ubuntu, Kubuntu, Pop!_OS, Mint | [Debian / Ubuntu family](#debian--ubuntu-family) |
| Fedora, Nobara | [Fedora](#fedora) |
| Arch, EndeavourOS | [Arch Linux](#arch-linux) |
| Manjaro | [Manjaro](#manjaro) |
| Gentoo | [Gentoo](#gentoo) |
| SteamOS / Steam Deck | [SteamOS](#steamos--steam-deck) |
| Raspberry Pi OS | [Raspberry Pi](#linux-arm64aarch64) |

### Linux troubleshooting (all distributions)

**`error while loading shared libraries: libXcursor.so.1`** — runtime libraries are missing. Install the runtime (non-`-dev`) packages for your distro.

**`Permission denied`** — run `chmod +x Fuzzy_Buddy_Farms` or the command with a leading `sudo`.

**Game can't find assets** — always launch from inside the repo folder, so `assets/` sits next to the binary.

**`odin: command not found`** — your `PATH` change didn't take. Run `source ~/.bashrc`, or `source ~/.zshrc` if you use zsh.

**`GLXBadFBConfig` / `Failed to create context`** — your GPU doesn't advertise OpenGL 3.3. Common on Raspberry Pi and very old integrated graphics. See the [Raspberry Pi](#linux-arm64aarch64) section for the `MESA_GL_VERSION_OVERRIDE=3.3` workaround.

| Purpose |	Debian/Ubuntu	| Fedora |	Arch/Manjaro	| Gentoo |
| ------- | ------------- | ------ | -------------- | ------ |
| X11 core | libx11-dev	| libX11-devel	| libx11	| x11-libs/libX11 |
| RandR	|libxrandr-dev	| libXrandr-devel	| libxrandr	| x11-libs/libXrandr |
| Xinerama	| libxinerama-dev	libXinerama-devel	libxinerama	x11-libs/libXinerama
| Cursor	| libxcursor-dev	| libXcursor-devel	| libxcursor	| x11-libs/libXcursor |
| Input	| libxi-dev	libXi-devel	| libxi	| x11-libs/libXi |
| OpenGL	| libgl1-mesa-dev	| mesa-libGL-devel	| mesa	| media-libs/mesa |
| GLU	| libglu1-mesa-dev	| mesa-libGLU-devel	| glu	| media-libs/glu |
| ALSA audio	| libasound2-dev	| alsa-lib-devel	| alsa-lib	| media-libs/alsa-lib |
| Clang	| clang	| clang	| clang	| sys-devel/clang |

## Linux (amd64/aarch64)

### Debian / Ubuntu Family

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


Now run:

```
git clone https://github.com/oooFruitSnacks/FuzzyBuddyFarms.git
cd FuzzyBuddyFarms

```

After the game has finished cloning into the directory, run:

```
odin build . -out:Fuzzy_Buddy_Farms -o:speed
```

Once it finishes, you'll find an executable named ```Fuzzy_Buddy_Farms``` in the folder alongside the ```assets``` directory. You can launch it directly from the terminal using:

```
chmod +x Fuzzy_Buddy_Farms
./Fuzzy_Buddy_Farms

```

Or make it executable from your file manager by right-clicking it → Properties → Permissions → "Allow executing file as program" (steps vary slightly by desktop environment), so you can double-click to launch the program.


## Linux (arm64/aarch64)

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

__DOWNLOAD ODIN__

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
git clone https://github.com/oooFruitSnacks/FuzzyBuddyFarms.git
cd FuzzyBuddyFarms
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

### Fedora

Tested on Fedora 42+. Also applies to **Nobara**.

__1. INSTALL DEPENDENCIES__

```
sudo dnf install -y git clang
libX11-devel libXrandr-devel libXinerama-devel
libXcursor-devel libXi-devel
mesa-libGL-devel mesa-libGLU-devel alsa-lib-devel
```

Fedora uses `-devel` suffixes and capitalized X11 names (`libX11-devel`, not `libx11-dev`) — the single most common mistake when adapting Debian instructions.

Shortcut — this pulls in most X11 development headers at once:

```
sudo dnf install -y git clang @development-tools
sudo dnf install -y mesa-libGL-devel alsa-lib-devel libXrandr-devel
libXinerama-devel libXcursor-devel libXi-devel libX11-devel
```

__2. DOWNLOAD ODIN__

```
cd ~
curl -L -o odin.zip https://github.com/odin-lang/Odin/releases/latest/download/odin-linux-amd64-nightly.zip
unzip odin.zip -d odin
echo 'export PATH="HOME/odin:PATH"' >> ~/.bashrc
source ~/.bashrc
odin version
```

__3. CLONE AND BUILD__

```
cd ~
git clone https://github.com/oooFruitSnacks/FuzzyBuddyFarms.git
cd FuzzyBuddyFarms
odin build . -out:Fuzzy_Buddy_Farms -o:speed
chmod +x Fuzzy_Buddy_Farms
./Fuzzy_Buddy_Farms
```

### Arch Linux

Also applies to **EndeavourOS**, **CachyOS**, and other Arch derivatives.

__1. INSTALL DEPENDENCIES__

```
sudo pacman -Syu --needed git base-devel clang llvm
libx11 libxrandr libxinerama libxcursor libxi
mesa glu alsa-lib
```

Arch doesn't split packages into runtime and `-dev` halves — headers ship with the main package so there are no `-devel` names to hunt for. Note `mesa` provides the OpenGL headers and `glu` is separate.

__2. INSTALL ODIN__

**Option A — AUR (recommended):** the `odin-git` package builds the compiler from source [^e8b3c9]:

```
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/odin-git.git
cd odin-git
makepkg -si
```

Or with an AUR helper:

```
yay -S odin-git
```

> [!WARNING]
> AUR packages are user-maintained and occasionally break — `odin-git` has had periods where a patch failed to apply [^e8b3c9]. If `makepkg` errors out, check the [AUR comments](https://aur.archlinux.org/packages/odin-git) or use Option B.

**Option B — official binary release:**

```
cd ~
curl -L -o odin.zip https://github.com/odin-lang/Odin/releases/latest/download/odin-linux-amd64-nightly.zip
unzip odin.zip -d odin
echo 'export PATH=":HOME/odin:PATH"' >> ~/.bashrc
source ~/.bashrc
odin version
```

__3. CLONE AND BUILD__

```
cd ~
git clone https://github.com/oooFruitSnacks/FuzzyBuddyFarms.git
cd FuzzyBuddyFarms
odin build . -out:Fuzzy_Buddy_Farms -o:speed
chmod +x Fuzzy_Buddy_Farms
./Fuzzy_Buddy_Farms
```

### Manjaro

Manjaro is Arch-based so the packages are identical but Manjaro holds updates back on its own schedule so always sync fully first.

__1. INSTALL DEPENDENCIES__

```
sudo pacman -Syu --needed git base-devel clang llvm
libx11 libxrandr libxinerama libxcursor libxi
mesa glu alsa-lib
```


> [!WARNING]
> Never use `pacman -Sy package` alone on Manjaro or Arch — partial upgrades cause broken library versions. Always `-Syu`.

__2. INSTALL ODIN__

Manjaro ships `pamac`, which can build AUR packages once enabled:

```
pamac build odin-git
```

If AUR support is off, enable it in **Add/Remove Software → Preferences → Third Party → AUR support**, or just use the binary release method from the Arch section above.

__3. CLONE AND BUILD__

Identical to Arch — Follow the [Arch Linux](#arch-linux) section above.

### Kubuntu

Kubuntu is Ubuntu with the KDE Plasma desktop. **The build steps are byte-for-byte identical to the Debian/Ubuntu guide** — same `apt`, same package names, same everything.

Follow the [Debian / Ubuntu family](#debian--ubuntu-family) section above.

The only difference is launching by double-click: in **Dolphin** (KDE's file manager), right-click `Fuzzy_Buddy_Farms` → **Properties** → **Permissions** tab → check **Is executable**. Then double-click and choose **Execute**.

The same applies to **Xubuntu**, **Lubuntu**, **Ubuntu Budgie**, and **Linux Mint** — desktop environment doesn't affect the build.

### Gentoo

Gentoo builds everything from source, so most dependencies may already be present. Gentoo has no `-dev` split — headers always install with the library.

__1. INSTALL DEPENDENCIES__

```
sudo emerge --ask --noreplace
dev-vcs/git
sys-devel/clang
x11-libs/libX11
x11-libs/libXrandr
x11-libs/libXinerama
x11-libs/libXcursor
x11-libs/libXi
media-libs/mesa
media-libs/glu
media-libs/alsa-lib
```

`--noreplace` skips anything already installed. Add `--ask` to review the plan before committing.

Make sure Mesa is built with OpenGL support in `/etc/portage/make.conf`:

```
USE="X opengl"
VIDEO_CARDS="amdgpu radeonsi"
```
or nvidia, intel, etc.


Then rebuild anything affected:

```
sudo emerge --ask --changed-use --deep @world
```

__2. INSTALL ODIN__

Odin isn't in the official Portage tree. Use the binary release:

```
cd ~
curl -L -o odin.zip https://github.com/odin-lang/Odin/releases/latest/download/odin-linux-amd64-nightly.zip
unzip odin.zip -d odin
echo 'export PATH=":HOME/odin:PATH"' >> ~/.bashrc
source ~/.bashrc
odin version
```

Or build from source (Odin needs LLVM 17–22):

```
sudo emerge --ask sys-devel/llvm dev-vcs/git-lfs
git clone https://github.com/odin-lang/Odin
cd Odin
git lfs install && git lfs pull
make release-native
echo 'export PATH=":HOME/Odin:PATH"' >> ~/.bashrc
source ~/.bashrc
```

If your default LLVM is outside 17–22, point the build at a specific slot:

```
LLVM_CONFIG=/usr/lib/llvm/18/bin/llvm-config make release-native
```

__3. CLONE AND BUILD__

```
cd ~
git clone https://github.com/oooFruitSnacks/FuzzyBuddyFarms.git
cd FuzzyBuddyFarms
odin build . -out:Fuzzy_Buddy_Farms -o:speed
chmod +x Fuzzy_Buddy_Farms
./Fuzzy_Buddy_Farms
```

### SteamOS / Steam Deck

> [!IMPORTANT]
> SteamOS uses an immutable (read-only) root filesystem, and system changes are **wiped by every SteamOS update**. Method A below avoids this entirely and is strongly recommended.

First, switch to **Desktop Mode** (Steam button → Power → Switch to Desktop) and open **Konsole**.

Set a password if you've never done so — `sudo` won't work without one: ```passwd```

---

#### Method A — Distrobox (recommended, survives updates)

Distrobox runs a full Arch container with your home directory shared, so you can install build tools without touching SteamOS itself [^ecd868][^02fc7c]. Nothing breaks on update.

```
distrobox create --name fuzzydev --image archlinux:latest
distrobox enter fuzzydev
```

Now inside the container:

```
sudo pacman -Syu --needed git base-devel clang llvm
libx11 libxrandr libxinerama libxcursor libxi
mesa glu alsa-lib
cd ~
curl -L -o odin.zip https://github.com/odin-lang/Odin/releases/latest/download/odin-linux-amd64-nightly.zip
unzip odin.zip -d odin
export PATH=":HOME/odin:PATH"
git clone https://github.com/oooFruitSnacks/FuzzyBuddyFarms.git
cd FuzzyBuddyFarms
odin build . -out:Fuzzy_Buddy_Farms -o:speed
```

Type `exit` to leave the container. Because Distrobox shares your home directory, the binary is available directly from SteamOS:

```
cd ~/FuzzyBuddyFarms
chmod +x Fuzzy_Buddy_Farms
./Fuzzy_Buddy_Farms
```

---

#### Method B — Unlock the filesystem (changes lost on update)

```
sudo steamos-devmode enable
```

This helper disables read-only mode, populates the pacman keyring, restores headers stripped from the shipping image, and installs base development tools [^558924].

If `steamos-devmode` isn't available or errors, do it manually [^0b7f0f]:

```
sudo steamos-readonly disable
sudo pacman-key --init
sudo pacman-key --populate archlinux
sudo pacman -Syu
```

Then install dependencies and Odin exactly as in the [Arch Linux](#arch-linux) section.

When finished, re-enable protection:

```
sudo steamos-readonly enable
```

> [!WARNING]
> Everything installed this way is erased by the next SteamOS update [^0bde30]. `steamos-devmode enable` has also been reported to fail with read-only errors on some SteamOS versions [^6ce365]. If you hit that, use Method A.

---

#### Adding the game to your Steam library

Steam → Games → Add a Non-Steam Game to My Library → Browse

Select `~/FuzzyBuddyFarms/Fuzzy_Buddy_Farms`. Then in its Properties, set **Start In** to `/home/deck/FuzzyBuddyFarms` so the game finds its `assets` folder. It'll now launch from Game Mode.

> [!NOTE]
> The Steam Deck's AMD GPU fully supports OpenGL 3.3, so no `MESA_GL_VERSION_OVERRIDE` workaround is needed — that's only required on Raspberry Pi hardware.

### Linux troubleshooting (all distributions)

**`error while loading shared libraries: libXcursor.so.1`** — runtime libraries are missing. Install the runtime (non-`-dev`) packages for your distro.

**`Permission denied`** — run `chmod +x Fuzzy_Buddy_Farms`.

**Game can't find assets** — always launch from inside the repo folder, so `assets/` sits next to the binary.

**`odin: command not found`** — your `PATH` change didn't take. Run `source ~/.bashrc`, or `source ~/.zshrc` if you use zsh.

**`GLXBadFBConfig` / `Failed to create context`** — your GPU doesn't advertise OpenGL 3.3. Common on Raspberry Pi and very old integrated graphics. See the [Raspberry Pi](#linux-arm64aarch64) section for the `MESA_GL_VERSION_OVERRIDE=3.3` workaround.

# License

FuzzyBuddyFarms is licensed under the [GNU General Public License v2.0](LICENSE).

This means you're free to run, study, modify, and redistribute the source code — but any distributed modified versions must also be licensed under GPLv2 and made available in source form. See the [LICENSE](LICENSE) file for the full terms.

# Security Policy

Found a security vulnerability? Please __DON'T__ open a public issue for it — see [SECURITY.md](SECURITY.md) for how to report it responsibly.

Enjoy the game!






