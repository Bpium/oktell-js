actions = [
	'call'
	'endCall'
	'conference'
	'intercom'
	'hold'
	'resume'
	'transfer'
	'toggle'
	'answer'
	'ghostListen'
	'ghostHelp'
	'ghostConference'
]



states = [
	'disconnected'
	'ready'
	'ring'
	'call'
	'backRing'
	'talk'
]

statuses = [
	'ready'
	'dnd'
	'redirect'
	'ccReady'
	'ccBreak'
]

webrtc = [true, false]

numberStates = [
	'isAbonent'
	'isHolded'
	'inQueue'
]

conference = [
	'off'
	'inConfNotCreator'
	'inConfCreator'
]

me = [true, false]

conditions =
	'state': states
	'status': statuses
	'webrtc': webrtc
	'numberState': numberStates
	'conference': conference
	'me': me

