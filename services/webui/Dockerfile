FROM alpine/git:2.36.2 as download

RUN mkdir /repositories

RUN --mount=type=cache,target=/root/.cache/stable-diffusion-stability-ai \
    git clone https://github.com/Stability-AI/stablediffusion.git /repositories/stable-diffusion-stability-ai && \
    cd /repositories/stable-diffusion-stability-ai && \
    rm -rf assets data/**/*.png data/**/*.jpg data/**/*.gif

RUN --mount=type=cache,target=/root/.cache/taming-transformers \
    git clone https://github.com/CompVis/taming-transformers.git /repositories/taming-transformers && \
    cd /repositories/taming-transformers \
    rm -rf data assets **/*.ipynb

RUN --mount=type=cache,target=/root/.cache/k-diffusion \
    git clone https://github.com/crowsonkb/k-diffusion.git /repositories/k-diffusion

RUN --mount=type=cache,target=/root/.cache/CodeFormer \
    git clone https://github.com/sczhou/CodeFormer.git /repositories/CodeFormer && \
    cd /repositories/CodeFormer && \
    rm -rf assets inputs

RUN --mount=type=cache,target=/root/.cache/BLIP \
    git clone https://github.com/salesforce/BLIP.git /repositories/BLIP

RUN --mount=type=cache,target=/root/.cache/clip-interrogator \
    git clone https://github.com/pharmapsychotic/clip-interrogator /repositories/clip-interrogator

FROM rocm/pytorch:latest

LABEL maintainer="kristof.kamin@gmail.com"

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    PYTHONIOENCODING=UTF-8 \
    TORCH_COMMAND='pip install torch torchvision torchaudio --force-reinstall --extra-index-url https://download.pytorch.org/whl/rocm5.4.2' \
    REQS_FILE='requirements.txt' \
    ROOT=/stable-diffusion-webui \
    HSA_OVERRIDE_GFX_VERSION=10.3.0

SHELL ["/bin/bash", "-c"]

RUN --mount=type=cache,target=/root/.cache/webui \
    git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git ${ROOT}

COPY --from=download /repositories/ ${ROOT}/repositories/
RUN --mount=type=cache,target=/root/.cache/pip \
  pip install -r ${ROOT}/repositories/CodeFormer/requirements.txt

RUN --mount=type=cache,target=/root/.cache/pip \
    cd ${ROOT} && \
    python -m venv venv && \
    source venv/bin/activate && \
    python -m pip install --upgrade pip wheel && \
    pip install numpy==1.22.4 requests==2.25.1 pytorch-triton-rocm==2.0.1 && \
    pip install -r requirements_versions.txt && \
    python -m $TORCH_COMMAND

COPY scripts/entrypoint.sh /entrypoint.sh

WORKDIR ${ROOT}
EXPOSE 7860

ENTRYPOINT ["bash", "/entrypoint.sh"]

CMD cd ${ROOT} && \
    python -m venv venv && \
    source venv/bin/activate && \
    python launch.py --precision full --no-half
