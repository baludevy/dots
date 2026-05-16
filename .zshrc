
if [[ $- == *i* ]]; then
    fastfetch
fi

clear() {
  command clear
  fastfetch
}

# history
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

setopt HIST_IGNORE_DUPS
setopt SHARE_HISTORY
setopt APPEND_HISTORY

# completion
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

autoload -Uz compinit
compinit

zstyle ':completion:*' menu select

# keybinds
bindkey -e

# word nav
bindkey "^[[1;5C" forward-word      # Ctrl + Right
bindkey "^[[1;5D" backward-word     # Ctrl + Left

# delete word
bindkey "^H" backward-kill-word
bindkey "^[[3;5~" kill-word         # Ctrl + Delete

# home / end
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line

# alt + arrow word nav
bindkey "^[^[[C" forward-word
bindkey "^[^[[D" backward-word

# aliases
alias ll="ls -lah --color=auto"
alias la="ls -A"
alias l="ls -CF"
alias c="clear"

# starship
eval "$(starship init zsh)"