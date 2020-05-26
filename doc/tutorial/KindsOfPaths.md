# Види шляхів
Шлях - набір символів, що показує розташування файлу або каталогу в файлової системі.
Символом розмежування найчастіше є коса риска ("/"), зворотна коса риска ("\\") або двокрапка (":"), 
хоча деякі операційні системи можуть використовувати інші знаки розмежування.

### Шляхи бувають:
- глобальними або локальними
- абсолютними або відносними

#### Глобальний та локальний шлях
Глобальний шлях це шлях до файлу, який містить у собі протокол - ім'я сайту в мережі, підкаталог(або кілька підкаталогів), 
назва файлу. Тобто необхідний файл знаходиться на віддаленому ресурсі.

Локальний шлях це шлях до файлу, що знаходиться на локальному комп'ютері, звідки виконується запит. У такому шляху 
протокол не вказується.

#### Абсолютний та відносний шлях
Абсолютний шлях - це шлях, який вказує на одне і те ж місце в файлової системі, незалежно від поточного робочого каталогу 
або інших обставин. Абсолютний шлях завжди починається з кореневого каталогу. 
В операційних системах UNIX це "/", у Windows -"C:\\".

Відносний шлях являє собою шлях відносно поточного робочого каталогу користувача або активних додатків. Відносний шлях
ніколи не починається із кореневого каталогу.

Приклад шляхів, що вказують на файл /home/john/documents/myFile.txt

#### Глобальний:
- абсолютний -> file:///home/john/documents/myFile.txt
- відносний -> file://documents/myFile.txt

#### Локальний:
- абсолютний -> /home/john/documents/myFile.txt
- відносний -> documents/myFile.txt

<!--  -->

### Обробка шляху перед використанням

Часто виникає потреба піддати шлях певній обробці, перед тим, як ним скористатись.\
Далі розглядається використання наступних рутин обробки шляху - `normalize`, `nativize` та `canonize`.

#### Нормалізація шляху

Це процес, при якому шлях приводиться до однакового виду. Мета процесу нормалізації полягає в перетворенні шляху 
в нормалізований вигляд, з тим, щоб визначити еквівалентність двох синтаксично різних шляхів.

Рутина `normalize` нормалізує шлях, шляхом видалення надлишкових роздільників, вирішенням '..' та '.' сегментів так,
що A//B, A/./B та A/foo/../B - всі приводяться до A/B.
Така маніпуляція рядком може змінити значення шляху, що містить символічні посилання.
На Windows вона заміняє прямий слеш на обернений. Якщо шлях є порожнім рядком, рутина повертає '.',
що являє собою поточний робочий каталог.

```js
const _ = require( 'wTools' );
require( 'wuribasic' );

let path = '://some/staging/index.html/.';
console.log( _.uri.normalize( path ) ); 
// ://some/staging/index.html

path = '/foo/bar//baz1/baz2//some/..';
console.log( _.uri.normalize( path ) ); 
// /foo/bar/baz1/baz2

path = ':///some/staging/./index.html/./';
console.log( _.uri.normalize( path ) ); 
// :///some/staging/index.html/

path = 'C:\\Projects\\apilibrary\\index.html\\..\\';
console.log( _.uri.normalize( path ) ); 
// /C/Projects/apilibrary/

path = 'https://web.archive.org/web/*\/http://www.heritage.org/.././index/ranking/./.';
console.log( _.uri.normalize( path ) ); 
// https://web.archive.org/web/*\/http://index/ranking
```

#### Нативізація шляху

Мета процесу нативізації полягає в приведенні шляху в нативізований вигляд, з тим, щоб 
визначити еквівалентний шлях в ОС Windows та в POSIX.

Рутина `nativize` виконає нативізацію шляхів, як показано нижче.

```js
const _ = require( 'wTools' );
require( 'wuribasic' );

// process.platform === 'win32'
let path = '/A';
console.log( _.uri.nativize( path ) ); 
// A:\

path = '/C/Documents/Newsletters/Summer2018.pdf';
console.log( _.uri.nativize( path ) ); 
// C:\Documents\Newsletters\Summer2018.pdf

path = '/Documents/Newsletters/Summer2018.pdf';
console.log( _.uri.nativize( path ) ); 
// \Documents\Newsletters\Summer2018.pdf

// process.platform !== 'win32'
path = '/bin';
console.log( _.uri.nativize( path ) ); 
// /bin

path = '/home/mthomas/class_stuff/foo';
console.log( _.uri.nativize( path ) ); 
// /home/mthomas/class_stuff/foo
```

#### Канонізація шляху

