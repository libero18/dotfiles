find . -type d -not -path './.git*' -empty -print -exec touch {}\/.gitkeep \;
find . -name .gitkeep
