 #!/bin/zsh

  DOT_FILES=(.vimrc .vim …)

 for file in ${DOT_FILES[@]}
 do
     ln -s $HOME/dotfiles/$file $HOME/$file
 done
