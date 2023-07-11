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

RUN --mount=type=cache,target=/root/.cache/sd-webui-controlnet \
    git clone https://github.com/Mikubill/sd-webui-controlnet.git /repositories/sd-webui-controlnet

RUN --mount=type=cache,target=/root/.cache/sd-webui-inpaint-anything \
    git clone https://github.com/Uminosachi/sd-webui-inpaint-anything.git /repositories/sd-webui-inpaint-anything

RUN --mount=type=cache,target=/root/.cache/openpose-editor \
    git clone https://github.com/fkunn1326/openpose-editor.git /repositories/openpose-editor

FROM rocm/pytorch:latest

LABEL maintainer="kristof.kamin@gmail.com"

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    PYTHONIOENCODING=UTF-8 \
    TORCH_COMMAND='pip install torch torchvision torchaudio --force-reinstall --extra-index-url https://download.pytorch.org/whl/rocm5.4.2' \
    REQS_FILE='requirements.txt' \
    ROOT=/stable-diffusion-webui \
    HSA_OVERRIDE_GFX_VERSION=10.3.0 \
    CUDA_VERSION=gfx1030 \
    HF_HOME=/stable-diffusion-webui/.cache/huggingface

SHELL ["/bin/bash", "-c"]

RUN --mount=type=cache,target=/root/.cache/apt \
    apt-get update && apt-get install rsync -y

RUN --mount=type=cache,target=/root/.cache/webui \
    git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git ${ROOT}

RUN mkdir -p ${HF_HOME}

COPY --from=download /repositories/ ${ROOT}/repositories/

RUN --mount=type=cache,target=/root/.cache/pip \
    cd ${ROOT} && \
    python -m venv venv && \
    source venv/bin/activate && \
    python -m pip install --upgrade pip wheel

RUN --mount=type=cache,target=/root/.cache/pip \
    cd ${ROOT} && \
    python -m venv venv && \
    source venv/bin/activate && \
    python -m ${TORCH_COMMAND}

RUN --mount=type=cache,target=/root/.cache/pip \
    cd ${ROOT} && \
    python -m venv venv && \
    source venv/bin/activate && \
    python -m pip install -r requirements_versions.txt

RUN --mount=type=cache,target=/root/.cache/pip \
    cd ${ROOT} && \
    python -m venv venv && \
    source venv/bin/activate && \
    python -m pip install -r ${ROOT}/repositories/CodeFormer/requirements.txt

RUN --mount=type=cache,target=/root/.cache/pip \
    cd ${ROOT} && \
    python -m venv venv && \
    source venv/bin/activate && \
    python -m pip install pytorch-triton-rocm==2.0.2

RUN --mount=type=cache,target=/root/.cache/pip \
    cd ${ROOT} && \
    python -m venv venv && \
    source venv/bin/activate && \
    python -m pip install git+https://github.com/cloneofsimo/lora.git

RUN --mount=type=cache,target=/root/.cache/extensions \
    mv ${ROOT}/repositories/sd-webui-controlnet ${ROOT}/extensions/ && \
    git config --global --add safe.directory /data/extensions/sd-webui-controlnet && \
    mv ${ROOT}/repositories/sd-webui-inpaint-anything ${ROOT}/extensions/ && \
    git config --global --add safe.directory /data/extensions/sd-webui-inpaint-anything && \
    mv ${ROOT}/repositories/openpose-editor ${ROOT}/extensions/ && \
    git config --global --add safe.directory /data/extensions/openpose-editor

#RUN --mount=type=cache,target=/root/.cache/bitsandbytes \
#    git clone https://git.ecker.tech/mrq/bitsandbytes-rocm.git /bitsandbytes-rocm && \
#    cd /bitsandbytes-rocm && \
#    make hip && \
#    python -m venv venv && \
#    source venv/bin/activate && \
#    python setup.py install

COPY scripts/entrypoint.sh /entrypoint.sh

WORKDIR ${ROOT}
EXPOSE 7860

ENTRYPOINT ["bash", "/entrypoint.sh"]

#VOLUME [ "/stable-diffusion-rocm/configs","/stable-diffusion-rocm/models", "/stable-diffusion-rocm/outputs","/stable-diffusion-rocm/extensions", "/stable-diffusion-rocm/plugins"]

CMD cd ${ROOT} && \
    python -m venv venv && \
    source venv/bin/activate && \
    python launch.py --precision full --no-half
