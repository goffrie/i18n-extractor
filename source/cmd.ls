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
    newAry = []
    for sub of obj
        newObj = {}
        newObj["tags"] = []
        counter = 0
        s = JSON.parse sub
        newObj["string"] = s[0]
        newObj["tags"] = s.slice 1
        newAry.push newObj
    final[key] = newAry

process.stdout.write JSON.stringify final
