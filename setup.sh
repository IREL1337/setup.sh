#!/bin/bash

# Nama paket untuk Python setup.py
PACKAGE_NAME="cyberchef-john-wireshark-tool"

# Buat setup.py
cat << EOF > setup.py
from setuptools import setup, find_packages

setup(
    name='$PACKAGE_NAME',
    version='1.0.0',
    description='A tool combining CyberChef, John the Ripper, and Wireshark with terminal-like interface.',
    packages=find_packages(),
    install_requires=[
        'prompt_toolkit',
    ],
    entry_points={
        'console_scripts': [
            'cyberchef_john_wireshark = main:main',
        ],
    },
)
EOF

# Perbarui paket dan instal dependencies
echo "Updating system packages and installing necessary tools..."
sudo apt-get update
sudo apt-get install -y python3 python3-pip john wireshark curl

# Jalankan pip untuk menginstal dependencies Python
echo "Installing Python dependencies via setup.py..."
pip3 install .

# Buat direktori proyek dan file Python yang diperlukan
mkdir -p $PACKAGE_NAME

# Buat main.py
cat << 'EOF' > main.py
from prompt_toolkit import PromptSession
from prompt_toolkit.completion import WordCompleter
from cyberchef import run_cyberchef
from john_the_ripper import run_john
from wireshark import run_wireshark

# Commands available in the tool
commands = {
    'cyberchef': run_cyberchef,
    'john': run_john,
    'wireshark': run_wireshark,
}

command_completer = WordCompleter(commands.keys(), ignore_case=True)

def main():
    session = PromptSession(completer=command_completer)
    while True:
        try:
            command = session.prompt('> ')
            command_parts = command.split()
            if not command_parts:
                continue
            
            cmd = command_parts[0]
            args = command_parts[1:]

            if cmd in commands:
                commands[cmd](args)
            else:
                print(f"Unknown command: {cmd}")
        except (KeyboardInterrupt, EOFError):
            print("Exiting...")
            break

if __name__ == "__main__":
    main()
EOF

# Buat cyberchef.py
cat << 'EOF' > cyberchef.py
import subprocess

def run_cyberchef(args):
    if not args:
        print("Please provide a command to run CyberChef.")
        return
    
    command = " ".join(args)
    print(f"Running CyberChef operation: {command}")
    # Simulasi panggilan CyberChef (CyberChef asli biasanya berbasis web)
    subprocess.run(["echo", "CyberChef command executed:", command])
EOF

# Buat john_the_ripper.py
cat << 'EOF' > john_the_ripper.py
import subprocess

def run_john(args):
    if not args:
        print("Please provide a file to crack with John the Ripper.")
        return
    
    command = ["john"] + args
    print(f"Running John the Ripper: {' '.join(command)}")
    subprocess.run(command)
EOF

# Buat wireshark.py
cat << 'EOF' > wireshark.py
import subprocess

def run_wireshark(args):
    if not args:
        print("Please provide a file to analyze with Wireshark.")
        return
    
    command = ["wireshark"] + args
    print(f"Running Wireshark: {' '.join(command)}")
    subprocess.run(command)
EOF

# Selesai
echo "Installation and setup complete. You can now run the tool using the command: cyberchef_john_wireshark"
