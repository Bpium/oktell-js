module.exports = (grunt)->
	require('load-grunt-tasks')(grunt)
	require('time-grunt')(grunt)

	myConf =
		build: 'build'
		version: '1.8.1'
		chromePath: 'C:/Program Files (x86)/Google/Chrome/Application/chrome.exe'
		karmaChromeUsersDir: 'c:/www/karmaTestChromeUserDir'

	karmaTestConfig = grunt.file.read('test/config.coffee')

	karmaStartPort = parseInt karmaTestConfig.match(/karmaStartPort[ ]*=[ ]*([0-9]{4,5})/)?[1]
	karmaServersCount = parseInt karmaTestConfig.match(/okServersCount[ ]*=[ ]*([0-9]{1,5})/)?[1]

	console.log "karmaStartPort = #{karmaStartPort}, karmaServersCount = #{karmaServersCount}"

	concurrentConfig =
		test:
			tasks: []
			options:
				limit: 50
				logConcurrentOutput: false

	karmaConfig =
		options:
			autoWatch: false
			configFile: 'karma.conf.js'
			singleRun: true
#			browsers: ['Chrome_webrtc']
			customLaunchers: {}



# 	for i in [karmaStartPort..karmaStartPort+karmaServersCount-1]
# 		taskName = 'server'+i
# 		userDir = myConf.karmaChromeUsersDir+'/'+i
# 		if not grunt.file.isDir(userDir)
# 			grunt.file.mkdir userDir


# 		karmaConfig.options.customLaunchers[taskName] =
# 			base: 'ChromeCanary',
# 			flags: [
# #				'--use-fake-device-for-media-stream',
# 				'--user-data-dir='+(userDir.replace(/\//g, '\\\\'))
# 			]

# 		karmaConfig[taskName] =
# 			port: i
# 			browsers: [taskName]

# 		concurrentConfig.test.tasks.push 'karma:' + taskName

	grunt.initConfig
		myConf: myConf
#		clean: ['build/*']
#			build:
#				files: [{
##					expand: true
##					flatten: true
#					dot: true
#					src: ['<%= myConf.build %>/*']
#				}]

#		coffee:
#			options:
#				bare: true
#			build:
#				files: [{
#						expand: true,
#						src: 'oktell-voice.coffee',
#						dest: '<%= myConf.build %>',
#						ext: '.js'
#				}]
		concat:
			build:
				options:
					banner: "/*\n * Oktell.js\n * version <%= myConf.version %>\n * http://js.oktell.ru/\n */\n\n"
				files: [
					{
						src: [
							'oktell.js'
						]
						dest: '<%= myConf.build %>/oktell.js'
					}
				]
		uglify:
			build:
				files: {
					'<%= myConf.build %>/oktell.min.js': [
						'<%= myConf.build %>/oktell.js'
					]
				}

		replace:
			build:
				src: ['oktell.*']
				overwrite: true
				replacements: [{
					from: /self.version = '[0-9\.]+'/g,
					to: "self.version = '<%= myConf.version %>'"
				}]
			bower:
				src: ['bower.json']
				overwrite: true
				replacements: [{
					from: /"version": "[0-9\.]+",/,
					to: '"version": "<%= myConf.version %>",'
				}]

		karma: karmaConfig

		concurrent: concurrentConfig

		parallel: {
			assets: {
				options: {
					grunt: true
				},
				tasks: ['karma:first', 'karma:second']
			}
		}

		connect:
			server:
				options:
					hostname: '127.0.0.1'
					port: 6574
					keepalive: true
					open: true


	grunt.registerTask 'build', [
		'replace',
		'concat:build',
		'uglify:build'
	]

	grunt.registerTask 'default', [
		'build'
	]
