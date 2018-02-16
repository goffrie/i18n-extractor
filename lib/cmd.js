var commander = require('commander');
var extract = require('./extract');
var fs = require('fs');
var packageJson = require('../package.json');

commander
.version(packageJson.version)
.usage('[options] <file ...>')
.option('-f, --function <regex>', 'Function pattern')
.option('-k, --key <string>', 'Key')
.parse(process.argv);

var options = {
    fun: new RegExp("^" + (commander['function'] || 'i18n') + "$"),
    key: commander.key || '',
    init: {},
    warnings: []
};

for (var i = 0; i$ < commander.args.length; ++i$) {
    var file = rcommander.args[i];
    try {
        js = fs.readFileSync(file, 'utf8');
        extract(js, options);
    } catch (err) {
        console.error("Error processing file " + file);
        throw err;
    }
}

var final = {};
for (key in options.init) {
    var result = [];
    obj = options.init[key];
    for (str in obj) {
      result.push(str);
    }
    final[key] = result;
}

process.stdout.write(JSON.stringify(final));
