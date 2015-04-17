
##################################################################################################################
##################################################################################################################
describe "CSSEncapsulator", () ->

    start = Date.now()
    instance = new CSSEncapsulator(
        document.querySelector(".content")
        {
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


    it "constructor", () ->
        console.log 3


##################################################################################################################
##################################################################################################################
# describe "JQL.Schema", () ->
