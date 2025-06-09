#!/usr/bin/python
from os import popen as run
from os.path import exists
from pathlib import Path as path
from yaml import safe_load_all, dump_all

config_folder = str(path.home()) + "/.config/"
config_file  = config_folder + "belosMacros.yaml"

if not exists(config_folder):
    os.makedirs(config_path)

"""
    Creates bare minimum configuration file if it's not found,
    the first yaml file (before the ---) defines some configuration for this script,
        right now, the only configuration is which application should be used as a menu
    the second part has the user defined macros,
        in this case, the bare minimum is a macro to open a text editor to the configuration file itself
"""
if not exists(config_file):
    with open(config_file, 'w') as buffer:
        config_macro = f'st -e nvim {config_file}'
        menu = 'dmenu'
        macro_config = [{'menu': menu}, {'macro_config': config_macro}]
        dump_all(macro_config, buffer)

# Won't think about things going wrong, take care of yourself
with open(config_file, 'r') as stream:
    loaded_stream = list(safe_load_all(stream))
    configs = loaded_stream[0]
    user_macros = loaded_stream[1]

if __name__ == "__main__":
    macro_name = str()
    for key in user_macros:
        macro_name += str(key)+'\n'

    run_macro = run (f"echo \"{macro_name}\" | {configs['menu']}").read().replace('\n', '')

    if run_macro in user_macros:
        run (user_macros[run_macro])
