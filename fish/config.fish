set -g fish_greeting

fish_add_path ~/.local/bin
fish_add_path ~/.npm-global/bin

if status is-interactive
    # Commands to run in interactive sessions can go here
    if type -q starship
        starship init fish | source
    end
end
