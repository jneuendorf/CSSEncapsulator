# CSSEncapsulator
randStr = (len=16) ->
    text = ""
    chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"

    for i in [0...(~~len)]
        text += chars.charAt(Math.floor(Math.random() * chars.length))

    return text

###*
* @class CSSEncapsulator
*
* @property root {HTMLElement}
* @property identifier {String}
* @property css {Object}
* @property cssString {String}
* @property styleSheet {HTMLStyleElement}
*
* @constructor
* @param root {HTMLElement|jQuery}
* @param css {Object|String}
* @param identifier {Number|String}
*###
class window.CSSEncapsulator

    @CSS_COMMENT = CSS_COMMENT = "/* generated by CSSEncapsulator */\n"

    constructor: (root, css={}, identifier=16, apply=true) ->
        if typeof jQuery isnt "undefined" and root instanceof jQuery
            @root = root[0]
        else
            @root = root

        if identifier?
            loop
                if typeof identifier is "number"
                    @identifier = randStr(identifier)
                else if typeof identifier is "string"
                    @identifier = identifier

                break unless document.getElementById @identifier


        if typeof css is "string"
            @css = null
            @cssString = css
        else
            @css = @defineCSS(css)
            @stringifyCSS()

        @styleSheet = null

        if apply is true
            @apply()


    apply: (rebuildCSS=false) ->
        if not @cssString? or rebuildCSS is true
            @stringifyCSS()

        head    = document.head or document.getElementsByTagName("head")[0]
        style   = document.createElement "style"

        style.type = "text/css"
        if style.styleSheet
            style.styleSheet.cssText = CSS_COMMENT + @cssString
        else
            style.appendChild document.createTextNode(CSS_COMMENT + @cssString)

        style.setAttribute("data-id", @identifier)

        if @styleSheet?
            head.removeChild @styleSheet

        head.appendChild style

        @styleSheet = style

        return @

    stringifyCSS: () ->
        @root.id = @identifier

        rules = @css.rules
        order = @css.order
        css = ""

        for key in order
            css += "#{key} { #{rules[key]} }\n"

        @cssString = css
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
        {
            "body":                 "font-family: Arial; font-size: 20pt; font-weight: bold;"
            "body span":            "color: black; text-decoration: underline;"
            "body div.class":       "height: 20px;"
            "body div.class:hover": "height: 30px;"
            "#main":                "float: left;"
            ".xy":                  "color: red;"
        }
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

            if res[prev]
                res[prev] += defs.trim()
            else
                res[prev] = defs.trim()

            return obj


        rules = {}
        order = ["##{@identifier}"]
        createSelectors("##{@identifier}", data, rules, order)

        return {
            rules: rules
            order: order
        }
