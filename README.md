Neovim 入れる

```
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage
chmod u+x nvim-linux-x86_64.appimage

# 移動
sudo mkdir -p /opt/nvim
sudo mv nvim-linux-x86_64.appimage /opt/nvim/nvim

# 起動できるようにする
echo 'export PATH="$PATH:/opt/nvim/"' >> ~/.bashrc
```

nvim-config を配置

```
$ mkdir -p ~/.config
$ cd ~/.config
$ git clone https://github.com/tamago324/nvim-config.git nvim
```
