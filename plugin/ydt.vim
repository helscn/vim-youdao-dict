if !has('python3')
    echo "Error: Required vim compiled with +python3"
    finish
endif

" This function taken from the lh-vim repository
function! s:GetVisualSelection()
    try
        let a_save = @a
        normal! gv"ay
        return @a
    finally
        let @a = a_save
    endtry
endfunction

function! s:GetCursorWord()
    return expand("<cword>")
endfunction


python3 << EOF
import vim,urllib.request,urllib.parse,json

# -*- coding: utf-8 -*-

# 你的有道翻译API key 
youdao_key = ''
# 你的有道翻译API keyfrom
youdao_keyfrom = ''

WARN_NOT_FIND = " 找不到该单词的释义"
ERROR_QUERY = " 有道翻译查询出错!"
NETWORK_ERROR = " 无法连接有道服务器!"

def get_word_info(word):
    word=word.strip().replace('"',"'")
    if not word:
        return ''
    try:
        url="http://fanyi.youdao.com/openapi.do"
        values={
            'keyfrom' : youdao_keyfrom,
            'key' : youdao_key,
            'type' : 'data',
            'doctype' : 'json',
            'version' : '1.1',
            'q' : word.encode('utf8')
        }   #查询字符串必须为utf8编码
        data=urllib.parse.urlencode(values)
        req=urllib.request.urlopen(url+'?'+urllib.parse.urlencode(values))
        json_str=req.read()
        result=json.loads(json_str.decode('utf8'))
    except:
        return NETWORK_ERROR
    if result['errorCode'] == 0:
        return result['translation']
    elif result['errorCode']==60:
        return WARN_NOT_FIND
    else:
        return  ERROR_QUERY

def translate_visual_selection(selection):
    r"""selection = selection.decode('utf-8')"""
    result=get_word_info(selection)
    if isinstance(result,list):
        for line in result:
            vim.command('echo "'+ line +'"')
    else:
        vim.command('echo "'+ result +'"')
EOF

function! s:YoudaoVisualTranslate()
    python3 translate_visual_selection(vim.eval("<SID>GetVisualSelection()"))
endfunction

function! s:YoudaoCursorTranslate()
    python3 translate_visual_selection(vim.eval("<SID>GetCursorWord()"))
endfunction

function! s:YoudaoEnterTranslate()
    let word = input("Please enter the word: ")
    redraw!
    python3 translate_visual_selection(vim.eval("word"))
endfunction

command! Ydv call <SID>YoudaoVisualTranslate()
command! Ydc call <SID>YoudaoCursorTranslate()
command! Yde call <SID>YoudaoEnterTranslate()
