USE master;
DROP DATABASE IF EXISTS CriminalNetwork;
CREATE DATABASE CriminalNetwork;
USE CriminalNetwork;


CREATE TABLE Suspect
(
    id INT NOT NULL PRIMARY KEY,
    name NVARCHAR(50) NOT NULL,
    birthdate DATE
) AS NODE;


CREATE TABLE Crime
(
    id INT NOT NULL PRIMARY KEY,
    type NVARCHAR(50) NOT NULL,
    crime_date DATE
) AS NODE;


CREATE TABLE Location
(
    id INT NOT NULL PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    city NVARCHAR(50) NOT NULL
) AS NODE;


CREATE TABLE Evidence
(
    id INT NOT NULL PRIMARY KEY,
    type NVARCHAR(50) NOT NULL,
    description NVARCHAR(255)
) AS NODE;


CREATE TABLE Officer
(
    id INT NOT NULL PRIMARY KEY,
    name NVARCHAR(50) NOT NULL,
    rank NVARCHAR(30)
) AS NODE;


--Таблицы рёбер (AS EDGE)

CREATE TABLE SeenAt
(
    seen_date DATE,
    method NVARCHAR(100)  -- Например, "по камерам"
) AS EDGE;

CREATE TABLE LinkedTo
(
    relation_type NVARCHAR(50)  -- Например, "отпечатки"
) AS EDGE;

CREATE TABLE Investigates
(
    role NVARCHAR(50)  -- Например, "главный следователь"
) AS EDGE;

CREATE TABLE InvolvedIn
(
    role NVARCHAR(50)  -- Например, "подозреваемый"
) AS EDGE;

CREATE TABLE TookPlaceAt
AS EDGE;


CREATE TABLE EvidenceInCrime
AS EDGE;

CREATE TABLE WorkedTogether
(
    collaboration_date DATE,  -- Дата совместной работы
    cases_count INT           -- Количество совместных дел
) AS EDGE;

-- Связь между офицерами (офицер -> работал с -> офицер)
ALTER TABLE WorkedTogether
ADD CONSTRAINT EC_WorkedTogether CONNECTION (Officer TO Officer);
-- Подозреваемый был замечен в локации
ALTER TABLE SeenAt
ADD CONSTRAINT EC_SeenAt CONNECTION (Suspect TO Location);

-- Подозреваемый связан с уликой
ALTER TABLE LinkedTo
ADD CONSTRAINT EC_LinkedTo CONNECTION (Suspect TO Evidence);

-- Офицер расследует преступление
ALTER TABLE Investigates
ADD CONSTRAINT EC_Investigates CONNECTION (Officer TO Crime);

-- Подозреваемый вовлечён в преступление
ALTER TABLE InvolvedIn
ADD CONSTRAINT EC_InvolvedIn CONNECTION (Suspect TO Crime);

-- Преступление произошло в месте
ALTER TABLE TookPlaceAt
ADD CONSTRAINT EC_TookPlaceAt CONNECTION (Crime TO Location);

-- Улика относится к преступлению
ALTER TABLE EvidenceInCrime
ADD CONSTRAINT EC_EvidenceInCrime CONNECTION (Evidence TO Crime);

GO




---------------------------------------------------------------------------
--Insert into tables

INSERT INTO Suspect (id, name, birthdate) VALUES
(1, N'Даг Джуди', '1983-07-14'),
(2, N'Билл', '1979-11-03'),
(3, N'Боб Андерсон', '1962-03-29'),
(4, N'Стервятник', '1980-06-21'),
(5, N'Джонни Франция', '1981-09-08'),
(6, N'Шеймус Мёрфи', '1970-04-13'),
(7, N'Фредди Малярди', '1985-02-23'),
(8, N'Ник Линджеман', '1977-12-11'),
(9, N'ДиСи Парлов', '1965-05-05'),
(10, N'Мора Фиггис', '1982-08-09');

INSERT INTO Crime (id, type, crime_date) VALUES
(1, N'Угон автомобиля', '2023-01-12'),
(2, N'Трафик наркотиков', '2023-03-09'),
(3, N'Убийство', '2022-12-01'),
(4, N'Ограбление', '2023-05-10'),
(5, N'Похищение', '2022-09-15'),
(6, N'Мошенничество', '2023-02-20'),
(7, N'Кража со взломом', '2023-01-28'),
(8, N'Поджог', '2023-04-18'),
(9, N'Нападение', '2022-10-07'),
(10, N'Киберпреступление', '2023-03-30');

