#YAML_FILE=hello-esphome-esp32s3.yaml
PORT=/dev/ttyACM0
#PORT=/dev/ttyUSB0
#SERIAL_PORT?=/dev/cu.usbserial-14*

esp32-build:
	./dlab build --type esp32 esp32
esp32-run:
	./dlab shell -c "source ~/.bashrc && tmux new -As0" --docker-run-args="--device=$(PORT)" esp32

lab-run:
	./dlab shell -c "source ~/.bashrc && tmux new -As0" --docker-run-args="-p 1313:1313" lab
