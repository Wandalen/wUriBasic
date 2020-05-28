const _ = require( 'wTools' );
require( 'wuribasic' );

path = '/C:\\temp\\\\foo\\bar\\';
console.log( _.uri.canonize( path ) ); 
// /C:/temp//foo/bar

path = '/C:\\temp\\\\foo\\\\bar\\..\\';
console.log( _.uri.canonize( path ) ); 
// /C:/temp//foo

path = 'foo/././bar/././baz/';
console.log( _.uri.canonize( path ) ); 
// foo/bar/baz
