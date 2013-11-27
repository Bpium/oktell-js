class OktellServerConfig
	constructor: (@host, @login, @pass, @oktellVoice)->



okServers = [
	new OktellServerConfig('ws://192.168.0.61:4066', 'b300', 'b300', true)
	new OktellServerConfig('ws://192.168.0.61:4066', 'b300', 'b300', true)
	new OktellServerConfig('ws://192.168.0.61:4066', 'b300', 'b300', false)

	new OktellServerConfig('ws://192.168.0.61:4066', 'b301', 'b301', true)
	new OktellServerConfig('ws://192.168.0.61:4066', 'b301', 'b301', true)
	new OktellServerConfig('ws://192.168.0.61:4066', 'b301', 'b301', false)

]



actionTypes: {
	restart: 'перезапустить соединение'
	waitStatus: 'ожидание указанного статуса для целей'
	checkEvents: 'проверка цепочки вызванных событий с последующей очисткой цепочки'
	timeout: 'таймаут'
}


cases = [
	{
		action: 'restart'
		targets: [0,1,2,3,4,5]
	}
	{
		action: 'waitStatus'
		targets: [0,1,2,3,4,5]
		params: [1]
	}
	{
		action: 'timeout'
		targets: [0,1,2,3,4,5]
		params: [1000]
	}
	{
		action: 'checkEvents'
		target: [0,1,2,3,4,5]
		result:
			stateChange: ['ready', 'false']
			readyStart: true
	}
]



