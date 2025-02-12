<h1 align="center">Box2D-Lite WASM</h1>

<p align="center">
  <i>is a complete rewrite in <a title="Zig" href="https://ziglang.org/" target="_blank" rel="noopener noreferrer">Zig</a> and build to <a title="WASM" href="https://webassembly.org/" target="_blank" rel="noopener noreferrer">WASM</a> of an awesome <a title="Box2D-Lite" href="https://github.com/erincatto/box2d-lite" target="_blank" rel="noopener noreferrer">Box2D-Lite</a> physics engine by <a title="Erin Catto" href="https://github.com/erincatto" target="_blank" rel="noopener noreferrer">Erin Catto</a>.</i>
</p>

<p align="center">
  <!-- <img alt="GitHub Deployments" src="https://img.shields.io/github/deployments/UstymUkhman/box2d-lite-wasm/github-pages?style=flat-square" /> -->
  <img alt="GitHub Repo Size" src="https://img.shields.io/github/repo-size/UstymUkhman/box2d-lite-wasm?style=flat-square" />
  <img alt="GitHub License" src="https://img.shields.io/github/license/UstymUkhman/box2d-lite-wasm?color=lightgrey&style=flat-square" />
</p>

## Commands

```sh
# Download
git clone https://github.com/UstymUkhman/box2d-lite-wasm.git
cd box2d-lite-wasm

# Install
git submodule update --init --recursive
cd Zig

# Run
zig run ./src/main.zig

# Build
zig build

# Run .exe
./zig-out/bin/box2d-lite-wasm.exe
```

## License

Box2D-Lite is developed by Erin Catto, and uses the [MIT license](https://github.com/erincatto/box2d-lite/blob/master/LICENSE).

Box2D-Lite WASM is developed by Ustym Ukhman, and uses the [MIT license](https://github.com/UstymUkhman/box2d-lite-wasm/blob/main/LICENSE).
