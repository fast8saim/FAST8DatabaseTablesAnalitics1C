﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("ПолноеИмяМетаданных", fast8ПолноеИмяМетаданных);
	
	Если Не ЗначениеЗаполнено(fast8ПолноеИмяМетаданных) Тогда
		Отказ = Истина;
		СтандартнаяОбработка = Ложь;
	Иначе
		ЗаполнитьИнформацию();
	КонецЕсли;
	
КонецПроцедуры // ПриСозданииНаСервере()

&НаСервере
Процедура ЗаполнитьИнформацию()
	
	Заголовок = fast8ПолноеИмяМетаданных;
	
	МетаданныеСсылки	= Метаданные.НайтиПоПолномуИмени(fast8ПолноеИмяМетаданных);
	fast8ЭтоДокумент	= Метаданные.Документы.Содержит(МетаданныеСсылки);
	fast8ЭтоПланОбмена	= Метаданные.ПланыОбмена.Содержит(МетаданныеСсылки);
	fast8ЭтоКонстанта	= Метаданные.Константы.Содержит(МетаданныеСсылки);
	fast8ЭтоРегистр		= Метаданные.РегистрыСведений.Содержит(МетаданныеСсылки) Или Метаданные.РегистрыРасчета.Содержит(МетаданныеСсылки) Или Метаданные.РегистрыНакопления.Содержит(МетаданныеСсылки) Или Метаданные.РегистрыБухгалтерии.Содержит(МетаданныеСсылки);

	УстановитьВидимость();
	
	ЗаполнитьРеквизиты();
	ЗаполнитьПодпискиНаСобытия();
	ЗаполнитьПланыОбмена();
	ЗаполнитьФункциональныеОпции();
	ЗаполнитьПодсистемы();
	ЗаполнитьРегистраторы();
	ЗаполнитьДвижения();
	
	ДобавитьСтатистикуВЗаголовок("ГруппаДвижения",				fast8Движения);
	ДобавитьСтатистикуВЗаголовок("ГруппаПланыОбмена",			fast8ПланыОбмена);
	ДобавитьСтатистикуВЗаголовок("ГруппаПодпискиНаСобытия",		fast8ПодпискиНаСобытия);
	ДобавитьСтатистикуВЗаголовок("ГруппаРегистраторы",			fast8Регистраторы);
	ДобавитьСтатистикуВЗаголовок("ГруппаПодсистемы",			fast8Подсистемы);
	ДобавитьСтатистикуВЗаголовок("ГруппаФункциональныеОпции",	fast8ФункциональныеОпции);
			
КонецПроцедуры // ЗаполнитьИнформацию()

&НаСервере
Процедура ДобавитьСтатистикуВЗаголовок(ИмяГруппы, Таблица)
	
	Если ТипЗнч(Таблица) = Тип("ДанныеФормыДерево") Тогда
		Количество = Таблица.ПолучитьЭлементы().Количество();
	Иначе
		Количество = Таблица.Количество();
	КонецЕсли;
	
	Элементы[ИмяГруппы].Заголовок = Элементы[ИмяГруппы].Заголовок + " (" + Количество + ")";
	
КонецПроцедуры // ДобавитьСтатистикуВЗаголовок()

&НаСервере
Процедура УстановитьВидимость()
	
	Элементы.ГруппаРеквизиты.Видимость		= Не fast8ЭтоКонстанта;
	Элементы.ГруппаДвижения.Видимость		= fast8ЭтоДокумент;
	Элементы.ГруппаРегистраторы.Видимость	= fast8ЭтоРегистр;
	Элементы.ГруппаПланыОбмена.Видимость	= Не fast8ЭтоПланОбмена;
	
	Элементы.fast8ПользователиПроведение.Видимость	= fast8ЭтоДокумент;
	Элементы.fast8ПользователиДобавление.Видимость	= Не fast8ЭтоРегистр;
	Элементы.fast8ПользователиУдаление.Видимость	= Не fast8ЭтоРегистр;
	Элементы.fast8РолиПроведение.Видимость			= fast8ЭтоДокумент;
	Элементы.fast8РолиДобавление.Видимость			= Не fast8ЭтоРегистр;
	Элементы.fast8РолиУдаление.Видимость			= Не fast8ЭтоРегистр;
	
