const _ = require( 'wTools' );
require( 'wuribasic' );

// process.platform === 'win32'
let path = '/A';
console.log( _.uri.nativize( path ) );
// A:\

// process.platform === 'win32'
path = '/C/Documents/Newsletters/Summer2018.pdf';
console.log( _.uri.nativize( path ) ); 
// C:\Documents\Newsletters\Summer2018.pdf

// process.platform === 'win32'
path = '/Documents/Newsletters/Summer2018.pdf';
console.log( _.uri.nativize( path ) ); 
// \Documents\Newsletters\Summer2018.pdf

//

// process.platform !== 'win32'
path = '/bin';
console.log( _.uri.nativize( path ) ); 
// /bin

// process.platform !== 'win32'
path = '/home/mthomas/class_stuff/foo';
console.log( _.uri.nativize( path ) ); 
// /home/mthomas/class_stuff/foo