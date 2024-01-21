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
from glob import glob
from random import choice
from sys import path
from concurrent.futures import ThreadPoolExecutor

# Configuration
path.append("/home/firmanqs/.config/dmscripts/")
from config import dmenu, BACKGROUND_DIRERCTORY

commands = {
    "dmenu_sound" : ["ffplay", "-nodisp", "-autoexit", "/home/firmanqs/.config/sounds/menu-01.mp3"],
    "setbg_menu": ["printf", "Set\nRandom\nExit"],
    "run_sxiv": ["sxiv", "-t", "o", BACKGROUND_DIRERCTORY],
    "pywal_setclr": ["wal", "-i"],
    "xrdb_refresh": ["xdotool", "key", "Super+Shift+F5"],
    "setbg_random_opt": ["printf", "Yes\nNo"]
}


def main():
    '''
    The Main function
    '''
    with ThreadPoolExecutor(max_workers=2) as executor:
        future_decision = executor.submit(dmenu_run_get_input, commands["setbg_menu"])
        future_sound = executor.submit(dmenu_sound, commands["dmenu_sound"])
        # Wait for both tasks to complete
        decision = future_decision.result()
        future_sound.result()

    if decision == "Set":
        run(commands["run_sxiv"], check=False)
    elif decision == "Random":
        while True:
            image = [get_random_image(BACKGROUND_DIRERCTORY)]
            # run(commands["nitrogen_setbg"] + image, check=False)
            run(commands["pywal_setclr"] + image, check=False)
            run(commands["xrdb_refresh"], check=False)
            pick_another = dmenu_run_get_input(commands["setbg_random_opt"])
            if pick_another == "Yes":
                break


def dmenu_run_get_input(menu_setbg):
    '''
    main program to run menu sound and pipe the menu into dmenu
    '''
    setbg_menu = Popen(menu_setbg, stdout=PIPE)
    run_and_get_input = check_output(dmenu("Set Background"),
                                     stdin=setbg_menu.stdout, text=True)
    setbg_menu.stdout.close()
    user_action_input = re.search(r"(\w+)", run_and_get_input).group(1)
    return user_action_input


def get_random_image(directory):
    '''
    Get Random image from image_directory with type png and jpeg
    '''
    file_path_type = [f"{directory}/*.png", f"{directory}/*.jpeg"]
    images = glob(choice(file_path_type))
    # images = glob(f"{directory}/*")
    random_image = choice(images)
    return random_image


def dmenu_sound(command):
    '''sound'''
    Popen(command)

if __name__ == '__main__':
    try:
        main()
    except:
        print("User escape")
