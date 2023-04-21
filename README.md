# Stable Diffusion WebUI with ROCm

1. Place a model into data/models/Stable-diffusion. E.g. https://huggingface.co/runwayml/stable-diffusion-v1-5/resolve/main/v1-5-pruned.safetensors

2. Build
    ```shell
    docker-compose build webui
    ```

3. Build & run
    ```shell
    docker-compose up
    ```

4. Use the WebUI on http://127.0.0.1:7860

tested on AMD Radeon 6650 XT 8GB (gfx1032) NAVI 23