# Сетка состояний, возможных переходов и действий

do ->

	actions = [
		'call'
		'conference'
		'intercom'
		'transfer'
		'toggle'
		'ghostListen'
		'ghostHelp'
		'ghostConference'
		'endCall'
	]

	states =
		state: ['disconnected', 'ready', 'ring', 'backring', 'call', 'talk']
		webrtc: [true, false]
		callcenter: [true, false]
		conference: [true, false]
		status: ['ready', 'dnd', 'redirect', 'ccready', 'ccbreak']