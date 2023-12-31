#!/usr/bin/env python3
'''
------------------------------------------------------------------------------
author      = "github.com/firman-qs"
version     = "1.0.0"
date        = "16-08-2023"
------------------------------------------------------------------------------
'''
from subprocess import Popen

command_list = [
    # run menu sound
    ["ffplay", "-nodisp", "-autoexit", "/home/fqs/.config/sounds/menu-01.mp3"],
    # run dmenu with pywal colors
    ["dmenu_run", "-p", "Run"]
]

process_list = [Popen(command) for command in command_list]
for process in process_list:
    process.wait()
