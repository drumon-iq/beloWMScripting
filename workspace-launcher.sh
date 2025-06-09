#!/usr/bin/bash
# TODO: Add a way to use this file for more than just Workspace projects, to edit documents and stuff

# Used for debugging and overall notifications for the user
# Currently only prints to stdout
msg_notify () {
    echo $@
}

# All my projects are in the Workspace directory
# Another configuration could be HOME/Arduino for arduino projects
rootdir="$HOME/Workspace/"

# Using DMENU to filter the desired project
# The way for selecting PROJ can be anything, fzf, rofi,
# as long as the result is the name of the folder, no slash, i.e just "PROJECT"
get_project_folder () {
    echo `ls $rootdir | dmenu`
}

proj=$(get_project_folder)
if [ -z ${proj} ]; then
    msg_notify Nothing was selected, bailing oooout
    exit
fi

projdir="${rootdir}${proj}"
wfsetup="${rootdir}.workflow-setups"
projsetup="${wfsetup}/${proj}"

if ! [ -d ${wfsetup} ]; then
    mkdir -p ${wfsetup}
fi

template_setup () {
    echo "#!/usr/bin/bash" >> ${projsetup}/text-editor
    echo "st -e nvim" >> ${projsetup}/text-editor
}

if ! [ -d ${projsetup} ]; then
    mkdir -p ${projsetup}
    template_setup
fi

cd ${projdir}

if [ -z $(ls ${projsetup}) ]; then
    echo nothing to do, bailing out
    exit
fi

# Inside the setup folder for each project
# lies a bunch of simple scripts and executables
# the order for ls is alphabetical, and dwm sets the last
# application as the master, so I edit the setup to make
# the main window (like the text editor) the last to be executed

for i in $(ls ${projsetup}); do
    setsid bash ${projsetup}/$i & > /dev/null
done
