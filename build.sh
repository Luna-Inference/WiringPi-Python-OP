#!/bin/bash

# Save the original directory
ORIGINAL_DIR=$(pwd)

# Check if swig is available
if ! command -v swig &> /dev/null; then
    echo "Error: SWIG is required but not found. Please install SWIG first."
    echo "Run: sudo apt-get install swig"
    exit 1
fi

# Save virtual env status before changing directory
VIRTENV_STATUS="$VIRTUAL_ENV"

# Generate Python bindings using SWIG directly from wiringpi.i template
echo "Generating Python bindings using SWIG..."
swig -python -threads wiringpi.i

# Ensure the generated file exists
if [ ! -f "wiringpi_wrap.c" ]; then
    echo "Error: wiringpi_wrap.c was not generated. SWIG wrapping failed."
    exit 1
fi

# Check if running in a virtual environment
if [ -n "$VIRTENV_STATUS" ]; then
    echo "Virtual environment detected: $VIRTENV_STATUS"
    echo "Installing WiringPi to the virtual environment..."
    
    # Use the Python from the virtual environment without sudo
    echo "Building and installing..."
    python setup.py build install
    
    # Verify installation by importing the module
    echo "Verifying installation..."
    cd "$ORIGINAL_DIR"
    
    # Try importing the wiringpi module to verify installation
    if python -c "import wiringpi; print('WiringPi successfully installed!')" 2>/dev/null; then
        echo "Installation to virtual environment completed successfully."
    else
        echo "Installation failed. WiringPi module could not be imported."
        echo "This might be because you're trying to import from the source directory."
        echo "Try importing wiringpi from a different directory."
        
        # Create a simple test script and run it
        echo "print('Testing wiringpi import from temp script...')" > /tmp/test_wiringpi.py
        echo "try:" >> /tmp/test_wiringpi.py
        echo "    import wiringpi" >> /tmp/test_wiringpi.py
        echo "    print('Success: wiringpi module imported!')" >> /tmp/test_wiringpi.py
        echo "except ImportError as e:" >> /tmp/test_wiringpi.py
        echo "    print(f'Error: {e}')" >> /tmp/test_wiringpi.py
        
        python /tmp/test_wiringpi.py
    fi
else
    echo "No virtual environment detected, installing globally (requires sudo)..."
    
    # Use sudo for global installation
    echo "Building and installing globally..."
    sudo python setup.py build install
    
    # Verify installation
    echo "Verifying installation..."
    cd "$ORIGINAL_DIR"
    
    # Try importing the wiringpi module to verify installation
    if python -c "import wiringpi; print('WiringPi successfully installed!')" 2>/dev/null; then
        echo "Global installation completed successfully."
    else
        echo "Installation failed. WiringPi module could not be imported."
        echo "This might be because you're trying to import from the source directory."
        echo "Try importing wiringpi from a different directory."
        
        # Create a simple test script and run it
        echo "print('Testing wiringpi import from temp script...')" > /tmp/test_wiringpi.py
        echo "try:" >> /tmp/test_wiringpi.py
        echo "    import wiringpi" >> /tmp/test_wiringpi.py
        echo "    print('Success: wiringpi module imported!')" >> /tmp/test_wiringpi.py
        echo "except ImportError as e:" >> /tmp/test_wiringpi.py
        echo "    print(f'Error: {e}')" >> /tmp/test_wiringpi.py
        
        sudo python /tmp/test_wiringpi.py
    fi
fi
