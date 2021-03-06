﻿
&Вместо("ПодключитьВнешнююОбработку")
Функция ОтладкаВнешних_ПодключитьВнешнююОбработку(Ссылка)
	
	// Проверка корректности переданных параметров.
	Если ТипЗнч(Ссылка) <> Тип("СправочникСсылка.ДополнительныеОтчетыИОбработки") 
		Или Ссылка = Справочники.ДополнительныеОтчетыИОбработки.ПустаяСсылка() Тогда
		Возврат Неопределено;
	КонецЕсли;

	// Нужна ли отладка?
	ОтладкаВнешних=Ложь;
	
	Отбор = Новый Структура("ВнешняяОбработка", Ссылка);
	// В любом случае возвращает структуру, если даже нет записи
	ОбработкаДопСведения=РегистрыСведений.ОтладкаВнешних_ВнешниеОбработкиОтладка.Получить(Отбор);
	//ОбработкаВыборка=РегистрыСведений.ОтладкаВнешних_ВнешняяОбработкаОтладка.Выбрать(Отбор);
	
	//ОтлаживаемаяСсылка=Справочники.ОтладкаВнешних_Отлаживаемые.НайтиПоРеквизиту("СсылкаНаОбработку", Ссылка);
	
	//Если НЕ ОтлаживаемаяСсылка=Справочники.ОтладкаВнешних_Отлаживаемые.ПустаяСсылка() И ОтлаживаемаяСсылка.Отладка Тогда  
	Если ОбработкаДопСведения.Отладка И ЗначениеЗаполнено(ОбработкаДопСведения.ИмяФайла) Тогда  
		
		// Указана ссылка и галка отладка
		
		Если НЕ ОбработкаДопСведения.Пользователь = Справочники.Пользователи.ПустаяСсылка() Тогда // Указан пользователь
		
			ТекПользователь=Пользователи.ТекущийПользователь();
			
			Если ТекПользователь=ОбработкаДопСведения.Пользователь Тогда
				// Нужна отладка
			    ОтладкаВнешних=Истина;
			КонецЕсли;

		Иначе  // Пользователь не указан
		
			ОтладкаВнешних=Истина;
		
		КонецЕсли; // конец пользователя
			
	КонецЕсли; // конец проверки нужна ли отладка
	
	Если ОтладкаВнешних Тогда
	
		Возврат ПодключитьВнешнююОбработкуСОтладкой(Ссылка, ОбработкаДопСведения.ИмяФайла);
	
	Иначе // отладка не нужна, Стандартное поведение системы
	
		Результат = ПродолжитьВызов(Ссылка);
		Возврат Результат;
	
	КонецЕсли; 
	
		
	

	
КонецФункции

Функция ПодключитьВнешнююОбработкуСОтладкой(Ссылка, ИмяФайлаОбработки)

		
		
		// Здесь нужно указать имя файла обработки. 
		// Если база файловая, используем каталог базы
		
		//Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		//
		//	КаталогБазы = ОбщегоНазначенияКлиентСервер.КаталогФайловойИнформационнойБазы();
		//
		//Иначе // база не файловая, нужна настройка
		//
		//	КаталогБазы = "c:\"; // Нужны настройки
		//
		//КонецЕсли; 
		
		//ИмяФайлаОбработки = ОтлаживаемаяСсылка.ИмяФайла;
		
		//ИмяФайла = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "ИмяФайла");
		//ИмяФайлаОбработки = ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(КаталогБазы, ИмяФайла);
		
		// Если файла нет, выгружаем из обработки
		// Если есть, то не трогаем. Не забываем потом перезагрузить!
		ФайлОбработки = Новый Файл(ИмяФайлаОбработки);
		Если НЕ ФайлОбработки.Существует() Тогда
		
			ХранилищеОбработки = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "ХранилищеОбработки");
			ДвоичныеДанные = ХранилищеОбработки.Получить();
			ДвоичныеДанные.Записать(ИмяФайлаОбработки);
		
		КонецЕсли; 
		
		Вид = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "Вид");
		Если Вид = Перечисления.ВидыДополнительныхОтчетовИОбработок.Отчет
			Или Вид = Перечисления.ВидыДополнительныхОтчетовИОбработок.ДополнительныйОтчет Тогда
			Менеджер = ВнешниеОтчеты;
		Иначе
			Менеджер = ВнешниеОбработки;
		КонецЕсли;

		
		ИмяОбработки = Менеджер.Создать(ИмяФайлаОбработки, Ложь);
		// Мое написание
		//ИмяОбработки = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "ИмяОбъекта");
		// Взято с интеренета
		ИмяОбработки = СокрЛП(ИмяОбработки.Метаданные().Имя); // ИМЯ(!) Внешней обработки
		
		Возврат ИмяОбработки;

КонецФункции // ПодключитьВнешнююОбработкуСОтладкой()

// На просторах интернета пишут, что нужно поменять и эту функцию
// Но поменять сложно, и без нее вроде работает
//Процедура ПриПолученииРегистрационныхДанных(Объект, РегистрационныеДанные,
//     ПараметрыРегистрации, РезультатРегистрации)
//...
//// Было:
//// ВнешнийОбъект = Менеджер.Создать(РезультатРегистрации.ИмяОбъекта);
//// Стало:
//ВнешнийОбъект = Менеджер.Создать("c:\МояОбработка.epf", Ложь);
//...