INSERT INTO Evidence (id, type, description) VALUES
(1, N'Отпечаток пальца', N'Найден на двери автомобиля'),
(2, N'Видеонаблюдение', N'Запись со склада'),
(3, N'Текстовые сообщения', N'Переписка Джуди с сообщником'),
(4, N'ДНК', N'На осколках стекла'),
(5, N'Оружие', N'Нож с пятнами крови'),
(6, N'Жесткий диск', N'Содержит нелегальные файлы'),
(7, N'Мешок с деньгами', N'С краской из банка'),
(8, N'Фотография', N'Подозреваемого на месте преступления'),
(9, N'Аудиозапись', N'Признание в телефонном разговоре'),
(10, N'Сожженные документы', N'С места поджога');

INSERT INTO Officer (id, name, rank) VALUES
(1, N'Джейк Перальта', N'Детектив'),
(2, N'Эми Сантьяго', N'Сержант детектив'),
(3, N'Роза Диаз', N'Детектив'),
(4, N'Терри Джеффордс', N'Лейтенант'),
(5, N'Раймонд Холт', N'Капитан'),
(6, N'Чарльз Бойл', N'Детектив'),
(7, N'Джина Линетти', N'Гражданский администратор'),
(8, N'Адриан Пименто', N'Детектив'),
(9, N'Кевин Кознер', N'Консультант'),
(10, N'Скалли', N'Детектив');

INSERT INTO Location (id, name, city) VALUES
(1, N'Бруклинская верфь', N'Нью-Йорк'),
(2, N'99-й участок', N'Нью-Йорк'),
(3, N'Гараж Дага Джуди', N'Нью-Йорк'),
(4, N'Склад Шеймуса', N'Нью-Йорк'),
(5, N'Заброшенное здание', N'Нью-Йорк'),
(6, N'Банк в центре', N'Нью-Йорк'),
(7, N'Книжный магазин Парлова', N'Нью-Йорк'),
(8, N'Автосервис Франция', N'Нью-Йорк'),
(9, N'Складской блок C-17', N'Нью-Йорк'),
(10, N'Тоннель под мостом', N'Нью-Йорк');

INSERT INTO SeenAt ( $from_id, $to_id, seen_date, method ) VALUES
( (SELECT $node_id FROM Suspect WHERE id = 1), (SELECT $node_id FROM Location WHERE id = 3), '2023-01-10', N'Камера наблюдения' ),
( (SELECT $node_id FROM Suspect WHERE id = 2), (SELECT $node_id FROM Location WHERE id = 5), '2023-01-12', N'Показания свидетеля' ),
( (SELECT $node_id FROM Suspect WHERE id = 3), (SELECT $node_id FROM Location WHERE id = 9), '2023-02-03', N'Запись с дрона' ),
( (SELECT $node_id FROM Suspect WHERE id = 4), (SELECT $node_id FROM Location WHERE id = 6), '2023-03-21', N'Камера наблюдения' ),
( (SELECT $node_id FROM Suspect WHERE id = 5), (SELECT $node_id FROM Location WHERE id = 8), '2023-04-01', N'Анонимный источник' ),
((SELECT $node_id FROM Suspect WHERE id = 6), (SELECT $node_id FROM Location WHERE id = 4), '2023-03-08', N'Камера наблюдения'),
((SELECT $node_id FROM Suspect WHERE id = 7), (SELECT $node_id FROM Location WHERE id = 5), '2023-01-15', N'Показания свидетеля'),
((SELECT $node_id FROM Suspect WHERE id = 8), (SELECT $node_id FROM Location WHERE id = 7), '2023-02-10', N'Анонимный источник'),
((SELECT $node_id FROM Suspect WHERE id = 9), (SELECT $node_id FROM Location WHERE id = 7), '2023-04-05', N'Камера наблюдения'),
((SELECT $node_id FROM Suspect WHERE id = 10), (SELECT $node_id FROM Location WHERE id = 10), '2023-03-25', N'Запись с дрона');


