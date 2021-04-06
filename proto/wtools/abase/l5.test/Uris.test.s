( function _Uris_test_s_( )
{

'use strict';

if( typeof module !== 'undefined' )
{
  let _ = require( '../../../node_modules/Tools' );
  _.include( 'wTesting' );
  // _.include( 'wStringer' );
  require( '../l5/Uris.s' );
}

const _global = _global_;
const _ = _global_.wTools;

/*
qqq : fix style problems and non-style problems in the test | Dmytro : fixed
*/

// --
//
// --

function refine( test )
{
  test.case = 'refine the uris';
  var srcs =
  [
    '/some/staging/index.html',
    '/some/staging/index.html/',
    '//some/staging/index.html',
    '//some/staging/index.html/',
    '///some/staging/index.html',
    '///some/staging/index.html/',
    'file:///some/staging/index.html',
    'file:///some/staging/index.html/',
    'http://some.come/staging/index.html',
    'http://some.come/staging/index.html/',
    'svn+https://user@subversion.com/svn/trunk',
    'svn+https://user@subversion.com/svn/trunk/',
    'complex+protocol://www.site.com:13/path/name/?query=here&and=here#anchor',
    'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor',
    'https://web.archive.org/web/*/http://www.heritage.org/index/ranking',
    'https://web.archive.org//web//*//http://www.heritage.org//index//ranking',
    '://www.site.com:13/path//name//?query=here&and=here#anchor',
    ':///www.site.com:13/path//name/?query=here&and=here#anchor',
  ]
  var expected =
  [
    '/some/staging/index.html',
    '/some/staging/index.html/',
    '//some/staging/index.html',
    '//some/staging/index.html/',
    '///some/staging/index.html',
    '///some/staging/index.html/',
    'file:///some/staging/index.html',
    'file:///some/staging/index.html/',
    'http://some.come/staging/index.html',
    'http://some.come/staging/index.html/',
    'svn+https://user@subversion.com/svn/trunk',
    'svn+https://user@subversion.com/svn/trunk/',
    'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor',
    'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor',
    'https://web.archive.org/web/*/http://www.heritage.org/index/ranking',
    'https://web.archive.org//web//*//http://www.heritage.org//index//ranking',
    '://www.site.com:13/path//name/?query=here&and=here#anchor',
    ':///www.site.com:13/path//name?query=here&and=here#anchor'
  ]
  var got = _.uri.s.refine( srcs );
  test.identical( got, expected );

  if( !Config.debug )
  return;

  test.case = 'incorrect input';
  test.shouldThrowErrorSync( () => _.uris.refine() );
  test.shouldThrowErrorSync( () => _.uris.refine( [] ) );
  test.shouldThrowErrorSync( () => _.uris.refine( {} ) );
  test.shouldThrowErrorSync( () => _.uris.refine( [ '' ] ) );
  test.shouldThrowErrorSync( () => _.uris.refine( [ 1, 'http://some.com' ] ) );

}

//

function common( test )
{

  test.case = 'empty';

  var got = _.uri.s.common();
  test.identical( got, null );

  var got = _.uri.s.common([]);
  test.identical( got, [] );

  test.case = 'array';

  var got = _.uri.s.common([ '/a1/b2', '/a1/b' ]);
  test.identical( got, [ '/a1/b2', '/a1/b' ] );

  var got = _.uri.s.common( [ '/a1/b1/c', '/a1/b1/d' ], '/a1/b2' );
  test.identical( got, [ '/a1/', '/a1/' ] );

  test.case = 'other';

  var got = _.uri.s.common( 'npm:///wprocedure#0.3.19', 'npm:///wprocedure' );
  test.identical( got, 'npm:///wprocedure' );

  var got = _.uri.s.common( 'npm:///wprocedure', 'npm:///wprocedure#0.3.19' );
  test.identical( got, 'npm:///wprocedure' );

  var got = _.uri.s.common( 'npm:///wprocedure#0.3.19', 'npm:///wprocedure#' );
  test.identical( got, 'npm:///wprocedure' );

  var got = _.uri.s.common( 'npm:///wprocedure#', 'npm:///wprocedure#0.3.19' );
  test.identical( got, 'npm:///wprocedure' );

  var got = _.uri.s.common( 'git+https:///github.com/repo/wTools#bd9094b83', 'git+https:///github.com/repo/wTools#master' );
  test.identical( got, 'git+https:///github.com/repo/wTools' );

  var got = _.uri.s.common( '://a1/b2', '://some/staging/index.html' );
  test.identical( got, '://.' );

  var got = _.uri.s.common( '://some/staging/index.html', '://a1/b2' );
  test.identical( got, '://.' );

  var got = _.uri.s.common( '://some/staging/index.html', '://some/staging/' );
  test.identical( got, '://some/staging/' );

  var got = _.uri.s.common( '://some/staging/index.html', '://some/stagi' );
  test.identical( got, '://some/' );

  var got = _.uri.s.common( 'file:///some/staging/index.html', ':///some/stagi' );
  test.identical( got, ':///some/' );

  var got = _.uri.s.common( 'file://some/staging/index.html', '://some/stagi' );
  test.identical( got, '://some/' );

  var got = _.uri.s.common( 'file:///some/staging/index.html', '/some/stagi' );
  test.identical( got, ':///some/' );

  var got = _.uri.s.common( 'file:///some/staging/index.html', 'file:///some/staging' );
  test.identical( got, 'file:///some/staging' );

  var got = _.uri.s.common( 'http://some', 'some/staging' );
  test.identical( got, '://some' );

  var got = _.uri.s.common( 'some/staging', 'http://some' );
  test.identical( got, '://some' );

  var got = _.uri.s.common( 'http://some.come/staging/index.html', 'some/staging' );
  test.identical( got, '://.' );

  var got = _.uri.s.common( 'http:///some.come/staging/index.html', '/some/staging' );
  test.identical( got, ':///' );

  var got = _.uri.s.common( 'http://some.come/staging/index.html', 'file://some/staging' );
  test.identical( got, '' );

  var got = _.uri.s.common( 'http:///some.come/staging/index.html', 'file:///some/staging' );
  test.identical( got, '' );

  var got = _.uri.s.common( 'http:///some.come/staging/index.html', 'http:///some/staging/file.html' );
  test.identical( got, 'http:///' );

  var got = _.uri.s.common( 'http://some.come/staging/index.html', 'http://some.come/some/staging/file.html' );
  test.identical( got, 'http://some.come/' );

  // xxx !!! : implement
  var got = _.uri.s.common( 'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor', 'complex+protocol://www.site.com:13/path' );
  test.identical( got, 'complex+protocol://www.site.com:13/path' );

  var got = _.uri.s.common( 'complex+protocol://www.site.com:13/path', 'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor' );
  test.identical( got, 'complex+protocol://www.site.com:13/path' );

  var got = _.uri.s.common( 'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor', 'complex+protocol://www.site.com:13/path?query=here' );
  test.identical( got, 'complex+protocol://www.site.com:13/path' );

  var got = _.uri.s.common( 'complex+protocol://www.site.com:13/path?query=here', 'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor' );
  test.identical( got, 'complex+protocol://www.site.com:13/path' );

  var got = _.uri.s.common( 'https://user:pass@sub.host.com:8080/p/a/t/h?query=string#hash', 'https://user:pass@sub.host.com:8080/p/a' );
  test.identical( got, 'https://user:pass@sub.host.com:8080/p/a' );

  var got = _.uri.s.common( '://some/staging/a/b/c', '://some/staging/a/b/c/index.html', '://some/staging/a/x' );
  test.identical( got, '://some/staging/a/' );

  var got = _.uri.s.common( 'http:///', 'http:///' );
  test.identical( got, 'http:///' );

  var got = _.uri.s.common( '/some/staging/a/b/c' );
  test.identical( got, '/some/staging/a/b/c' );

  test.case = 'combination of diff strcutures';

  var got = _.uri.s.common( [ 'http:///' ], [ 'http:///' ] )
  test.identical( got, [ 'http:///' ] );

  var got = _.uri.s.common( [ 'http:///x' ], [ 'http:///y' ] )
  test.identical( got, [ 'http:///' ] );

  var got = _.uri.s.common( [ 'http:///a/x' ], [ 'http:///a/y' ] )
  test.identical( got, [ 'http:///a/' ] );

  var got = _.uri.s.common( [ 'http:///a/x' ], 'http:///a/y' )
  test.identical( got, [ 'http:///a/' ] );

  var got = _.uri.s.common( 'http:///a/x', [ 'http:///a/y' ] )
  test.identical( got, [ 'http:///a/' ] );

  var got = _.uri.s.common( 'http:///a/x', 'http:///a/y' )
  test.identical( got, 'http:///a/' );

  var got = _.uri.s.common( [ [ 'http:///a/x' ], 'http:///a/y' ], 'http:///a/z' )
  test.identical( got, [ 'http:///a/', 'http:///a/' ] );

  /* */

  if( !Config.debug )
  return

  test.case = 'incorrect input';
  test.shouldThrowErrorOfAnyKind( () => _.uri.s.common( 1, 2 ) );

  test.case = 'different paths'
  test.shouldThrowErrorOfAnyKind( () => _.uri.s.common( 'http://some.come/staging/index.html', 'file:///some/staging' ) );
  test.shouldThrowErrorOfAnyKind( () => _.uri.s.common( 'http://some.come/staging/index.html', 'http:///some/staging/file.html' ) );

}

//

// function commonMapsInArgs( test )
// {
//   test.case = 'array with paths';
//   var src1 = _.uri.parseFull( '/a1/b2' );
//   var src2 = _.uri.parse( '/a1/b' );
//   var got = _.uri.s.common( [ src1, src2 ], [ src2, src1 ] );
//   test.identical( got, [ '/a1/', '/a1/' ] );
//
//   test.case = 'array with paths and path';
//   var src1 = _.uri.parseFull( '/a1/b1/c' );
//   var src2 = _.uri.parse( '/a1/b1/d' );
//   // var src3 = _.uri.parse( '/a1/b2' );
//   var got = _.uri.s.common( [ src1, src2 ], '/a1/b2' );
//   test.identical( got, [ '/a1/', '/a1/' ] );
//
//   /* */
//
//   test.case = 'equal protocols and local path';
//   var src1 = _.uri.parse( 'npm:///wprocedure#0.3.19' );
//   var src2 = _.uri.parse( 'npm:///wprocedure' );
//   debugger;
//   var got = _.uri.s.common( src1, src2 );
//   test.identical( got, 'npm:///wprocedure' );
//
//   test.case = 'equal protocols, local paths has anchor tags';
//   var src1 = _.uri.parseAtomic( 'npm:///wprocedure#0.3.19' );
//   var src2 = _.uri.parseAtomic( 'npm:///wprocedure#' );
//   var got = _.uri.s.common( src1, src2 );
//   test.identical( got, 'npm:///wprocedure' );
//
//   test.case = 'equal complex protocols and local paths';
//   var src1 = _.uri.parseConsecutive( 'git+https:///github.com/repo/wTools#bd9094b83' );
//   var src2 = _.uri.parseConsecutive( 'git+https:///github.com/repo/wTools#master' );
//   var got = _.uri.s.common( src1, src2 );
//   test.identical( got, 'git+https:///github.com/repo/wTools' );
//
//   test.case = 'without protocols, local paths is different';
//   var src1 = _.uri.parseFull( '://a1/b2' );
//   var src2 = _.uri.parseFull( '://some/staging/index.html' );
//   var got = _.uri.s.common( src1, src2 );
//   test.identical( got, '://.' );
//
//   test.case = 'without protocols, local paths partly equal';
//   var src1 = _.uri.parse( '://some/staging/index.html' );
//   var src2 = _.uri.parseFull( '://some/staging/' );
//   var got = _.uri.s.common( src1, src2 );
//   test.identical( got, '://some/staging/' );
//
//   test.case = 'without protocols, local paths partly equal, not full subpath';
//   var src1 = _.uri.parseAtomic( '://some/staging/index.html' );
//   var src2 = _.uri.parseFull( '://some/stagi' );
//   var got = _.uri.s.common( src1, src2 );
//   test.identical( got, '://some/' );
//
//   test.case = 'local paths partly equal, not full subpath';
//   var src1 = _.uri.parseConsecutive( 'file:///some/staging/index.html' );
//   var src2 = _.uri.parseFull( ':///some/stagi' );
//   var got = _.uri.s.common( src1, src2 );
//   test.identical( got, ':///some/' );
//
//   test.case = 'local paths partly equal, not full subpath';
//   var src1 = _.uri.parse( 'file://some/staging/index.html' );
//   var src2 = _.uri.parseFull( '://some/stagi' );
//   var got = _.uri.s.common( src1, src2 );
//   test.identical( got, '://some/' );
//
//   test.case = 'local paths partly equal, not full subpath';
//   var src1 = _.uri.parseConsecutive( 'file:///some/staging/index.html' );
//   var src2 = _.uri.parseAtomic( '/some/stagi' );
//   var got = _.uri.s.common( src1, src2 );
//   test.identical( got, ':///some/' );
//
//   test.case = 'equal protocols, local paths partly equal, not full subpath';
//   var src1 = _.uri.parseFull( 'file:///some/staging/index.html' );
//   var src2 = _.uri.parseConsecutive( 'file:///some/staging' );
//   var got = _.uri.s.common( src1, src2 );
//   test.identical( got, 'file:///some/staging' );
//
//   test.case = 'path with protocol and without it, partly equal';
//   var src1 = _.uri.parse( 'http://some' );
//   var src2 = _.uri.parse( 'some/staging' );
//   var got = _.uri.s.common( src1, src2 );
//   test.identical( got, '://some' );
//
//   test.case = 'map with paths in keys, path with protocol and without it';
//   var src = { 'some/staging' : '', 'http://some' : '' };
//   var got = _.uri.s.common( src );
//   test.identical( got, '://some' );
//
//   test.case = 'map with paths in keys, path with protocol and without it';
//   var src = { 'http://some.come/staging/index.html' : '', 'some/staging' : '' };
//   var got = _.uri.s.common( src );
//   test.identical( got, '://.' );
//
//   test.case = 'path with protocol and without it, local paths is not equal';
//   var src1 = _.uri.parse( 'http:///some.come/staging/index.html' );
//   var src2 = _.uri.parseFull( '/some/staging' );
//   var got = _.uri.s.common( src1, src2 );
//   test.identical( got, ':///' );
//
//   test.case = 'different protocols and local paths';
//   var src1 = _.uri.parseFull( 'http://some.come/staging/index.html' );
//   var src2 = _.uri.parseFull( 'file://some/staging' );
//   var got = _.uri.s.common( src1, src2 );
//   test.identical( got, '' );
//
//   test.case = 'path with protocol and without it, local paths is not equal';
//   var src1 = _.uri.parseConsecutive( 'http:///some.come/staging/index.html' );
//   var src2 = _.uri.parse( 'file:///some/staging' );
//   var got = _.uri.s.common( src1, src2 );
//   test.identical( got, '' );
//
//   test.case = 'the same protocols';
//   var src1 = _.uri.parseAtomic( 'http:///some.come/staging/index.html' );
//   var src2 = _.uri.parseConsecutive( 'http:///some/staging/file.html' );
//   var got = _.uri.s.common( src1, src2 );
//   test.identical( got, 'http:///' );
//
//   test.case = 'path with equal protocols, begin of local paths is equal';
//   var src1 = _.uri.parseFull( 'http://some.come/staging/index.html' );
//   var src2 = _.uri.parse( 'http://some.come/some/staging/file.html' );
//   var got = _.uri.s.common( src1, src2 );
//   test.identical( got, 'http://some.come/' );
//
//   test.case = 'one path has queries and anchor';
//   var src1 = _.uri.parse( 'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor' );
//   var src2 = _.uri.parseConsecutive( 'complex+protocol://www.site.com:13/path' );
//   var got = _.uri.s.common( src1, src2 );
//   test.identical( got, 'complex+protocol://www.site.com:13/path' );
//
//   test.case = 'two paths has equal begin, second paths has not full query and anchor';
//   var src1 = _.uri.parse( 'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor' );
//   var src2 = _.uri.parseAtomic( 'complex+protocol://www.site.com:13/path?query=here' );
//   var got = _.uri.s.common( src1, src2 );
//   test.identical( got, 'complex+protocol://www.site.com:13/path' );
//
//   test.case = 'paths with ports';
//   var src1 = _.uri.parseFull( 'https://user:pass@sub.host.com:8080/p/a/t/h?query=string#hash' );
//   var src2 = _.uri.parseAtomic( 'https://user:pass@sub.host.com:8080/p/a' );
//   var got = _.uri.s.common( src1, src2 );
//   test.identical( got, 'https://user:pass@sub.host.com:8080/p/a' );
//
//   test.case = 'three paths';
//   var src1 = _.uri.parse( '://some/staging/a/b/c' );
//   var src2 = _.uri.parse( '://some/staging/a/b/c/index.html' );
//   var got = _.uri.s.common( src1, src2, '://some/staging/a/x' );
//   test.identical( got, '://some/staging/a/' );
//
//   test.case = 'one map and one string path, only protocols';
//   var src = _.uri.parseAtomic( 'http:///' );
//   var got = _.uri.s.common( src, 'http:///' );
//   test.identical( got, 'http:///' );
//
//   test.case = 'one path';
//   var src = _.uri.parse( '/some/staging/a/b/c' );
//   var got = _.uri.s.common( src );
//   test.identical( got, '/some/staging/a/b/c' );
//
//   /* */
//
//   test.case = 'string and map path in longs, only protocols';
//   var src = _.uri.parse( 'http:///' );
//   var got = _.uri.s.common( [ 'http:///' ], [ src ] )
//   test.identical( got, [ 'http:///' ] );
//
//   test.case = 'string and map path in longs, protocols and local paths';
//   var src = _.uri.parseFull( 'http:///y' );
//   var got = _.uri.s.common( [ 'http:///x' ], [ src ] )
//   test.identical( got, [ 'http:///' ] );
//
//   test.case = 'string and map path in longs, protocols and local paths, local paths partly equal';
//   var src = _.uri.parseAtomic( 'http:///a/x' );
//   var got = _.uri.s.common( [ src ], [ 'http:///a/y' ] )
//   test.identical( got, [ 'http:///a/' ] );
//
//   test.case = 'paths nested in few levels';
//   var src = _.uri.parseConsecutive( 'http:///a/x' );
//   var got = _.uri.s.common( [ [ [ src ] ] ], 'http:///a/y' )
//   test.identical( got, [ 'http:///a/' ] );
//
//   test.case = 'complex structure of paths';
//   var src1 = { 'http:///a/x' : '' };
//   var src2 = { 'http:///a/y' : '' };
//   var got = _.uri.s.common( [ [ src1 ], src2 ], 'http:///a/z' )
//   test.identical( got, [ 'http:///a/', 'http:///a/' ] );
// }

// --
// declare
// --

const Proto =
{

  name : 'Tools.l4.Uri.S',
  silencing : 1,

  tests :
  {
    refine,
    common,
    // commonMapsInArgs,
  },

}

const Self = wTestSuite( Proto );

if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self );

})();