КонецПроцедуры // УстановитьВидимость()

&НаСервере
Процедура ЗаполнитьРеквизиты()
	
	fast8Реквизиты.ПолучитьЭлементы().Очистить();
		
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	МетаданныеСсылки = Метаданные.НайтиПоПолномуИмени(fast8ПолноеИмяМетаданных);
	
	ВсеТипыКонфигурации = ПолучитьСтруктуруТипов();
	
	Если fast8ЭтоРегистр Тогда
		УровеньШапка = fast8Реквизиты.ПолучитьЭлементы().Добавить();
		УровеньШапка.Имя = "Измерения (" + МетаданныеСсылки.Измерения.Количество() + ")";
		
		ЗаполнитьСтрокуРеквизитов(МетаданныеСсылки.Измерения, УровеньШапка, ВсеТипыКонфигурации);
		
		УровеньШапка = fast8Реквизиты.ПолучитьЭлементы().Добавить();
		УровеньШапка.Имя = "Ресурсы (" + МетаданныеСсылки.Ресурсы.Количество() + ")";
		
		ЗаполнитьСтрокуРеквизитов(МетаданныеСсылки.Ресурсы, УровеньШапка, ВсеТипыКонфигурации);
	КонецЕсли;		
	
	Если Не fast8ЭтоКонстанта Тогда
		УровеньШапка = fast8Реквизиты.ПолучитьЭлементы().Добавить();
		УровеньШапка.Имя = "Реквизиты (" + (МетаданныеСсылки.СтандартныеРеквизиты.Количество() + МетаданныеСсылки.Реквизиты.Количество()) + ")";
		
		ЗаполнитьСтрокуРеквизитов(МетаданныеСсылки.СтандартныеРеквизиты, УровеньШапка, ВсеТипыКонфигурации);
		ЗаполнитьСтрокуРеквизитов(МетаданныеСсылки.Реквизиты, УровеньШапка, ВсеТипыКонфигурации);
	КонецЕсли;
		
	Если Не fast8ЭтоРегистр И Не fast8ЭтоКонстанта Тогда
		Для Каждого ТабличнаяЧасть Из МетаданныеСсылки.ТабличныеЧасти Цикл
			УровеньТабличнаяЧасть = fast8Реквизиты.ПолучитьЭлементы().Добавить();
			УровеньТабличнаяЧасть.Имя		= ТабличнаяЧасть.Имя + " (табличная часть) (" + ТабличнаяЧасть.Реквизиты.Количество() + ")";
			УровеньТабличнаяЧасть.Синоним	= ТабличнаяЧасть.Синоним;
			ЗаполнитьСтрокуРеквизитов(ТабличнаяЧасть.Реквизиты, УровеньТабличнаяЧасть, ВсеТипыКонфигурации);
			
			ЗаполнитьПринадлежностьРеквизита(ТабличнаяЧасть, УровеньТабличнаяЧасть);
			
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры // ЗаполнитьРеквизиты()

&НаСервере
Функция ПолучитьСтруктуруТипов()
	
	ГруппыМетаданных = Новый Структура;
	ГруппыМетаданных.Вставить("Справочники",		"Справочник");
	ГруппыМетаданных.Вставить("Документы",			"Документ");
	ГруппыМетаданных.Вставить("Перечисления",		"Перечисление");
	ГруппыМетаданных.Вставить("ПланыОбмена",		"ПланОбмена");
	ГруппыМетаданных.Вставить("ПланыВидовХарактеристик", "ПланВидовХарактеристик");
	ГруппыМетаданных.Вставить("ПланыВидовРасчета",	"ПланВидовРасчета");
	ГруппыМетаданных.Вставить("ПланыСчетов",		"ПланСчетов");
	
	СоответствиеТипов = Новый Соответствие;
	
	Для Каждого ГруппаМетаданных Из ГруппыМетаданных Цикл
		Для Каждого МетаОбъект Из Метаданные[ГруппаМетаданных.Ключ] Цикл
			СоответствиеТипов.Вставить(Тип(ГруппаМетаданных.Значение + "Ссылка." + МетаОбъект.Имя), ГруппаМетаданных.Значение + "." + МетаОбъект.Имя);
		КонецЦикла;
	КонецЦикла;
	
	Возврат СоответствиеТипов;
		