Select * 
from SeenAt;
INSERT INTO LinkedTo ( $from_id, $to_id, relation_type ) VALUES
( (SELECT $node_id FROM Suspect WHERE id = 1), (SELECT $node_id FROM Evidence WHERE id = 1), N'Отпечаток пальца' ),
( (SELECT $node_id FROM Suspect WHERE id = 2), (SELECT $node_id FROM Evidence WHERE id = 2), N'Видеодоказательство' ),
( (SELECT $node_id FROM Suspect WHERE id = 4), (SELECT $node_id FROM Evidence WHERE id = 5), N'ДНК' ),
( (SELECT $node_id FROM Suspect WHERE id = 6), (SELECT $node_id FROM Evidence WHERE id = 4), N'Образец волос' ),
( (SELECT $node_id FROM Suspect WHERE id = 8), (SELECT $node_id FROM Evidence WHERE id = 9), N'Аудиозапись' ),
((SELECT $node_id FROM Suspect WHERE id = 3), (SELECT $node_id FROM Evidence WHERE id = 3), N'Переписка'),
((SELECT $node_id FROM Suspect WHERE id = 5), (SELECT $node_id FROM Evidence WHERE id = 6), N'Цифровые следы'),
((SELECT $node_id FROM Suspect WHERE id = 7), (SELECT $node_id FROM Evidence WHERE id = 7), N'Вещественное доказательство'),
((SELECT $node_id FROM Suspect WHERE id = 9), (SELECT $node_id FROM Evidence WHERE id = 8), N'Фото доказательство'),
((SELECT $node_id FROM Suspect WHERE id = 10), (SELECT $node_id FROM Evidence WHERE id = 10), N'Документальное доказательство');


INSERT INTO TookPlaceAt ( $from_id, $to_id ) VALUES
( (SELECT $node_id FROM Crime WHERE id = 1), (SELECT $node_id FROM Location WHERE id = 3) ),
( (SELECT $node_id FROM Crime WHERE id = 2), (SELECT $node_id FROM Location WHERE id = 4) ),
( (SELECT $node_id FROM Crime WHERE id = 3), (SELECT $node_id FROM Location WHERE id = 5) ),
( (SELECT $node_id FROM Crime WHERE id = 5), (SELECT $node_id FROM Location WHERE id = 6) ),
( (SELECT $node_id FROM Crime WHERE id = 7), (SELECT $node_id FROM Location WHERE id = 9) ),
((SELECT $node_id FROM Crime WHERE id = 4), (SELECT $node_id FROM Location WHERE id = 6)),
((SELECT $node_id FROM Crime WHERE id = 6), (SELECT $node_id FROM Location WHERE id = 7)),
((SELECT $node_id FROM Crime WHERE id = 8), (SELECT $node_id FROM Location WHERE id = 5)),
((SELECT $node_id FROM Crime WHERE id = 9), (SELECT $node_id FROM Location WHERE id = 10)),
((SELECT $node_id FROM Crime WHERE id = 10), (SELECT $node_id FROM Location WHERE id = 1));

