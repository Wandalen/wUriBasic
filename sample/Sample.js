
if( typeof module !== 'undefined' )
require( 'wuribasic' );
var _ = wTools;

var uri = 'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor';
var parsed = _.uri.parse( uri );
console.log( 'parsed :', parsed );

/*
parsed :
{
  protocol: 'complex+protocol',
  host: 'www.site.com',
  port: '13',
  localPath: '/path/name',
  query: 'query=here&and=here',
  hash: 'anchor',
  longPath: 'www.site.com:13/path/name',
  protocols: [ 'complex', 'protocol' ],
  hostWithPort: 'www.site.com:13',
  origin: 'complex+protocol://www.site.com:13',
  full: 'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor'
}
*/
