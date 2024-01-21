'''
------------------------------------------------------------------------------
author      = "github.com/firman-qs"
version     = "1.0.0"
date        = "16-08-2023"
------------------------------------------------------------------------------
'''

def dmenu(prompt):
    '''run dmenu'''
    dmenu_conf = ["dmenu", "-i",
             # "-l", "10",
             # "-g", "1",
             "-p", prompt]
    return dmenu_conf

BACKGROUND_DIRERCTORY = "/home/firmanqs/Pictures/wallpapers"