-- InvolvedIn (Подозреваемые, связанные с преступлениями)
INSERT INTO InvolvedIn ($from_id, $to_id, role) VALUES
-- Угон автомобиля (преступление 1)
((SELECT $node_id FROM Suspect WHERE id = 1), (SELECT $node_id FROM Crime WHERE id = 1), N'Организатор'),
((SELECT $node_id FROM Suspect WHERE id = 5), (SELECT $node_id FROM Crime WHERE id = 1), N'Водитель'),
((SELECT $node_id FROM Suspect WHERE id = 9), (SELECT $node_id FROM Crime WHERE id = 1), N'Смотрящий'),
-- Трафик наркотиков (преступление 2)
((SELECT $node_id FROM Suspect WHERE id = 6), (SELECT $node_id FROM Crime WHERE id = 2), N'Глава сети'),
((SELECT $node_id FROM Suspect WHERE id = 3), (SELECT $node_id FROM Crime WHERE id = 2), N'Курьер'),
((SELECT $node_id FROM Suspect WHERE id = 7), (SELECT $node_id FROM Crime WHERE id = 2), N'Финансист'),
-- Убийство (преступление 3)
((SELECT $node_id FROM Suspect WHERE id = 4), (SELECT $node_id FROM Crime WHERE id = 3), N'Исполнитель'),
((SELECT $node_id FROM Suspect WHERE id = 8), (SELECT $node_id FROM Crime WHERE id = 3), N'Заказчик'),
-- Ограбление банка (преступление 4)
((SELECT $node_id FROM Suspect WHERE id = 1), (SELECT $node_id FROM Crime WHERE id = 4), N'Схемщик'),
((SELECT $node_id FROM Suspect WHERE id = 2), (SELECT $node_id FROM Crime WHERE id = 4), N'Охранник'),
((SELECT $node_id FROM Suspect WHERE id = 10), (SELECT $node_id FROM Crime WHERE id = 4), N'Хакер'),
-- Похищение (преступление 5)
((SELECT $node_id FROM Suspect WHERE id = 5), (SELECT $node_id FROM Crime WHERE id = 5), N'Похититель'),
((SELECT $node_id FROM Suspect WHERE id = 9), (SELECT $node_id FROM Crime WHERE id = 5), N'Водитель'),
((SELECT $node_id FROM Suspect WHERE id = 3), (SELECT $node_id FROM Crime WHERE id = 5), N'Охранник'),
-- Мошенничество (преступление 6)
((SELECT $node_id FROM Suspect WHERE id = 7), (SELECT $node_id FROM Crime WHERE id = 6), N'Мошенник'),
((SELECT $node_id FROM Suspect WHERE id = 10), (SELECT $node_id FROM Crime WHERE id = 6), N'IT-специалист'),
-- Кража со взломом (преступление 7)
((SELECT $node_id FROM Suspect WHERE id = 2), (SELECT $node_id FROM Crime WHERE id = 7), N'Взломщик'),
((SELECT $node_id FROM Suspect WHERE id = 4), (SELECT $node_id FROM Crime WHERE id = 7), N'Смотрящий'),
-- Поджог (преступление 8)
((SELECT $node_id FROM Suspect WHERE id = 8), (SELECT $node_id FROM Crime WHERE id = 8), N'Поджигатель'),
((SELECT $node_id FROM Suspect WHERE id = 3), (SELECT $node_id FROM Crime WHERE id = 8), N'Сообщник'),
-- Нападение (преступление 9)
((SELECT $node_id FROM Suspect WHERE id = 9), (SELECT $node_id FROM Crime WHERE id = 9), N'Нападавший'),
((SELECT $node_id FROM Suspect WHERE id = 1), (SELECT $node_id FROM Crime WHERE id = 9), N'Подстрекатель'),
-- Киберпреступление (преступление 10)
((SELECT $node_id FROM Suspect WHERE id = 10), (SELECT $node_id FROM Crime WHERE id = 10), N'Хакер'),
((SELECT $node_id FROM Suspect WHERE id = 5), (SELECT $node_id FROM Crime WHERE id = 10), N'Финансист');


