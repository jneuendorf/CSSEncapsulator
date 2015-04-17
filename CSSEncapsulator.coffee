# CSSEncapsulator
randStr = (len=16) ->
    text = ""
    chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"

    for i in [0...len]
        text += chars.charAt(Math.floor(Math.random() * chars.length))

    return text

class window.CSSEncapsulator

    constructor: (root, css={}, prefix=16, apply=true) ->
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

        if apply is true
            @apply()


    apply: () ->
        # NOTE: browser support for document.head:
        #       Chrome    Firefox   MSIE    Opera    Safari
        #       4.0       4.0       9.0     11.0     5.0

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

        @root.id = @prefix

        rules = @css.rules
        order = @css.order
        css = ""

        for key in order
            css += "##{@prefix} #{key} { #{rules[key]} }\n"

        head = document.head or document.getElementsByTagName("head")[0]
        style = document.createElement("style")

        style.type = "text/css"
        if style.styleSheet
            style.styleSheet.cssText = css
        else
            style.appendChild(document.createTextNode(css))

        head.appendChild(style)

        return @

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
                    ":hover":
                        height: "30px"
                # 3rd body property:
                "font-weight": "bold"
            "#main":
                float: left
            ".xy":
                color: red
        }
        all selectors are interpreted relative to this.root

        ====>

        [
            "body":                 "font-family: Arial; font-size: 20pt; font-weight: bold;"
            "body span":            "color: black; text-decoration: underline;"
            "body div.class":       "height: 20px;"
            "body div.class:hover": "height: 30px;"
            "#main":                "float: left;"
            ".xy":                  "color: red;"
        ]
        ###

        # prev  = selector so far
        # obj   = remaining data
        # res   = accumulator -> result
        createSelectors = (prev, obj, res, order) ->
            defs = ""
            for key, val of obj
                # key-val pair is an attribute definition
                if typeof val is "string"
                    defs += "#{key}: #{val}; "
                # key-val pair is a selector
                else
                    # pseudo class/element => don't insert white space
                    if key[0] is ":"
                        selector = "#{prev}#{key}"
                    else
                        selector = "#{prev} #{key}"

                    order.push selector
                    createSelectors(selector, val, res, order)

            if prev.length > 0
                if res[prev]
                    res[prev] += defs.trim()
                else
                    res[prev] = defs.trim()
                # res.push prev, defs.trim()
            return obj



        rules = {}
        order = []
        createSelectors("", data, rules, order)

        return {
            rules: rules
            order: order
        }
