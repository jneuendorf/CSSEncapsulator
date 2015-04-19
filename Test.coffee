
##################################################################################################################
##################################################################################################################
describe "CSSEncapsulator", () ->

    beforeAll () ->

        start = performance.now()
        @instance = new CSSEncapsulator(
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
        loadingTime = performance.now() - start
        console.log "#{loadingTime} ms,", @instance
        @id = @instance.identifier


    it "randStr", () ->
        expect randStr(10).length
            .toBe 10

        expect randStr(10.5).length
            .toBe 10


    it "constructor", () ->

        expect @id.length
            .toBe 32

        expect @instance.cssString.trim().replace(/\n/g, " ").replace(/\s+/g, " ")
            .toBe """
                    ##{@id} { color: yellow; }
                    ##{@id} span { color: green; font-weight: bold; }
                    ##{@id} span:hover { color: red; }
                    ##{@id} .testclass { text-decoration: underline; }
                  """.trim().replace(/\n/g, " ").replace(/\s+/g, " ")

        expect @instance.styleSheet.innerText.substr(0, CSSEncapsulator.CSS_COMMENT.length)
            .toBe CSSEncapsulator.CSS_COMMENT

        expect @instance.root.id
            .toBe @id

        expect $("style[data-id='#{@id}']")[0].innerText.trim().replace(/\n/g, " ").replace(/\s+/g, " ")
            .toBe (CSSEncapsulator.CSS_COMMENT + @instance.cssString).trim().replace(/\n/g, " ").replace(/\s+/g, " ")


    it "apply/reapply", () ->

        @instance.cssString = ""
        @instance.apply()

        expect $("style[data-id='#{@id}']").length
            .toBe 1

        expect $("style[data-id='#{@id}']")[0].innerText
            .toBe CSSEncapsulator.CSS_COMMENT


        @instance.apply(true)

        expect $("style[data-id='#{@id}']").length
            .toBe 1

        expect $("style[data-id='#{@id}']")[0].innerText.trim().replace(/\n/g, " ").replace(/\s+/g, " ")
            .toBe (CSSEncapsulator.CSS_COMMENT + @instance.cssString).trim().replace(/\n/g, " ").replace(/\s+/g, " ")



################################################################################################################
# TESTS WITH JQUERY
describe "CSSEncapsulator jQuery", () ->

    beforeAll () ->
        @instance = new CSSEncapsulator(
            $(".content")
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
        @id = @instance.identifier



    it "constructor jQuery", () ->

        expect @id.length
            .toBe 32

        expect @instance.cssString.trim().replace(/\n/g, " ").replace(/\s+/g, " ")
            .toBe """
                    ##{@id} { color: yellow; }
                    ##{@id} span { color: green; font-weight: bold; }
                    ##{@id} span:hover { color: red; }
                    ##{@id} .testclass { text-decoration: underline; }
                  """.trim().replace(/\n/g, " ").replace(/\s+/g, " ")

        expect @instance.styleSheet.innerText.substr(0, CSSEncapsulator.CSS_COMMENT.length)
            .toBe CSSEncapsulator.CSS_COMMENT

        expect @instance.root.id
            .toBe @id

        expect $("style[data-id='#{@id}']")[0].innerText.trim().replace(/\n/g, " ").replace(/\s+/g, " ")
            .toBe (CSSEncapsulator.CSS_COMMENT + @instance.cssString).trim().replace(/\n/g, " ").replace(/\s+/g, " ")
