const _ = require( 'wTools' );
require( 'wuribasic' );

let path = '://some/staging/index.html/.';
console.log( _.uri.normalize( path ) ); 
// ://some/staging/index.html

path = ':///some/staging/./index.html/./';
console.log( _.uri.normalize( path ) ); 
// :///some/staging/index.html/

path = '/foo/bar//baz1/baz2//some/..';
console.log( _.uri.normalize( path ) ); 
// /foo/bar//baz1/baz2/

path = 'https://web.archive.org/web/*\/http://www.heritage.org/.././index/ranking/./.';
console.log( _.uri.normalize( path ) ); 
// https://web.archive.org/web/*\/http://index/ranking

path = 'C:\\Projects\\apilibrary\\index.html\\..\\';
console.log( _.uri.normalize( path ) ); 
// /C/Projects/apilibrary/