КонецФункции // ПолучитьСтруктуруТипов()

&НаСервере
Процедура ЗаполнитьСтрокуРеквизитов(Коллекция, СтрокаДерева, ВсеТипыКонфигурации)
	
	Для Каждого Реквизит Из Коллекция Цикл
		НовыйРеквизит = СтрокаДерева.ПолучитьЭлементы().Добавить();
		НовыйРеквизит.Имя		= Реквизит.Имя;
		НовыйРеквизит.Синоним	= Реквизит.Синоним;
		
		СтрокаТипы = Новый Массив;
		МассивТипов = Реквизит.Тип.Типы();
		
		ТипБулево	= Тип("Булево");
		ТипЧисло	= Тип("Число");
		ТипДата		= Тип("Дата");
		ТипСтрока	= Тип("Строка");
		
		Для Каждого ТекущийТип Из МассивТипов Цикл
			Если ТекущийТип = ТипБулево Тогда
				СтрокаТипы.Добавить("Булево");
			ИначеЕсли ТекущийТип = ТипЧисло Тогда
				СтрокаТипы.Добавить("Число " + Реквизит.Тип.КвалификаторыЧисла.Разрядность + "." + Реквизит.Тип.КвалификаторыЧисла.РазрядностьДробнойЧасти);
			ИначеЕсли ТекущийТип = ТипДата Тогда
				СтрокаТипы.Добавить("Дата");
			ИначеЕсли ТекущийТип = ТипСтрока Тогда
				СтрокаТипы.Добавить("Строка " + Реквизит.Тип.КвалификаторыСтроки.Длина);
			Иначе
				СтрокаТипы.Добавить(ВсеТипыКонфигурации.Получить(ТекущийТип));
			КонецЕсли;
		КонецЦикла;
		
		НовыйРеквизит.Тип = СтрокиСоединить(СтрокаТипы, ", ");
		
		ЗаполнитьПринадлежностьРеквизита(Реквизит, НовыйРеквизит);
		
	КонецЦикла;
	
КонецПроцедуры // ЗаполнитьСтрокуРеквизитов()

Процедура ЗаполнитьПринадлежностьРеквизита(Реквизит, ПолеТаблицы)
	
	ПолеТаблицы.Принадлежность = "Конфигурация";
	Если ТипЗнч(Реквизит) = Тип("ОбъектМетаданных") Тогда
		Если Реквизит.РасширениеКонфигурации() = Неопределено Тогда
			Если Реквизит.ЕстьИзмененияРасширениямиКонфигурации() Тогда
				ПолеТаблицы.Принадлежность = "Изменено в расширении";
			КонецЕсли;
		Иначе
			ПолеТаблицы.Принадлежность = "Объект расширения";
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры // ЗаполнитьПринадлежностьРеквизита()

