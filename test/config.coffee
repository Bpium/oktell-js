class OktellServerConfig
	constructor: (@host, @login, @pass, @oktellVoice)->

karmaStartPort = 9000

okServers = [
	new OktellServerConfig('ws://192.168.0.61:4066', 'b300', 'b300', true)
	new OktellServerConfig('ws://192.168.0.61:4066', 'b300', 'b300', true)
	new OktellServerConfig('ws://192.168.0.61:4066', 'b300', 'b300', false)

	new OktellServerConfig('ws://192.168.0.61:4066', 'b301', 'b301', true)
	new OktellServerConfig('ws://192.168.0.61:4066', 'b301', 'b301', true)
	new OktellServerConfig('ws://192.168.0.61:4066', 'b301', 'b301', false)

	new OktellServerConfig('ws://192.168.0.61:4066', 'b302', 'b302', true)
	new OktellServerConfig('ws://192.168.0.61:4066', 'b302', 'b302', true)
	new OktellServerConfig('ws://192.168.0.61:4066', 'b302', 'b302', false)

	new OktellServerConfig('ws://192.168.0.61:4066', 'b303', 'b303', true)
	new OktellServerConfig('ws://192.168.0.61:4066', 'b303', 'b303', true)
	new OktellServerConfig('ws://192.168.0.61:4066', 'b303', 'b303', false)

	new OktellServerConfig('ws://192.168.0.61:4066', 'b304', 'b304', true)
	new OktellServerConfig('ws://192.168.0.61:4066', 'b304', 'b304', true)
	new OktellServerConfig('ws://192.168.0.61:4066', 'b304', 'b304', false)

	new OktellServerConfig('ws://192.168.0.61:4066', 'b305', 'b305', true)
	new OktellServerConfig('ws://192.168.0.61:4066', 'b305', 'b305', true)
	new OktellServerConfig('ws://192.168.0.61:4066', 'b305', 'b305', false)

]

okServersCount = 2

serverNumber = location.port - karmaStartPort

actionTypes: {
	restart: 'перезапустить соединение'
	waitStatus: 'ожидание указанного статуса для целей'
	checkEvents: 'проверка цепочки вызванных событий с последующей очисткой цепочки'
	timeout: 'таймаут'
}


cases = [
	{ action: 'timeout', params: [parseInt(1000 + 1500 * serverNumber)] }
#	{ action: 'timeout', targets: [1], params: [1100] }
#	{ action: 'timeout', targets: [2], params: [1200] }
#	{ action: 'timeout', targets: [3], params: [1300] }
	{ action: 'restart' }
#	{ action: 'timeout', params: [1000]	}
#	{
#		action: 'waitStatus'
#		targets: [0,1,2,3,4,5,6,7,8,9]
#		params: [
#			[{300:1}] #,{301:1},{301:1}]
#			5000
#		]
#	}
	{ action: 'waitKarmaServer', params: [[0...okServersCount],	60000] }
#	{ action: 'timeout', params: [1000]	}
#	{
#		action: 'checkEvents'
#		targets: [0,1,3,4,6,7]
#		params: [
#			[
#				['stateChange', ['ready', 'disconnected']]
#			]
#		]
#	}
	{
		action: 'checkEvents'
#		targets: [2,5,8]
		params: [
			[
				['stateChange', ['ready']]
				['readyStart']
			]
		]
	}
	{ action: 'disconnect' }
]



