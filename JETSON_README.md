# SAMURAI on NVIDIA Jetson Orin AGX

This document provides instructions for building and running SAMURAI on NVIDIA Jetson Orin AGX.

**Target Environment:**
*   Device: Jetson Orin AGX
*   JetPack: 6.2.1 (L4T 36.4.4) or 6.2 (L4T 36.4.3) or 6.1 (L4T 36.4.0)
*   CUDA: 12.x

## Prerequisites

*   Docker and NVIDIA Container Runtime installed (standard on JetPack).
*   Internet access on the Jetson.
*   **Check your L4T version:**
    ```bash
    cat /etc/nv_tegra_release
    ```

## Build the Docker Image

We use `dustynv/l4t-pytorch` as the base image. The default tag in the script is `r36.4.0` (JetPack 6.1), which is generally compatible with JetPack 6.2.

To build the image:

```bash
./scripts/build_jetson.sh
```

**Note:** If you find a more specific tag for your L4T version (e.g., `dustynv/l4t-pytorch:r36.4.4` for JetPack 6.2.1), you can specify it:

```bash
./scripts/build_jetson.sh dustynv/l4t-pytorch:r36.4.4
```

The build process will:
1.  Install dependencies (ffmpeg, etc.).
2.  Compile SAM 2 CUDA extensions (`SAM2_BUILD_CUDA=1`) for Orin (Arch 8.7).
3.  Download SAM 2.1 checkpoints.

*Warning: Installing `opencv-python` via pip on Jetson can take time as it may build from source. Be patient.*

## Run the Container

To run the container interactively:

```bash
./scripts/run_jetson.sh
```

This script:
*   Uses `--runtime nvidia` to enable GPU access.
*   Mounts the local `data` directory to `/opt/samurai/data` inside the container (if it exists).
*   Enables X11 forwarding (if you have a display connected).

## Running Inference

### Demo on Video

Ensure you have a video and a bounding box text file in your `data` folder.

```bash
python scripts/demo.py \
    --video_path data/your_video.mp4 \
    --txt_path data/bbox.txt \
    --video_output_path data/output.mp4
```

The output video will be saved to `data/output.mp4` (accessible from host).

### Main Inference (VOT)

```bash
python scripts/main_inference.py
```

## Troubleshooting

*   **ImportError: libGL.so.1**: If OpenCV complains about missing libraries, install them inside the container:
    ```bash
    apt-get update && apt-get install -y libgl1
    ```
    (The Dockerfile already installs `ffmpeg` libs which usually cover this, but `libgl1` might be needed for headless opencv sometimes).

*   **PyTorch Version Warning**: SAM 2 desires PyTorch >= 2.3.1. `dustynv/l4t-pytorch:r36.4.0` should meet this. If you see warnings, check `python -c "import torch; print(torch.__version__)"`.
