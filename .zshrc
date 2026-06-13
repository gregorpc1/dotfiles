# --- POWERLEVEL10K INSTANT PROMPT ---
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source ~/.zsh/powerlevel10k/powerlevel10k.zsh-theme

# --- AUTOSUGGESTIONS ---
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=yellow'

# --- HISTORY SUBSTRING SEARCH ---
source ~/.zsh/zsh-history-substring-search/zsh-history-substring-search.zsh
bindkey '^[OA' history-substring-search-up
bindkey '^[OB' history-substring-search-down
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# --- ALIASY ---
alias hom='cd ~'
alias homd='cd ~/Dokumenty'
alias hommu='cd ~/Muzyka'
alias homz='cd ~/Zdjecia'
alias homp='cd ~/Pobrane'
alias homo='cd ~/Obrazy'

alias mag='cd /mnt/magazyn'
alias maga='cd /mnt/magazyn/Audiobooki'
alias magd='cd /mnt/magazyn/digikam-db'
alias magdo='cd /mnt/magazyn/Dokumenty'
alias magf='cd /mnt/magazyn/Film'
alias magk='cd /mnt/magazyn/Kompromaty'
alias magkp='cd /mnt/magazyn/Kopie\ zapasowe'
alias magm='cd /mnt/magazyn/Memy'
alias magmu='cd /mnt/magazyn/Muzyka'
alias magn='cd /mnt/magazyn/Notatki'
alias magso='cd /mnt/magazyn/Systemu\ operacyjne'
alias magz='cd /mnt/magazyn/Zdjecia'
alias magtr='cd /mnt/magazyn/Trening'

alias ll='ls -alh --color=auto'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias c='clear'
alias restorep='cd ~/dotfiles && git pull && cp .p10k.zsh ~/.p10k.zsh && cp .zshrc ~/.zshrc && source ~/.zshrc && cd -'
alias backup_copyq='cd ~/backup_configs && git add copyq && git commit -m "Backup CopyQ $(date +"%Y-%m-%d %H:%M:%S")" && cd -'


alias upd='sudo dnf upgrade --refresh -y && sudo dnf autoremove -y && sudo dnf clean all && sudo rm -rf "/var/tmp/dnf-*"'
alias sprzataj='sudo dnf5 autoremove -y && sudo dnf5 clean all && sudo rm -rf /var/tmp/dnf-*'
alias fixdnf='sudo rm -f /var/lib/dnf5/history.sqlite-shm /var/lib/dnf5/history.sqlite-wal && sudo dnf5 clean all'
alias cpu='btop'
alias skrypty='ls -lah ~/bin'
alias timery='systemctl --user list-timers --all --no-pager'

alias ffmp4='ffmpeg -i "$1" -c:v libx264 -preset fast -crf 22 -c:a aac "${1%.*}.mp4"'
alias ffogg='ffmpeg -i "$1" -c:a libopus -b:a 128k "${1%.*}.ogg"'
alias ffcut='ffmpeg -ss "$1" -to "$2" -i "$3" -c copy output.mp4'
alias ffopus='ffmpeg -i "$1" -c:a libopus -b:a 96k -vbr on -compression_level 10 "${1%.*}.ogg"'

alias meta='exiftool -a -G1 -s'
alias jerr='journalctl -p err -b --no-pager'
alias eurofs='python3 ~/scripts/predict_europe_fs.py'
alias amerfs='python3 ~/scripts/predict_americas_fs.py'
alias top40='python3 ~/scripts/predict_top40_fs.py'

alias worldfs='python3 ~/scripts/predict_world_full_fs.py'
alias cleanall='sudo /usr/local/bin/clean-journal.sh && sudo /usr/local/bin/dnf5-log-clean.sh'
alias gup='
echo "[1/5] Kopiuję .zshrc..."
cp ~/.zshrc ~/dotfiles/.zshrc

echo "[2/5] Kopiuję .p10k.zsh..."
cp ~/.p10k.zsh ~/dotfiles/.p10k.zsh

echo "[3/5] Synchronizuję pluginy Zsh..."
rsync -av --delete --exclude=".git" ~/.zsh/ ~/dotfiles/zsh/

echo "[4/5] Synchronizuję configi narzędzi..."
rsync -av --delete ~/.config/btop ~/dotfiles/config/ 2>/dev/null
rsync -av --delete ~/.config/mpv ~/dotfiles/config/ 2>/dev/null

echo "[5/5] Commit + push..."
cd ~/dotfiles &&
git add . &&
git commit -m "terminal sync: $(date +"%Y-%m-%d %H:%M")" &&
git push &&
cd - >/dev/null

echo "✔ Synchronizacja zakończona!"
'

# --- FUNKCJE ---
extract() {
  if [[ -f "$1" ]]; then
    case "$1" in
      *.tar.bz2) tar xjf "$1" ;;
      *.tar.gz)  tar xzf "$1" ;;
      *.bz2)     bunzip2 "$1" ;;
      *.rar)     unrar x "$1" ;;
      *.gz)      gunzip "$1" ;;
      *.tar)     tar xf "$1" ;;
      *.tbz2)    tar xjf "$1" ;;
      *.tgz)     tar xzf "$1" ;;
      *.zip)     unzip "$1" ;;
      *.7z)      7z x "$1" ;;
      *)         echo "Nieznany format: $1" ;;
    esac
  else
    echo "Plik nie istnieje"
  fi
}

spakuj() {
  local arch="$1"
  local dir="$(basename "$PWD")"
  cd .. && zip -r "${arch}.zip" "$dir" && cd "$dir"
}

podejrzyj() {
  if [[ ! -f "$1" ]]; then
    echo "Plik nie istnieje: $1"
    return 1
  fi

  case "$1" in
    *.zip) unzip -l "$1" ;;
    *.rar) unrar l "$1" ;;
    *.7z)  7z l "$1" ;;
    *.tar|*.tar.gz|*.tgz|*.tar.bz2|*.tbz2) tar -tf "$1" ;;
    *) echo "Nieznany format: $1" ;;
  esac
}

mount_sd() {
  local dev="/dev/sdc1"
  local mnt="/mnt/backup_sd"

  if [[ ! -e $dev ]]; then
    echo "❌ Nie znaleziono urządzenia $dev"
    return 1
  fi

  if ! mountpoint -q $mnt; then
    sudo mount $dev $mnt && echo "✅ Zamontowano kartę SD"
  else
    echo "ℹ️  Karta SD już jest zamontowana"
  fi

  sudo chown -R $USER:$USER $mnt && echo "🔧 Nadano właściciela"
}

# --- HISTORIA ZSH ---
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000

setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY

# --- SYNTAX HIGHLIGHTING (musi być ostatnie) ---
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=red,bold'

# --- POWERLEVEL10K CONFIG ---
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

cutvideo() {
    input="$1"
    start="$2"
    end="$3"
    ffmpeg -ss "$start" -to "$end" -i "$input" -c copy "${input%.*}_cut.mp4"
}