INSERT INTO EvidenceInCrime ($from_id, $to_id) VALUES
-- Угон автомобиля (преступление 1)
((SELECT $node_id FROM Evidence WHERE id = 1), (SELECT $node_id FROM Crime WHERE id = 1)),
((SELECT $node_id FROM Evidence WHERE id = 3), (SELECT $node_id FROM Crime WHERE id = 1)),
((SELECT $node_id FROM Evidence WHERE id = 8), (SELECT $node_id FROM Crime WHERE id = 1)),
-- Трафик наркотиков (преступление 2)
((SELECT $node_id FROM Evidence WHERE id = 2), (SELECT $node_id FROM Crime WHERE id = 2)),
((SELECT $node_id FROM Evidence WHERE id = 6), (SELECT $node_id FROM Crime WHERE id = 2)),
((SELECT $node_id FROM Evidence WHERE id = 9), (SELECT $node_id FROM Crime WHERE id = 2)),
-- Убийство (преступление 3)
((SELECT $node_id FROM Evidence WHERE id = 5), (SELECT $node_id FROM Crime WHERE id = 3)),
((SELECT $node_id FROM Evidence WHERE id = 4), (SELECT $node_id FROM Crime WHERE id = 3)),
((SELECT $node_id FROM Evidence WHERE id = 8), (SELECT $node_id FROM Crime WHERE id = 3)),
-- Ограбление банка (преступление 4)
((SELECT $node_id FROM Evidence WHERE id = 7), (SELECT $node_id FROM Crime WHERE id = 4)),
((SELECT $node_id FROM Evidence WHERE id = 3), (SELECT $node_id FROM Crime WHERE id = 4)),
((SELECT $node_id FROM Evidence WHERE id = 10), (SELECT $node_id FROM Crime WHERE id = 4)),
-- Похищение (преступление 5)
((SELECT $node_id FROM Evidence WHERE id = 9), (SELECT $node_id FROM Crime WHERE id = 5)),
((SELECT $node_id FROM Evidence WHERE id = 1), (SELECT $node_id FROM Crime WHERE id = 5)),
((SELECT $node_id FROM Evidence WHERE id = 2), (SELECT $node_id FROM Crime WHERE id = 5)),
-- Мошенничество (преступление 6)
((SELECT $node_id FROM Evidence WHERE id = 6), (SELECT $node_id FROM Crime WHERE id = 6)),
((SELECT $node_id FROM Evidence WHERE id = 3), (SELECT $node_id FROM Crime WHERE id = 6)),
-- Кража со взломом (преступление 7)
((SELECT $node_id FROM Evidence WHERE id = 1), (SELECT $node_id FROM Crime WHERE id = 7)),
((SELECT $node_id FROM Evidence WHERE id = 2), (SELECT $node_id FROM Crime WHERE id = 7)),
-- Поджог (преступление 8)
((SELECT $node_id FROM Evidence WHERE id = 10), (SELECT $node_id FROM Crime WHERE id = 8)),
((SELECT $node_id FROM Evidence WHERE id = 5), (SELECT $node_id FROM Crime WHERE id = 8)),
-- Нападение (преступление 9)
((SELECT $node_id FROM Evidence WHERE id = 8), (SELECT $node_id FROM Crime WHERE id = 9)),
((SELECT $node_id FROM Evidence WHERE id = 4), (SELECT $node_id FROM Crime WHERE id = 9)),
-- Киберпреступление (преступление 10)
((SELECT $node_id FROM Evidence WHERE id = 6), (SELECT $node_id FROM Crime WHERE id = 10)),
((SELECT $node_id FROM Evidence WHERE id = 9), (SELECT $node_id FROM Crime WHERE id = 10));


