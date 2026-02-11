---
title: "Add nvidia runtime to docker runtimes"
source: "https://stackoverflow.com/questions/59008295/add-nvidia-runtime-to-docker-runtimes"
author:
  - "[[evaleria                    1]]"
  - "[[44166 gold badges2525 silver badges3131 bronze badges]]"
  - "[[Robert Crovella–                         Robert Crovella]]"
  - "[[sema–                         sema]]"
  - "[[Viacheslav Shalamov                    4]]"
  - "[[50788 gold badges5252 silver badges7171 bronze badges]]"
  - "[[Victor K Victor K Over a year ago]]"
  - "[[Neil Borromeo                    11711 silver badge44 bronze badges]]"
published: 2019-11-23
created: 2026-02-09
description: "I’m running a virtual vachine on GCP with a tesla GPU. And try to deploy a PyTorch-based app to accelerate it with GPU.I want to make docker use this GPU, have access to it from containers.I m..."
tags:
  - "clippings"
---
25

This question does not show any research effort; it is unclear or not useful

Save this question.Show activity on this post.

I’m running a virtual vachine on `GCP` with a tesla GPU. And try to deploy a `PyTorch`\-based app to accelerate it with GPU.

**I want to make docker use this GPU, have access to it from containers.**

I managed to install all drivers on host machine, and the app runs fine there, but when I try to run it in docker (based on nvidia/cuda container) pytorch fails:

```
File "/usr/local/lib/python3.6/dist-packages/torch/cuda/__init__.py", line 82, 
in _check_driver http://www.nvidia.com/Download/index.aspx""")
AssertionError: 
Found no NVIDIA driver on your system. Please check that you have an NVIDIA GPU and installed a driver from
```

To get some info about nvidia drivers visible to the container, I run this:

`docker run --runtime=nvidia --rm nvidia/cuda nvidia-smi`  
But it complains: `docker: Error response from daemon: Unknown runtime specified nvidia.`

On the host machine `nvidia-smi` output looks like this:

```
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 440.33.01    Driver Version: 440.33.01    CUDA Version: 10.2     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|===============================+======================+======================|
|   0  Tesla P100-PCIE...  On   | 00000000:00:04.0 Off |                    0 |
| N/A   39C    P0    35W / 250W |    873MiB / 16280MiB |      0%      Default |
+-------------------------------+----------------------+----------------------+
```

If I check my runtimes in docker, I get only `runc` runtime, no `nvidia` as in examples around the internet.

```
$ docker info|grep -i runtime
 Runtimes: runc
 Default Runtime: runc
```

**How can I add this `nvidia` runtime environment to my docker?**

Most posts and questions I found so far say something like "I just forgot to restart my docker daemon, it worked", but it does not help me. Whot should I do?

I checked many issues on github, and [#1](https://stackoverflow.com/questions/57957491/nvidia-docker-unknown-runtime-specified-nvidia), [#2](https://stackoverflow.com/questions/52865988/nvidia-docker-unknown-runtime-specified-nvidia) and [#3](https://stackoverflow.com/questions/50364031/cant-execute-nvidia-runtime-on-docker) StackOverflow questions - didn't help.

## Answer

The `nvidia` runtime you need, is `nvidia-container-runtime`.

Follow the installation instructions here:  
[https://github.com/NVIDIA/nvidia-container-runtime#installation](https://github.com/NVIDIA/nvidia-container-runtime#installation)

Basically, you install it with your package manager first, if it's not present:

`sudo apt-get install nvidia-container-runtime`

Then you add it to docker runtimes:  
[https://github.com/nvidia/nvidia-container-runtime#daemon-configuration-file](https://github.com/nvidia/nvidia-container-runtime#daemon-configuration-file)

This option worked for me:

```
$ sudo tee /etc/docker/daemon.json <<EOF
{
    "runtimes": {
        "nvidia": {
            "path": "/usr/bin/nvidia-container-runtime",
            "runtimeArgs": []
        }
    }
}
EOF
sudo pkill -SIGHUP dockerd
```

Check that it's added:

```
$ docker info|grep -i runtime
 Runtimes: nvidia runc
 Default Runtime: runc
```