import datetime
import subprocess
import time
from functools import lru_cache

import gi
import psutil
from fabric.utils import cooldown, exec_shell_command, exec_shell_command_async
from gi.repository import Gdk, GdkPixbuf, Gio, GLib, Gtk


# Function to get the percentage of a value
def convert_to_percent(
    current: int | float, max: int | float, is_int=True
) -> int | float:
    if max == 0:
        return 0
    if is_int:
        return int((current / max) * 100)
    else:
        return (current / max) * 100


# Function to format time in hours and minutes
def format_seconds_to_hours_minutes(secs: int):
    mm, _ = divmod(secs, 60)
    hh, mm = divmod(mm, 60)
    return "%d h %02d min" % (hh, mm)


# Function to ttl lru cache
def ttl_lru_cache(seconds_to_live: int, maxsize: int = 128):
    def wrapper(func):
        @lru_cache(maxsize)
        def inner(__ttl, *args, **kwargs):
            return func(*args, **kwargs)

        return lambda *args, **kwargs: inner(
            time.time() // seconds_to_live, *args, **kwargs
        )

    return wrapper


@ttl_lru_cache(600, 10)
def check_executable_exists(executable_name):
    executable_path = GLib.find_program_in_path(executable_name)
    if not executable_path:
        raise ImportError(f"{executable_name} not installed")


# Function to get the system uptime
def uptime():
    boot_time = psutil.boot_time()
    now = datetime.now()

    diff = now.timestamp() - boot_time

    # Convert the difference in seconds to hours and minutes
    hours, remainder = divmod(diff, 3600)
    minutes, _ = divmod(remainder, 60)

    return f"{int(hours):02}:{int(minutes):02}"


# Function to check if an app is running
def is_app_running(app_name: str) -> bool:
    return len(exec_shell_command(f"pidof {app_name}")) != 0


# Function to play sound
@cooldown(1)
def play_sound(file: str):
    exec_shell_command_async(f"pw-play {file}", lambda *_: None)
    return True


# Function to toggle a shell command
def toggle_command(command: str, full_command: str):
    if is_app_running(command):
        kill_process(command)
    else:
        subprocess.Popen(
            full_command.split(" "),
            stdin=subprocess.DEVNULL,  # No input stream
            stdout=subprocess.DEVNULL,  # Optionally discard the output
            stderr=subprocess.DEVNULL,  # Optionally discard the error output
            start_new_session=True,  # This prevents the process from being killed
        )


## Function to kill a shell command asynchronously
def kill_process(process_name: str):
    exec_shell_command_async(f"pkill {process_name}", lambda *_: None)
    return True
