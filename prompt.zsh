#
# Loads prompt themes.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#
zsh_timing_function ${(%):-%N}

# Load and execute the prompt theming system.
autoload -Uz promptinit && promptinit

# Load the prompt theme.
source ~/.zsh/prompt/prompt_pure_setup
