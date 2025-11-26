# windows-terminal-shaders-retro-crt-flicker

A modified pixel shader for Windows Terminal (`RetroModded.hlsl`) that features a high-frequency CRT flicker effect and sharper text compared to the default retro shader.

##  Installation

### 1. Download the Shader
Download the [RetroModded.hlsl](./RetroModded.hlsl) file from this repository and save it to a permanent location on your PC (e.g., `C:\Users\YourName\Documents\Shaders\RetroModded.hlsl`).

### 2. Configure Windows Terminal
1. Open **Windows Terminal**.
2. Open **Settings** (Click the dropdown arrow `∨` or press `Ctrl` + `,`).
3. Click **"Open JSON file"** in the bottom left corner to open `settings.json`.
4. Find the profile you want to apply the effect to (e.g., `"name": "Windows PowerShell"`).
5. Add the following line to that profile (replace the path with your actual file location):

```json 
"experimental.pixelShaderPath": "<path to a .hlsl pixel shader>" 
```
(e.g., "experimental.pixelShaderPath": "C:\\Users\\YourName\\Documents\\Shaders\\RetroModded.hlsl")

Refer to [Microsoft Terminal PixelShaders Samples](https://github.com/microsoft/terminal/tree/main/samples/PixelShaders) for more detail
