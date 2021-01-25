
if( typeof module !== 'undefined' )
require( 'wuribasic' );
let _ = wTools;

var uri = 'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor';
var parsed = _.uri.parse( uri );
console.log( 'Uri : ', uri );
console.log( 'Parsed ( full ) : \n', parsed );

/* log
Parsed ( full ) :
 [Object: null prototype] {
  'protocol' : 'complex+protocol',
  'host' : 'www.site.com',
  'port' : '13',
  'localWebPath' : '/path/name',
  'query' : 'query=here&and=here',
  'hash' : 'anchor',
  'longPath' : 'www.site.com:13/path/name',
  'protocols' : [ 'complex', 'protocol' ],
  'hostWithPort' : 'www.site.com:13',
  'origin' : 'complex+protocol://www.site.com:13',
  'full' : 'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor'
}
*/

/* */

var uri = 'git://../repo/Tools?out=out/wTools.out.will#master'
var parsed = _.uri.parseAtomic( uri );
console.log( 'Uri : ', uri );
console.log( 'Parsed ( atomic ) :\n', parsed );

/* log
Parsed ( atomic ) :
 [Object: null prototype] {
  'protocol' : 'git',
  'host' : '..',
  'localWebPath' : '/repo/Tools',
  'query' : 'out=out/wTools.out.will',
  'hash' : 'master'
}
*/
