numbers = {}
for i in [300..309]
	numbers[i] = 0

_onNumberStateCallbacks = []
onNumbersState = (nums, state, fn, context = window)->
	_onNumberStateCallbacks.push [nums, state, fn, context]

setNumberState = (num, state)->
	if numbers[num]?
		numbers[num] = state
		for obj in _onNumberStateCallbacks
			allReady = true
			for n in obj[0]
				if numbers[n] isnt obj[1]
					allReady = false
			if allReady
				obj[2]?.apply?(obj[3]||window)




describe 'server connect', ->
	it 'should call callback', ->

		okServer = okServers[location.port - 9000]
		console.log "oktell connect params: host:#{okServer.host}, login: #{okServer.login}, pass #{okServer.pass}"

		complete = false
		callbackData = false

		oktell = new Oktell
		window.oktell = oktell
		window.oktellVoice = oktellVoice

		talkTime = 3000


		context = new webkitAudioContext
		oscillator = context.createOscillator()
		#			oscillator.connect context.destination
		remote = context.createMediaStreamDestination()
		oscillator.connect remote
		oktellVoice._localMediaStream = remote.stream

		analyser = context.createAnalyser()
		analyser.fftSize = 2048


		connect = ->
			oktell.connect
				url: okServer.host
				login: okServer.login
				password: okServer.pass
				oktellVoice: if okServer.oktellVoice then oktellVoice else false
				callback: (data)->

					src = null
					remote = null

					callbackData = data

					oktell.onNativeEvent 'pbxnumberstatechanged', (data)->
						for n in data.numbers
							setNumberState n.num, n.numstateid


					oktell.exec 'getpbxnumbers', {mode:'full'}, (data)->
						for n in data.numbers
							setNumberState n.number, n.state

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

					oktell.on 'talkStart', ->
						setTimeout ->

#							console.log 'local and remote stream ,1 ', oktellVoice.currentLocalStream, oktellVoice.currentRemoteStream, window.currentLocalStream1
#							local2 = context.createMediaElementSource oktellVoice.remoteEl
#							local2.connect analyser
#							interval = setInterval ->
#								num_bars = 30
#								d = new Uint8Array(2048);
#								analyser.getByteFrequencyData(d);
#								bin_size = Math.floor(2048 / num_bars)
#								sd = []
#								for i in [0...num_bars]
#									sm = 0
#									for j in [0...bin_size]
#										sm += d[(i * bin_size) + j]
#									sd.push(sm / bin_size)
#								console.log 'analyser data', bin_size, JSON.stringify(sd)
#							, 50
#
#							setTimeout ->
#								clearInterval interval
#							, 5000

							setTimeout ->
								oscillator.start(0)
							, 1000
							setTimeout ->
								oscillator.stop(0)
							, 3000
						, 1000

					oktell.on 'talkStop', ->
						setTimeout ->
							complete = true
						, 1000



		onMediaRequestSuccess = ->
			connect()


		runs ->
			oktellVoice.createUserMedia( onMediaRequestSuccess )

		waitsFor ->
			complete
		, "connect callback should be called", talkTime + 10000

		runs ->
			expect(callbackData?.result).toBeTruthy()
			expect(oktell.webphoneIsActive()).toBeTruthy()
			expect(oktell.getMyInfo().login).toBe(okServer.login)



