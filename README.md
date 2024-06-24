# Домашнее задание по курсу System Design ([balun.courses](https://balun.courses/courses/system_design))

## System Design проекта "Социальная сеть для путешественников".

### Содержание

1. [Требования](#требования)
   1. [Функциональные](#функциональные)
   2. [Нефункциональные](#нефункциональные)
2. [Расчет нагрузки](#расчет-нагрузки)
3. [Расчет количества дисков для хранения данных на 1 год](#расчет-количества-дисков-для-хранения-данных-на-1-год)

### Требования

#### Функциональные

* Аккаунт/профиль путешественника
  * Регистрация
  * Аутентификация (по уникальному логину / по почте / по номеру телефона / OAuth 2.0)
  * Авторизация
    * Например, могу редактировать только свои посты
  * Заполнение информации о себе
    * Ник  
    * Имя (отображаемое, полное)
    * Какое-то описание (н-р, любимые места для путешествия, способы передвижения и т.д.)
    * Аватарка
    * Местонахождение (страна, город)
* Публикация поста
  * Содержимое поста
    * Заголовок
    * Обложка (фото для превью)
    * Описание (для превью)
    * Контент
    * Фотографии
    * Страна
    * Город
* Действия пользователей над опубликованными постами
  * Просмотр
    * Счетчик просмотров постов
  * Оценки
    * лайк/дизлайк
  * Комментарии
    * Содержимое комментария - только текст
    * Упорядочены по дате написания коммента (от старых к новым)
    * Структура комментариев - плоская
    * Если пользователь отвечает на чей-то комментарий, то будет приходить уведомление тому, на чей комментарий был ответ
* Подписка на путешественника
  * Уведомление при публикации поста подписчикам
  * Просмотр тех, на кого ты подписан
    * Сортировка - по имени
  * Просмотр тех, кто подписаны на тебя
    * Сортировка - по имени
* Лента постов
  * Отображает пост в виде превью (с возможностью перейти к просмотру поста целиком)
  * Сжатие фотографий (или обложки поста в виде фотки) для превью
  * Упорядочена по дате публикации поста (от новых к старым)
  * Отображает оценки каждого поста
* Поиск популярных мест
  * Популярность определяется по количеству постов об этом месте
  * Определяются ТОП по странам и ТОП по городам
  * В рамках каждой позиции ТОПа можно просмотреть самые популярные посты
* Общение в ЛС
  * Поиск/выбор собеседника
    * Поиск по нику
    * Выбор среди подписчиков / среди тех, на кого ты подписан
  * Просмотр собеседников (сначала те, с кем общался недавно)
  * Просмотр истории сообщений с собеседником
  * Отправить сообщение (текст)
    * Приложить фото к сообщению
  * Просмотр всех приложенных фото в рамках переписки с конкретным собеседником
  * Уведомление о новом сообщении
  * Поиск по истории сообщений (по текстам сообщений)

#### Нефункциональные
* Общее
  * 10 000 000 DAU, но будет расти, так что имеет смысл целиться сразу на 15 000 000 DAU
  * Регионы использования: Только СНГ
  * Доступность: 99.99%
  * Сезонность:
    * Больше пользователей просматривают посты в поисках места прямо перед сезонами путешествий (лето, новогодние праздники, длинные выходные)
* Аккаунт/профиль путешественника
  * Предположения:
    * Новых пользователей в день: 15 000 000 (DAU) / 365 = ~40 000 
    * Информация/поля в аккаунте с предполагаемым весом:
      * Ник (30b)
      * Имя (50b)
      * Пароль (100b)
      * Описание (200b)
      * Аватарка (1Mb)
      * Местонахождение (страна, город) (16b)
      * Итого: В среднем = ~1Mb
    * Пользователь в среднем просматривает 5 аккаунтов/профилей в день
* Публикация поста
  * Содержимое поста
    * Заголовок (100b)
    * Обложка: Максимум = 500Kb. В среднем = 200Kb
    * Описание: Максимум = 200b; В среднем = 100b
    * Контент: Максимум = 500Kb; В среднем = 50Kb
    * Фотографии
      * Максимальное кол-во = 20. В среднем = 5
      * Максимальный размер фото = 2Mb. В среднем = 1Mb
      * Итого: Максимум = 40Mb; В среднем = 5Mb
    * Страна (8b)
    * Город (8b)
    * Итого, в среднем: 
      * Только картинки = ~5.2Mb
      * Данные без картинок = ~51Kb
  * Пользователь в среднем пишет 3 поста в месяц
* Действия пользователей над опубликованными постами
  * Пользователь в среднем просматривает/прочитывает 15 полных постов в день
  * Пользователь в среднем оценивает 10 постов в день
    * Вес "оценки": user_id(8b) + post_id(8b) + like(true/false=1b); с запасом ~30b 
  * Пользователь в среднем оставляет 5 комментов в день
    * Вес комментария: Максимум = 500b, в среднем = 200b
* Подписка на путешественника
  * Не более 1 000 000 подписчиков
  * В среднем новых подписок в день: 15 000 000 (DAU) * 0.1 = 1 500 000
  * Вес информации о подписке = ~50b
  * Пользователь в среднем просматривает подписки (на кого подписан и кто подписан на него) 5 раз в день 
* Лента постов
  * Пользователь в среднем просматривает ленту у 10 путешественников
  * Пусть один "подгружаемый кусок" ленты имеет 10 постов
  * Пусть один "подгружаемый кусок" весит в среднем:
    * Только картинки = ~200Kb (показываем превью постов, а не целиком) * 10 = ~2Mb
    * Данные без картинок = ~250b * 10 = ~2.5Kb
  * Пользователь в среднем просматривает у каждого из 10 путешественников по 2 "подгружаемых куска"
* Поиск популярных мест
  * Пользователь в среднем просматривает ТОП 1 раз в день
* Общение в ЛС
  * Размер сообщения:
    * Фото: Максимум = 2Mb. В среднем = 1Mb
    * Текст: Максимум = 100Kb. В среднем = 100b
    * Итого: Максимум = 2.1Mb. В среднем = ~1Mb
  * Пользователь в среднем пишет 20 сообщений в день, из них 5 с фото
  * Пользователь в среднем просматривает диалоги 20 раз в день
  * Пользователь в среднем ищет (поиском по текстам сообщений) по истории сообщений 3 раза в день

### Расчет нагрузки
Аккаунт/профиль путешественника:
```
RPS по регистрации новых аккаунтов = 40 000 / 86 400 = 0.5 => ~1
Трафик по регистрации новых аккаунтов = 1 * 1Mb = 1Mb/sec

RPS по просмотру аккаунтов = (15 000 000 * 5) / 86 400 = 868
Трафик по просмотру аккаунтов = 868 * 1Mb = 868Mb/sec 
```
Пост:
```
RPS опубликовать новый пост = (15 000 000 * 3 / 30) / 86 400  = ~18
Трафик по публикации новых постов:
* Только картинки = 18 * 5.2Mb = ~94Mb/sec
* Данные без картинок = 18 * 51Kb = ~1Mb/sec

RPS по просмотру постов = (15 000 000 * 15) / 86 400 = ~2 600
Трафик по просмотру постов:
* Только картинки = 2 600 * 5.2Mb = ~13.5Gb/sec
* Данные без картинок = 2 600 * 51Kb = ~130Mb/sec
```
Действия пользователей над опубликованными постами:
```
RPS оценить пост (лайк/дизлайк) = (15 000 000 * 10) / 86 400 = 1 740
Трафик по оценкам постов = 1 740 * 30b = ~50Kb/sec
RPS просмотреть оценку поста ~= RPS по просмотру постов = 2 600
Трафик по просмотру оценки поста = 2 600 * 30b = ~78Kb/sec

RPS по новым комментариям = (15 000 000 * 5) / 86 400 = ~860
Трафик по новым комментариям = 860 * 200b = ~170Kb/sec
RPS просмотреть комментарии ~= RPS по просмотру постов * 3 (множитель, учитывающий подгрузку списка батчами) = ~7 800
Трафик по просмотру комментариев = 7 800 * 200b * 15 (множитель, учитывающий размер батча) = ~22Mb/sec
```
Подписка на путешественника:
```
RPS подписаться на путешественника = 1 500 000 / 86 400 = ~18
Трафик по подпискам = 18 * 50b = ~1Kb/sec
RPS по просмотру подписок = ( (15 000 000 * 5) / 86 400 ) * 3 (множитель, учитывающий подгрузку списка батчами) = ~2 600
Трафик по просмотру подписок = 2600 * 50b * 15 (множитель, учитывающий размер батча) = 2Mb/sec 
```
Лента постов:
```
RPS просмотреть ленту = (15 000 000 * 10 * 2) / 86 400 = ~3 500
Трафик по просмотру лент: 
* Только картинки = 3 500 * 2Mb = ~7Gb/sec
* Данные без картинок = 3 500 * 2.5Kb = ~8.5Mb/sec
```
Общение в ЛС:
```
RPS по отправке сообщений = (15 000 000 * 20) / 86 400 = ~3 500
Трафик по отправке сообщений = (3 500 * (5/20) * 1Mb) + (3 500 * 100b) = 870Mb + 0.35Mb = ~870Mb/sec
RPS по просмотру сообщений = ((15 000 000 * 20) / 86 400) * 3 (множитель, учитывающий подгрузку списка батчами) = ~10 500
Трафик по просмотру сообщений = (10 500 * (5/20) * 1Mb) * 3 (фото в батче в среднем) + (10 500 * 100b)) * 10 (размер батча) = 7.9Gb + 10Mb = ~8Gb/sec
```
### Расчет количества дисков для хранения данных на 1 год
Аккаунт/профиль путешественника:
```
Прирост данных в год по аккаунтам: 1Mb/sec * 86 400 * 365 = ~30Tb/year
IOPS = 1 (write) + 868 (read) = 869
Трафик = 1Mb/sec (write) + 868Mb/sec (read) = 869Mb/sec

Для HDD:
Disks_for_capacity = 30Tb / 32Tb = ~1
Disks_for_throughput =  869Mb/sec / 100Mb/sec = ~9
Disks_for_iops = 869 / 100 = ~9
Disks = 9

Для SSD (SATA):
Disks_for_capacity = 30Tb / 100Tb = ~1
Disks_for_throughput = 869Mb/sec / 500Mb/sec = ~2
Disks_for_iops = 869 / 1 000 = ~1
Disks = 2

Выбирается 2 SSD (SATA) диска.
```
Посты (+ лента):
```
Прирост данных в год по постам: 
* Только картинки = 94Mb/sec * 86 400 * 365 = ~2 830Tb/year
* Данные без картинок = 1Mb/sec * 86 400 * 365 = ~30Tb/year
IOPS = 18 (write) + 2 600 (read, просмотр постов) + 3 500 (read, просмотр ленты) = 6 100
Трафик:
* Только картинки = 94Mb/sec (write) + 13.5Gb/sec (read, просмотр постов) + 7Gb/sec (read, просмотр ленты) = ~20.6Gb/sec
* Данные без картинок: 1Mb/sec (write) + 130Mb/sec (read, просмотр постов) + 8.5Mb/sec (read, просмотр ленты) = ~140Mb/sec

- Только картинки:
Для SSD (SATA):
Disks_for_capacity = 2 830Tb / 100Tb = 29
Disks_for_throughput = 20.6Gb/sec / 500Mb/sec = 42
Disks_for_iops = 6 100 / 1 000 = 7
Disks = 42

Кажется, что HDD и SSD (nVME) рассматривать нет смысла, так как тут основной рост кол-ва дисков из-за capacity.

- Данные без картинок
Для SSD (SATA):
Disks_for_capacity = 30Tb / 100Tb = 1
Disks_for_throughput = 140Mb/sec / 500Mb/sec = 1
Disks_for_iops = 6 100 / 1 000 = 7
Disks = 7

Можно было бы и SSD (nVME) рассмотреть, но тогда их придётся взять 2 из-за capacity впритык.
```
Действия пользователей над опубликованными постами:
```
Прирост данных в год по оценкам постов = 50Kb/sec * 86 400 * 365 = 1.5Tb/year
IOPS = 1 740 (write) + 2 600 (read) = 4 340
Трафик = 50Kb/sec (write) + 78Kb/sec (read) = ~130Kb/sec

Для SSD (nVME):
Disks_for_capacity = 1.5Tb / 30Tb = 1
Disks_for_throughput = 130Kb/sec / 3Gb/sec = 1
Disks_for_iops = 4 340 / 10 000 = 1
Disks = 1

Кажется, что HDD и SSD (SATA) рассматривать нет смысла, так как тут основной рост кол-ва дисков из-за IOPS.
----------------------------------------------------------------------
Прирост данных в год по комментариям = 170Kb/sec * 86 400 * 365 = 5Tb/year
IOPS = 860 (write) + 7 800 (read) = ~8700
Трафик = 170Kb/sec (write) + 22Mb/sec (read) = ~22.5Mb/sec

Для SSD (nVME):
Disks_for_capacity = 5Tb / 30Tb = 1
Disks_for_throughput = 22.5Mb/sec / 3Gb/sec = 1
Disks_for_iops = 8 700 / 10 000 = 1
Disks = 1

Кажется, что HDD и SSD (SATA) рассматривать нет смысла, так как тут основной рост кол-ва дисков из-за IOPS.
```
Подписка на путешественника:
```
Прирост данных в год по подпискам = 1Kb/sec * 86 400 * 365 = 30Gb/year
IOPS = 18 (write) + 2 600 (read) = ~2 600
Трафик = 1Kb/sec (write) + 2Mb/sec (read) = ~2Mb/sec

Для SSD (nVME):
Disks_for_capacity = 30Gb / 30Tb = 1
Disks_for_throughput = 2Mb/sec / 3Gb/sec = 1
Disks_for_iops = 2 600 / 10 000 = 1
Disks = 1

Кажется, что HDD и SSD (SATA) рассматривать нет смысла, так как тут основной рост кол-ва дисков из-за IOPS.
```
Общение в ЛС:
```
Прирост данных в год по сообщениям = 870Mb/sec * 86 400 * 365 = ~26 000 Tb/year
IOPS = 3 500 (write) + 10 500 (read) = ~14 000
Трафик = 870Mb/sec (write) + 8Gb/sec (read) = ~9Gb/sec

Для HDD (nVME):
Disks_for_capacity = 26 000Tb / 32Tb = 813
Disks_for_throughput = 9Gb/sec / 100Mb/sec = 90
Disks_for_iops = 14 000 / 100 = 140
Disks = 813

Для SSD (SATA):
Disks_for_capacity = 26 000Tb / 100Tb = 260
Disks_for_throughput = 9Gb/sec / 500Mb/sec = 18
Disks_for_iops = 14 000 / 1 000 = 14
Disks = 260

Для SSD (nVME):
Disks_for_capacity = 26 000Tb / 30Tb = 867
Disks_for_throughput = 9Gb/sec / 3Gb/sec = 3
Disks_for_iops = 14 000 / 10 000 = 2
Disks = 867

Выбирается 260 SSD (SATA) дисков.
```