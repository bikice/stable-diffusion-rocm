FROM alpine/git:2.36.2 as builder

WORKDIR /opt

RUN --mount=type=cache,target=/root/.cache/download-sd-webui \
    git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui /opt/stable-diffusion-webui && \
    sed -i -e '/^torch\r/d' /opt/stable-diffusion-webui/requirements.txt && \
    sed -i -e '/^torch\r/d' /opt/stable-diffusion-webui/requirements_versions.txt

RUN --mount=type=cache,target=/root/.cache/download-repositories \
    mkdir /opt/repositories && \
    git clone https://github.com/Stability-AI/stablediffusion.git /opt/repositories/stable-diffusion-stability-ai && \
    cd /opt/repositories/stable-diffusion-stability-ai && rm -rf assets data/**/*.png data/**/*.jpg data/**/*.gif && \
    git clone https://github.com/CompVis/taming-transformers.git /opt/repositories/taming-transformers && \
    cd /opt/repositories/taming-transformers && rm -rf data assets **/*.ipynb && \
    git clone https://github.com/crowsonkb/k-diffusion.git /opt/repositories/k-diffusion && \
    git clone https://github.com/sczhou/CodeFormer.git /opt/repositories/CodeFormer && \
    cd /opt/repositories/CodeFormer && rm -rf assets inputs && \
    git clone https://github.com/salesforce/BLIP.git /opt/repositories/BLIP && \
    git clone https://github.com/pharmapsychotic/clip-interrogator /opt/repositories/clip-interrogator

RUN --mount=type=cache,target=/root/.cache/download-extensions \
    mkdir /opt/extensions && \
    git clone https://github.com/Mikubill/sd-webui-controlnet.git /opt/extensions/sd-webui-controlnet && \
    git clone https://github.com/Uminosachi/sd-webui-inpaint-anything.git /opt/extensions/sd-webui-inpaint-anything && \
    git clone https://github.com/fkunn1326/openpose-editor.git /opt/extensions/openpose-editor


FROM rocm/pytorch:latest

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    PYTHONIOENCODING=UTF-8 \
    REQS_FILE='requirements.txt' \
    ROOT=/stable-diffusion-webui \
    CUDA_VERSION=gfx1030 \
    HF_HOME=/stable-diffusion-webui/.cache/huggingface \
    HSA_OVERRIDE_GFX_VERSION=10.3.0 \
    PYTORCH_HIP_ALLOC_CONF=garbage_collection_threshold:0.6,max_split_size_mb:128

RUN --mount=type=cache,target=/root/.cache/apt \
    apt-get update && apt-get install -y --no-install-recommends ffmpeg rsync && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

SHELL ["/bin/bash", "-c"]

COPY --from=builder /opt/stable-diffusion-webui ${ROOT}
COPY --from=builder /opt/repositories ${ROOT}/repositories
COPY --from=builder /opt/extensions ${ROOT}/extensions
#COPY --chown=1000:1000 --from=builder /opt/stable-diffusion-webui ${ROOT}
#COPY --chown=1000:1000 --from=builder /opt/repositories ${ROOT}/repositories
#COPY --chown=1000:1000 --from=builder /opt/extensions ${ROOT}/extensions

WORKDIR ${ROOT}

RUN --mount=type=cache,target=/root/.cache/pip \
    python -m pip install --upgrade pip wheel && \
    python -m pip install -r requirements_versions.txt && \
    python -m pip install -r ${ROOT}/repositories/CodeFormer/requirements.txt && \
    python -m pip install git+https://github.com/cloneofsimo/lora.git && \
    python -m pip install pytorch_lightning

COPY entrypoint.sh /entrypoint.sh

WORKDIR ${ROOT}
EXPOSE 7860

ENTRYPOINT ["bash", "/entrypoint.sh"]

CMD python launch.py --precision full --no-half --opt-sub-quad-attention
