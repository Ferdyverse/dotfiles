#!/bin/bash

echo "Removing files and folders"
rm -rf config/git/*
rm -rf config/gnome/*
rm -rf config/scripts/backup_script.conf
rm -rf config/ssh/*
rm -rf config/zsh/alias
rm -rf config/zsh/zshrc.work

echo "Add keep files"
touch config/git/.gitkeep
touch config/gnome/.gitkeep
touch config/ssh/.gitkeep