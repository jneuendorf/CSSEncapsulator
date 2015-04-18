
##################################################################################################################
##################################################################################################################
describe "CSSEncapsulator", () ->

    start = Date.now()
    instance = new CSSEncapsulator(
        document.querySelector(".content")
        {
            "color": "yellow"
            "span":
                "color": "green"
                "font-weight": "bold"
                ":hover":
                    "color": "red"
            ".testclass":
                "text-decoration": "underline"
        }
        32
    )
    loadingTime = Date.now() - start
    console.log "#{loadingTime} ms,", instance
    id = instance.identifier


    it "randStr", () ->
        expect randStr(10).length
            .toBe 10

        expect randStr(10.5).length
            .toBe 10

    it "constructor", () ->

        expect instance.identifier.length
            .toBe 32

        expect instance.cssString.trim().replace(/\n/g, " ").replace(/\s+/g, " ")
            .toBe """
                    ##{id} { color: yellow; }
                    ##{id} span { color: green; font-weight: bold; }
                    ##{id} span:hover { color: red; }
                    ##{id} .testclass { text-decoration: underline; }
                  """.trim().replace(/\n/g, " ").replace(/\s+/g, " ")

        expect instance.styleSheet.innerText.substr(0, CSSEncapsulator.CSS_COMMENT.length)
            .toBe CSSEncapsulator.CSS_COMMENT

        expect instance.root.id
            .toBe instance.identifier
