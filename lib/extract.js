var uglifyJs = require('uglify-js');

// Takes a string of Javascript and parses function calls on literal strings,
// or constant expressions that evaluate to strings.
//
// `options` has the following keys:
//
// - `fun`: a regular expression indicating which function calls to parse
// - `key`: the key under which to record the function arguments. Can use
//     backreferences, as per String//replace. Defaults to an empty string.
// - `init`: if present, the results will be merged onto this object.
// - `warnings`: if present, function calls that match `fun`, but don't have the
//     right format (exactly one literal string) will be recorded in this array.
//
// Returns an object where the keys are per `key` and the values are objects
// where the keys are the used strings.
module.exports = function(js, options){
    if(!options.key) {options.key = '';}
    var ast = uglifyJs.parse(js);

    ast.figure_out_scope();
    var results = options.init || {};
    var compressor = uglifyJs.Compressor({evaluate: true}, true);

    ast.walk(new uglifyJs.TreeWalker(function(node) {
        var key;

        if (node instanceof uglifyJs.AST_Call &&
            typeof node.expression.name === 'string' &&
            node.expression.name.match(options.fun)
        ) {
            node = node.transform(compressor);
            key = node.expression.name.replace(options.fun, options.key);
            if (node.args.length < 1) {
                if(options.warnings) {
                    options.warnings.push({node: node, msg: "Magic function called without enough arguments"});
                }
            } else if (!(node.args[0] instanceof uglifyJs.AST_String)) {
                if(options.warnings) {
                    options.warnings.push({node: node, msg: "Magic function argument not a literal string"});
                }
            } else {
                if(!results[key]) {results[key] = {};}
                results[key][node.args[0].value] = 1;
            }
        }

    }));

    return results;
};
