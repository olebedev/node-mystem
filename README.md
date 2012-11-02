Node.js обертка для утилиты ``MyStem`` от [yandex](http://company.yandex.ru/technologies/mystem/).
==================================================================================================

### Возможности ###

Пока возможно только привести слово в нормальную форму, все остальные возможности пока не доступны.

### Использование ###

```bash
npm install mystem
```

При установке скачивается версия ``MyStem`` для Mac OS X. Если у вас другая платформа, то необходимо скачать [MyStem](http://company.yandex.ru/technologies/mystem/noncommercial.xml) и установить в папку ``./vendor/<uname(darwin or linux)>/<platform arch(x64 or x86)>``. После этого можно начать использование.

Функция ``normalize`` принимает два значения: строку и функцию обратного вызова.

```javascript
> mystem = require('./lib/index')
> mystem.normalize('В мурелки шлепают пельсиски.\nВ стакелках светится мычай.', console.log);
> null [ { raw: 'мурелка?|мурелки?|мурелок?',
    args: {},
    target: 'мурелка',
    hypothesis: true },
  { raw: 'шлепать', args: {}, target: 'шлепать' },
  { raw: 'пельсиска?', args: {}, target: 'пельсиска', hypothesis: true },
  { raw: 'в', args: {}, target: 'в' },
  { raw: 'стакелк?|стакелка?|стакелки?|стакелок?',
    args: {},
    target: 'стакелк',
    hypothesis: true },
  { raw: 'светиться', args: {}, target: 'светиться' },
  { raw: 'мычай?', args: {}, target: 'мычай', hypothesis: true } ]

> mystem.normalize('В мурелки шлепают пельсиски.\nВ стакелках светится мычай.', function(err,data){
	console.log(data.toString())
});
> в
мурелка,шлепать,пельсиска,в,стакелк,светиться,мычай
```

Возвращает два значения: ``err``, ``result``.
``result`` - это массив объектов ``Info``, в которых содержится информация ответа ``MyStem``. 

### Объект Info

```javascript
> i = new Info('мурелка?|мурелки?|мурелок?') // парсинг ответа MyStem
> i.raw 
> 'мурелка?|мурелки?|мурелок?' // содержит "сырой" ответ из MyStem
> i.args
> {}
> i.target
> 'мурелка', // строка с нормализованным по версии MyStem словом. Если это гипотеза то это всегда первое слово из массива.
> i.hypothesis
> true 
> i.toString() //return i.target
> 'мурелка'
```



