require! {
    commander
    './extract'
    fs
}

commander
    .version '0.1.0'
    .usage '[options] <file ...>'
    .option '-f, --function <regex>', 'Function pattern'
    .option '-k, --key <string>', 'Key'
    .option '-t, --tags', 'Extract additional parameters as tags.'
    .parse process.argv

options = {
    fun: new RegExp("^#{commander.function ? 'i18n'}$")
    commander.key ? ''
    init: {}
    warnings: []
}

for file in commander.args
    try
        js = fs.readFileSync file, 'utf8'
        extract js, options
    catch e
        console.error "Error processing file #{file}"
        throw e

final = {}
for key, obj of options.init
    final[key] = for args of obj
        r = {}
        [ r.string, ...r.tags ] = JSON.parse args
        if commander.tags
            r
        else
            r.string

process.stdout.write JSON.stringify final
