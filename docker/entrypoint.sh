#!/bin/bash

declare -A MOUNTS
MOUNTS["/stable-diffusion-webui/outputs"]="/data/outputs"
MOUNTS["/stable-diffusion-webui/models"]="/data/models"
MOUNTS["/stable-diffusion-webui/embeddings"]="/data/embeddings"
MOUNTS["/stable-diffusion-webui/extensions"]="/data/extensions"

for sd_path in "${!MOUNTS[@]}"; do
  set -Eeuo pipefail
  data_path="${MOUNTS[${sd_path}]}"

  # check if /data/* exists
  if [ ! -d "${data_path}" ]; then
    mkdir -vp "${data_path}"
  fi

  # copy everything from stable-diffusion-web into data folder
  if [ -d "${sd_path}" ]; then
    rsync -r "${sd_path}" "/data/"
    rm -rf "${sd_path}"
  fi

  # create symlink
  if [ ! -L "${sd_path}" ]; then
    ln -sT "${data_path}" "${sd_path}"
  fi

  # add directory to git
  for d in ${data_path}/* ; do
    if [ -d "${d}" ] && [ -d "${d}/.git" ]; then
      git config --global --add safe.directory $d
    fi
  done

  chown -R jenkins:jenkins ${data_path}
done

exec "$@"