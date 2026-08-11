# Homebrew
if test -x /opt/homebrew/bin/brew
    /opt/homebrew/bin/brew shellenv | source
end

# User-installed CLI tools
fish_add_path --global $HOME/.local/bin

# Network proxy
set -gx https_proxy http://127.0.0.1:6152
set -gx http_proxy http://127.0.0.1:6152
set -gx all_proxy socks5://127.0.0.1:6153

# Claude Code
set -gx CLAUDE_CODE_NO_FLICKER 1
set -gx CLAUDE_CODE_MAX_OUTPUT_TOKENS 32000
set -gx ANTHROPIC_BASE_URL https://api.903336.xyz

if status is-interactive
    # pyenv
    set -gx PYENV_ROOT $HOME/.pyenv
    if command -q pyenv
        pyenv init - fish | source
    end
end

starship init fish | source
kubectl completion fish | source

