<div align="center">

# 🍯 Welcome to Honeyville! 🐝

**Bee Farming Simulator built in Odin + Raylib**

[![License: GPL v2](https://img.shields.io/badge/License-GPL%20v2-purple.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-Windows%20%7C%20macOS%20%7C%20Linux%20%7C%20Raspberry%20Pi-blue)](#-download)
![GitHub Repo stars](https://img.shields.io/github/stars/oooFruitSnacks/FuzzyBuddyFarms)

![GitHub Downloads (all assets, all releases)](https://img.shields.io/github/downloads/oooFruitSnacks/FuzzyBuddyFarms/total)
![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/oooFruitSnacks/FuzzyBuddyFarms)
![GitHub commit activity](https://img.shields.io/github/commit-activity/w/oooFruitSnacks/FuzzyBuddyFarms)

![Platform](https://img.shields.io/badge/build-passing-brightgreen?style=for-the-badge)

</div>

> [!TIP]
> Please visit the [**Wiki**](wiki) section for a complete guide of the game with tips, key binds, easter eggs, and information on the story-line. A lot of time and passion has gone into this project. I hope you enjoy it! 🎉

https://github.com/user-attachments/assets/7fbb42ac-bae3-456c-bd60-c6c6c5f8df02

---
<div align="center">

__Mac OS \ Windows__

![Badge](https://img.shields.io/badge/macOS(intel)-yellow)
![Badge](https://img.shields.io/badge/macOS(silicon/m_series)-green)
![Badge](https://img.shields.io/badge/Windows-green)

__Linux__

![Badge](https://img.shields.io/badge/Ubuntu-green)
![Badge](https://img.shields.io/badge/Kubuntu-green)
![Badge](https://img.shields.io/badge/Debian_11-yellow)
![Badge](https://img.shields.io/badge/Debian_12-orange)
![Badge](https://img.shields.io/badge/Debian_13+-green)
![Badge](https://img.shields.io/badge/Fedora-green)
![Badge](https://img.shields.io/badge/Nobara-green)
![Badge](https://img.shields.io/badge/Arch-green)
![Badge](https://img.shields.io/badge/Manjaro-green)
![Badge](https://img.shields.io/badge/Gentoo-green)
![Badge](https://img.shields.io/badge/SteamOS-green)

![Badge](https://img.shields.io/badge/Raspberry_Pi_OS-green)
![Badge](https://img.shields.io/badge/Raspberryi_Pi_OS|32bit-red)
![Badge](https://img.shields.io/badge/NIXos-teal)
![Badge](https://img.shields.io/badge/Alpine-teal)
![Badge](https://img.shields.io/badge/Arduino-pink)

__COLOR CODING INDEX__

![Badge](https://img.shields.io/badge/%20Maintained%20-green)
![Badge](https://img.shields.io/badge/Not%20Maintained%20-yellow)
![Badge](https://img.shields.io/badge/Under%20Work%20-orange)
![Badge](https://img.shields.io/badge/Not%20Supported%20-red)
![Badge](https://img.shields.io/badge/Future%20Support%20-pink)
![Badge](https://img.shields.io/badge/Newly%20Supported%20-teal)

</div>

<div align="center">

## 📖 Table of Contents

<table>
<tr><td width="50%" valign="top">

**Getting Started**

| | Section |
|:--:|---|
| 🎮 | [How to Play](#-how-to-play) |
| 📥 | [Download](#-download) |
| 🔐 | [Verify SHA256 Fingerprint](#-verify-release-checksum) |
| 🍎 | [Apple Warning Bypass](#-apple-warning-bypass) |

</td><td width="50%" valign="top">

**Building From Source**

| | Section |
|:--:|---|
| 🛠️ | [Build From Source](#️-build-from-source) |
| 🐧 | [Linux Build Guides](#-linux) |
| 📜 | [License](#-license) |
| 🛡️ | [Security Policy](#️-security-policy) |

</td></tr>
</table>

<details open>
<summary><b>🔧 Build From Source — Full Index</b></summary>

<br>

| Platform | Architecture | Guide |
|:--|:--|:--|
|  **macOS** | Apple Silicon / Intel | [macOS Build Guide](#-macos-apple-silicon--intel) |
|  **Windows** | amd64 (Intel / AMD) | [Windows Build Guide](#-windows-amd64) |
|  **Linux** | amd64 / arm64 | [Linux Overview](#-linux) |

</details>

<details open>
<summary><b>🐧 Linux — Quick Jump by Distribution</b></summary>

<br>

| Distribution Family | Includes | Guide |
|:--|:--|:--|
| 🌀 **Debian / Ubuntu** | Debian, Ubuntu, Kubuntu, Xubuntu, Lubuntu, Pop!_OS, Mint, Ubuntu Budgie | [Jump →](#-debian--ubuntu-family) |
| 🎩 **Fedora** | Fedora 42+, Nobara | [Jump →](#-fedora) |
| 🏹 **Arch Linux** | Arch, EndeavourOS, CachyOS | [Jump →](#-arch-linux) |
| 🟢 **Manjaro** | Manjaro | [Jump →](#-manjaro) |
| 🐮 **Gentoo** | Gentoo | [Jump →](#-gentoo) |
| 🎮 **SteamOS** | SteamOS, Steam Deck | [Jump →](#-steamos--steam-deck) |
| 🍓 **Raspberry Pi OS** | Bookworm, Trixie | [Jump →](#-raspberry-pi-os) |
| 🔩 **Generic arm64** | Any aarch64 Linux | [Jump →](#-linux-arm64--aarch64) |
| ❓ **Troubleshooting** | All distributions | [Jump →](#-linux-troubleshooting-all-distributions) |

</details>

</div>

### Other Distributions

Not seeing your distro? The game builds anywhere you can get
Odin, Clang, X11 headers, Mesa, and ALSA. Map the
[dependency reference table](#linux) to your package manager:

| Distro | Package Manager | Naming Convention |
|:--|:--|:--|
| openSUSE | `zypper install` | `-devel` (like Fedora) |
| Void | `xbps-install` | `-devel` |
| Solus | `eopkg install` | `-devel` |
| RHEL / Rocky / Alma | `dnf install` | `-devel`, needs EPEL |
| NixOS | `nix-shell` | see flake below |

**Immutable systems** (Silverblue, Kinoite, Bazzite, SteamOS) —
use Distrobox or `toolbox` rather than layering packages.
See [Method A](#method-a--distrobox-recommended).

> [!IMPORTANT]
> **musl libc distros** (Alpine, postmarketOS, Void-musl) are not
> supported. The prebuilt releases are glibc-linked and will not
> run. Building from source requires rebuilding Raylib against musl.

> [!NOTE]
> **Minimum glibc:** 2.36 for `raspberrypi-arm64`, 2.39 for the
> generic `linux-arm64` build. Check yours with `ldd --version`.
> Debian 11, Ubuntu 20.04, and RHEL 8 are below both thresholds —
> build from source on those.


---

## 🎮 How to Play

> [!TIP]
> Use your starting money to purchase a bee hive and some flower seeds at the market.

You spawn into Honeyville with a small plot of land to get started. The starting plot of land is yours to maintain and grow into a bee farm, head to the market and purchase upgrades for your bee farm like bee hives, flowers, trees, and queen bee upgrades.

Strategize the best business model for your farm just like real life. Each NPC will purchase honey at different rates, if you need some quick money then sell to whoever but try to remember who pays the most. You can also go to the market or the bank to sell your honey.

Keep in mind that different **seasons**, **weather cycles** and **day/night cycles** all have an effect on your honey production and honey value. Honey can be produced from bee hives on your land plots or you can purchase the bee factory to produce honey at a steady constant rate no matter the season, weather or day/night cycle.

Make sure to visit the **soccer field**, **race track**, **fishing pond**, or the **park** for mini games and more!

<div align="right"><a href="#-table-of-contents">⬆ Back to top</a></div>

---

## 📥 Download

> [!NOTE]
> FuzzyBuddyFarms will be available on Steam as well!

### 🖥️ Desktop — Windows & macOS

| Platform | Architecture | Download File |
|:--|:--|:--|
|  **Windows** | 64-bit (Intel / AMD) | `Fuzzy_Buddy_Farms-windows-amd64.zip` |
|  **macOS** | Apple Silicon (M-series) | `Fuzzy_Buddy_Farms-macos-arm64.zip` |
|  **macOS** | Intel | `Fuzzy_Buddy_Farms-macos-amd64.zip` |

### 🐧 Linux — Pick by Distribution

| Download File | Architecture | Supported Distributions | Notes |
|:--|:--|:--|:--|
| `Fuzzy_Buddy_Farms-linux-amd64.zip` | **x86_64**<br>(Intel / AMD) | Arch • Fedora • Gentoo • Manjaro • Kubuntu • SteamOS | ✅ Standard desktop Linux build |
| `Fuzzy_Buddy_Farms-linux-arm64.zip` | **aarch64** | Ubuntu • Fedora • Nobara • Raspberry Pi OS *(Trixie only)* | ⚠️ Requires **glibc 2.39+** |
| `Fuzzy_Buddy_Farms-raspberrypi-arm64.zip` | **aarch64** | Raspberry Pi OS *(Bookworm **and** Trixie)* | 🍓 Built against **glibc 2.36** — widest Pi compatibility |

<details>
<summary><b> Which Raspberry Pi build should you choose?</b></summary>

<br>

| Your Pi OS Version | Recommended Download | Why |
|:--|:--|:--|
| **Bookworm** (Debian 12 based, Oct 2023 – Jun 2026) | `raspberrypi-arm64` | Bookworm ships glibc **2.36**. The generic arm64 build needs 2.39 and **will not launch**. |
| **Trixie** (Debian 13 based, Jun 2026+) | Either works | `raspberrypi-arm64` is still the safest pick. |
| **Not sure?** | `raspberrypi-arm64` | Runs on both. When in doubt, grab this one. |

Check your version with:

```bash
cat /etc/os-release
```

</details>

### Flatpak

Download `Fuzzy_Buddy_Farms-x86_64.flatpak` (or `aarch64`) from
[Releases](https://github.com/ooofruitsnacks/FuzzyBuddyFarms/releases):

```bash
flatpak install --user Fuzzy_Buddy_Farms-x86_64.flatpak
flatpak run io.github.ooofruitsnacks.FuzzyBuddyFarms
```

**Flatpak solves nearly every gap from the "unsupported distros" list.** 

OpenSUSE, Void, Solus, Slackware, NixOS, RHEL 8, Alpine, and the Fedora variants all get covered because the runtime carries its own glibc and X11 stack. 32-bit ARM architecture is not supported. 


### 📦 How to Download

**Go to the Releases section of FuzzyBuddyFarms:**

<img width="376" height="153" alt="Releases section screenshot" src="https://github.com/user-attachments/assets/00a3d533-335c-4215-a335-7c946307e2f5" />

Click on the zip file for your hardware architecture and download that zip file.

> [!WARNING]
> It will flash a spooky warning message but don't be alarmed. This is just because it is not signed with a certificate — but good news! Everything is completely open source so you can verify everything yourself! Wow!

<div align="right"><a href="#-table-of-contents">⬆ Back to top</a></div>

---

## 🔐 Verify Release Checksum

Each release includes a `checksums.txt` file with SHA256 hashes for every zip. To verify your download hasn't been tampered with:

| OS | Command |
|:--|:--|
|  **macOS** /  **Linux** | `shasum -a 256 -c checksums.txt` |
|  **Windows** | `Get-FileHash .\Fuzzy_Buddy_Farms-windows-amd64.zip -Algorithm SHA256` |

**macOS / Linux** — open the directory where you have FuzzyBuddyFarms saved and run:

```bash
shasum -a 256 -c checksums.txt
```

**Windows** — open the directory where you have FuzzyBuddyFarms saved and run:

```powershell
Get-FileHash .\Fuzzy_Buddy_Farms-windows-amd64.zip -Algorithm SHA256
```

Compare the output against the matching line in `checksums.txt`.

<div align="right"><a href="#-table-of-contents">⬆ Back to top</a></div>

---

## 🍎 Apple Warning Bypass

As mentioned above, your OS will probably display a warning message when you try to execute the program. For Apple users this can be overridden with the steps below.

> [!NOTE]
> If you are not comfortable with this option, please download from Steam.

<table>
<tr><td width="60px" align="center"><b>1</b></td><td>

Close out of the spooky scary urgent warning message and locate **Privacy and Security**, about midway down in the main menu:

<img width="221" height="110" alt="Privacy and Security menu" src="https://github.com/user-attachments/assets/6878a18c-8777-4325-827c-fd9b6a8250c5" />

</td></tr>
<tr><td align="center"><b>2</b></td><td>

Scroll all the way down and find:

<img width="479" height="184" alt="Open Anyway button" src="https://github.com/user-attachments/assets/b4aa33c0-b0a1-43aa-9b72-91390c1b1771" />

</td></tr>
<tr><td align="center"><b>3</b></td><td>

Click **Open Anyway** and it will open another prompt window. Click **Open Anyway** again in the window and then relaunch FuzzyBuddyFarms. It will now open and run the game.

<img width="276" height="355" alt="Confirmation prompt" src="https://github.com/user-attachments/assets/66c7920c-e082-4e64-ad0b-41b2c09adca8" />

</td></tr>
</table>

<div align="right"><a href="#-table-of-contents">⬆ Back to top</a></div>

---

## 🛠️ Build From Source

If you don't trust pre-bundled packages or if you want to make your own changes to the source code to have a more unique bee farming experience, you can do so easily by building from source for your machine. Below is a full step-by-step guide to build from source. Enjoy :)

| Platform | Jump to Guide |
|:--|:--|
|  macOS (Silicon / arm64 / Intel / amd64) | [macOS](#-macos-apple-silicon--intel) |
|  Windows (amd64 / Intel or AMD) | [Windows](#-windows-amd64) |
|  Linux (all distributions) | [Linux](#-linux) |

---

### 🍎 macOS (Apple Silicon / Intel)

This step-by-step guide can be used for both M-series and Intel chip generations. If you run into any issues please report it under `Issues` so I can fix the guide.

If you don't use Steam and want to download it directly from GitHub, don't worry — it's very easy!

**Prerequisites:** `Homebrew`, `Xcode Tools`, and `Odin`

<details open>
<summary><b>Step 1 — Install Xcode Command Line Tools</b> <i>(required for Intel)</i></summary>

<br>

```bash
xcode-select --install
```

Or you can visit the App Store to download Xcode Tools.

</details>

<details open>
<summary><b>Step 2 — Install Homebrew</b></summary>

<br>

Copy and paste this command into your terminal:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

If you have any issues, please go to [brew.sh](https://brew.sh) directly and then continue with the steps below.

</details>

<details open>
<summary><b>Step 3 — Install Odin</b></summary>

<br>

After Homebrew has been installed, run:

```bash
cd
brew install odin
```

If you run into issues downloading Odin, visit [odin-lang.org/docs/install](https://odin-lang.org/docs/install/) directly for step-by-step instructions. This is needed so you can build your release as an executable.

</details>

<details open>
<summary><b>Step 4 — Clone and Build</b></summary>

<br>

```bash
git clone https://github.com/oooFruitSnacks/FuzzyBuddyFarms.git
cd FuzzyBuddyFarms
odin build . -out:Fuzzy_Buddy_Farms -o:speed && odin build . -out:Fuzzy_Buddy_Farms -o:speed -extra-linker-flags:"-rpath @executable_path"
```

Now you can either double-click the icon and it will execute as a normal "app" would, or you can launch it from the command line with:

```bash
./Fuzzy_Buddy_Farms
```

</details>

<div align="right"><a href="#-table-of-contents">⬆ Back to top</a></div>

---

### 🪟 Windows (amd64)

**Prerequisites:** `MSVC` compiler and `Windows SDK`

Download the **Visual Studio Installer** then select the workload titled **Desktop development with C++**.

<details open>
<summary><b>Step 1 — Install Odin</b></summary>

<br>

Once you have MSVC and SDK installed, install Odin either with a package manager:

```powershell
winget install --id Odin.Odin
```

Or you can grab a release from Odin directly and add the folder to your PATH. If you run into issues or want to know more information about Odin on Windows, visit [odin-lang.org/docs/install](https://odin-lang.org/docs/install/) and follow the Windows guide.

</details>

<details open>
<summary><b>Step 2 — Open the Correct Terminal</b></summary>

<br>

Run `vcvarsall.bat x64` from a blank developer PowerShell. You can search for the shortcut **x64 Native Tools Command Prompt for VS2026** in your **Start Menu**.

> [!IMPORTANT]
> The normal Windows PowerShell won't have the MSVC tools needed to successfully complete this operation.

</details>

<details open>
<summary><b>Step 3 — Clone and Build</b></summary>

<br>

```powershell
git clone https://github.com/ooofruitsnacks/FuzzyBuddyFarms.git
cd fuzzybuddyfarms
odin build . -out:Fuzzy_Buddy_Farms.exe -o:speed
```

Once it finishes, you'll find `Fuzzy_Buddy_Farms.exe` sitting in the folder alongside the `assets` directory.

Double-click `Fuzzy_Buddy_Farms.exe` to launch the game. You can also run the game from the command line with:

```powershell
Fuzzy_Buddy_Farms.exe
```

</details>

> [!WARNING]
> Don't be alarmed if Windows also pops up a scary warning when you go to run the exe. This build isn't signed with a Windows code-signing certificate, so Windows SmartScreen may show a **"Windows protected your PC"** warning the first time you launch it. Click **More info**, then **Run anyway** to proceed. This is expected for unsigned open-source software and is safe to bypass here.

<div align="right"><a href="#-table-of-contents">⬆ Back to top</a></div>

---

## 🐧 Linux

**Pick your desired distro:**

| Distribution Family | Includes | Guide |
|:--|:--|:--|
| 🌀 **Debian / Ubuntu** | Debian, Ubuntu, Kubuntu, Xubuntu, Lubuntu, Pop!_OS, Mint | [Jump →](#-debian--ubuntu-family) |
| 🎩 **Fedora** | Fedora 42+, Nobara | [Jump →](#-fedora) |
| 🏹 **Arch Linux** | Arch, EndeavourOS, CachyOS | [Jump →](#-arch-linux) |
| 🟢 **Manjaro** | Manjaro | [Jump →](#-manjaro) |
| 🐮 **Gentoo** | Gentoo | [Jump →](#-gentoo) |
| 🎮 **SteamOS** | SteamOS, Steam Deck | [Jump →](#-steamos--steam-deck) |
| 🍓 **Raspberry Pi OS** | Bookworm, Trixie | [Jump →](#-raspberry-pi-os) |
| 🔩 **Generic arm64** | Any aarch64 Linux | [Jump →](#-linux-arm64--aarch64) |

<details>
<summary><b>📋 Dependency Reference Table — All Distributions</b></summary>

<br>

| Purpose | Debian / Ubuntu | Fedora | Arch / Manjaro | Gentoo |
|:--|:--|:--|:--|:--|
| **X11 core** | `libx11-dev` | `libX11-devel` | `libx11` | `x11-libs/libX11` |
| **RandR** | `libxrandr-dev` | `libXrandr-devel` | `libxrandr` | `x11-libs/libXrandr` |
| **Xinerama** | `libxinerama-dev` | `libXinerama-devel` | `libxinerama` | `x11-libs/libXinerama` |
| **Cursor** | `libxcursor-dev` | `libXcursor-devel` | `libxcursor` | `x11-libs/libXcursor` |
| **Input** | `libxi-dev` | `libXi-devel` | `libxi` | `x11-libs/libXi` |
| **OpenGL** | `libgl1-mesa-dev` | `mesa-libGL-devel` | `mesa` | `media-libs/mesa` |
| **GLU** | `libglu1-mesa-dev` | `mesa-libGLU-devel` | `glu` | `media-libs/glu` |
| **ALSA audio** | `libasound2-dev` | `alsa-lib-devel` | `alsa-lib` | `media-libs/alsa-lib` |
| **Clang** | `clang` | `clang` | `clang` | `sys-devel/clang` |

</details>

---

### 🌀 Debian / Ubuntu Family

> Applies to **Debian**, **Ubuntu**, **Kubuntu**, **Xubuntu**, **Lubuntu**, **Ubuntu Budgie**, **Pop!_OS**, and **Linux Mint**. Desktop environment doesn't affect the build.

**Prerequisites:** `Odin`, `Clang`, and a few system libraries needed for linking.

<details open>
<summary><b>Step 1 — Install Dependencies</b></summary>

<br>

Open a new terminal and run:

```bash
sudo apt update
sudo apt install -y clang libx11-dev libxrandr-dev libxinerama-dev libxcursor-dev libxi-dev libgl1-mesa-dev libasound2-dev
```

</details>

<details open>
<summary><b>Step 2 — Install Odin</b></summary>

<br>

Download the amd64 Linux binary from Odin's releases page, extract it and add to your PATH:

```bash
cd ~
curl -L -o odin.zip https://github.com/odin-lang/Odin/releases/latest/download/odin-linux-amd64-nightly.zip
unzip odin.zip -d odin
echo 'export PATH="$HOME/odin:$PATH"' >> ~/.bashrc
source ~/.bashrc
odin version
```

Please visit [odin-lang.org/docs/install](https://odin-lang.org/docs/install/) to install the Odin language or build it from source. This is needed so you can build your release as an executable.

</details>

<details open>
<summary><b>Step 3 — Clone and Build</b></summary>

<br>

```bash
git clone https://github.com/oooFruitSnacks/FuzzyBuddyFarms.git
cd FuzzyBuddyFarms
odin build . -out:Fuzzy_Buddy_Farms -o:speed
```

Once it finishes, you'll find an executable named `Fuzzy_Buddy_Farms` in the folder alongside the `assets` directory. You can launch it directly from the terminal using:

```bash
chmod +x Fuzzy_Buddy_Farms
./Fuzzy_Buddy_Farms
```

</details>

> [!TIP]
> **Prefer double-clicking?** Make it executable from your file manager by right-clicking it → **Properties** → **Permissions** → **"Allow executing file as program"** (steps vary slightly by desktop environment).
>
> On **KDE / Kubuntu** using **Dolphin**: right-click `Fuzzy_Buddy_Farms` → **Properties** → **Permissions** tab → check **Is executable**. Then double-click and choose **Execute**.

<div align="right"><a href="#-linux">⬆ Back to Linux menu</a></div>

---

### 🎩 Fedora

> Tested on Fedora 42+. Also applies to **Nobara**.

<details open>
<summary><b>Step 1 — Install Dependencies</b></summary>

<br>

```bash
sudo dnf install -y git clang \
  libX11-devel libXrandr-devel libXinerama-devel \
  libXcursor-devel libXi-devel \
  mesa-libGL-devel mesa-libGLU-devel alsa-lib-devel
```

> [!IMPORTANT]
> Fedora uses `-devel` suffixes and **capitalized** X11 names (`libX11-devel`, not `libx11-dev`) — the single most common mistake when adapting Debian instructions.

**Shortcut** — this pulls in most X11 development headers at once:

```bash
sudo dnf install -y git clang @development-tools
sudo dnf install -y mesa-libGL-devel alsa-lib-devel libXrandr-devel \
  libXinerama-devel libXcursor-devel libXi-devel libX11-devel
```

</details>

<details open>
<summary><b>Step 2 — Install Odin</b></summary>

<br>

```bash
cd ~
curl -L -o odin.zip https://github.com/odin-lang/Odin/releases/latest/download/odin-linux-amd64-nightly.zip
unzip odin.zip -d odin
echo 'export PATH="$HOME/odin:$PATH"' >> ~/.bashrc
source ~/.bashrc
odin version
```

</details>

<details open>
<summary><b>Step 3 — Clone and Build</b></summary>

<br>

```bash
cd ~
git clone https://github.com/oooFruitSnacks/FuzzyBuddyFarms.git
cd FuzzyBuddyFarms
odin build . -out:Fuzzy_Buddy_Farms -o:speed
chmod +x Fuzzy_Buddy_Farms
./Fuzzy_Buddy_Farms
```

</details>

<div align="right"><a href="#-linux">⬆ Back to Linux menu</a></div>

---

### 🏹 Arch Linux

> Also applies to **EndeavourOS**, **CachyOS**, and other Arch derivatives.

<details open>
<summary><b>Step 1 — Install Dependencies</b></summary>

<br>

```bash
sudo pacman -Syu --needed git base-devel clang llvm \
  libx11 libxrandr libxinerama libxcursor libxi \
  mesa glu alsa-lib
```

> [!NOTE]
> Arch doesn't split packages into runtime and `-dev` halves — headers ship with the main package so there are no `-devel` names to hunt for. Note `mesa` provides the OpenGL headers and `glu` is separate.

</details>

<details open>
<summary><b>Step 2 — Install Odin</b></summary>

<br>

**Option A — AUR (recommended)**

The `odin-git` package builds the compiler from source:

```bash
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/odin-git.git
cd odin-git
makepkg -si
```

Or with an AUR helper:

```bash
yay -S odin-git
```

> [!WARNING]
> AUR packages are user-maintained and occasionally break — `odin-git` has had periods where a patch failed to apply. If `makepkg` errors out, check the [AUR comments](https://aur.archlinux.org/packages/odin-git) or use Option B.

**Option B — Official binary release**

```bash
cd ~
curl -L -o odin.zip https://github.com/odin-lang/Odin/releases/latest/download/odin-linux-amd64-nightly.zip
unzip odin.zip -d odin
echo 'export PATH="$HOME/odin:$PATH"' >> ~/.bashrc
source ~/.bashrc
odin version
```

</details>

<details open>
<summary><b>Step 3 — Clone and Build</b></summary>

<br>

```bash
cd ~
git clone https://github.com/oooFruitSnacks/FuzzyBuddyFarms.git
cd FuzzyBuddyFarms
odin build . -out:Fuzzy_Buddy_Farms -o:speed
chmod +x Fuzzy_Buddy_Farms
./Fuzzy_Buddy_Farms
```

</details>

<div align="right"><a href="#-linux">⬆ Back to Linux menu</a></div>

---

### 🟢 Manjaro

Manjaro is Arch-based so the packages are identical, but Manjaro holds updates back on its own schedule so **always sync fully first**.

<details open>
<summary><b>Step 1 — Install Dependencies</b></summary>

<br>

```bash
sudo pacman -Syu --needed git base-devel clang llvm \
  libx11 libxrandr libxinerama libxcursor libxi \
  mesa glu alsa-lib
```

> [!WARNING]
> Never use `pacman -Sy package` alone on Manjaro or Arch — partial upgrades cause broken library versions. **Always `-Syu`.**

</details>

<details open>
<summary><b>Step 2 — Install Odin</b></summary>

<br>

Manjaro ships `pamac`, which can build AUR packages once enabled:

```bash
pamac build odin-git
```

If AUR support is off, enable it in **Add/Remove Software → Preferences → Third Party → AUR support**, or just use the binary release method from the Arch section above.

</details>

<details open>
<summary><b>Step 3 — Clone and Build</b></summary>

<br>

Identical to Arch — follow the [Arch Linux](#-arch-linux) section above.

</details>

<div align="right"><a href="#-linux">⬆ Back to Linux menu</a></div>

---

### 🐮 Gentoo

Gentoo builds everything from source, so most dependencies may already be present. Gentoo has no `-dev` split — headers always install with the library.

<details open>
<summary><b>Step 1 — Install Dependencies</b></summary>

<br>

```bash
sudo emerge --ask --noreplace \
  dev-vcs/git \
  sys-devel/clang \
  x11-libs/libX11 \
  x11-libs/libXrandr \
  x11-libs/libXinerama \
  x11-libs/libXcursor \
  x11-libs/libXi \
  media-libs/mesa \
  media-libs/glu \
  media-libs/alsa-lib
```

`--noreplace` skips anything already installed. Add `--ask` to review the plan before committing.

Make sure Mesa is built with OpenGL support in `/etc/portage/make.conf`:

```bash
USE="X opengl"
VIDEO_CARDS="amdgpu radeonsi"
```

*(or `nvidia`, `intel`, etc.)*

Then rebuild anything affected:

```bash
sudo emerge --ask --changed-use --deep @world
```

</details>

<details open>
<summary><b>Step 2 — Install Odin</b></summary>

<br>

Odin isn't in the official Portage tree. Use the binary release:

```bash
cd ~
curl -L -o odin.zip https://github.com/odin-lang/Odin/releases/latest/download/odin-linux-amd64-nightly.zip
unzip odin.zip -d odin
echo 'export PATH="$HOME/odin:$PATH"' >> ~/.bashrc
source ~/.bashrc
odin version
```

**Or build from source** (Odin needs LLVM 17–22):

```bash
sudo emerge --ask sys-devel/llvm dev-vcs/git-lfs
git clone https://github.com/odin-lang/Odin
cd Odin
git lfs install && git lfs pull
make release-native
echo 'export PATH="$HOME/Odin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

If your default LLVM is outside 17–22, point the build at a specific slot:

```bash
LLVM_CONFIG=/usr/lib/llvm/18/bin/llvm-config make release-native
```

</details>

<details open>
<summary><b>Step 3 — Clone and Build</b></summary>

<br>

```bash
cd ~
git clone https://github.com/oooFruitSnacks/FuzzyBuddyFarms.git
cd FuzzyBuddyFarms
odin build . -out:Fuzzy_Buddy_Farms -o:speed
chmod +x Fuzzy_Buddy_Farms
./Fuzzy_Buddy_Farms
```

</details>

<div align="right"><a href="#-linux">⬆ Back to Linux menu</a></div>

---

### 🎮 SteamOS / Steam Deck

> [!IMPORTANT]
> SteamOS uses an **immutable (read-only) root filesystem**, and system changes are **wiped by every SteamOS update**. Method A below avoids this entirely and is strongly recommended.

First, switch to **Desktop Mode** (Steam button → Power → Switch to Desktop) and open **Konsole**.

Set a password if you've never done so — `sudo` won't work without one:

```bash
passwd
```

| Method | Survives Updates? | Recommended |
|:--|:--:|:--:|
| [**A** — Distrobox](#method-a--distrobox-recommended) | ✅ Yes | ⭐ |
| [**B** — Unlock filesystem](#method-b--unlock-the-filesystem) | ❌ No | |

#### Method A — Distrobox (Recommended)

Distrobox runs a full Arch container with your home directory shared, so you can install build tools without touching SteamOS itself. Nothing breaks on update.

```bash
distrobox create --name fuzzydev --image archlinux:latest
distrobox enter fuzzydev
```

Now **inside the container**:

```bash
sudo pacman -Syu --needed git base-devel clang llvm \
  libx11 libxrandr libxinerama libxcursor libxi \
  mesa glu alsa-lib
cd ~
curl -L -o odin.zip https://github.com/odin-lang/Odin/releases/latest/download/odin-linux-amd64-nightly.zip
unzip odin.zip -d odin
export PATH="$HOME/odin:$PATH"
git clone https://github.com/oooFruitSnacks/FuzzyBuddyFarms.git
cd FuzzyBuddyFarms
odin build . -out:Fuzzy_Buddy_Farms -o:speed
```

Type `exit` to leave the container. Because Distrobox shares your home directory, the binary is available directly from SteamOS:

```bash
cd ~/FuzzyBuddyFarms
chmod +x Fuzzy_Buddy_Farms
./Fuzzy_Buddy_Farms
```

#### Method B — Unlock the Filesystem

```bash
sudo steamos-devmode enable
```

This helper disables read-only mode, populates the pacman keyring, restores headers stripped from the shipping image, and installs base development tools.

If `steamos-devmode` isn't available or errors, do it manually:

```bash
sudo steamos-readonly disable
sudo pacman-key --init
sudo pacman-key --populate archlinux
sudo pacman -Syu
```

Then install dependencies and Odin exactly as in the [Arch Linux](#-arch-linux) section.

When finished, re-enable protection:

```bash
sudo steamos-readonly enable
```

> [!WARNING]
> Everything installed this way is **erased by the next SteamOS update**. `steamos-devmode enable` has also been reported to fail with read-only errors on some SteamOS versions. If you hit that, use **Method A**.

#### Adding the Game to Your Steam Library

**Steam → Games → Add a Non-Steam Game to My Library → Browse**

Select `~/FuzzyBuddyFarms/Fuzzy_Buddy_Farms`. Then in its **Properties**, set **Start In** to `/home/deck/FuzzyBuddyFarms` so the game finds its `assets` folder. It'll now launch from Game Mode.

> [!NOTE]
> The Steam Deck's AMD GPU fully supports OpenGL 3.3, so no `MESA_GL_VERSION_OVERRIDE` workaround is needed — that's only required on Raspberry Pi hardware.

<div align="right"><a href="#-linux">⬆ Back to Linux menu</a></div>

---

### 🍓 Raspberry Pi OS

<details open>
<summary><b>Step 1 — Confirm You're on 64-bit</b></summary>

<br>

```bash
uname -m
```

| Output | Meaning | Action |
|:--|:--|:--|
| `aarch64` | ✅ 64-bit OS | Good to move on to the next step |
| `armv7l` | ⚠️ 32-bit OS | You will need to reinstall the 64-bit image |

You can also target `linux_arm32` instead with the flag `-target=linux_arm32` to try and cross compile, but cross compilation can be finicky with Odin.

</details>

<details open>
<summary><b>Step 2 — Install Clang and System Libraries</b></summary>

<br>

```bash
sudo apt update
sudo apt install -y git clang \
  libx11-dev libxrandr-dev libxinerama-dev \
  libxcursor-dev libxi-dev libgl1-mesa-dev libasound2-dev
```

</details>

<details open>
<summary><b>Step 3 — Install Odin</b></summary>

<br>

Install the Linux arm64 release from Odin via command line:

```bash
cd ~
curl -L -o odin.zip https://github.com/odin-lang/Odin/releases/latest/download/odin-linux-arm64-nightly.zip
unzip odin.zip -d odin
echo 'export PATH="$HOME/odin:$PATH"' >> ~/.bashrc
source ~/.bashrc
odin version
```

Or please visit [odin-lang.org/docs/install](https://odin-lang.org/docs/install/) to install the Odin language if you have any issues.

**If there are no arm64 releases available**, build the compiler from source with:

```bash
sudo apt install -y llvm llvm-dev git-lfs
git clone https://github.com/odin-lang/Odin
cd Odin
git lfs install
git lfs pull
make release-native
echo 'export PATH="$HOME/Odin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

> [!WARNING]
> If your `LLVM` is outdated please update to the latest release — Odin supports versions **17–22**. Please be aware this will take some time to update on Pi hardware, so if you don't see anything happen or update for a while **DO NOT START BUTTON MASHING** thank you.

</details>

<details open>
<summary><b>Step 4 — Clone and Build</b></summary>

<br>

```bash
git clone https://github.com/oooFruitSnacks/FuzzyBuddyFarms.git
cd FuzzyBuddyFarms
odin build . -out:Fuzzy_Buddy_Farms -o:speed
```

> [!NOTE]
> **No target flag is needed when building on a Raspberry Pi** — Odin will default to the host architecture.

Now run:

```bash
chmod +x Fuzzy_Buddy_Farms
./Fuzzy_Buddy_Farms
```

</details>

<details open>
<summary><b>🔧 If It Fails to Run</b></summary>

<br>

**1. Install the runtime counterparts** and then try again:

```bash
sudo apt install -y libx11-6 libxrandr2 libxinerama1 libxcursor1 libxi6 libgl1 libasound2t64
```

**2. Alternatively, if that doesn't work, try:**

```bash
MESA_GL_VERSION_OVERRIDE=3.3 ./Fuzzy_Buddy_Farms
```

**3. Last resort — software rendering:**

> [!WARNING]
> THIS METHOD IS **VERY SLOW AND BUGGY** BUT IT CAN BE USED TO CONFIRM YOU HAVE EVERYTHING INSTALLED PROPERLY TO RUN THE GAME

```bash
LIBGL_ALWAYS_SOFTWARE=1 ./Fuzzy_Buddy_Farms
```

</details>

<div align="right"><a href="#-linux">⬆ Back to Linux menu</a></div>

---

### 🔩 Linux arm64 / aarch64

> For generic aarch64 Linux systems. For Raspberry Pi specifically, see [Raspberry Pi OS](#-raspberry-pi-os).

<details open>
<summary><b>Step 1 — Install Clang and System Libraries</b></summary>

<br>

```bash
sudo apt update
sudo apt install -y git clang \
  libx11-dev libxrandr-dev libxinerama-dev \
  libxcursor-dev libxi-dev libgl1-mesa-dev libasound2-dev
```

</details>

<details open>
<summary><b>Step 2 — Install Odin</b></summary>

<br>

Install the Linux arm64 release from Odin via command line:

```bash
cd ~
curl -L -o odin.zip https://github.com/odin-lang/Odin/releases/latest/download/odin-linux-arm64-nightly.zip
unzip odin.zip -d odin
echo 'export PATH="$HOME/odin:$PATH"' >> ~/.bashrc
source ~/.bashrc
odin version
```

Or please visit [odin-lang.org/docs/install](https://odin-lang.org/docs/install/) to install the Odin language if you have any issues.

**If there are no arm64 releases available**, build the compiler from source with:

```bash
sudo apt install -y llvm llvm-dev git-lfs
git clone https://github.com/odin-lang/Odin
cd Odin
git lfs install
git lfs pull
make release-native
echo 'export PATH="$HOME/Odin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

> [!NOTE]
> If your `LLVM` is outdated please update to the latest release — Odin supports versions **17–22**.

</details>

<details open>
<summary><b>Step 3 — Clone and Build</b></summary>

<br>

```bash
git clone https://github.com/oooFruitSnacks/FuzzyBuddyFarms
cd FuzzyBuddyFarms
odin build . -out:Fuzzy_Buddy_Farms -o:speed
chmod +x Fuzzy_Buddy_Farms
./Fuzzy_Buddy_Farms
```

If it fails to run, try:

```bash
MESA_GL_VERSION_OVERRIDE=3.3 ./Fuzzy_Buddy_Farms
```

</details>

<div align="right"><a href="#-linux">⬆ Back to Linux menu</a></div>

---

### ❓ Linux Troubleshooting (All Distributions)

| Error Message | Cause | Fix |
|:--|:--|:--|
| `error while loading shared libraries: libXcursor.so.1` | Runtime libraries are missing | Install the runtime (non-`-dev`) packages for your distro |
| `Permission denied` | Binary isn't marked executable | Run `chmod +x Fuzzy_Buddy_Farms` or prefix the command with `sudo` |
| **Game can't find assets** | Wrong working directory | Always launch from inside the repo folder, so `assets/` sits next to the binary |
| `odin: command not found` | Your `PATH` change didn't take | Run `source ~/.bashrc`, or `source ~/.zshrc` if you use zsh |
| `GLXBadFBConfig` / `Failed to create context` | Your GPU doesn't advertise OpenGL 3.3 — common on Raspberry Pi and very old integrated graphics | See the [Raspberry Pi](#-raspberry-pi-os) section for the `MESA_GL_VERSION_OVERRIDE=3.3` workaround |

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

<div align="right"><a href="#-table-of-contents">⬆ Back to top</a></div>

---

## 📜 License

FuzzyBuddyFarms is licensed under the [**GNU General Public License v2.0**](LICENSE).

This means you're free to run, study, modify, and redistribute the source code — but any distributed modified versions must also be licensed under GPLv2 and made available in source form. See the [LICENSE](LICENSE) file for the full terms.

<div align="right"><a href="#-table-of-contents">⬆ Back to top</a></div>

---

## 🛡️ Security Policy

> [!CAUTION]
> Found a security vulnerability? Please **DON'T** open a public issue for it — see [SECURITY.md](SECURITY.md) for how to report it responsibly.

<div align="right"><a href="#-table-of-contents">⬆ Back to top</a></div>

---

<div align="center">

### 🐝 Enjoy the game! 🍯

</div>
