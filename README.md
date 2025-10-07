🌐 Available in: [English](README.md) | [Português BR](README.pt-br.md)

# PiFluidDisplay

### Turn any Raspberry Pi into a universal and intelligent wireless secondary screen.

Welcome to PiFluidDisplay! This open-source project transforms a Raspberry Pi (any model works) and a monitor into a robust and flexible VNC screen receiver. It is designed to be controlled by any device on the network, allowing you to mirror your Android phone's screen or a Windows, Linux, or macOS computer.

## ✨ Key Features

* **"Zero-Touch" Automatic Installation:** Set up your Raspberry Pi just once. Simply copy the files to the SD card, and the Pi will install and configure itself on the first boot.
* **Intelligent Waiting Screen:** When idle, the Pi displays a customizable status screen with useful information like the screen name, IP address, and hostname, making it easy to connect.
* **Stable Architecture ("Single X Session"):** The Pi's graphical environment is started only once at boot and is never shut down. The system just switches between the waiting screen and the VNC client, avoiding constant video driver restarts, which ensures maximum stability.
* **Universal Receiver:** Designed to receive connections from multiple operating systems. Ready-to-use control scripts for **Windows** and **Android (Termux)** are included.
* **Recovery Mechanism:** If something goes wrong during installation, simply create an empty `reinstall.txt` file on the SD card and reboot the Pi for an automatic factory reset.

## 🏛️ The Concept: Universal Receiver

The philosophy of PiFluidDisplay is simple: the **Raspberry Pi is a passive, intelligent receiver**. It doesn't care where the signal comes from, as long as the "controller" device can do two things:

1.  **Run a VNC server:** To stream the screen's image.
2.  **Send an SSH command:** To "wake up" the Pi and tell it to connect.

This means **any operating system** can become a controller.

* **Windows:** Yes ( `.bat` script provided).
* **Android:** Yes (shell script for Termux provided).
* **macOS or another Linux PC:** Yes. The architecture is the same: just have a VNC server running and send the appropriate SSH command to the Pi, instructing it to connect to your IP.

Example command for a Linux/macOS controller:
```bash
ssh -t pi@<PI_IP_ADDRESS> "/home/pi/pi-fluid-display/pfd-connect.sh '<YOUR_PC_IP>'"
```

---

## 🚀 Installation and Usage Guide

### **Part 1: The Receiver (Raspberry Pi Setup)**

This setup is done only once.

#### **Prerequisites:**
* A Raspberry Pi (any model with Wi-Fi/Ethernet).
* A MicroSD card (8GB or more).
* A monitor.
* A power supply.

#### **Automatic Installation Instructions:**

1.  **Flash the OS Image:** Use the "Raspberry Pi Imager" to flash the latest image of **Raspberry Pi OS Lite** (32-bit or 64-bit) to the SD card.
    * **Tip:** In the Imager's advanced options (gear icon ⚙️), you can pre-configure your Wi-Fi network, enable SSH, and set a password for the `pi` user, which simplifies the process.

2.  **Copy the Project Files:** After flashing, the `boot` (or `bootfs`) partition will appear on your computer.
    * Within this partition, create a new folder named `pi-fluid-display`.
    * Copy the contents of the `raspberry-pi` folder from this repository (`install.sh`, `pfd-config.txt.template`, and the `files` folder) into the `pi-fluid-display` folder you just created.

3.  **Customize Your Device (Optional, but Recommended):**
    * Inside the `pi-fluid-display` folder on the card, rename the `pfd-config.txt.template` file to `pfd-config.txt`.
    * Open `pfd-config.txt` with a text editor and set a `DISPLAY_NAME` (friendly name) and a `HOSTNAME` (network name) for your screen.

4.  **Enable the Automatic Installer:**
    * In the root of the `boot` partition, find and open the `cmdline.txt` file.
    * Go to the end of the single long line and add the following text (leave a space before it):
        ```
        init=/boot/pi-fluid-display/install.sh
        ```

5.  **Start the Pi:** Safely eject the SD card, insert it into the Raspberry Pi, and power it on.
    * The first boot will take longer (a few minutes). The `install.sh` script will run, install all dependencies, configure the services, and automatically reboot the Pi.
    * After the second boot, your custom waiting screen will appear. **Your PiFluidDisplay is ready!**

---

### **Part 2: The Controllers**

#### **Windows Controller**

1.  **Dependencies (one-time setup):**
    * **VNC Server:** Install **UltraVNC Server**. Configure it to run as an automatic service, with **no password**, and (important!) streaming only your **main monitor**. This is done in the UltraVNC "Admin Properties".
    * **SSH Client:** Download the `plink.exe` program from the official [PuTTY](https://putty.org) website and place it in the same folder where you will save the `pfd-manager.bat` script.
2.  **Usage:**
    * Run the `pfd-manager.bat` script. It will ask for the Pi's IP and password. For a "one-click" connection, edit the `.bat` file and fill in the variables at the top.

#### **Android Controller (Termux)**

1.  **Dependencies (one-time setup):**
    * **VNC Server:** Install a VNC Server app from the Play Store (e.g., "droidVNC-NG") and start it, configuring it for access with **no password**.
    * **Termux:** Install Termux and, inside it, the `openssh` and `sshpass` packages with the command: `pkg install openssh sshpass`.
2.  **Usage:**
    * Copy the `pfd-manager.sh` script to any folder in your Termux home directory.
    * Edit the variables at the top or leave them blank for the script to ask.
    * Run the script in Termux (e.g., `$ ./pfd-manager.sh`).

---

### 🔧 Troubleshooting

* **Installation Failed:** Check the `pfd-install-log.txt` log file on the `boot` partition of the SD card for error messages.
* **Waiting Screen Does Not Appear:** Connect via SSH and check the service status with `sudo systemctl status idle-screen.service`.
* **Factory Reset:** Create an empty file named `reinstall.txt` on the `boot` partition (usually at: "/boot/firmware") of the SD card and reboot the Pi.

---

## 👤 About the Author

Developed by [Rodrigo Lemos](https://linkedin.com/in/irlemos)

💻 **Extensive experience in software development, integrations, and complex solutions**
With vast experience in multiple programming languages, platforms, and scalable projects.

---

## 📜 License

This is a demonstration project and is part of my professional portfolio.
Commercial use of this architecture requires prior authorization.
