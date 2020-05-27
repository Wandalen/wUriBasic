# Види шляхів
Шлях - набір символів, що показує розташування файлу або каталогу в файловій системі.

**Шляхи бувають:**

- *глобальними* або *локальними*
- *абсолютними* або *відносними*

### Глобальний та локальний шлях
Глобальний шлях - це шлях до файлу, який містить у собі протокол - ім'я сайту в мережі, підкаталог(або кілька підкаталогів), 
назва файлу. Тобто необхідний файл знаходиться на віддаленому ресурсі.

Локальний шлях - це шлях до файлу, що знаходиться на локальному комп'ютері, звідки виконується запит. У такому шляху 
протокол не вказується.

### Абсолютний та відносний шлях
Абсолютний шлях - це шлях, який вказує на одне і те ж місце в файлової системі, незалежно від поточного робочого каталогу 
або інших обставин. Абсолютний шлях завжди починається з кореневого каталогу. 
В операційних системах UNIX це "/", у Windows -"C:\\".

Відносний шлях - це шлях відносно поточного робочого каталогу користувача або активних додатків. Відносний шлях
ніколи не починається із кореневого каталогу.

### Приклади 

Необхідно вказати на файл - /home/john/documents/myFile.txt

- Глобальний шлях:
  - абсолютний -> file:///home/john/documents/myFile.txt
  - відносний -> file://documents/myFile.txt

- Локальний шлях:
  - абсолютний -> /home/john/documents/myFile.txt
  - відносний -> documents/myFile.txt

<!--  -->

### Нормалізація шляху

Це процес, при якому шлях приводиться до однакового виду. Мета процесу нормалізації полягає в перетворенні шляху 
в нормалізований вигляд, з тим, щоб визначити еквівалентність двох синтаксично різних шляхів.

Рутина `normalize` нормалізує шлях, шляхом видалення надлишкових роздільників, опрацюванням '..' та '.' сегментів так,
що A//B, A/./B та A/foo/../B - всі приводяться до A/B. Така маніпуляція рядком може змінити значення шляху, 
що містить символічні посилання.

Видалення "." у кінці шляху:
```js
let path = '://some/staging/index.html/.';
console.log( _.uri.normalize( path ) ); 
// ://some/staging/index.html
```
Опрацювання сегменту ".":
```js
let path = ':///some/staging/./index.html/./';
console.log( _.uri.normalize( path ) ); 
// :///some/staging/index.html/
```
Опрацювання сегменту "..":
```js
let path = '/foo/bar//baz1/baz2//some/..';
console.log( _.uri.normalize( path ) ); 
// /foo/bar/baz1/baz2
```
Опрацювання комбінації сегментів "." та "..":
```js
let path = 'https://web.archive.org/web/*\/http://www.heritage.org/.././index/ranking/./.';
console.log( _.uri.normalize( path ) ); 
// https://web.archive.org/web/*\/http://index/ranking
```
Заміна оберененого слешу на прямий:
```js
let path = 'C:\\Projects\\apilibrary\\index.html\\..\\';
console.log( _.uri.normalize( path ) ); 
// /C/Projects/apilibrary/
```

### Нативізація шляху

Мета процесу нативізації полягає в приведенні шляху в нативізований вигляд, з тим, щоб 
визначити еквівалентний шлях в ОС на якій виконується процес, до заданого.

Рутина `nativize` виконує нативізацію шляхів, як показано нижче.

Якщо нативізація виконується на Windows, то в результаті:

абсолютні шляхи починаються як це прийнято - C:\\dir\\...
```js
// process.platform === 'win32'
let path = '/A';
console.log( _.uri.nativize( path ) ); 
// A:\
```
```js
// process.platform === 'win32'
let path = '/C/Documents/Newsletters/Summer2018.pdf';
console.log( _.uri.nativize( path ) ); 
// C:\Documents\Newsletters\Summer2018.pdf
```
оберенний слеш замінено на прямий:
```js
// process.platform === 'win32'
let path = '/Documents/Newsletters/Summer2018.pdf';
console.log( _.uri.nativize( path ) ); 
// \Documents\Newsletters\Summer2018.pdf
```
Виконання нативізації на ОС відмінній від Windows не призводить до жодних змін шляху.
```js
// process.platform !== 'win32'
let path = '/bin';
console.log( _.uri.nativize( path ) ); 
// /bin
```

```js
// process.platform !== 'win32'
let path = '/home/mthomas/class_stuff/foo';
console.log( _.uri.nativize( path ) ); 
// /home/mthomas/class_stuff/foo
```

### Канонізація шляху

Це процес аналогічний до нормалізації, проте шлях у канонічний формі є більш строгим та простим.
Рутина `canonize` повертає шлях без "/" у кінці, якщо такий був до цього.

```js
let path = '/foo/bar//baz/asdf/quux/./';
console.log( _.uri.canonize( path ) ); 
// /foo/bar//baz/asdf/quux
```

```js
let path = '/C:\\temp\\\\foo\\bar\\..\\';
console.log( _.uri.canonize( path ) ); 
// /C:/temp//foo
```

```js
let path = 'foo/././bar/././baz/';
console.log( _.uri.canonize( path ) ); 
// foo/bar/baz
```
