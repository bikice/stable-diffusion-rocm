# Stable Diffusion WebUI with ROCm

1. Place a model into data/models/Stable-diffusion. E.g. https://huggingface.co/runwayml/stable-diffusion-v1-5/resolve/main/v1-5-pruned.safetensors

2. Build
   ```shell
   docker-compose build --force-rm webui
   ```

3. Run
   ```shell
   docker-compose up
   ```

4. Bash `docker exec -it <running container-id> bash`
   ```shell
   docker ps -a
   ```

5. Use the WebUI on http://127.0.0.1:7860

6. Summary 
   - tested on AMD Radeon 6650 XT 8GB (gfx1032) NAVI 23
   - Using DreamBooth throws Triton Error [HIP]:  Code: 98, Messsage: invalid device function
      - waiting for: https://github.com/openai/triton/issues/46
      - pr's: https://github.com/openai/triton/pulls?q=is%3Apr+rocm+