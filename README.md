# GPTOS

GPTOS is a minimal Linux-based operating system built from scratch completely with the LLM ChatGPT by OpenAI (some troubleshooting may be done by me). You can either **build it from source** using the provided script or **download the pre-built ISO** directly from this repository.

---

## Features
- WARNING: Most of this features are not in the iso or build iso because its still on prealpha/alpha
- Minimal Linux kernel with BusyBox as the userland.
- Core GNU utilities via compiled coreutils.
- Package management via vibe coded package manager `gpt`.
- Works in QEMU and real hardware (x86_64).
- Custom init and initramfs setup for lightweight boot.
- (btw dont use this in real hardware pls)
---

## Package Repository

GPTOS uses a separate package repository for the `gpt` package manager:

👉 https://github.com/aderox20/gptpm-repo

This repository contains:
- Prebuilt packages (`.tar.xz`)
- The package index (`index.json`)
- Files used by the `gpt` package manager

---

### Using the package manager

Inside GPTOS:

```bash
gpt install neovim
gpt install < package >
gpt list
## Build from Scratch

Run the included script `build_fromscratch_gptos.sh`:

```bash
sudo ./build_fromscratch_gptos.sh
```

The script will:

1. Download and compile the Linux kernel if needed.
2. Download BusyBox and coreutils.
3. Set up the root filesystem and initramfs.
4. Build a bootable ISO with GRUB.
5. Optionally boot the ISO in QEMU.

---

## Download Pre-built ISO

You can download the latest ISO directly from this repository:

[GPTOS 0.0.1 Pre-alpha ISO](https://github.com/Aderox20_dev/GPTOS/raw/main/gptos-0.0.1-x86_64.iso)

```bash
curl -LO https://github.com/Aderox20_dev/GPTOS/raw/main/gptos-0.0.1-x86_64.iso
```

---

## Running in QEMU

To test GPTOS in QEMU:

```bash
qemu-system-x86_64 -cdrom gptos-0.0.1-x86_64.iso -m 2G -boot d
```

---

## Contributing

Contributions are welcome! You can help by:

- Testing builds on different hardware.
- Adding new packages to the root filesystem.
- Improving scripts or documentation.

---

## License

GPTOS is released under the MIT License. See the `LICENSE` file for details.