&НаСервере
Процедура ЗаполнитьРолиИПользователей()
	
	fast8Роли.Очистить();
	fast8Пользователи.Очистить();
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	МетаданныеСсылки = Метаданные.НайтиПоПолномуИмени(fast8ПолноеИмяМетаданных);
	
	Для Каждого Роль Из Метаданные.Роли Цикл
		ПравоЧтение		= ПравоДоступа("Чтение", МетаданныеСсылки, Роль);
		ПравоДобавление	= ?(fast8ЭтоРегистр Или fast8ЭтоКонстанта, Ложь, ПравоДоступа("Добавление", МетаданныеСсылки, Роль));
		ПравоИзменение	= ПравоДоступа("Изменение", МетаданныеСсылки, Роль);
		ПравоУдаление	= ?(fast8ЭтоРегистр Или fast8ЭтоКонстанта, Ложь, ПравоДоступа("Удаление", МетаданныеСсылки, Роль));
		ПравоПроведение	= ?(fast8ЭтоДокумент, ПравоДоступа("Проведение", МетаданныеСсылки, Роль), Ложь);
		
		Если ПравоЧтение Или ПравоДобавление Или ПравоИзменение Или ПравоУдаление Или ПравоПроведение Тогда
			НоваяСтрока = fast8Роли.Добавить();
			НоваяСтрока.Роль = Роль.Имя;
			НоваяСтрока.Синоним = Роль.Синоним;
		
			НоваяСтрока.Чтение		= ПравоЧтение;
			НоваяСтрока.Добавление	= ПравоДобавление;
			НоваяСтрока.Изменение	= ПравоИзменение;
			НоваяСтрока.Удаление	= ПравоУдаление;
			НоваяСтрока.Проведение	= ПравоПроведение;
		КонецЕсли;
	КонецЦикла;
	fast8Роли.Сортировать("Роль");
	
	ПользователиИБ = ПользователиИнформационнойБазы.ПолучитьПользователей();
	Для Каждого ПользовательИБ Из ПользователиИБ Цикл
		ПравоЧтение		= ПравоДоступа("Чтение", МетаданныеСсылки, ПользовательИБ);
		ПравоДобавление	= ?(fast8ЭтоРегистр Или fast8ЭтоКонстанта, Ложь, ПравоДоступа("Добавление", МетаданныеСсылки, ПользовательИБ));
		ПравоИзменение	= ПравоДоступа("Изменение", МетаданныеСсылки, ПользовательИБ);
		ПравоУдаление	= ?(fast8ЭтоРегистр Или fast8ЭтоКонстанта, Ложь, ПравоДоступа("Удаление", МетаданныеСсылки, ПользовательИБ));
		ПравоПроведение	= ?(fast8ЭтоДокумент, ПравоДоступа("Проведение", МетаданныеСсылки, ПользовательИБ), Ложь);
		
		Если ПравоЧтение Или ПравоДобавление Или ПравоИзменение Или ПравоУдаление Или ПравоПроведение Тогда
			НоваяСтрока = fast8Пользователи.Добавить();
			НоваяСтрока.Пользователь = ПользовательИБ.Имя;
					
			НоваяСтрока.Чтение		= ПравоЧтение;
			НоваяСтрока.Добавление	= ПравоДобавление;
			НоваяСтрока.Изменение	= ПравоИзменение;
			НоваяСтрока.Удаление	= ПравоУдаление;
			НоваяСтрока.Проведение	= ПравоПроведение;
		КонецЕсли;
	КонецЦикла;
	fast8Пользователи.Сортировать("Пользователь");
		
КонецПроцедуры // ЗаполнитьРоли()

&НаКлиенте
Процедура fast8ЗаполнитьПрава(Команда)
	
	ЗаполнитьРолиИПользователей();
	
КонецПроцедуры // ЗаполнитьПрава()

