# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh
export PATH=$PATH:/usr/local/go/bin

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
#ZSH_THEME="ys"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git fzf pyenv zsh-autosuggestions history-substring-search copypath )

#copypath
#zsh-vi-mode conflict with keyboard shortcuts
#zsh-vi-mode zsh-syntax-highlighting

source $ZSH/oh-my-zsh.sh
ZSH_AUTOSUGGEST_STRATEGY=match_prev_cmd


# auto sugessions using sqllite3
source $HOME/.oh-my-zsh/custom/plugins/zsh-histdb/sqlite-history.zsh
autoload -Uz add-zsh-hook

source $HOME/.oh-my-zsh/custom/plugins/zsh-histdb/histdb-interactive.zsh

_zsh_autosuggest_strategy_histdb_top() {
    local query="
        select commands.argv from history
        left join commands on history.command_id = commands.rowid
        left join places on history.place_id = places.rowid
        where commands.argv LIKE '$(sql_escape $1)%'
        group by commands.argv, places.dir
        order by places.dir != '$(sql_escape $PWD)', count(*) desc
        limit 1
    "
    suggestion=$(_histdb_query "$query")
}

#ZSH_AUTOSUGGEST_STRATEGY=histdb_top

_zsh_autosuggest_strategy_histdb_bharath() {
    local query1="
	SELECT commands.argv
	FROM history
	LEFT JOIN commands ON history.command_id = commands.rowid
	LEFT JOIN places ON history.place_id = places.rowid
	ORDER BY places.dir != '$(sql_escape $PWD)', command_id DESC
	LIMIT 1
    "
        local query2="
        select commands.argv from history
        left join commands on history.command_id = commands.rowid
        left join places on history.place_id = places.rowid
        where commands.argv LIKE '$(sql_escape $1)%'
        group by commands.argv, places.dir
        order by places.dir != '$(sql_escape $PWD)', count(*) desc
        limit 1
    "
            local query3="
        select commands.argv from history
        left join commands on history.command_id = commands.rowid
        left join places on history.place_id = places.rowid
        where commands.argv LIKE '$(sql_escape $1)%'
        group by commands.argv, places.dir
        order by places.dir != '$(sql_escape $PWD)', count(*) desc
        limit 1,1
    "

    suggestion1=$(_histdb_query "$query1")
    suggestion2=$(_histdb_query "$query2")
    suggestion3=$(_histdb_query "$query2")

	if [ $suggestion1 = $suggestion2 ]; then
	    suggestion=$suggestion3
	else
	    suggestion=$suggestion2
	fi

#echo $suggestion
}

#ZSH_AUTOSUGGEST_STRATEGY=histdb_bharath

# Query to pull in the most recent command if anything was found similar
# in that directory. Otherwise pull in the most recent command used anywhere
# Give back the command that was used most recently
_zsh_autosuggest_strategy_histdb_top_fallback() {
    local query="
    select commands.argv from
    history left join commands on history.command_id = commands.rowid
    left join places on history.place_id = places.rowid
    where places.dir LIKE
        case when exists(select commands.argv from history
        left join commands on history.command_id = commands.rowid
        left join places on history.place_id = places.rowid
        where places.dir LIKE '$(sql_escape $PWD)%'
        AND commands.argv LIKE '$(sql_escape $1)%')
            then '$(sql_escape $PWD)%'
            else '%'
            end
    and commands.argv LIKE '$(sql_escape $1)%'
    group by commands.argv
    order by places.dir LIKE '$(sql_escape $PWD)%' desc,
        history.start_time desc
    limit 1"
    suggestion=$(_histdb_query "$query")
}

#ZSH_AUTOSUGGEST_STRATEGY=histdb_top_fallback


# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
#
alias doom="~/.emacs.d/bin/doom"
alias doc="/mnt/doc"
alias logseq="~/Logseq-linux-x64-0.5.9.AppImage &"
# copy to git hub folder and push
alias cpdot="~/dotfiles/copy_dotfiles.sh"



###### pyenv
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
##############################

############### Kitty commands
#autoload -Uz compinit
#compinit
## Completion for kitty
#kitty + complete setup zsh | source /dev/stdin
###############################
export PATH="/usr/local/texlive/2020/bin/x86_64-linux:$PATH"
#export MANPATH="/usr/local/texlive/2020/texmf/doc/man:$MANPATH"
#export INFOPATH="/usr/local/texlive/2020/texmf/doc/info:$INFOPATH"
##########################
#autojump
. /usr/share/autojump/autojump.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# zsh-substring-search keybindings
# normal mode
bindkey "^[[A" history-substring-search-up
bindkey "^[[B" history-substring-search-down
# vim mode
bindkey -M vicmd "k" history-substring-search-up
bindkey -M vicmd "j" history-substring-search-down

#https://www.dev-diaries.com/blog/terminal-history-auto-suggestions-as-you-type/
#https://github.com/larkery/zsh-histdb#installation
bindkey "^r" _histdb-isearch
