// MIT License
//
// Copyright (c) 2023 FAST8.RU
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
    ЭтаОбработка = РеквизитФормыВЗначение("Объект");
	Информация = ЭтаОбработка.ИнформацияОПрограмме();
	
	fast8АдресНаСайте = Информация.АдресНаСайте;
	fast8Автор = Информация.Автор;
	fast8Версия = Информация.Версия;
	fast8Имя = Информация.Имя;
	fast8Описание = Информация.Описание;
	fast8Синоним = Информация.Синоним;
	
	Элементы.АдресНаСайте.Заголовок = fast8АдресНаСайте;
	
КонецПроцедуры // ПриСозданииНаСервере()

#КонецОбласти // ОбработчикиСобытийФормы

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура АдресНаСайтеНажатие(Элемент)
	
	НачатьЗапускПриложения(Новый ОписаниеОповещения, fast8АдресНаСайте);
	
КонецПроцедуры // АдресНаСайтеНажатие()

&НаКлиенте
Процедура fast8ПроверитьОбновлениеНажатие(Элемент)
	
	АдресСайта = "fast8.ru";
	Страница = "/soft_versions/";
	Соединение = Новый HTTPСоединение(АдресСайта,,,,,, Новый ЗащищенноеСоединениеOpenSSL);
	
	Заголовки = Новый Соответствие;
	Заголовки.Вставить("Host", АдресСайта);
	Заголовки.Вставить("Accept", "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8");
	Заголовки.Вставить("Accept-Language", "ru-RU,ru;q=0.5");
	Заголовки.Вставить("Connection", "keep-alive");
	Заголовки.Вставить("User-Agent", "1C+Enterprise/8.3");
	
	Запрос = Новый HTTPЗапрос(Страница, Заголовки);
	Попытка
		Ответ = Соединение.Получить(Запрос);
		СтрокаОтвета = Ответ.ПолучитьТелоКакСтроку("UTF-8");
	Исключение
		СтрокаОтвета = "";
	КонецПопытки;
	
	Если ЗначениеЗаполнено(СтрокаОтвета) Тогда
		ПозицияНачала = СтрНайти(СтрокаОтвета, fast8Имя);
		Если ПозицияНачала <> 0 Тогда
			ПозицияОкончания = СтрНайти(СтрокаОтвета, "</p",, ПозицияНачала);
			СтрокаВерсии = Сред(СтрокаОтвета, ПозицияНачала, ПозицияОкончания - ПозицияНачала);
			ВерсияНаСайте = СокрЛП(СтрЗаменить(СтрокаВерсии, fast8Имя, ""));
			Если ВерсияНаСайте <> fast8Версия Тогда
				fast8СтатусОбновления = "Доступно обновление!";
			Иначе
				fast8СтатусОбновления = "Версия актуальна";
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(fast8СтатусОбновления) Тогда
		fast8СтатусОбновления = "Не удалось получить информацию об обновлении";
	КонецЕсли;
	
КонецПроцедуры // fast8ПроверитьОбновлениеНажатие()

#КонецОбласти // ОбработчикиСобытийЭлементовШапкиФормы
