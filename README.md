# Stable Diffusion WebUI with ROCm

1. Place models into data/models/Stable-diffusion. E.g. https://huggingface.co/runwayml/stable-diffusion-v1-5/resolve/main/v1-5-pruned.safetensors

2. Build
   ```shell
   docker-compose build
   ```

3. Run
   ```shell
   docker-compose up
   ```

4. Bash
   ```shell
   docker-compose run stable-diffusion-webui bash
   ```

5. Use the WebUI on http://127.0.0.1:7860

6. Summary 
   - tested on AMD Radeon 6650 XT 8GB (gfx1032) NAVI 23