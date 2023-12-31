#!/usr/bin/env python3
'''
------------------------------------------------------------------------------
author      = "github.com/firman-qs"
version     = "1.0.0"
date        = "16-08-2023"
------------------------------------------------------------------------------
'''
import re
from subprocess import PIPE, Popen, check_output, run
from sys import path
from concurrent.futures import ThreadPoolExecutor

# Configuration
path.append("/home/firmanqs/.config/dmscripts/")
from config import dmenu

def main():
    '''test'''
    commands = {
        "dmenu_sound" : ["ffplay", "-nodisp", "-autoexit", "/home/fqs/.config/sounds/menu-01.mp3"],
        "logout_menu" : ["printf", "Lock Screen\nLogout\nReboot\nShutdown\nSuspend\nQuit"],
        "confirm" : ["printf", "Yes\nNo"]
    }
    with ThreadPoolExecutor(max_workers=2) as executor:
        future_decision = executor.submit(dmenu_run, commands["logout_menu"])
        future_sound = executor.submit(dmenu_sound, commands["dmenu_sound"])
        # Wait for both tasks to complete
        decision = future_decision.result()
        future_sound.result()
    actions(decision, commands["confirm"])

def actions(decision, confirmation):
    '''
    this type of switch case on python work for 3.10 or above, otherwise use if
    elif statement.
    '''
    match decision:
        case "Lock Screen":
            if dmenu_run(confirmation) == "Yes":
                run(["slock"], check=False)
        case "Logout":
            if dmenu_run(confirmation) == "Yes":
                run(["pkill", "dwm"], check=False)
                # run(["slock"], check=False)
        case "Reboot":
            if dmenu_run(confirmation) == "Yes":
                return "two"
        case "Shutdown":
            if dmenu_run(confirmation) == "Yes":
                run(["systemctl", "poweroff"], check=False)
        case "Suspend":
            if dmenu_run(confirmation) == "Yes":
                return "four"
        case "Quit":
            if dmenu_run(confirmation) == "Yes":
                return "five"
        case _:
            return "Exit case return 0"

def dmenu_run(command):
    '''
    main program to run menu sound and pipe the menu into dmenu
    '''
    logout_menu = Popen(command, stdout=PIPE)
    run_and_get_input = check_output(dmenu("Logout:"),
                                     stdin=logout_menu.stdout, text=True)
    logout_menu.stdout.close()
    user_input = re.search(r"(\w+(\s\w+)*)\n", run_and_get_input).group(1)
    return user_input


def dmenu_sound(command):
    '''sound'''
    Popen(command)


if __name__ == '__main__':
    main()
