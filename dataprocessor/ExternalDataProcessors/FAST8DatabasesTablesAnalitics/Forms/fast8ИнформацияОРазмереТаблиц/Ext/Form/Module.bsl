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
	
	ПолеТекста.УстановитьТекст(
	"/* Пример запроса для MS SQL Server */
	|
	|USE [DB_Name]
	|SELECT
	|	TAB.name AS TableName,
	|	SUM(UN.total_pages) * 8 / 1024 AS SizeMB 
	|FROM
	|	sys.tables AS TAB
	|	INNER JOIN sys.partitions AS PART
	|		ON TAB.object_id = PART.object_id
	|	INNER JOIN sys.allocation_units AS UN
	|		ON PART.partition_id = UN.container_id
	|GROUP BY
	|	TAB.name
	|ORDER BY
	|	SizeMB DESC");
	
КонецПроцедуры // ПриСозданииНаСервере()

#КонецОбласти // ОбработчикиСобытийФормы
