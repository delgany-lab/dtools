# Building ESP32 development image

Make sure you have `docker` and `docker-buildx` installed:

```
sudo pacman -S docker docker-buildx
```

`docker-buildx` is needed for building Dockerfile targes with dependent stages only.

To quickly build ESP development docker image just run:
```bash
make esp32
```

# Run Hello World

Connect your ESP development board e.g. `ESP32-H2-DevKitM-1` to your computer. `/dev/ttyUSB0` should become available.

Enter ESP docker:

```bash
make run-esp32
```

Once inside, copy and build example hello_world from ESP examples:
```bash
cp -R $IDF_PATH/examples/get-started/hello_world/ .
cd hello_world
idf.py set-target esp32-h2
idf.py build
```

After successfull build flash the board:

```
idf.py -p /dev/ttyUSB0 flash
```

Monitor board's output:

```
idf.py monitor
```
