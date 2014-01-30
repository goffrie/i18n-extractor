require! \uglify-js

# Takes a string of Javascript and parses function calls on literal strings,
# or constant expressions that evaluate to strings.
#
# `options` has the following keys:
#
# - `fun`: a regular expression indicating which function calls to parse
# - `key`: the key under which to record the function arguments. Can use
#     backreferences, as per String#replace. Defaults to an empty string.
# - `init`: if present, the results will be merged onto this object.
# - `warnings`: if present, function calls that match `fun`, but don't have the
#     right format (exactly one literal string) will be recorded in this array.
#
# Returns an object where the keys are per `key` and the values are objects
# where the keys are the used strings.
extract = (js, options) ->
    options.key ?= ''
    ast = uglify-js.parse js
    ast.figure_out_scope!
    results = options.init ? {}
    compressor = uglify-js.Compressor { evaluate: true }, true
    ast.walk new uglify-js.TreeWalker !(node) ->
        if node instanceof uglify-js.AST_Call &&
                typeof node.expression.name == 'string' &&
                node.expression.name.match options.fun
            node = node.transform compressor
            key = node.expression.name.replace options.fun, options.key
            if node.args.length < 1
                options.warnings?.push {
                    node
                    msg: "Magic function called without enough arguments"
                }
            else if !(node.args[0] instanceof uglify-js.AST_String)
                options.warnings?.push {
                    node
                    msg: "Magic function argument not a literal string"
                }
            else
                results[key] ?= {}
                results[key][node.args[0].value] = 1
    results

module.exports = extract
