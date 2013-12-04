// Karma configuration
// Generated on Tue Nov 12 2013 11:58:41 GMT+0400 (Московское время (зима))

module.exports = function (config) {
	config.set({

		// base path, that will be used to resolve files and exclude
		basePath: '',


		// frameworks to use
		frameworks: ['jasmine'],


		// list of files / patterns to load in the browser
		files: [
			'bower_components/lodash/dist/lodash.js',
			'bower_components/jquery/jquery.js',
			'oktell.js',
			'bower_components/oktell-voice/build/oktell-voice.js',
			'test/mock/**/*.js',
			'test/config.js',
			'test/spec/**/*.js'
//			'test/sample.mp3'
		],


		// list of files to exclude
		exclude: [

		],


		// test results reporter to use
		// possible values: 'dots', 'progress', 'junit', 'growl', 'coverage'
		reporters: ['progress'],

		hostname: 'weboperator.airato.lan',


		// web server port
		//port: 9876,


		// enable / disable colors in the output (reporters and logs)
		colors: true,


		// level of logging
		// possible values: config.LOG_DISABLE || config.LOG_ERROR || config.LOG_WARN || config.LOG_INFO || config.LOG_DEBUG
		logLevel: config.LOG_INFO,


		// enable / disable watching file and executing tests whenever any file changes
		autoWatch: false,


		// Start these browsers, currently available:
		// - Chrome
		// - ChromeCanary
		// - Firefox
		// - Opera (has to be installed with `npm install karma-opera-launcher`)
		// - Safari (only Mac; has to be installed with `npm install karma-safari-launcher`)
		// - PhantomJS
		// - IE (only Windows; has to be installed with `npm install karma-ie-launcher`)
		browsers: ['Chrome'],

		customLaunchers: {
			"Chrome_webrtc": {
				base: 'ChromeCanary',
//				flags: ['--disable-web-security']
				flags: ['--use-fake-device-for-media-stream', '--disable-user-media-security', '--process-per-tab', '--user-data-dir=c:\\www\\karmaTestChromeUserDir']
			}
		},


		// If browser does not capture in given timeout [ms], kill it
		captureTimeout: 60000,


		// Continuous Integration mode
		// if true, it capture browsers, run tests and exit
		singleRun: false
	});
};
