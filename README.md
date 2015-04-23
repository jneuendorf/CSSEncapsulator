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

Requirements:
- coffee
- cat
- uglifyjs


## Testing

Since the tests use `window.performance.now()` a modern browser (Chrome 20+, FF 15+, IE 10+, Opera 15+, Safari 8+) is required.

See [MDN](https://developer.mozilla.org/en-US/docs/Web/API/Performance/now)


## API

### Constructor

The constructor has the following signature:
`(root, css={}, identifier=16, apply=true)`

- root: HTMLElement, jQuery
    - The container  / root element of the encapsulated CSS.
- css: Object, String
    - The definition of the CSS that will be applied to the container / root.
    - If a String is given it will be directly applied.
    - Otherwise a nested object notation is expected (see example below). The keys will be merged with their parents separated by spaces (unless the key begins with a colon for pseudo classes).
    - Default: `{}`
- identifier: Number, String
    - Specifies how long or what the identifier will be.
    - Number => length, String => value.
    - Default: `16`
- apply: Boolean
    - Specifies if the style will be applied directly when instantiated.
    - If set to `false` use `apply()` at any later point to make your style take effect.
    - Default: `true`


#### Example:

HTML:
```html
<body>
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
</body>
```

JavaScript:
```javascript
new CSSEncapsulator(document.querySelector(".content"), {
    "color": "yellow",
    "span": {
        "color": "green",
        "font-weight": "bold",
        ":hover": {
            "color": "red"
        }
    }
}, 32);
```

The result will be:
- "should be blue" is blue
- "asdf (anything but blue!)" is green
- "HEADING" is yellow
- "some very funny text" is yellow

### CSSEncapsulator.prototype.apply(rebuildCSS=false)

Use `apply()` on the instance to (re)apply the style. If `rebuildCSS == true` the string will be rebuild from the instance's data.

Otherwise the `cssString` property will be used.
