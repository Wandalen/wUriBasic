
if( typeof module !== 'undefined' )
require( 'wUriFundamentals' );

var _ = wTools;

var pathFile = '/a/b/c.x'
var name = _.pathName( pathFile );
console.log( 'name of ' + pathFile + ' is ' + name );
