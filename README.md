# GRE Tunnel for [Pterodactyl](https://pterodactyl.io/)

Scripts that allows you to create a tunnel between two remote machines to protect the target server.

## Requirements

For Debian/Ubuntu distro

```bash
sudo apt install iptables iproute2
```

For Red Hat distro

```bash
sudo yum install iptables iproute2
```

## Installation

Download files called:
```bash
prot_side.sh
```
and
```bash
back_side.sh
```

```prot_side.sh``` put in your protected VPS

```back_side.sh``` put in VPS you want to protect

## Configuration

On the top of this two files you need to change this two lines.
```bash
PROTECTED_IP="XX.XX.XXX.XXX"

BACKEND_IP="XX.XX.XXX.XXX"
```
In the 
```PROTECTED_IP``` set your protected VPS IP

In
```BACKEND_IP``` set your VPS IP that you want to protect

## Usage

After configuration you can start the GRE Tunnel

On Protected VPS run:

```
chmod +x /root/prot_side.sh
./prot_side.sh
```

On VPS you want to protect run:

```
chmod +x /root/back_side.sh
./back_side.sh
```

After that you can test the connection, on your Protected VPS type ```ping 10.0.0.2```
If you get replies, it means everything is working

#Note:
Backend VPS can be accessed by ```10.0.0.2``` IP

## License

[CC Attribution-Share Alike 4.0 International](https://creativecommons.org/licenses/by-sa/4.0/deed.en)
