
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
