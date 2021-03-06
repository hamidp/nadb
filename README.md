# Nadb

A nicer interface to adb. 

*  ``nadb -n n5`` instead of ``adb -s aja98jfao8ejfao``
*  ``nadb -i 1`` instead of ``adb -s aja98jfao8ejfao``
*  ``nadb --all`` insated of running the adb command on every single device

Anything else gets passed along to ``adb`` so you can use it as a straight up replacement.

```
Usage: nadb [options] command

Options:
        --all                        Run command on all connected devices
    -n, --name NAME                  Name of device to run from
    -i, --index INDEX                The index of the target device in the adb devices output
    -h, --help                       Display this screen
```

## Installation

``gem install nadb``

## Upcoming features

*  ``-p`` or ``--pick`` for an interactive picker
*  alias add/remove commands so you don't have to edit the config file yourself
*  More better device display

## Defining aliases

Simply create a ``~/.nadb.config`` file with contents like these:

```
{
        "aliases": {
                "n5": "serial from adb output"
        }
}
```