&НаСервере
Процедура ЗаполнитьПодпискиНаСобытия()
	
	fast8ПодпискиНаСобытия.Очистить();
	
	УстановитьПривилегированныйРежим(Истина);
	МетаданныеСсылки = Метаданные.НайтиПоПолномуИмени(fast8ПолноеИмяМетаданных);
	ПолноеИмяМетаданных = МетаданныеСсылки.ПолноеИмя();
	
	Разделитель	= Найти(ПолноеИмяМетаданных, ".");
	ЛеваяЧасть	= Лев(ПолноеИмяМетаданных, Разделитель - 1);
	ПраваяЧасть	= Сред(ПолноеИмяМетаданных, Разделитель);
	Если fast8ЭтоРегистр Тогда
		ТипНабора	= Тип(ЛеваяЧасть + "НаборЗаписей" + ПраваяЧасть);
	ИначеЕсли Не fast8ЭтоКонстанта Тогда
		ТипОбъекта	= Тип(ЛеваяЧасть + "Объект" + ПраваяЧасть);
		ТипСсылки	= Тип(ЛеваяЧасть + "Ссылка" + ПраваяЧасть);
	КонецЕсли;
	ТипМенеджера = Тип(ЛеваяЧасть + "Менеджер" + ПраваяЧасть);
			
	Для Каждого Подписка Из Метаданные.ПодпискиНаСобытия Цикл
		ТипыИсточника = Подписка.Источник.Типы();
		Если ТипыИсточника.Найти(ТипОбъекта) <> Неопределено Или ТипыИсточника.Найти(ТипСсылки) <> Неопределено Или ТипыИсточника.Найти(ТипМенеджера) <> Неопределено Или ТипыИсточника.Найти(ТипНабора) <> Неопределено Тогда
			НоваяСтрока = fast8ПодпискиНаСобытия.Добавить();
			НоваяСтрока.Подписка	= Подписка.Имя;
			НоваяСтрока.Событие		= Подписка.Событие;
			НоваяСтрока.Обработчик	= Подписка.Обработчик;
		КонецЕсли;
	КонецЦикла;
	fast8ПодпискиНаСобытия.Сортировать("Событие, Подписка");
	
КонецПроцедуры // ЗаполнитьПодпискиНаСобытия()

&НаСервере
Процедура ЗаполнитьПланыОбмена()
	
	fast8ПланыОбмена.Очистить();
	
	Если fast8ЭтоПланОбмена Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	МетаданныеСсылки = Метаданные.НайтиПоПолномуИмени(fast8ПолноеИмяМетаданных);
				
	Для Каждого ПланОбмена Из Метаданные.ПланыОбмена Цикл
		Если ПланОбмена.Состав.Содержит(МетаданныеСсылки) Тогда
			НоваяСтрока = fast8ПланыОбмена.Добавить();
			НоваяСтрока.ПланОбменаИмяУзел = ПланОбмена.Имя;
		КонецЕсли;
	КонецЦикла;
		
КонецПроцедуры // ЗаполнитьПланыОбмена()

&НаСервере
Процедура ЗаполнитьФункциональныеОпции()
	
	fast8ФункциональныеОпции.Очистить();
	
	УстановитьПривилегированныйРежим(Истина);
	МетаданныеСсылки = Метаданные.НайтиПоПолномуИмени(fast8ПолноеИмяМетаданных);
	
	Для Каждого Опция Из Метаданные.ФункциональныеОпции Цикл
		Если Опция.Состав.Содержит(МетаданныеСсылки) Тогда
			НоваяСтрока = fast8ФункциональныеОпции.Добавить();
			НоваяСтрока.Имя = Опция.Имя;
			НоваяСтрока.Синоним = Опция.Синоним;
			НоваяСтрока.Включена = ПолучитьФункциональнуюОпцию(Опция.Имя);
		КонецЕсли;
	КонецЦикла;
	fast8ФункциональныеОпции.Сортировать("Имя");
	
КонецПроцедуры // ЗаполнитьФункциональныеОпции()

&НаСервере
Процедура ЗаполнитьПодсистемы()
	
	fast8Подсистемы.ПолучитьЭлементы().Очистить();
	ДеревоПодсистем = РеквизитФормыВЗначение("fast8Подсистемы", Тип("ДеревоЗначений"));
	
	УстановитьПривилегированныйРежим(Истина);
	МетаданныеСсылки = Метаданные.НайтиПоПолномуИмени(fast8ПолноеИмяМетаданных);
	
	ЗаполнитьДанныеПодсистем(МетаданныеСсылки, Метаданные.Подсистемы, ДеревоПодсистем);
	УдалитьЛишниеПодсистемы(ДеревоПодсистем);
		
	ЗначениеВРеквизитФормы(ДеревоПодсистем, "fast8Подсистемы");
	
КонецПроцедуры // ЗаполнитьПодсистемы()

