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

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция СведенияОВнешнейОбработке() Экспорт
	
	// Если запуск осуществляется при отсутствии БСП
	БезопасныйРежимВключен = БезопасныйРежим();
	УстановитьБезопасныйРежим(Истина);
	МодульДополнительныеОтчетыИОбработки = Вычислить("ДополнительныеОтчетыИОбработки");
	МодульДополнительныеОтчетыИОбработкиКлиентСервер = Вычислить("ДополнительныеОтчетыИОбработкиКлиентСервер");
	УстановитьБезопасныйРежим(БезопасныйРежимВключен);

	Информация = ИнформацияОПрограмме();
	
    ПараметрыРегистрации = МодульДополнительныеОтчетыИОбработки.СведенияОВнешнейОбработке();
    ПараметрыРегистрации.Вид = МодульДополнительныеОтчетыИОбработкиКлиентСервер.ВидОбработкиДополнительнаяОбработка();
    ПараметрыРегистрации.Версия = Информация.Версия;
    ПараметрыРегистрации.БезопасныйРежим = Информация.БезопасныйРежим;
    ПараметрыРегистрации.Информация = Информация.Описание;
    
    Команда = ПараметрыРегистрации.Команды.Добавить();
    Команда.Представление = Информация.Синоним;
    Команда.Идентификатор = Информация.Имя;
    Команда.Использование = МодульДополнительныеОтчетыИОбработкиКлиентСервер.ТипКомандыОткрытиеФормы();
    Команда.ПоказыватьОповещение = Истина;
    Команда.Модификатор = Информация.Имя;
    
    Возврат ПараметрыРегистрации;
    
КонецФункции // СведенияОВнешнейОбработке()

Функция ИнформацияОПрограмме() Экспорт

	Информация = Новый Структура;
	Информация.Вставить("АдресНаСайте", "https://fast8.ru/FAST8DatabaseTablesAnalitics/");
	Информация.Вставить("Версия", Метаданные().Комментарий);
	Информация.Вставить("Имя", Метаданные().Имя);
	Информация.Вставить("Синоним", Метаданные().Синоним);
	Информация.Вставить("Описание", "Внешняя обработка анализа таблиц базы для 1С:Предприятие 8");
	Информация.Вставить("БезопасныйРежим", Истина);
	Информация.Вставить("Автор", "sa1m0nn FAST8, Екатеринбург, 2021");
	
	Возврат Информация;
	
КонецФункции // ИнформацияОПрограмме()

#КонецОбласти // ПрограммныйИнтерфейс

#КонецЕсли