INSERT INTO Investigates ($from_id, $to_id, role) VALUES
-- Угон автомобиля (преступление 1)
((SELECT $node_id FROM Officer WHERE id = 1), (SELECT $node_id FROM Crime WHERE id = 1), N'Следователь'),
((SELECT $node_id FROM Officer WHERE id = 6), (SELECT $node_id FROM Crime WHERE id = 1), N'Помощник'),
-- Трафик наркотиков (преступление 2)
((SELECT $node_id FROM Officer WHERE id = 4), (SELECT $node_id FROM Crime WHERE id = 2), N'Руководитель'),
((SELECT $node_id FROM Officer WHERE id = 3), (SELECT $node_id FROM Crime WHERE id = 2), N'Оперативник'),
((SELECT $node_id FROM Officer WHERE id = 8), (SELECT $node_id FROM Crime WHERE id = 2), N'Агент'),
-- Убийство (преступление 3)
((SELECT $node_id FROM Officer WHERE id = 2), (SELECT $node_id FROM Crime WHERE id = 3), N'Криминалист'),
((SELECT $node_id FROM Officer WHERE id = 1), (SELECT $node_id FROM Crime WHERE id = 3), N'Детектив'),
((SELECT $node_id FROM Officer WHERE id = 5), (SELECT $node_id FROM Crime WHERE id = 3), N'Координатор'),
-- Ограбление банка (преступление 4)
((SELECT $node_id FROM Officer WHERE id = 5), (SELECT $node_id FROM Crime WHERE id = 4), N'Координатор'),
((SELECT $node_id FROM Officer WHERE id = 6), (SELECT $node_id FROM Crime WHERE id = 4), N'Техник'),
((SELECT $node_id FROM Officer WHERE id = 10), (SELECT $node_id FROM Crime WHERE id = 4), N'Эксперт'),
-- Похищение (преступление 5)
((SELECT $node_id FROM Officer WHERE id = 2), (SELECT $node_id FROM Crime WHERE id = 5), N'Следователь'),
((SELECT $node_id FROM Officer WHERE id = 5), (SELECT $node_id FROM Crime WHERE id = 5), N'Начальник'),
-- Мошенничество (преступление 6)
((SELECT $node_id FROM Officer WHERE id = 7), (SELECT $node_id FROM Crime WHERE id = 6), N'Финансовый аналитик'),
((SELECT $node_id FROM Officer WHERE id = 9), (SELECT $node_id FROM Crime WHERE id = 6), N'Киберспециалист'),
-- Кража со взломом (преступление 7)
((SELECT $node_id FROM Officer WHERE id = 6), (SELECT $node_id FROM Crime WHERE id = 7), N'Детектив'),
((SELECT $node_id FROM Officer WHERE id = 3), (SELECT $node_id FROM Crime WHERE id = 7), N'Криминалист'),
-- Поджог (преступление 8)
((SELECT $node_id FROM Officer WHERE id = 8), (SELECT $node_id FROM Crime WHERE id = 8), N'Пожарный эксперт'),
((SELECT $node_id FROM Officer WHERE id = 4), (SELECT $node_id FROM Crime WHERE id = 8), N'Следователь'),
-- Нападение (преступление 9)
((SELECT $node_id FROM Officer WHERE id = 10), (SELECT $node_id FROM Crime WHERE id = 9), N'Участковый'),
((SELECT $node_id FROM Officer WHERE id = 1), (SELECT $node_id FROM Crime WHERE id = 9), N'Дознаватель'),
-- Киберпреступление (преступление 10)
((SELECT $node_id FROM Officer WHERE id = 9), (SELECT $node_id FROM Crime WHERE id = 10), N'IT-эксперт'),
((SELECT $node_id FROM Officer WHERE id = 2), (SELECT $node_id FROM Crime WHERE id = 10), N'Финансовый следователь');


INSERT INTO WorkedTogether ($from_id, $to_id, collaboration_date, cases_count) VALUES
((SELECT $node_id FROM Officer WHERE id = 1), (SELECT $node_id FROM Officer WHERE id = 6), '2023-01-15', 2),
((SELECT $node_id FROM Officer WHERE id = 2), (SELECT $node_id FROM Officer WHERE id = 1), '2022-12-05', 1),
((SELECT $node_id FROM Officer WHERE id = 1), (SELECT $node_id FROM Officer WHERE id = 2), '2022-12-05', 1),
((SELECT $node_id FROM Officer WHERE id = 4), (SELECT $node_id FROM Officer WHERE id = 3), '2023-03-15', 1),
((SELECT $node_id FROM Officer WHERE id = 4), (SELECT $node_id FROM Officer WHERE id = 8), '2023-03-15', 1),
((SELECT $node_id FROM Officer WHERE id = 3), (SELECT $node_id FROM Officer WHERE id = 8), '2023-03-15', 1),
((SELECT $node_id FROM Officer WHERE id = 5), (SELECT $node_id FROM Officer WHERE id = 2), '2023-05-15', 2),
((SELECT $node_id FROM Officer WHERE id = 1), (SELECT $node_id FROM Officer WHERE id = 5), '2023-05-15', 2),
((SELECT $node_id FROM Officer WHERE id = 10), (SELECT $node_id FROM Officer WHERE id = 5), '2023-05-15', 1),
((SELECT $node_id FROM Officer WHERE id = 6), (SELECT $node_id FROM Officer WHERE id = 10), '2023-05-12', 1),
((SELECT $node_id FROM Officer WHERE id = 7), (SELECT $node_id FROM Officer WHERE id = 9), '2023-02-25', 1),
((SELECT $node_id FROM Officer WHERE id = 8), (SELECT $node_id FROM Officer WHERE id = 4), '2023-04-20', 1),
((SELECT $node_id FROM Officer WHERE id = 10), (SELECT $node_id FROM Officer WHERE id = 1), '2022-10-10', 1),
((SELECT $node_id FROM Officer WHERE id = 9), (SELECT $node_id FROM Officer WHERE id = 2), '2023-04-01', 1);



