var ExtensionClass = function() {};

ExtensionClass.prototype = {
    run: function(arguments) {
        arguments.completionFunction({
            "href": document.location.href,
            "contentHTML": document.body.innerHTML,
            "title": document.title.toString()
        });
    }
};

var ExtensionPreprocessingJS = new ExtensionClass;
