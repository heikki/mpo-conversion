var fs = require('fs');
var path = require('path');
var spawn = require('child_process').spawn;

var glob = require('glob');
var del = require('del');
var minimist = require('minimist');
var progress = require('progress');

var argv = minimist(process.argv.slice(2), {
	force: 'boolean'
});

var exiftool = spawn('exiftool', ['-stay_open', 'True',  '-@', '-'], { stdio: ['pipe', 'pipe', 2] });

function execute(cmd) {
	exiftool.stdin.write(cmd.replace(/ /g, '\n') + '\n-execute\n');
}

function exit() {
	exiftool.stdin.write('-stay_open\nFalse\n');
}

if (argv.force) {
	del.sync('converted/**');
}

var entries = glob.sync(argv._[0] || 'mpo/*.MPO').map(function(input) {
	return { input: input, output: 'converted/' + path.basename(input.toLowerCase(), '.mpo') };
}).filter(function(entry) {
	if (glob.sync(entry.output + '-{left,right}.jpg').length < 2) {
		del.sync(entry.output + '-{left,right}.jpg');
		return true;
	}
	return false;
});

entries.forEach(function(entry) {
	execute('-trailer:all= ' + entry.input + ' -o ' + entry.output + '-left.jpg');
	execute('-mpimage2 ' + entry.input + ' -b -W ' + entry.output + '-right.jpg');
});

var bar = new progress('Converting :current/:total [:bar] :percent', {
	total: entries.length,
	width: 20,
	incomplete: ' '
});

var counter = 0;

exiftool.stdout.on('data', function(chunk) {
	if ((/\{ready\}/).test(chunk)) {
		if (++counter % 2 === 0) {
			bar.tick();
		}
	}
});

exit();
