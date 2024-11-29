/*
Задание 3
+-----------+--------+-----+---------+-----------+----------+
|Employee_ID|Job_Code| Name|City_Code|        Job| Home_City|
+-----------+--------+-----+---------+-----------+----------+
|       E001|     J01|Alice|       26|       Chef|    Moscow|
|       E001|     J02|Alice|       26|     Waiter|    Moscow|
|       E002|     J02|  Bob|       56|     Waiter|      Perm|
|       E002|     J03|  Bob|       56|  Bartender|      Perm|
|       E003|     J01|Alice|       56|       Chef|      Perm|
+-----------+--------+-----+---------+-----------+----------+
Определите в какой нормальной форме данная таблица, приведите её ко 2 и 3 нормальным формам последовательно.
*/


CREATE SCHEMA homework1;

USE homework1;

-- Исходная таблица
CREATE TABLE Task1 (
    Employee_ID VARCHAR(10),
    Name VARCHAR(50),
    Job_Code VARCHAR(10),
    Job VARCHAR(50),
    City_Code INT,
    Home_City VARCHAR(50)
);

INSERT INTO Task1 VALUES
('E001', 'Alice', 'J01', 'Chef', 26, 'Moscow'),
('E001', 'Alice', 'J02', 'Waiter', 26, 'Moscow'),
('E002', 'Bob', 'J02', 'Waiter', 56, 'Perm'),
('E002', 'Bob', 'J03', 'Bartender', 56, 'Perm'),
('E003', 'Alice', 'J01', 'Chef', 56, 'Perm');

/*
-- Определение текущей нормальной формы

-- В таблице есть повторяющиеся значения (Name, Job, City_code, Home_city) для одного и того же Employee_ID.
-- Поля Job_Code и Job зависят от Employee_ID, но не всегда функционально полно определены.
-- Поле Home_city дублируется для City_code.

-- Таблица находится в первой нормальной форме (1NF), так как данные организованы в табличном виде, 
-- каждая ячейка содержит одно значение. Однако есть частичные зависимости и избыточность.
*/

-- Разбиваем исходную таблицу на 3
CREATE TABLE Employees (
    Employee_ID VARCHAR(10) PRIMARY KEY,
    Name VARCHAR(50),
    City_Code INT
);

INSERT INTO Employees (Employee_ID, Name, City_Code)
SELECT DISTINCT Employee_ID, Name, City_Code
FROM Task1;


CREATE TABLE Jobs (
    Job_Code VARCHAR(10) PRIMARY KEY,
    Job VARCHAR(50)
);

INSERT INTO Jobs (Job_Code, Job)
SELECT DISTINCT Job_Code, Job
FROM Task1;

CREATE TABLE Cities (
    City_Code INT PRIMARY KEY,
    Home_City VARCHAR(50)
);

INSERT INTO Cities (City_Code, Home_City)
SELECT DISTINCT City_Code, Home_City
FROM Task1;

-- Создаем составной ключ
CREATE TABLE Employee_Jobs (
    Employee_ID VARCHAR(10),
    Job_Code VARCHAR(10),
    PRIMARY KEY (Employee_ID, Job_Code),
    FOREIGN KEY (Employee_ID) REFERENCES Employees(Employee_ID),
    FOREIGN KEY (Job_Code) REFERENCES Jobs(Job_Code)
);

INSERT INTO Employee_Jobs (Employee_ID, Job_Code)
SELECT DISTINCT Employee_ID, Job_Code
FROM Task1;

/*
Таблицы приведены к 3 нормальной форме. Это позволяет избежать избыточности и поддерживать целостность данных.
*/

-- Проверка
SELECT 
    e.Employee_ID,
    e.Name,
    j.Job_Code,
    j.Job,
    c.City_Code,
    c.Home_City
FROM Employee_Jobs ej
JOIN Employees e ON ej.Employee_ID = e.Employee_ID
JOIN Jobs j ON ej.Job_Code = j.Job_Code
JOIN Cities c ON e.City_Code = c.City_Code;

