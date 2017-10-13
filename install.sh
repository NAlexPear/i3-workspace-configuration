#! /bin/bash

# Handles dependencies for Arch through Pacman and pip

if [[ -z $(which python 2> /dev/null) ]]; then
  echo "No python found! Installing...";

  sudo pacman -S python;
fi

if [[ -z $(which pip 2> /dev/null) ]]; then
  echo "No pip found! Installing...";

  sudo pacman -S python-pip;
fi

if [[ -z $(pip freeze | grep i3-py) ]]; then
  echo "No i3 module found! Installing...";

  pip install i3-py;
fi
