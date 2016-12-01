##Vim youdao dict
----------------
###如何安装
1. 将 **ydt.vim** 文件放到 *~/.vim/plugin* 目录中；
2. 修改**ydt.vim** 文件中的第27-30行中的内容：
```python
# 你的有道翻译API key 
youdao_key = ''
# 你的有道翻译API keyfrom
youdao_keyfrom = ''
```
在上面代码的单引号中增加你的有道翻译API Key和Keyfrom，个人使用的Key可以在[这里](http://fanyi.youdao.com/openapi?path=data-mode)申请，每天有1000次的查询上限，做为个人使用已经足够了。
3. 修改 *~/.vimrc* 配置文件增加快捷，在其中增加快捷键映射：
```vim
vnoremap <silent> <C-T> :<C-u>Ydv<CR>
nnoremap <silent> <C-T> :<C-u>Ydc<CR>
```
4. 重新启动Vim以使配置生效

###如何使用
- 在普通模式下，按 **Ctrl+t**， 会翻译当前光标下的单词；
- 在 visual 模式下选中单词或语句，按 **Ctrl+t**，会翻译选择的单词或语句；

###其它
该插件在[vim-youdao-translater](https://github.com/ianva/vim-youdao-translater)的基础上修改而来，由于vim-youdao-translater插件使用Python2来实现查词功能，而我的Vim只内置了Python3，因此将原插件用Python3重新改写了，同时换成了有道新的API，并去除了通过抓取网页进行查词的功能（由于网页改版的原因，通过正则抓取网页的方式并不稳定，速度也会慢很多）。