FROM rocm/pytorch:latest

LABEL maintainer="kristof.kamin@gmail.com"

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    PYTHONIOENCODING=UTF-8 \
    TORCH_COMMAND='pip install torch torchvision torchaudio --force-reinstall --extra-index-url https://download.pytorch.org/whl/rocm5.4.2' \
    ROOT=/stable-diffusion-webui \
    HSA_OVERRIDE_GFX_VERSION=10.3.0

SHELL ["/bin/bash", "-c"]

RUN --mount=type=cache,target=/root/.cache/pip \
  pip install --upgrade pip

RUN --mount=type=cache,target=/root/.cache/pip \
  pip install numpy==1.22.4 requests==2.25.1

RUN cd / && \
  git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git ${ROOT} && \
  cd ${ROOT} && \
  pip install -r requirements_versions.txt

RUN --mount=type=cache,target=/root/.cache/pip \
  $TORCH_COMMAND

COPY ./entrypoint.sh /entrypoint.sh

WORKDIR ${ROOT}
EXPOSE 7860
ENTRYPOINT ["bash", "/entrypoint.sh"]
CMD python launch.py --precision full --no-half