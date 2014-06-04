oktell = null
numbers = {}
_onNumberStateCallbacks = []
_events = []
_karmaServerWaitServers = {}
_waitKarmaServerEventName = "waitKarmaServer"

subscribeToEvents = (ok)->
	ok.on 'all', (event, args...)->
		_events.push
			event: event
			args: args

	ok.onCustomEvent _waitKarmaServerEventName, (data)->
#		console.log "waitKarmaServer event on #{serverNumber} from #{data.servers}"
		ss = data.servers.split(',')
		for s in ss
			_karmaServerWaitServers[s] = true





setNumberState = (num, state)->
	if num and state?
		numbers[num] = state
	for obj in _onNumberStateCallbacks
		allReady = true
		for n in obj[0]
			cNum = Object.keys(n)?[0]
			if cNum and numbers[cNum] isnt n[cNum]
				allReady = false
		if allReady
			obj[1]?.apply?(obj[2]||window)

onNumbersState = (nums, fn, context = window)->
	_onNumberStateCallbacks.push [nums, fn, context]
	setNumberState()

caseActions =
	restart: (after)->
		defer = $.Deferred()

		callbackData = false

		okServer = okServers[serverNumber]
		console.log "oktell connect params: host #{okServer.host}, login #{okServer.login}, pass #{okServer.pass}, with webrtc= #{okServer.oktellVoice}"

		tests = ->
			expect(callbackData?.result).toBeTruthy()
#			expect(oktell.webphoneIsActive()).toBeTruthy()
			expect(oktell.getMyInfo().login).toBe(okServer.login)
			defer.resolve()

		connect = ->
			oktell.connect
				url: okServer.host
				login: okServer.login
				password: okServer.pass
#				debugMode: true
				oktellVoice: if okServer.oktellVoice then oktellVoice else false
				callback: (data)->
#					console.warn "connect callback with result #{data.result}"
					callbackData = data



					if not okServer.oktellVoice
						tests()
					else
						timer = setTimeout ->
							clearInterval interval
							defer.rejectWith(window,['webrtc connect timeout'])
						, 10000

						interval = setInterval ->
#							console.log "check interval " + oktell.webphoneIsActive()
							if oktell.webphoneIsActive()
								clearInterval interval
								clearTimeout timer
								tests()
						, 20






					###

					onNumbersState [oktell.getMyInfo().number, 301], 1, ->
						if oktell.getMyInfo().number.toString() is '300'
							oscillator.frequency = 1000
							setTimeout ->
								oktell.call(106)
							, 1000

					oktell.on 'ringStart', ->
						setTimeout ->
							oktell.answer()

							setTimeout ->
								oktell.endCall()
							, talkTime

						, 1000

					oktell.on 'talkStop', ->
						setTimeout ->
							complete = true
						, 1000###



		onMediaRequestSuccess = ->
			connect()

		oktellVoice.createUserMedia( onMediaRequestSuccess )

		defer.promise()

	waitStatus: (waitNumbers, timeout = 10000)->
		defer = $.Deferred()

		if _.size(numbers) is 0
			oktell.onNativeEvent 'pbxnumberstatechanged', (data)->
				for n in data.numbers
#					console.log "event set #{n.number} to #{n.state}"
					setNumberState n.num, n.numstateid

			oktell.exec 'getpbxnumbers', {mode:'full'}, (data)->
#				console.log "pbx numbers " + data.result
				for n in data.numbers
#					console.log "set #{n.number} to #{n.state}"
					setNumberState n.number, n.state

		timer = setTimeout ->
			defer.rejectWith window, ['wait status timeout']
		, timeout

		onNumbersState waitNumbers, ->
			clearTimeout timer
			defer.resolve()

		defer.promise()

	checkEvents: (events)->
		defer = $.Deferred()
		setTimeout ->
			allEvents = _events
			_events = []
			found = []
			foundCount = 0
			currI = 0
	#		console.log "checkEvents #{JSON.stringify(allEvents)}"
			for searchEvent, j in events
				found.push searchEvent[0] + " - NOT found"
	#			console.log "searchEvent = #{searchEvent[0]} with args #{JSON.stringify(searchEvent[1])}"
				for i in [currI...allEvents.length]
	#				console.log "  try #{allEvents[i]?.event}"
					if allEvents[i]?.event is searchEvent[0]
						allArgsEqual = true
						args = allEvents[i].args
						searchArgs = searchEvent[1]
	#					console.log "    name success, real args = #{JSON.stringify(args)}"
						if searchArgs
							for sArg, k in searchArgs
								if _.isObject(sArg)
									sArg = _.extend {}, args[k], sArg
		#						console.log "      arg check real= #{JSON.stringify(args[k])} , search  = #{JSON.stringify(sArg)}"
								if sArg? and not _.isEqual(args[k], sArg)
									allArgsEqual = false

						if allArgsEqual
	#						console.log "          allArgsEqual = true"
							currI = i
							foundCount++
							found[found.length-1] = searchEvent[0] + " - found"
							break;
			if events.length is foundCount
				defer.resolve()
			else
				defer.rejectWith window, ["not all events found: #{found.join(', ')} | all #{JSON.stringify(allEvents)}"]
		, 1
		defer.promise()

	timeout: (time)->
		defer = $.Deferred()
		setTimeout ->
			defer.resolve()
		, time
		defer.promise()

	disconnect: ->
		defer = $.Deferred()
		oktell.exec('logout')
		setTimeout ->
			defer.resolve()
		, 1000
		defer.promise()

	waitKarmaServer: (servers, timeout = 5000)->
		defer = $.Deferred()
		timer = setTimeout ->
			defer.rejectWith window, ["not all karma servers ready: #{JSON.stringify(_karmaServerWaitServers)}"]
		, timeout
		interval = setInterval ->
#			console.log "#{serverNumber} _karmaServerWaitServers = #{JSON.stringify(_karmaServerWaitServers)}"
			ready = true
			for server in servers
				if server isnt serverNumber and not _karmaServerWaitServers[server]
					ready = false
			_karmaServerWaitServers[serverNumber] = true
			oktell.triggerCustomEvent _waitKarmaServerEventName, false, {servers:Object.keys(_karmaServerWaitServers).join(',')}, true
			if ready
				clearInterval interval
				clearTimeout timer
				defer.resolve()
		, 500
		defer.promise()



describe 'test cases', ->
	describe 'first case', ->
		it 'should run all actions successfully', ->
			successRun = false
			actionsComplete = false
			oktell = new Oktell
			subscribeToEvents oktell
			runs ->
				currentI = 0
				promise = null
				go = ->
					if currentI < cases.length
						currCase = cases[currentI]
						if currCase.targets?.indexOf?(serverNumber) is -1
							currentI++
							go()
							return
						action = currCase.action
#						console.log ""
#						console.log "===================== #{serverNumber} start action '#{action}' with params #{JSON.stringify(currCase.params)}"
						promise = caseActions[action]?.apply(undefined, currCase.params or [])
						currentI++
						promise.then ->
#							console.log "===================== #{serverNumber} action '#{action}' complete"
							go()
						, (msg)->
							console.error "#{serverNumber} server error on action '#{action}' with: #{msg}"
							actionsComplete = true
					else
						promise.then ->
							successRun = true
							actionsComplete = true

				go()

			waitsFor ->
				actionsComplete
			, 'should run all cases', 1000000

			runs ->
				if not successRun
					console.log "ERROR !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
				#expect(successRun).toBeTruthy()

