# Security Policy

FuzzyBuddyFarms is an open-source, solo-developed project. Security and transparency are taken seriously, and reports of any kind are welcomed and will be addressed promptly.

## Supported Versions

Only the latest tagged release available on the [Releases](https://github.com/oooFruitSnacks/FuzzyBuddyFarms/releases) page is actively supported with security fixes. Older releases will not receive patches — please always download or build from the latest version.

| Version         | Supported          |
| ---------------- | ------------------ |
| Latest release   | ✅ Yes              |
| Older releases    | ❌ No               |
| `main` branch (source) | ✅ Yes (unreleased fixes may land here first) |

## Reporting a Vulnerability

If you discover a security concern — whether in the game's source code, a build artifact, the GitHub Actions release pipeline, or anywhere else in this repository — please report it privately rather than opening a public GitHub issue, so it can be addressed before any details are made public.

**Contact:** `467487@pm.me`

**Subject line:** `SECURITY BUG - FuzzyBuddyFarms`

Please include as much of the following as you reasonably can:
- A clear description of the issue and where it was found (source file, specific build/platform, release version, etc.)
- Steps to reproduce the vulnerability
- The potential impact/severity of the vulnerability
- Any suggested fix, if you have one (entirely optional) I'm still learning and I'm only one person. If you have a better and safer way of fixing something please let me know.

You do not need to be a security researcher to report something — if anything about this project looks off or unsafe please reach out to my email.

### What to expect after reporting

- **Acknowledgment:** You can expect a response as soon as possible after the report is received.
- **Assessment:** The issue will be investigated and you will be kept informed of the outcome — whether it's confirmed as a real issue, needs more information, or isn't reproducible.
- **Fix and disclosure:** If a legitimate threat is confirmed, a fix will be prioritized and pushed as quickly as possible, followed by a public notice describing the issue and the update, once a patch is available. Reporters will be credited if they wish to be (or kept anonymous, if preferred).

## Scope

This policy covers:
- The Odin source code in this repository (`fuzzybuddyfarmsdemo.odin`, `net.odin`, and any other source files)
- The build and release pipeline (`.github/workflows/build.yml`)
- Official release artifacts published under this repository's [Releases](https://github.com/oooFruitSnacks/FuzzyBuddyFarms/releases) page
- Packaging files under `packaging/`

This policy does **not** cover third-party dependencies directly (e.g. the Odin compiler/toolchain itself, or the Raylib library FuzzyBuddyFarms is built on) — please report issues in those projects to their respective maintainers. However, if you believe a dependency issue directly affects FuzzyBuddyFarms specifically, feel free to reach out anyway and it will be looked into.

## A Note on Unsigned Binaries

FuzzyBuddyFarms release binaries (Windows, macOS, and Linux) are **not code-signed**, since this requires a paid certificate that isn't currently part of this project's budget as a solo, open-source effort. As a result:

- **Windows** may show a "Windows protected your PC" SmartScreen warning
- **macOS** may show an "unidentified developer" or similar Gatekeeper warning
- **Linux** users may need to manually mark the binary as executable

This is **expected behavior for unsigned software** and is not, by itself, evidence of a security problem. Step-by-step instructions for safely bypassing these warnings are included in the [README](https://github.com/oooFruitSnacks/FuzzyBuddyFarms/blob/main/README.md#download-honeybee).

If you'd rather not rely on these warnings being safe to dismiss, you are always welcome to read through the full source code yourself and build the game directly from source — instructions for Windows, macOS, and Linux are provided in the README's [Build From Source](https://github.com/oooFruitSnacks/FuzzyBuddyFarms/blob/main/README.md#build-from-source) section. This project is made open source specifically so that this kind of independent verification is possible.

## Commitment to Transparency

FuzzyBuddyFarms contains no hidden trackers, telemetry, scrapers, backdoors, or other undisclosed data-collection or exploit code. All source code is public and open for review at any time — reading through it yourself is genuinely encouraged, not just tolerated.

If a legitimate vulnerability is ever discovered and confirmed, an immediate notice will be published (via a GitHub Release note and/or repository announcement) alongside the fix, so users are never left unaware of a real risk.
