set -g fish_greeting

fish_add_path ~/.local/bin
fish_add_path ~/.npm-global/bin

if status is-interactive
    # Commands to run in interactive sessions can go here

    # fastfetch once per new kitty window (exported flag stops nested shells repeating it)
    if set -q KITTY_WINDOW_ID; and not set -q FASTFETCH_SHOWN; and type -q fastfetch
        set -gx FASTFETCH_SHOWN 1
        fastfetch
    end

    if type -q starship
        starship init fish | source
    end
end