&НаСервере
Процедура ЗаполнитьДанныеПодсистем(МетаданныеСсылки, Подсистемы, ЗаполняемаяКоллекция)
	
	Для Каждого Подсистема Из Подсистемы Цикл
		НоваяСтрока = ЗаполняемаяКоллекция.Строки.Добавить();
		НоваяСтрока.Имя					= Подсистема.Имя;
		НоваяСтрока.Синоним				= Подсистема.Синоним;
		НоваяСтрока.ВключатьВКомандныйИнтерфейс = Подсистема.ВключатьВКомандныйИнтерфейс;
		НоваяСтрока.ОбъектВПодсистеме	= Подсистема.Состав.Содержит(МетаданныеСсылки);
		НоваяСтрока.ОбъектовВВетке		= ?(НоваяСтрока.ОбъектВПодсистеме, 1, 0);
	
		ЗаполнитьДанныеПодсистем(МетаданныеСсылки, Подсистема.Подсистемы, НоваяСтрока);
		
		НоваяСтрока.ОбъектовВВетке = НоваяСтрока.ОбъектовВВетке + НоваяСтрока.Строки.Итог("ОбъектовВВетке");
	КонецЦикла;
	
КонецПроцедуры // ЗаполнитьДанныеПодсистемы()

&НаСервере
Процедура УдалитьЛишниеПодсистемы(УровеньНиже)
	
	МассивУдалить = Новый Массив;
	Для Каждого УровеньВыше Из УровеньНиже.Строки Цикл
		Если УровеньВыше.ОбъектовВВетке = 0 Тогда
			МассивУдалить.Добавить(УровеньВыше);
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого СтрокаУдалить Из МассивУдалить Цикл
		УровеньНиже.Строки.Удалить(СтрокаУдалить);
	КонецЦикла;
	
	Для Каждого УровеньВыше Из УровеньНиже.Строки Цикл
		УдалитьЛишниеПодсистемы(УровеньВыше);
	КонецЦикла;
	
КонецПроцедуры // УдалитьЛишниеПодсистемы()

&НаСервере
Процедура ЗаполнитьРегистраторы()
	
	Если Не fast8ЭтоРегистр Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	МетаданныеСсылки = Метаданные.НайтиПоПолномуИмени(fast8ПолноеИмяМетаданных);
	
	Для Каждого Регистратор Из Метаданные.Документы Цикл
		Если Регистратор.Движения.Содержит(МетаданныеСсылки) Тогда
			НовыйРегистратор = fast8Регистраторы.Добавить();
			НовыйРегистратор.Имя = Регистратор.Имя;
			НовыйРегистратор.Синоним = Регистратор.Синоним;
		КонецЕсли;
	КонецЦикла;
	
	fast8Регистраторы.Сортировать("Имя");
	
КонецПроцедуры // ЗаполнитьРегистраторы()

&НаСервере
Процедура ЗаполнитьДвижения()
	
	Если Не fast8ЭтоДокумент Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	МетаданныеСсылки = Метаданные.НайтиПоПолномуИмени(fast8ПолноеИмяМетаданных);
	
	Для Каждого Движение Из МетаданныеСсылки.Движения Цикл
		НовоеДвижение = fast8Движения.Добавить();
		НовоеДвижение.Имя		= Движение.Имя;
		НовоеДвижение.Синоним	= Движение.Синоним;
		
		ПолноеИмяРегистра = Движение.ПолноеИмя();
		НовоеДвижение.Вид		= Лев(ПолноеИмяРегистра, Найти(ПолноеИмяРегистра, ".") - 1);
	КонецЦикла;
	fast8Движения.Сортировать("Вид, Имя");
	
КонецПроцедуры // ЗаполнитьДвижения()

Функция СтрокиСоединить(МассивСтрок, Разделитель)
	
	// СтрСоединить()
	
	СтрокаРезультат = "";
	ПерваяСтрока = Истина;
	Для Каждого ТекущаяСтрока Из МассивСтрок Цикл
		СтрокаРезультат = СтрокаРезультат + ?(ПерваяСтрока, "", Разделитель) + ТекущаяСтрока;
		ПерваяСтрока = Ложь;
	КонецЦикла;
	
	Возврат СтрокаРезультат;
	
КонецФункции // СтрокиСоединить()