#!/usr/bin/env python3
# ------------------------------------------------------------------------------
__author__      = "github.com/firman-qs"
__version__     = "1.0.0"
__date__        = "16-08-2023"
# ------------------------------------------------------------------------------

import argparse
import re
import sys
import subprocess
sys.path.append("/home/fqs/.cache/wal/")
import python_pywal as pp

ncolor = f"""-h string:bgcolor:{pp.colors[0]} -h string:fgcolor:{pp.colors[7]}
 -h string:frcolor:{pp.colors[7]}"""

def send_notification():
    '''Send Notification'''
    # Brightness information
    brightnessctl_output = subprocess.check_output(["brightnessctl", "info"], text=True)
    brightnessctl_value = re.search(r"(\d+)%", brightnessctl_output).group(1)
    brightnessctl_device = re.search(r"'(\w+)'", brightnessctl_output).group(1)
    # the icon used on notification
    icon = f"~/.config/dunst/icons/vol/vol-{brightnessctl_value}.svg"
    # send notification if brightness neq 0
    if brightnessctl_value != 0:
        subprocess.run([
            "dunstify",
            "-h", f"string:bgcolor:{pp.colors[0]}",
            "-h", f"string:fgcolor:{pp.colors[7]}",
            "-h", f"string:frcolor:{pp.colors[7]}",
            "brightctl",
            "-i", icon,
            "-a", f"{brightnessctl_value}",
            f"Device: {brightnessctl_device}",
            "-r", "91190",
            "-t", "800"],
                       check=False)

def main():
    '''The Main Gate of Controlling Brightness'''
    parser = argparse.ArgumentParser(description="Adjust brightness")
    parser.add_argument("-i", "--increase", nargs="?", const="+5%", metavar="+VALUE%",
                        help="Increase brightness by +VALUE%% (default: +5%%)")
    parser.add_argument("-d", "--decrease", nargs="?", const="5%-", metavar="VALUE%-",
                        help="Decrease brightness by -VALUE%% (default: 5%%-)")
    args = parser.parse_args()
    print(args)
    if args.increase is not None:
        subprocess.run(["brightnessctl", "set", args.increase], check=False)
    elif args.decrease is not None:
        subprocess.run(["brightnessctl", "set", args.decrease], check=False)

    send_notification()

main()