--Найти всех подозреваемых, связанных с конкретным преступлением (убийством) и улики по этому делу:
SELECT s.name AS Подозреваемый, i.role AS Роль, e.type AS Улика, e.description AS Описание
FROM Suspect AS s, InvolvedIn AS i, Crime AS c, EvidenceInCrime AS eic, Evidence AS e
WHERE MATCH(s-(i)->c<-(eic)-e)
AND c.type = N'Убийство';

--Найти все места преступлений, где был замечен конкретный подозреваемый (Даг Джуди):
SELECT l.name AS Место, s.seen_date AS Дата, s.method AS Метод_обнаружения
FROM Suspect AS su, SeenAt AS s, Location AS l
WHERE MATCH(su-(s)->l)
AND su.name = N'Даг Джуди'
ORDER BY s.seen_date;

--Найти всех офицеров, расследующих преступления, связанные с конкретным подозреваемым (Стервятник):
SELECT o.name AS Офицер, o.rank AS Звание, inv.role AS Роль_в_расследовании
FROM Officer AS o, Investigates AS inv, Crime AS c, InvolvedIn AS i, Suspect AS s
WHERE MATCH(o-(inv)->c<-(i)-s)
AND s.name = N'Стервятник';

--Найти все преступления, которые расследует конкретный офицер (Джейк Перальта):
SELECT c.type AS Преступление, inv.role AS Роль_в_расследовании
FROM Officer AS o, Investigates AS inv, Crime AS c
WHERE MATCH(o-(inv)->c)
AND o.name = N'Джейк Перальта';

--Найти все места, где был замечен подозреваемый (Стервятник), и метод обнаружения:
SELECT l.name AS Место, s.seen_date AS Дата, s.method AS Метод_обнаружения
FROM Suspect AS su, SeenAt AS s, Location AS l
WHERE MATCH(su-(s)->l)
AND su.name = N'Стервятник';

--запрос, который показывает всю цепочку:Подозреваемый → Улика → Преступление ← Офицер
SELECT s.name AS Подозреваемый, 
       e.type AS Улика, 
       c.type AS Преступление, 
       o.name AS Офицер, 
       o.rank AS Звание
FROM Suspect AS s, 
     LinkedTo AS lt, 
     Evidence AS e, 
     EvidenceInCrime AS eic, 
     Crime AS c, 
     Investigates AS inv, 
     Officer AS o
WHERE MATCH(s-(lt)->e-(eic)->c<-(inv)-o);

	-- Найти всех коллег Джейка Перальта через совместные дела (1-3 уровня)
SELECT 
    o1.name AS Офицер,
    STRING_AGG(o2.name, ' -> ') WITHIN GROUP (GRAPH PATH) AS Путь_сотрудничества,
    COUNT(o2.name) WITHIN GROUP (GRAPH PATH) AS Уровней_глубины
FROM 
    Officer AS o1,
    WorkedTogether FOR PATH AS wt,
    Officer FOR PATH AS o2
WHERE 
    MATCH(SHORTEST_PATH(o1(-(wt)->o2){1,3}))
    AND o1.name = N'Джейк Перальта'
ORDER BY 
    Уровней_глубины, Путь_сотрудничества;

	-- Найти кратчайший путь сотрудничества между Джина Линетти и Скалли
DECLARE @OfficerFrom AS NVARCHAR(50) = N'Джина Линетти';
DECLARE @OfficerTo AS NVARCHAR(50) = N'Скалли';

WITH OfficerPaths AS (
    SELECT 
        o1.name AS Начальный_офицер,
        STRING_AGG(o2.name, ' -> ') WITHIN GROUP (GRAPH PATH) AS Путь,
        LAST_VALUE(o2.name) WITHIN GROUP (GRAPH PATH) AS Конечный_офицер
    FROM 
        Officer AS o1,
        WorkedTogether FOR PATH AS wt,
        Officer FOR PATH AS o2
    WHERE 
        MATCH(SHORTEST_PATH(o1(-(wt)->o2)+))
        AND o1.name = @OfficerFrom
)
SELECT 
    Начальный_офицер, 
    Путь
FROM 
    OfficerPaths
WHERE 
    Конечный_офицер = @OfficerTo;