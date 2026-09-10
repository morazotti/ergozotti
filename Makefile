.PHONY: all update clean build copy

all: clean build copy 

init:
	docker run --rm -v $(PWD):/workdir -w /workdir zmkfirmware/zmk-dev-arm:3.5 bash -c "west init -l config"

update:
	docker run --rm -v $(PWD):/workdir -w /workdir zmkfirmware/zmk-dev-arm:3.5 bash -c "west update"

clean:
	docker run --rm -v $(PWD):/workdir -w /workdir zmkfirmware/zmk-dev-arm:3.5 bash -c "\
		rm -rf build/*"
	mkdir -p firmware
	rm -rf firmware/*


build:
	docker run --rm -v $(PWD):/workdir -w /workdir zmkfirmware/zmk-dev-arm:3.5 bash -c "\
		west zephyr-export && \
		west build -s zmk/app -d build/ergonaut_one_left -b xiao_ble//zmk -S studio-rpc-usb-uart -- -DZMK_CONFIG=/workdir/config -DSHIELD=ergonaut_one_left && \
		west build -s zmk/app -d build/ergonaut_one_right -b xiao_ble//zmk -- -DZMK_CONFIG=/workdir/config -DSHIELD=ergonaut_one_right && \
		west build -s zmk/app -d build/settings_reset -b xiao_ble//zmk -- -DSHIELD=settings_reset"

copy:
	cp build/ergonaut_one_left/zephyr/zmk.uf2 firmware/ergonaut_one_left.uf2
	cp build/ergonaut_one_right/zephyr/zmk.uf2 firmware/ergonaut_one_right.uf2
	cp build/settings_reset/zephyr/zmk.uf2 firmware/settings_reset.uf2
