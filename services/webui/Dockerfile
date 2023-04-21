FROM rocm/pytorch:latest

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    PYTHONIOENCODING=UTF-8 \
    ROOT=/stable-diffusion-webui

SHELL ["/bin/bash", "-c"]

RUN --mount=type=cache,target=/root/.cache/pip \
  pip install torch torchvision torchaudio --force-reinstall --extra-index-url https://download.pytorch.org/whl/rocm5.4

RUN cd / && \
  git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git ${ROOT} && \
  cd ${ROOT} && \
  pip install -r requirements_versions.txt

RUN --mount=type=cache,target=/root/.cache/pip \
  pip install pip numpy==1.22.4 requests==2.25.1

COPY ./entrypoint.sh /entrypoint.sh

WORKDIR ${ROOT}
EXPOSE 7860
ENTRYPOINT ["bash", "/entrypoint.sh"]
CMD python launch.py --precision full --no-half --skip-torch-cuda-test