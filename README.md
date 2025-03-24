# 🎵 Odin-FAudio 🎮

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## 🚀 Overview

Bindings for the amazing [FAudio](https://github.com/FNA-XNA/FAudio) library, a cross-platform, open-source implementation of the XAudio APIs.

⚠️ **WARNING**: These bindings are mostly an AI-generated first attempt, so keep that in mind and create an issue if you encounter any problems!

## ✨ Features

- 🔄 Complete bindings for the core FAudio API
- 🎧 Support for 3D audio positioning with F3DAUDIO
- 🎚️ XAPO (audio processing objects) support
- 🎼 XACT3 (Cross-platform Audio Creation Tool) compatibility
- 🎹 STB Vorbis integration for Ogg Vorbis decoding

## 📦 Installation

## 🔧 Usage

```odin
import "path/to/faudio"

// Initialize FAudio
faudio_engine: ^faudio.FAudio
faudio.FAudioCreate(&faudio_engine, 0, faudio.FAUDIO_DEFAULT_PROCESSOR)

// Create a mastering voice
mastering_voice: ^faudio.FAudioMasteringVoice
faudio.FAudio_CreateMasteringVoice(
    faudio_engine,
    &mastering_voice,
    2,                // Two channels for stereo
    48000,            // 48kHz sample rate
    0,                // No special effects
    nil,              // Use default device ID
    nil,              // No effect chain
    faudio.AudioCategory_GameEffects
)

// Clean up when done
faudio.FAudioVoice_DestroyVoice(mastering_voice)
faudio.FAudio_Release(faudio_engine)
```

## 🛠️ Building Projects

When using these bindings in your project:

- 💻 On Windows: Link against `FAudio.lib`
- 🐧 On Linux/macOS: The library will be linked as `system:FAudio`, so either have FAudio installed in your system or follow the Linux/macOS Configuration instructions below.

### Linux/macOS Configuration

On Linux/macOS, if you want to use a local FAudio installation, you'll also need an SDL3 build, and after that you can follow these steps:

```bash
# Clone or add the FAudio repository as a git subtree
git subtree add --prefix=vendor/FAudio https://github.com/FNA-XNA/FAudio.git [LATEST_TAG] --squash

# Build it
mkdir -p vendor/FAudio/build
cd ./vendor/FAudio/build
cmake .. -DSDL3_DIR=/path/to/SDL3/build
make -j$(nproc)

# Make sure the linker can find your local FAudio build
odin build [your_project] \
    -extra-linker-flags:"-L/path/to/vendor/FAudio/build -Wl,-rpath,/path/to/vendor/FAudio/build"
```

I'm sure you can do something similar in Windows, but I don't know how to do it _shrug_.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgements

- [FAudio](https://github.com/FNA-XNA/FAudio) - The amazing library these bindings are built for
- [Odin Language](https://odin-lang.org/) - The programming language used for these bindings
