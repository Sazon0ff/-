IF(логическое_выражение, выражение_1 (если да), выражение_2 (если нет)) - улосвие через IF

Пример: 
/*SELECT title, amount, price, 
    IF(amount<4, price*0.5, price*0.7) AS sale
FROM book;

SELECT title, amount, price,
    ROUND(IF(amount < 4, price * 0.5, IF(amount < 11, price * 0.7, price * 0.9)), 2) AS sale,
    IF(amount < 4, 'скидка 50%', IF(amount < 11, 'скидка 30%', 'скидка 10%')) AS Ваша_скидка
FROM book;
*/
________________________________________________________________________________________________________


Оператор LIKE - Оператор LIKE используется для сравнения строк. 
В отличие от операторов отношения равно (=) и не равно (<>), LIKE позволяет 
сравнивать строки не на полное совпадение (не совпадение), а в соответствии 
с шаблоном. Шаблон может включать обычные символы и символы-шаблоны. При 
сравнении с шаблоном, его обычные символы должны в точности совпадать с 
символами, указанными в строке. Символы-шаблоны могут совпадать с 
произвольными элементами символьной строки.

% - любая строка, содержащая 0 или более символов
_ - любой одиночный символ

Пример
/*
Вывести названия книг, которые содержат букву "и" как отдельное
слово, если считать, что слова в названии отделяются друг от друга пробелами и не содержат знаков препинания.

SELECT title FROM book 
WHERE   title LIKE "_% и _%" /*отбирает слово И внутри названия */
    OR title LIKE "и _%" /*отбирает слово И в начале названия */
    OR title LIKE "_% и" /*отбирает слово И в конце названия */
    OR title LIKE "и" /* отбирает название, состоящее из одного слова И */
_________________________________________________________________________________________________________


При использовании оператора ANY в результирующую таблицу будут включены все записи, для которых  выражение 
со знаком отношения верно хотя бы для одного элемента результирующего запроса. Как работает оператор ANY:

/*amount > ANY (10, 12) эквивалентно amount > 10

amount < ANY (10, 12) эквивалентно amount < 12

amount = ANY (10, 12) эквивалентно (amount = 10) OR (amount = 12), а также amount IN  (10,12)

amount <> ANY (10, 12) вернет все записи с любым значением amount, включая 10 и 12*/

При использовании оператора ALL в результирующую таблицу будут включены все записи, для которых  выражение со 
знаком отношения верно для всех элементов результирующего запроса. Как работает оператор ALL:

/*amount > ALL (10, 12) эквивалентно amount > 12

amount < ALL (10, 12) эквивалентно amount < 10

amount = ALL (10, 12) не вернет ни одной записи, так как эквивалентно (amount = 10) AND (amount = 12)
amount <> ALL (10, 12) вернет все записи кроме тех,  в которыхamount равно 10 или 12*/

Важно! Операторы ALL и ANY можно использовать только с вложенными запросами. В примерах выше (10, 12) приводится как результат 
вложенного запроса просто для того, чтобы показать как эти операторы работают. В запросах так записывать нельзя.

Пример:
Вывести информацию о тех книгах, количество которых меньше самого маленького среднего количества книг каждого автора.

/*SELECT title, author, amount, price
FROM book
WHERE amount < ALL (
        SELECT AVG(amount) 
        FROM book 
        GROUP BY author);*/

Вывести информацию о тех книгах, количество которых меньше самого большого среднего количества книг каждого автора.

/*SELECT title, author, amount, price
FROM book
WHERE amount < ANY (
        SELECT AVG(amount) 
        FROM book 
        GROUP BY author);*/
____________________________________________________________________________________________________________


Вложенный запрос после SELCT


/*Посчитать сколько и каких экземпляров книг нужно заказать поставщикам, чтобы на складе стало одинаковое 
количество экземпляров каждой книги, равное значению самого большего количества экземпляров одной книги 
на складе. Вывести название книги, ее автора, текущее количество экземпляров на складе и количество заказываемых 
экземпляров книг. Последнему столбцу присвоить имя Заказ. В результат не включать книги, которые заказывать не нужно.*/

select
title,
author,
amount,
(select
max(amount)
from book) - amount as 'Заказ'
from book
where amount < (select
max(amount)
from book)
______________________________________________________________________________________________________________


