# MOSS Image Universal — RunPod Serverless ComfyUI worker (MOSS Image models)
# Build on RunPod from your own PRIVATE copy of this repo (Dockerfile path = Dockerfile, build context = .).
# The build steps are downloaded from the original repo, so you never need to edit anything but these two lines (and the optional LORAS line).

# Cobalt Pear users: skip these two lines — the app's «Add your token» link puts both in a file civitai.env instead.
# >>> Put your Civitai API token here (civitai.com → Account settings → Security & Apps → API Keys). Keep your repo PRIVATE.
#     Not needed for a Hugging Face model. <<<
ARG CIVITAI_TOKEN=PASTE_YOUR_CIVITAI_TOKEN_HERE
# >>> Put the model's Civitai page link here (or just its version number, e.g. 3443487), or its Hugging Face link. <<<
ARG CIVITAI_MODEL=PASTE_THE_MODEL_LINK_HERE

# >>> Optional — LoRAs built into the worker (each picture picks which to use): Civitai or Hugging Face links, each followed by
#     its strength (1 when left out), separated by spaces. Leave it empty for none. Example:
#     ARG LORAS="https://civitai.com/models/12345 0.8 https://huggingface.co/user/some-lora 0.6"   <<<
ARG LORAS=""

FROM runpod/worker-comfyui:5.10.0-base
ARG LORAS
ARG CIVITAI_TOKEN
ARG CIVITAI_MODEL
COPY . /setup/
ADD https://github.com/cobaltpear/civitai-moss/releases/latest/download/build.sh /build.sh
ADD https://github.com/cobaltpear/civitai-moss/releases/latest/download/handler.py /handler.py
RUN CIVITAI_TOKEN="$CIVITAI_TOKEN" CIVITAI_MODEL="$CIVITAI_MODEL" sh /build.sh && python /handler.py --bake-loras && rm -rf /setup
