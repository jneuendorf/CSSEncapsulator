# CSSEncapsulator
randStr = (len=16) ->
    text = ""
    chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"

    for i in [0...len]
        text += chars.charAt(Math.floor(Math.random() * chars.length))

    return text

class window.CSSEncapsulator

    constructor: (root, css={}, prefix=16) ->
        if typeof jQuery isnt "undefined" and root instanceof jQuery
            @root = root[0]
        else
            @root = root

        @css = @defineCSS(css)

        if prefix?
            loop
                if typeof prefix is "number"
                    @prefix = randStr(prefix)
                else if typeof prefix is "string"
                    @prefix = prefix

                break unless document.getElementById @prefix

    defineCSS: (data) ->
        ###
        data is like:
        {
            body:
                # 1st body property:
                "font-family": "Arial"
                # child
                span:
                    color: "black"
                    "text-decoration": "underline"
                # 2nd body property:
                "font-size": "20pt"
                # child
                "div.class":
                    height: "20px"
                # 3rd body property:
                "font-weight": "bold"
            "#main":
                float: left
            ".xy":
                color: red
        }
        all selectors are interpreted relative to this.root
        ###

        # prev  = selector so far
        # obj   = remaining data
        # res   = accumulator -> result
        createSelectors = (prev, obj, res=[]) ->


            return obj



        ruleSets = []
        createSelectors("", data, ruleSets)

        # NOTE: browser support:
        #       Chrome    Firefox   MSIE    Opera    Safari
        #       4.0       4.0       9.0     11.0     5.0
        document.head

        ###
        css = 'h1 { background: red; }'
        head = document.head || document.getElementsByTagName('head')[0]
        style = document.createElement('style')

        style.type = 'text/css'
        if style.styleSheet
          style.styleSheet.cssText = css
        else
          style.appendChild(document.createTextNode(css))

        head.appendChild(style)

        ###
