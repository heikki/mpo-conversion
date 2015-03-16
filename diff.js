
// Calculate stereo pair vertical diff
// > brew install autopano-sift-c

var exec = require('child_process').exec;

exec('autopano-sift-c - converted/test-left.jpg converted/test-right.jpg | grep "^c "', function(err, stdout) {

	var diffs = stdout.trim().split('\n').map(function(line) {
		// c n0 N1 x883.946600 y819.974337 X932.585399 Y809.359149 t0
		var m = line.match(/y(\d+\.?\d*).*Y(\d+\.?\d*)/);
		return parseFloat(m[1], 10) - parseFloat(m[2], 10);
	});

	var avg = diffs.reduce(function(memo, num) {
		return memo + num;
	}, 0) / diffs.length;

	console.log('Vertical diff:', avg);

});
