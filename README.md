# CSSEncapsulator

A JavaScript tool that breaks CSS inheritance for a specific area.

## Usage

Include the development or production version of the script in your browser:

```html
<script type="text/javascript" src="CSSEncapsulator.min.js"></script>
```


## Build


For now, it only works on Unix systems.

Use `make` to create development version.

Use `make production` to create development and production version.

Use `make test` to create test version (development code + jasmine tests). The test file is also called `JQL.js` so you just need to refresh your browser.


## Testing

Since the tests use `window.performance.now()` a modern browser (Chrome 20+, FF 15+, IE 10+, Opera 15+, Safari 8+) is required.

See [MDN](https://developer.mozilla.org/en-US/docs/Web/API/Performance/now)


## API



Example:

Given HTML:

```<body>
        <div class="top">
            <div class="header">
                <span>should be blue</span>
            </div>
            <div class="content">
                <span>asdf (anything but blue!)</span>
                <div class="div">
                    <h1>HEADING</h1>
                    <p>
                        some very funny text
                    </p>
                </div>
            </div>
            <div class="footer"></div>
        </div>
        <script src="CSSEncapsulator.js" type="text/javascript" charset="utf-8"></script>
    </body>```

```javascript
new CSSEncapsulator(document.querySelector(".content"), {
        "color": "yellow",
        "span": {
          "color": "green",
          "font-weight": "bold",
          ":hover": {
            "color": "red"
          }
        },
        ".testclass": {
          "text-decoration": "underline"
        }
      }, 32);
```
