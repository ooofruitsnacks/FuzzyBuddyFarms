# Flatpak Packaging

Builds Odin **and** raylib from source inside the sandbox so the result
satisfies Flathub's no-prebuilt-binaries requirement.

## One-time host setup

```bash
sudo apt install flatpak flatpak-builder   # or dnf / pacman

flatpak remote-add --if-not-exists --user flathub \
  https://dl.flathub.org/repo/flathub.flatpakrepo

flatpak install --user flathub \
  org.freedesktop.Platform//25.08 \
  org.freedesktop.Sdk//25.08 \
  org.freedesktop.Sdk.Extension.llvm20//25.08
```

The LLVM extension is required twice over: Odin is an LLVM frontend and
Odin invokes `clang` by name at link time. The Freedesktop SDK ships gcc
but no clang.

## Pinning commits

Flathub rejects moving branch refs. Fill in both `commit:` fields:

```bash
git ls-remote https://github.com/odin-lang/Odin.git refs/tags/dev-2026-08
git ls-remote https://github.com/raysan5/raylib.git refs/tags/5.5^{}
```

## Build and run locally

```bash
flatpak-builder --user --install --force-clean \
  build-dir io.github.ooofruitsnacks.FuzzyBuddyFarms.yml

flatpak run io.github.ooofruitsnacks.FuzzyBuddyFarms
```

First build takes 30–60 minutes — you are compiling a compiler.

## Iterate without rebuilding Odin

```bash
flatpak-builder --user --force-clean --stop-at=fuzzybuddyfarms \
  build-dir io.github.ooofruitsnacks.FuzzyBuddyFarms.yml

flatpak-builder --user --build-shell=fuzzybuddyfarms \
  build-dir io.github.ooofruitsnacks.FuzzyBuddyFarms.yml
```

Inside that shell, check `$ODIN_ROOT`, inspect
`$ODIN_ROOT/vendor/raylib/linux/`, and re-run `odin build` by hand.

## Distributable bundle

```bash
flatpak-builder --repo=repo --force-clean build-dir \
  io.github.ooofruitsnacks.FuzzyBuddyFarms.yml

flatpak build-bundle repo \
  Fuzzy_Buddy_Farms-x86_64.flatpak \
  io.github.ooofruitsnacks.FuzzyBuddyFarms
```

## Validate before submitting

```bash
appstreamcli validate io.github.ooofruitsnacks.FuzzyBuddyFarms.metainfo.xml
pip install flatpak-builder-lint
flatpak-builder-lint manifest io.github.ooofruitsnacks.FuzzyBuddyFarms.yml
flatpak-builder-lint repo repo
```
