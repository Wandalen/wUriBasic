const _ = require( 'wTools' );
require( 'wuribasic' );

let path = '/foo/bar//baz/asdf/quux/./';
console.log( _.uri.canonize( path ) ); 
// /foo/bar//baz/asdf/quux

path = '/C:\\temp\\\\foo\\bar\\..\\';
console.log( _.uri.canonize( path ) ); 
// /C:/temp//foo

path = 'foo/././bar/././baz/';
console.log( _.uri.canonize( path ) ); 
// foo/bar/baz
