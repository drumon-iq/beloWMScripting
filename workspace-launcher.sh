#!/usr/bin/bash

#=== Default values ===

# Change each variable during call, instead of editing the script
# i.e $ textEditor="kitty -e vim" sh workspace-launcher.sh
# or $ textEditor="kitty -e nvim" menu="rofi -dmenu" sh workspace-launcher.sh

if [ -z ${textEditor} ]
then
    # This is the default text editor
    # can be any command that accepts the first argument as the file to edit
    textEditor="st -e nvim"
fi

if [ -z ${rootdir} ]
then
    # All my projects are in the Workspace directory
    # Another configuration could be HOME/Arduino for arduino projects
    rootdir="$HOME/Workspace/"
fi

if [ -z ${menu} ]
then
    # Using DMENU to filter the desired project
    # The way for selecting PROJ can be anything, fzf, rofi,
    # as long as the result is the name of the folder, no slash, i.e just "PROJECT"
    menu="dmenu"
fi

# Used for debugging and overall notifications for the user
if [ -z ${notify} ]
then
    notify=echo
fi

#=== Setting up enviroment ===

get_project_folder () {
    echo `ls ${rootdir} | ${menu}`
}

proj=$(get_project_folder)
projdir="${rootdir}${proj}"

if [ -z ${proj} ]; then
    ${notify} Nothing was selected, bailing oooout
    exit
fi

if ! [ -d ${projdir} ]
then
    ans=$(echo "no\nyes" | dmenu -p "${proj} wasn\'t found, create project?")
    if [ ${ans} = "yes" ]
    then
	mkdir -p ${projdir}
    else
	${notify} Leaving as no project was selected
	exit
    fi
fi

wfsetup="${rootdir}.workflow-setups"
projsetup="${wfsetup}/${proj}"

if ! [ -d ${wfsetup} ]; then
    mkdir -p ${wfsetup}
fi

template_setup () {
    echo "#!/usr/bin/bash" >> ${projsetup}/text-editor
    echo ${textEditor} >> ${projsetup}/text-editor
}

if ! [ -d ${projsetup} ]; then
    mkdir -p ${projsetup}
    template_setup
fi

cd ${projdir}

if [ -z $(ls ${projsetup}) ]; then
    ${notify} nothing to do, bailing out
    exit
fi

#=== Launching applications for project ===

# Inside the setup folder for each project
# lies a bunch of simple scripts and executables
# the order for ls is alphabetical, and dwm sets the last
# application as the master, so I edit the setup to make
# the main window (like the text editor) the last to be executed

for i in $(ls ${projsetup}); do
    setsid bash ${projsetup}/$i & > /dev/null
done
