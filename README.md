# Inside Job LTX-2.3 Workspace

This workspace is the main project repo for LTX-2.3 LoRA training.

Tracked here:
- training configs
- helper scripts
- run notes
- LoRA checkpoints via Git LFS
- dataset copies if you choose to version them

Not intended for Git tracking:
- base model weights in `models/`
- the upstream `LTX-2/` clone
- caches and temporary outputs

## Cheap Test Run

Expected local layout after cloning this repo:

```text
~/workspace/
├── LTX-2/
├── configs/
├── data/
├── models/
├── scripts/
└── runs/
```

Install the trainer dependencies from the LTX-2 repo:

```bash
cd ~/workspace/LTX-2
uv sync --frozen
```

Place the base assets here, or override the paths with environment variables:

```text
~/workspace/models/ltx23/model.safetensors
~/workspace/models/gemma/
```

Preprocess the copied dataset into LTX latents and text conditions:

```bash
cd ~/workspace
./scripts/preprocess.sh
```

Run the preflight check:

```bash
./scripts/validate_setup.sh test
```

Start the checkpoint pusher in another shell:

```bash
cd ~/workspace
nohup ./scripts/watch_and_push_checkpoints.sh test > ./logs/checkpoint_watcher.log 2>&1 &
```

Start the cheap 200-step test:

```bash
cd ~/workspace
./scripts/train_test.sh
```

For the full run later:

```bash
cd ~/workspace
./scripts/train_full.sh
```

## RTX 5090 Smoke Test

Use this profile only for a cheap setup test on a 32GB RTX 5090. It uses a smaller bucket, lower LoRA rank, INT8 quantization, 8-bit optimizer, and disabled validation.

```bash
cd ~/workspace
./scripts/preprocess_5090.sh
./scripts/validate_setup.sh 5090
nohup ./scripts/watch_and_push_checkpoints.sh 5090 > ./logs/checkpoint_watcher_5090.log 2>&1 &
./scripts/train_5090.sh
```
