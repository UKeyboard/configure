# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi


# set LOCALE so tensorflow can work perfectly
if [ -z "$LC_ALL" ]; then
  LANG="en_US.UTF-8"
  LANGUAGE="en_US:en"
  LC_CTYPE="en_US.UTF-8"
  LC_NUMERIC="en_US.UTF-8"
  LC_TIME="en_US.UTF-8"
  LC_COLLATE="en_US.UTF-8"
  LC_MONETARY="en_US.UTF-8"
  LC_MESSAGES="en_US.UTF-8"
  LC_PAPER="en_US.UTF-8"
  LC_NAME="en_US.UTF-8"
  LC_ADDRESS="en_US.UTF-8"
  LC_TELEPHONE="en_US.UTF-8"
  LC_MEASUREMENT="en_US.UTF-8"
  LC_IDENTIFICATION="en_US.UTF-8"
  LC_ALL="en_US.UTF-8"
fi

###
SYS_PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games"
USR_PATH="$PATH"
EXTRA_PATH=""
EXTRA_LD_LIBRARY_PATH=""
SHARE_PREFIX="/home/share"

# set PATH&LD_LIBRARY_PATH so they include CUDA
# priority: system > shared > local
if ! [ -x "$(command -v nvcc)" ]; then
  if [ -z "$CUDA_VERSION" ]; then CUDA_VERSION=9.0; fi # set the CUDA version, default 9.0
  if [ -d "$SHARE_PREFIX/cuda/cuda-$CUDA_VERSION" ]; then
    EXTRA_PATH="$SHARE_PREFIX/cuda/cuda-$CUDA_VERSION/bin:$EXTRA_PATH"
    EXTRA_LD_LIBRARY_PATH="$SHARE_PREFIX/cuda/cuda-$CUDA_VERSION/lib64:$EXTRA_LD_LIBRARY_PATH"
  elif [ -d "$HOME/.local/cuda-$CUDA_VERSION" ]; then
    EXTRA_PATH="$HOME/.local/cuda-$CUDA_VERSION/bin:$EXTRA_PATH"
    EXTRA_LD_LIBRARY_PATH="$HOME/.local/cuda-$CUDA_VERSION/lib64:$EXTRA_LD_LIBRARY_PATH"
  fi
  unset CUDA_VERSION
fi

# set PATH so it include conda
# priority: system > shared > local
if [ -z "$(command -v conda)" ]; then
  if [ -z "$CONDA_BRANCH" ]; then CONDA_BRANCH=3; fi # set the conda branch, default 3
  if [ -d "$SHARE_PREFIX/miniconda$CONDA_BRANCH" ]; then
    CONDA_HOME="$SHARE_PREFIX/miniconda$CONDA_BRANCH"
    EXTRA_PATH="$SHARE_PREFIX/miniconda$CONDA_BRANCH/bin:$EXTRA_PATH"
  elif [ -d "$HOME/miniconda$CONDA_BRANCH" ]; then
    CONDA_HOME="$HOME/miniconda$CONDA_BRANCH"
    EXTRA_PATH="$HOME/miniconda$CONDA_BRANCH:$EXTRA_PATH"
  fi
  PATH="$EXTRA_PATH:$SYS_PATH"
  if ! [ -z "$(command -v conda)" ]; then
    if [[ "$(conda --version | grep -Eo '[0-9.]*')" > "4.3.9999" ]]; then # set to use conda rather than source as recommended
      source "$CONDA_HOME/etc/profile.d/conda.sh"
    fi
  fi
  PATH="$USR_PATH"
  unset CONDA_HOME
  unset CONDA_BRANCH
else
  CONDA_HOME="$(which conda)"
  CONDA_HOME="$(dirname $CONDA_HOME)"
  CONDA_HOME="$(dirname $CONDA_HOME)"
  if [[ "$(conda --version | grep -Eo '[0-9.]*')" > "4.3.9999" ]]; then # set to use conda rather than source as recommended
    source "$CONDA_HOME/etc/profile.d/conda.sh"
  fi
  unset CONDA_HOME
fi

# set PATH so it includes local bin directories
if [ -d "$HOME/.bin" ]; then
  EXTRA_PATH="$HOME/.bin:$EXTRA_PATH"
fi
if [ -d "$HOME/.local/bin" ]; then
  EXTRA_PATH="$HOME/.local/bin:$EXTRA_PATH"
fi


PATH="$EXTRA_PATH:$PATH"
LD_LIBRARY_PATH="$EXTRA_LD_LIBRARY_PATH:$LD_LIBRARY_PATH"
