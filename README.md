# Oktell.js

Библиотека для взаимодействия с сервером Oktell и телефоном (внешний или WebRTC)


# Тестирование работы библиотеки



Каждый тест это выполнение одного действия из списка возможных действий.
Порядок выполнения теста:
1. Проверяется начальные состояния
2. Вызывается метод
3. Проверяются конечные состояния


###Список состояний, которые можно менять через API

1. WebRTC
	1. true
	2. false

2. CallCenter
	1. true
	2. false

3. Status
	1. в коллцентре
		1. Ready
		2. Break
	2. не в коллцентре
		1. Ready
		2. DND
		3. Redirect


###Список состояний, которые можно получить, но нельзя менять через API

1. State
	1. disconnected
	2. ready
	3. call
	4. ring
	5. backring
	6. talk

2. phone actions - массив из след элементов
	1. call
	2. conference
	3. intercom
	4. transfer
	5. toggle
	6. ghostListen
	7. ghostHelp
	8. ghostConference
	9. endCall

