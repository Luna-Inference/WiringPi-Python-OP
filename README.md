# WiringPi for Python

WiringPi: An implementation of most of the Arduino Wiring functions for the Raspberry Pi and Orange Pi boards

WiringPi implements new functions for managing IO expanders.

## Testing
Built and tested with gcc on ARM64/AARCH64 Linux systems
Supports Python 3.x

## Get/setup repo
```bash
git clone --recursive https://github.com/ThomasVuNguyen/WiringPi-Python-OP.git
cd WiringPi-Python-OP
```

## Prerequisites
To rebuild the bindings you **must** first have python-dev, python-setuptools and swig installed.

For Debian/Ubuntu-based systems:
```bash
sudo apt update
sudo apt install build-essential gcc g++  # generic compiler
# or for explicit cross-compiler name
sudo apt install gcc-aarch64-linux-gnu g++-aarch64-linux-gnu
sudo apt-get install python3-dev python3-setuptools swig
```

## Installation

### Option 1: Using the simplified build script (Recommended)

The build script automatically detects if you're in a virtual environment and installs accordingly:

```bash
# For global installation (requires sudo)
./build.sh

# OR for virtual environment installation
# First activate your virtual environment
python -m venv myenv  # Create a virtual environment if you don't have one
source myenv/bin/activate

# Then run the build script (no sudo needed)
./build.sh
```

### Option 2: Manual installation

#### First build the WiringPi C library (if not already done)
```bash
cd WiringPi
./build
cd ..
```

#### Generate Bindings
```bash
# Generate Python bindings with SWIG
swig -python -threads wiringpi.i
```

#### Build & install with

For global installation:
```bash
sudo python setup.py install
```

For virtual environment installation:
```bash
# First activate your virtual environment
source myenv/bin/activate
# Then install (no sudo needed)
python setup.py install
```

#### Testing your installation
```bash
# Simple test to verify installation
python -c "import wiringpi; print('WiringPi successfully installed!')"
```

#Class-based Usage
Description incoming!

##Usage

	import wiringpi
	
	wiringpi.wiringPiSetup() # For sequential pin numbering, one of these MUST be called before using IO functions
	# OR
	wiringpi.wiringPiSetupSys() # For /sys/class/gpio with GPIO pin numbering
	# OR
	wiringpi.wiringPiSetupGpio() # For GPIO pin numbering


Setting up IO expanders (This example was tested on a quick2wire board with one digital IO expansion board connected via I2C):

	wiringpi.mcp23017Setup(65,0x20)
	wiringpi.pinMode(65,1)
	wiringpi.digitalWrite(65,1)

**General IO:**

	wiringpi.pinMode(6,1) # Set pin 6 to 1 ( OUTPUT )
	wiringpi.digitalWrite(6,1) # Write 1 ( HIGH ) to pin 6
	wiringpi.digitalRead(6) # Read pin 6

**Setting up a peripheral:**
WiringPi2 supports expanding your range of available "pins" by setting up a port expander. The implementation details of
your port expander will be handled transparently, and you can write to the additional pins ( starting from PIN_OFFSET >= 64 )
as if they were normal pins on the Pi.

	wiringpi.mcp23017Setup(PIN_OFFSET,I2C_ADDR)

**Soft Tone**

Hook a speaker up to your Pi and generate music with softTone. Also useful for generating frequencies for other uses such as modulating A/C.

	wiringpi.softToneCreate(PIN)
	wiringpi.softToneWrite(PIN,FREQUENCY)

**Bit shifting:**

	wiringpi.shiftOut(1,2,0,123) # Shift out 123 (b1110110, byte 0-255) to data pin 1, clock pin 2

**Serial:**

	serial = wiringpi.serialOpen('/dev/ttyAMA0',9600) # Requires device/baud and returns an ID
	wiringpi.serialPuts(serial,"hello")
	wiringpi.serialClose(serial) # Pass in ID

**Full details at:**
http://www.wiringpi.com
