( function _Uri_test_s_( )
{

'use strict';

if( typeof module !== 'undefined' )
{
  let _ = require( '../../../wtools/Tools.s' );
  _.include( 'wTesting' );
  // _.include( 'wStringer' );
  require( '../l4/Uri.s' );
}

let _global = _global_;
let _ = _global_.wTools;

// --
// tests
// --

function isRelative( test )
{
  /* */

  test.case = 'relative with protocol';

  var path = 'ext://.';
  var expected = true;
  var got = _.uriNew.isRelative( path );
  test.identical( got, expected );

  /* */

  test.case = 'relative with protocol and folder';

  var path = 'ext://something';
  var expected = true;
  var got = _.uriNew.isRelative( path );
  test.identical( got, expected );

  /* */

  test.case = 'relative with protocol and 2 folders';

  var path = 'ext://something/longer';
  var expected = true;
  var got = _.uriNew.isRelative( path );
  test.identical( got, expected );

  /* */

  test.case = 'absolute with protocol';

  var path = 'ext:///';
  var expected = false;
  var got = _.uriNew.isRelative( path );
  test.identical( got, expected );
}

//

function isRoot( test )
{
  test.case = 'local';

  var path = '/src/a1';
  var got = _.uriNew.isRoot( path );
  test.identical( got, false );

  var path = '.';
  var got = _.uriNew.isRoot( path );
  test.identical( got, false );

  var path = '';
  var got = _.uriNew.isRoot( path );
  test.identical( got, false );

  var path = '/';
  var got = _.uriNew.isRoot( path );
  test.identical( got, true );

  var path = '/.';
  var got = _.uriNew.isRoot( path );
  test.identical( got, true );

  var path = '/./.';
  var got = _.uriNew.isRoot( path );
  test.identical( got, true );

  var path = '/x/..';
  var got = _.uriNew.isRoot( path );
  test.identical( got, true );

  test.case = 'global';

  var path = 'extract+src:///src/a1';
  var got = _.uriNew.isRoot( path );
  test.identical( got, false );

  var path = 'extract+src:///';
  var got = _.uriNew.isRoot( path );
  test.identical( got, true );

  var path = 'extract+src:///.';
  var got = _.uriNew.isRoot( path );
  test.identical( got, true );

  var path = 'extract+src:///./.';
  var got = _.uriNew.isRoot( path );
  test.identical( got, true );

  var path = 'extract+src:///x/..';
  var got = _.uriNew.isRoot( path );
  test.identical( got, true );

  var path = 'extract+src://';
  var got = _.uriNew.isRoot( path );
  test.identical( got, false );

  var path = 'extract+src://.';
  var got = _.uriNew.isRoot( path );
  test.identical( got, false );
}

//

function normalize( test )
{
  test.case = 'empty';
  var path = '';
  var expected = '';
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  test.case = 'dot at end';
  var path = 'ext:///.';
  var expected = 'ext:///';
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  var path = 'file:///C/proto/.';
  var expected = 'file:///C/proto';
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  var path = '://some/staging/index.html/'
  var expected ='://some/staging/index.html/'
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  var path = '://some/staging/index.html/.'
  var expected ='://some/staging/index.html'
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  var path = '://some/staging/index.html.'
  var expected ='://some/staging/index.html.'
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  var path = ':///some/staging/index.html'
  var expected =':///some/staging/index.html'
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  var path = ':///some/staging/index.html/.'
  var expected =':///some/staging/index.html'
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  var path = ':///some/staging/index.html/./'
  var expected =':///some/staging/index.html/'
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  var path = ':///some/staging/./index.html/./'
  var expected =':///some/staging/index.html/'
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  var path = ':///some/staging/.//index.html/./'
  var expected =':///some/staging//index.html/'
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  var path = ':///some/staging/index.html///.'
  var expected =':///some/staging/index.html//'
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  var path = 'file:///some/staging/index.html/..'
  var expected ='file:///some/staging'
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  var path = 'file:///some/staging/index.html/..///'
  var expected ='file:///some/staging///'
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  var path = 'file:///some\\staging\\index.html\\..\\'
  var expected ='file:///some/staging/'
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  var path = 'http:///./some.come/staging/index.html/.'
  var expected ='http:///some.come/staging/index.html'
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  var path = 'http:///./some.come/staging/index.html'
  var expected ='http:///some.come/staging/index.html'
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  var path = 'http:///./some.come/./staging/index.html'
  var expected ='http:///some.come/staging/index.html'
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  var path = 'svn+https://../user@subversion.com/svn/trunk'
  var expected ='svn+https://../user@subversion.com/svn/trunk'
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  var path = 'svn+https://..//..//user@subversion.com/svn/trunk'
  var expected ='svn+https://..//user@subversion.com/svn/trunk'
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  var path = 'svn+https://..//../user@subversion.com/svn/trunk'
  var expected ='svn+https://../user@subversion.com/svn/trunk'
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  var path = 'complex+protocol://www.site.com:13/path/name/.?query=here&and=here#anchor'
  var expected ='complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor'
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  var path = 'complex+protocol://www.site.com:13/path/name/./../?query=here&and=here#anchor'
  var expected ='complex+protocol://www.site.com:13/path/?query=here&and=here#anchor'
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  var path = 'complex+protocol://www.site.com:13/path/name/./..?query=here&and=here#anchor'
  var expected ='complex+protocol://www.site.com:13/path?query=here&and=here#anchor'
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  var path = 'complex+protocol://www.site.com:13/path/name/.//../?query=here&and=here#anchor'
  var expected ='complex+protocol://www.site.com:13/path/name/?query=here&and=here#anchor'
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  var path = 'https://web.archive.org/web/*\/http://www.heritage.org/index/ranking/.'
  var expected ='https://web.archive.org/web/*\/http://www.heritage.org/index/ranking'
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  var path = 'https://web.archive.org/web/*\/http://www.heritage.org/index/ranking//.'
  var expected ='https://web.archive.org/web/*\/http://www.heritage.org/index/ranking/'
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  var path = 'https://web.archive.org/web/*\/http://www.heritage.org//index/ranking//.'
  var expected ='https://web.archive.org/web/*\/http://www.heritage.org//index/ranking/'
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  var path = 'https://web.archive.org/web/*\/http://www.heritage.org/../index/ranking//.'
  var expected ='https://web.archive.org/web/*\/http://index/ranking/'
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  var path = 'https://web.archive.org/web/*\/http://www.heritage.org/.././index/ranking//.'
  var expected ='https://web.archive.org/web/*\/http://index/ranking/'
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  var path = 'https://web.archive.org/web/*\/http://www.heritage.org/.././index/ranking/./.'
  var expected ='https://web.archive.org/web/*\/http://index/ranking'
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );
}

//

function normalizeLocalPaths( test )
{
  /* */

  test.case = 'posix path';

  var path = '/foo/bar//baz/asdf/quux/..';
  var expected = '/foo/bar//baz/asdf';
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  var path = '/foo/bar//baz/asdf/quux/../';
  var expected = '/foo/bar//baz/asdf/';
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  var path = '//foo/bar//baz/asdf/quux/..//';
  var expected = '//foo/bar//baz/asdf//';
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  var path = 'foo/bar//baz/asdf/quux/..//.';
  var expected = 'foo/bar//baz/asdf/';
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  /* */

  test.case = 'winoows path';

  var path = 'C:\\temp\\\\foo\\bar\\..\\';
  var expected = '/C/temp//foo/';
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  var path = 'C:\\temp\\\\foo\\bar\\..\\\\';
  var expected = '/C/temp//foo//';
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  var path = 'C:\\temp\\\\foo\\bar\\..\\\\';
  var expected = '/C/temp//foo//';
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  var path = 'C:\\temp\\\\foo\\bar\\..\\..\\';
  var expected = '/C/temp//';
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  var path = 'C:\\temp\\\\foo\\bar\\..\\..\\.';
  var expected = '/C/temp/';
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  /* */

  test.case = 'empty path';

  var path = '';
  var expected = '';
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  var path = '/';
  var expected = '/';
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  var path = '//';
  var expected = '//';
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  var path = '///';
  var expected = '///';
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  var path = '/.';
  var expected = '/';
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  var path = '/./.';
  var expected = '/';
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  var path = '.';
  var expected = '.';
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  var path = './.';
  var expected = '.';
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  /* */

  test.case = 'path with "." in the middle';

  var path = 'foo/./bar/baz';
  var expected = 'foo/bar/baz';
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  var path = 'foo/././bar/baz/';
  var expected = 'foo/bar/baz/';
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  var path = 'foo/././bar/././baz/';
  var expected = 'foo/bar/baz/';
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  var path = '/foo/././bar/././baz/';
  var expected = '/foo/bar/baz/';
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  var path = '/foo/.x./baz/';
  var expected = '/foo/.x./baz/';
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  /* */

  test.case = 'path with "." in the beginning';

  var path = './foo/bar';
  var expected = './foo/bar';
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  var path = '././foo/bar/';
  var expected = './foo/bar/';
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  var path = './/.//foo/bar/';
  var expected = './//foo/bar/';
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  var path = '/.//.//foo/bar/';
  var expected = '///foo/bar/';
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  var path = '.x/foo/bar';
  var expected = '.x/foo/bar';
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  var path = '.x./foo/bar';
  var expected = '.x./foo/bar';
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  var path = './x/.';
  var expected = './x';
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  /* */

  test.case = 'path with "." in the end';

  var path = 'foo/bar.';
  var expected = 'foo/bar.';
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  var path = 'foo/.bar.';
  var expected = 'foo/.bar.';
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  var path = 'foo/bar/.';
  var expected = 'foo/bar';
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  var path = 'foo/bar/./.';
  var expected = 'foo/bar';
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  var path = 'foo/bar/././';
  var expected = 'foo/bar/';
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  var path = '/foo/bar/././';
  var expected = '/foo/bar/';
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  var path = '/foo/baz/.x./';
  var expected = '/foo/baz/.x./';
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  /* */

  test.case = 'path with ".." in the middle';

  var path = 'foo/../bar/baz';
  var expected = 'bar/baz';
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  var path = 'foo/../../bar/baz/';
  var expected = '../bar/baz/';
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  var path = 'foo/../../bar/../../baz/';
  var expected = '../../baz/';
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  var path = '/foo/../../bar/../../baz/';
  var expected = '/../../baz/';
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  /* */

  test.case = 'path with ".." in the beginning';

  var path = '../foo/bar';
  var expected = '../foo/bar';
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  var path = '../../foo/bar/';
  var expected = '../../foo/bar/';
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  var path = '..//..//foo/bar/';
  var expected = '..//foo/bar/';
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  var path = '/..//..//foo/bar/';
  var expected = '/..//foo/bar/';
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  var path = '..x/foo/bar';
  var expected = '..x/foo/bar';
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  var path = '..x../foo/bar';
  var expected = '..x../foo/bar';
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  /* */

  test.case = 'path with ".." in the end';

  var path = 'foo/bar..';
  var expected = 'foo/bar..';
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  var path = 'foo/..bar..';
  var expected = 'foo/..bar..';
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  var path = 'foo/bar/..';
  var expected = 'foo';
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  var path = 'foo/bar/../..';
  var expected = '.';
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  var path = 'foo/bar/../../';
  var expected = './';
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  var path = '/foo/bar/../../';
  var expected = '/';
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  var path = 'foo/bar/../../..';
  var expected = '..';
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  var path = 'foo/bar/../../../..';
  var expected = '../..';
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  var path = 'foo/../bar/../../../..';
  var expected = '../../..';
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  /* */

  test.case = 'path with ".." and "." combined';

  var path = '/abc/./../a/b';
  var expected = '/a/b';
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  var path = '/abc/.././a/b';
  var expected = '/a/b';
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  var path = '/abc/./.././a/b';
  var expected = '/a/b';
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  var path = '/a/b/abc/../.';
  var expected = '/a/b';
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  var path = '/a/b/abc/./..';
  var expected = '/a/b';
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  var path = '/a/b/abc/./../.';
  var expected = '/a/b';
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  var path = './../.';
  var expected = '..';
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  var path = './..';
  var expected = '..';
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );

  var path = '../.';
  var expected = '..';
  var got = _.uriNew.normalize( path );
  test.identical( got, expected );
}

//

function normalizeTolerant( test )
{
  test.case = 'dot at end';
  var path = 'ext:///.';
  var expected = 'ext:///';
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'file:///C/proto/.';
  var expected = 'file:///C/proto';
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'file:///C/proto/./';
  var expected = 'file:///C/proto/';
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  test.case = '';
  var path = '://some/staging/index.html/'
  var expected ='://some/staging/index.html/'
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  test.case = '';
  var path = '://some/staging/index.html/./'
  var expected ='://some/staging/index.html/'
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  test.case = '';
  var path = '://some/staging/index.html/.'
  var expected ='://some/staging/index.html'
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '://some/staging/index.html/.'
  var expected ='://some/staging/index.html'
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '://some/staging/index.html.'
  var expected ='://some/staging/index.html.'
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = ':///some/staging/index.html'
  var expected =':///some/staging/index.html'
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = ':///some/staging/index.html/.'
  var expected =':///some/staging/index.html'
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = ':///some/staging/index.html/./'
  var expected =':///some/staging/index.html/'
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = ':///some/staging/./index.html/./'
  var expected =':///some/staging/index.html/'
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = ':///some/staging/.//index.html/./'
  var expected =':///some/staging/index.html/'
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = ':///some/staging/index.html///.'
  var expected =':///some/staging/index.html'
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'file:///some/staging/index.html/..'
  var expected ='file:///some/staging'
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'file:///some/staging/index.html/..///'
  var expected ='file:///some/staging/'
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'file:///some\\staging\\index.html\\..\\'
  var expected ='file:///some/staging/'
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'http:///./some.come/staging/index.html/.'
  var expected ='http:///some.come/staging/index.html'
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'http:///./some.come/staging/index.html'
  var expected ='http:///some.come/staging/index.html'
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'http:///./some.come/./staging/index.html'
  var expected ='http:///some.come/staging/index.html'
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'svn+https://../user@subversion.com/svn/trunk'
  var expected ='svn+https://../user@subversion.com/svn/trunk'
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'svn+https://..//..//user@subversion.com/svn/trunk'
  var expected ='svn+https://../../user@subversion.com/svn/trunk'
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'svn+https://..//../user@subversion.com/svn/trunk'
  var expected ='svn+https://../../user@subversion.com/svn/trunk'
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'complex+protocol://www.site.com:13/path/name/.?query=here&and=here#anchor'
  var expected ='complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor'
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'complex+protocol://www.site.com:13/path/name/./../?query=here&and=here#anchor'
  var expected ='complex+protocol://www.site.com:13/path/?query=here&and=here#anchor'
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'complex+protocol://www.site.com:13/path/name/.//../?query=here&and=here#anchor'
  var expected ='complex+protocol://www.site.com:13/path/?query=here&and=here#anchor'
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'https://web.archive.org/web/*\/http://www.heritage.org/index/ranking/.'
  var expected ='https://web.archive.org/web/*\/http:/www.heritage.org/index/ranking'
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'https://web.archive.org/web/*\/http://www.heritage.org/index/ranking//.'
  var expected ='https://web.archive.org/web/*\/http:/www.heritage.org/index/ranking'
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'https://web.archive.org/web/*\/http://www.heritage.org//index/ranking//.'
  var expected ='https://web.archive.org/web/*\/http:/www.heritage.org/index/ranking'
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'https://web.archive.org/web/*\/http://www.heritage.org/../index/ranking//.'
  var expected ='https://web.archive.org/web/*\/http:/index/ranking'
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'https://web.archive.org/web/*\/http://www.heritage.org/.././index/ranking//.'
  var expected ='https://web.archive.org/web/*\/http:/index/ranking'
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'https://web.archive.org/web/*\/http://www.heritage.org/.././index/ranking/./.'
  var expected ='https://web.archive.org/web/*\/http:/index/ranking'
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'https://web.archive.org/web/*\/http://www.heritage.org/.././index/ranking/././'
  var expected ='https://web.archive.org/web/*\/http:/index/ranking/'
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );
}

//

function normalizeTolerantLocalPaths( test )
{
  /* */

  test.case = 'posix path';

  var path = '/foo/bar//baz/asdf/quux/..';
  var expected = '/foo/bar/baz/asdf';
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '/foo/bar//baz/asdf/quux/../';
  var expected = '/foo/bar/baz/asdf/';
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '//foo/bar//baz/asdf/quux/..//';
  var expected = '/foo/bar/baz/asdf/';
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'foo/bar//baz/asdf/quux/..//.';
  var expected = 'foo/bar/baz/asdf';
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  /* */

  test.case = 'winoows path';

  var path = 'C:\\temp\\\\foo\\bar\\..\\';
  var expected = '/C/temp/foo/';
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'C:\\temp\\\\foo\\bar\\..\\\\';
  var expected = '/C/temp/foo/';
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'C:\\temp\\\\foo\\bar\\..\\\\';
  var expected = '/C/temp/foo/';
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'C:\\temp\\\\foo\\bar\\..\\..\\';
  var expected = '/C/temp/';
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'C:\\temp\\\\foo\\bar\\..\\..\\.';
  var expected = '/C/temp';
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  /* */

  test.case = 'empty path';

  var path = '';
  var expected = '';
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '/';
  var expected = '/';
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '//';
  var expected = '/';
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '///';
  var expected = '/';
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '/.';
  var expected = '/';
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '/./.';
  var expected = '/';
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '.';
  var expected = '.';
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = './.';
  var expected = '.';
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  /* */

  test.case = 'path with "." in the middle';

  var path = 'foo/./bar/baz';
  var expected = 'foo/bar/baz';
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'foo/././bar/baz/';
  var expected = 'foo/bar/baz/';
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'foo/././bar/././baz/';
  var expected = 'foo/bar/baz/';
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '/foo/././bar/././baz/';
  var expected = '/foo/bar/baz/';
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '/foo/.x./baz/';
  var expected = '/foo/.x./baz/';
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  /* */

  test.case = 'path with "." in the beginning';

  var path = './foo/bar';
  var expected = './foo/bar';
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '././foo/bar/';
  var expected = './foo/bar/';
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = './/.//foo/bar/';
  var expected = './foo/bar/';
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '/.//.//foo/bar/';
  var expected = '/foo/bar/';
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '.x/foo/bar';
  var expected = '.x/foo/bar';
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '.x./foo/bar';
  var expected = '.x./foo/bar';
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = './x/.';
  var expected = './x';
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = './x/./';
  var expected = './x/';
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  /* */

  test.case = 'path with "." in the end';

  var path = 'foo/bar.';
  var expected = 'foo/bar.';
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'foo/.bar.';
  var expected = 'foo/.bar.';
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'foo/bar/.';
  var expected = 'foo/bar';
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'foo/bar/./';
  var expected = 'foo/bar/';
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'foo/bar/./.';
  var expected = 'foo/bar';
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'foo/bar/././';
  var expected = 'foo/bar/';
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '/foo/bar/././';
  var expected = '/foo/bar/';
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '/foo/baz/.x./';
  var expected = '/foo/baz/.x./';
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  /* */

  test.case = 'path with ".." in the middle';

  var path = 'foo/../bar/baz';
  var expected = 'bar/baz';
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'foo/../../bar/baz/';
  var expected = '../bar/baz/';
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'foo/../../bar/../../baz/';
  var expected = '../../baz/';
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '/foo/../../bar/../../baz/';
  var expected = '/../../baz/';
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  /* */

  test.case = 'path with ".." in the beginning';

  var path = '../foo/bar';
  var expected = '../foo/bar';
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '../../foo/bar/';
  var expected = '../../foo/bar/';
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '..//..//foo/bar/';
  var expected = '../../foo/bar/';
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '/..//..//foo/bar/';
  var expected = '/../../foo/bar/';
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '..x/foo/bar';
  var expected = '..x/foo/bar';
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '..x../foo/bar';
  var expected = '..x../foo/bar';
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  /* */

  test.case = 'path with ".." in the end';

  var path = 'foo/bar..';
  var expected = 'foo/bar..';
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'foo/..bar..';
  var expected = 'foo/..bar..';
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'foo/bar/..';
  var expected = 'foo';
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'foo/bar/../../';
  var expected = './';
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'foo/bar/../..';
  var expected = '.';
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '/foo/bar/../../';
  var expected = '/';
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'foo/bar/../../..';
  var expected = '..';
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'foo/bar/../../../..';
  var expected = '../..';
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'foo/../bar/../../../..';
  var expected = '../../..';
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  /* */

  test.case = 'path with ".." and "." combined';

  var path = '/abc/./../a/b';
  var expected = '/a/b';
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '/abc/.././a/b';
  var expected = '/a/b';
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '/abc/./.././a/b';
  var expected = '/a/b';
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '/a/b/abc/../.';
  var expected = '/a/b';
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '/a/b/abc/./..';
  var expected = '/a/b';
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '/a/b/abc/./../.';
  var expected = '/a/b';
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = './../.';
  var expected = '..';
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = './.././';
  var expected = '../';
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = './..';
  var expected = '..';
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '../.';
  var expected = '..';
  var got = _.uriNew.normalizeTolerant( path );
  test.identical( got, expected );
}

//
// //
//
// function refine( test )
// {
//   test.case = 'refine the uri';
//
//   var cases =
//   [
//     { src : '', expected : '' },
//     { src : '.', expected : '.' },
//
//     { src : 'a/', expected : 'a' },
//     { src : 'a//', expected : 'a//' },
//     { src : 'a\\', expected : 'a' },
//     { src : 'a\\\\', expected : 'a//' },
//
//     { src : 'a', expected : 'a' },
//     { src : 'a/b', expected : 'a/b' },
//     { src : 'a\\b', expected : 'a/b' },
//     { src : '\\a\\b\\c', expected : '/a/b/c' },
//     { src : '\\\\a\\\\b\\\\c', expected : '//a//b//c' },
//     { src : '\\', expected : '/' },
//     { src : '\\\\', expected : '//' },
//     { src : '\\\\\\', expected : '///' },
//     { src : '/', expected : '/' },
//     { src : '//', expected : '//' },
//     { src : '///', expected : '///' },
//
//     {
//       src : '/some/staging/index.html',
//       expected : '/some/staging/index.html'
//     },
//     {
//       src : '/some/staging/index.html/',
//       expected : '/some/staging/index.html'
//     },
//     {
//       src : '//some/staging/index.html',
//       expected : '//some/staging/index.html'
//     },
//     {
//       src : '//some/staging/index.html/',
//       expected : '//some/staging/index.html'
//     },
//     {
//       src : '///some/staging/index.html',
//       expected : '///some/staging/index.html'
//     },
//     {
//       src : '///some/staging/index.html/',
//       expected : '///some/staging/index.html'
//     },
//     {
//       src : 'file:///some/staging/index.html',
//       expected : 'file:///some/staging/index.html'
//     },
//     {
//       src : 'file:///some/staging/index.html/',
//       expected : 'file:///some/staging/index.html'
//     },
//     {
//       src : 'http://some.come/staging/index.html',
//       expected : 'http://some.come/staging/index.html'
//     },
//     {
//       src : 'http://some.come/staging/index.html/',
//       expected : 'http://some.come/staging/index.html'
//     },
//     {
//       src : 'svn+https://user@subversion.com/svn/trunk',
//       expected : 'svn+https://user@subversion.com/svn/trunk'
//     },
//     {
//       src : 'svn+https://user@subversion.com/svn/trunk/',
//       expected : 'svn+https://user@subversion.com/svn/trunk'
//     },
//     {
//       src : 'complex+protocol://www.site.com:13/path/name/?query=here&and=here#anchor',
//       expected : 'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor'
//     },
//     {
//       src : 'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor',
//       expected : 'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor'
//     },
//     {
//       src : 'https://web.archive.org/web/*/http://www.heritage.org/index/ranking',
//       expected : 'https://web.archive.org/web/*/http://www.heritage.org/index/ranking'
//     },
//     {
//       src : 'https://web.archive.org//web//*//http://www.heritage.org//index//ranking',
//       expected : 'https://web.archive.org//web//*//http://www.heritage.org//index//ranking'
//     },
//     {
//       src : '://www.site.com:13/path//name//?query=here&and=here#anchor',
//       expected : '://www.site.com:13/path//name//?query=here&and=here#anchor'
//     },
//     {
//       src : ':///www.site.com:13/path//name/?query=here&and=here#anchor',
//       expected : ':///www.site.com:13/path//name?query=here&and=here#anchor'
//     },
//   ]
//
//   for( var i = 0; i < cases.length; i++ )
//   {
//     var c = cases[ i ];
//     if( c.error )
//     test.shouldThrowErrorOfAnyKind( () => _.uriNew.refine( c.src ) );
//     else
//     test.identical( _.uriNew.refine( c.src ), c.expected );
//   }
//
// }

//

function refine( test )
{
  test.case = 'empty uri';
  var src = '';
  var got = _.uriNew.refine( src );
  var exp = '';
  test.identical( got, exp );

  test.case = 'dot uri';
  var src = '.';
  var got = _.uriNew.refine( src );
  var exp = '.';
  test.identical( got, exp );

  test.case = 'uri - simple string';
  var src = 'a';
  var got = _.uriNew.refine( src );
  var exp = 'a';
  test.identical( got, exp );

  test.case = 'uri ends on one slash';
  var src = 'a/';
  var got = _.uriNew.refine( src );
  var exp = 'a/';
  test.identical( got, exp );

  test.case = 'uri ends on double slash';
  var src = 'a//';
  var got = _.uriNew.refine( src );
  var exp = 'a//';
  test.identical( got, exp );

  test.case = 'uri ends on one backslash';
  var src = 'a\\';
  var got = _.uriNew.refine( src );
  var exp = 'a/';
  test.identical( got, exp );

  test.case = 'uri ends on double backslash';
  var src = 'a\\\\';
  var got = _.uriNew.refine( src );
  var exp = 'a//';
  test.identical( got, exp );

  test.case = 'uri has one slash between parts';
  var src = 'a/b';
  var got = _.uriNew.refine( src );
  var exp = 'a/b';
  test.identical( got, exp );

  test.case = 'uri has double slash between parts';
  var src = 'a//b';
  var got = _.uriNew.refine( src );
  var exp = 'a//b';
  test.identical( got, exp );

  test.case = 'uri has one backslash between parts';
  var src = 'a\\b';
  var got = _.uriNew.refine( src );
  var exp = 'a/b';
  test.identical( got, exp );

  test.case = 'uri has double backslash between parts';
  var src = 'a\\\\b';
  var got = _.uriNew.refine( src );
  var exp = 'a//b';
  test.identical( got, exp );

  test.case = 'uri has a few backslash between parts';
  var src = '\\a\\b\\c';
  var got = _.uriNew.refine( src );
  var exp = '/a/b/c';
  test.identical( got, exp );

  test.case = 'uri has a few double backslash between parts';
  var src = '\\\\a\\\\b\\\\c';
  var got = _.uriNew.refine( src );
  var exp = '//a//b//c';
  test.identical( got, exp );

  /* */

  test.case = 'uri - one slash';
  var src = '/';
  var got = _.uriNew.refine( src );
  var exp = '/';
  test.identical( got, exp );

  test.case = 'uri - double slash';
  var src = '//';
  var got = _.uriNew.refine( src );
  var exp = '//';
  test.identical( got, exp );

  test.case = 'uri - triple slash';
  var src = '///';
  var got = _.uriNew.refine( src );
  var exp = '///';
  test.identical( got, exp );

  test.case = 'uri - one backslash';
  var src = '\\';
  var got = _.uriNew.refine( src );
  var exp = '/';
  test.identical( got, exp );

  test.case = 'uri - double backslash';
  var src = '\\\\';
  var got = _.uriNew.refine( src );
  var exp = '//';
  test.identical( got, exp );

  test.case = 'uri - triple backslash';
  var src = '\\\\\\';
  var got = _.uriNew.refine( src );
  var exp = '///';
  test.identical( got, exp );

  /* */

  test.case = 'uri - simple path';
  var src = '/some/staging/index.html';
  var got = _.uriNew.refine( src );
  var exp = '/some/staging/index.html';
  test.identical( got, exp );

  test.case = 'uri - simple path, ends by slash';
  var src = '/some/staging/index.html/';
  var got = _.uriNew.refine( src );
  var exp = '/some/staging/index.html/';
  test.identical( got, exp );

  test.case = 'uri - begins by double slash';
  var src = '//some/staging/index.html';
  var got = _.uriNew.refine( src );
  var exp = '//some/staging/index.html';
  test.identical( got, exp );

  test.case = 'uri - begins by double slash, ends by slash';
  var src = '//some/staging/index.html/';
  var got = _.uriNew.refine( src );
  var exp = '//some/staging/index.html/';
  test.identical( got, exp );

  test.case = 'uri - begins by triple slash';
  var src = '///some/staging/index.html';
  var got = _.uriNew.refine( src );
  var exp = '///some/staging/index.html';
  test.identical( got, exp );

  test.case = 'uri - begins by triple slash, ends by slash';
  var src = '///some/staging/index.html/';
  var got = _.uriNew.refine( src );
  var exp = '///some/staging/index.html/';
  test.identical( got, exp );

  test.case = 'hard drive path';
  var src = 'file:///some/staging/index.html';
  var got = _.uriNew.refine( src );
  var exp = 'file:///some/staging/index.html';
  test.identical( got, exp );

  test.case = 'hard drive path, ends by slash';
  var src = 'file:///some/staging/index.html/';
  var got = _.uriNew.refine( src );
  var exp = 'file:///some/staging/index.html/';
  test.identical( got, exp );

  test.case = 'http path';
  var src = 'http://some/staging/index.html';
  var got = _.uriNew.refine( src );
  var exp = 'http://some/staging/index.html';
  test.identical( got, exp );

  test.case = 'http path, ends by slash';
  var src = 'http://some/staging/index.html/';
  var got = _.uriNew.refine( src );
  var exp = 'http://some/staging/index.html/';
  test.identical( got, exp );

  test.case = 'svn+https path';
  var src = 'svn+https://user@subversion.com/svn/trunk';
  var got = _.uriNew.refine( src );
  var exp = 'svn+https://user@subversion.com/svn/trunk';
  test.identical( got, exp );

  test.case = 'svn+https path, ends by slash';
  var src = 'svn+https://user@subversion.com/svn/trunk/';
  var got = _.uriNew.refine( src );
  var exp = 'svn+https://user@subversion.com/svn/trunk/';
  test.identical( got, exp );

  test.case = 'complex+protocol path';
  var src = 'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor';
  var got = _.uriNew.refine( src );
  var exp = 'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor';
  test.identical( got, exp );

  test.case = 'complex+protocol path, unnecessary slash';
  var src = 'complex+protocol://www.site.com:13/path/name/?query=here&and=here#anchor';
  var got = _.uriNew.refine( src );
  var exp = 'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor';
  test.identical( got, exp );

  test.case = 'a few paths in string';
  var src = 'https://web.archive.org/web/*/http://www.heritage.org/index/ranking';
  var got = _.uriNew.refine( src );
  var exp = 'https://web.archive.org/web/*/http://www.heritage.org/index/ranking';
  test.identical( got, exp );

  test.case = 'a few paths in string';
  var src = 'https://web.archive.org//web//*//http://www.heritage.org//index//ranking';
  var got = _.uriNew.refine( src );
  var exp = 'https://web.archive.org//web//*//http://www.heritage.org//index//ranking';
  test.identical( got, exp );

  test.case = 'path, one slash before query';
  var src = '://www.site.com:13/path//name/?query=here&and=here#anchor';
  var got = _.uriNew.refine( src );
  var exp = '://www.site.com:13/path//name?query=here&and=here#anchor';
  test.identical( got, exp );

  test.case = 'path, a few slash before query';
  var src = '://www.site.com:13/path//name//?query=here&and=here#anchor';
  var got = _.uriNew.refine( src );
  var exp = '://www.site.com:13/path//name/?query=here&and=here#anchor';
  test.identical( got, exp );
}

//

function urisRefine( test )
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
  ];

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
  ];

  var got = _.uriNew.s.refine( srcs );
  test.identical( got, expected );
}

//

function parse( test )
{

  /* */

  test.case = 'query only';
  var src = '?entry:1&format:null';
  var expected =
  {
    'resourcePath' : '',
    'query' : 'entry:1&format:null',
    'longPath' : '',
    'postfixedPath' : '?entry:1&format:null',
    'protocols' : [],
    'full' : '?entry:1&format:null'
  }
  var got = _.uriNew.parse( src );
  test.identical( got, expected );

  /* */

  var expected =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/git@bitbucket.org:someorg/somerepo.git',
    longPath : '/git@bitbucket.org:someorg/somerepo.git',
    postfixedPath : '/git@bitbucket.org:someorg/somerepo.git!tag',
    protocols : [ 'git' ],
    tag : 'tag',
    hostFull : '',
    origin : 'git://',
    full : 'git:///git@bitbucket.org:someorg/somerepo.git!tag'
  }
  var got = _.uriNew.parse( 'git:///git@bitbucket.org:someorg/somerepo.git!tag' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/git@bitbucket.org:someorg/somerepo.git',
    hash : 'hash',
    longPath : '/git@bitbucket.org:someorg/somerepo.git',
    postfixedPath : '/git@bitbucket.org:someorg/somerepo.git#hash',
    protocols : [ 'git' ],
    hostFull : '',
    origin : 'git://',
    full : 'git:///git@bitbucket.org:someorg/somerepo.git#hash'
  }
  var got = _.uriNew.parse( 'git:///git@bitbucket.org:someorg/somerepo.git#hash' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/git@bitbucket.org:someorg/somerepo.git/',
    hash : 'hash',
    longPath : '/git@bitbucket.org:someorg/somerepo.git/',
    postfixedPath : '/git@bitbucket.org:someorg/somerepo.git/#hash',
    protocols : [ 'git' ],
    hostFull : '',
    origin : 'git://',
    full : 'git:///git@bitbucket.org:someorg/somerepo.git/#hash'
  }
  var got = _.uriNew.parse( 'git:///git@bitbucket.org:someorg/somerepo.git/#hash' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/somerepo.git',
    hash : 'hash',
    longPath : '/somerepo.git',
    postfixedPath : '/somerepo.git#hash',
    protocols : [ 'git' ],
    hostFull : '',
    origin : 'git://',
    full : 'git:///somerepo.git#hash'
  }
  var got = _.uriNew.parse( 'git:///somerepo.git#hash' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/somerepo.git/',
    hash : 'hash',
    longPath : '/somerepo.git/',
    postfixedPath : '/somerepo.git/#hash',
    protocols : [ 'git' ],
    hostFull : '',
    origin : 'git://',
    full : 'git:///somerepo.git/#hash'
  }
  var got = _.uriNew.parse( 'git:///somerepo.git/#hash' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/git@bitbucket.org:someorg/somerepo.git/',
    tag : 'tag',
    longPath : '/git@bitbucket.org:someorg/somerepo.git/',
    postfixedPath : '/git@bitbucket.org:someorg/somerepo.git/!tag',
    protocols : [ 'git' ],
    hostFull : '',
    origin : 'git://',
    full : 'git:///git@bitbucket.org:someorg/somerepo.git/!tag'
  }
  var got = _.uriNew.parse( 'git:///git@bitbucket.org:someorg/somerepo.git/!tag' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/somerepo.git/',
    tag : 'tag',
    longPath : '/somerepo.git/',
    postfixedPath : '/somerepo.git/!tag',
    protocols : [ 'git' ],
    hostFull : '',
    origin : 'git://',
    full : 'git:///somerepo.git/!tag'
  }
  var got = _.uriNew.parse( 'git:///somerepo.git/!tag' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/git@bitbucket.org:someorg/somerepo.git',
    hash : 'hash',
    tag : 'tag',
    longPath : '/git@bitbucket.org:someorg/somerepo.git',
    postfixedPath : '/git@bitbucket.org:someorg/somerepo.git#hash!tag',
    protocols : [ 'git' ],
    hostFull : '',
    origin : 'git://',
    full : 'git:///git@bitbucket.org:someorg/somerepo.git#hash!tag'
  }
  var got = _.uriNew.parse( 'git:///git@bitbucket.org:someorg/somerepo.git#hash!tag' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/git@bitbucket.org:someorg/somerepo.git/',
    hash : 'hash',
    tag : 'tag',
    longPath : '/git@bitbucket.org:someorg/somerepo.git/',
    postfixedPath : '/git@bitbucket.org:someorg/somerepo.git/#hash!tag',
    protocols : [ 'git' ],
    hostFull : '',
    origin : 'git://',
    full : 'git:///git@bitbucket.org:someorg/somerepo.git/#hash!tag'
  }
  var got = _.uriNew.parse( 'git:///git@bitbucket.org:someorg/somerepo.git/#hash!tag' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/somerepo.git',
    hash : 'hash',
    tag : 'tag',
    longPath : '/somerepo.git',
    postfixedPath : '/somerepo.git#hash!tag',
    protocols : [ 'git' ],
    hostFull : '',
    origin : 'git://',
    full : 'git:///somerepo.git#hash!tag'
  }
  var got = _.uriNew.parse( 'git:///somerepo.git#hash!tag' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/somerepo.git/',
    hash : 'hash',
    tag : 'tag',
    longPath : '/somerepo.git/',
    postfixedPath : '/somerepo.git/#hash!tag',
    protocols : [ 'git' ],
    hostFull : '',
    origin : 'git://',
    full : 'git:///somerepo.git/#hash!tag'
  }
  var got = _.uriNew.parse( 'git:///somerepo.git/#hash!tag' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/git@bitbucket.org:someorg/somerepo.git',
    query : 'query=1',
    hash : 'hash',
    tag : 'tag',
    longPath : '/git@bitbucket.org:someorg/somerepo.git',
    postfixedPath : '/git@bitbucket.org:someorg/somerepo.git?query=1#hash!tag',
    protocols : [ 'git' ],
    hostFull : '',
    origin : 'git://',
    full : 'git:///git@bitbucket.org:someorg/somerepo.git?query=1#hash!tag'
  }
  var got = _.uriNew.parse( 'git:///git@bitbucket.org:someorg/somerepo.git?query=1#hash!tag' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/git@bitbucket.org:someorg/somerepo.git/',
    query : 'query=1',
    hash : 'hash',
    tag : 'tag',
    longPath : '/git@bitbucket.org:someorg/somerepo.git/',
    postfixedPath : '/git@bitbucket.org:someorg/somerepo.git/?query=1#hash!tag',
    protocols : [ 'git' ],
    hostFull : '',
    origin : 'git://',
    full : 'git:///git@bitbucket.org:someorg/somerepo.git/?query=1#hash!tag'
  }
  var got = _.uriNew.parse( 'git:///git@bitbucket.org:someorg/somerepo.git/?query=1#hash!tag' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/somerepo.git',
    query : 'query=1',
    hash : 'hash',
    tag : 'tag',
    longPath : '/somerepo.git',
    postfixedPath : '/somerepo.git?query=1#hash!tag',
    protocols : [ 'git' ],
    hostFull : '',
    origin : 'git://',
    full : 'git:///somerepo.git?query=1#hash!tag'
  }
  var got = _.uriNew.parse( 'git:///somerepo.git?query=1#hash!tag' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/somerepo.git/',
    query : 'query=1',
    hash : 'hash',
    tag : 'tag',
    longPath : '/somerepo.git/',
    postfixedPath : '/somerepo.git/?query=1#hash!tag',
    protocols : [ 'git' ],
    hostFull : '',
    origin : 'git://',
    full : 'git:///somerepo.git/?query=1#hash!tag'
  }
  var got = _.uriNew.parse( 'git:///somerepo.git/?query=1#hash!tag' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/git@bitbucket.org:someorg/somerepo.git',
    query : 'query=1',
    tag : 'tag',
    longPath : '/git@bitbucket.org:someorg/somerepo.git',
    postfixedPath : '/git@bitbucket.org:someorg/somerepo.git?query=1!tag',
    protocols : [ 'git' ],
    hostFull : '',
    origin : 'git://',
    full : 'git:///git@bitbucket.org:someorg/somerepo.git?query=1!tag'
  }
  var got = _.uriNew.parse( 'git:///git@bitbucket.org:someorg/somerepo.git?query=1!tag' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/git@bitbucket.org:someorg/somerepo.git/',
    query : 'query=1',
    tag : 'tag',
    longPath : '/git@bitbucket.org:someorg/somerepo.git/',
    postfixedPath : '/git@bitbucket.org:someorg/somerepo.git/?query=1!tag',
    protocols : [ 'git' ],
    hostFull : '',
    origin : 'git://',
    full : 'git:///git@bitbucket.org:someorg/somerepo.git/?query=1!tag'
  }
  var got = _.uriNew.parse( 'git:///git@bitbucket.org:someorg/somerepo.git/?query=1!tag' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/somerepo.git',
    query : 'query=1',
    tag : 'tag',
    longPath : '/somerepo.git',
    postfixedPath : '/somerepo.git?query=1!tag',
    protocols : [ 'git' ],
    hostFull : '',
    origin : 'git://',
    full : 'git:///somerepo.git?query=1!tag'
  }
  var got = _.uriNew.parse( 'git:///somerepo.git?query=1!tag' );
  test.identical( got, expected );


  var expected =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/somerepo.git/',
    query : 'query=1',
    tag : 'tag',
    longPath : '/somerepo.git/',
    postfixedPath : '/somerepo.git/?query=1!tag',
    protocols : [ 'git' ],
    hostFull : '',
    origin : 'git://',
    full : 'git:///somerepo.git/?query=1!tag'
  }
  var got = _.uriNew.parse( 'git:///somerepo.git/?query=1!tag' );
  test.identical( got, expected );
}

//

function parseCommon( test )
{

  /* */

  test.case = 'query only';
  var src = '?entry:1&format:null';

  test.description = 'consecutive';
  var expected =
  {
    'longPath' : '',
    'query' : 'entry:1&format:null'
  }
  var got = _.uriNew.parseConsecutive( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'atomic';
  var expected =
  {
    'query' : 'entry:1&format:null',
  }
  var got = _.uriNew.parseAtomic( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'full';
  var expected =
  {
    'query' : 'entry:1&format:null',
    'longPath' : '',
    'postfixedPath' : '?entry:1&format:null',
    'full' : '?entry:1&format:null',
    'protocols' : [],
  }
  var got = _.uriNew.parseFull( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  /* */

  test.case = 'global, relative, with hash, with query';
  var src = 'git://../repo/Tools?out=out/wTools.out.will#master';

  test.description = 'consecutive';
  var expected =
  {
    'protocol' : 'git',
    'longPath' : '../repo/Tools',
    'query' : 'out=out/wTools.out.will',
    'hash' : 'master'
  }
  var got = _.uriNew.parseConsecutive( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'atomic';
  var expected =
  {
    'protocol' : 'git',
    'query' : 'out=out/wTools.out.will',
    'hash' : 'master',
    'resourcePath' : 'repo/Tools',
    'host' : '..',
  }
  var got = _.uriNew.parseAtomic( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'full';
  var expected =
  {
    'protocol' : 'git',
    'longPath' : '../repo/Tools',
    'query' : 'out=out/wTools.out.will',
    'hash' : 'master',
    'postfixedPath' : '../repo/Tools?out=out/wTools.out.will#master',
    'hostFull' : '..',
    'resourcePath' : 'repo/Tools',
    'host' : '..',
    'protocols' : [ 'git' ],
    'origin' : 'git://..',
    'full' : 'git://../repo/Tools?out=out/wTools.out.will#master',
  }
  var got = _.uriNew.parseFull( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  /* */

  test.case = 'global, absolute, with hash, with query';
  var src = 'git:///../repo/Tools?out=out/wTools.out.will#master'

  test.description = 'consecutive';
  var expected =
  {
    'protocol' : 'git',
    'longPath' : '/../repo/Tools',
    'query' : 'out=out/wTools.out.will',
    'hash' : 'master'
  }
  var got = _.uriNew.parseConsecutive( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'atomic';
  var expected =
  {
    'protocol' : 'git',
    'host' : '/..',
    'resourcePath' : 'repo/Tools',
    'query' : 'out=out/wTools.out.will',
    'hash' : 'master',
  }
  var got = _.uriNew.parseAtomic( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'full';
  var expected =
  {
    'protocol' : 'git',
    'host' : '/..',
    'resourcePath' : 'repo/Tools',
    'query' : 'out=out/wTools.out.will',
    'hash' : 'master',
    'longPath' : '/../repo/Tools',
    'postfixedPath' : '/../repo/Tools?out=out/wTools.out.will#master',
    'protocols' : [ 'git' ],
    'hostFull' : '/..',
    'origin' : 'git:///..',
    'full' : 'git:///../repo/Tools?out=out/wTools.out.will#master'
  }
  var got = _.uriNew.parseFull( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  /* */

  test.case = 'query with equal. relative';
  var src = 'http://127.0.0.1:5000/a/b?q=3#anch';

  test.description = 'consecutive';
  var expected =
  {
    'protocol' : 'http',
    'longPath' : '127.0.0.1:5000/a/b',
    'query' : 'q=3',
    'hash' : 'anch'
  }
  var got = _.uriNew.parseConsecutive( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'atomic';
  var expected =
  {
    'protocol' : 'http',
    'host' : '127.0.0.1',
    'port' : 5000,
    'resourcePath' : 'a/b',
    'query' : 'q=3',
    'hash' : 'anch',
  }
  var got = _.uriNew.parseAtomic( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'full';
  var expected =
  {
    'protocol' : 'http',
    'host' : '127.0.0.1',
    'port' : 5000,
    'resourcePath' : 'a/b',
    'query' : 'q=3',
    'hash' : 'anch',
    'longPath' : '127.0.0.1:5000/a/b',
    'postfixedPath' : '127.0.0.1:5000/a/b?q=3#anch',
    'protocols' : [ 'http' ],
    'hostFull' : '127.0.0.1:5000',
    'origin' : 'http://127.0.0.1:5000',
    'full' : 'http://127.0.0.1:5000/a/b?q=3#anch'
  }
  var got = _.uriNew.parseFull( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  /* */

  test.case = 'query with equal. absolute';
  var src = 'http:///127.0.0.1:5000/a/b?q=3#anch';

  test.description = 'consecutive';
  var expected =
  {
    'protocol' : 'http',
    'longPath' : '/127.0.0.1:5000/a/b',
    'query' : 'q=3',
    'hash' : 'anch'
  }
  var got = _.uriNew.parseConsecutive( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'atomic';
  var expected =
  {
    'protocol' : 'http',
    'host' : '/127.0.0.1',
    'port' : 5000,
    'resourcePath' : 'a/b',
    'query' : 'q=3',
    'hash' : 'anch',
  }
  var got = _.uriNew.parseAtomic( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'full';
  var expected =
  {
    'protocol' : 'http',
    'host' : '/127.0.0.1',
    'port' : 5000,
    'resourcePath' : 'a/b',
    'query' : 'q=3',
    'hash' : 'anch',
    'longPath' : '/127.0.0.1:5000/a/b',
    'postfixedPath' : '/127.0.0.1:5000/a/b?q=3#anch',
    'protocols' : [ 'http' ],
    'hostFull' : '/127.0.0.1:5000',
    'origin' : 'http:///127.0.0.1:5000',
    'full' : 'http:///127.0.0.1:5000/a/b?q=3#anch'
  }
  var got = _.uriNew.parseFull( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  /* */

  test.case = 'query with colon. relative';
  var src = 'http://127.0.0.1:5000/a/b?q:3#anch';
  test.description = 'consecutive';

  var expected =
  {
    'protocol' : 'http',
    'longPath' : '127.0.0.1:5000/a/b',
    'query' : 'q:3',
    'hash' : 'anch'
  }
  var got = _.uriNew.parseConsecutive( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'atomic';
  var expected =
  {
    'protocol' : 'http',
    'host' : '127.0.0.1',
    'port' : 5000,
    'resourcePath' : 'a/b',
    'query' : 'q:3',
    'hash' : 'anch',
  }
  var got = _.uriNew.parseAtomic( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'full';
  var expected =
  {
    'protocol' : 'http',
    'host' : '127.0.0.1',
    'port' : 5000,
    'resourcePath' : 'a/b',
    'query' : 'q:3',
    'hash' : 'anch',
    'longPath' : '127.0.0.1:5000/a/b',
    'postfixedPath' : '127.0.0.1:5000/a/b?q:3#anch',
    'protocols' : [ 'http' ],
    'hostFull' : '127.0.0.1:5000',
    'origin' : 'http://127.0.0.1:5000',
    'full' : 'http://127.0.0.1:5000/a/b?q:3#anch'
  }
  var got = _.uriNew.parseFull( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  /* */

  test.case = 'query with colon. absolute';
  var src = 'http:///127.0.0.1:5000/a/b?q:3#anch';
  test.description = 'consecutive';

  var expected =
  {
    'protocol' : 'http',
    'longPath' : '/127.0.0.1:5000/a/b',
    'query' : 'q:3',
    'hash' : 'anch'
  }
  var got = _.uriNew.parseConsecutive( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'atomic';
  var expected =
  {
    'protocol' : 'http',
    'host' : '/127.0.0.1',
    'port' : 5000,
    'resourcePath' : 'a/b',
    'query' : 'q:3',
    'hash' : 'anch',
  }
  var got = _.uriNew.parseAtomic( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'full';
  var expected =
  {
    'protocol' : 'http',
    'host' : '/127.0.0.1',
    'port' : 5000,
    'resourcePath' : 'a/b',
    'query' : 'q:3',
    'hash' : 'anch',
    'longPath' : '/127.0.0.1:5000/a/b',
    'postfixedPath' : '/127.0.0.1:5000/a/b?q:3#anch',
    'protocols' : [ 'http' ],
    'hostFull' : '/127.0.0.1:5000',
    'origin' : 'http:///127.0.0.1:5000',
    'full' : 'http:///127.0.0.1:5000/a/b?q:3#anch'
  }
  var got = _.uriNew.parseFull( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  /* */

  test.case = 'no protocol';
  var src = '127.0.0.1:61726/../path';
  test.description = 'consecutive';

  var expected =
  {
    longPath : '127.0.0.1:61726/../path',
  }
  var got = _.uriNew.parseConsecutive( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'atomic';
  var expected =
  {
    'resourcePath' : '../path',
    'host' : '127.0.0.1',
    'port' : 61726,
  }
  var got = _.uriNew.parseAtomic( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'full';
  var expected =
  {
    'longPath' : '127.0.0.1:61726/../path',
    'postfixedPath' : '127.0.0.1:61726/../path',
    'hostFull' : '127.0.0.1:61726',
    'resourcePath' : '../path',
    'host' : '127.0.0.1',
    'port' : 61726,
    'full' : '127.0.0.1:61726/../path',
    'protocols' : [],
  }
  var got = _.uriNew.parseFull( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  /* */

  test.case = 'full uri with all components';
  var src = 'http://www.site.com:13/path/name?query=here&and=here#anchor';
  test.description = 'consecutive';

  var expected =
  {
    protocol : 'http',
    longPath : 'www.site.com:13/path/name',
    query : 'query=here&and=here',
    hash : 'anchor',
  }
  var got = _.uriNew.parseConsecutive( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'atomic';
  var expected =
  {
    protocol : 'http',
    query : 'query=here&and=here',
    hash : 'anchor',
    resourcePath : 'path/name',
    host : 'www.site.com',
    port : 13,
  }
  var got = _.uriNew.parseAtomic( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'full';
  var expected =
  {
    protocol : 'http',
    longPath : 'www.site.com:13/path/name',
    query : 'query=here&and=here',
    hash : 'anchor',
    postfixedPath : 'www.site.com:13/path/name?query=here&and=here#anchor',
    hostFull : 'www.site.com:13',
    resourcePath : 'path/name',
    host : 'www.site.com',
    port : 13,
    protocols : [ 'http' ],
    origin : 'http://www.site.com:13',
    full : 'http://www.site.com:13/path/name?query=here&and=here#anchor'
  }
  var got = _.uriNew.parseFull( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  /* */

  test.case = 'full uri with all components, primitiveOnly';
  var src = 'http://www.site.com:13/path/name?query=here&and=here#anchor';
  test.description = 'consecutive';

  var expected =
  {
    protocol : 'http',
    longPath : 'www.site.com:13/path/name',
    query : 'query=here&and=here',
    hash : 'anchor',
  }

  var got = _.uriNew.parseConsecutive( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'atomic';
  var expected =
  {
    protocol : 'http',
    query : 'query=here&and=here',
    hash : 'anchor',
    resourcePath : 'path/name',
    host : 'www.site.com',
    port : 13,
  }
  var got = _.uriNew.parseAtomic( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'full';
  var expected =
  {
    protocol : 'http',
    longPath : 'www.site.com:13/path/name',
    query : 'query=here&and=here',
    hash : 'anchor',
    postfixedPath : 'www.site.com:13/path/name?query=here&and=here#anchor',
    hostFull : 'www.site.com:13',
    resourcePath : 'path/name',
    host : 'www.site.com',
    port : 13,
    protocols : [ 'http' ],
    origin : 'http://www.site.com:13',
    full : 'http://www.site.com:13/path/name?query=here&and=here#anchor'
  }
  var got = _.uriNew.parseFull( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  /* */

  test.case = 'reparse with non primitives';

  test.description = 'consecutive';
  var got = _.uriNew.parseConsecutive( 'http://www.site.com:13/path/name?query=here&and=here#anchor' );
  var expected =
  {
    protocol : 'http',
    longPath : 'www.site.com:13/path/name',
    query : 'query=here&and=here',
    hash : 'anchor',
  }
  var parsed = got;
  var got = _.uriNew.parseConsecutive( parsed );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'atomic';
  var expected =
  {
    protocol : 'http',
    query : 'query=here&and=here',
    hash : 'anchor',
    resourcePath : 'path/name',
    host : 'www.site.com',
    port : 13,
  }
  var got = _.uriNew.parseAtomic( src );
  var parsed = got;
  var got = _.uriNew.parseAtomic( parsed );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'full';
  var got = _.uriNew.parseFull( 'http://www.site.com:13/path/name?query=here&and=here#anchor' )
  var expected =
  {
    protocol : 'http',
    longPath : 'www.site.com:13/path/name',
    query : 'query=here&and=here',
    hash : 'anchor',
    postfixedPath : 'www.site.com:13/path/name?query=here&and=here#anchor',
    hostFull : 'www.site.com:13',
    resourcePath : 'path/name',
    host : 'www.site.com',
    port : 13,
    protocols : [ 'http' ],
    origin : 'http://www.site.com:13',
    full : 'http://www.site.com:13/path/name?query=here&and=here#anchor'
  }
  var parsed = got;
  var got = _.uriNew.parseFull( parsed );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  /* */

  test.case = 'reparse with primitives';
  var src = 'http://www.site.com:13/path/name?query=here&and=here#anchor';

  test.description = 'consecutive';
  var expected =
  {
    protocol : 'http',
    longPath : 'www.site.com:13/path/name',
    query : 'query=here&and=here',
    hash : 'anchor',
  }

  var got = _.uriNew.parseConsecutive( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'atomic';
  var expected =
  {
    protocol : 'http',
    query : 'query=here&and=here',
    hash : 'anchor',
    resourcePath : 'path/name',
    host : 'www.site.com',
    port : 13,
  }
  var got = _.uriNew.parseAtomic( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'full';
  var expected =
  {
    protocol : 'http',
    longPath : 'www.site.com:13/path/name',
    query : 'query=here&and=here',
    hash : 'anchor',
    postfixedPath : 'www.site.com:13/path/name?query=here&and=here#anchor',
    hostFull : 'www.site.com:13',
    resourcePath : 'path/name',
    host : 'www.site.com',
    port : 13,
    protocols : [ 'http' ],
    origin : 'http://www.site.com:13',
    full : 'http://www.site.com:13/path/name?query=here&and=here#anchor'
  }
  var got = _.uriNew.parseFull( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  /* */

  test.case = 'uri with zero length protocol';
  var src = '://some.domain.com/something/filePath/add';

  test.description = 'consecutive';
  var expected =
  {
    protocol : '',
    longPath : 'some.domain.com/something/filePath/add',
  }
  var got = _.uriNew.parseConsecutive( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'atomic';
  var expected =
  {
    protocol : '',
    resourcePath : 'something/filePath/add',
    host : 'some.domain.com',
  }
  var got = _.uriNew.parseAtomic( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'full';
  var expected =
  {
    protocol : '',
    longPath : 'some.domain.com/something/filePath/add',
    postfixedPath : 'some.domain.com/something/filePath/add',
    hostFull : 'some.domain.com',
    resourcePath : 'something/filePath/add',
    host : 'some.domain.com',
    origin : '://some.domain.com',
    full : '://some.domain.com/something/filePath/add',
    protocols : [],
  }
  var got = _.uriNew.parseFull( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  /* */

  test.case = 'uri with zero length hostFull';
  var src = 'file:///something/filePath/add';

  test.description = 'consecutive';
  var expected =
  {
    protocol : 'file',
    longPath : '/something/filePath/add',
  }
  var got = _.uriNew.parseConsecutive( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'atomic';
  var expected =
  {
    protocol : 'file',
    host : '/something',
    resourcePath : 'filePath/add'
  }
  var got = _.uriNew.parseAtomic( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'full';
  var expected =
  {
    protocol : 'file',
    longPath : '/something/filePath/add',
    postfixedPath : '/something/filePath/add',
    hostFull : '/something',
    resourcePath : 'filePath/add',
    host : '/something',
    protocols : [ 'file' ],
    origin : 'file:///something',
    full : 'file:///something/filePath/add'
  }
  var got = _.uriNew.parseFull( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  /* */

  test.case = 'uri with double protocol, user';
  var src = 'svn+https://user@subversion.com:13/svn/trunk';

  test.description = 'consecutive';
  var expected =
  {
    protocol : 'svn+https',
    longPath : 'user@subversion.com:13/svn/trunk',
  }
  var got = _.uriNew.parseConsecutive( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'atomic';
  var expected =
  {
    protocol : 'svn+https',
    host : 'subversion.com',
    port : 13,
    user : 'user',
    resourcePath : 'svn/trunk'
  }
  var got = _.uriNew.parseAtomic( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'full';
  var expected =
  {
    protocol : 'svn+https',
    host : 'subversion.com',
    port : 13,
    user : 'user',
    hostFull : 'user@subversion.com:13',
    longPath : 'user@subversion.com:13/svn/trunk',
    protocols : [ 'svn', 'https' ],
    origin : 'svn+https://user@subversion.com:13',
    postfixedPath : 'user@subversion.com:13/svn/trunk',
    resourcePath : 'svn/trunk',
    full : 'svn+https://user@subversion.com:13/svn/trunk',
  }
  var got = _.uriNew.parseFull( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  /* */

  test.case = 'uri with double protocol, user and tag';
  var src = 'svn+https://user@subversion.com:13/svn/trunk!tag1';

  test.description = 'consecutive';
  var expected =
  {
    protocol : 'svn+https',
    longPath : 'user@subversion.com:13/svn/trunk',
    tag : 'tag1',
  }
  var got = _.uriNew.parseConsecutive( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'atomic';
  var expected =
  {
    'protocol' : 'svn+https',
    'tag' : 'tag1',
    'resourcePath' : 'svn/trunk',
    'host' : 'subversion.com',
    'port' : 13,
    'user' : 'user'
  }
  var got = _.uriNew.parseAtomic( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'full';
  var expected =
  {
    protocol : 'svn+https',
    host : 'subversion.com',
    user : 'user',
    port : 13,
    hostFull : 'user@subversion.com:13',
    longPath : 'user@subversion.com:13/svn/trunk',
    tag : 'tag1',
    protocols : [ 'svn', 'https' ],
    origin : 'svn+https://user@subversion.com:13',
    postfixedPath : 'user@subversion.com:13/svn/trunk!tag1',
    resourcePath : 'svn/trunk',
    full : 'svn+https://user@subversion.com:13/svn/trunk!tag1',
  }
  var got = _.uriNew.parseFull( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  /* */

  test.case = 'simple path';
  var src = '/some/file';

  test.description = 'consecutive';
  var expected =
  {
    longPath : '/some/file',
  }
  var got = _.uriNew.parseConsecutive( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'atomic';
  var expected =
  {
    'resourcePath' : 'file', 'host' : '/some'
  }
  var got = _.uriNew.parseAtomic( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'full';
  var expected =
  {
    longPath : '/some/file',
    postfixedPath : '/some/file',
    hostFull : '/some',
    resourcePath : 'file',
    host : '/some',
    full : '/some/file',
    protocols : [],
  }
  var got = _.uriNew.parseFull( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  /* */

  test.case = 'without ":"';
  var src = '//some.domain.com/was';

  test.description = 'consecutive';
  var expected =
  {
    longPath : '//some.domain.com/was',
  }
  var got = _.uriNew.parseConsecutive( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'atomic';
  var expected =
  {
    'resourcePath' : 'some.domain.com/was', 'host' : '/'
  }
  var got = _.uriNew.parseAtomic( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'full';
  var expected =
  {
    longPath : '//some.domain.com/was',
    postfixedPath : '//some.domain.com/was',
    host : '/',
    hostFull : '/',
    resourcePath : 'some.domain.com/was',
    full : '//some.domain.com/was',
    protocols : [],
  }
  var got = _.uriNew.parseFull( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  /* */

  test.case = 'with ":"';
  var src = '://some.domain.com/was';

  test.description = 'consecutive';
  var expected =
  {
    protocol : '',
    longPath : 'some.domain.com/was',
  }
  var got = _.uriNew.parseConsecutive( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'atomic';
  var expected =
  {
    'protocol' : '', 'resourcePath' : 'was', 'host' : 'some.domain.com'
  }
  var got = _.uriNew.parseAtomic( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'full';
  var expected =
  {
    protocol : '',
    longPath : 'some.domain.com/was',
    postfixedPath : 'some.domain.com/was',
    hostFull : 'some.domain.com',
    resourcePath : 'was',
    host : 'some.domain.com',
    origin : '://some.domain.com',
    full : '://some.domain.com/was',
    protocols : [],
  }
  var got = _.uriNew.parseFull( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  /* */

  test.case = 'with ":" and protocol';
  var src = 'protocol://some.domain.com/was';

  test.description = 'consecutive';
  var expected =
  {
    protocol : 'protocol',
    longPath : 'some.domain.com/was',
  }
  var got = _.uriNew.parseConsecutive( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'atomic';
  var expected =
  {
    'protocol' : 'protocol', 'resourcePath' : 'was', 'host' : 'some.domain.com'
  }
  var got = _.uriNew.parseAtomic( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'full';
  var expected =
  {
    protocol : 'protocol',
    longPath : 'some.domain.com/was',
    postfixedPath : 'some.domain.com/was',
    hostFull : 'some.domain.com',
    resourcePath : 'was',
    host : 'some.domain.com',
    protocols : [ 'protocol' ],
    origin : 'protocol://some.domain.com',
    full : 'protocol://some.domain.com/was'
  }
  var got = _.uriNew.parseFull( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  /* */

  test.case = 'double slash';
  var src = '//';

  test.description = 'consecutive';
  var expected =
  {
    longPath : '//',
  }
  var got = _.uriNew.parseConsecutive( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'atomic';
  var expected =
  {
    'resourcePath' : '',
    'host' : '/',
  }
  var got = _.uriNew.parseAtomic( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'full';
  var expected =
  {
    longPath : '//',
    postfixedPath : '//',
    host : '/',
    hostFull : '/',
    resourcePath : '',
    full : '//',
    protocols : [],
  }
  var got = _.uriNew.parseFull( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  /* */

  test.case = 'triple slash';
  var src = '///';

  test.description = 'consecutive';
  var expected =
  {
    longPath : '///',
  }
  var got = _.uriNew.parseConsecutive( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'atomic';
  var expected =
  {
    'resourcePath' : '/',
    'host' : '/',
  };
  debugger;
  var got = _.uriNew.parseAtomic( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'full';
  var expected =
  {
    longPath : '///',
    postfixedPath : '///',
    host : '/',
    hostFull : '/',
    resourcePath : '/',
    full : '///',
    protocols : [],
  }
  var got = _.uriNew.parseFull( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  /* */

  test.case = 'triple slash with long path';
  var src = '///a/b/c';

  test.description = 'consecutive';
  var expected =
  {
    longPath : '///a/b/c',
  }
  var got = _.uriNew.parseConsecutive( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'atomic';
  var expected =
  {
    'resourcePath' : '/a/b/c',
    'host' : '/'
  }
  var got = _.uriNew.parseAtomic( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'full';
  var expected =
  {
    longPath : '///a/b/c',
    postfixedPath : '///a/b/c',
    host : '/',
    hostFull : '/',
    resourcePath : '/a/b/c',
    full : '///a/b/c',
    protocols : [],
  }
  var got = _.uriNew.parseFull( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  /* */

  test.case = 'double protocol, query and hash';
  var src = 'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor';

  test.description = 'consecutive';
  var expected =
  {
    protocol : 'complex+protocol',
    longPath : 'www.site.com:13/path/name',
    query : 'query=here&and=here',
    hash : 'anchor',
  }
  var got = _.uriNew.parseConsecutive( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'atomic';
  var expected =
  {
    'protocol' : 'complex+protocol',
    'query' : 'query=here&and=here',
    'hash' : 'anchor',
    'resourcePath' : 'path/name',
    'host' : 'www.site.com',
    'port' : 13
  }
  var got = _.uriNew.parseAtomic( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'full';
  var expected =
  {
    protocol : 'complex+protocol',
    longPath : 'www.site.com:13/path/name',
    query : 'query=here&and=here',
    hash : 'anchor',
    postfixedPath : 'www.site.com:13/path/name?query=here&and=here#anchor',
    hostFull : 'www.site.com:13',
    resourcePath : 'path/name',
    host : 'www.site.com',
    port : 13,
    protocols : [ 'complex', 'protocol' ],
    origin : 'complex+protocol://www.site.com:13',
    full : 'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor'
  }
  var got = _.uriNew.parseFull( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  /* */

  test.case = 'colon, double slash';
  var src = '://www.site.com:13/path//name//?query=here&and=here#anchor';

  test.description = 'consecutive';
  var got = _.uriNew.parseConsecutive( src );
  var expected =
  {
    protocol : '',
    longPath : 'www.site.com:13/path//name//',
    query : 'query=here&and=here',
    hash : 'anchor',
  }
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'atomic';
  var expected =
  {
    'protocol' : '',
    'query' : 'query=here&and=here',
    'hash' : 'anchor',
    'resourcePath' : 'path//name//',
    'host' : 'www.site.com',
    'port' : 13
  }
  var got = _.uriNew.parseAtomic( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'full';
  var expected =
  {
    protocol : '',
    longPath : 'www.site.com:13/path//name//',
    query : 'query=here&and=here',
    hash : 'anchor',
    postfixedPath : 'www.site.com:13/path//name//?query=here&and=here#anchor',
    hostFull : 'www.site.com:13',
    resourcePath : 'path//name//',
    host : 'www.site.com',
    port : 13,
    origin : '://www.site.com:13',
    full : '://www.site.com:13/path//name//?query=here&and=here#anchor',
    protocols : [],
  }
  var got = _.uriNew.parseFull( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  /* */

  test.case = 'colon, triple slash';
  var src = ':///www.site.com:13/path//name//?query=here&and=here#anchor';

  test.description = 'consecutive';
  var got = _.uriNew.parseConsecutive( src );
  var expected =
  {
    protocol : '',
    longPath : '/www.site.com:13/path//name//',
    query : 'query=here&and=here',
    hash : 'anchor',
  }
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'atomic';
  var expected =
  {
    'protocol' : '',
    'query' : 'query=here&and=here',
    'hash' : 'anchor',
    'resourcePath' : 'path//name//',
    'host' : '/www.site.com',
    'port' : 13
  }
  var got = _.uriNew.parseAtomic( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'full';
  var expected =
  {
    protocol : '',
    longPath : '/www.site.com:13/path//name//',
    query : 'query=here&and=here',
    hash : 'anchor',
    postfixedPath : '/www.site.com:13/path//name//?query=here&and=here#anchor',
    hostFull : '/www.site.com:13',
    resourcePath : 'path//name//',
    host : '/www.site.com',
    port : 13,
    origin : ':///www.site.com:13',
    full : ':///www.site.com:13/path//name//?query=here&and=here#anchor',
    protocols : [],
  }
  var got = _.uriNew.parseFull( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  /* */

  test.case = 'not ://, but //';
  var src = '///some.com:99/staging/index.html?query=here&and=here#anchor';

  test.description = 'consecutive';
  var expected =
  {
    longPath : '///some.com:99/staging/index.html',
    query : 'query=here&and=here',
    hash : 'anchor',
  }
  var got = _.uriNew.parseConsecutive( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'atomic';
  var expected =
  {
    'query' : 'query=here&and=here',
    'hash' : 'anchor',
    'resourcePath' : '/some.com:99/staging/index.html',
    'host' : '/'
  }
  var got = _.uriNew.parseAtomic( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'full';
  var expected =
  {
    longPath : '///some.com:99/staging/index.html',
    query : 'query=here&and=here',
    hash : 'anchor',
    postfixedPath : '///some.com:99/staging/index.html?query=here&and=here#anchor',
    host : '/',
    hostFull : '/',
    resourcePath : '/some.com:99/staging/index.html',
    full : '///some.com:99/staging/index.html?query=here&and=here#anchor',
    protocols : [],
  }
  var got = _.uriNew.parseFull( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  /* */

  test.case = 'tag and user';
  var src = 'git://git@bitbucket.org:someorg/somerepo.git!tag';

  test.description = 'consecutive';
  var expected =
  {
    longPath : 'git@bitbucket.org:someorg/somerepo.git',
    tag : 'tag',
    protocol : 'git',
  }
  var got = _.uriNew.parseConsecutive( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'atomic';
  var expected =
  {
    'protocol' : 'git',
    'tag' : 'tag',
    'resourcePath' : 'somerepo.git',
    'host' : 'bitbucket.org',
    'port' : 'someorg',
    'user' : 'git'
  }
  var got = _.uriNew.parseAtomic( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'full';
  var expected =
  {
    protocol : 'git',
    longPath : 'git@bitbucket.org:someorg/somerepo.git',
    tag : 'tag',
    postfixedPath : 'git@bitbucket.org:someorg/somerepo.git!tag',
    hostFull : 'git@bitbucket.org:someorg',
    resourcePath : 'somerepo.git',
    host : 'bitbucket.org',
    port : 'someorg',
    user : 'git',
    protocols : [ 'git' ],
    origin : 'git://git@bitbucket.org:someorg',
    full : 'git://git@bitbucket.org:someorg/somerepo.git!tag'
  }
  var got = _.uriNew.parseFull( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  /* */

  test.case = 'hash and user';
  var src = 'git://git@bitbucket.org:someorg/somerepo.git#hash';

  test.description = 'consecutive';
  var expected =
  {
    longPath : 'git@bitbucket.org:someorg/somerepo.git',
    hash : 'hash',
    protocol : 'git',
  }
  var got = _.uriNew.parseConsecutive( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'atomic';
  var expected =
  {
    'protocol' : 'git',
    'hash' : 'hash',
    'resourcePath' : 'somerepo.git',
    'host' : 'bitbucket.org',
    'port' : 'someorg',
    'user' : 'git'
  }
  var got = _.uriNew.parseAtomic( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'full';
  var expected =
  {
    protocol : 'git',
    longPath : 'git@bitbucket.org:someorg/somerepo.git',
    hash : 'hash',
    postfixedPath : 'git@bitbucket.org:someorg/somerepo.git#hash',
    hostFull : 'git@bitbucket.org:someorg',
    resourcePath : 'somerepo.git',
    host : 'bitbucket.org',
    port : 'someorg',
    user : 'git',
    protocols : [ 'git' ],
    origin : 'git://git@bitbucket.org:someorg',
    full : 'git://git@bitbucket.org:someorg/somerepo.git#hash'
  }
  var got = _.uriNew.parseFull( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  /* */

  test.case = 'absolute, user and tag';
  var src = 'git:///git@bitbucket.org:someorg/somerepo.git!tag';

  test.description = 'consecutive';
  var expected =
  {
    longPath : '/git@bitbucket.org:someorg/somerepo.git',
    tag : 'tag',
    protocol : 'git',
  }
  var got = _.uriNew.parseConsecutive( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'atomic';
  var expected =
  {
    'protocol' : 'git',
    'tag' : 'tag',
    'resourcePath' : 'somerepo.git',
    'host' : '/bitbucket.org',
    'port' : 'someorg',
    'user' : 'git'
  }
  var got = _.uriNew.parseAtomic( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'full';
  var expected =
  {
    protocol : 'git',
    longPath : '/git@bitbucket.org:someorg/somerepo.git',
    tag : 'tag',
    postfixedPath : '/git@bitbucket.org:someorg/somerepo.git!tag',
    hostFull : '/git@bitbucket.org:someorg',
    resourcePath : 'somerepo.git',
    host : '/bitbucket.org',
    port : 'someorg',
    user : 'git',
    protocols : [ 'git' ],
    origin : 'git:///git@bitbucket.org:someorg',
    full : 'git:///git@bitbucket.org:someorg/somerepo.git!tag'
  }
  var got = _.uriNew.parseFull( src );
  test.identical( got, expected );
  var str = _.uriNew.str( expected );
  test.identical( str, src );

  /* */

  test.case = 'absolute, user and hash';
  var src = 'git:///git@bitbucket.org:someorg/somerepo.git#hash';

  test.description = 'consecutive';
  var expected =
  {
    longPath : '/git@bitbucket.org:someorg/somerepo.git',
    hash : 'hash',
    protocol : 'git',
  }
  var got = _.uriNew.parseConsecutive( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'atomic';
  var expected =
  {
    'protocol' : 'git',
    'hash' : 'hash',
    'resourcePath' : 'somerepo.git',
    'host' : '/bitbucket.org',
    'port' : 'someorg',
    'user' : 'git'
  }
  var got = _.uriNew.parseAtomic( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'full';
  var expected =
  {
    protocol : 'git',
    longPath : '/git@bitbucket.org:someorg/somerepo.git',
    hash : 'hash',
    postfixedPath : '/git@bitbucket.org:someorg/somerepo.git#hash',
    hostFull : '/git@bitbucket.org:someorg',
    resourcePath : 'somerepo.git',
    host : '/bitbucket.org',
    port : 'someorg',
    user : 'git',
    protocols : [ 'git' ],
    origin : 'git:///git@bitbucket.org:someorg',
    full : 'git:///git@bitbucket.org:someorg/somerepo.git#hash'
  }
  var got = _.uriNew.parseFull( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  /* */

  test.case = 'protocol, colon, triple slash';
  var src = 'git:///git@bitbucket.org';

  test.description = 'consecutive';
  var expected =
  {
    longPath : '/git@bitbucket.org',
    protocol : 'git',
  }
  var got = _.uriNew.parseConsecutive( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'atomic';
  var expected =
  {
    'protocol' : 'git',
    'host' : '/bitbucket.org',
    'user' : 'git'
  }
  var got = _.uriNew.parseAtomic( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'full';
  var expected =
  {
    protocol : 'git',
    longPath : '/git@bitbucket.org',
    postfixedPath : '/git@bitbucket.org',
    hostFull : '/git@bitbucket.org',
    host : '/bitbucket.org',
    user : 'git',
    protocols : [ 'git' ],
    origin : 'git:///git@bitbucket.org',
    full : 'git:///git@bitbucket.org'
  }
  var got = _.uriNew.parseFull( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  /* */

  test.case = 'protocol, colon, triple slash, tag';
  var src = 'git:///git@bitbucket.org!tag';

  test.description = 'consecutive';
  var expected =
  {
    longPath : '/git@bitbucket.org',
    tag : 'tag',
    protocol : 'git',
  }
  var got = _.uriNew.parseConsecutive( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'atomic';
  var expected =
  {
    'protocol' : 'git',
    'tag' : 'tag',
    'host' : '/bitbucket.org',
    'user' : 'git'
  }
  var got = _.uriNew.parseAtomic( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'full';
  var expected =
  {
    protocol : 'git',
    longPath : '/git@bitbucket.org',
    tag : 'tag',
    postfixedPath : '/git@bitbucket.org!tag',
    hostFull : '/git@bitbucket.org',
    host : '/bitbucket.org',
    user : 'git',
    protocols : [ 'git' ],
    origin : 'git:///git@bitbucket.org',
    full : 'git:///git@bitbucket.org!tag'
  }
  var got = _.uriNew.parseFull( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  /* */

  test.case = 'longpath with dot after host, tag';
  var src = 'git:///git@bitbucket.org/somerepo.git!tag';

  test.description = 'consecutive';
  var expected =
  {
    longPath : '/git@bitbucket.org/somerepo.git',
    tag : 'tag',
    protocol : 'git',
  }
  var got = _.uriNew.parseConsecutive( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'atomic';
  var expected =
  {
    'protocol' : 'git',
    'tag' : 'tag',
    'resourcePath' : 'somerepo.git',
    'host' : '/bitbucket.org',
    'user' : 'git',
  }
  var got = _.uriNew.parseAtomic( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'full';
  var expected =
  {
    protocol : 'git',
    longPath : '/git@bitbucket.org/somerepo.git',
    tag : 'tag',
    postfixedPath : '/git@bitbucket.org/somerepo.git!tag',
    hostFull : '/git@bitbucket.org',
    resourcePath : 'somerepo.git',
    host : '/bitbucket.org',
    user : 'git',
    protocols : [ 'git' ],
    origin : 'git:///git@bitbucket.org',
    full : 'git:///git@bitbucket.org/somerepo.git!tag'
  }
  var got = _.uriNew.parseFull( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  /* */

  test.case = 'longpath with dot after host, user, tag';
  var src = 'git:///git@bitbucket.org:someorg/somerepo.git!tag';

  test.description = 'consecutive';
  var expected =
  {
    longPath : '/git@bitbucket.org:someorg/somerepo.git',
    tag : 'tag',
    protocol : 'git',
  }
  var got = _.uriNew.parseConsecutive( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'atomic';
  var expected =
  {
    'protocol' : 'git',
    'tag' : 'tag',
    'resourcePath' : 'somerepo.git',
    'host' : '/bitbucket.org',
    'port' : 'someorg',
    'user' : 'git'
  }
  var got = _.uriNew.parseAtomic( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'full';
  var expected =
  {
    protocol : 'git',
    longPath : '/git@bitbucket.org:someorg/somerepo.git',
    tag : 'tag',
    postfixedPath : '/git@bitbucket.org:someorg/somerepo.git!tag',
    hostFull : '/git@bitbucket.org:someorg',
    resourcePath : 'somerepo.git',
    host : '/bitbucket.org',
    port : 'someorg',
    user : 'git',
    protocols : [ 'git' ],
    origin : 'git:///git@bitbucket.org:someorg',
    full : 'git:///git@bitbucket.org:someorg/somerepo.git!tag'
  }
  var got = _.uriNew.parseFull( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  /* */

  test.case = 'longpath with dot after host, user, slash tag';
  var src = 'git:///git@bitbucket.org:someorg/somerepo.git/!tag';

  test.description = 'consecutive';
  var expected =
  {
    longPath : '/git@bitbucket.org:someorg/somerepo.git/',
    tag : 'tag',
    protocol : 'git',
  }
  var got = _.uriNew.parseConsecutive( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'atomic';
  var expected =
  {
    'protocol' : 'git',
    'tag' : 'tag',
    'resourcePath' : 'somerepo.git/',
    'host' : '/bitbucket.org',
    'port' : 'someorg',
    'user' : 'git'
  }
  var got = _.uriNew.parseAtomic( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'full';
  var expected =
  {
    protocol : 'git',
    longPath : '/git@bitbucket.org:someorg/somerepo.git/',
    tag : 'tag',
    postfixedPath : '/git@bitbucket.org:someorg/somerepo.git/!tag',
    hostFull : '/git@bitbucket.org:someorg',
    resourcePath : 'somerepo.git/',
    host : '/bitbucket.org',
    port : 'someorg',
    user : 'git',
    protocols : [ 'git' ],
    origin : 'git:///git@bitbucket.org:someorg',
    full : 'git:///git@bitbucket.org:someorg/somerepo.git/!tag'
  }
  var got = _.uriNew.parseFull( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  /* */

  test.case = 'longpath with dot after host, user, hash';
  var src = 'git:///git@bitbucket.org:someorg/somerepo.git#hash';

  test.description = 'consecutive';
  var expected =
  {
    protocol : 'git',
    longPath : '/git@bitbucket.org:someorg/somerepo.git',
    hash : 'hash'
  }
  var got = _.uriNew.parseConsecutive( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'atomic';
  var expected =
  {
    'protocol' : 'git',
    'hash' : 'hash',
    'resourcePath' : 'somerepo.git',
    'host' : '/bitbucket.org',
    'port' : 'someorg',
    'user' : 'git'
  }
  var got = _.uriNew.parseAtomic( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'full';
  var expected =
  {
    protocol : 'git',
    longPath : '/git@bitbucket.org:someorg/somerepo.git',
    hash : 'hash',
    postfixedPath : '/git@bitbucket.org:someorg/somerepo.git#hash',
    hostFull : '/git@bitbucket.org:someorg',
    resourcePath : 'somerepo.git',
    host : '/bitbucket.org',
    port : 'someorg',
    user : 'git',
    protocols : [ 'git' ],
    origin : 'git:///git@bitbucket.org:someorg',
    full : 'git:///git@bitbucket.org:someorg/somerepo.git#hash'
  }
  var got = _.uriNew.parseFull( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  /* */

  test.case = 'longpath with dot after host, user, slash hash';
  var src = 'git:///git@bitbucket.org:someorg/somerepo.git/#hash';

  test.description = 'consecutive';
  var expected =
  {
    protocol : 'git',
    longPath : '/git@bitbucket.org:someorg/somerepo.git/',
    hash : 'hash'
  }
  var got = _.uriNew.parseConsecutive( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'atomic';
  var expected =
  {
    'protocol' : 'git',
    'hash' : 'hash',
    'resourcePath' : 'somerepo.git/',
    'host' : '/bitbucket.org',
    'port' : 'someorg',
    'user' : 'git'
  }
  var got = _.uriNew.parseAtomic( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'full';
  var expected =
  {
    protocol : 'git',
    longPath : '/git@bitbucket.org:someorg/somerepo.git/',
    hash : 'hash',
    postfixedPath : '/git@bitbucket.org:someorg/somerepo.git/#hash',
    hostFull : '/git@bitbucket.org:someorg',
    resourcePath : 'somerepo.git/',
    host : '/bitbucket.org',
    port : 'someorg',
    user : 'git',
    protocols : [ 'git' ],
    origin : 'git:///git@bitbucket.org:someorg',
    full : 'git:///git@bitbucket.org:someorg/somerepo.git/#hash'
  }
  var got = _.uriNew.parseFull( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  /* */

  test.case = 'protocol, host and hash only';
  var src  ='git:///somerepo.git#hash';

  test.description = 'consecutive';
  var expected =
  {
    protocol : 'git',
    longPath : '/somerepo.git',
    hash : 'hash'
  }
  var got = _.uriNew.parseConsecutive( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'atomic';
  var expected =
  {
    'protocol' : 'git',
    'hash' : 'hash',
    'host' : '/somerepo.git',
  }
  var got = _.uriNew.parseAtomic( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'full';
  var expected =
  {
    'longPath' : '/somerepo.git',
    'hash' : 'hash',
    'postfixedPath' : '/somerepo.git#hash',
    'hostFull' : '/somerepo.git',
    'host' : '/somerepo.git',
    'origin' : 'git:///somerepo.git',
    'full' : 'git:///somerepo.git#hash',
    'protocol' : 'git',
    'protocols' : [ 'git' ]
  }
  var got = _.uriNew.parseFull( src );
  test.identical( got, expected );
  var str = _.uriNew.str( expected );
  test.identical( str, src );

  /* */

  test.case = 'protocol, host and slash hash only';
  var src = 'git:///somerepo.git/#hash';

  test.description = 'consecutive';
  var expected =
  {
    protocol : 'git',
    longPath : '/somerepo.git/',
    hash : 'hash'
  }
  var got = _.uriNew.parseConsecutive( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'atomic';
  var expected =
  {
    'protocol' : 'git',
    'hash' : 'hash',
    'resourcePath' : '',
    'host' : '/somerepo.git'
  }
  var got = _.uriNew.parseAtomic( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'full';
  var expected =
  {
    protocol : 'git',
    longPath : '/somerepo.git/',
    hash : 'hash',
    postfixedPath : '/somerepo.git/#hash',
    hostFull : '/somerepo.git',
    resourcePath : '',
    host : '/somerepo.git',
    protocols : [ 'git' ],
    origin : 'git:///somerepo.git',
    full : 'git:///somerepo.git/#hash'
  }
  var got = _.uriNew.parseFull( src );
  test.identical( got, expected );
  var str = _.uriNew.str( expected );
  test.identical( str, src );

  /* */

  test.case = 'protocol, host and slash tag only';
  var src = 'git:///somerepo.git/!tag';

  test.description = 'consecutive';
  var expected =
  {
    protocol : 'git',
    longPath : '/somerepo.git/',
    tag : 'tag',
  }
  var got = _.uriNew.parseConsecutive( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'atomic';
  var expected =
  {
    'protocol' : 'git',
    'tag' : 'tag',
    'resourcePath' : '',
    'host' : '/somerepo.git',
  }
  var got = _.uriNew.parseAtomic( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'full';
  var expected =
  {
    protocol : 'git',
    longPath : '/somerepo.git/',
    tag : 'tag',
    postfixedPath : '/somerepo.git/!tag',
    hostFull : '/somerepo.git',
    resourcePath : '',
    host : '/somerepo.git',
    protocols : [ 'git' ],
    origin : 'git:///somerepo.git',
    full : 'git:///somerepo.git/!tag'
  }
  var got = _.uriNew.parseFull( src );
  test.identical( got, expected );
  var str = _.uriNew.str( expected );
  test.identical( str, src );

  /* */

  test.case = 'user, hash and tag';
  var src = 'git:///git@bitbucket.org:someorg/somerepo.git#hash!tag';

  test.description = 'consecutive';
  var expected =
  {
    protocol : 'git',
    longPath : '/git@bitbucket.org:someorg/somerepo.git',
    hash : 'hash',
    tag : 'tag'
  }
  var got = _.uriNew.parseConsecutive( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'atomic';
  var expected =
  {
    'protocol' : 'git',
    'hash' : 'hash',
    'tag' : 'tag',
    'resourcePath' : 'somerepo.git',
    'host' : '/bitbucket.org',
    'port' : 'someorg',
    'user' : 'git',
  }
  var got = _.uriNew.parseAtomic( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'full';
  var expected =
  {
    protocol : 'git',
    longPath : '/git@bitbucket.org:someorg/somerepo.git',
    hash : 'hash',
    tag : 'tag',
    postfixedPath : '/git@bitbucket.org:someorg/somerepo.git#hash!tag',
    hostFull : '/git@bitbucket.org:someorg',
    resourcePath : 'somerepo.git',
    host : '/bitbucket.org',
    port : 'someorg',
    user : 'git',
    protocols : [ 'git' ],
    origin : 'git:///git@bitbucket.org:someorg',
    full : 'git:///git@bitbucket.org:someorg/somerepo.git#hash!tag'
  }
  var got = _.uriNew.parseFull( src );
  test.identical( got, expected );
  var str = _.uriNew.str( expected );
  test.identical( str, src );

  /* */

  test.case = 'user, hash and tag after slash';
  var src = 'git:///git@bitbucket.org:someorg/somerepo.git/#hash!tag';

  test.description = 'consecutive';
  var expected =
  {
    protocol : 'git',
    longPath : '/git@bitbucket.org:someorg/somerepo.git/',
    hash : 'hash',
    tag : 'tag'
  }
  var got = _.uriNew.parseConsecutive( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'atomic';
  var expected =
  {
    'protocol' : 'git',
    'hash' : 'hash',
    'tag' : 'tag',
    'resourcePath' : 'somerepo.git/',
    'host' : '/bitbucket.org',
    'port' : 'someorg',
    'user' : 'git'
  }
  var got = _.uriNew.parseAtomic( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'full';
  var expected =
  {
    protocol : 'git',
    longPath : '/git@bitbucket.org:someorg/somerepo.git/',
    hash : 'hash',
    tag : 'tag',
    postfixedPath : '/git@bitbucket.org:someorg/somerepo.git/#hash!tag',
    hostFull : '/git@bitbucket.org:someorg',
    resourcePath : 'somerepo.git/',
    host : '/bitbucket.org',
    port : 'someorg',
    user : 'git',
    protocols : [ 'git' ],
    origin : 'git:///git@bitbucket.org:someorg',
    full : 'git:///git@bitbucket.org:someorg/somerepo.git/#hash!tag'
  }
  var got = _.uriNew.parseFull( src );
  test.identical( got, expected );
  var str = _.uriNew.str( expected );
  test.identical( str, src );

  /* */

  test.case = 'hash and tag';
  var src = 'git:///somerepo.git#hash!tag';

  test.description = 'consecutive';
  var expected =
  {
    protocol : 'git',
    longPath : '/somerepo.git',
    hash : 'hash',
    tag : 'tag',
  }
  var got = _.uriNew.parseConsecutive( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'atomic';
  var expected =
  {
    'protocol' : 'git',
    'hash' : 'hash',
    'tag' : 'tag',
    'host' : '/somerepo.git'
  }
  var got = _.uriNew.parseAtomic( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'full';
  var expected =
  {
    protocol : 'git',
    longPath : '/somerepo.git',
    hash : 'hash',
    tag : 'tag',
    postfixedPath : '/somerepo.git#hash!tag',
    hostFull : '/somerepo.git',
    host : '/somerepo.git',
    protocols : [ 'git' ],
    origin : 'git:///somerepo.git',
    full : 'git:///somerepo.git#hash!tag'
  }
  var got = _.uriNew.parseFull( src );
  test.identical( got, expected );
  var str = _.uriNew.str( expected );
  test.identical( str, src );

  /* */

  test.case = 'hash and tag after slash';
  var src = 'git:///somerepo.git/#hash!tag';

  test.description = 'consecutive';
  var expected =
  {
    protocol : 'git',
    longPath : '/somerepo.git/',
    hash : 'hash',
    tag : 'tag',
  }
  var got = _.uriNew.parseConsecutive( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'atomic';
  var expected =
  {
    'protocol' : 'git',
    'hash' : 'hash',
    'tag' : 'tag',
    'resourcePath' : '',
    'host' : '/somerepo.git',
  }
  var got = _.uriNew.parseAtomic( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'full';
  var expected =
  {
    protocol : 'git',
    longPath : '/somerepo.git/',
    hash : 'hash',
    tag : 'tag',
    postfixedPath : '/somerepo.git/#hash!tag',
    hostFull : '/somerepo.git',
    resourcePath : '',
    host : '/somerepo.git',
    protocols : [ 'git' ],
    origin : 'git:///somerepo.git',
    full : 'git:///somerepo.git/#hash!tag'
  }
  var got = _.uriNew.parseFull( src );
  test.identical( got, expected );
  var str = _.uriNew.str( expected );
  test.identical( str, src );

  /* */

  test.case = 'name, query, hash and tag';
  var src = 'git:///git@bitbucket.org:someorg/somerepo.git?query=1#hash!tag';

  test.description = 'consecutive';
  var expected =
  {
    protocol : 'git',
    longPath : '/git@bitbucket.org:someorg/somerepo.git',
    query : 'query=1',
    hash : 'hash',
    tag : 'tag',
  }
  var got = _.uriNew.parseConsecutive( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'atomic';
  var expected =
  {
    'protocol' : 'git',
    'query' : 'query=1',
    'hash' : 'hash',
    'tag' : 'tag',
    'resourcePath' : 'somerepo.git',
    'host' : '/bitbucket.org',
    'port' : 'someorg',
    'user' : 'git',
  }
  var got = _.uriNew.parseAtomic( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'full';
  var expected =
  {
    protocol : 'git',
    longPath : '/git@bitbucket.org:someorg/somerepo.git',
    query : 'query=1',
    hash : 'hash',
    tag : 'tag',
    postfixedPath : '/git@bitbucket.org:someorg/somerepo.git?query=1#hash!tag',
    hostFull : '/git@bitbucket.org:someorg',
    resourcePath : 'somerepo.git',
    host : '/bitbucket.org',
    port : 'someorg',
    user : 'git',
    protocols : [ 'git' ],
    origin : 'git:///git@bitbucket.org:someorg',
    full : 'git:///git@bitbucket.org:someorg/somerepo.git?query=1#hash!tag'
  }
  var got = _.uriNew.parseFull( src );
  test.identical( got, expected );
  var str = _.uriNew.str( expected );
  test.identical( str, src );

  /* */

  test.case = 'name, slash before query, hash and tag';
  var src = 'git:///git@bitbucket.org:someorg/somerepo.git/?query=1#hash!tag';

  test.description = 'consecutive';
  var expected =
  {
    protocol : 'git',
    longPath : '/git@bitbucket.org:someorg/somerepo.git/',
    query : 'query=1',
    hash : 'hash',
    tag : 'tag',
  }
  var got = _.uriNew.parseConsecutive( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'atomic';
  var expected =
  {
    'protocol' : 'git',
    'query' : 'query=1',
    'hash' : 'hash',
    'tag' : 'tag',
    'resourcePath' : 'somerepo.git/',
    'host' : '/bitbucket.org',
    'port' : 'someorg',
    'user' : 'git',
  }
  var got = _.uriNew.parseAtomic( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'full';
  var expected =
  {
    protocol : 'git',
    longPath : '/git@bitbucket.org:someorg/somerepo.git/',
    query : 'query=1',
    hash : 'hash',
    tag : 'tag',
    postfixedPath : '/git@bitbucket.org:someorg/somerepo.git/?query=1#hash!tag',
    hostFull : '/git@bitbucket.org:someorg',
    resourcePath : 'somerepo.git/',
    host : '/bitbucket.org',
    port : 'someorg',
    user : 'git',
    protocols : [ 'git' ],
    origin : 'git:///git@bitbucket.org:someorg',
    full : 'git:///git@bitbucket.org:someorg/somerepo.git/?query=1#hash!tag'
  }
  var got = _.uriNew.parseFull( src );
  test.identical( got, expected );
  var str = _.uriNew.str( expected );
  test.identical( str, src );

  /* */

  test.case = 'query, hash and tag';
  var src = 'git:///somerepo.git?query=1#hash!tag';

  test.description = 'consecutive';
  var expected =
  {
    protocol : 'git',
    longPath : '/somerepo.git',
    query : 'query=1',
    hash : 'hash',
    tag : 'tag',
  }
  var got = _.uriNew.parseConsecutive( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'atomic';
  var expected =
  {
    'protocol' : 'git',
    'query' : 'query=1',
    'hash' : 'hash',
    'tag' : 'tag',
    'host' : '/somerepo.git',
  }
  var got = _.uriNew.parseAtomic( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'full';
  var expected =
  {
    protocol : 'git',
    longPath : '/somerepo.git',
    query : 'query=1',
    hash : 'hash',
    tag : 'tag',
    postfixedPath : '/somerepo.git?query=1#hash!tag',
    hostFull : '/somerepo.git',
    host : '/somerepo.git',
    protocols : [ 'git' ],
    origin : 'git:///somerepo.git',
    full : 'git:///somerepo.git?query=1#hash!tag'
  }
  var got = _.uriNew.parseFull( src );
  test.identical( got, expected );
  var str = _.uriNew.str( expected );
  test.identical( str, src );

  /* */

  test.case = 'slash before query, hash and tag';
  var src = 'git:///somerepo.git/?query=1#hash!tag';

  test.description = 'consecutive';
  var expected =
  {
    protocol : 'git',
    longPath : '/somerepo.git/',
    query : 'query=1',
    hash : 'hash',
    tag : 'tag',
  }
  var got = _.uriNew.parseConsecutive( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'atomic';
  var expected =
  {
    'protocol' : 'git',
    'query' : 'query=1',
    'hash' : 'hash',
    'tag' : 'tag',
    'resourcePath' : '',
    'host' : '/somerepo.git'
  }
  var got = _.uriNew.parseAtomic( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'full';
  var expected =
  {
    protocol : 'git',
    longPath : '/somerepo.git/',
    query : 'query=1',
    hash : 'hash',
    tag : 'tag',
    postfixedPath : '/somerepo.git/?query=1#hash!tag',
    hostFull : '/somerepo.git',
    resourcePath : '',
    host : '/somerepo.git',
    protocols : [ 'git' ],
    origin : 'git:///somerepo.git',
    full : 'git:///somerepo.git/?query=1#hash!tag'
  }
  var got = _.uriNew.parseFull( src );
  test.identical( got, expected );
  var str = _.uriNew.str( expected );
  test.identical( str, src );

  /* */

  test.case = 'name, query and tag';
  var src = 'git:///git@bitbucket.org:someorg/somerepo.git?query=1!tag';

  test.description = 'consecutive';
  var expected =
  {
    protocol : 'git',
    longPath : '/git@bitbucket.org:someorg/somerepo.git',
    query : 'query=1',
    tag : 'tag',
  }
  var got = _.uriNew.parseConsecutive( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'atomic';
  var expected =
  {
    'host' : '/bitbucket.org',
    'protocol' : 'git',
    'query' : 'query=1',
    'tag' : 'tag',
    'resourcePath' : 'somerepo.git',
    'port' : 'someorg',
    'user' : 'git'
  }
  var got = _.uriNew.parseAtomic( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'full';
  var expected =
  {
    protocol : 'git',
    longPath : '/git@bitbucket.org:someorg/somerepo.git',
    query : 'query=1',
    tag : 'tag',
    postfixedPath : '/git@bitbucket.org:someorg/somerepo.git?query=1!tag',
    hostFull : '/git@bitbucket.org:someorg',
    resourcePath : 'somerepo.git',
    host : '/bitbucket.org',
    port : 'someorg',
    user : 'git',
    protocols : [ 'git' ],
    origin : 'git:///git@bitbucket.org:someorg',
    full : 'git:///git@bitbucket.org:someorg/somerepo.git?query=1!tag'
  }
  var got = _.uriNew.parseFull( src );
  test.identical( got, expected );
  var str = _.uriNew.str( expected );
  test.identical( str, src );

  /* */

  test.case = 'name, slash before query and tag';
  var src = 'git:///git@bitbucket.org:someorg/somerepo.git/?query=1!tag';

  test.description = 'consecutive';
  var expected =
  {
    protocol : 'git',
    longPath : '/git@bitbucket.org:someorg/somerepo.git/',
    query : 'query=1',
    tag : 'tag',
  }
  var got = _.uriNew.parseConsecutive( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'atomic';
  var expected =
  {
    'protocol' : 'git',
    'query' : 'query=1',
    'tag' : 'tag',
    'resourcePath' : 'somerepo.git/',
    'host' : '/bitbucket.org',
    'port' : 'someorg',
    'user' : 'git'
  }
  var got = _.uriNew.parseAtomic( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'full';
  var expected =
  {
    protocol : 'git',
    longPath : '/git@bitbucket.org:someorg/somerepo.git/',
    query : 'query=1',
    tag : 'tag',
    postfixedPath : '/git@bitbucket.org:someorg/somerepo.git/?query=1!tag',
    hostFull : '/git@bitbucket.org:someorg',
    resourcePath : 'somerepo.git/',
    host : '/bitbucket.org',
    port : 'someorg',
    user : 'git',
    protocols : [ 'git' ],
    origin : 'git:///git@bitbucket.org:someorg',
    full : 'git:///git@bitbucket.org:someorg/somerepo.git/?query=1!tag'
  }
  var got = _.uriNew.parseFull( src );
  test.identical( got, expected );
  var str = _.uriNew.str( expected );
  test.identical( str, src );

  /* */

  test.case = 'query and tag';
  var src = 'git:///somerepo.git?query=1!tag';

  test.description = 'consecutive';
  var expected =
  {
    protocol : 'git',
    longPath : '/somerepo.git',
    query : 'query=1',
    tag : 'tag',
  }
  var got = _.uriNew.parseConsecutive( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'atomic';
  var expected =
  {
    'protocol' : 'git',
    'query' : 'query=1',
    'tag' : 'tag',
    'host' : '/somerepo.git',
  }
  var got = _.uriNew.parseAtomic( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'full';
  var expected =
  {
    protocol : 'git',
    longPath : '/somerepo.git',
    query : 'query=1',
    tag : 'tag',
    postfixedPath : '/somerepo.git?query=1!tag',
    hostFull : '/somerepo.git',
    host : '/somerepo.git',
    protocols : [ 'git' ],
    origin : 'git:///somerepo.git',
    full : 'git:///somerepo.git?query=1!tag'
  }
  var got = _.uriNew.parseFull( src );
  test.identical( got, expected );
  var str = _.uriNew.str( expected );
  test.identical( str, src );

  /* */

  test.case = 'slash before query and tag';
  var src = 'git:///somerepo.git/?query=1!tag';

  test.description = 'consecutive';
  var expected =
  {
    protocol : 'git',
    longPath : '/somerepo.git/',
    query : 'query=1',
    tag : 'tag',
  }
  var got = _.uriNew.parseConsecutive( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'atomic';
  var expected =
  {
    'protocol' : 'git',
    'query' : 'query=1',
    'tag' : 'tag',
    'resourcePath' : '',
    'host' : '/somerepo.git'
  }
  var got = _.uriNew.parseAtomic( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'full';
  var expected =
  {
    protocol : 'git',
    longPath : '/somerepo.git/',
    query : 'query=1',
    tag : 'tag',
    postfixedPath : '/somerepo.git/?query=1!tag',
    hostFull : '/somerepo.git',
    resourcePath : '',
    host : '/somerepo.git',
    protocols : [ 'git' ],
    origin : 'git:///somerepo.git',
    full : 'git:///somerepo.git/?query=1!tag'
  }
  var got = _.uriNew.parseFull( src );
  test.identical( got, expected );
  var str = _.uriNew.str( expected );
  test.identical( str, src );

  /* */

  test.case = '# @ ?';
  var src = '://?query1#hash1/!tag1/';

  test.description = 'consecutive';
  var expected =
  {
    longPath : '',
    query : 'query1',
    tag : 'tag1/',
    hash : 'hash1/',
    protocol : '',
  }
  var got = _.uriNew.parseConsecutive( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'atomic';
  var expected =
  {
    'protocol' : '',
    'query' : 'query1',
    'hash' : 'hash1/',
    'tag' : 'tag1/'
  }
  var got = _.uriNew.parseAtomic( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'full';
  var expected =
  {
    protocol : '',
    longPath : '',
    query : 'query1',
    hash : 'hash1/',
    tag : 'tag1/',
    postfixedPath : '?query1#hash1/!tag1/',
    origin : '://undefined',
    full : '://?query1#hash1/!tag1/',
    protocols : [],
  }
  var got = _.uriNew.parseFull( src );
  test.identical( got, expected );
  var str = _.uriNew.str( expected );
  test.identical( str, src );

  /* */

  test.case = 'escaped # @ ?';
  var src = '://"#hash1"/"!tag1"/"?query1"';

  test.description = 'consecutive';
  var expected =
  {
    longPath : '"#hash1"/"!tag1"/"?query1"',
    protocol : '',
  }
  var got = _.uriNew.parseConsecutive( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'atomic';
  var expected =
  {
    'protocol' : '',
    'resourcePath' : '"!tag1"/"?query1"',
    'host' : '"#hash1"',
  }
  var got = _.uriNew.parseAtomic( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'full';
  var expected =
  {
    protocol : '',
    longPath : '"#hash1"/"!tag1"/"?query1"',
    postfixedPath : '"#hash1"/"!tag1"/"?query1"',
    hostFull : '"#hash1"',
    resourcePath : '"!tag1"/"?query1"',
    host : '"#hash1"',
    origin : '://"#hash1"',
    full : '://"#hash1"/"!tag1"/"?query1"',
    protocols : [],
  }
  var got = _.uriNew.parseFull( src );
  test.identical( got, expected );
  var str = _.uriNew.str( expected );
  test.identical( str, src );

  /* */

  test.case = 'several ://';
  var src = 'https://web.archive.org/web/*/http://www.heritage.org/index/ranking';

  test.description = 'consecutive';
  var expected =
  {
    'protocol' : 'https',
    'longPath' : 'web.archive.org/web/*/http://www.heritage.org/index/ranking'
  }
  var got = _.uriNew.parseConsecutive( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'atomic';
  var expected =
  {
    'protocol' : 'https',
    'resourcePath' : 'web/*/http://www.heritage.org/index/ranking',
    'host' : 'web.archive.org',
  }
  var got = _.uriNew.parseAtomic( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'full';
  var expected =
  {
    'protocol' : 'https',
    'longPath' : 'web.archive.org/web/*/http://www.heritage.org/index/ranking',
    'postfixedPath' : 'web.archive.org/web/*/http://www.heritage.org/index/ranking',
    'hostFull' : 'web.archive.org',
    'resourcePath' : 'web/*/http://www.heritage.org/index/ranking',
    'host' : 'web.archive.org',
    'protocols' : [ 'https' ],
    'origin' : 'https://web.archive.org',
    'full' : 'https://web.archive.org/web/*/http://www.heritage.org/index/ranking',
  }
  var got = _.uriNew.parseFull( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  /* */

  test.case = 'user and password';
  var src = '://user:pass@sub.host.com:8080/p/a/t/h';

  test.description = 'consecutive';
  var expected =
  {
    'longPath' : 'user:pass@sub.host.com:8080/p/a/t/h',
    'protocol' : '',
  }
  var got = _.uriNew.parseConsecutive( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'atomic';
  var expected =
  {
    'protocol' : '',
    'resourcePath' : 'p/a/t/h',
    'host' : 'sub.host.com',
    'port' : 8080,
    'user' : 'user:pass',
  }
  var got = _.uriNew.parseAtomic( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'full';
  var expected =
  {
    'protocol' : '',
    'longPath' : 'user:pass@sub.host.com:8080/p/a/t/h',
    'postfixedPath' : 'user:pass@sub.host.com:8080/p/a/t/h',
    'hostFull' : 'user:pass@sub.host.com:8080',
    'resourcePath' : 'p/a/t/h',
    'host' : 'sub.host.com',
    'port' : 8080,
    'user' : 'user:pass',
    'origin' : '://user:pass@sub.host.com:8080',
    'full' : '://user:pass@sub.host.com:8080/p/a/t/h',
    'protocols' : [],
  }
  var got = _.uriNew.parseFull( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  /* */

  test.case = 'local';
  var src = '/a/!a.js';

  test.description = 'consecutive';
  var expected =
  {
    'longPath' : '/a/',
    'tag' : 'a.js'
  }
  var got = _.uriNew.parseConsecutive( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'atomic';
  var expected =
  {
    'tag' : 'a.js',
    'resourcePath' : '',
    'host' : '/a',
  }
  var got = _.uriNew.parseAtomic( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'full';
  var expected =
  {
    'longPath' : '/a/',
    'tag' : 'a.js',
    'postfixedPath' : '/a/!a.js',
    'hostFull' : '/a',
    'resourcePath' : '',
    'host' : '/a',
    'full' : '/a/!a.js',
    'protocols' : [],
  }
  var got = _.uriNew.parseFull( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  /* */

  test.case = 'double slash for resource';
  var src = ':///server1//resource1';

  test.description = 'consecutive';
  var expected =
  {
    'protocol' : '', 'longPath' : '/server1//resource1'
  }
  var got = _.uriNew.parseConsecutive( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'atomic';
  var expected =
  {
    'resourcePath' : '/resource1', 'host' : '/server1', 'protocol' : ''
  }
  var got = _.uriNew.parseAtomic( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'full';
  var expected =
  {
    'protocol' : '',
    'longPath' : '/server1//resource1',
    'postfixedPath' : '/server1//resource1',
    'hostFull' : '/server1',
    'resourcePath' : '/resource1',
    'host' : '/server1',
    'origin' : ':///server1',
    'full' : ':///server1//resource1',
    'protocols' : [],
  }
  var got = _.uriNew.parseFull( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  /* */

  test.case = 'empty host and double slash of resource';
  var src = '://///';

  test.description = 'consecutive';
  var expected =
  {
    'protocol' : '',
    'longPath' : '///',
  }
  var got = _.uriNew.parseConsecutive( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'atomic';
  var expected =
  {
    'protocol' : '',
    'resourcePath' : '/',
    'host' : '/'
  }
  var got = _.uriNew.parseAtomic( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  test.description = 'full';
  var expected =
  {
    'protocol' : '',
    'longPath' : '///',
    'postfixedPath' : '///',
    'hostFull' : '/',
    'resourcePath' : '/',
    'host' : '/',
    'origin' : ':///',
    'full' : '://///',
    'protocols' : [],
  }
  var got = _.uriNew.parseFull( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  /* - */

  if( !Config.debug )
  return;

  test.case = 'missed arguments';
  test.shouldThrowErrorSync( () => _.uriNew.parseConsecutive() );
  test.shouldThrowErrorSync( () => _.uriNew.parseAtomic() );
  test.shouldThrowErrorSync( () => _.uriNew.parseFull() );

  test.case = 'redundant argument';
  test.shouldThrowErrorSync( () => _.uriNew.parseConsecutive( 'path1', 'path2' ) );
  test.shouldThrowErrorSync( () => _.uriNew.parseAtomic( 'path1', 'path2' ) );
  test.shouldThrowErrorSync( () => _.uriNew.parseFull( 'path1', 'path2' ) );

  test.case = 'argument is not string';
  test.shouldThrowErrorSync( () => _.uriNew.parseConsecutive( 13 ) );
  test.shouldThrowErrorSync( () => _.uriNew.parseAtomic( 13 ) );
  test.shouldThrowErrorSync( () => _.uriNew.parseFull( 13 ) );

} /* eof function parseCommon */

// //
//
// function parseFull( test )
// {
//
//   /* */
//
//   test.case = 'query only';
//   var src = '?entry:1&format:null';
//   var expected =
//   {
//     'longPath' : '',
//     'query' : 'entry:1&format:null',
//     'postfixedPath' : '?entry:1&format:null',
//     'protocols' : [],
//     'full' : '?entry:1&format:null',
//   }
//   var got = _.uriNew.parseFull( src );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'global, relative, with hash, with query';
//   var src = 'git://../repo/Tools?out=out/wTools.out.will#master';
//   var expected =
//   {
//     'protocol' : 'git',
//     'longPath' : '../repo/Tools',
//     'query' : 'out=out/wTools.out.will',
//     'hash' : 'master',
//     'postfixedPath' : '../repo/Tools?out=out/wTools.out.will#master',
//     'hostFull' : '..',
//     'resourcePath' : 'repo/Tools',
//     'host' : '..',
//     'protocols' : [ 'git' ],
//     'origin' : 'git://..',
//     'full' : 'git://../repo/Tools?out=out/wTools.out.will#master',
//   }
//   var got = _.uriNew.parseFull( src );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'global, absolute, with hash, with query';
//   var src = "git:///../repo/Tools?out=out/wTools.out.will#master"
//   var expected =
//   {
//     'protocol' : 'git',
//     'longPath' : '/../repo/Tools',
//     'query' : 'out=out/wTools.out.will',
//     'hash' : 'master',
//     'postfixedPath' : '/../repo/Tools?out=out/wTools.out.will#master',
//     'hostFull' : '/..',
//     'protocols' : [ 'git' ],
//     'resourcePath' : 'repo/Tools',
//     'host' : '..',
//     'origin' : 'git:///..',
//     'full' : 'git:///../repo/Tools?out=out/wTools.out.will#master',
//   }
//   var got = _.uriNew.parseFull( src );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'query with equal. relative';
//   var src = 'http://127.0.0.1:5000/a/b?q=3#anch';
//   var expected =
//   {
//     'protocol' : 'http',
//     'longPath' : '127.0.0.1:5000/a/b',
//     'query' : 'q=3',
//     'hash' : 'anch'
//   }
//   var got = _.uriNew.parseAtomic( src );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'query with equal. absolute';
//   var src = 'http:///127.0.0.1:5000/a/b?q=3#anch';
//   var expected =
//   {
//     'protocol' : 'http',
//     'longPath' : '/127.0.0.1:5000/a/b',
//     'query' : 'q=3',
//     'hash' : 'anch',
//     'postfixedPath' : '/127.0.0.1:5000/a/b?q=3#anch',
//     'hostFull' : '/127.0.0.1:5000',
//     'resourcePath' : 'a/b',
//     'host' : '127.0.0.1',
//     'port' : 5000,
//     'protocols' : [ 'http' ],
//     'origin' : 'http:///127.0.0.1:5000',
//     'full' : 'http:///127.0.0.1:5000/a/b?q=3#anch',
//   }
//   var got = _.uriNew.parseFull( src );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'query with colon. relative';
//   var src = 'http://127.0.0.1:5000/a/b?q:3#anch';
//   var expected =
//   {
//     'protocol' : 'http',
//     'longPath' : '127.0.0.1:5000/a/b',
//     'query' : 'q:3',
//     'hash' : 'anch',
//     'postfixedPath' : '127.0.0.1:5000/a/b?q:3#anch',
//     'hostFull' : '127.0.0.1:5000',
//     'resourcePath' : 'a/b',
//     'host' : '127.0.0.1',
//     'port' : 5000,
//     'protocols' : [ 'http' ],
//     'origin' : 'http://127.0.0.1:5000',
//     'full' : 'http://127.0.0.1:5000/a/b?q:3#anch'
//   }
//   var got = _.uriNew.parseFull( src );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'query with colon. absolute';
//   var src = 'http:///127.0.0.1:5000/a/b?q:3#anch';
//   var expected =
//   {
//     'protocol' : 'http',
//     'longPath' : '/127.0.0.1:5000/a/b',
//     'query' : 'q:3',
//     'hash' : 'anch',
//     'postfixedPath' : '/127.0.0.1:5000/a/b?q:3#anch',
//     'hostFull' : '/127.0.0.1:5000',
//     'resourcePath' : 'a/b',
//     'host' : '127.0.0.1',
//     'port' : 5000,
//     'protocols' : [ 'http' ],
//     'origin' : 'http:///127.0.0.1:5000',
//     'full' : 'http:///127.0.0.1:5000/a/b?q:3#anch',
//   }
//   var got = _.uriNew.parseFull( src );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'no protocol';
//   var uri = '127.0.0.1:61726/../path';
//   var expected =
//   {
//     'longPath' : '127.0.0.1:61726/../path',
//     'postfixedPath' : '127.0.0.1:61726/../path',
//     'hostFull' : '127.0.0.1:61726',
//     'resourcePath' : '../path',
//     'host' : '127.0.0.1',
//     'port' : 61726,
//     'protocols' : [],
//     'origin' : 'undefined://127.0.0.1:61726',
//     'full' : '127.0.0.1:61726/../path'
//   }
//   var got = _.uriNew.parseFull( uri );
//   test.identical( got, expected );
//
//   debugger; return; /* qqq2 : update all other test cases */
//
//   /* */
//
//   test.case = 'full uri with all components';
//   var expected =
//   {
//     protocol : 'http',
//     longPath : 'www.site.com:13/path/name',
//     query : 'query=here&and=here',
//     hash : 'anchor',
//   }
//   var src = 'http://www.site.com:13/path/name?query=here&and=here#anchor';
//   var got = _.uriNew.parseFull( uri1 );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'full uri with all components, primitiveOnly';
//
//   var expected =
//   {
//     protocol : 'http',
//     longPath : 'www.site.com:13/path/name',
//     query : 'query=here&and=here',
//     hash : 'anchor',
//   }
//
//   var uri1 = 'http://www.site.com:13/path/name?query=here&and=here#anchor';
//   var got = _.uriNew.parseFull( uri1 );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'reparse with non primitives';
//
//   var expected =
//   {
//     protocol : 'http',
//     longPath : 'www.site.com:13/path/name',
//     query : 'query=here&and=here',
//     hash : 'anchor',
//   }
//
//   var parsed = got;
//   var got = _.uriNew.parseFull( parsed );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'reparse with primitives';
//
//   var uri1 = 'http://www.site.com:13/path/name?query=here&and=here#anchor';
//   var expected =
//   {
//     protocol : 'http',
//     longPath : 'www.site.com:13/path/name',
//     query : 'query=here&and=here',
//     hash : 'anchor',
//   }
//
//   var got = _.uriNew.parseFull( uri1 );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'uri with zero length protocol';
//   var uri = '://some.domain.com/something/filePath/add';
//   var expected =
//   {
//     protocol : '',
//     longPath : 'some.domain.com/something/filePath/add',
//   }
//   var got = _.uriNew.parseFull( uri );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'uri with zero length hostFull';
//   var uri = 'file:///something/filePath/add';
//   var expected =
//   {
//     protocol : 'file',
//     longPath : '/something/filePath/add',
//   }
//   var got = _.uriNew.parseFull( uri );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'uri with double protocol, user';
//   var uri = 'svn+https://user@subversion.com:13/svn/trunk';
//   var expected =
//   {
//     protocol : 'svn+https',
//     longPath : 'user@subversion.com:13/svn/trunk',
//   }
//   var got = _.uriNew.parseFull( uri );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'uri with double protocol, user and tag';
//   var uri = 'svn+https://user@subversion.com:13/svn/trunk!tag1';
//   var expected =
//   {
//     protocol : 'svn+https',
//     longPath : 'user@subversion.com:13/svn/trunk',
//     tag : 'tag1',
//   }
//   var got = _.uriNew.parseFull( uri );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'simple path';
//   var uri = '/some/file';
//   var expected =
//   {
//     longPath : '/some/file',
//   }
//   var got = _.uriNew.parseFull( uri );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'without ":"';
//   var uri = '//some.domain.com/was';
//   var expected =
//   {
//     longPath : '//some.domain.com/was',
//   }
//   var got = _.uriNew.parseFull( uri );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'with ":" and protocol';
//
//   var uri = 'protocol://some.domain.com/was';
//   var expected =
//   {
//     protocol : 'protocol',
//     longPath : 'some.domain.com/was',
//   }
//
//   var got = _.uriNew.parseFull( uri );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'simple path';
//   var uri = '//';
//   var expected =
//   {
//     longPath : '//',
//   }
//   var got = _.uriNew.parseFull( uri );
//   test.identical( got, expected );
//   /* */
//
//   test.case = 'simple path';
//
//   var uri = '///';
//   var expected =
//   {
//     longPath : '///',
//   }
//
//   var got = _.uriNew.parseFull( uri );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'simple path';
//
//   var uri = '///a/b/c';
//   var expected =
//   {
//     longPath : '///a/b/c',
//   }
//
//   var got = _.uriNew.parseFull( uri );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = '???'; /* qqq : describe cases without description ( short! ) */
//   var uri = 'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor';
//   var expected =
//   {
//     protocol : 'complex+protocol',
//     longPath : 'www.site.com:13/path/name',
//     query : 'query=here&and=here',
//     hash : 'anchor',
//   }
//
//   var got = _.uriNew.parseFull( uri );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = '???';
//   var uri = '://www.site.com:13/path//name//?query=here&and=here#anchor';
//   var got = _.uriNew.parseFull( uri );
//   var expected =
//   {
//     protocol : '',
//     longPath : 'www.site.com:13/path//name//',
//     query : 'query=here&and=here',
//     hash : 'anchor',
//   }
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = '???';
//   var uri = ':///www.site.com:13/path//name//?query=here&and=here#anchor';
//   var got = _.uriNew.parseFull( uri );
//   var expected =
//   {
//     protocol : '',
//     longPath : '/www.site.com:13/path//name//',
//     query : 'query=here&and=here',
//     hash : 'anchor',
//   }
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'not ://, but //';
//
//   var expected =
//   {
//     longPath : '///some.com:99/staging/index.html',
//     query : 'query=here&and=here',
//     hash : 'anchor',
//   }
//   var got = _.uriNew.parseFull( '///some.com:99/staging/index.html?query=here&and=here#anchor' );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'tag and user';
//
//   var expected =
//   {
//     longPath : 'git@bitbucket.org:someorg/somerepo.git',
//     tag : 'tag',
//     protocol : 'git',
//   }
//   var got = _.uriNew.parseFull( 'git://git@bitbucket.org:someorg/somerepo.git!tag' );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = '???';
//
//   var expected =
//   {
//     longPath : '/git@bitbucket.org',
//     protocol : 'git',
//   }
//   var got = _.uriNew.parseFull( 'git:///git@bitbucket.org' );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = '???';
//
//   var expected =
//   {
//     longPath : '/git@bitbucket.org',
//     tag : 'tag',
//     protocol : 'git',
//   }
//   var got = _.uriNew.parseFull( 'git:///git@bitbucket.org!tag' );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = '???';
//
//   var expected =
//   {
//     longPath : '/git@bitbucket.org/somerepo.git',
//     tag : 'tag',
//     protocol : 'git',
//   }
//   var got = _.uriNew.parseFull( 'git:///git@bitbucket.org/somerepo.git!tag' );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = '???';
//
//   var expected =
//   {
//     longPath : '/git@bitbucket.org:someorg/somerepo.git',
//     tag : 'tag',
//     protocol : 'git',
//   }
//   var got = _.uriNew.parseFull( 'git:///git@bitbucket.org:someorg/somerepo.git!tag' );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = '???';
//
//   var expected =
//   {
//     protocol : 'git',
//     longPath : '/git@bitbucket.org:someorg/somerepo.git',
//     hash : 'hash'
//   }
//   var got = _.uriNew.parseFull( 'git:///git@bitbucket.org:someorg/somerepo.git#hash' );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = '???';
//
//   var expected =
//   {
//     protocol : 'git',
//     longPath : '/git@bitbucket.org:someorg/somerepo.git/',
//     hash : 'hash'
//   }
//   var got = _.uriNew.parseFull( 'git:///git@bitbucket.org:someorg/somerepo.git/#hash' );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = '???';
//
//   var expected =
//   {
//     protocol : 'git',
//     longPath : '/somerepo.git',
//     hash : 'hash'
//   }
//   var got = _.uriNew.parseFull( 'git:///somerepo.git#hash' );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = '???';
//
//   var expected =
//   {
//     protocol : 'git',
//     longPath : '/somerepo.git/',
//     hash : 'hash'
//   }
//   var got = _.uriNew.parseFull( 'git:///somerepo.git/#hash' );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = '???';
//
//   var expected =
//   {
//     protocol : 'git',
//     longPath : '/git@bitbucket.org:someorg/somerepo.git/',
//     tag : 'tag',
//   }
//   var got = _.uriNew.parseFull( 'git:///git@bitbucket.org:someorg/somerepo.git/!tag' );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = '???';
//
//   var expected =
//   {
//     protocol : 'git',
//     longPath : '/somerepo.git/',
//     tag : 'tag',
//   }
//   var got = _.uriNew.parseFull( 'git:///somerepo.git/!tag' );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = '???';
//
//   var expected =
//   {
//     protocol : 'git',
//     longPath : '/git@bitbucket.org:someorg/somerepo.git',
//     hash : 'hash',
//     tag : 'tag'
//   }
//   var got = _.uriNew.parseFull( 'git:///git@bitbucket.org:someorg/somerepo.git#hash!tag' );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = '???';
//
//   var expected =
//   {
//     protocol : 'git',
//     longPath : '/git@bitbucket.org:someorg/somerepo.git/',
//     hash : 'hash',
//     tag : 'tag'
//   }
//   var got = _.uriNew.parseFull( 'git:///git@bitbucket.org:someorg/somerepo.git/#hash!tag' );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = '???';
//
//   var expected =
//   {
//     protocol : 'git',
//     longPath : '/somerepo.git',
//     hash : 'hash',
//     tag : 'tag',
//   }
//   var got = _.uriNew.parseFull( 'git:///somerepo.git#hash!tag' );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = '???';
//
//   var expected =
//   {
//     protocol : 'git',
//     longPath : '/somerepo.git/',
//     hash : 'hash',
//     tag : 'tag',
//   }
//   var got = _.uriNew.parseFull( 'git:///somerepo.git/#hash!tag' );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = '???';
//
//   var expected =
//   {
//     protocol : 'git',
//     longPath : '/git@bitbucket.org:someorg/somerepo.git',
//     query : 'query=1',
//     hash : 'hash',
//     tag : 'tag',
//   }
//   var got = _.uriNew.parseFull( 'git:///git@bitbucket.org:someorg/somerepo.git?query=1#hash!tag' );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = '???';
//
//   var expected =
//   {
//     protocol : 'git',
//     longPath : '/git@bitbucket.org:someorg/somerepo.git/',
//     query : 'query=1',
//     hash : 'hash',
//     tag : 'tag',
//   }
//   var got = _.uriNew.parseFull( 'git:///git@bitbucket.org:someorg/somerepo.git/?query=1#hash!tag' );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = '???';
//
//   var expected =
//   {
//     protocol : 'git',
//     longPath : '/somerepo.git',
//     query : 'query=1',
//     hash : 'hash',
//     tag : 'tag',
//   }
//   var got = _.uriNew.parseFull( 'git:///somerepo.git?query=1#hash!tag' );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = '???';
//
//   var expected =
//   {
//     protocol : 'git',
//     longPath : '/somerepo.git/',
//     query : 'query=1',
//     hash : 'hash',
//     tag : 'tag',
//   }
//   var got = _.uriNew.parseFull( 'git:///somerepo.git/?query=1#hash!tag' );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = '???';
//
//   var expected =
//   {
//     protocol : 'git',
//     longPath : '/git@bitbucket.org:someorg/somerepo.git',
//     query : 'query=1',
//     tag : 'tag',
//   }
//   var got = _.uriNew.parseFull( 'git:///git@bitbucket.org:someorg/somerepo.git?query=1!tag' );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = '???';
//
//   var expected =
//   {
//     protocol : 'git',
//     longPath : '/git@bitbucket.org:someorg/somerepo.git/',
//     query : 'query=1',
//     tag : 'tag',
//   }
//   var got = _.uriNew.parseFull( 'git:///git@bitbucket.org:someorg/somerepo.git/?query=1!tag' );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = '???';
//
//   var expected =
//   {
//     protocol : 'git',
//     longPath : '/somerepo.git',
//     query : 'query=1',
//     tag : 'tag',
//   }
//   var got = _.uriNew.parseFull( 'git:///somerepo.git?query=1!tag' );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = '???';
//
//   var expected =
//   {
//     protocol : 'git',
//     longPath : '/somerepo.git/',
//     query : 'query=1',
//     tag : 'tag',
//   }
//   var got = _.uriNew.parseFull( 'git:///somerepo.git/?query=1!tag' );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = '# @ ?';
//   var expected =
//   {
//     longPath : '',
//     query : 'query1',
//     tag : 'tag1/',
//     hash : 'hash1/',
//     protocol : '',
//   }
//   var got = _.uriNew.parseFull( '://#hash1/!tag1/?query1' );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'escaped # @ ?';
//   var expected =
//   {
//     longPath : '"#hash1"/"!tag1"/"?query1"',
//     protocol : '',
//   }
//   var got = _.uriNew.parseFull( '://"#hash1"/"!tag1"/"?query1"' );
//   test.identical( got, expected );
//
//   /* - */
//
//   if( !Config.debug )
//   return;
//
//   test.case = 'missed arguments';
//   test.shouldThrowErrorSync( function()
//   {
//     _.uriNew.parseFull();
//   });
//
//   test.case = 'redundant argument';
//   test.shouldThrowErrorSync( function()
//   {
//     _.uriNew.parseFull( 'http://www.site.com:13/path/name?query=here&and=here#anchor', '' );
//   });
//
//   test.case = 'argument is not string';
//   test.shouldThrowErrorSync( function()
//   {
//     _.uriNew.parseFull( 34 );
//   });
//
// }
//
// //
//
// function parseFull2( test )
// {
//
//   /* */
//
//   test.case = 'query only';
//   var src = '?entry:1&format:null';
//   var expected =
//   {
//     'resourcePath' : '',
//     'query' : 'entry:1&format:null',
//     'longPath' : '',
//     'postfixedPath' : '?entry:1&format:null',
//     'protocols' : [],
//     'full' : '?entry:1&format:null'
//   }
//   var got = _.uriNew.parseFull( src );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'global, relative, with hash, with query';
//   var src = "git://../repo/Tools?out=out/wTools.out.will#master"
//   var expected =
//   {
//     'protocol' : 'git',
//     'host' : '..',
//     'resourcePath' : '/repo/Tools',
//     'query' : 'out=out/wTools.out.will',
//     'hash' : 'master',
//     'longPath' : '../repo/Tools',
//     'postfixedPath' : '../repo/Tools?out=out/wTools.out.will#master',
//     'protocols' : [ 'git' ],
//     'hostFull' : '..',
//     'origin' : 'git://..',
//     'full' : 'git://../repo/Tools?out=out/wTools.out.will#master'
//   }
//   var got = _.uriNew.parseFull( src );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'global, absolute, with hash, with query';
//   var src = "git:///../repo/Tools?out=out/wTools.out.will#master"
//   var expected =
//   {
//     'protocol' : 'git',
//     'host' : '',
//     'resourcePath' : '/../repo/Tools',
//     'query' : 'out=out/wTools.out.will',
//     'hash' : 'master',
//     'longPath' : '/../repo/Tools',
//     'postfixedPath' : '/../repo/Tools?out=out/wTools.out.will#master',
//     'protocols' : [ 'git' ],
//     'hostFull' : '',
//     'origin' : 'git://',
//     'full' : 'git:///../repo/Tools?out=out/wTools.out.will#master'
//   }
//   var got = _.uriNew.parseFull( src );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'query with equal';
//   var src = 'http://127.0.0.1:5000/a/b?q=3#anch';
//   var expected =
//   {
//     'protocol' : 'http',
//     'host' : '127.0.0.1',
//     'port' : 5000,
//     'resourcePath' : '/a/b',
//     'query' : 'q=3',
//     'hash' : 'anch',
//     'longPath' : '127.0.0.1:5000/a/b',
//     'postfixedPath' : '127.0.0.1:5000/a/b?q=3#anch',
//     'protocols' : [ 'http' ],
//     'hostFull' : '127.0.0.1:5000',
//     'origin' : 'http://127.0.0.1:5000',
//     'full' : 'http://127.0.0.1:5000/a/b?q=3#anch'
//   }
//   var got = _.uriNew.parseFull( src );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'query with colon';
//   var src = 'http://127.0.0.1:5000/a/b?q:3#anch';
//   var expected =
//   {
//     'protocol' : 'http',
//     'host' : '127.0.0.1',
//     'port' : 5000,
//     'resourcePath' : '/a/b',
//     'query' : 'q:3',
//     'hash' : 'anch',
//     'longPath' : '127.0.0.1:5000/a/b',
//     'postfixedPath' : '127.0.0.1:5000/a/b?q:3#anch',
//     'protocols' : [ 'http' ],
//     'hostFull' : '127.0.0.1:5000',
//     'origin' : 'http://127.0.0.1:5000',
//     'full' : 'http://127.0.0.1:5000/a/b?q:3#anch'
//   }
//   var got = _.uriNew.parseFull( src );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'no protocol';
//   var uri = '127.0.0.1:61726/../path';
//   var expected =
//   {
//     resourcePath : '127.0.0.1:61726/../path',
//     longPath : '127.0.0.1:61726/../path',
//     postfixedPath : '127.0.0.1:61726/../path',
//     protocols : [],
//     full : '127.0.0.1:61726/../path'
//   }
//   var got = _.uriNew.parseFull( uri );
//   test.identical( got, expected );
//
//   var expected =
//   {
//     'resourcePath' : '127.0.0.1:61726/../path',
//     'longPath' : '127.0.0.1:61726/../path',
//     'postfixedPath' : '127.0.0.1:61726/../path',
//     'protocols' : [],
//     'full' : '127.0.0.1:61726/../path'
//   }
//   var got = _.uriNew.parseFull( uri );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'full uri with all components';
//
//   var expected =
//   {
//     protocol : 'http',
//     host : 'www.site.com',
//     port : 13,
//     resourcePath : '/path/name',
//     query : 'query=here&and=here',
//     hash : 'anchor',
//     longPath : 'www.site.com:13/path/name',
//     postfixedPath : 'www.site.com:13/path/name?query=here&and=here#anchor',
//     protocols : [ 'http' ],
//     hostFull : 'www.site.com:13',
//     origin : 'http://www.site.com:13',
//     full : 'http://www.site.com:13/path/name?query=here&and=here#anchor',
//   }
//
//   var uri1 = 'http://www.site.com:13/path/name?query=here&and=here#anchor';
//   var got = _.uriNew.parseFull( uri1 );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'full uri with all components, primitiveOnly';
//
//   var expected =
//   {
//     'protocol' : 'http',
//     'host' : 'www.site.com',
//     'port' : 13,
//     'resourcePath' : '/path/name',
//     'query' : 'query=here&and=here',
//     'hash' : 'anchor',
//     'longPath' : 'www.site.com:13/path/name',
//     'postfixedPath' : 'www.site.com:13/path/name?query=here&and=here#anchor',
//     'protocols' : [ 'http' ],
//     'hostFull' : 'www.site.com:13',
//     'origin' : 'http://www.site.com:13',
//     'full' : 'http://www.site.com:13/path/name?query=here&and=here#anchor'
//   }
//   var uri1 = 'http://www.site.com:13/path/name?query=here&and=here#anchor';
//   var got = _.uriNew.parseFull( uri1 );
//   test.identical( got, expected );
//
//   test.case = 'reparse with non primitives';
//
//   var expected =
//   {
//     protocol : 'http',
//     host : 'www.site.com',
//     port : 13,
//     resourcePath : '/path/name',
//     query : 'query=here&and=here',
//     hash : 'anchor',
//
//     longPath : 'www.site.com:13/path/name',
//     postfixedPath : 'www.site.com:13/path/name?query=here&and=here#anchor',
//     protocols : [ 'http' ],
//     hostFull : 'www.site.com:13',
//     origin : 'http://www.site.com:13',
//     full : 'http://www.site.com:13/path/name?query=here&and=here#anchor',
//   }
//
//   var parsed = got;
//   var got = _.uriNew.parseFull( parsed );
//   test.identical( got, expected );
//
//   test.case = 'reparse with primitives';
//
//   var uri1 = 'http://www.site.com:13/path/name?query=here&and=here#anchor';
//   var expected =
//   {
//     'protocol' : 'http',
//     'host' : 'www.site.com',
//     'port' : 13,
//     'resourcePath' : '/path/name',
//     'query' : 'query=here&and=here',
//     'hash' : 'anchor',
//     'longPath' : 'www.site.com:13/path/name',
//     'postfixedPath' : 'www.site.com:13/path/name?query=here&and=here#anchor',
//     'protocols' : [ 'http' ],
//     'hostFull' : 'www.site.com:13',
//     'origin' : 'http://www.site.com:13',
//     'full' : 'http://www.site.com:13/path/name?query=here&and=here#anchor'
//   }
//   var got = _.uriNew.parseFull( uri1 );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'uri with zero length protocol';
//
//   var uri = '://some.domain.com/something/filePath/add';
//
//   var expected =
//   {
//     protocol : '',
//     host : 'some.domain.com',
//     resourcePath : '/something/filePath/add',
//     longPath : 'some.domain.com/something/filePath/add',
//     postfixedPath : 'some.domain.com/something/filePath/add',
//     protocols : [],
//     hostFull : 'some.domain.com',
//     origin : '://some.domain.com',
//     full : '://some.domain.com/something/filePath/add',
//   }
//
//   var got = _.uriNew.parseFull( uri );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'uri with zero length hostFull';
//
//   var uri = 'file:///something/filePath/add';
//
//   var expected =
//   {
//     protocol : 'file',
//     host : '',
//     resourcePath : '/something/filePath/add',
//     longPath : '/something/filePath/add',
//     postfixedPath : '/something/filePath/add',
//     protocols : [ 'file' ],
//     hostFull : '',
//     origin : 'file://',
//     full : 'file:///something/filePath/add',
//   }
//
//   var got = _.uriNew.parseFull( uri );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'uri with double protocol';
//
//   var uri = 'svn+https://user@subversion.com/svn/trunk';
//
//   var expected =
//   {
//     protocol : 'svn+https',
//     host : 'user@subversion.com',
//     resourcePath : '/svn/trunk',
//     longPath : 'user@subversion.com/svn/trunk',
//     postfixedPath : 'user@subversion.com/svn/trunk',
//     protocols : [ 'svn', 'https' ],
//     hostFull : 'user@subversion.com',
//     origin : 'svn+https://user@subversion.com',
//     full : 'svn+https://user@subversion.com/svn/trunk',
//   }
//
//   var got = _.uriNew.parseFull( uri );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'simple path';
//
//   var uri = '/some/file';
//
//   var expected =
//   {
//     resourcePath : '/some/file',
//     longPath : '/some/file',
//     postfixedPath : '/some/file',
//     protocols : [],
//     full : '/some/file',
//   }
//
//   var got = _.uriNew.parseFull( uri );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'without ":"';
//
//   var uri = '//some.domain.com/was';
//   var expected =
//   {
//     resourcePath : '//some.domain.com/was',
//     longPath : '//some.domain.com/was',
//     postfixedPath : '//some.domain.com/was',
//     protocols : [],
//     full : '//some.domain.com/was'
//   }
//
//   var got = _.uriNew.parseFull( uri );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'with ":"';
//
//   var uri = '://some.domain.com/was';
//   var expected =
//   {
//     protocol : '',
//     host : 'some.domain.com',
//     resourcePath : '/was',
//     longPath : 'some.domain.com/was',
//     postfixedPath : 'some.domain.com/was',
//     protocols : [ '' ],
//     hostFull : 'some.domain.com',
//     origin : '://some.domain.com',
//     full : '://some.domain.com/was'
//   }
//
//   /* */
//
//   test.case = 'with ":" and protocol';
//
//   var uri = 'protocol://some.domain.com/was';
//   var expected =
//   {
//     protocol : 'protocol',
//     host : 'some.domain.com',
//     resourcePath : '/was',
//     longPath : 'some.domain.com/was',
//     postfixedPath : 'some.domain.com/was',
//     protocols : [ 'protocol' ],
//     hostFull : 'some.domain.com',
//     origin : 'protocol://some.domain.com',
//     full : 'protocol://some.domain.com/was'
//   }
//
//   var got = _.uriNew.parseFull( uri );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'simple path';
//
//   var uri = '//';
//   var expected =
//   {
//     resourcePath : '//',
//     longPath : '//',
//     postfixedPath : '//',
//     protocols : [],
//     full : '//'
//   }
//
//   var got = _.uriNew.parseFull( uri );
//   test.identical( got, expected );
//
//   var uri = '///';
//   var expected =
//   {
//     resourcePath : '///',
//     longPath : '///',
//     postfixedPath : '///',
//     protocols : [],
//     full : '///'
//   }
//
//   var got = _.uriNew.parseFull( uri );
//   test.identical( got, expected );
//
//   var uri = '///a/b/c';
//   var expected =
//   {
//     resourcePath : '///a/b/c',
//     longPath : '///a/b/c',
//     postfixedPath : '///a/b/c',
//     protocols : [],
//     full : '///a/b/c'
//   }
//
//   var got = _.uriNew.parseFull( uri );
//   test.identical( got, expected );
//
//   test.case = '???';
//   var uri = 'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor';
//   var expected =
//   {
//     protocol : 'complex+protocol',
//     host : 'www.site.com',
//     port : 13,
//     resourcePath : '/path/name',
//     query : 'query=here&and=here',
//     hash : 'anchor',
//     longPath : 'www.site.com:13/path/name',
//     postfixedPath : 'www.site.com:13/path/name?query=here&and=here#anchor',
//     protocols : [ 'complex', 'protocol' ],
//     hostFull : 'www.site.com:13',
//     origin : 'complex+protocol://www.site.com:13',
//     full : uri,
//   }
//
//   var got = _.uriNew.parseFull( uri );
//   test.identical( got, expected );
//
//   var uri = '://www.site.com:13/path//name//?query=here&and=here#anchor';
//   var got = _.uriNew.parseFull( uri );
//   var expected =
//   {
//     protocol : '',
//     host : 'www.site.com',
//     port : 13,
//     resourcePath : '/path//name//',
//     query : 'query=here&and=here',
//     hash : 'anchor',
//     longPath : 'www.site.com:13/path//name//',
//     postfixedPath : 'www.site.com:13/path//name//?query=here&and=here#anchor',
//     protocols : [],
//     hostFull : 'www.site.com:13',
//     origin : '://www.site.com:13',
//     full : uri,
//   }
//   test.identical( got, expected );
//
//   var uri = '://www.site.com:13/path//name//?query=here&and=here#anchor';
//   var got = _.uriNew.parseFull( uri );
//   var expected =
//   {
//     'protocol' : '',
//     'host' : 'www.site.com',
//     'port' : 13,
//     'resourcePath' : '/path//name//',
//     'query' : 'query=here&and=here',
//     'hash' : 'anchor',
//     'longPath' : 'www.site.com:13/path//name//',
//     'postfixedPath' : 'www.site.com:13/path//name//?query=here&and=here#anchor',
//     'protocols' : [],
//     'hostFull' : 'www.site.com:13',
//     'origin' : '://www.site.com:13',
//     'full' : '://www.site.com:13/path//name//?query=here&and=here#anchor'
//   }
//   test.identical( got, expected );
//
//   var uri = ':///www.site.com:13/path//name//?query=here&and=here#anchor';
//   var got = _.uriNew.parseFull( uri );
//   var expected =
//   {
//     protocol : '',
//     host : '',
//     resourcePath : '/www.site.com:13/path//name//',
//     query : 'query=here&and=here',
//     hash : 'anchor',
//     protocols : [],
//     hostFull : '',
//     origin : '://',
//     full : uri,
//     longPath : '/www.site.com:13/path//name//',
//     postfixedPath : '/www.site.com:13/path//name//?query=here&and=here#anchor',
//   }
//   test.identical( got, expected );
//
//   var uri = ':///www.site.com:13/path//name//?query=here&and=here#anchor';
//   var got = _.uriNew.parseFull( uri );
//   var expected =
//   {
//     'protocol' : '',
//     'host' : '',
//     'resourcePath' : '/www.site.com:13/path//name//',
//     'query' : 'query=here&and=here',
//     'hash' : 'anchor',
//     'longPath' : '/www.site.com:13/path//name//',
//     'postfixedPath' : '/www.site.com:13/path//name//?query=here&and=here#anchor',
//     'protocols' : [],
//     'hostFull' : '',
//     'origin' : '://',
//     'full' : ':///www.site.com:13/path//name//?query=here&and=here#anchor'
//   }
//   test.identical( got, expected );
//
//   /* */
//
//   var expected =
//   {
//     resourcePath : '///some.com:99/staging/index.html',
//     query : 'query=here&and=here',
//     hash : 'anchor',
//     longPath : '///some.com:99/staging/index.html',
//     postfixedPath : '///some.com:99/staging/index.html?query=here&and=here#anchor',
//     protocols : [],
//     full : '///some.com:99/staging/index.html?query=here&and=here#anchor',
//   }
//   var got = _.uriNew.parseFull( '///some.com:99/staging/index.html?query=here&and=here#anchor' );
//   test.identical( got, expected );
//
//   /* */
//
//   var expected =
//   {
//     protocol : 'git',
//     host : '',
//     resourcePath : '/git@bitbucket.org:someorg/somerepo.git',
//     longPath : '/git@bitbucket.org:someorg/somerepo.git',
//     postfixedPath : '/git@bitbucket.org:someorg/somerepo.git!tag',
//     protocols : [ 'git' ],
//     hostFull : '',
//     tag : 'tag',
//     origin : 'git://',
//     full : 'git:///git@bitbucket.org:someorg/somerepo.git!tag'
//   }
//   var got = _.uriNew.parseFull( 'git:///git@bitbucket.org:someorg/somerepo.git!tag' );
//   test.identical( got, expected );
//
//   var expected =
//   {
//     protocol : 'git',
//     host : '',
//     resourcePath : '/git@bitbucket.org:someorg/somerepo.git',
//     hash : 'hash',
//     longPath : '/git@bitbucket.org:someorg/somerepo.git',
//     postfixedPath : '/git@bitbucket.org:someorg/somerepo.git#hash',
//     protocols : [ 'git' ],
//     hostFull : '',
//     origin : 'git://',
//     full : 'git:///git@bitbucket.org:someorg/somerepo.git#hash'
//   }
//   var got = _.uriNew.parseFull( 'git:///git@bitbucket.org:someorg/somerepo.git#hash' );
//   test.identical( got, expected );
//
//   var expected =
//   {
//     protocol : 'git',
//     host : '',
//     resourcePath : '/git@bitbucket.org:someorg/somerepo.git/',
//     hash : 'hash',
//     longPath : '/git@bitbucket.org:someorg/somerepo.git/',
//     postfixedPath : '/git@bitbucket.org:someorg/somerepo.git/#hash',
//     protocols : [ 'git' ],
//     hostFull : '',
//     origin : 'git://',
//     full : 'git:///git@bitbucket.org:someorg/somerepo.git/#hash'
//   }
//   var got = _.uriNew.parseFull( 'git:///git@bitbucket.org:someorg/somerepo.git/#hash' );
//   test.identical( got, expected );
//
//   var expected =
//   {
//     protocol : 'git',
//     host : '',
//     resourcePath : '/somerepo.git',
//     hash : 'hash',
//     longPath : '/somerepo.git',
//     postfixedPath : '/somerepo.git#hash',
//     protocols : [ 'git' ],
//     hostFull : '',
//     origin : 'git://',
//     full : 'git:///somerepo.git#hash'
//   }
//   var got = _.uriNew.parseFull( 'git:///somerepo.git#hash' );
//   test.identical( got, expected );
//
//   var expected =
//   {
//     protocol : 'git',
//     host : '',
//     resourcePath : '/somerepo.git/',
//     hash : 'hash',
//     longPath : '/somerepo.git/',
//     postfixedPath : '/somerepo.git/#hash',
//     protocols : [ 'git' ],
//     hostFull : '',
//     origin : 'git://',
//     full : 'git:///somerepo.git/#hash'
//   }
//   var got = _.uriNew.parseFull( 'git:///somerepo.git/#hash' );
//   test.identical( got, expected );
//
//   var expected =
//   {
//     protocol : 'git',
//     host : '',
//     resourcePath : '/git@bitbucket.org:someorg/somerepo.git/',
//     tag : 'tag',
//     longPath : '/git@bitbucket.org:someorg/somerepo.git/',
//     postfixedPath : '/git@bitbucket.org:someorg/somerepo.git/!tag',
//     protocols : [ 'git' ],
//     hostFull : '',
//     origin : 'git://',
//     full : 'git:///git@bitbucket.org:someorg/somerepo.git/!tag'
//   }
//   var got = _.uriNew.parseFull( 'git:///git@bitbucket.org:someorg/somerepo.git/!tag' );
//   test.identical( got, expected );
//
//   var expected =
//   {
//     protocol : 'git',
//     host : '',
//     resourcePath : '/somerepo.git/',
//     tag : 'tag',
//     longPath : '/somerepo.git/',
//     postfixedPath : '/somerepo.git/!tag',
//     protocols : [ 'git' ],
//     hostFull : '',
//     origin : 'git://',
//     full : 'git:///somerepo.git/!tag'
//   }
//   var got = _.uriNew.parseFull( 'git:///somerepo.git/!tag' );
//   test.identical( got, expected );
//
//   var expected =
//   {
//     protocol : 'git',
//     host : '',
//     resourcePath : '/git@bitbucket.org:someorg/somerepo.git',
//     hash : 'hash',
//     tag : 'tag',
//     longPath : '/git@bitbucket.org:someorg/somerepo.git',
//     postfixedPath : '/git@bitbucket.org:someorg/somerepo.git#hash!tag',
//     protocols : [ 'git' ],
//     hostFull : '',
//     origin : 'git://',
//     full : 'git:///git@bitbucket.org:someorg/somerepo.git#hash!tag'
//   }
//   var got = _.uriNew.parseFull( 'git:///git@bitbucket.org:someorg/somerepo.git#hash!tag' );
//   test.identical( got, expected );
//
//   var expected =
//   {
//     protocol : 'git',
//     host : '',
//     resourcePath : '/git@bitbucket.org:someorg/somerepo.git/',
//     hash : 'hash',
//     tag : 'tag',
//     longPath : '/git@bitbucket.org:someorg/somerepo.git/',
//     postfixedPath : '/git@bitbucket.org:someorg/somerepo.git/#hash!tag',
//     protocols : [ 'git' ],
//     hostFull : '',
//     origin : 'git://',
//     full : 'git:///git@bitbucket.org:someorg/somerepo.git/#hash!tag'
//   }
//   var got = _.uriNew.parseFull( 'git:///git@bitbucket.org:someorg/somerepo.git/#hash!tag' );
//   test.identical( got, expected );
//
//   var expected =
//   {
//     protocol : 'git',
//     host : '',
//     resourcePath : '/somerepo.git',
//     hash : 'hash',
//     tag : 'tag',
//     longPath : '/somerepo.git',
//     postfixedPath : '/somerepo.git#hash!tag',
//     protocols : [ 'git' ],
//     hostFull : '',
//     origin : 'git://',
//     full : 'git:///somerepo.git#hash!tag'
//   }
//   var got = _.uriNew.parseFull( 'git:///somerepo.git#hash!tag' );
//   test.identical( got, expected );
//
//   var expected =
//   {
//     protocol : 'git',
//     host : '',
//     resourcePath : '/somerepo.git/',
//     hash : 'hash',
//     tag : 'tag',
//     longPath : '/somerepo.git/',
//     postfixedPath : '/somerepo.git/#hash!tag',
//     protocols : [ 'git' ],
//     hostFull : '',
//     origin : 'git://',
//     full : 'git:///somerepo.git/#hash!tag'
//   }
//   var got = _.uriNew.parseFull( 'git:///somerepo.git/#hash!tag' );
//   test.identical( got, expected );
//
//   var expected =
//   {
//     protocol : 'git',
//     host : '',
//     resourcePath : '/git@bitbucket.org:someorg/somerepo.git',
//     query : 'query=1',
//     hash : 'hash',
//     tag : 'tag',
//     longPath : '/git@bitbucket.org:someorg/somerepo.git',
//     postfixedPath : '/git@bitbucket.org:someorg/somerepo.git?query=1#hash!tag',
//     protocols : [ 'git' ],
//     hostFull : '',
//     origin : 'git://',
//     full : 'git:///git@bitbucket.org:someorg/somerepo.git?query=1#hash!tag'
//   }
//   var got = _.uriNew.parseFull( 'git:///git@bitbucket.org:someorg/somerepo.git?query=1#hash!tag' );
//   test.identical( got, expected );
//
//   var expected =
//   {
//     protocol : 'git',
//     host : '',
//     resourcePath : '/git@bitbucket.org:someorg/somerepo.git/',
//     query : 'query=1',
//     hash : 'hash',
//     tag : 'tag',
//     longPath : '/git@bitbucket.org:someorg/somerepo.git/',
//     postfixedPath : '/git@bitbucket.org:someorg/somerepo.git/?query=1#hash!tag',
//     protocols : [ 'git' ],
//     hostFull : '',
//     origin : 'git://',
//     full : 'git:///git@bitbucket.org:someorg/somerepo.git/?query=1#hash!tag'
//   }
//   var got = _.uriNew.parseFull( 'git:///git@bitbucket.org:someorg/somerepo.git/?query=1#hash!tag' );
//   test.identical( got, expected );
//
//   var expected =
//   {
//     protocol : 'git',
//     host : '',
//     resourcePath : '/somerepo.git',
//     query : 'query=1',
//     hash : 'hash',
//     tag : 'tag',
//     longPath : '/somerepo.git',
//     postfixedPath : '/somerepo.git?query=1#hash!tag',
//     protocols : [ 'git' ],
//     hostFull : '',
//     origin : 'git://',
//     full : 'git:///somerepo.git?query=1#hash!tag'
//   }
//   var got = _.uriNew.parseFull( 'git:///somerepo.git?query=1#hash!tag' );
//   test.identical( got, expected );
//
//   var expected =
//   {
//     protocol : 'git',
//     host : '',
//     resourcePath : '/somerepo.git/',
//     query : 'query=1',
//     hash : 'hash',
//     tag : 'tag',
//     longPath : '/somerepo.git/',
//     postfixedPath : '/somerepo.git/?query=1#hash!tag',
//     protocols : [ 'git' ],
//     hostFull : '',
//     origin : 'git://',
//     full : 'git:///somerepo.git/?query=1#hash!tag'
//   }
//   var got = _.uriNew.parseFull( 'git:///somerepo.git/?query=1#hash!tag' );
//   test.identical( got, expected );
//
//   var expected =
//   {
//     protocol : 'git',
//     host : '',
//     resourcePath : '/git@bitbucket.org:someorg/somerepo.git',
//     query : 'query=1',
//     tag : 'tag',
//     longPath : '/git@bitbucket.org:someorg/somerepo.git',
//     postfixedPath : '/git@bitbucket.org:someorg/somerepo.git?query=1!tag',
//     protocols : [ 'git' ],
//     hostFull : '',
//     origin : 'git://',
//     full : 'git:///git@bitbucket.org:someorg/somerepo.git?query=1!tag'
//   }
//   var got = _.uriNew.parseFull( 'git:///git@bitbucket.org:someorg/somerepo.git?query=1!tag' );
//   test.identical( got, expected );
//
//   var expected =
//   {
//     protocol : 'git',
//     host : '',
//     resourcePath : '/git@bitbucket.org:someorg/somerepo.git/',
//     query : 'query=1',
//     tag : 'tag',
//     longPath : '/git@bitbucket.org:someorg/somerepo.git/',
//     postfixedPath : '/git@bitbucket.org:someorg/somerepo.git/?query=1!tag',
//     protocols : [ 'git' ],
//     hostFull : '',
//     origin : 'git://',
//     full : 'git:///git@bitbucket.org:someorg/somerepo.git/?query=1!tag'
//   }
//   var got = _.uriNew.parseFull( 'git:///git@bitbucket.org:someorg/somerepo.git/?query=1!tag' );
//   test.identical( got, expected );
//
//   var expected =
//   {
//     protocol : 'git',
//     host : '',
//     resourcePath : '/somerepo.git',
//     query : 'query=1',
//     tag : 'tag',
//     longPath : '/somerepo.git',
//     postfixedPath : '/somerepo.git?query=1!tag',
//     protocols : [ 'git' ],
//     hostFull : '',
//     origin : 'git://',
//     full : 'git:///somerepo.git?query=1!tag'
//   }
//   var got = _.uriNew.parseFull( 'git:///somerepo.git?query=1!tag' );
//   test.identical( got, expected );
//
//
//   var expected =
//   {
//     protocol : 'git',
//     host : '',
//     resourcePath : '/somerepo.git/',
//     query : 'query=1',
//     tag : 'tag',
//     longPath : '/somerepo.git/',
//     postfixedPath : '/somerepo.git/?query=1!tag',
//     protocols : [ 'git' ],
//     hostFull : '',
//     origin : 'git://',
//     full : 'git:///somerepo.git/?query=1!tag'
//   }
//   var got = _.uriNew.parseFull( 'git:///somerepo.git/?query=1!tag' );
//   test.identical( got, expected );
//
//   /* - */
//
//   if( !Config.debug )
//   return;
//
//   test.case = 'missed arguments';
//   test.shouldThrowErrorSync( function()
//   {
//     _.uriNew.parseFull();
//   });
//
//   test.case = 'redundant argument';
//   test.shouldThrowErrorSync( function()
//   {
//     _.uriNew.parseFull( 'http://www.site.com:13/path/name?query=here&and=here#anchor', '' );
//   });
//
//   test.case = 'argument is not string';
//   test.shouldThrowErrorSync( function()
//   {
//     _.uriNew.parseFull( 34 );
//   });
//
// }
//
// //
//
// function parseConsecutive( test )
// {
//
//   /* */
//
//   test.case = 'query only';
//   var src = '?entry:1&format:null';
//   var expected = { 'longPath' : '', 'query' : 'entry:1&format:null' }
//   var got = _.uriNew.parseConsecutive( src );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'global, relative, with hash, with query';
//   var src = 'git://../repo/Tools?out=out/wTools.out.will#master';
//   var expected =
//   {
//     'protocol' : 'git',
//     'longPath' : '../repo/Tools',
//     'query' : 'out=out/wTools.out.will',
//     'hash' : 'master'
//   }
//   var got = _.uriNew.parseConsecutive( src );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'global, absolute, with hash, with query';
//   var src = "git:///../repo/Tools?out=out/wTools.out.will#master"
//   var expected =
//   {
//     'protocol' : 'git',
//     'longPath' : '/../repo/Tools',
//     'query' : 'out=out/wTools.out.will',
//     'hash' : 'master'
//   }
//   var got = _.uriNew.parseConsecutive( src );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'query with equal. relative';
//   var src = 'http://127.0.0.1:5000/a/b?q=3#anch';
//   var expected =
//   {
//     'protocol' : 'http',
//     'longPath' : '127.0.0.1:5000/a/b',
//     'query' : 'q=3',
//     'hash' : 'anch'
//   }
//   var got = _.uriNew.parseConsecutive( src );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'query with equal. absolute';
//   var src = 'http:///127.0.0.1:5000/a/b?q=3#anch';
//   var expected =
//   {
//     'protocol' : 'http',
//     'longPath' : '/127.0.0.1:5000/a/b',
//     'query' : 'q=3',
//     'hash' : 'anch'
//   }
//   var got = _.uriNew.parseConsecutive( src );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'query with colon. relative';
//   var src = 'http://127.0.0.1:5000/a/b?q:3#anch';
//   var expected =
//   {
//     'protocol' : 'http',
//     'longPath' : '127.0.0.1:5000/a/b',
//     'query' : 'q:3',
//     'hash' : 'anch'
//   }
//   var got = _.uriNew.parseConsecutive( src );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'query with colon. absolute';
//   var src = 'http:///127.0.0.1:5000/a/b?q:3#anch';
//   var expected =
//   {
//     'protocol' : 'http',
//     'longPath' : '/127.0.0.1:5000/a/b',
//     'query' : 'q:3',
//     'hash' : 'anch'
//   }
//   var got = _.uriNew.parseConsecutive( src );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'no protocol';
//   var uri = '127.0.0.1:61726/../path';
//   var expected =
//   {
//     longPath : '127.0.0.1:61726/../path',
//   }
//   var got = _.uriNew.parseConsecutive( uri );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'full uri with all components';
//   var expected =
//   {
//     protocol : 'http',
//     longPath : 'www.site.com:13/path/name',
//     query : 'query=here&and=here',
//     hash : 'anchor',
//   }
//   var uri1 = 'http://www.site.com:13/path/name?query=here&and=here#anchor';
//   var got = _.uriNew.parseConsecutive( uri1 );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'full uri with all components, primitiveOnly';
//
//   var expected =
//   {
//     protocol : 'http',
//     longPath : 'www.site.com:13/path/name',
//     query : 'query=here&and=here',
//     hash : 'anchor',
//   }
//
//   var uri1 = 'http://www.site.com:13/path/name?query=here&and=here#anchor';
//   var got = _.uriNew.parseConsecutive( uri1 );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'reparse with non primitives';
//
//   var expected =
//   {
//     protocol : 'http',
//     longPath : 'www.site.com:13/path/name',
//     query : 'query=here&and=here',
//     hash : 'anchor',
//   }
//
//   var parsed = got;
//   var got = _.uriNew.parseConsecutive( parsed );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'reparse with primitives';
//
//   var uri1 = 'http://www.site.com:13/path/name?query=here&and=here#anchor';
//   var expected =
//   {
//     protocol : 'http',
//     longPath : 'www.site.com:13/path/name',
//     query : 'query=here&and=here',
//     hash : 'anchor',
//   }
//
//   var got = _.uriNew.parseConsecutive( uri1 );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'uri with zero length protocol';
//   var uri = '://some.domain.com/something/filePath/add';
//   var expected =
//   {
//     protocol : '',
//     longPath : 'some.domain.com/something/filePath/add',
//   }
//   var got = _.uriNew.parseConsecutive( uri );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'uri with zero length hostFull';
//   var uri = 'file:///something/filePath/add';
//   var expected =
//   {
//     protocol : 'file',
//     longPath : '/something/filePath/add',
//   }
//   var got = _.uriNew.parseConsecutive( uri );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'uri with double protocol, user';
//   var uri = 'svn+https://user@subversion.com:13/svn/trunk';
//   var expected =
//   {
//     protocol : 'svn+https',
//     longPath : 'user@subversion.com:13/svn/trunk',
//   }
//   var got = _.uriNew.parseConsecutive( uri );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'uri with double protocol, user. full';
//   var uri = 'svn+https://user@subversion.com:13/svn/trunk';
//   var expected =
//   {
//     protocol : 'svn+https',
//     host : 'subversion.com',
//     port : 13,
//     user : 'user',
//     hostFull : 'user@subversion.com:13',
//     longPath : 'user@subversion.com:13/svn/trunk',
//     protocols : [ 'svn', 'https' ],
//     origin : 'svn+https://user@subversion.com:13',
//     postfixedPath : 'user@subversion.com:13/svn/trunk',
//     resourcePath : 'svn/trunk',
//     full : 'svn+https://user@subversion.com:13/svn/trunk',
//   }
//   var got = _.uriNew.parseFull( uri );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'uri with double protocol, user and tag';
//   var uri = 'svn+https://user@subversion.com:13/svn/trunk!tag1';
//   var expected =
//   {
//     protocol : 'svn+https',
//     longPath : 'user@subversion.com:13/svn/trunk',
//     tag : 'tag1',
//   }
//   var got = _.uriNew.parseConsecutive( uri );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'uri with double protocol, user and tag. full';
//   var uri = 'svn+https://user@subversion.com:13/svn/trunk!tag1';
//   var expected =
//   {
//     protocol : 'svn+https',
//     host : 'subversion.com',
//     user : 'user',
//     port : 13,
//     hostFull : 'user@subversion.com:13',
//     longPath : 'user@subversion.com:13/svn/trunk',
//     tag : 'tag1',
//     protocols : [ 'svn', 'https' ],
//     origin : 'svn+https://user@subversion.com:13',
//     postfixedPath : 'user@subversion.com:13/svn/trunk!tag1',
//     resourcePath : 'svn/trunk',
//     full : 'svn+https://user@subversion.com:13/svn/trunk!tag1',
//   }
//   var got = _.uriNew.parseFull( uri );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'simple path';
//   var uri = '/some/file';
//   var expected =
//   {
//     longPath : '/some/file',
//   }
//   var got = _.uriNew.parseConsecutive( uri );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'without ":"';
//   var uri = '//some.domain.com/was';
//   var expected =
//   {
//     longPath : '//some.domain.com/was',
//   }
//   var got = _.uriNew.parseConsecutive( uri );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'with ":" and protocol';
//
//   var uri = 'protocol://some.domain.com/was';
//   var expected =
//   {
//     protocol : 'protocol',
//     longPath : 'some.domain.com/was',
//   }
//
//   var got = _.uriNew.parseConsecutive( uri );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'simple path';
//   var uri = '//';
//   var expected =
//   {
//     longPath : '//',
//   }
//   var got = _.uriNew.parseConsecutive( uri );
//   test.identical( got, expected );
//   /* */
//
//   test.case = 'simple path';
//
//   var uri = '///';
//   var expected =
//   {
//     longPath : '///',
//   }
//
//   var got = _.uriNew.parseConsecutive( uri );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'simple path';
//
//   var uri = '///a/b/c';
//   var expected =
//   {
//     longPath : '///a/b/c',
//   }
//
//   var got = _.uriNew.parseConsecutive( uri );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = '???'; /* qqq : describe cases without description ( short! ) */
//   var uri = 'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor';
//   var expected =
//   {
//     protocol : 'complex+protocol',
//     longPath : 'www.site.com:13/path/name',
//     query : 'query=here&and=here',
//     hash : 'anchor',
//   }
//
//   var got = _.uriNew.parseConsecutive( uri );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = '???';
//   var uri = '://www.site.com:13/path//name//?query=here&and=here#anchor';
//   var got = _.uriNew.parseConsecutive( uri );
//   var expected =
//   {
//     protocol : '',
//     longPath : 'www.site.com:13/path//name//',
//     query : 'query=here&and=here',
//     hash : 'anchor',
//   }
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = '???';
//   var uri = ':///www.site.com:13/path//name//?query=here&and=here#anchor';
//   var got = _.uriNew.parseConsecutive( uri );
//   var expected =
//   {
//     protocol : '',
//     longPath : '/www.site.com:13/path//name//',
//     query : 'query=here&and=here',
//     hash : 'anchor',
//   }
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'not ://, but //';
//
//   var expected =
//   {
//     longPath : '///some.com:99/staging/index.html',
//     query : 'query=here&and=here',
//     hash : 'anchor',
//   }
//   var got = _.uriNew.parseConsecutive( '///some.com:99/staging/index.html?query=here&and=here#anchor' );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'tag and user';
//
//   var expected =
//   {
//     longPath : 'git@bitbucket.org:someorg/somerepo.git',
//     tag : 'tag',
//     protocol : 'git',
//   }
//   var got = _.uriNew.parseConsecutive( 'git://git@bitbucket.org:someorg/somerepo.git!tag' );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = '???';
//
//   var expected =
//   {
//     longPath : '/git@bitbucket.org',
//     protocol : 'git',
//   }
//   var got = _.uriNew.parseConsecutive( 'git:///git@bitbucket.org' );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = '???';
//
//   var expected =
//   {
//     longPath : '/git@bitbucket.org',
//     tag : 'tag',
//     protocol : 'git',
//   }
//   var got = _.uriNew.parseConsecutive( 'git:///git@bitbucket.org!tag' );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = '???';
//
//   var expected =
//   {
//     longPath : '/git@bitbucket.org/somerepo.git',
//     tag : 'tag',
//     protocol : 'git',
//   }
//   var got = _.uriNew.parseConsecutive( 'git:///git@bitbucket.org/somerepo.git!tag' );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = '???';
//
//   var expected =
//   {
//     longPath : '/git@bitbucket.org:someorg/somerepo.git',
//     tag : 'tag',
//     protocol : 'git',
//   }
//   var got = _.uriNew.parseConsecutive( 'git:///git@bitbucket.org:someorg/somerepo.git!tag' );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = '???';
//
//   var expected =
//   {
//     protocol : 'git',
//     longPath : '/git@bitbucket.org:someorg/somerepo.git',
//     hash : 'hash'
//   }
//   var got = _.uriNew.parseConsecutive( 'git:///git@bitbucket.org:someorg/somerepo.git#hash' );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = '???';
//
//   var expected =
//   {
//     protocol : 'git',
//     longPath : '/git@bitbucket.org:someorg/somerepo.git/',
//     hash : 'hash'
//   }
//   var got = _.uriNew.parseConsecutive( 'git:///git@bitbucket.org:someorg/somerepo.git/#hash' );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = '???';
//
//   var expected =
//   {
//     protocol : 'git',
//     longPath : '/somerepo.git',
//     hash : 'hash'
//   }
//   var got = _.uriNew.parseConsecutive( 'git:///somerepo.git#hash' );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = '???';
//
//   var expected =
//   {
//     protocol : 'git',
//     longPath : '/somerepo.git/',
//     hash : 'hash'
//   }
//   var got = _.uriNew.parseConsecutive( 'git:///somerepo.git/#hash' );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = '???';
//
//   var expected =
//   {
//     protocol : 'git',
//     longPath : '/git@bitbucket.org:someorg/somerepo.git/',
//     tag : 'tag',
//   }
//   var got = _.uriNew.parseConsecutive( 'git:///git@bitbucket.org:someorg/somerepo.git/!tag' );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = '???';
//
//   var expected =
//   {
//     protocol : 'git',
//     longPath : '/somerepo.git/',
//     tag : 'tag',
//   }
//   var got = _.uriNew.parseConsecutive( 'git:///somerepo.git/!tag' );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = '???';
//
//   var expected =
//   {
//     protocol : 'git',
//     longPath : '/git@bitbucket.org:someorg/somerepo.git',
//     hash : 'hash',
//     tag : 'tag'
//   }
//   var got = _.uriNew.parseConsecutive( 'git:///git@bitbucket.org:someorg/somerepo.git#hash!tag' );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = '???';
//
//   var expected =
//   {
//     protocol : 'git',
//     longPath : '/git@bitbucket.org:someorg/somerepo.git/',
//     hash : 'hash',
//     tag : 'tag'
//   }
//   var got = _.uriNew.parseConsecutive( 'git:///git@bitbucket.org:someorg/somerepo.git/#hash!tag' );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = '???';
//
//   var expected =
//   {
//     protocol : 'git',
//     longPath : '/somerepo.git',
//     hash : 'hash',
//     tag : 'tag',
//   }
//   var got = _.uriNew.parseConsecutive( 'git:///somerepo.git#hash!tag' );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = '???';
//
//   var expected =
//   {
//     protocol : 'git',
//     longPath : '/somerepo.git/',
//     hash : 'hash',
//     tag : 'tag',
//   }
//   var got = _.uriNew.parseConsecutive( 'git:///somerepo.git/#hash!tag' );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = '???';
//
//   var expected =
//   {
//     protocol : 'git',
//     longPath : '/git@bitbucket.org:someorg/somerepo.git',
//     query : 'query=1',
//     hash : 'hash',
//     tag : 'tag',
//   }
//   var got = _.uriNew.parseConsecutive( 'git:///git@bitbucket.org:someorg/somerepo.git?query=1#hash!tag' );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = '???';
//
//   var expected =
//   {
//     protocol : 'git',
//     longPath : '/git@bitbucket.org:someorg/somerepo.git/',
//     query : 'query=1',
//     hash : 'hash',
//     tag : 'tag',
//   }
//   var got = _.uriNew.parseConsecutive( 'git:///git@bitbucket.org:someorg/somerepo.git/?query=1#hash!tag' );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = '???';
//
//   var expected =
//   {
//     protocol : 'git',
//     longPath : '/somerepo.git',
//     query : 'query=1',
//     hash : 'hash',
//     tag : 'tag',
//   }
//   var got = _.uriNew.parseConsecutive( 'git:///somerepo.git?query=1#hash!tag' );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = '???';
//
//   var expected =
//   {
//     protocol : 'git',
//     longPath : '/somerepo.git/',
//     query : 'query=1',
//     hash : 'hash',
//     tag : 'tag',
//   }
//   var got = _.uriNew.parseConsecutive( 'git:///somerepo.git/?query=1#hash!tag' );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = '???';
//
//   var expected =
//   {
//     protocol : 'git',
//     longPath : '/git@bitbucket.org:someorg/somerepo.git',
//     query : 'query=1',
//     tag : 'tag',
//   }
//   var got = _.uriNew.parseConsecutive( 'git:///git@bitbucket.org:someorg/somerepo.git?query=1!tag' );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = '???';
//
//   var expected =
//   {
//     protocol : 'git',
//     longPath : '/git@bitbucket.org:someorg/somerepo.git/',
//     query : 'query=1',
//     tag : 'tag',
//   }
//   var got = _.uriNew.parseConsecutive( 'git:///git@bitbucket.org:someorg/somerepo.git/?query=1!tag' );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = '???';
//
//   var expected =
//   {
//     protocol : 'git',
//     longPath : '/somerepo.git',
//     query : 'query=1',
//     tag : 'tag',
//   }
//   var got = _.uriNew.parseConsecutive( 'git:///somerepo.git?query=1!tag' );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = '???';
//
//   var expected =
//   {
//     protocol : 'git',
//     longPath : '/somerepo.git/',
//     query : 'query=1',
//     tag : 'tag',
//   }
//   var got = _.uriNew.parseConsecutive( 'git:///somerepo.git/?query=1!tag' );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = '# @ ?';
//   var expected =
//   {
//     longPath : '',
//     query : 'query1',
//     tag : 'tag1/',
//     hash : 'hash1/',
//     protocol : '',
//   }
//   var got = _.uriNew.parseConsecutive( '://#hash1/!tag1/?query1' );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'escaped # @ ?';
//   var expected =
//   {
//     longPath : '"#hash1"/"!tag1"/"?query1"',
//     protocol : '',
//   }
//   var got = _.uriNew.parseConsecutive( '://"#hash1"/"!tag1"/"?query1"' );
//   test.identical( got, expected );
//
//   /* - */
//
//   if( !Config.debug )
//   return;
//
//   test.case = 'missed arguments';
//   test.shouldThrowErrorSync( function()
//   {
//     _.uriNew.parseConsecutive();
//   });
//
//   test.case = 'redundant argument';
//   test.shouldThrowErrorSync( function()
//   {
//     _.uriNew.parseConsecutive( 'http://www.site.com:13/path/name?query=here&and=here#anchor', '' );
//   });
//
//   test.case = 'argument is not string';
//   test.shouldThrowErrorSync( function()
//   {
//     _.uriNew.parseConsecutive( 34 );
//   });
//
// }
//
// //
//
// function parseConsecutive2( test )
// {
//
//   /* */
//
//   test.case = 'query only';
//   var src = '?entry:1&format:null';
//   var expected =
//   {
//     'query' : 'entry:1&format:null',
//     'longPath' : '',
//     'postfixedPath' : '?entry:1&format:null',
//   }
//   var got = _.uriNew.parseConsecutive( src );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'global, relative, with hash, with query';
//   var src = "git://../repo/Tools?out=out/wTools.out.will#master"
//   var expected =
//   {
//     'protocol' : 'git',
//     'query' : 'out=out/wTools.out.will',
//     'hash' : 'master',
//     'longPath' : '../repo/Tools',
//     'postfixedPath' : '../repo/Tools?out=out/wTools.out.will#master'
//   }
//   var got = _.uriNew.parseConsecutive( src );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'global, absolute, with hash, with query';
//   var src = "git:///../repo/Tools?out=out/wTools.out.will#master"
//   var expected =
//   {
//     'protocol' : 'git',
//     'query' : 'out=out/wTools.out.will',
//     'hash' : 'master',
//     'longPath' : '/../repo/Tools',
//     'postfixedPath' : '/../repo/Tools?out=out/wTools.out.will#master'
//   }
//   var got = _.uriNew.parseConsecutive( src );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'query with equal';
//   var src = 'http://127.0.0.1:5000/a/b?q=3#anch';
//   var expected =
//   {
//     'protocol' : 'http',
//     'query' : 'q=3',
//     'hash' : 'anch',
//     'longPath' : '127.0.0.1:5000/a/b',
//     'postfixedPath' : '127.0.0.1:5000/a/b?q=3#anch'
//   }
//   var got = _.uriNew.parseConsecutive( src );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'query with colon';
//   var src = 'http://127.0.0.1:5000/a/b?q:3#anch';
//   var expected =
//   {
//     'protocol' : 'http',
//     'query' : 'q:3',
//     'hash' : 'anch',
//     'longPath' : '127.0.0.1:5000/a/b',
//     'postfixedPath' : '127.0.0.1:5000/a/b?q:3#anch'
//   }
//   var got = _.uriNew.parseConsecutive( src );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'no protocol';
//   var uri = '127.0.0.1:61726/../path';
//   var expected =
//   {
//     longPath : '127.0.0.1:61726/../path',
//     postfixedPath : '127.0.0.1:61726/../path',
//   }
//   var got = _.uriNew.parseConsecutive( uri );
//   test.identical( got, expected );
//
//   var expected =
//   {
//     longPath : '127.0.0.1:61726/../path',
//     postfixedPath : '127.0.0.1:61726/../path',
//   }
//
//   var got = _.uriNew.parseConsecutive( uri );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'full uri with all components';
//
//   var expected =
//   {
//     protocol : 'http',
//     query : 'query=here&and=here',
//     hash : 'anchor',
//     longPath : 'www.site.com:13/path/name',
//     postfixedPath : 'www.site.com:13/path/name?query=here&and=here#anchor',
//   }
//
//   var uri1 = 'http://www.site.com:13/path/name?query=here&and=here#anchor';
//   var got = _.uriNew.parseConsecutive( uri1 );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'full uri with all components, primitiveOnly';
//
//   var expected =
//   {
//     protocol : 'http',
//     longPath : 'www.site.com:13/path/name',
//     postfixedPath : 'www.site.com:13/path/name?query=here&and=here#anchor',
//     query : 'query=here&and=here',
//     hash : 'anchor',
//   }
//
//   var uri1 = 'http://www.site.com:13/path/name?query=here&and=here#anchor';
//   var got = _.uriNew.parseConsecutive( uri1 );
//   test.identical( got, expected );
//
//   test.case = 'reparse with non primitives';
//
//   var expected =
//   {
//     protocol : 'http',
//     query : 'query=here&and=here',
//     hash : 'anchor',
//     longPath : 'www.site.com:13/path/name',
//     postfixedPath : 'www.site.com:13/path/name?query=here&and=here#anchor',
//   }
//
//   var parsed = got;
//   var got = _.uriNew.parseConsecutive( parsed );
//   test.identical( got, expected );
//
//   test.case = 'reparse with primitives';
//
//   var uri1 = 'http://www.site.com:13/path/name?query=here&and=here#anchor';
//   var expected =
//   {
//     protocol : 'http',
//     query : 'query=here&and=here',
//     hash : 'anchor',
//     longPath : 'www.site.com:13/path/name',
//     postfixedPath : 'www.site.com:13/path/name?query=here&and=here#anchor',
//   }
//
//   var got = _.uriNew.parseConsecutive( uri1 );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'uri with zero length protocol';
//
//   var uri = '://some.domain.com/something/filePath/add';
//
//   var expected =
//   {
//     protocol : '',
//     longPath : 'some.domain.com/something/filePath/add',
//     postfixedPath : 'some.domain.com/something/filePath/add',
//   }
//
//   var got = _.uriNew.parseConsecutive( uri );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'uri with zero length hostFull';
//
//   var uri = 'file:///something/filePath/add';
//
//   var expected =
//   {
//     protocol : 'file',
//     longPath : '/something/filePath/add',
//     postfixedPath : '/something/filePath/add',
//   }
//
//   var got = _.uriNew.parseConsecutive( uri );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'uri with double protocol';
//
//   var uri = 'svn+https://user@subversion.com/svn/trunk';
//
//   var expected =
//   {
//     protocol : 'svn+https',
//     longPath : 'user@subversion.com/svn/trunk',
//     postfixedPath : 'user@subversion.com/svn/trunk',
//   }
//
//   var got = _.uriNew.parseConsecutive( uri );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'simple path';
//
//   var uri = '/some/file';
//
//   var expected =
//   {
//     longPath : '/some/file',
//     postfixedPath : '/some/file',
//   }
//
//   var got = _.uriNew.parseConsecutive( uri );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'without ":"';
//
//   var uri = '//some.domain.com/was';
//   var expected =
//   {
//     longPath : '//some.domain.com/was',
//     postfixedPath : '//some.domain.com/was',
//   }
//
//   var got = _.uriNew.parseConsecutive( uri );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'with ":"';
//
//   var uri = '://some.domain.com/was';
//   var expected =
//   {
//     protocol : '',
//     host : 'some.domain.com',
//     resourcePath : '/was',
//     longPath : 'some.domain.com/was',
//     postfixedPath : 'some.domain.com/was',
//     protocols : [ '' ],
//     hostFull : 'some.domain.com',
//     origin : '://some.domain.com',
//     full : '://some.domain.com/was'
//   }
//
//   /* */
//
//   test.case = 'with ":" and protocol';
//
//   var uri = 'protocol://some.domain.com/was';
//   var expected =
//   {
//     protocol : 'protocol',
//     longPath : 'some.domain.com/was',
//     postfixedPath : 'some.domain.com/was',
//   }
//
//   var got = _.uriNew.parseConsecutive( uri );
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'simple path';
//
//   var uri = '//';
//   var expected =
//   {
//     longPath : '//',
//     postfixedPath : '//',
//   }
//
//   var got = _.uriNew.parseConsecutive( uri );
//   test.identical( got, expected );
//
//   var uri = '///';
//   var expected =
//   {
//     longPath : '///',
//     postfixedPath : '///',
//   }
//
//   var got = _.uriNew.parseConsecutive( uri );
//   test.identical( got, expected );
//
//   var uri = '///a/b/c';
//   var expected =
//   {
//     longPath : '///a/b/c',
//     postfixedPath : '///a/b/c',
//   }
//
//   var got = _.uriNew.parseConsecutive( uri );
//   test.identical( got, expected );
//
//   test.case = '???';
//   var uri = 'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor';
//   var expected =
//   {
//     protocol : 'complex+protocol',
//     query : 'query=here&and=here',
//     hash : 'anchor',
//     longPath : 'www.site.com:13/path/name',
//     postfixedPath : 'www.site.com:13/path/name?query=here&and=here#anchor',
//   }
//
//   var got = _.uriNew.parseConsecutive( uri );
//   test.identical( got, expected );
//
//   var uri = '://www.site.com:13/path//name//?query=here&and=here#anchor';
//   var got = _.uriNew.parseConsecutive( uri );
//   var expected =
//   {
//     protocol : '',
//     query : 'query=here&and=here',
//     hash : 'anchor',
//     longPath : 'www.site.com:13/path//name//',
//     postfixedPath : 'www.site.com:13/path//name//?query=here&and=here#anchor',
//   }
//   test.identical( got, expected );
//
//   var uri = '://www.site.com:13/path//name//?query=here&and=here#anchor';
//   var got = _.uriNew.parseConsecutive( uri );
//   var expected =
//   {
//     protocol : '',
//     query : 'query=here&and=here',
//     hash : 'anchor',
//     longPath : 'www.site.com:13/path//name//',
//     postfixedPath : 'www.site.com:13/path//name//?query=here&and=here#anchor',
//   }
//   test.identical( got, expected );
//
//   var uri = ':///www.site.com:13/path//name//?query=here&and=here#anchor';
//   var got = _.uriNew.parseConsecutive( uri );
//   var expected =
//   {
//     protocol : '',
//     query : 'query=here&and=here',
//     hash : 'anchor',
//     longPath : '/www.site.com:13/path//name//',
//     postfixedPath : '/www.site.com:13/path//name//?query=here&and=here#anchor',
//   }
//   test.identical( got, expected );
//
//   var uri = ':///www.site.com:13/path//name//?query=here&and=here#anchor';
//   var got = _.uriNew.parseConsecutive( uri );
//   var expected =
//   {
//     protocol : '',
//     query : 'query=here&and=here',
//     hash : 'anchor',
//     longPath : '/www.site.com:13/path//name//',
//     postfixedPath : '/www.site.com:13/path//name//?query=here&and=here#anchor',
//   }
//   test.identical( got, expected );
//
//   /* */
//
//   var expected =
//   {
//     query : 'query=here&and=here',
//     hash : 'anchor',
//     longPath : '///some.com:99/staging/index.html',
//     postfixedPath : '///some.com:99/staging/index.html?query=here&and=here#anchor',
//   }
//   var got = _.uriNew.parseConsecutive( '///some.com:99/staging/index.html?query=here&and=here#anchor' );
//   test.identical( got, expected );
//
//   /* */
//
//   var expected =
//   {
//     protocol : 'git',
//     longPath : '/git@bitbucket.org:someorg/somerepo.git',
//     postfixedPath : '/git@bitbucket.org:someorg/somerepo.git!tag',
//     tag : 'tag'
//   }
//   var got = _.uriNew.parseConsecutive( 'git:///git@bitbucket.org:someorg/somerepo.git!tag' );
//   test.identical( got, expected );
//
//   var expected =
//   {
//     protocol : 'git',
//     longPath : '/git@bitbucket.org:someorg/somerepo.git',
//     postfixedPath : '/git@bitbucket.org:someorg/somerepo.git#hash',
//     hash : 'hash'
//   }
//   var got = _.uriNew.parseConsecutive( 'git:///git@bitbucket.org:someorg/somerepo.git#hash' );
//   test.identical( got, expected );
//
//   var expected =
//   {
//     protocol : 'git',
//     hash : 'hash',
//     longPath : '/git@bitbucket.org:someorg/somerepo.git/',
//     postfixedPath : '/git@bitbucket.org:someorg/somerepo.git/#hash',
//   }
//   var got = _.uriNew.parseConsecutive( 'git:///git@bitbucket.org:someorg/somerepo.git/#hash' );
//   test.identical( got, expected );
//
//   var expected =
//   {
//     protocol : 'git',
//     hash : 'hash',
//     longPath : '/somerepo.git',
//     postfixedPath : '/somerepo.git#hash',
//   }
//   var got = _.uriNew.parseConsecutive( 'git:///somerepo.git#hash' );
//   test.identical( got, expected );
//
//   var expected =
//   {
//     protocol : 'git',
//     hash : 'hash',
//     longPath : '/somerepo.git/',
//     postfixedPath : '/somerepo.git/#hash',
//   }
//   var got = _.uriNew.parseConsecutive( 'git:///somerepo.git/#hash' );
//   test.identical( got, expected );
//
//   var expected =
//   {
//     protocol : 'git',
//     tag : 'tag',
//     longPath : '/git@bitbucket.org:someorg/somerepo.git/',
//     postfixedPath : '/git@bitbucket.org:someorg/somerepo.git/!tag',
//   }
//   var got = _.uriNew.parseConsecutive( 'git:///git@bitbucket.org:someorg/somerepo.git/!tag' );
//   test.identical( got, expected );
//
//   var expected =
//   {
//     protocol : 'git',
//     tag : 'tag',
//     longPath : '/somerepo.git/',
//     postfixedPath : '/somerepo.git/!tag',
//   }
//   var got = _.uriNew.parseConsecutive( 'git:///somerepo.git/!tag' );
//   test.identical( got, expected );
//
//   var expected =
//   {
//     protocol : 'git',
//     hash : 'hash',
//     tag : 'tag',
//     longPath : '/git@bitbucket.org:someorg/somerepo.git',
//     postfixedPath : '/git@bitbucket.org:someorg/somerepo.git#hash!tag',
//   }
//   var got = _.uriNew.parseConsecutive( 'git:///git@bitbucket.org:someorg/somerepo.git#hash!tag' );
//   test.identical( got, expected );
//
//   var expected =
//   {
//     protocol : 'git',
//     hash : 'hash',
//     tag : 'tag',
//     longPath : '/git@bitbucket.org:someorg/somerepo.git/',
//     postfixedPath : '/git@bitbucket.org:someorg/somerepo.git/#hash!tag',
//   }
//   var got = _.uriNew.parseConsecutive( 'git:///git@bitbucket.org:someorg/somerepo.git/#hash!tag' );
//   test.identical( got, expected );
//
//   var expected =
//   {
//     protocol : 'git',
//     hash : 'hash',
//     tag : 'tag',
//     longPath : '/somerepo.git',
//     postfixedPath : '/somerepo.git#hash!tag',
//   }
//   var got = _.uriNew.parseConsecutive( 'git:///somerepo.git#hash!tag' );
//   test.identical( got, expected );
//
//   var expected =
//   {
//     protocol : 'git',
//     hash : 'hash',
//     tag : 'tag',
//     longPath : '/somerepo.git/',
//     postfixedPath : '/somerepo.git/#hash!tag',
//   }
//   var got = _.uriNew.parseConsecutive( 'git:///somerepo.git/#hash!tag' );
//   test.identical( got, expected );
//
//   var expected =
//   {
//     protocol : 'git',
//     query : 'query=1',
//     hash : 'hash',
//     tag : 'tag',
//     longPath : '/git@bitbucket.org:someorg/somerepo.git',
//     postfixedPath : '/git@bitbucket.org:someorg/somerepo.git?query=1#hash!tag',
//   }
//   var got = _.uriNew.parseConsecutive( 'git:///git@bitbucket.org:someorg/somerepo.git?query=1#hash!tag' );
//   test.identical( got, expected );
//
//   var expected =
//   {
//     protocol : 'git',
//     query : 'query=1',
//     hash : 'hash',
//     tag : 'tag',
//     longPath : '/git@bitbucket.org:someorg/somerepo.git/',
//     postfixedPath : '/git@bitbucket.org:someorg/somerepo.git/?query=1#hash!tag',
//   }
//   var got = _.uriNew.parseConsecutive( 'git:///git@bitbucket.org:someorg/somerepo.git/?query=1#hash!tag' );
//   test.identical( got, expected );
//
//   var expected =
//   {
//     protocol : 'git',
//     query : 'query=1',
//     hash : 'hash',
//     tag : 'tag',
//     longPath : '/somerepo.git',
//     postfixedPath : '/somerepo.git?query=1#hash!tag',
//   }
//   var got = _.uriNew.parseConsecutive( 'git:///somerepo.git?query=1#hash!tag' );
//   test.identical( got, expected );
//
//   var expected =
//   {
//     protocol : 'git',
//     query : 'query=1',
//     hash : 'hash',
//     tag : 'tag',
//     longPath : '/somerepo.git/',
//     postfixedPath : '/somerepo.git/?query=1#hash!tag',
//   }
//   var got = _.uriNew.parseConsecutive( 'git:///somerepo.git/?query=1#hash!tag' );
//   test.identical( got, expected );
//
//   var expected =
//   {
//     protocol : 'git',
//     query : 'query=1',
//     tag : 'tag',
//     longPath : '/git@bitbucket.org:someorg/somerepo.git',
//     postfixedPath : '/git@bitbucket.org:someorg/somerepo.git?query=1!tag',
//   }
//   var got = _.uriNew.parseConsecutive( 'git:///git@bitbucket.org:someorg/somerepo.git?query=1!tag' );
//   test.identical( got, expected );
//
//   var expected =
//   {
//     protocol : 'git',
//     query : 'query=1',
//     tag : 'tag',
//     longPath : '/git@bitbucket.org:someorg/somerepo.git/',
//     postfixedPath : '/git@bitbucket.org:someorg/somerepo.git/?query=1!tag',
//   }
//   var got = _.uriNew.parseConsecutive( 'git:///git@bitbucket.org:someorg/somerepo.git/?query=1!tag' );
//   test.identical( got, expected );
//
//   var expected =
//   {
//     protocol : 'git',
//     query : 'query=1',
//     tag : 'tag',
//     longPath : '/somerepo.git',
//     postfixedPath : '/somerepo.git?query=1!tag',
//   }
//   var got = _.uriNew.parseConsecutive( 'git:///somerepo.git?query=1!tag' );
//   test.identical( got, expected );
//
//
//   var expected =
//   {
//     protocol : 'git',
//     query : 'query=1',
//     tag : 'tag',
//     longPath : '/somerepo.git/',
//     postfixedPath : '/somerepo.git/?query=1!tag',
//   }
//   var got = _.uriNew.parseConsecutive( 'git:///somerepo.git/?query=1!tag' );
//   test.identical( got, expected );
//
//   /* - */
//
//   if( !Config.debug )
//   return;
//
//   test.case = 'missed arguments';
//   test.shouldThrowErrorSync( function()
//   {
//     _.uriNew.parseConsecutive();
//   });
//
//   test.case = 'redundant argument';
//   test.shouldThrowErrorSync( function()
//   {
//     _.uriNew.parseConsecutive( 'http://www.site.com:13/path/name?query=here&and=here#anchor', '' );
//   });
//
//   test.case = 'argument is not string';
//   test.shouldThrowErrorSync( function()
//   {
//     _.uriNew.parseConsecutive( 34 );
//   });
//
// }

//

function parseGlob( test )
{

  /* qqq : ask how to resolve this */

  test.open( 'local path' );

  var src = '!a.js';
  var got = _.uriNew.parseFull( src );
  var expected = { resourcePath : src, longPath : src };
  test.contains( got, expected );

  var src = '/a/!a.js';
  var got = _.uriNew.parseFull( src );
  var expected = { resourcePath : src, longPath : src };
  test.contains( got, expected );

  var src = '/a/!a.js';
  var got = _.uriNew.parseFull( src );
  var expected = { resourcePath : src, longPath : src };
  test.contains( got, expected );

  var src = '/a/^a.js';
  var got = _.uriNew.parseFull( src );
  var expected = { resourcePath : src, longPath : src };
  test.contains( got, expected );

  var src = '/a/+a.js';
  var got = _.uriNew.parseFull( src );
  var expected = { resourcePath : src, longPath : src };
  test.contains( got, expected );

  var src = '/a/!';
  var got = _.uriNew.parseFull( src );
  var expected = { resourcePath : src, longPath : src };
  test.contains( got, expected );

  var src = '/a/???abc';
  var got = _.uriNew.parseFull( src );
  var expected = { resourcePath : src, longPath : src };
  test.contains( got, expected );

  var src = '/a/???abc#';
  var got = _.uriNew.parseFull( src );
  var expected =
  {
    'resourcePath' : '/a/???abc',
    'hash' : '',
    'longPath' : '/a/???abc',
    'postfixedPath' : '/a/???abc#',
    'protocols' : [],
    'full' : '/a/???abc#'
  }
  test.identical( got, expected );

  var src = '/a/^';
  var got = _.uriNew.parseFull( src );
  var expected = { resourcePath : src, longPath : src };
  test.contains( got, expected );

  var src = '/a/+';
  var got = _.uriNew.parseFull( src );
  var expected = { resourcePath : src, longPath : src };
  test.contains( got, expected );

  var src = '?';
  var got = _.uriNew.parseFull( src );
  var expected = { resourcePath : src, longPath : src };
  test.contains( got, expected );

  var src = '*';
  var got = _.uriNew.parseFull( src );
  var expected = { resourcePath : src, longPath : src };
  test.contains( got, expected );

  var src = '**';
  var got = _.uriNew.parseFull( src );
  var expected = { resourcePath : src, longPath : src };
  test.contains( got, expected );

  var src = '?c.js';
  var got = _.uriNew.parseFull( src );
  var expected = { resourcePath : src, longPath : src };
  test.contains( got, expected );

  var src = '*.js';
  var got = _.uriNew.parseFull( src );
  var expected = { resourcePath : src, longPath : src };
  test.contains( got, expected );

  var src = '**/a.js';
  var got = _.uriNew.parseFull( src );
  var expected = { resourcePath : src, longPath : src };
  test.contains( got, expected );

  var src = 'dir?c/a.js';
  var got = _.uriNew.parseFull( src );
  var expected = { resourcePath : src, longPath : src };
  test.contains( got, expected );

  var src = 'dir/*.js';
  var got = _.uriNew.parseFull( src );
  var expected = { resourcePath : src, longPath : src };
  test.contains( got, expected );

  var src = 'dir/**.js';
  var got = _.uriNew.parseFull( src );
  var expected = { resourcePath : src, longPath : src };
  test.contains( got, expected );

  var src = 'dir/**/a.js';
  var got = _.uriNew.parseFull( src );
  var expected = { resourcePath : src, longPath : src };
  test.contains( got, expected );

  var src = '/dir?c/a.js';
  var got = _.uriNew.parseFull( src );
  var expected = { resourcePath : src, longPath : src };
  test.contains( got, expected );

  var src = '/dir/*.js';
  var got = _.uriNew.parseFull( src );
  var expected = { resourcePath : src, longPath : src };
  test.contains( got, expected );

  var src = '/dir/**.js';
  var got = _.uriNew.parseFull( src );
  var expected = { resourcePath : src, longPath : src };
  test.contains( got, expected );

  var src = '/dir/**/a.js';
  var got = _.uriNew.parseFull( src );
  var expected = { resourcePath : src, longPath : src };
  test.contains( got, expected );

  var src = '[a-c]';
  var got = _.uriNew.parseFull( src );
  var expected = { resourcePath : src, longPath : src };
  test.contains( got, expected );

  var src = '{a,c}';
  var got = _.uriNew.parseFull( src );
  var expected = { resourcePath : src, longPath : src };
  test.contains( got, expected );

  var src = '(a|b)';
  var got = _.uriNew.parseFull( src );
  var expected = { resourcePath : src, longPath : src };
  test.contains( got, expected );

  var src = '(ab)';
  var got = _.uriNew.parseFull( src );
  var expected = { resourcePath : src, longPath : src };
  test.contains( got, expected );

  var src = '@(ab)';
  var got = _.uriNew.parseFull( src );
  var expected = { resourcePath : src, longPath : src };
  test.contains( got, expected );

  var src = '!(ab)';
  var got = _.uriNew.parseFull( src );
  var expected = { resourcePath : src, longPath : src };
  test.contains( got, expected );

  var src = '?(ab)';
  var got = _.uriNew.parseFull( src );
  var expected = { resourcePath : src, longPath : src };
  test.contains( got, expected );

  var src = '*(ab)';
  var got = _.uriNew.parseFull( src );
  var expected = { resourcePath : src, longPath : src };
  test.contains( got, expected );

  var src = '+(ab)';
  var got = _.uriNew.parseFull( src );
  var expected = { resourcePath : src, longPath : src };
  test.contains( got, expected );

  var src = 'dir/[a-c].js';
  var got = _.uriNew.parseFull( src );
  var expected = { resourcePath : src, longPath : src };
  test.contains( got, expected );

  var src = 'dir/{a,c}.js';
  var got = _.uriNew.parseFull( src );
  var expected = { resourcePath : src, longPath : src };
  test.contains( got, expected );

  var src = 'dir/(a|b).js';
  var got = _.uriNew.parseFull( src );
  var expected = { resourcePath : src, longPath : src };
  test.contains( got, expected );

  var src = 'dir/(ab).js';
  var got = _.uriNew.parseFull( src );
  var expected = { resourcePath : src, longPath : src };
  test.contains( got, expected );

  var src = 'dir/@(ab).js';
  var got = _.uriNew.parseFull( src );
  var expected =
  {
    resourcePath : 'dir/',
    tag : '(ab).js',
    longPath : 'dir/',
    full : src
  }
  test.contains( got, expected );

  var src = 'dir/!(ab).js';
  var got = _.uriNew.parseFull( src );
  var expected = { resourcePath : src, longPath : src };
  test.contains( got, expected );

  var src = 'dir/?(ab).js';
  var got = _.uriNew.parseFull( src );
  var expected = { resourcePath : src, longPath : src };
  test.contains( got, expected );

  var src = 'dir/*(ab).js';
  var got = _.uriNew.parseFull( src );
  var expected = { resourcePath : src, longPath : src };
  test.contains( got, expected );

  var src = 'dir/+(ab).js';
  var got = _.uriNew.parseFull( src );
  var expected = { resourcePath : src, longPath : src };
  test.contains( got, expected );

  var src = '/index/**';
  var got = _.uriNew.parseFull( src );
  var expected = { resourcePath : src, longPath : src };
  test.contains( got, expected );

  test.close( 'local path' );

  /* */

  test.open( 'complex uri' );

  var src = '/!a.js?';
  var uri = 'complex+protocol://www.site.com:13/!a.js??query=here&and=here#anchor';
  var got = _.uriNew.parseFull( uri );
  var expected =
  {
    'protocol' : 'complex+protocol',
    'host' : 'www.site.com',
    'port' : 13,
    'query' : 'query=here&and=here',
    'hash' : 'anchor',
    'resourcePath' : '/!a.js?',
    'longPath' : 'www.site.com:13/!a.js?',
    'postfixedPath' : 'www.site.com:13/!a.js??query=here&and=here#anchor',
    'protocols' : [ 'complex', 'protocol' ],
    'hostFull' : 'www.site.com:13',
    'origin' : 'complex+protocol://www.site.com:13',
    'full' : 'complex+protocol://www.site.com:13/!a.js??query=here&and=here#anchor',
  }
  test.identical( got, expected );

  var src = '/a/!a.js';
  var uri = 'complex+protocol://www.site.com:13/a/!a.js?query=here&and=here#anchor';
  var got = _.uriNew.parseFull( uri );
  var expected =
  {
    'protocol' : 'complex+protocol',
    'host' : 'www.site.com',
    'port' : 13,
    'resourcePath' : '/a/!a.js',
    'query' : 'query=here&and=here',
    'hash' : 'anchor',
    'longPath' : 'www.site.com:13/a/!a.js',
    'postfixedPath' : 'www.site.com:13/a/!a.js?query=here&and=here#anchor',
    'protocols' : [ 'complex', 'protocol' ],
    'hostFull' : 'www.site.com:13',
    'origin' : 'complex+protocol://www.site.com:13',
    'full' : 'complex+protocol://www.site.com:13/a/!a.js?query=here&and=here#anchor'
  };
  test.identical( got, expected );

  var src = '/a/^a.js';
  var uri = 'complex+protocol://www.site.com:13/a/^a.js?query=here&and=here#anchor';
  var got = _.uriNew.parseFull( uri );
  var expected =
  {
    'protocol' : 'complex+protocol',
    'host' : 'www.site.com',
    'port' : 13,
    'resourcePath' : '/a/^a.js',
    'query' : 'query=here&and=here',
    'hash' : 'anchor',
    'longPath' : 'www.site.com:13/a/^a.js',
    'postfixedPath' : 'www.site.com:13/a/^a.js?query=here&and=here#anchor',
    'protocols' : [ 'complex', 'protocol' ],
    'hostFull' : 'www.site.com:13',
    'origin' : 'complex+protocol://www.site.com:13',
    'full' : 'complex+protocol://www.site.com:13/a/^a.js?query=here&and=here#anchor'
  };
  test.identical( got, expected );

  var src = '/a/+a.js';
  var uri = 'complex+protocol://www.site.com:13/a/+a.js?query=here&and=here#anchor';
  var got = _.uriNew.parseFull( uri );
  var expected =
  {
    'protocol' : 'complex+protocol',
    'host' : 'www.site.com',
    'port' : 13,
    'resourcePath' : '/a/+a.js',
    'query' : 'query=here&and=here',
    'hash' : 'anchor',
    'longPath' : 'www.site.com:13/a/+a.js',
    'postfixedPath' : 'www.site.com:13/a/+a.js?query=here&and=here#anchor',
    'protocols' : [ 'complex', 'protocol' ],
    'hostFull' : 'www.site.com:13',
    'origin' : 'complex+protocol://www.site.com:13',
    'full' : 'complex+protocol://www.site.com:13/a/+a.js?query=here&and=here#anchor',
  };
  test.identical( got, expected );

  var src = '/a/!';
  var uri = 'complex+protocol://www.site.com:13/a/!?query=here&and=here#anchor';
  var got = _.uriNew.parseFull( uri );
  var expected =
  {
    'protocol' : 'complex+protocol',
    'host' : 'www.site.com',
    'port' : 13,
    'resourcePath' : '/a/!',
    'query' : 'query=here&and=here',
    'hash' : 'anchor',
    'longPath' : 'www.site.com:13/a/!',
    'postfixedPath' : 'www.site.com:13/a/!?query=here&and=here#anchor',
    'protocols' : [ 'complex', 'protocol' ],
    'hostFull' : 'www.site.com:13',
    'origin' : 'complex+protocol://www.site.com:13',
    'full' : 'complex+protocol://www.site.com:13/a/!?query=here&and=here#anchor',
  };
  test.identical( got, expected );

  var src = '/a/^';
  var uri = 'complex+protocol://www.site.com:13/a/^?query=here&and=here#anchor';
  var got = _.uriNew.parseFull( uri );
  var expected =
  {
    'protocol' : 'complex+protocol',
    'host' : 'www.site.com',
    'port' : 13,
    'resourcePath' : '/a/^',
    'query' : 'query=here&and=here',
    'hash' : 'anchor',
    'longPath' : 'www.site.com:13/a/^',
    'postfixedPath' : 'www.site.com:13/a/^?query=here&and=here#anchor',
    'protocols' : [ 'complex', 'protocol' ],
    'hostFull' : 'www.site.com:13',
    'origin' : 'complex+protocol://www.site.com:13',
    'full' : 'complex+protocol://www.site.com:13/a/^?query=here&and=here#anchor',
  };
  test.identical( got, expected );

  var src = '/a/+';
  var uri = 'complex+protocol://www.site.com:13/a/+?query=here&and=here#anchor';
  var got = _.uriNew.parseFull( uri );
  var expected =
  {
    'protocol' : 'complex+protocol',
    'host' : 'www.site.com',
    'port' : 13,
    'resourcePath' : '/a/+',
    'query' : 'query=here&and=here',
    'hash' : 'anchor',
    'longPath' : 'www.site.com:13/a/+',
    'postfixedPath' : 'www.site.com:13/a/+?query=here&and=here#anchor',
    'protocols' : [ 'complex', 'protocol' ],
    'hostFull' : 'www.site.com:13',
    'origin' : 'complex+protocol://www.site.com:13',
    'full' : 'complex+protocol://www.site.com:13/a/+?query=here&and=here#anchor',
  };
  test.identical( got, expected );

  var src = '/?';
  var uri = 'complex+protocol://www.site.com:13/??query=here&and=here#anchor';
  var got = _.uriNew.parseFull( uri );
  var expected =
  {
    'protocol' : 'complex+protocol',
    'host' : 'www.site.com',
    'port' : 13,
    'resourcePath' : '/?',
    'query' : 'query=here&and=here',
    'hash' : 'anchor',
    'longPath' : 'www.site.com:13/?',
    'postfixedPath' : 'www.site.com:13/??query=here&and=here#anchor',
    'protocols' : [ 'complex', 'protocol' ],
    'hostFull' : 'www.site.com:13',
    'origin' : 'complex+protocol://www.site.com:13',
    'full' : 'complex+protocol://www.site.com:13/??query=here&and=here#anchor',
  };
  test.identical( got, expected );

  var src = '/*';
  var uri = 'complex+protocol://www.site.com:13/*?query=here&and=here#anchor';
  var got = _.uriNew.parseFull( uri );
  var expected =
  {
    'protocol' : 'complex+protocol',
    'host' : 'www.site.com',
    'port' : 13,
    'resourcePath' : '/*',
    'query' : 'query=here&and=here',
    'hash' : 'anchor',
    'longPath' : 'www.site.com:13/*',
    'postfixedPath' : 'www.site.com:13/*?query=here&and=here#anchor',
    'protocols' : [ 'complex', 'protocol' ],
    'hostFull' : 'www.site.com:13',
    'origin' : 'complex+protocol://www.site.com:13',
    'full' : 'complex+protocol://www.site.com:13/*?query=here&and=here#anchor',
  };
  test.identical( got, expected );

  var src = '/**';
  var uri = 'complex+protocol://www.site.com:13/**?query=here&and=here#anchor';
  var got = _.uriNew.parseFull( uri );
  var expected =
  {
    'protocol' : 'complex+protocol',
    'host' : 'www.site.com',
    'port' : 13,
    'resourcePath' : '/**',
    'query' : 'query=here&and=here',
    'hash' : 'anchor',
    'longPath' : 'www.site.com:13/**',
    'postfixedPath' : 'www.site.com:13/**?query=here&and=here#anchor',
    'protocols' : [ 'complex', 'protocol' ],
    'hostFull' : 'www.site.com:13',
    'origin' : 'complex+protocol://www.site.com:13',
    'full' : 'complex+protocol://www.site.com:13/**?query=here&and=here#anchor',
  };
  test.identical( got, expected );

  var src = '/?c.js';
  var uri = 'complex+protocol://www.site.com:13/?c.js?query=here&and=here#anchor';
  var got = _.uriNew.parseFull( uri );
  var expected =
  {
    'protocol' : 'complex+protocol',
    'host' : 'www.site.com',
    'port' : 13,
    'resourcePath' : '/?c.js',
    'query' : 'query=here&and=here',
    'hash' : 'anchor',
    'longPath' : 'www.site.com:13/?c.js',
    'postfixedPath' : 'www.site.com:13/?c.js?query=here&and=here#anchor',
    'protocols' : [ 'complex', 'protocol' ],
    'hostFull' : 'www.site.com:13',
    'origin' : 'complex+protocol://www.site.com:13',
    'full' : 'complex+protocol://www.site.com:13/?c.js?query=here&and=here#anchor',
  };
  test.identical( got, expected );

  var src = '/*.js';
  var uri = 'complex+protocol://www.site.com:13/*.js?query=here&and=here#anchor';
  var got = _.uriNew.parseFull( uri );
  var expected =
  {
    'protocol' : 'complex+protocol',
    'host' : 'www.site.com',
    'port' : 13,
    'resourcePath' : '/*.js',
    'query' : 'query=here&and=here',
    'hash' : 'anchor',
    'longPath' : 'www.site.com:13/*.js',
    'postfixedPath' : 'www.site.com:13/*.js?query=here&and=here#anchor',
    'protocols' : [ 'complex', 'protocol' ],
    'hostFull' : 'www.site.com:13',
    'origin' : 'complex+protocol://www.site.com:13',
    'full' : 'complex+protocol://www.site.com:13/*.js?query=here&and=here#anchor'

  };
  test.identical( got, expected );

  var src = '/**/a.js';
  var uri = 'complex+protocol://www.site.com:13/**/a.js?query=here&and=here#anchor';
  var got = _.uriNew.parseFull( uri );
  var expected =
  {
    'protocol' : 'complex+protocol',
    'host' : 'www.site.com',
    'port' : 13,
    'resourcePath' : '/**/a.js',
    'query' : 'query=here&and=here',
    'hash' : 'anchor',
    'longPath' : 'www.site.com:13/**/a.js',
    'postfixedPath' : 'www.site.com:13/**/a.js?query=here&and=here#anchor',
    'protocols' : [ 'complex', 'protocol' ],
    'hostFull' : 'www.site.com:13',
    'origin' : 'complex+protocol://www.site.com:13',
    'full' : 'complex+protocol://www.site.com:13/**/a.js?query=here&and=here#anchor'
  };
  test.identical( got, expected );

  var src = '/dir?c/a.js';
  var uri = 'complex+protocol://www.site.com:13/dir?c/a.js?query=here&and=here#anchor';
  var got = _.uriNew.parseFull( uri );
  var expected =
  {
    'protocol' : 'complex+protocol',
    'host' : 'www.site.com',
    'port' : 13,
    'resourcePath' : '/dir?c/a.js',
    'query' : 'query=here&and=here',
    'hash' : 'anchor',
    'longPath' : 'www.site.com:13/dir?c/a.js',
    'postfixedPath' : 'www.site.com:13/dir?c/a.js?query=here&and=here#anchor',
    'protocols' : [ 'complex', 'protocol' ],
    'hostFull' : 'www.site.com:13',
    'origin' : 'complex+protocol://www.site.com:13',
    'full' : 'complex+protocol://www.site.com:13/dir?c/a.js?query=here&and=here#anchor'
  };
  test.identical( got, expected );

  var src = '/dir/*.js';
  var uri = 'complex+protocol://www.site.com:13/dir/*.js?query=here&and=here#anchor';
  var got = _.uriNew.parseFull( uri );
  var expected =
  {
    'protocol' : 'complex+protocol',
    'host' : 'www.site.com',
    'port' : 13,
    'resourcePath' : '/dir/*.js',
    'query' : 'query=here&and=here',
    'hash' : 'anchor',
    'longPath' : 'www.site.com:13/dir/*.js',
    'postfixedPath' : 'www.site.com:13/dir/*.js?query=here&and=here#anchor',
    'protocols' : [ 'complex', 'protocol' ],
    'hostFull' : 'www.site.com:13',
    'origin' : 'complex+protocol://www.site.com:13',
    'full' : 'complex+protocol://www.site.com:13/dir/*.js?query=here&and=here#anchor',
  };
  test.identical( got, expected );

  var src = '/dir/**.js';
  var uri = 'complex+protocol://www.site.com:13/dir/**.js?query=here&and=here#anchor';
  var got = _.uriNew.parseFull( uri );
  var expected =
  {
    'protocol' : 'complex+protocol',
    'host' : 'www.site.com',
    'port' : 13,
    'resourcePath' : '/dir/**.js',
    'query' : 'query=here&and=here',
    'hash' : 'anchor',
    'longPath' : 'www.site.com:13/dir/**.js',
    'postfixedPath' : 'www.site.com:13/dir/**.js?query=here&and=here#anchor',
    'protocols' : [ 'complex', 'protocol' ],
    'hostFull' : 'www.site.com:13',
    'origin' : 'complex+protocol://www.site.com:13',
    'full' : 'complex+protocol://www.site.com:13/dir/**.js?query=here&and=here#anchor',
  }
  test.identical( got, expected );

  var src = '/dir/**/a.js';
  var uri = 'complex+protocol://www.site.com:13/dir/**/a.js?query=here&and=here#anchor';
  var got = _.uriNew.parseFull( uri );
  var expected =
  {
    'protocol' : 'complex+protocol',
    'host' : 'www.site.com',
    'port' : 13,
    'resourcePath' : '/dir/**/a.js',
    'query' : 'query=here&and=here',
    'hash' : 'anchor',
    'longPath' : 'www.site.com:13/dir/**/a.js',
    'postfixedPath' : 'www.site.com:13/dir/**/a.js?query=here&and=here#anchor',
    'protocols' : [ 'complex', 'protocol' ],
    'hostFull' : 'www.site.com:13',
    'origin' : 'complex+protocol://www.site.com:13',
    'full' : 'complex+protocol://www.site.com:13/dir/**/a.js?query=here&and=here#anchor',
  };
  test.identical( got, expected );

  var src = '/dir?c/a.js';
  var uri = 'complex+protocol://www.site.com:13/dir?c/a.js?query=here&and=here#anchor';
  var got = _.uriNew.parseFull( uri );
  var expected =
  {
    'protocol' : 'complex+protocol',
    'host' : 'www.site.com',
    'port' : 13,
    'resourcePath' : '/dir?c/a.js',
    'query' : 'query=here&and=here',
    'hash' : 'anchor',
    'longPath' : 'www.site.com:13/dir?c/a.js',
    'postfixedPath' : 'www.site.com:13/dir?c/a.js?query=here&and=here#anchor',
    'protocols' : [ 'complex', 'protocol' ],
    'hostFull' : 'www.site.com:13',
    'origin' : 'complex+protocol://www.site.com:13',
    'full' : 'complex+protocol://www.site.com:13/dir?c/a.js?query=here&and=here#anchor'
  };
  test.identical( got, expected );

  var src = '/dir/*.js';
  var uri = 'complex+protocol://www.site.com:13/dir/*.js?query=here&and=here#anchor';
  var got = _.uriNew.parseFull( uri );
  var expected =
  {
    'protocol' : 'complex+protocol',
    'host' : 'www.site.com',
    'port' : 13,
    'resourcePath' : '/dir/*.js',
    'query' : 'query=here&and=here',
    'hash' : 'anchor',
    'longPath' : 'www.site.com:13/dir/*.js',
    'postfixedPath' : 'www.site.com:13/dir/*.js?query=here&and=here#anchor',
    'protocols' : [ 'complex', 'protocol' ],
    'hostFull' : 'www.site.com:13',
    'origin' : 'complex+protocol://www.site.com:13',
    'full' : 'complex+protocol://www.site.com:13/dir/*.js?query=here&and=here#anchor',
  };
  test.identical( got, expected );

  var src = '/dir/**/a.js';
  var uri = 'complex+protocol://www.site.com:13/dir/**/a.js?query=here&and=here#anchor';
  var got = _.uriNew.parseFull( uri );
  var expected =
  {
    'protocol' : 'complex+protocol',
    'host' : 'www.site.com',
    'port' : 13,
    'resourcePath' : '/dir/**/a.js',
    'query' : 'query=here&and=here',
    'hash' : 'anchor',
    'longPath' : 'www.site.com:13/dir/**/a.js',
    'postfixedPath' : 'www.site.com:13/dir/**/a.js?query=here&and=here#anchor',
    'protocols' : [ 'complex', 'protocol' ],
    'hostFull' : 'www.site.com:13',
    'origin' : 'complex+protocol://www.site.com:13',
    'full' : 'complex+protocol://www.site.com:13/dir/**/a.js?query=here&and=here#anchor',
  };
  test.identical( got, expected );

  var src = '/[a-c]';
  var uri = 'complex+protocol://www.site.com:13/[a-c]?query=here&and=here#anchor';
  var got = _.uriNew.parseFull( uri );
  var expected =
  {
    'protocol' : 'complex+protocol',
    'host' : 'www.site.com',
    'port' : 13,
    'resourcePath' : '/[a-c]',
    'query' : 'query=here&and=here',
    'hash' : 'anchor',
    'longPath' : 'www.site.com:13/[a-c]',
    'postfixedPath' : 'www.site.com:13/[a-c]?query=here&and=here#anchor',
    'protocols' : [ 'complex', 'protocol' ],
    'hostFull' : 'www.site.com:13',
    'origin' : 'complex+protocol://www.site.com:13',
    'full' : 'complex+protocol://www.site.com:13/[a-c]?query=here&and=here#anchor',
  };
  test.identical( got, expected );

  var src = '/{a-c}';
  var uri = 'complex+protocol://www.site.com:13/{a-c}?query=here&and=here#anchor';
  var got = _.uriNew.parseFull( uri );
  var expected =
  {
    'protocol' : 'complex+protocol',
    'host' : 'www.site.com',
    'port' : 13,
    'resourcePath' : '/{a-c}',
    'query' : 'query=here&and=here',
    'hash' : 'anchor',
    'longPath' : 'www.site.com:13/{a-c}',
    'postfixedPath' : 'www.site.com:13/{a-c}?query=here&and=here#anchor',
    'protocols' : [ 'complex', 'protocol' ],
    'hostFull' : 'www.site.com:13',
    'origin' : 'complex+protocol://www.site.com:13',
    'full' : 'complex+protocol://www.site.com:13/{a-c}?query=here&and=here#anchor',
  };
  test.identical( got, expected );

  var src = '/(a|b)';
  var uri = 'complex+protocol://www.site.com:13/(a|b)?query=here&and=here#anchor';
  var got = _.uriNew.parseFull( uri );
  var expected =
  {
    'protocol' : 'complex+protocol',
    'host' : 'www.site.com',
    'port' : 13,
    'resourcePath' : '/(a|b)',
    'query' : 'query=here&and=here',
    'hash' : 'anchor',
    'longPath' : 'www.site.com:13/(a|b)',
    'postfixedPath' : 'www.site.com:13/(a|b)?query=here&and=here#anchor',
    'protocols' : [ 'complex', 'protocol' ],
    'hostFull' : 'www.site.com:13',
    'origin' : 'complex+protocol://www.site.com:13',
    'full' : 'complex+protocol://www.site.com:13/(a|b)?query=here&and=here#anchor',
  };
  test.identical( got, expected );

  var src = '/@(ab)';
  var uri = 'complex+protocol://www.site.com:13/@(ab)?query=here&and=here#anchor';
  var got = _.uriNew.parseFull( uri );
  var expected =
  {
    'protocol' : 'complex+protocol',
    'host' : 'www.site.com',
    'port' : 13,
    'resourcePath' : '/',
    'tag' : '(ab)',
    'query' : 'query=here&and=here',
    'hash' : 'anchor',
    'longPath' : 'www.site.com:13/',
    'postfixedPath' : 'www.site.com:13/@(ab)?query=here&and=here#anchor',
    'protocols' : [ 'complex', 'protocol' ],
    'hostFull' : 'www.site.com:13',
    'origin' : 'complex+protocol://www.site.com:13',
    'full' : 'complex+protocol://www.site.com:13/@(ab)?query=here&and=here#anchor',
  };
  test.identical( got, expected );

  var src = '/!(ab)';
  var uri = 'complex+protocol://www.site.com:13/!(ab)?query=here&and=here#anchor';
  var got = _.uriNew.parseFull( uri );
  var expected =
  {
    'protocol' : 'complex+protocol',
    'host' : 'www.site.com',
    'port' : 13,
    'resourcePath' : '/!(ab)',
    'query' : 'query=here&and=here',
    'hash' : 'anchor',
    'longPath' : 'www.site.com:13/!(ab)',
    'postfixedPath' : 'www.site.com:13/!(ab)?query=here&and=here#anchor',
    'protocols' : [ 'complex', 'protocol' ],
    'hostFull' : 'www.site.com:13',
    'origin' : 'complex+protocol://www.site.com:13',
    'full' : 'complex+protocol://www.site.com:13/!(ab)?query=here&and=here#anchor',
  };
  test.identical( got, expected );

  var src = '/?(ab)';
  var uri = 'complex+protocol://www.site.com:13/?(ab)?query=here&and=here#anchor';
  var got = _.uriNew.parseFull( uri );
  var expected =
  {
    'protocol' : 'complex+protocol',
    'host' : 'www.site.com',
    'port' : 13,
    'resourcePath' : '/?(ab)',
    'query' : 'query=here&and=here',
    'hash' : 'anchor',
    'longPath' : 'www.site.com:13/?(ab)',
    'postfixedPath' : 'www.site.com:13/?(ab)?query=here&and=here#anchor',
    'protocols' : [ 'complex', 'protocol' ],
    'hostFull' : 'www.site.com:13',
    'origin' : 'complex+protocol://www.site.com:13',
    'full' : 'complex+protocol://www.site.com:13/?(ab)?query=here&and=here#anchor'
  };
  test.identical( got, expected );

  var src = '/*(ab)';
  var uri = 'complex+protocol://www.site.com:13/*(ab)?query=here&and=here#anchor';
  var got = _.uriNew.parseFull( uri );
  var expected =
  {
    'protocol' : 'complex+protocol',
    'host' : 'www.site.com',
    'port' : 13,
    'resourcePath' : '/*(ab)',
    'query' : 'query=here&and=here',
    'hash' : 'anchor',
    'longPath' : 'www.site.com:13/*(ab)',
    'postfixedPath' : 'www.site.com:13/*(ab)?query=here&and=here#anchor',
    'protocols' : [ 'complex', 'protocol' ],
    'hostFull' : 'www.site.com:13',
    'origin' : 'complex+protocol://www.site.com:13',
    'full' : 'complex+protocol://www.site.com:13/*(ab)?query=here&and=here#anchor',
  };
  test.identical( got, expected );

  var src = '/+(ab)';
  var uri = 'complex+protocol://www.site.com:13/+(ab)?query=here&and=here#anchor';
  var got = _.uriNew.parseFull( uri );
  var expected =
  {
    'protocol' : 'complex+protocol',
    'host' : 'www.site.com',
    'port' : 13,
    'resourcePath' : '/+(ab)',
    'query' : 'query=here&and=here',
    'hash' : 'anchor',
    'longPath' : 'www.site.com:13/+(ab)',
    'postfixedPath' : 'www.site.com:13/+(ab)?query=here&and=here#anchor',
    'protocols' : [ 'complex', 'protocol' ],
    'hostFull' : 'www.site.com:13',
    'origin' : 'complex+protocol://www.site.com:13',
    'full' : 'complex+protocol://www.site.com:13/+(ab)?query=here&and=here#anchor',
  };
  test.identical( got, expected );

  var src = '/dir/[a-c].js';
  var uri = 'complex+protocol://www.site.com:13/dir/[a-c].js?query=here&and=here#anchor';
  var got = _.uriNew.parseFull( uri );
  var expected =
  {
    'protocol' : 'complex+protocol',
    'host' : 'www.site.com',
    'port' : 13,
    'resourcePath' : '/dir/[a-c].js',
    'query' : 'query=here&and=here',
    'hash' : 'anchor',
    'longPath' : 'www.site.com:13/dir/[a-c].js',
    'postfixedPath' : 'www.site.com:13/dir/[a-c].js?query=here&and=here#anchor',
    'protocols' : [ 'complex', 'protocol' ],
    'hostFull' : 'www.site.com:13',
    'origin' : 'complex+protocol://www.site.com:13',
    'full' : 'complex+protocol://www.site.com:13/dir/[a-c].js?query=here&and=here#anchor'
  };
  test.identical( got, expected );

  var src = '/dir/{a,c}.js';
  var uri = 'complex+protocol://www.site.com:13/dir/{a,c}.js?query=here&and=here#anchor';
  var got = _.uriNew.parseFull( uri );
  var expected =
  {
    'protocol' : 'complex+protocol',
    'host' : 'www.site.com',
    'port' : 13,
    'resourcePath' : '/dir/{a,c}.js',
    'query' : 'query=here&and=here',
    'hash' : 'anchor',
    'longPath' : 'www.site.com:13/dir/{a,c}.js',
    'postfixedPath' : 'www.site.com:13/dir/{a,c}.js?query=here&and=here#anchor',
    'protocols' : [ 'complex', 'protocol' ],
    'hostFull' : 'www.site.com:13',
    'origin' : 'complex+protocol://www.site.com:13',
    'full' : 'complex+protocol://www.site.com:13/dir/{a,c}.js?query=here&and=here#anchor',
  };
  test.identical( got, expected );

  var src = '/dir/(a|b).js';
  var uri = 'complex+protocol://www.site.com:13/dir/(a|b).js?query=here&and=here#anchor';
  var got = _.uriNew.parseFull( uri );
  var expected =
  {
    'protocol' : 'complex+protocol',
    'host' : 'www.site.com',
    'port' : 13,
    'resourcePath' : '/dir/(a|b).js',
    'query' : 'query=here&and=here',
    'hash' : 'anchor',
    'longPath' : 'www.site.com:13/dir/(a|b).js',
    'postfixedPath' : 'www.site.com:13/dir/(a|b).js?query=here&and=here#anchor',
    'protocols' : [ 'complex', 'protocol' ],
    'hostFull' : 'www.site.com:13',
    'origin' : 'complex+protocol://www.site.com:13',
    'full' : 'complex+protocol://www.site.com:13/dir/(a|b).js?query=here&and=here#anchor'
  };
  test.identical( got, expected );

  var src = '/dir/(ab).js';
  var uri = 'complex+protocol://www.site.com:13/dir/(ab).js?query=here&and=here#anchor';
  var got = _.uriNew.parseFull( uri );
  var expected =
  {
    'protocol' : 'complex+protocol',
    'host' : 'www.site.com',
    'port' : 13,
    'resourcePath' : '/dir/(ab).js',
    'query' : 'query=here&and=here',
    'hash' : 'anchor',
    'longPath' : 'www.site.com:13/dir/(ab).js',
    'postfixedPath' : 'www.site.com:13/dir/(ab).js?query=here&and=here#anchor',
    'protocols' : [ 'complex', 'protocol' ],
    'hostFull' : 'www.site.com:13',
    'origin' : 'complex+protocol://www.site.com:13',
    'full' : 'complex+protocol://www.site.com:13/dir/(ab).js?query=here&and=here#anchor',
  };
  test.identical( got, expected );

  var src = '/dir/@(ab).js';
  var uri = 'complex+protocol://www.site.com:13/dir/@(ab).js?query=here&and=here#anchor';
  var got = _.uriNew.parseFull( uri );
  var expected =
  {
    'protocol' : 'complex+protocol',
    'host' : 'www.site.com',
    'port' : 13,
    'resourcePath' : '/dir/',
    'query' : 'query=here&and=here',
    'hash' : 'anchor',
    'tag' : '(ab).js',
    'longPath' : 'www.site.com:13/dir/',
    'postfixedPath' : 'www.site.com:13/dir/@(ab).js?query=here&and=here#anchor',
    'protocols' : [ 'complex', 'protocol' ],
    'hostFull' : 'www.site.com:13',
    'origin' : 'complex+protocol://www.site.com:13',
    'full' : 'complex+protocol://www.site.com:13/dir/@(ab).js?query=here&and=here#anchor'
  };
  test.identical( got, expected );

  var src = '/dir/?(ab).js';
  var uri = 'complex+protocol://www.site.com:13/dir/?(ab).js?query=here&and=here#anchor';
  var got = _.uriNew.parseFull( uri );
  var expected =
  {
    'protocol' : 'complex+protocol',
    'host' : 'www.site.com',
    'port' : 13,
    'resourcePath' : '/dir/?(ab).js',
    'query' : 'query=here&and=here',
    'hash' : 'anchor',
    'longPath' : 'www.site.com:13/dir/?(ab).js',
    'postfixedPath' : 'www.site.com:13/dir/?(ab).js?query=here&and=here#anchor',
    'protocols' : [ 'complex', 'protocol' ],
    'hostFull' : 'www.site.com:13',
    'origin' : 'complex+protocol://www.site.com:13',
    'full' : 'complex+protocol://www.site.com:13/dir/?(ab).js?query=here&and=here#anchor',
  };
  test.identical( got, expected );

  var src = '/dir/*(ab).js';
  var uri = 'complex+protocol://www.site.com:13/dir/*(ab).js?query=here&and=here#anchor';
  var got = _.uriNew.parseFull( uri );
  var expected =
  {
    'protocol' : 'complex+protocol',
    'host' : 'www.site.com',
    'port' : 13,
    'resourcePath' : '/dir/*(ab).js',
    'query' : 'query=here&and=here',
    'hash' : 'anchor',
    'longPath' : 'www.site.com:13/dir/*(ab).js',
    'postfixedPath' : 'www.site.com:13/dir/*(ab).js?query=here&and=here#anchor',
    'protocols' : [ 'complex', 'protocol' ],
    'hostFull' : 'www.site.com:13',
    'origin' : 'complex+protocol://www.site.com:13',
    'full' : 'complex+protocol://www.site.com:13/dir/*(ab).js?query=here&and=here#anchor',
  };
  test.identical( got, expected );

  var src = '/dir/+(ab).js';
  var uri = 'complex+protocol://www.site.com:13/dir/+(ab).js?query=here&and=here#anchor';
  var got = _.uriNew.parseFull( uri );
  var expected =
  {
    'protocol' : 'complex+protocol',
    'host' : 'www.site.com',
    'port' : 13,
    'resourcePath' : '/dir/+(ab).js',
    'query' : 'query=here&and=here',
    'hash' : 'anchor',
    'longPath' : 'www.site.com:13/dir/+(ab).js',
    'postfixedPath' : 'www.site.com:13/dir/+(ab).js?query=here&and=here#anchor',
    'protocols' : [ 'complex', 'protocol' ],
    'hostFull' : 'www.site.com:13',
    'origin' : 'complex+protocol://www.site.com:13',
    'full' : 'complex+protocol://www.site.com:13/dir/+(ab).js?query=here&and=here#anchor'
  };
  test.identical( got, expected );

  var src = '/index/**';
  var uri = 'complex+protocol://www.site.com:13/index/**?query=here&and=here#anchor';
  var got = _.uriNew.parseFull( uri );
  var expected =
  {
    'protocol' : 'complex+protocol',
    'host' : 'www.site.com',
    'port' : 13,
    'resourcePath' : '/index/**',
    'query' : 'query=here&and=here',
    'hash' : 'anchor',
    'longPath' : 'www.site.com:13/index/**',
    'postfixedPath' : 'www.site.com:13/index/**?query=here&and=here#anchor',
    'protocols' : [ 'complex', 'protocol' ],
    'hostFull' : 'www.site.com:13',
    'origin' : 'complex+protocol://www.site.com:13',
    'full' : 'complex+protocol://www.site.com:13/index/**?query=here&and=here#anchor'
  };
  test.identical( got, expected );

  test.close( 'complex uri' );

  // '?';
  // '*';
  // '**';
  // '?c.js';
  // '*.js';
  // '**/a.js';
  // 'dir?c/a.js';
  // 'dir/*.js';
  // 'dir/**.js';
  // 'dir/**/a.js';
  // '/dir?c/a.js';
  // '/dir/*.js';
  // '/dir/**.js';
  // '/dir/**/a.js';
  // '[a-c]';
  // '{a,c}';
  // '(a|b)';
  // '(ab)';
  // '@(ab)';
  // '!(ab)';
  // '?(ab)';
  // '*(ab)';
  // '+(ab)';
  // 'dir/[a-c].js';
  // 'dir/{a,c}.js';
  // 'dir/(a|b).js';
  // 'dir/(ab).js';
  // 'dir/@(ab).js';
  // 'dir/!(ab).js';
  // 'dir/?(ab).js';
  // 'dir/*(ab).js';
  // 'dir/+(ab).js';
  // '/index/**';
}

// //
//
// function parseTagExperiment( test )
// {
//
//   var exp =
//   {
//     'protocol' : 'git',
//     'host' : '',
//     'resourcePath' : '/git@bitbucket.org:org/repo.git/some/long/path',
//     'hash' : 'master',
//     'longPath' : '/git@bitbucket.org:org/repo.git/some/long/path',
//     'postfixedPath' : '/git@bitbucket.org:org/repo.git/some/long/path',
//     'protocols' : [ 'git' ],
//     'hostFull' : '',
//     'origin' : 'git://',
//     'full' : 'git:///git@bitbucket.org:org/repo.git/some/long/path#master'
//   }
//   var got =_.uriNew.parseFull( 'git:///git@bitbucket.org:org/repo.git/some/long/path#master' );
//   test.identical( got, exp );
//
//   var exp =
//   {
//     'protocol' : 'git',
//     'host' : '',
//     'resourcePath' : '/git@bitbucket.org:org/repo.git/some/long/path',
//     'tag' : 'master',
//     'longPath' : '/git@bitbucket.org:org/repo.git/some/long/path',
//     'postfixedPath' : '/git@bitbucket.org:org/repo.git/some/long/path',
//     'protocols' : [ 'git' ],
//     'hostFull' : '',
//     'origin' : 'git://',
//     'full' : 'git:///git@bitbucket.org:org/repo.git/some/long/path#master'
//   }
//   var got =_.uriNew.parseFull( 'git:///git@bitbucket.org:org/repo.git/some/long/path@master' );
//   test.identical( got, exp );
// }
//
// parseTagExperiment.experimental = 1;

//

function localFromGlobal( test )
{
  var src = '/some/staging/index.html'
  var expected = '/some/staging/index.html'
  var got = _.uriNew.localFromGlobal( src );
  test.identical( got, expected );

  var src = '/some/staging/index.html/'
  var expected =     '/some/staging/index.html/'
  var got = _.uriNew.localFromGlobal( src );
  test.identical( got, expected );

  var src = '//some/staging/index.html'
  var expected =     '//some/staging/index.html'
  var got = _.uriNew.localFromGlobal( src );
  test.identical( got, expected );

  var src = '//some/staging/index.html/'
  var expected =     '//some/staging/index.html/'
  var got = _.uriNew.localFromGlobal( src );
  test.identical( got, expected );

  var src = '///some/staging/index.html'
  var expected =     '///some/staging/index.html'
  var got = _.uriNew.localFromGlobal( src );
  test.identical( got, expected );

  var src = '///some/staging/index.html/'
  var expected =     '///some/staging/index.html/'
  var got = _.uriNew.localFromGlobal( src );
  test.identical( got, expected );

  var src = 'file:///some/staging/index.html'
  var expected =     '/some/staging/index.html'
  var got = _.uriNew.localFromGlobal( src );
  test.identical( got, expected );

  var src = 'file:///some/staging/index.html/'
  var expected =     '/some/staging/index.html/'
  var got = _.uriNew.localFromGlobal( src );
  test.identical( got, expected );

  var src = 'http://some.come/staging/index.html'
  var expected =     'some.come/staging/index.html'
  var got = _.uriNew.localFromGlobal( src );
  test.identical( got, expected );

  var src = 'http://some.come/staging/index.html/'
  var expected =     'some.come/staging/index.html/'
  var got = _.uriNew.localFromGlobal( src );
  test.identical( got, expected );

  var src = 'svn+https://user@subversion.com/svn/trunk'
  var expected =     'user@subversion.com/svn/trunk'
  var got = _.uriNew.localFromGlobal( src );
  test.identical( got, expected );

  var src = 'svn+https://user@subversion.com/svn/trunk/'
  var expected =     'user@subversion.com/svn/trunk/'
  var got = _.uriNew.localFromGlobal( src );
  test.identical( got, expected );

  var src = 'complex+protocol://www.site.com:13/path/name/?query=here&and=here#anchor'
  var expected =     'www.site.com:13/path/name/'
  var got = _.uriNew.localFromGlobal( src );
  test.identical( got, expected );

  var src = 'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor'
  var expected =     'www.site.com:13/path/name'
  var got = _.uriNew.localFromGlobal( src );
  test.identical( got, expected );

  var src = 'https://web.archive.org/web/*/http://www.heritage.org/index/ranking'
  var expected =     'web.archive.org/web/*/http://www.heritage.org/index/ranking'
  var got = _.uriNew.localFromGlobal( src );
  test.identical( got, expected );

  var src = 'https://web.archive.org//web//*//http://www.heritage.org//index//ranking'
  var expected =     'web.archive.org//web//*//http://www.heritage.org//index//ranking'
  var got = _.uriNew.localFromGlobal( src );
  test.identical( got, expected );

  var src = '://www.site.com:13/path//name//?query=here&and=here#anchor'
  var expected =     'www.site.com:13/path//name//'
  var got = _.uriNew.localFromGlobal( src );
  test.identical( got, expected );

  var src = ':///www.site.com:13/path//name/?query=here&and=here#anchor'
  var expected =     '/www.site.com:13/path//name/'
  var got = _.uriNew.localFromGlobal( src );
  test.identical( got, expected );

  /* */

  var src = _.uriNew.parse( ':///www.site.com:13/path//name/?query=here&and=here#anchor' );
  var expected =     '/www.site.com:13/path//name/'
  var got = _.uriNew.localFromGlobal( src );
  test.identical( got, expected );

}

//

function str( test )
{
  /* aaa : normalize test */ /* Dmytro : normalized */

  test.case = 'map is a String';
  var components = 'http://www.site.com:13/path/name?query=here&and=here#anchor';
  var expected = 'http://www.site.com:13/path/name?query=here&and=here#anchor';
  var got = _.uriNew.str( components );
  test.identical( got, expected );

  /* */

  test.case = 'only full field in map';
  var components =
  {
    full : 'http://www.site.com:13/path/name?query=here&and=here#anchor',
  };
  var expected = 'http://www.site.com:13/path/name?query=here&and=here#anchor';
  var got = _.uriNew.str( components );
  test.identical( got, expected );

  /* */

  test.case = 'from atomic parsed path, resourcePath - global';
  var components =
  {
    host: 'www.site.com',
    protocol: 'http',
    resourcePath: '/z',
  };
  var expected = 'http://www.site.com//z';
  var got = _.uriNew.str( components );
  test.identical( got, expected );

  /* */

  test.case = 'from atomic parsed path, resourcePath - local';
  var components =
  {
    protocol : 'http',
    host : 'www.site.com',
    port : 13,
    resourcePath : 'path/name',
    query : 'query=here&and=here',
    hash : 'anchor',
  };
  var expected = 'http://www.site.com:13/path/name?query=here&and=here#anchor';
  var got = _.uriNew.str( components );
  test.identical( got, expected );

  /* */

  test.case = 'from atomic parsed path, resourcePath - global';
  var components =
  {
    protocol : 'http',
    host : 'www.site.com',
    port : 13,
    resourcePath : '/path/name',
    query : 'query=here&and=here',
    hash : 'anchor',
  };
  var expected = 'http://www.site.com:13//path/name?query=here&and=here#anchor';
  var got = _.uriNew.str( components );
  test.identical( got, expected );

  /* */

  test.case = 'from composites components with field origin';
  var components =
  {
    resourcePath : '/path/name',
    query : 'query=here&and=here',
    hash : 'anchor',
    origin : 'http://www.site.com:13'
  };
  var expected = 'http://www.site.com:13//path/name?query=here&and=here#anchor';
  var got = _.uriNew.str( components );
  test.identical( got, expected );

  /* */

  test.case = 'from host and resourcePath';
  var components =
  {
    host : 'some.domain.com',
    resourcePath : 'was',
  };
  var expected = 'some.domain.com/was';
  var got = _.uriNew.str( components );
  test.identical( got, expected );

  /* */

  test.case = 'no host, but protocol, resourcePath - global';
  var components =
  {
    resourcePath : '/some2',
    protocol : 'src',
  };
  var expected = 'src:///some2';
  var got = _.uriNew.str( components );
  test.identical( got, expected );

  test.case = 'no host, but protocol, resourcePath - local';
  var components =
  {
    resourcePath : 'some2',
    protocol : 'src',
  };
  var expected = 'src://some2';
  var got = _.uriNew.str( components );
  test.identical( got, expected );

  /* */

  test.case = 'hash and protocol - null, from longPath and protocols';
  var components =
  {
    protocol : null,
    hash : null,
    longPath : '/github.com/user/repo.git',
    protocols : [ 'git' ]
  }
  var expected = 'git:///github.com/user/repo.git';
  var got = _.uriNew.str( components );
  test.identical( got, expected );

  /* */

  test.case = 'from full parsed, resourcePath - global';
  var components =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/git@bitbucket.org:someorg/somerepo.git',
    hash : 'hash',
    longPath : '/git@bitbucket.org:someorg/somerepo.git',
    protocols : [ 'git' ],
    hostFull : '',
    origin : 'git://',
  }
  var expected = 'git:///git@bitbucket.org:someorg/somerepo.git#hash'
  var got = _.uriNew.str( components );
  test.identical( got, expected );

  test.case = 'from full parsed, resourcePath - global, resourcePath ends by upToken';
  var components =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/git@bitbucket.org:someorg/somerepo.git/',
    hash : 'hash',
    longPath : '/git@bitbucket.org:someorg/somerepo.git/',
    protocols : [ 'git' ],
    hostFull : '',
    origin : 'git://'
  }
  var expected = 'git:///git@bitbucket.org:someorg/somerepo.git/#hash';
  var got = _.uriNew.str( components );
  test.identical( got, expected );

  var components =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/somerepo.git',
    hash : 'hash',
    longPath : '/somerepo.git',
    protocols : [ 'git' ],
    hostFull : '',
    origin : 'git://',
  }
  var expected  = 'git:///somerepo.git#hash'
  var got = _.uriNew.str ( components);
  test.identical( got, expected );

  var components =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/somerepo.git/',
    hash : 'hash',
    longPath : '/somerepo.git/',
    protocols : [ 'git' ],
    hostFull : '',
    origin : 'git://',
  }
  var expected = 'git:///somerepo.git/#hash'
  var got = _.uriNew.str( components );
  test.identical( got, expected );

  test.case = 'from full parsed, with tag, resourcePath - global, resourcePath ends by upToken';
  var components =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/git@bitbucket.org:someorg/somerepo.git/',
    tag : 'tag',
    longPath : '/git@bitbucket.org:someorg/somerepo.git/',
    protocols : [ 'git' ],
    hostFull : '',
    origin : 'git://',
  }
  var expected = 'git:///git@bitbucket.org:someorg/somerepo.git/!tag'
  var got = _.uriNew.str( components );
  test.identical( got, expected );

  var components =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/somerepo.git/',
    tag : 'tag',
    longPath : '/somerepo.git/',
    protocols : [ 'git' ],
    hostFull : '',
    origin : 'git://',
  }
  var expected = 'git:///somerepo.git/!tag'
  var got = _.uriNew.str( components );
  test.identical( got, expected );

  test.case = 'from full parsed, longPath - global';
  var components =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/git@bitbucket.org:someorg/somerepo.git',
    hash : 'hash',
    tag : 'tag',
    longPath : '/git@bitbucket.org:someorg/somerepo.git',
    protocols : [ 'git' ],
    hostFull : '',
    origin : 'git://',
  }
  var expected = 'git:///git@bitbucket.org:someorg/somerepo.git#hash!tag'
  var got = _.uriNew.str( components );
  test.identical( got, expected );

  test.case = 'from full parsed, longPath - global, longPath ends by upToken';
  var components =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/git@bitbucket.org:someorg/somerepo.git/',
    hash : 'hash',
    tag : 'tag',
    longPath : '/git@bitbucket.org:someorg/somerepo.git/',
    protocols : [ 'git' ],
    hostFull : '',
    origin : 'git://',
  }
  var expected = 'git:///git@bitbucket.org:someorg/somerepo.git/#hash!tag'
  var got = _.uriNew.str( components );
  test.identical( got, expected );

  var components =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/somerepo.git',
    hash : 'hash',
    tag : 'tag',
    longPath : '/somerepo.git',
    protocols : [ 'git' ],
    hostFull : '',
    origin : 'git://',
  }
  var expected = 'git:///somerepo.git#hash!tag'
  var got = _.uriNew.str( components );
  test.identical( got, expected );

  var components =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/somerepo.git/',
    hash : 'hash',
    tag : 'tag',
    longPath : '/somerepo.git/',
    protocols : [ 'git' ],
    hostFull : '',
    origin : 'git://',
  }
  var expected = 'git:///somerepo.git/#hash!tag'
  var got = _.uriNew.str( components );
  test.identical( got, expected );

  test.case = 'from full parsed, with query';
  var components =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/git@bitbucket.org:someorg/somerepo.git',
    query : 'query=1',
    hash : 'hash',
    tag : 'tag',
    longPath : '/git@bitbucket.org:someorg/somerepo.git',
    protocols : [ 'git' ],
    hostFull : '',
    origin : 'git://',
  }
  var expected = 'git:///git@bitbucket.org:someorg/somerepo.git?query=1#hash!tag'
  var got = _.uriNew.str( components );
  test.identical( got, expected );

  var components =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/git@bitbucket.org:someorg/somerepo.git/',
    query : 'query=1',
    hash : 'hash',
    tag : 'tag',
    longPath : '/git@bitbucket.org:someorg/somerepo.git/',
    protocols : [ 'git' ],
    hostFull : '',
    origin : 'git://',
  }
  var expected = 'git:///git@bitbucket.org:someorg/somerepo.git/?query=1#hash!tag'
  var got = _.uriNew.str( components );
  test.identical( got, expected );

  var components =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/somerepo.git',
    query : 'query=1',
    hash : 'hash',
    tag : 'tag',
    longPath : '/somerepo.git',
    protocols : [ 'git' ],
    hostFull : '',
    origin : 'git://',
  }
  var expected = 'git:///somerepo.git?query=1#hash!tag'
  var got = _.uriNew.str( components );
  test.identical( got, expected );

  var components =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/somerepo.git/',
    query : 'query=1',
    hash : 'hash',
    tag : 'tag',
    longPath : '/somerepo.git/',
    protocols : [ 'git' ],
    hostFull : '',
    origin : 'git://',
  }
  var expected = 'git:///somerepo.git/?query=1#hash!tag'
  var got = _.uriNew.str( components );
  test.identical( got, expected );

  var components =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/git@bitbucket.org:someorg/somerepo.git',
    query : 'query=1',
    tag : 'tag',
    longPath : '/git@bitbucket.org:someorg/somerepo.git',
    protocols : [ 'git' ],
    hostFull : '',
    origin : 'git://',
  }
  var expected = 'git:///git@bitbucket.org:someorg/somerepo.git?query=1!tag'
  var got = _.uriNew.str( components );
  test.identical( got, expected );

  var components =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/git@bitbucket.org:someorg/somerepo.git/',
    query : 'query=1',
    tag : 'tag',
    longPath : '/git@bitbucket.org:someorg/somerepo.git/',
    protocols : [ 'git' ],
    hostFull : '',
    origin : 'git://',
  }
  var expected = 'git:///git@bitbucket.org:someorg/somerepo.git/?query=1!tag'
  var got = _.uriNew.str( components );
  test.identical( got, expected );

  var components =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/somerepo.git',
    query : 'query=1',
    tag : 'tag',
    longPath : '/somerepo.git',
    protocols : [ 'git' ],
    hostFull : '',
    origin : 'git://',
  };
  var expected = 'git:///somerepo.git?query=1!tag'
  var got = _.uriNew.str( components );
  test.identical( got, expected );

  var components =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/somerepo.git/',
    query : 'query=1',
    tag : 'tag',
    longPath : '/somerepo.git/',
    protocols : [ 'git' ],
    hostFull : '',
    origin : 'git://',
  };
  var expected = 'git:///somerepo.git/?query=1!tag'
  var got = _.uriNew.str( components );
  test.identical( got, expected );

  /* - */

  if( !Config.debug )
  return;

  test.case = 'without arguments';
  test.shouldThrowErrorSync( () => _.uriNew.str() );

  test.case = 'extra arguments';
  test.shouldThrowErrorSync( () => _.uriNew.str( 'a', 'b' ) );

  test.case = 'unknown field in map';
  test.shouldThrowErrorSync( () => _.uriNew.str({ x : 'x' }) );

}

//

function full( test )
{

  /* */

  test.case = 'string basePath string';
  var components = 'http://www.site.com:13/path/name?query=here&and=here#anchor';
  var expected = 'http://www.site.com:13/path/name?query=here&and=here#anchor';
  var got = _.uriNew.full( components );
  test.identical( got, expected );

  /* */

  test.case = 'make uri basePath components uri';
  var components =
  {
    full : 'http://www.site.com:13/path/name?query=here&and=here#anchor'
  }
  var got = _.uriNew.full( components );
  var expected = 'http://www.site.com:13/path/name?query=here&and=here#anchor';
  test.identical( got, expected );

  /* */

  test.case = 'make uri basePath atomic components';
  var components =
  {
    protocol : 'http',
    host : 'www.site.com',
    port : 13,
    resourcePath : 'path/name',
    query : 'query=here&and=here',
    hash : 'anchor',
  }
  var expected = 'http://www.site.com:13/path/name?query=here&and=here#anchor';
  var got = _.uriNew.full( components );
  test.identical( got, expected );

  /* */

  test.case = 'make uri basePath composites components: origin';
  var components =
  {
    resourcePath : 'path/name',
    query : 'query=here&and=here',
    hash : 'anchor',
    origin : 'http://www.site.com:13'
  }
  var expected = 'http://www.site.com:13/path/name?query=here&and=here#anchor';
  var got = _.uriNew.full( components );
  test.identical( got, expected );

  /* */

  test.case = 'make uri basePath composites components: hostFull';
  var components =
  {
    protocol : 'http',
    resourcePath : 'path/name',
    query : 'query=here&and=here',
    hash : 'anchor',

    hostFull : 'www.site.com:13'
  }
  var expected = 'http://www.site.com:13/path/name?query=here&and=here#anchor';
  var got = _.uriNew.full( components );
  test.identical( got, expected );

  /* */

  test.case = 'make uri basePath composites components: hostFull';
  var expected = 'some.domain.com/was';
  var components =
  {
    host : 'some.domain.com',
    resourcePath : 'was',
  }
  var got = _.uriNew.full( components );
  test.identical( got, expected );

  /* */

  test.case = 'no host, but protocol'

  var components =
  {
    resourcePath : '/some2',
    protocol : 'src',
  }
  var expected = 'src:///some2';
  var got = _.uriNew.full( components );
  test.identical( got, expected );

  var components =
  {
    resourcePath : 'some2',
    protocol : 'src',
  }
  var expected = 'src://some2';
  var got = _.uriNew.full( components );
  test.identical( got, expected );

  /* */

  test.case = 'hash and protocol null, but protocols presents'

  var components =
  {
    protocol : null,
    hash : null,
    longPath : '/github.com/user/repo.git',
    protocols : [ 'git' ]
  }
  var expected = 'git:///github.com/user/repo.git';
  var got = _.uriNew.full( components );
  test.identical( got, expected );

  var components =
  {
    protocol : 'git',
    host : '',
    resourcePath : 'git@bitbucket.org:someorg/somerepo.git',
    hash : 'hash',
    longPath : '/git@bitbucket.org:someorg/somerepo.git',
    protocols : [ 'git' ],
    hostFull : '',
    origin : 'git://',
  }
  var expected = 'git:///git@bitbucket.org:someorg/somerepo.git#hash'
  var got = _.uriNew.full( components );
  test.identical( got, expected );

  var components =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/git@bitbucket.org:someorg/somerepo.git/',
    hash : 'hash',
    longPath : '/git@bitbucket.org:someorg/somerepo.git/',
    protocols : [ 'git' ],
    hostFull : '',
    origin : 'git://'
  }
  var expected = 'git:///git@bitbucket.org:someorg/somerepo.git/#hash';
  var got = _.uriNew.full( components );
  test.identical( got, expected );

  var components =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/somerepo.git',
    hash : 'hash',
    longPath : '/somerepo.git',
    protocols : [ 'git' ],
    hostFull : '',
    origin : 'git://',
  }
  var expected  = 'git:///somerepo.git#hash'
  var got = _.uriNew.full ( components);
  test.identical( got, expected );

  var components =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/somerepo.git/',
    hash : 'hash',
    longPath : '/somerepo.git/',
    protocols : [ 'git' ],
    hostFull : '',
    origin : 'git://',
  }
  var expected = 'git:///somerepo.git/#hash'
  var got = _.uriNew.full( components );
  test.identical( got, expected );

  var components =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/git@bitbucket.org:someorg/somerepo.git/',
    tag : 'tag',
    longPath : '/git@bitbucket.org:someorg/somerepo.git/',
    protocols : [ 'git' ],
    hostFull : '',
    origin : 'git://',
  }
  var expected = 'git:///git@bitbucket.org:someorg/somerepo.git/!tag'
  var got = _.uriNew.full( components );
  test.identical( got, expected );

  var components =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/somerepo.git/',
    tag : 'tag',
    longPath : '/somerepo.git/',
    protocols : [ 'git' ],
    hostFull : '',
    origin : 'git://',
  }
  var expected = 'git:///somerepo.git/!tag'
  var got = _.uriNew.full( components );
  test.identical( got, expected );

  var components =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/git@bitbucket.org:someorg/somerepo.git',
    hash : 'hash',
    tag : 'tag',
    longPath : '/git@bitbucket.org:someorg/somerepo.git',
    protocols : [ 'git' ],
    hostFull : '',
    origin : 'git://',
  }
  var expected = 'git:///git@bitbucket.org:someorg/somerepo.git#hash!tag'
  var got = _.uriNew.full( components );
  test.identical( got, expected );

  var components =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/git@bitbucket.org:someorg/somerepo.git/',
    hash : 'hash',
    tag : 'tag',
    longPath : '/git@bitbucket.org:someorg/somerepo.git/',
    protocols : [ 'git' ],
    hostFull : '',
    origin : 'git://',
  }
  var expected = 'git:///git@bitbucket.org:someorg/somerepo.git/#hash!tag'
  var got = _.uriNew.full( components );
  test.identical( got, expected );

  var components =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/somerepo.git',
    hash : 'hash',
    tag : 'tag',
    longPath : '/somerepo.git',
    protocols : [ 'git' ],
    hostFull : '',
    origin : 'git://',
  }
  var expected = 'git:///somerepo.git#hash!tag'
  var got = _.uriNew.full( components );
  test.identical( got, expected );

  var components =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/somerepo.git/',
    hash : 'hash',
    tag : 'tag',
    longPath : '/somerepo.git/',
    protocols : [ 'git' ],
    hostFull : '',
    origin : 'git://',
  }
  var expected = 'git:///somerepo.git/#hash!tag'
  var got = _.uriNew.full( components );
  test.identical( got, expected );

  var components =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/git@bitbucket.org:someorg/somerepo.git',
    query : 'query=1',
    hash : 'hash',
    tag : 'tag',
    longPath : '/git@bitbucket.org:someorg/somerepo.git',
    protocols : [ 'git' ],
    hostFull : '',
    origin : 'git://',
  }
  var expected = 'git:///git@bitbucket.org:someorg/somerepo.git?query=1#hash!tag'
  var got = _.uriNew.full( components );
  test.identical( got, expected );

  var components =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/git@bitbucket.org:someorg/somerepo.git/',
    query : 'query=1',
    hash : 'hash',
    tag : 'tag',
    longPath : '/git@bitbucket.org:someorg/somerepo.git/',
    protocols : [ 'git' ],
    hostFull : '',
    origin : 'git://',
  }
  var expected = 'git:///git@bitbucket.org:someorg/somerepo.git/?query=1#hash!tag'
  var got = _.uriNew.full( components );
  test.identical( got, expected );

  var components =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/somerepo.git',
    query : 'query=1',
    hash : 'hash',
    tag : 'tag',
    longPath : '/somerepo.git',
    protocols : [ 'git' ],
    hostFull : '',
    origin : 'git://',
  }
  var expected = 'git:///somerepo.git?query=1#hash!tag'
  var got = _.uriNew.full( components );
  test.identical( got, expected );

  var components =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/somerepo.git/',
    query : 'query=1',
    hash : 'hash',
    tag : 'tag',
    longPath : '/somerepo.git/',
    protocols : [ 'git' ],
    hostFull : '',
    origin : 'git://',
  }
  var expected = 'git:///somerepo.git/?query=1#hash!tag'
  var got = _.uriNew.full( components );
  test.identical( got, expected );

  var components =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/git@bitbucket.org:someorg/somerepo.git',
    query : 'query=1',
    tag : 'tag',
    longPath : '/git@bitbucket.org:someorg/somerepo.git',
    protocols : [ 'git' ],
    hostFull : '',
    origin : 'git://',
  }
  var expected = 'git:///git@bitbucket.org:someorg/somerepo.git?query=1!tag'
  var got = _.uriNew.full( components );
  test.identical( got, expected );

  var components =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/git@bitbucket.org:someorg/somerepo.git/',
    query : 'query=1',
    tag : 'tag',
    longPath : '/git@bitbucket.org:someorg/somerepo.git/',
    protocols : [ 'git' ],
    hostFull : '',
    origin : 'git://',
  }
  var expected = 'git:///git@bitbucket.org:someorg/somerepo.git/?query=1!tag'
  var got = _.uriNew.full( components );
  test.identical( got, expected );

  var components =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/somerepo.git',
    query : 'query=1',
    tag : 'tag',
    longPath : '/somerepo.git',
    protocols : [ 'git' ],
    hostFull : '',
    origin : 'git://',
  }
  var expected = 'git:///somerepo.git?query=1!tag'
  var got = _.uriNew.full( components );
  test.identical( got, expected );

  var components =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/somerepo.git/',
    query : 'query=1',
    tag : 'tag',
    longPath : '/somerepo.git/',
    protocols : [ 'git' ],
    hostFull : '',
    origin : 'git://',
  }
  var expected = 'git:///somerepo.git/?query=1!tag'
  var got = _.uriNew.full( components );
  test.identical( got, expected );

  /* */

  let original = _realGlobal_.location;
  _realGlobal_.location = { origin : 'git://' }
  var components =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/somerepo.git/',
    query : 'query=1',
    tag : 'tag',
    longPath : '/somerepo.git/',
    protocols : [ 'git' ],
    hostFull : '',
  }
  var got = _.uriNew.full( components );
  test.identical( got, expected );
  _realGlobal_.location = original;

}

//

function parseAndStr( test )
{

  test.open( 'all' );

  /* - */

  test.case = 'no protocol';

  var uri = '127.0.0.1:61726/../path';
  var parsed = _.uriNew.parse( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  test.case = 'other';

  var uri = '/some/staging/index.html';
  var parsed = _.uriNew.parse( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = '//some/staging/index.html';
  var parsed = _.uriNew.parse( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = '//www.site.com/index.html';
  var parsed = _.uriNew.parse( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = '///index.html';
  var parsed = _.uriNew.parse( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = '//www.site.com:/index.html';
  var parsed = _.uriNew.parse( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = '//www.site.com:13/index.html';
  var parsed = _.uriNew.parse( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = '//www.site.com:13/index.html?query=here&and=here#anchor';
  var parsed = _.uriNew.parse( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = '///some/staging/index.html';
  var parsed = _.uriNew.parse( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = '///some.com:99/staging/index.html';
  var parsed = _.uriNew.parse( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = '///some.com:99/staging/index.html?query=here&and=here#anchor';
  var parsed = _.uriNew.parse( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = 'file:///some/staging/index.html';
  var parsed = _.uriNew.parse( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = 'file:///some.com:/staging/index.html?query=here&and=here#anchor';
  var parsed = _.uriNew.parse( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = 'http://some.come/staging/index.html';
  var parsed = _.uriNew.parse( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = 'http://some.come:88/staging/index.html';
  var parsed = _.uriNew.parse( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = 'http://some.come:88/staging/?query=here&and=here#anchor';
  var parsed = _.uriNew.parse( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = 'svn+https://user@subversion.com/svn/trunk';
  var parsed = _.uriNew.parse( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = 'svn+https://user@subversion.com:99/svn/trunk';
  var parsed = _.uriNew.parse( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = 'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor';
  var parsed = _.uriNew.parse( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = 'complex+protocol://www.site.com:13/path/name?';
  var parsed = _.uriNew.parse( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = 'complex+protocol://www.site.com:13/path/name?#';
  var parsed = _.uriNew.parse( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = 'https://web.archive.org/web/*/http://www.heritage.org/index/ranking';
  var parsed = _.uriNew.parse( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = '://www.site.com:13/path//name//?query=here&and=here#anchor';
  var parsed = _.uriNew.parse( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = ':///www.site.com:13/path//name//?query=here&and=here#anchor';
  var parsed = _.uriNew.parse( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = 'protocol://';
  var parsed = _.uriNew.parse( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = '//:99';
  var parsed = _.uriNew.parse( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = '://:99';
  var parsed = _.uriNew.parse( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = '//?q=1#x';
  var parsed = _.uriNew.parse( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = '//';
  var parsed = _.uriNew.parse( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = '//a/b/c';
  var parsed = _.uriNew.parse( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = '///';
  var parsed = _.uriNew.parse( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = '///a/b/c';
  var parsed = _.uriNew.parse( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var expectedParsed =
  {
    'protocol' : 'ext',
    'host' : '..',
    'resourcePath' : 'src',
    'longPath' : '../src',
    'postfixedPath' : '../src',
    'protocols' : [ 'ext' ],
    'hostFull' : '..',
    'origin' : 'ext://..',
    'full' : 'ext://../src'
  }
  var uri = 'ext://../src';
  var parsed = _.uriNew.parse( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );
  test.identical( parsed, expectedParsed );

  /* - */

  test.close( 'all' );
  test.open( 'atomic' );

  /* - */

  test.case = 'no protocol';

  var uri = '127.0.0.1:61726/../path';
  var parsed = _.uriNew.parseAtomic( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  test.case = 'other';

  var uri = '/some/staging/index.html';
  var parsed = _.uriNew.parseAtomic( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = '//some/staging/index.html';
  var parsed = _.uriNew.parseAtomic( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = '//www.site.com/index.html';
  var parsed = _.uriNew.parseAtomic( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = '///index.html';
  var parsed = _.uriNew.parseAtomic( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = '//www.site.com:/index.html';
  var parsed = _.uriNew.parseAtomic( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = '//www.site.com:13/index.html';
  var parsed = _.uriNew.parseAtomic( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = '//www.site.com:13/index.html?query=here&and=here#anchor';
  var parsed = _.uriNew.parseAtomic( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = '///some/staging/index.html';
  var parsed = _.uriNew.parseAtomic( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = '///some.com:99/staging/index.html';
  var parsed = _.uriNew.parseAtomic( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = '///some.com:99/staging/index.html?query=here&and=here#anchor';
  var parsed = _.uriNew.parseAtomic( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = 'file:///some/staging/index.html';
  var parsed = _.uriNew.parseAtomic( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = 'file:///some.com:/staging/index.html?query=here&and=here#anchor';
  var parsed = _.uriNew.parseAtomic( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = 'http://some.come/staging/index.html';
  var parsed = _.uriNew.parseAtomic( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = 'http://some.come:88/staging/index.html';
  var parsed = _.uriNew.parseAtomic( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = 'http://some.come:88/staging/?query=here&and=here#anchor';
  var parsed = _.uriNew.parseAtomic( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = 'svn+https://user@subversion.com/svn/trunk';
  var parsed = _.uriNew.parseAtomic( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = 'svn+https://user@subversion.com:99/svn/trunk';
  var parsed = _.uriNew.parseAtomic( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = 'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor';
  var parsed = _.uriNew.parseAtomic( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = 'complex+protocol://www.site.com:13/path/name?';
  var parsed = _.uriNew.parseAtomic( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = 'complex+protocol://www.site.com:13/path/name?#';
  var parsed = _.uriNew.parseAtomic( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = 'https://web.archive.org/web/*/http://www.heritage.org/index/ranking';
  var parsed = _.uriNew.parseAtomic( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = '://www.site.com:13/path//name//?query=here&and=here#anchor';
  var parsed = _.uriNew.parseAtomic( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = ':///www.site.com:13/path//name//?query=here&and=here#anchor';
  var parsed = _.uriNew.parseAtomic( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = 'protocol://';
  var parsed = _.uriNew.parseAtomic( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = '//:99';
  var parsed = _.uriNew.parseAtomic( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = '://:99';
  var parsed = _.uriNew.parseAtomic( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = '//?q=1#x';
  var parsed = _.uriNew.parseAtomic( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = '//';
  var parsed = _.uriNew.parseAtomic( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = '//a/b/c';
  var parsed = _.uriNew.parseAtomic( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = '///';
  var parsed = _.uriNew.parseAtomic( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = '///a/b/c';
  var parsed = _.uriNew.parseAtomic( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = 'git:///github.com/user/repo.git';
  var parsed = _.uriNew.parseAtomic( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  /* - */

  test.close( 'atomic' );
  test.open( 'consecutive' );

  /* - */

  test.case = 'no protocol';

  var uri = '127.0.0.1:61726/../path';
  var parsed = _.uriNew.parseConsecutive( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  test.case = 'other';

  var uri = '/some/staging/index.html';
  var parsed = _.uriNew.parseConsecutive( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = '//some/staging/index.html';
  var parsed = _.uriNew.parseConsecutive( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = '//www.site.com/index.html';
  var parsed = _.uriNew.parseConsecutive( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = '///index.html';
  var parsed = _.uriNew.parseConsecutive( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = '//www.site.com:/index.html';
  var parsed = _.uriNew.parseConsecutive( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = '//www.site.com:13/index.html';
  var parsed = _.uriNew.parseConsecutive( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = '//www.site.com:13/index.html?query=here&and=here#anchor';
  var parsed = _.uriNew.parseConsecutive( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = '///some/staging/index.html';
  var parsed = _.uriNew.parseConsecutive( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = '///some.com:99/staging/index.html';
  var parsed = _.uriNew.parseConsecutive( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = '///some.com:99/staging/index.html?query=here&and=here#anchor';
  var parsed = _.uriNew.parseConsecutive( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = 'file:///some/staging/index.html';
  var parsed = _.uriNew.parseConsecutive( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = 'file:///some.com:/staging/index.html?query=here&and=here#anchor';
  var parsed = _.uriNew.parseConsecutive( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = 'http://some.come/staging/index.html';
  var parsed = _.uriNew.parseConsecutive( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = 'http://some.come:88/staging/index.html';
  var parsed = _.uriNew.parseConsecutive( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = 'http://some.come:88/staging/?query=here&and=here#anchor';
  var parsed = _.uriNew.parseConsecutive( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = 'svn+https://user@subversion.com/svn/trunk';
  var parsed = _.uriNew.parseConsecutive( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = 'svn+https://user@subversion.com:99/svn/trunk';
  var parsed = _.uriNew.parseConsecutive( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = 'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor';
  var parsed = _.uriNew.parseConsecutive( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = 'complex+protocol://www.site.com:13/path/name?';
  var parsed = _.uriNew.parseConsecutive( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = 'complex+protocol://www.site.com:13/path/name?#';
  var parsed = _.uriNew.parseConsecutive( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = 'https://web.archive.org/web/*/http://www.heritage.org/index/ranking';
  var parsed = _.uriNew.parseConsecutive( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = '://www.site.com:13/path//name//?query=here&and=here#anchor';
  var parsed = _.uriNew.parseConsecutive( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = ':///www.site.com:13/path//name//?query=here&and=here#anchor';
  var parsed = _.uriNew.parseConsecutive( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = 'protocol://';
  var parsed = _.uriNew.parseConsecutive( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = '//:99';
  var parsed = _.uriNew.parseConsecutive( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = '://:99';
  var parsed = _.uriNew.parseConsecutive( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = '//?q=1#x';
  var parsed = _.uriNew.parseConsecutive( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = '//';
  var parsed = _.uriNew.parseConsecutive( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = '//a/b/c';
  var parsed = _.uriNew.parseConsecutive( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = '///';
  var parsed = _.uriNew.parseConsecutive( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = '///a/b/c';
  var parsed = _.uriNew.parseConsecutive( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  var uri = 'git:///github.com/user/repo.git';
  var parsed = _.uriNew.parseConsecutive( uri );
  var got = _.uriNew.str( parsed );
  test.identical( got, uri );

  /* - */

  test.close( 'consecutive' );

}

//

function documentGet( test )
{

  /* qqq : normalize test */

  var uri1 = 'https://www.site.com:13/path/name?query=here&and=here#anchor';
  var uri2 = 'www.site.com:13/path/name?query=here&and=here#anchor';
  var uri3 = 'http://www.site.com:13/path/name';
  var options1 = { withoutServer : 1 };
  var options2 = { withoutProtocol : 1 };
  var expected1 = 'https://www.site.com:13/path/name';
  var expected2 = 'http://www.site.com:13/path/name';
  var expected3 = 'www.site.com:13/path/name';
  var expected4 = '/path/name';

  test.case = 'full components uri';
  var got = _.uriNew.documentGet( uri1 );
  test.contains( got, expected1 );

  test.case = 'uri without protocol';
  var got = _.uriNew.documentGet( uri2 );
  test.contains( got, expected2 );

  test.case = 'uri without query, options withoutProtocol = 1';
  var got = _.uriNew.documentGet( uri3, options2 );
  test.contains( got, expected3 );

  test.case = 'get path only';
  var got = _.uriNew.documentGet( uri1, options1 );
  test.contains( got, expected4 );

}

//

function server( test )
{
  var string = 'http://www.site.com:13/path/name?query=here&and=here#anchor';
  var expected = 'http://www.site.com:13/';

  test.case = 'get server part of uri';
  var got = _.uriNew.server( string );
  test.contains( got, expected );

}

//

function query( test )
{
  var string = 'http://www.site.com:13/path/name?query=here&and=here#anchor';
  var expected = 'query=here&and=here#anchor';

  test.case = 'get query part of uri';
  var got = _.uriNew.query( string );
  test.contains( got, expected );

}

//

function dequery( test )
{
  /* qqq : normalize test */

  var query1 = 'key=value';
  var query2 = 'key1=value1&key2=value2&key3=value3';
  var query3 = 'k1=&k2=v2%20v3&k3=v4_v4';
  var expected1 = { key : 'value' };
  var expected2 =
  {
    key1 : 'value1',
    key2 : 'value2',
    key3 : 'value3'
  };
  var expected3 =
  {
    k1 : '',
    k2 : 'v2 v3',
    k3 : 'v4_v4'
  };

  test.case = 'parse simpliest query';
  var got = _.uriNew.dequery( query1 );
  test.contains( got, expected1 );

  test.case = 'parse query with several key/value pair';
  var got = _.uriNew.dequery( query2 );
  test.contains( got, expected2 );

  test.case = 'parse query with several key/value pair and decoding';
  var got = _.uriNew.dequery( query3 );
  test.contains( got, expected3 );

}

//

function join( test )
{

  test.case = 'join empty';
  var paths = [ '' ];
  var expected = '';
  var got = _.uriNew.join.apply( _.uriNew, paths );
  test.identical( got, expected );

  test.case = 'join several empties';
  var paths = [ '', '' ];
  var expected = '';
  var got = _.uriNew.join.apply( _.uriNew, paths );
  test.identical( got, expected );

  test.case = 'join with empty';
  var paths = [ '', 'a/b', '', 'c', '' ];
  var expected = 'a/b/c';
  var got = _.uriNew.join.apply( _.uriNew, paths );
  test.identical( got, expected );

  test.case = 'replace protocol';
  var got = _.uriNew.join( 'src:///in', 'fmap://' );
  var expected = 'fmap:///in';
  test.identical( got, expected );

  test.case = 'join different protocols';
  var got = _.uriNew.join( 'file://www.site.com:13', 'a', 'http:///dir', 'b' );
  var expected = 'http:///dir/b';
  test.identical( got, expected );

  var got = _.uriNew.join( 'file:///d', 'a', 'http:///dir', 'b' );
  var expected = 'http:///dir/b';
  test.identical( got, expected );

  test.case = 'join same protocols';

  var got = _.uriNew.join( 'http://www.site.com:13', 'a', 'http:///dir', 'b' );
  var expected = 'http:///dir/b';
  test.identical( got, expected );

  var got = _.uriNew.join( 'http:///www.site.com:13', 'a', 'http:///dir', 'b' );
  var expected = 'http:///dir/b';
  test.identical( got, expected );

  var got = _.uriNew.join( 'http://server1', 'a', 'http://server2', 'b' );
  var expected = 'http://server1/a/server2/b';
  test.identical( got, expected );

  var got = _.uriNew.join( 'http:///server1', 'a', 'http://server2', 'b' );
  var expected = 'http:///server1/a/server2/b';
  test.identical( got, expected );

  var got = _.uriNew.join( 'http://server1', 'a', 'http:///server2', 'b' );
  var expected = 'http:///server2/b';
  test.identical( got, expected );

  test.case = 'join protocol with protocol-less';

  var got = _.uriNew.join( 'http://www.site.com:13', 'a', ':///dir', 'b' );
  var expected = 'http:///dir/b';
  test.identical( got, expected );

  var got = _.uriNew.join( 'http:///www.site.com:13', 'a', '://dir', 'b' );
  var expected = 'http:///www.site.com:13/a/dir/b';
  test.identical( got, expected );

  var got = _.uriNew.join( 'http:///www.site.com:13', 'a', ':///dir', 'b' );
  var expected = 'http:///dir/b';
  test.identical( got, expected );

  var got = _.uriNew.join( 'http://www.site.com:13', 'a', '://dir', 'b' );
  var expected = 'http://www.site.com:13/a/dir/b';
  test.identical( got, expected );

  var got = _.uriNew.join( 'http://dir:13', 'a', '://dir', 'b' );
  var expected = 'http://dir:13/a/dir/b';
  test.identical( got, expected );

  var got = _.uriNew.join( 'http://www.site.com:13', 'a', '://:14', 'b' );
  var expected = 'http://www.site.com:13/a/:14/b';
  test.identical( got, expected );

  /**/

  var got = _.uriNew.join( 'a', '://dir1/x', 'b', 'http://dir2/y', 'c' );
  var expected = 'http://a/dir1/x/b/dir2/y/c';
  test.identical( got, expected );

  var got = _.uriNew.join( 'a', ':///dir1/x', 'b', 'http://dir2/y', 'c' );
  var expected = 'http:///dir1/x/b/dir2/y/c';
  test.identical( got, expected );

  var got = _.uriNew.join( 'a', '://dir1/x', 'b', 'http:///dir2/y', 'c' );
  var expected = 'http:///dir2/y/c';
  test.identical( got, expected );

  var got = _.uriNew.join( 'a', ':///dir1/x', 'b', 'http:///dir2/y', 'c' );
  var expected = 'http:///dir2/y/c';
  test.identical( got, expected );

  /* */

  test.case = 'server join absolute path 1';
  var got = _.uriNew.join( 'http://www.site.com:13', '/x', '/y', '/z' );
  test.identical( got, 'http:///z' );

  test.case = 'server join absolute path 2';
  var got = _.uriNew.join( 'http://www.site.com:13/', 'x', '/y', '/z' );
  test.identical( got, 'http:///z' );

  test.case = 'server join absolute path 2';
  var got = _.uriNew.join( 'http://www.site.com:13/', 'x', 'y', '/z' );
  test.identical( got, 'http:///z' );

  test.case = 'server join absolute path';
  var got = _.uriNew.join( 'http://www.site.com:13/', 'x', '/y', 'z' );
  test.identical( got, 'http:///y/z' );

  test.case = 'server join relative path';
  var got = _.uriNew.join( 'http://www.site.com:13/', 'x', 'y', 'z' );
  test.identical( got, 'http://www.site.com:13/x/y/z' );

  test.case = 'server with path join absolute path 2';
  var got = _.uriNew.join( 'http://www.site.com:13/ab', '/y', '/z' );
  test.identical( got, 'http:///z' );

  test.case = 'server with path join absolute path 2';
  var got = _.uriNew.join( 'http://www.site.com:13/ab', '/y', 'z' );
  test.identical( got, 'http:///y/z' );

  test.case = 'server with path join absolute path 2';
  var got = _.uriNew.join( 'http://www.site.com:13/ab', 'y', 'z' );
  test.identical( got, 'http://www.site.com:13/ab/y/z' );

  test.case = 'add relative filePath uri with no resourcePath';
  var got = _.uriNew.join( 'https://some.domain.com/', 'something/filePath/add' );
  test.identical( got, 'https://some.domain.com/something/filePath/add' );

  test.case = 'add relative filePath uri with resourcePath';
  var got = _.uriNew.join( 'https://some.domain.com/was', 'something/filePath/add' );
  test.identical( got, 'https://some.domain.com/was/something/filePath/add' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.join( 'https://some.domain.com/was', '/something/filePath/add' );
  test.identical( got, 'https:///something/filePath/add' );

  /* */

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.join( '//some.domain.com/was', '/something/filePath/add' );
  test.identical( got, '/something/filePath/add' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.join( '://some.domain.com/was', '/something/filePath/add' );
  test.identical( got, ':///something/filePath/add' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.join( '//some.domain.com/was', 'x', '/something/filePath/add' );
  test.identical( got, '/something/filePath/add' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.join( '://some.domain.com/was', 'x', '/something/filePath/add' );
  test.identical( got, ':///something/filePath/add' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.join( '//some.domain.com/was', '/something/filePath/add', 'x' );
  test.identical( got, '/something/filePath/add/x' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.join( '://some.domain.com/was', '/something/filePath/add', 'x' );
  test.identical( got, ':///something/filePath/add/x' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.join( '//some.domain.com/was', '/something/filePath/add', '/x' );
  test.identical( got, '/x' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.join( '://some.domain.com/was', '/something/filePath/add', '/x' );
  test.identical( got, ':///x' );

  /* */

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.join( '/some/staging/index.html', '/something/filePath/add' );
  test.identical( got, '/something/filePath/add' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.join( '/some/staging/index.html', 'x', '/something/filePath/add' );
  test.identical( got, '/something/filePath/add' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.join( '/some/staging/index.html', 'x', '/something/filePath/add', 'y' );
  test.identical( got, '/something/filePath/add/y' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.join( '/some/staging/index.html', '/something/filePath/add', '/y' );
  test.identical( got, '/y' );

  /* */

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.join( '///some/staging/index.html', '/something/filePath/add' );
  test.identical( got, '/something/filePath/add' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.join( ':///some/staging/index.html', '/something/filePath/add' );
  test.identical( got, ':///something/filePath/add' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.join( '///some/staging/index.html', 'x', '/something/filePath/add' );
  test.identical( got, '/something/filePath/add' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.join( ':///some/staging/index.html', 'x', '/something/filePath/add' );
  test.identical( got, ':///something/filePath/add' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.join( '///some/staging/index.html', 'x', '/something/filePath/add', 'y' );
  test.identical( got, '/something/filePath/add/y' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.join( ':///some/staging/index.html', 'x', '/something/filePath/add', 'y' );
  test.identical( got, ':///something/filePath/add/y' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.join( '///some/staging/index.html', '/something/filePath/add', '/y' );
  test.identical( got, '/y' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.join( ':///some/staging/index.html', '/something/filePath/add', '/y' );
  test.identical( got, ':///y' );

  /* */

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.join( 'svn+https://user@subversion.com/svn/trunk', '/something/filePath/add' );
  test.identical( got, 'svn+https:///something/filePath/add' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.join( 'svn+https://user@subversion.com/svn/trunk', 'x', '/something/filePath/add' );
  test.identical( got, 'svn+https:///something/filePath/add' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.join( 'svn+https://user@subversion.com/svn/trunk', 'x', '/something/filePath/add', 'y' );
  test.identical( got, 'svn+https:///something/filePath/add/y' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.join( 'svn+https://user@subversion.com/svn/trunk', '/something/filePath/add', '/y' );
  test.identical( got, 'svn+https:///y' );

  /* */

  var uri = 'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor';
  var parsed = _.uriNew.parse( uri );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.join( uri, '/something/filePath/add' );
  test.identical( got, 'complex+protocol:///something/filePath/add?query=here&and=here#anchor' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.join( uri, 'x', '/something/filePath/add' );
  test.identical( got, 'complex+protocol:///something/filePath/add?query=here&and=here#anchor' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.join( uri, 'x', '/something/filePath/add', 'y' );
  test.identical( got, 'complex+protocol:///something/filePath/add/y?query=here&and=here#anchor' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.join( uri, '/something/filePath/add', '/y' );
  test.identical( got, 'complex+protocol:///y?query=here&and=here#anchor' );

  test.case = 'prased uri at the end';
  var got = _.uriNew.join( '/something/filePath/add', 'y', uri );
  test.identical( got, 'complex+protocol:///something/filePath/add/y/www.site.com:13/path/name?query=here&and=here#anchor' );

  /* */

  test.case = 'several queries and hashes'
  var uri1 = '://user:pass@sub.host.com:8080/p/a/t/h?query1=string1#hash1';
  var uri2 = '://user:pass@sub.host.com:8080/p/a/t/h?query2=string2#hash2';
  var got = _.uriNew.join( uri1, uri2, '/x//y//z'  );
  var expected = ':///x//y//z?query1=string1&query2=string2#hash2';
  test.identical( got, expected );

  var uri = '://user:pass@sub.host.com:8080/p/a/t/h?query=string#hash';
  var got = _.uriNew.join( uri, 'x'  );
  var expected = '://user:pass@sub.host.com:8080/p/a/t/h/x?query=string#hash'
  test.identical( got, expected );

  var uri = '://user:pass@sub.host.com:8080/p/a/t/h?query=string#hash';
  var got = _.uriNew.join( uri, 'x', '/y'  );
  var expected = ':///y?query=string#hash';
  test.identical( got, expected );

  var uri = '://user:pass@sub.host.com:8080/p/a/t/h?query=string#hash';
  var got = _.uriNew.join( uri, '/x//y//z'  );
  var expected = ':///x//y//z?query=string#hash';
  test.identical( got, expected );

  var uri = '://user:pass@sub.host.com:8080/p//a//t//h?query=string#hash';
  var got = _.uriNew.join( uri, 'x/'  );
  var expected = '://user:pass@sub.host.com:8080/p//a//t//h/x?query=string#hash'
  test.identical( got, expected );

  var uri = ':///user:pass@sub.host.com:8080/p/a/t/h?query=string#hash';
  var got = _.uriNew.join( uri, 'x'  );
  // var expected = ':///user:pass/x#hash@sub.host.com:8080/p/a/t/h?query=string';
  var expected = ':///user:pass@sub.host.com:8080/p/a/t/h/x?query=string#hash';
  test.identical( got, expected );

  var uri = ':///user:pass@sub.host.com:8080/p/a/t/h?query=string#hash';
  var got = _.uriNew.join( uri, 'x', '/y'  );
  var expected = ':///y?query=string#hash'
  test.identical( got, expected );

  var uri = ':///user:pass@sub.host.com:8080/p/a/t/h?query=string#hash';
  var got = _.uriNew.join( uri, '/x//y//z'  );
  var expected = ':///x//y//z?query=string#hash'
  test.identical( got, expected );

  var uri = ':///user:pass@sub.host.com:8080/p/a/t/h?query=string#hash';
  var got = _.uriNew.join( uri, 'x/'  );
  var expected = ':///user:pass@sub.host.com:8080/p/a/t/h/x?query=string#hash'
  test.identical( got, expected );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.join( 'file:///some/file', '/something/filePath/add' );
  test.identical( got, 'file:///something/filePath/add' );

  /* */

  test.case = 'add uris';

  var got = _.uriNew.join( '//a', '//b', 'c' );
  test.identical( got, '//b/c' )

  var got = _.uriNew.join( 'b://c', 'd://e', 'f' );
  test.identical( got, 'd://c/e/f' );

  var got = _.uriNew.join( 'a://b', 'c://d/e', '//f/g' );
  test.identical( got, 'c:////f/g' )

  /* - */

  test.case = 'not global, windows path';
  var paths = [ 'c:\\', 'foo\\', 'bar\\' ];
  var expected = '/c/foo/bar/';
  var got = _.uriNew.join.apply( _.uriNew, paths );
  test.identical( got, expected );

  test.case = 'not global';
  var paths = [ '/bar/', '/baz', 'foo/', '.' ];
  var expected = '/baz/foo';
  var got = _.uriNew.join.apply( _.uriNew, paths );
  test.identical( got, expected );

  /* - */

  test.open( 'with nulls' );

  var paths = [ 'a', null ];
  var expected = null;
  var got = _.uriNew.join.apply( _.uriNew, paths );
  test.identical( got, expected );

  var paths = [ '/', null ];
  var expected = null;
  var got = _.uriNew.join.apply( _.uriNew, paths );
  test.identical( got, expected );

  var paths = [ 'a', null, 'b' ];
  var expected = 'b';
  var got = _.uriNew.join.apply( _.uriNew, paths );
  test.identical( got, expected );

  var paths = [ '/a', null, 'b' ];
  var expected = 'b';
  var got = _.uriNew.join.apply( _.uriNew, paths );
  test.identical( got, expected );

  var paths = [ '/a', null, '/b' ];
  var expected = '/b';
  var got = _.uriNew.join.apply( _.uriNew, paths );
  test.identical( got, expected );

  test.close( 'with nulls' );

  /* - */

  test.open( 'other special cases' );

  var paths = [  '/aa', 'bb//', 'cc' ];
  var expected = '/aa/bb//cc';
  var got = _.uriNew.join.apply( _.uriNew, paths );
  test.identical( got, expected );

  var paths = [  '/aa', 'bb//', 'cc', '.' ];
  var expected = '/aa/bb//cc';
  var got = _.uriNew.join.apply( _.uriNew, paths );
  test.identical( got, expected );

  var paths = [  '/', 'a', '//b', '././c', '../d', '..e' ];
  var expected = '//b/d/..e';
  var got = _.uriNew.join.apply( _.uriNew, paths );
  test.identical( got, expected );

  var paths = [  '/', 'a', '//b', '././c', '../d', '..e' ];
  var expected = '//b/d/..e';
  var got = _.uriNew.join.apply( _.uriNew, paths );
  test.identical( got, expected );

  var paths = [ 'git+https:///github.com/repo/wTools#master', '../wTools/**#master' ];
  var expected = 'git+https:///github.com/repo/wTools/**#master#master';
  var got = _.uriNew.join.apply( _.uriNew, paths );
  test.identical( got, expected );

  var paths = [ 'git+https:///github.com/repo/wTools#master', 'git+https://../wTools/**#master' ];
  var expected = 'git+https:///github.com/repo/wTools/**#master';
  var got = _.uriNew.join.apply( _.uriNew, paths );
  test.identical( got, expected );

  var paths = [ 'git+https:///github.com/repo/wTools#master1', 'git+https://../wTools/**#master2' ];
  var expected = 'git+https:///github.com/repo/wTools/**#master2';
  var got = _.uriNew.join.apply( _.uriNew, paths );
  test.identical( got, expected );

  var paths = [ 'http://127.0.0.1:15000/F1.html', '://?entry:1&format:null' ];
  var expected = 'http://127.0.0.1:15000/F1.html?entry:1&format:null';
  var got = _.uriNew.join.apply( _.uriNew, paths );
  test.identical( got, expected );

  var paths = [ 'http://127.0.0.1:15000/F1.html', '?entry:1&format:null' ];
  var expected = 'http://127.0.0.1:15000/F1.html/?entry:1&format:null';
  var got = _.uriNew.join.apply( _.uriNew, paths );
  test.identical( got, expected );

  test.close( 'other special cases' );

}

//

function join_( test )
{

  test.case = 'join empty';
  var paths = [ '' ];
  var expected = '';
  var got = _.uriNew.join_.apply( _.uriNew, paths );
  test.identical( got, expected );

  test.case = 'join several empties';
  var paths = [ '', '' ];
  var expected = '';
  var got = _.uriNew.join_.apply( _.uriNew, paths );
  test.identical( got, expected );

  test.case = 'join with empty';
  var paths = [ '', 'a/b', '', 'c', '' ];
  var expected = 'a/b/c';
  var got = _.uriNew.join_.apply( _.uriNew, paths );
  test.identical( got, expected );

  test.case = 'replace protocol';
  var got = _.uriNew.join_( 'src:///in', 'fmap://' );
  var expected = 'fmap:///in';
  test.identical( got, expected );

  test.case = 'join different protocols';
  var got = _.uriNew.join_( 'file://www.site.com:13', 'a', 'http:///dir', 'b' );
  var expected = 'http:///dir/b';
  test.identical( got, expected );

  var got = _.uriNew.join_( 'file:///d', 'a', 'http:///dir', 'b' );
  var expected = 'http:///dir/b';
  test.identical( got, expected );

  test.case = 'join same protocols';

  var got = _.uriNew.join_( 'http://www.site.com:13', 'a', 'http:///dir', 'b' );
  var expected = 'http:///dir/b';
  test.identical( got, expected );

  var got = _.uriNew.join_( 'http:///www.site.com:13', 'a', 'http:///dir', 'b' );
  var expected = 'http:///dir/b';
  test.identical( got, expected );

  var got = _.uriNew.join_( 'http://server1', 'a', 'http://server2', 'b' );
  var expected = 'http://server1/a/server2/b';
  test.identical( got, expected );

  var got = _.uriNew.join_( 'http:///server1', 'a', 'http://server2', 'b' );
  var expected = 'http:///server1/a/server2/b';
  test.identical( got, expected );

  var got = _.uriNew.join_( 'http://server1', 'a', 'http:///server2', 'b' );
  var expected = 'http:///server2/b';
  test.identical( got, expected );

  test.case = 'join protocol with protocol-less';

  var got = _.uriNew.join_( 'http://www.site.com:13', 'a', ':///dir', 'b' );
  var expected = 'http:///dir/b';
  test.identical( got, expected );

  var got = _.uriNew.join_( 'http:///www.site.com:13', 'a', '://dir', 'b' );
  var expected = 'http:///www.site.com:13/a/dir/b';
  test.identical( got, expected );

  var got = _.uriNew.join_( 'http:///www.site.com:13', 'a', ':///dir', 'b' );
  var expected = 'http:///dir/b';
  test.identical( got, expected );

  var got = _.uriNew.join_( 'http://www.site.com:13', 'a', '://dir', 'b' );
  var expected = 'http://www.site.com:13/a/dir/b';
  test.identical( got, expected );

  var got = _.uriNew.join_( 'http://dir:13', 'a', '://dir', 'b' );
  var expected = 'http://dir:13/a/dir/b';
  test.identical( got, expected );

  var got = _.uriNew.join_( 'http://www.site.com:13', 'a', '://:14', 'b' );
  var expected = 'http://www.site.com:13/a/:14/b';
  test.identical( got, expected );

  /**/

  var got = _.uriNew.join_( 'a', '://dir1/x', 'b', 'http://dir2/y', 'c' );
  var expected = 'http://a/dir1/x/b/dir2/y/c';
  test.identical( got, expected );

  var got = _.uriNew.join_( 'a', ':///dir1/x', 'b', 'http://dir2/y', 'c' );
  var expected = 'http:///dir1/x/b/dir2/y/c';
  test.identical( got, expected );

  var got = _.uriNew.join_( 'a', '://dir1/x', 'b', 'http:///dir2/y', 'c' );
  var expected = 'http:///dir2/y/c';
  test.identical( got, expected );

  var got = _.uriNew.join_( 'a', ':///dir1/x', 'b', 'http:///dir2/y', 'c' );
  var expected = 'http:///dir2/y/c';
  test.identical( got, expected );

  /* */

  test.case = 'server join absolute path 1';
  var got = _.uriNew.join_( 'http://www.site.com:13', '/x', '/y', '/z' );
  test.identical( got, 'http:///z' );

  test.case = 'server join absolute path 2';
  var got = _.uriNew.join_( 'http://www.site.com:13/', 'x', '/y', '/z' );
  test.identical( got, 'http:///z' );

  test.case = 'server join absolute path 2';
  var got = _.uriNew.join_( 'http://www.site.com:13/', 'x', 'y', '/z' );
  test.identical( got, 'http:///z' );

  test.case = 'server join absolute path';
  var got = _.uriNew.join_( 'http://www.site.com:13/', 'x', '/y', 'z' );
  test.identical( got, 'http:///y/z' );

  test.case = 'server join relative path';
  var got = _.uriNew.join_( 'http://www.site.com:13/', 'x', 'y', 'z' );
  test.identical( got, 'http://www.site.com:13/x/y/z' );

  test.case = 'server with path join absolute path 2';
  var got = _.uriNew.join_( 'http://www.site.com:13/ab', '/y', '/z' );
  test.identical( got, 'http:///z' );

  test.case = 'server with path join absolute path 2';
  var got = _.uriNew.join_( 'http://www.site.com:13/ab', '/y', 'z' );
  test.identical( got, 'http:///y/z' );

  test.case = 'server with path join absolute path 2';
  var got = _.uriNew.join_( 'http://www.site.com:13/ab', 'y', 'z' );
  test.identical( got, 'http://www.site.com:13/ab/y/z' );

  test.case = 'add relative filePath uri with no resourcePath';
  var got = _.uriNew.join_( 'https://some.domain.com/', 'something/filePath/add' );
  test.identical( got, 'https://some.domain.com/something/filePath/add' );

  test.case = 'add relative filePath uri with resourcePath';
  var got = _.uriNew.join_( 'https://some.domain.com/was', 'something/filePath/add' );
  test.identical( got, 'https://some.domain.com/was/something/filePath/add' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.join_( 'https://some.domain.com/was', '/something/filePath/add' );
  test.identical( got, 'https:///something/filePath/add' );

  /* */

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.join_( '//some.domain.com/was', '/something/filePath/add' );
  test.identical( got, '/something/filePath/add' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.join_( '://some.domain.com/was', '/something/filePath/add' );
  test.identical( got, ':///something/filePath/add' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.join_( '//some.domain.com/was', 'x', '/something/filePath/add' );
  test.identical( got, '/something/filePath/add' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.join_( '://some.domain.com/was', 'x', '/something/filePath/add' );
  test.identical( got, ':///something/filePath/add' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.join_( '//some.domain.com/was', '/something/filePath/add', 'x' );
  test.identical( got, '/something/filePath/add/x' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.join_( '://some.domain.com/was', '/something/filePath/add', 'x' );
  test.identical( got, ':///something/filePath/add/x' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.join_( '//some.domain.com/was', '/something/filePath/add', '/x' );
  test.identical( got, '/x' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.join_( '://some.domain.com/was', '/something/filePath/add', '/x' );
  test.identical( got, ':///x' );

  /* */

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.join_( '/some/staging/index.html', '/something/filePath/add' );
  test.identical( got, '/something/filePath/add' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.join_( '/some/staging/index.html', 'x', '/something/filePath/add' );
  test.identical( got, '/something/filePath/add' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.join_( '/some/staging/index.html', 'x', '/something/filePath/add', 'y' );
  test.identical( got, '/something/filePath/add/y' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.join_( '/some/staging/index.html', '/something/filePath/add', '/y' );
  test.identical( got, '/y' );

  /* */

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.join_( '///some/staging/index.html', '/something/filePath/add' );
  test.identical( got, '/something/filePath/add' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.join_( ':///some/staging/index.html', '/something/filePath/add' );
  test.identical( got, ':///something/filePath/add' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.join_( '///some/staging/index.html', 'x', '/something/filePath/add' );
  test.identical( got, '/something/filePath/add' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.join_( ':///some/staging/index.html', 'x', '/something/filePath/add' );
  test.identical( got, ':///something/filePath/add' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.join_( '///some/staging/index.html', 'x', '/something/filePath/add', 'y' );
  test.identical( got, '/something/filePath/add/y' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.join_( ':///some/staging/index.html', 'x', '/something/filePath/add', 'y' );
  test.identical( got, ':///something/filePath/add/y' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.join_( '///some/staging/index.html', '/something/filePath/add', '/y' );
  test.identical( got, '/y' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.join_( ':///some/staging/index.html', '/something/filePath/add', '/y' );
  test.identical( got, ':///y' );

  /* */

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.join_( 'svn+https://user@subversion.com/svn/trunk', '/something/filePath/add' );
  test.identical( got, 'svn+https:///something/filePath/add' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.join_( 'svn+https://user@subversion.com/svn/trunk', 'x', '/something/filePath/add' );
  test.identical( got, 'svn+https:///something/filePath/add' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.join_( 'svn+https://user@subversion.com/svn/trunk', 'x', '/something/filePath/add', 'y' );
  test.identical( got, 'svn+https:///something/filePath/add/y' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.join_( 'svn+https://user@subversion.com/svn/trunk', '/something/filePath/add', '/y' );
  test.identical( got, 'svn+https:///y' );

  /* */

  var uri = 'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor';
  var parsed = _.uriNew.parse( uri );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.join_( uri, '/something/filePath/add' );
  test.identical( got, 'complex+protocol:///something/filePath/add?query=here&and=here#anchor' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.join_( uri, 'x', '/something/filePath/add' );
  test.identical( got, 'complex+protocol:///something/filePath/add?query=here&and=here#anchor' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.join_( uri, 'x', '/something/filePath/add', 'y' );
  test.identical( got, 'complex+protocol:///something/filePath/add/y?query=here&and=here#anchor' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.join_( uri, '/something/filePath/add', '/y' );
  test.identical( got, 'complex+protocol:///y?query=here&and=here#anchor' );

  test.case = 'prased uri at the end';
  var got = _.uriNew.join_( '/something/filePath/add', 'y', uri );
  test.identical( got, 'complex+protocol:///something/filePath/add/y/www.site.com:13/path/name?query=here&and=here#anchor' );

  /* */

  test.case = 'several queries and hashes'
  var uri1 = '://user:pass@sub.host.com:8080/p/a/t/h?query1=string1#hash1';
  var uri2 = '://user:pass@sub.host.com:8080/p/a/t/h?query2=string2#hash2';
  var got = _.uriNew.join_( uri1, uri2, '/x//y//z'  );
  var expected = ':///x//y//z?query1=string1&query2=string2#hash2';
  test.identical( got, expected );

  var uri = '://user:pass@sub.host.com:8080/p/a/t/h?query=string#hash';
  var got = _.uriNew.join_( uri, 'x'  );
  var expected = '://user:pass@sub.host.com:8080/p/a/t/h/x?query=string#hash'
  test.identical( got, expected );

  var uri = '://user:pass@sub.host.com:8080/p/a/t/h?query=string#hash';
  var got = _.uriNew.join_( uri, 'x', '/y'  );
  var expected = ':///y?query=string#hash';
  test.identical( got, expected );

  var uri = '://user:pass@sub.host.com:8080/p/a/t/h?query=string#hash';
  var got = _.uriNew.join_( uri, '/x//y//z'  );
  var expected = ':///x//y//z?query=string#hash';
  test.identical( got, expected );

  var uri = '://user:pass@sub.host.com:8080/p//a//t//h?query=string#hash';
  var got = _.uriNew.join_( uri, 'x/'  );
  var expected = '://user:pass@sub.host.com:8080/p//a//t//h/x?query=string#hash'
  test.identical( got, expected );

  var uri = ':///user:pass@sub.host.com:8080/p/a/t/h?query=string#hash';
  var got = _.uriNew.join_( uri, 'x'  );
  // var expected = ':///user:pass/x#hash@sub.host.com:8080/p/a/t/h?query=string';
  var expected = ':///user:pass@sub.host.com:8080/p/a/t/h/x?query=string#hash';
  test.identical( got, expected );

  var uri = ':///user:pass@sub.host.com:8080/p/a/t/h?query=string#hash';
  var got = _.uriNew.join_( uri, 'x', '/y'  );
  var expected = ':///y?query=string#hash'
  test.identical( got, expected );

  var uri = ':///user:pass@sub.host.com:8080/p/a/t/h?query=string#hash';
  var got = _.uriNew.join_( uri, '/x//y//z'  );
  var expected = ':///x//y//z?query=string#hash'
  test.identical( got, expected );

  var uri = ':///user:pass@sub.host.com:8080/p/a/t/h?query=string#hash';
  var got = _.uriNew.join_( uri, 'x/'  );
  var expected = ':///user:pass@sub.host.com:8080/p/a/t/h/x?query=string#hash'
  test.identical( got, expected );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.join_( 'file:///some/file', '/something/filePath/add' );
  test.identical( got, 'file:///something/filePath/add' );

  /* */

  test.case = 'add uris';

  var got = _.uriNew.join_( '//a', '//b', 'c' );
  test.identical( got, '//b/c' )

  var got = _.uriNew.join_( 'b://c', 'd://e', 'f' );
  test.identical( got, 'd://c/e/f' );

  var got = _.uriNew.join_( 'a://b', 'c://d/e', '//f/g' );
  test.identical( got, 'c:////f/g' )

  /* - */

  test.case = 'not global, windows path';
  var paths = [ 'c:\\', 'foo\\', 'bar\\' ];
  var expected = '/c/foo/bar/';
  var got = _.uriNew.join_.apply( _.uriNew, paths );
  test.identical( got, expected );

  test.case = 'not global';
  var paths = [ '/bar/', '/baz', 'foo/', '.' ];
  var expected = '/baz/foo';
  var got = _.uriNew.join_.apply( _.uriNew, paths );
  test.identical( got, expected );

  /* - */

  test.open( 'with nulls' );

  var paths = [ 'a', null ];
  var expected = null;
  var got = _.uriNew.join_.apply( _.uriNew, paths );
  test.identical( got, expected );

  var paths = [ '/', null ];
  var expected = null;
  var got = _.uriNew.join_.apply( _.uriNew, paths );
  test.identical( got, expected );

  var paths = [ 'a', null, 'b' ];
  var expected = 'b';
  var got = _.uriNew.join_.apply( _.uriNew, paths );
  test.identical( got, expected );

  var paths = [ '/a', null, 'b' ];
  var expected = 'b';
  var got = _.uriNew.join_.apply( _.uriNew, paths );
  test.identical( got, expected );

  var paths = [ '/a', null, '/b' ];
  var expected = '/b';
  var got = _.uriNew.join_.apply( _.uriNew, paths );
  test.identical( got, expected );

  test.close( 'with nulls' );

  /* - */

  test.open( 'other special cases' );

  var paths = [  '/aa', 'bb//', 'cc' ];
  var expected = '/aa/bb//cc';
  var got = _.uriNew.join_.apply( _.uriNew, paths );
  test.identical( got, expected );

  var paths = [  '/aa', 'bb//', 'cc', '.' ];
  var expected = '/aa/bb//cc';
  var got = _.uriNew.join_.apply( _.uriNew, paths );
  test.identical( got, expected );

  var paths = [  '/', 'a', '//b', '././c', '../d', '..e' ];
  var expected = '//b/d/..e';
  var got = _.uriNew.join_.apply( _.uriNew, paths );
  test.identical( got, expected );

  var paths = [  '/', 'a', '//b', '././c', '../d', '..e' ];
  var expected = '//b/d/..e';
  var got = _.uriNew.join_.apply( _.uriNew, paths );
  test.identical( got, expected );

  var paths = [ 'git+https:///github.com/repo/wTools#master', '../wTools/**#master' ];
  var expected = 'git+https:///github.com/repo/wTools/**#master#master';
  var got = _.uriNew.join_.apply( _.uriNew, paths );
  test.identical( got, expected );

  var paths = [ 'git+https:///github.com/repo/wTools#master', 'git+https://../wTools/**#master' ];
  var expected = 'git+https:///github.com/repo/wTools/**#master';
  var got = _.uriNew.join_.apply( _.uriNew, paths );
  test.identical( got, expected );

  var paths = [ 'git+https:///github.com/repo/wTools#master1', 'git+https://../wTools/**#master2' ];
  var expected = 'git+https:///github.com/repo/wTools/**#master2';
  var got = _.uriNew.join_.apply( _.uriNew, paths );
  test.identical( got, expected );

  var paths = [ 'http://127.0.0.1:15000/F1.html', '://?entry:1&format:null' ];
  var expected = 'http://127.0.0.1:15000/F1.html?entry:1&format:null';
  var got = _.uriNew.join_.apply( _.uriNew, paths );
  test.identical( got, expected );

  var paths = [ 'http://127.0.0.1:15000/F1.html', '?entry:1&format:null' ];
  var expected = 'http://127.0.0.1:15000/F1.html/?entry:1&format:null';
  var got = _.uriNew.join_.apply( _.uriNew, paths );
  test.identical( got, expected );

  test.close( 'other special cases' );
}

//

function joinRaw( test )
{

  test.case = 'joinRaw with empty';
  var paths = [ '', 'a/b', '', 'c', '' ];
  var expected = 'a/b/c';
  var got = _.uriNew.joinRaw.apply( _.uriNew, paths );
  test.identical( got, expected );

  test.case = 'replace protocol';

  var got = _.uriNew.joinRaw( 'src:///in', 'fmap://' );
  var expected = 'fmap:///in';
  test.identical( got, expected );

  test.case = 'joinRaw different protocols';

  var got = _.uriNew.joinRaw( 'file://www.site.com:13', 'a', 'http:///dir', 'b' );
  var expected = 'http:///dir/b';
  test.identical( got, expected );

  var got = _.uriNew.joinRaw( 'file:///d', 'a', 'http:///dir', 'b' );
  var expected = 'http:///dir/b';
  test.identical( got, expected );

  test.case = 'joinRaw same protocols';

  var got = _.uriNew.joinRaw( 'http://www.site.com:13', 'a', 'http:///dir', 'b' );
  var expected = 'http:///dir/b';
  test.identical( got, expected );

  var got = _.uriNew.joinRaw( 'http:///www.site.com:13', 'a', 'http:///dir', 'b' );
  var expected = 'http:///dir/b';
  test.identical( got, expected );

  var got = _.uriNew.joinRaw( 'http://server1', 'a', 'http://server2', 'b' );
  var expected = 'http://server1/a/server2/b';
  test.identical( got, expected );

  var got = _.uriNew.joinRaw( 'http:///server1', 'a', 'http://server2', 'b' );
  var expected = 'http:///server1/a/server2/b';
  test.identical( got, expected );

  var got = _.uriNew.joinRaw( 'http://server1', 'a', 'http:///server2', 'b' );
  var expected = 'http:///server2/b';
  test.identical( got, expected );

  test.case = 'joinRaw protocol with protocol-less';

  var got = _.uriNew.joinRaw( 'http://www.site.com:13', 'a', ':///dir', 'b' );
  var expected = 'http:///dir/b';
  test.identical( got, expected );

  var got = _.uriNew.joinRaw( 'http:///www.site.com:13', 'a', '://dir', 'b' );
  var expected = 'http:///www.site.com:13/a/dir/b';
  test.identical( got, expected );

  var got = _.uriNew.joinRaw( 'http:///www.site.com:13', 'a', ':///dir', 'b' );
  var expected = 'http:///dir/b';
  test.identical( got, expected );

  var got = _.uriNew.joinRaw( 'http://www.site.com:13', 'a', '://dir', 'b' );
  var expected = 'http://www.site.com:13/a/dir/b';
  test.identical( got, expected );

  var got = _.uriNew.joinRaw( 'http://dir:13', 'a', '://dir', 'b' );
  var expected = 'http://dir:13/a/dir/b';
  test.identical( got, expected );

  var got = _.uriNew.joinRaw( 'http://www.site.com:13', 'a', '://:14', 'b' );
  var expected = 'http://www.site.com:13/a/:14/b';
  test.identical( got, expected );

  /**/

  var got = _.uriNew.joinRaw( 'a', '://dir1/x', 'b', 'http://dir2/y', 'c' );
  var expected = 'http://a/dir1/x/b/dir2/y/c';
  test.identical( got, expected );

  var got = _.uriNew.joinRaw( 'a', ':///dir1/x', 'b', 'http://dir2/y', 'c' );
  var expected = 'http:///dir1/x/b/dir2/y/c';
  test.identical( got, expected );

  var got = _.uriNew.joinRaw( 'a', '://dir1/x', 'b', 'http:///dir2/y', 'c' );
  var expected = 'http:///dir2/y/c';
  test.identical( got, expected );

  var got = _.uriNew.joinRaw( 'a', ':///dir1/x', 'b', 'http:///dir2/y', 'c' );
  var expected = 'http:///dir2/y/c';
  test.identical( got, expected );

  /* */

  test.case = 'server joinRaw absolute path 1';
  var got = _.uriNew.joinRaw( 'http://www.site.com:13', '/x', '/y', '/z' );
  test.identical( got, 'http:///z' );

  test.case = 'server joinRaw absolute path 2';
  var got = _.uriNew.joinRaw( 'http://www.site.com:13/', 'x', '/y', '/z' );
  test.identical( got, 'http:///z' );

  test.case = 'server joinRaw absolute path 2';
  var got = _.uriNew.joinRaw( 'http://www.site.com:13/', 'x', 'y', '/z' );
  test.identical( got, 'http:///z' );

  test.case = 'server joinRaw absolute path';
  var got = _.uriNew.joinRaw( 'http://www.site.com:13/', 'x', '/y', 'z' );
  test.identical( got, 'http:///y/z' );

  test.case = 'server joinRaw relative path';
  var got = _.uriNew.joinRaw( 'http://www.site.com:13/', 'x', 'y', 'z' );
  test.identical( got, 'http://www.site.com:13/x/y/z' );

  test.case = 'server with path joinRaw absolute path 2';
  var got = _.uriNew.joinRaw( 'http://www.site.com:13/ab', '/y', '/z' );
  test.identical( got, 'http:///z' );

  test.case = 'server with path joinRaw absolute path 2';
  var got = _.uriNew.joinRaw( 'http://www.site.com:13/ab', '/y', 'z' );
  test.identical( got, 'http:///y/z' );

  test.case = 'server with path joinRaw absolute path 2';
  var got = _.uriNew.joinRaw( 'http://www.site.com:13/ab', 'y', 'z' );
  test.identical( got, 'http://www.site.com:13/ab/y/z' );

  test.case = 'add relative filePath uri with no resourcePath';
  var got = _.uriNew.joinRaw( 'https://some.domain.com/', 'something/filePath/add' );
  test.identical( got, 'https://some.domain.com/something/filePath/add' );

  test.case = 'add relative filePath uri with resourcePath';
  var got = _.uriNew.joinRaw( 'https://some.domain.com/was', 'something/filePath/add' );
  test.identical( got, 'https://some.domain.com/was/something/filePath/add' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.joinRaw( 'https://some.domain.com/was', '/something/filePath/add' );
  test.identical( got, 'https:///something/filePath/add' );

  /* */

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.joinRaw( '//some.domain.com/was', '/something/filePath/add' );
  test.identical( got, '/something/filePath/add' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.joinRaw( '://some.domain.com/was', '/something/filePath/add' );
  test.identical( got, ':///something/filePath/add' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.joinRaw( '//some.domain.com/was', 'x', '/something/filePath/add' );
  test.identical( got, '/something/filePath/add' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.joinRaw( '://some.domain.com/was', 'x', '/something/filePath/add' );
  test.identical( got, ':///something/filePath/add' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.joinRaw( '//some.domain.com/was', '/something/filePath/add', 'x' );
  test.identical( got, '/something/filePath/add/x' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.joinRaw( '://some.domain.com/was', '/something/filePath/add', 'x' );
  test.identical( got, ':///something/filePath/add/x' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.joinRaw( '//some.domain.com/was', '/something/filePath/add', '/x' );
  test.identical( got, '/x' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.joinRaw( '://some.domain.com/was', '/something/filePath/add', '/x' );
  test.identical( got, ':///x' );

  /* */

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.joinRaw( '/some/staging/index.html', '/something/filePath/add' );
  test.identical( got, '/something/filePath/add' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.joinRaw( '/some/staging/index.html', 'x', '/something/filePath/add' );
  test.identical( got, '/something/filePath/add' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.joinRaw( '/some/staging/index.html', 'x', '/something/filePath/add', 'y' );
  test.identical( got, '/something/filePath/add/y' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.joinRaw( '/some/staging/index.html', '/something/filePath/add', '/y' );
  test.identical( got, '/y' );

  /* */

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.joinRaw( '///some/staging/index.html', '/something/filePath/add' );
  test.identical( got, '/something/filePath/add' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.joinRaw( ':///some/staging/index.html', '/something/filePath/add' );
  test.identical( got, ':///something/filePath/add' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.joinRaw( '///some/staging/index.html', 'x', '/something/filePath/add' );
  test.identical( got, '/something/filePath/add' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.joinRaw( ':///some/staging/index.html', 'x', '/something/filePath/add' );
  test.identical( got, ':///something/filePath/add' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.joinRaw( '///some/staging/index.html', 'x', '/something/filePath/add', 'y' );
  test.identical( got, '/something/filePath/add/y' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.joinRaw( ':///some/staging/index.html', 'x', '/something/filePath/add', 'y' );
  test.identical( got, ':///something/filePath/add/y' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.joinRaw( '///some/staging/index.html', '/something/filePath/add', '/y' );
  test.identical( got, '/y' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.joinRaw( ':///some/staging/index.html', '/something/filePath/add', '/y' );
  test.identical( got, ':///y' );

  /* */

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.joinRaw( 'svn+https://user@subversion.com/svn/trunk', '/something/filePath/add' );
  test.identical( got, 'svn+https:///something/filePath/add' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.joinRaw( 'svn+https://user@subversion.com/svn/trunk', 'x', '/something/filePath/add' );
  test.identical( got, 'svn+https:///something/filePath/add' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.joinRaw( 'svn+https://user@subversion.com/svn/trunk', 'x', '/something/filePath/add', 'y' );
  test.identical( got, 'svn+https:///something/filePath/add/y' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.joinRaw( 'svn+https://user@subversion.com/svn/trunk', '/something/filePath/add', '/y' );
  test.identical( got, 'svn+https:///y' );

  /* */

  var uri = 'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor';
  var parsed = _.uriNew.parse( uri );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.joinRaw( uri, '/something/filePath/add' );
  test.identical( got, 'complex+protocol:///something/filePath/add?query=here&and=here#anchor' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.joinRaw( uri, 'x', '/something/filePath/add' );
  test.identical( got, 'complex+protocol:///something/filePath/add?query=here&and=here#anchor' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.joinRaw( uri, 'x', '/something/filePath/add', 'y' );
  test.identical( got, 'complex+protocol:///something/filePath/add/y?query=here&and=here#anchor' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.joinRaw( uri, '/something/filePath/add', '/y' );
  test.identical( got, 'complex+protocol:///y?query=here&and=here#anchor' );

  test.case = 'prased uri at the end';
  var got = _.uriNew.joinRaw( '/something/filePath/add', 'y', uri );
  test.identical( got, 'complex+protocol:///something/filePath/add/y/www.site.com:13/path/name?query=here&and=here#anchor' );

  /* */

  test.case = 'several queries and hashes'
  var uri1 = '://user:pass@sub.host.com:8080/p/a/t/h?query1=string1#hash1';
  var uri2 = '://user:pass@sub.host.com:8080/p/a/t/h?query2=string2#hash2';
  var got = _.uriNew.joinRaw( uri1, uri2, '/x//y//z'  );
  var expected = ':///x//y//z?query1=string1&query2=string2#hash2';
  test.identical( got, expected );

  var uri = '://user:pass@sub.host.com:8080/p/a/t/h?query=string#hash';
  var got = _.uriNew.joinRaw( uri, 'x'  );
  var expected = '://user:pass@sub.host.com:8080/p/a/t/h/x?query=string#hash'
  test.identical( got, expected );

  var uri = '://user:pass@sub.host.com:8080/p/a/t/h?query=string#hash';
  var got = _.uriNew.joinRaw( uri, 'x', '/y'  );
  var expected = ':///y?query=string#hash';
  test.identical( got, expected );

  var uri = '://user:pass@sub.host.com:8080/p/a/t/h?query=string#hash';
  var got = _.uriNew.joinRaw( uri, '/x//y//z'  );
  var expected = ':///x//y//z?query=string#hash';
  test.identical( got, expected );

  var uri = '://user:pass@sub.host.com:8080/p//a//t//h?query=string#hash';
  var got = _.uriNew.joinRaw( uri, 'x/'  );
  var expected = '://user:pass@sub.host.com:8080/p//a//t//h/x?query=string#hash'
  test.identical( got, expected );

  var uri = ':///user:pass@sub.host.com:8080/p/a/t/h?query=string#hash';
  var got = _.uriNew.joinRaw( uri, 'x'  );
  var expected = ':///user:pass@sub.host.com:8080/p/a/t/h/x?query=string#hash'
  test.identical( got, expected );

  var uri = ':///user:pass@sub.host.com:8080/p/a/t/h?query=string#hash';
  var got = _.uriNew.joinRaw( uri, 'x', '/y'  );
  var expected = ':///y?query=string#hash'
  test.identical( got, expected );

  var uri = ':///user:pass@sub.host.com:8080/p/a/t/h?query=string#hash';
  var got = _.uriNew.joinRaw( uri, '/x//y//z'  );
  var expected = ':///x//y//z?query=string#hash'
  test.identical( got, expected );

  var uri = ':///user:pass@sub.host.com:8080/p/a/t/h?query=string#hash';
  var got = _.uriNew.joinRaw( uri, 'x/'  );
  var expected = ':///user:pass@sub.host.com:8080/p/a/t/h/x?query=string#hash'
  test.identical( got, expected );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.joinRaw( 'file:///some/file', '/something/filePath/add' );
  test.identical( got, 'file:///something/filePath/add' );

  /* */

  test.case = 'add uris';

  var got = _.uriNew.joinRaw( '//a', '//b', 'c' );
  test.identical( got, '//b/c' )

  var got = _.uriNew.joinRaw( 'b://c', 'd://e', 'f' );
  test.identical( got, 'd://c/e/f' );

  var got = _.uriNew.joinRaw( 'a://b', 'c://d/e', '//f/g' );
  test.identical( got, 'c:////f/g' )

  /* - */

  test.case = 'not global, windows path';
  var paths = [ 'c:\\', 'foo\\', 'bar\\' ];
  var expected = '/c/foo/bar/';
  var got = _.uriNew.joinRaw.apply( _.uriNew, paths );
  test.identical( got, expected );

  test.case = 'not global';
  var paths = [ '/bar/', '/baz', 'foo/', '.' ];
  var expected = '/baz/foo/.';
  var got = _.uriNew.joinRaw.apply( _.uriNew, paths );
  test.identical( got, expected );

  /* - */

  test.open( 'with nulls' );

  var paths = [ 'a', null ];
  var expected = null;
  var got = _.uriNew.joinRaw.apply( _.uriNew, paths );
  test.identical( got, expected );

  var paths = [ '/', null ];
  var expected = null;
  var got = _.uriNew.joinRaw.apply( _.uriNew, paths );
  test.identical( got, expected );

  var paths = [ 'a', null, 'b' ];
  var expected = 'b';
  var got = _.uriNew.joinRaw.apply( _.uriNew, paths );
  test.identical( got, expected );

  var paths = [ '/a', null, 'b' ];
  var expected = 'b';
  var got = _.uriNew.joinRaw.apply( _.uriNew, paths );
  test.identical( got, expected );

  var paths = [ '/a', null, '/b' ];
  var expected = '/b';
  var got = _.uriNew.joinRaw.apply( _.uriNew, paths );
  test.identical( got, expected );

  test.close( 'with nulls' );

  /* - */

  test.case = 'other special cases';

  /* xxx */

  var paths = [  '/aa', 'bb//', 'cc' ];
  var expected = '/aa/bb//cc';
  var got = _.uriNew.joinRaw.apply( _.uriNew, paths );
  test.identical( got, expected );

  var paths = [  '/aa', 'bb//', 'cc', '.' ];
  var expected = '/aa/bb//cc/.';
  var got = _.uriNew.joinRaw.apply( _.uriNew, paths );
  test.identical( got, expected );

  var paths = [  '/', 'a', '//b', '././c', '../d', '..e' ];
  var expected = '//b/././c/../d/..e';
  var got = _.uriNew.joinRaw.apply( _.uriNew, paths );
  test.identical( got, expected );

}

//

function joinRaw_( test )
{

  test.case = 'joinRaw with empty';
  var paths = [ '', 'a/b', '', 'c', '' ];
  var expected = 'a/b/c';
  var got = _.uriNew.joinRaw_.apply( _.uriNew, paths );
  test.identical( got, expected );

  test.case = 'replace protocol';

  var got = _.uriNew.joinRaw_( 'src:///in', 'fmap://' );
  var expected = 'fmap:///in';
  test.identical( got, expected );

  test.case = 'joinRaw different protocols';

  var got = _.uriNew.joinRaw_( 'file://www.site.com:13', 'a', 'http:///dir', 'b' );
  var expected = 'http:///dir/b';
  test.identical( got, expected );

  var got = _.uriNew.joinRaw_( 'file:///d', 'a', 'http:///dir', 'b' );
  var expected = 'http:///dir/b';
  test.identical( got, expected );

  test.case = 'joinRaw same protocols';

  var got = _.uriNew.joinRaw_( 'http://www.site.com:13', 'a', 'http:///dir', 'b' );
  var expected = 'http:///dir/b';
  test.identical( got, expected );

  var got = _.uriNew.joinRaw_( 'http:///www.site.com:13', 'a', 'http:///dir', 'b' );
  var expected = 'http:///dir/b';
  test.identical( got, expected );

  var got = _.uriNew.joinRaw_( 'http://server1', 'a', 'http://server2', 'b' );
  var expected = 'http://server1/a/server2/b';
  test.identical( got, expected );

  var got = _.uriNew.joinRaw_( 'http:///server1', 'a', 'http://server2', 'b' );
  var expected = 'http:///server1/a/server2/b';
  test.identical( got, expected );

  var got = _.uriNew.joinRaw_( 'http://server1', 'a', 'http:///server2', 'b' );
  var expected = 'http:///server2/b';
  test.identical( got, expected );

  test.case = 'joinRaw protocol with protocol-less';

  var got = _.uriNew.joinRaw_( 'http://www.site.com:13', 'a', ':///dir', 'b' );
  var expected = 'http:///dir/b';
  test.identical( got, expected );

  var got = _.uriNew.joinRaw_( 'http:///www.site.com:13', 'a', '://dir', 'b' );
  var expected = 'http:///www.site.com:13/a/dir/b';
  test.identical( got, expected );

  var got = _.uriNew.joinRaw_( 'http:///www.site.com:13', 'a', ':///dir', 'b' );
  var expected = 'http:///dir/b';
  test.identical( got, expected );

  var got = _.uriNew.joinRaw_( 'http://www.site.com:13', 'a', '://dir', 'b' );
  var expected = 'http://www.site.com:13/a/dir/b';
  test.identical( got, expected );

  var got = _.uriNew.joinRaw_( 'http://dir:13', 'a', '://dir', 'b' );
  var expected = 'http://dir:13/a/dir/b';
  test.identical( got, expected );

  var got = _.uriNew.joinRaw_( 'http://www.site.com:13', 'a', '://:14', 'b' );
  var expected = 'http://www.site.com:13/a/:14/b';
  test.identical( got, expected );

  /**/

  var got = _.uriNew.joinRaw_( 'a', '://dir1/x', 'b', 'http://dir2/y', 'c' );
  var expected = 'http://a/dir1/x/b/dir2/y/c';
  test.identical( got, expected );

  var got = _.uriNew.joinRaw_( 'a', ':///dir1/x', 'b', 'http://dir2/y', 'c' );
  var expected = 'http:///dir1/x/b/dir2/y/c';
  test.identical( got, expected );

  var got = _.uriNew.joinRaw_( 'a', '://dir1/x', 'b', 'http:///dir2/y', 'c' );
  var expected = 'http:///dir2/y/c';
  test.identical( got, expected );

  var got = _.uriNew.joinRaw_( 'a', ':///dir1/x', 'b', 'http:///dir2/y', 'c' );
  var expected = 'http:///dir2/y/c';
  test.identical( got, expected );

  /* */

  test.case = 'server joinRaw absolute path 1';
  var got = _.uriNew.joinRaw_( 'http://www.site.com:13', '/x', '/y', '/z' );
  test.identical( got, 'http:///z' );

  test.case = 'server joinRaw absolute path 2';
  var got = _.uriNew.joinRaw_( 'http://www.site.com:13/', 'x', '/y', '/z' );
  test.identical( got, 'http:///z' );

  test.case = 'server joinRaw absolute path 2';
  var got = _.uriNew.joinRaw_( 'http://www.site.com:13/', 'x', 'y', '/z' );
  test.identical( got, 'http:///z' );

  test.case = 'server joinRaw absolute path';
  var got = _.uriNew.joinRaw_( 'http://www.site.com:13/', 'x', '/y', 'z' );
  test.identical( got, 'http:///y/z' );

  test.case = 'server joinRaw relative path';
  var got = _.uriNew.joinRaw_( 'http://www.site.com:13/', 'x', 'y', 'z' );
  test.identical( got, 'http://www.site.com:13/x/y/z' );

  test.case = 'server with path joinRaw absolute path 2';
  var got = _.uriNew.joinRaw_( 'http://www.site.com:13/ab', '/y', '/z' );
  test.identical( got, 'http:///z' );

  test.case = 'server with path joinRaw absolute path 2';
  var got = _.uriNew.joinRaw_( 'http://www.site.com:13/ab', '/y', 'z' );
  test.identical( got, 'http:///y/z' );

  test.case = 'server with path joinRaw absolute path 2';
  var got = _.uriNew.joinRaw_( 'http://www.site.com:13/ab', 'y', 'z' );
  test.identical( got, 'http://www.site.com:13/ab/y/z' );

  test.case = 'add relative filePath uri with no resourcePath';
  var got = _.uriNew.joinRaw_( 'https://some.domain.com/', 'something/filePath/add' );
  test.identical( got, 'https://some.domain.com/something/filePath/add' );

  test.case = 'add relative filePath uri with resourcePath';
  var got = _.uriNew.joinRaw_( 'https://some.domain.com/was', 'something/filePath/add' );
  test.identical( got, 'https://some.domain.com/was/something/filePath/add' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.joinRaw_( 'https://some.domain.com/was', '/something/filePath/add' );
  test.identical( got, 'https:///something/filePath/add' );

  /* */

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.joinRaw_( '//some.domain.com/was', '/something/filePath/add' );
  test.identical( got, '/something/filePath/add' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.joinRaw_( '://some.domain.com/was', '/something/filePath/add' );
  test.identical( got, ':///something/filePath/add' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.joinRaw_( '//some.domain.com/was', 'x', '/something/filePath/add' );
  test.identical( got, '/something/filePath/add' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.joinRaw_( '://some.domain.com/was', 'x', '/something/filePath/add' );
  test.identical( got, ':///something/filePath/add' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.joinRaw_( '//some.domain.com/was', '/something/filePath/add', 'x' );
  test.identical( got, '/something/filePath/add/x' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.joinRaw_( '://some.domain.com/was', '/something/filePath/add', 'x' );
  test.identical( got, ':///something/filePath/add/x' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.joinRaw_( '//some.domain.com/was', '/something/filePath/add', '/x' );
  test.identical( got, '/x' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.joinRaw_( '://some.domain.com/was', '/something/filePath/add', '/x' );
  test.identical( got, ':///x' );

  /* */

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.joinRaw_( '/some/staging/index.html', '/something/filePath/add' );
  test.identical( got, '/something/filePath/add' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.joinRaw_( '/some/staging/index.html', 'x', '/something/filePath/add' );
  test.identical( got, '/something/filePath/add' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.joinRaw_( '/some/staging/index.html', 'x', '/something/filePath/add', 'y' );
  test.identical( got, '/something/filePath/add/y' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.joinRaw_( '/some/staging/index.html', '/something/filePath/add', '/y' );
  test.identical( got, '/y' );

  /* */

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.joinRaw_( '///some/staging/index.html', '/something/filePath/add' );
  test.identical( got, '/something/filePath/add' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.joinRaw_( ':///some/staging/index.html', '/something/filePath/add' );
  test.identical( got, ':///something/filePath/add' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.joinRaw_( '///some/staging/index.html', 'x', '/something/filePath/add' );
  test.identical( got, '/something/filePath/add' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.joinRaw_( ':///some/staging/index.html', 'x', '/something/filePath/add' );
  test.identical( got, ':///something/filePath/add' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.joinRaw_( '///some/staging/index.html', 'x', '/something/filePath/add', 'y' );
  test.identical( got, '/something/filePath/add/y' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.joinRaw_( ':///some/staging/index.html', 'x', '/something/filePath/add', 'y' );
  test.identical( got, ':///something/filePath/add/y' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.joinRaw_( '///some/staging/index.html', '/something/filePath/add', '/y' );
  test.identical( got, '/y' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.joinRaw_( ':///some/staging/index.html', '/something/filePath/add', '/y' );
  test.identical( got, ':///y' );

  /* */

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.joinRaw_( 'svn+https://user@subversion.com/svn/trunk', '/something/filePath/add' );
  test.identical( got, 'svn+https:///something/filePath/add' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.joinRaw_( 'svn+https://user@subversion.com/svn/trunk', 'x', '/something/filePath/add' );
  test.identical( got, 'svn+https:///something/filePath/add' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.joinRaw_( 'svn+https://user@subversion.com/svn/trunk', 'x', '/something/filePath/add', 'y' );
  test.identical( got, 'svn+https:///something/filePath/add/y' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.joinRaw_( 'svn+https://user@subversion.com/svn/trunk', '/something/filePath/add', '/y' );
  test.identical( got, 'svn+https:///y' );

  /* */

  var uri = 'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor';
  var parsed = _.uriNew.parse( uri );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.joinRaw_( uri, '/something/filePath/add' );
  test.identical( got, 'complex+protocol:///something/filePath/add?query=here&and=here#anchor' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.joinRaw_( uri, 'x', '/something/filePath/add' );
  test.identical( got, 'complex+protocol:///something/filePath/add?query=here&and=here#anchor' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.joinRaw_( uri, 'x', '/something/filePath/add', 'y' );
  test.identical( got, 'complex+protocol:///something/filePath/add/y?query=here&and=here#anchor' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.joinRaw_( uri, '/something/filePath/add', '/y' );
  test.identical( got, 'complex+protocol:///y?query=here&and=here#anchor' );

  test.case = 'prased uri at the end';
  var got = _.uriNew.joinRaw_( '/something/filePath/add', 'y', uri );
  test.identical( got, 'complex+protocol:///something/filePath/add/y/www.site.com:13/path/name?query=here&and=here#anchor' );

  /* */

  test.case = 'several queries and hashes'
  var uri1 = '://user:pass@sub.host.com:8080/p/a/t/h?query1=string1#hash1';
  var uri2 = '://user:pass@sub.host.com:8080/p/a/t/h?query2=string2#hash2';
  var got = _.uriNew.joinRaw_( uri1, uri2, '/x//y//z'  );
  var expected = ':///x//y//z?query1=string1&query2=string2#hash2';
  test.identical( got, expected );

  var uri = '://user:pass@sub.host.com:8080/p/a/t/h?query=string#hash';
  var got = _.uriNew.joinRaw_( uri, 'x'  );
  var expected = '://user:pass@sub.host.com:8080/p/a/t/h/x?query=string#hash'
  test.identical( got, expected );

  var uri = '://user:pass@sub.host.com:8080/p/a/t/h?query=string#hash';
  var got = _.uriNew.joinRaw_( uri, 'x', '/y'  );
  var expected = ':///y?query=string#hash';
  test.identical( got, expected );

  var uri = '://user:pass@sub.host.com:8080/p/a/t/h?query=string#hash';
  var got = _.uriNew.joinRaw_( uri, '/x//y//z'  );
  var expected = ':///x//y//z?query=string#hash';
  test.identical( got, expected );

  var uri = '://user:pass@sub.host.com:8080/p//a//t//h?query=string#hash';
  var got = _.uriNew.joinRaw_( uri, 'x/'  );
  var expected = '://user:pass@sub.host.com:8080/p//a//t//h/x?query=string#hash'
  test.identical( got, expected );

  var uri = ':///user:pass@sub.host.com:8080/p/a/t/h?query=string#hash';
  var got = _.uriNew.joinRaw_( uri, 'x'  );
  var expected = ':///user:pass@sub.host.com:8080/p/a/t/h/x?query=string#hash'
  test.identical( got, expected );

  var uri = ':///user:pass@sub.host.com:8080/p/a/t/h?query=string#hash';
  var got = _.uriNew.joinRaw_( uri, 'x', '/y'  );
  var expected = ':///y?query=string#hash'
  test.identical( got, expected );

  var uri = ':///user:pass@sub.host.com:8080/p/a/t/h?query=string#hash';
  var got = _.uriNew.joinRaw_( uri, '/x//y//z'  );
  var expected = ':///x//y//z?query=string#hash'
  test.identical( got, expected );

  var uri = ':///user:pass@sub.host.com:8080/p/a/t/h?query=string#hash';
  var got = _.uriNew.joinRaw_( uri, 'x/'  );
  var expected = ':///user:pass@sub.host.com:8080/p/a/t/h/x?query=string#hash'
  test.identical( got, expected );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriNew.joinRaw_( 'file:///some/file', '/something/filePath/add' );
  test.identical( got, 'file:///something/filePath/add' );

  /* */

  test.case = 'add uris';

  var got = _.uriNew.joinRaw_( '//a', '//b', 'c' );
  test.identical( got, '//b/c' )

  var got = _.uriNew.joinRaw_( 'b://c', 'd://e', 'f' );
  test.identical( got, 'd://c/e/f' );

  var got = _.uriNew.joinRaw_( 'a://b', 'c://d/e', '//f/g' );
  test.identical( got, 'c:////f/g' )

  /* - */

  test.case = 'not global, windows path';
  var paths = [ 'c:\\', 'foo\\', 'bar\\' ];
  var expected = '/c/foo/bar/';
  var got = _.uriNew.joinRaw_.apply( _.uriNew, paths );
  test.identical( got, expected );

  test.case = 'not global';
  var paths = [ '/bar/', '/baz', 'foo/', '.' ];
  var expected = '/baz/foo/.';
  var got = _.uriNew.joinRaw_.apply( _.uriNew, paths );
  test.identical( got, expected );

  /* - */

  test.open( 'with nulls' );

  var paths = [ 'a', null ];
  var expected = null;
  var got = _.uriNew.joinRaw_.apply( _.uriNew, paths );
  test.identical( got, expected );

  var paths = [ '/', null ];
  var expected = null;
  var got = _.uriNew.joinRaw_.apply( _.uriNew, paths );
  test.identical( got, expected );

  var paths = [ 'a', null, 'b' ];
  var expected = 'b';
  var got = _.uriNew.joinRaw_.apply( _.uriNew, paths );
  test.identical( got, expected );

  var paths = [ '/a', null, 'b' ];
  var expected = 'b';
  var got = _.uriNew.joinRaw_.apply( _.uriNew, paths );
  test.identical( got, expected );

  var paths = [ '/a', null, '/b' ];
  var expected = '/b';
  var got = _.uriNew.joinRaw_.apply( _.uriNew, paths );
  test.identical( got, expected );

  test.close( 'with nulls' );

  /* - */

  test.case = 'other special cases';

  /* xxx */

  var paths = [  '/aa', 'bb//', 'cc' ];
  var expected = '/aa/bb//cc';
  var got = _.uriNew.joinRaw_.apply( _.uriNew, paths );
  test.identical( got, expected );

  var paths = [  '/aa', 'bb//', 'cc', '.' ];
  var expected = '/aa/bb//cc/.';
  var got = _.uriNew.joinRaw_.apply( _.uriNew, paths );
  test.identical( got, expected );

  var paths = [  '/', 'a', '//b', '././c', '../d', '..e' ];
  var expected = '//b/././c/../d/..e';
  var got = _.uriNew.joinRaw_.apply( _.uriNew, paths );
  test.identical( got, expected );
}

//

function reroot( test )
{

  // var expected = 'file:///src/file:///a';
  var expected = 'file:///src/a';
  var a = 'file:///src';
  var b = 'file:///a';
  var got = _.uriNew.reroot( a, b );
  test.identical( got, expected );

}

//

function relativeLocalPaths( test )
{
  var got;

  test.open( 'absolute' );

  /* */

  test.case = '/a - /b';
  var basePath = '/a';
  var filePath = '/b';
  var expected = '../b';
  var got = _.uriNew.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = '/a - /b';
  var basePath = '/a';
  var filePath = '/b';
  var expected = '../b';
  var got = _.uriNew.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = '/ - /b';
  var basePath = '/';
  var filePath = '/b';
  var expected = 'b';
  var got = _.uriNew.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'same path';
  var basePath = '/aa/bb/cc';
  var filePath = '/aa/bb/cc';
  var expected = '.';
  var got = _.uriNew.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'same path';
  var basePath = '/aa/bb/cc';
  var filePath = '/aa/bb/cc/';
  var expected = './';
  var got = _.uriNew.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'same path';
  var basePath = '/aa/bb/cc/';
  var filePath = '/aa/bb/cc';
  var expected = '.';
  var got = _.uriNew.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = '4 down';
  var basePath = '/aa//bb/cc/';
  var filePath = '//xx/yy/zz/';
  var expected = './../../../..//xx/yy/zz/';
  var got = _.uriNew.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'relative filePath parent directory';
  var basePath = '/aa/bb/cc';
  var filePath = '/aa/bb';
  var expected = '..';
  var got = _.uriNew.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'relative filePath parent directory';
  var basePath = '/aa/bb/cc/';
  var filePath = '/aa/bb';
  var expected = './..';
  var got = _.uriNew.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'relative filePath parent directory';
  var basePath = '/aa/bb/cc/';
  var filePath = '/aa/bb/';
  var expected = './../';
  var got = _.uriNew.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'relative filePath nested';
  var basePath = '/foo/bar/baz/asdf/quux';
  var filePath = '/foo/bar/baz/asdf/quux/new1';
  var expected = 'new1';
  var got = _.uriNew.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'out of relative dir';
  var basePath = '/abc';
  var filePath = '/a/b/z';
  var expected = '../a/b/z';
  var got = _.uriNew.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'relative root';
  var basePath = '/';
  var filePath = '/a/b/z';
  var expected = 'a/b/z';
  var got = _.uriNew.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'relative root';
  var basePath = '/';
  var filePath = '/';
  var expected = '.';
  var got = _.uriNew.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'windows disks';
  var basePath = 'd:/';
  var filePath = 'c:/x/y';
  var expected = '../c/x/y';
  var got = _.uriNew.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'long, not direct';
  var basePath = '/a/b/xx/yy/zz';
  var filePath = '/a/b/files/x/y/z.txt';
  var expected = '../../../files/x/y/z.txt';
  var got = _.uriNew.relative( basePath, filePath );
  test.identical( got, expected );

  test.close( 'absolute' );

  //

  test.open( 'relative' );

  /* */

  test.case = '. - .';
  var basePath = '.';
  var filePath = '.';
  var expected = '.';
  var got = _.uriNew.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'a - b';
  var basePath = 'a';
  var filePath = 'b';
  var expected = '../b';
  var got = _.uriNew.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'a/b - b/c';
  var basePath = 'a/b';
  var filePath = 'b/c';
  var expected = '../../b/c';
  var got = _.uriNew.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'a/b - a/b/c';
  var basePath = 'a/b';
  var filePath = 'a/b/c';
  var expected = 'c';
  var got = _.uriNew.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'a/b/c - a/b';
  var basePath = 'a/b/c';
  var filePath = 'a/b';
  var expected = '..';
  var got = _.uriNew.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'a/b/c - a/b';
  var basePath = 'a/b/c';
  var filePath = 'a/b';
  var expected = '..';
  var got = _.uriNew.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'a/b/c/d - a/b/d/c';
  var basePath = 'a/b/c/d';
  var filePath = 'a/b/d/c';
  var expected = '../../d/c';
  var got = _.uriNew.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'a - ../a';
  var basePath = 'a';
  var filePath = '../a';
  var expected = '../../a';
  var got = _.uriNew.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'a//b - a//c';
  var basePath = 'a//b';
  var filePath = 'a//c';
  var expected = '../c';
  var got = _.uriNew.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'a/./b - a/./c';
  var basePath = 'a/./b';
  var filePath = 'a/./c';
  var expected = '../c';
  var got = _.uriNew.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'a/../b - b';
  var basePath = 'a/../b';
  var filePath = 'b';
  var expected = '.';
  var got = _.uriNew.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'b - b/../b';
  var basePath = 'b';
  var filePath = 'b/../b';
  var expected = '.';
  var got = _.uriNew.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = '. - ..';
  var basePath = '.';
  var filePath = '..';
  var expected = '..';
  var got = _.uriNew.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = '. - ../..';
  var basePath = '.';
  var filePath = '../..';
  var expected = '../..';
  var got = _.uriNew.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = '.. - ../..';
  var basePath = '..';
  var filePath = '../..';
  var expected = '..';
  var got = _.uriNew.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = '.. - ..';
  var basePath = '..';
  var filePath = '..';
  var expected = '.';
  var got = _.uriNew.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = '../a/b - ../c/d';
  var basePath = '../a/b';
  var filePath = '../c/d';
  var expected = '../../c/d';
  var got = _.uriNew.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'a/../b/.. - b';
  var basePath = 'a/../b/..';
  var filePath = 'b';
  var expected = 'b';
  var got = _.uriNew.relative( basePath, filePath );
  test.identical( got, expected );

  test.close( 'relative' );

  //

  if( !Config.debug ) //
  return;

  test.open( 'relative' );

  // must be fails

  /* */

  test.case = '../a/b - .';
  var basePath = '../a/b';
  var filePath = '.';
  test.shouldThrowErrorOfAnyKind( () => _.uriNew.relative( basePath, filePath ) );

  /* */

  test.case = '../a/b - ./c/d';
  var basePath = '../a/b';
  var filePath = './c/d';
  test.shouldThrowErrorOfAnyKind( () => _.uriNew.relative( basePath, filePath ) );

  /* */

  test.case = '.. - .';
  var basePath = '..';
  var filePath = '.';
  test.shouldThrowErrorOfAnyKind( () => _.uriNew.relative( basePath, filePath ) );

  /* */

  test.case = '.. - ./a';
  var basePath = '..';
  var filePath = './a';
  test.shouldThrowErrorOfAnyKind( () => _.uriNew.relative( basePath, filePath ) );

  /* */

  test.case = '../a - a';
  var basePath = '../a';
  var filePath = 'a';
  test.shouldThrowErrorOfAnyKind( () => _.uriNew.relative( basePath, filePath ) );

  test.close( 'relative' );

  //

  test.open( 'other' )

  test.case = 'missed arguments';
  test.shouldThrowErrorSync( function( )
  {
    _.uriNew.relative( basePath );
  });

  test.case = 'extra arguments';
  test.shouldThrowErrorSync( function( )
  {
    _.uriNew.relative( 'from3', 'to3', 'to4' );
  });

  test.case = 'second argument is not string or array';
  test.shouldThrowErrorSync( function( )
  {
    _.uriNew.relative( 'from3', null );
  });

  test.case = 'relative + absolute';
  test.shouldThrowErrorSync( function( )
  {
    _.uriNew.relative( '.', '/' );
  });

  test.close( 'other' )

};

//

function relative( test )
{
  var got;

  /* - */

  test.open( 'absolute' );

  /* */

  test.case = 'git+https:///github.com/repo/wTools - git+https:///github.com/repo/wTools#bd9094b8';
  var basePath = 'git+https:///github.com/repo/wTools';
  var filePath = 'git+https:///github.com/repo/wTools#bd9094b8';
  var expected = 'git+https://.#bd9094b8';
  var got = _.uriNew.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = '/a - /b';
  var basePath = 'file:///a';
  var filePath = 'file:///b';
  var expected = 'file://../b';
  var got = _.uriNew.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = '/a - /b';
  var basePath = 'file:///a';
  var filePath = 'file:///b';
  var expected = 'file://../b';
  var got = _.uriNew.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = '/ - /b';
  var basePath = 'file:///';
  var filePath = 'file:///b';
  var expected = 'file://b';
  var got = _.uriNew.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'same path';
  var basePath = 'file:///aa/bb/cc';
  var filePath = 'file:///aa/bb/cc';
  var expected = 'file://.';
  var got = _.uriNew.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'same path';
  var basePath = 'file:///aa/bb/cc';
  var filePath = 'file:///aa/bb/cc/';
  var expected = 'file://./';
  var got = _.uriNew.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'same path';
  var basePath = 'file:///aa/bb/cc/';
  var filePath = 'file:///aa/bb/cc';
  var expected = 'file://.';
  var got = _.uriNew.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'same path';
  var basePath = 'file:///aa//bb/cc/';
  var filePath = 'file:////xx/yy/zz/';
  var expected = 'file://./../../../..//xx/yy/zz/';
  var got = _.uriNew.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'relative filePath parent directory';
  var basePath = 'file:///aa/bb/cc';
  var filePath = 'file:///aa/bb';
  var expected = 'file://..';
  var got = _.uriNew.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'relative filePath parent directory';
  var basePath = 'file:///aa/bb/cc/';
  var filePath = 'file:///aa/bb';
  var expected = 'file://./..';
  var got = _.uriNew.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'relative filePath parent directory';
  var basePath = 'file:///aa/bb/cc/';
  var filePath = 'file:///aa/bb/';
  var expected = 'file://./../';
  var got = _.uriNew.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'relative filePath nested';
  var basePath = 'file:///foo/bar/baz/asdf/quux';
  var filePath = 'file:///foo/bar/baz/asdf/quux/new1';
  var expected = 'file://new1';
  var got = _.uriNew.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'out of relative dir';
  var basePath = 'file:///abc';
  var filePath = 'file:///a/b/z';
  var expected = 'file://../a/b/z';
  var got = _.uriNew.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'relative root';
  var basePath = 'file:///';
  var filePath = 'file:///a/b/z';
  var expected = 'file://a/b/z';
  var got = _.uriNew.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'relative root';
  var basePath = 'file:///';
  var filePath = 'file:///';
  var expected = 'file://.';
  var got = _.uriNew.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'windows disks';
  var basePath = 'file://d:/';
  var filePath = 'file://c:/x/y';
  var expected = 'file://../c/x/y';
  var got = _.uriNew.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'long, not direct';
  var basePath = 'file:///a/b/xx/yy/zz';
  var filePath = 'file:///a/b/files/x/y/z.txt';
  var expected = 'file://../../../files/x/y/z.txt';
  var got = _.uriNew.relative( basePath, filePath );
  test.identical( got, expected );

  test.close( 'absolute' );

  /* - */

  test.open( 'relative' );

  /* */

  test.case = '. - .';
  var basePath = 'file://.';
  var filePath = 'file://.';
  var expected = 'file://.';
  var got = _.uriNew.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'a - b';
  var basePath = 'file://a';
  var filePath = 'file://b';
  var expected = 'file://../b';
  var got = _.uriNew.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'a/b - b/c';
  var basePath = 'file://a/b';
  var filePath = 'file://b/c';
  var expected = 'file://../../b/c';
  var got = _.uriNew.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'a/b - a/b/c';
  var basePath = 'file://a/b';
  var filePath = 'file://a/b/c';
  var expected = 'file://c';
  var got = _.uriNew.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'a/b/c - a/b';
  var basePath = 'file://a/b/c';
  var filePath = 'file://a/b';
  var expected = 'file://..';
  var got = _.uriNew.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'a/b/c - a/b';
  var basePath = 'file://a/b/c';
  var filePath = 'file://a/b';
  var expected = 'file://..';
  var got = _.uriNew.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'a/b/c/d - a/b/d/c';
  var basePath = 'file://a/b/c/d';
  var filePath = 'file://a/b/d/c';
  var expected = 'file://../../d/c';
  var got = _.uriNew.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'a - ../a';
  var basePath = 'file://a';
  var filePath = 'file://../a';
  var expected = 'file://../../a';
  var got = _.uriNew.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'a//b - a//c';
  var basePath = 'file://a//b';
  var filePath = 'file://a//c';
  var expected = 'file://../c';
  var got = _.uriNew.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'a/./b - a/./c';
  var basePath = 'file://a/./b';
  var filePath = 'file://a/./c';
  var expected = 'file://../c';
  var got = _.uriNew.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'a/../b - b';
  var basePath = 'file://a/../b';
  var filePath = 'file://b';
  var expected = 'file://.';
  var got = _.uriNew.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'b - b/../b';
  var basePath = 'file://b';
  var filePath = 'file://b/../b';
  var expected = 'file://.';
  var got = _.uriNew.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = '. - ..';
  var basePath = 'file://.';
  var filePath = 'file://..';
  var expected = 'file://..';
  var got = _.uriNew.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = '. - ../..';
  var basePath = 'file://.';
  var filePath = 'file://../..';
  var expected = 'file://../..';
  var got = _.uriNew.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = '.. - ../..';
  var basePath = 'file://..';
  var filePath = 'file://../..';
  var expected = 'file://..';
  var got = _.uriNew.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = '.. - ..';
  var basePath = '..';
  var filePath = 'file://..';
  var expected = 'file://.';
  var got = _.uriNew.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = '.. - ..';
  var basePath = 'file://..';
  var filePath = '..';
  var expected = 'file://.';
  var got = _.uriNew.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = '../a/b - ../c/d';
  var basePath = 'file://../a/b';
  var filePath = 'file://../c/d';
  var expected = 'file://../../c/d';
  var got = _.uriNew.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'a/../b/.. - b';
  var basePath = 'file://a/../b/..';
  var filePath = 'file://b';
  var expected = 'file://b';
  var got = _.uriNew.relative( basePath, filePath );
  test.identical( got, expected );

  test.close( 'relative' );

  /* - */

  test.open( 'absolute - options map' );

  /* */

  test.case = 'git+https:///github.com/repo/wTools - git+https:///github.com/repo/wTools#bd9094b8';
  var basePath = 'git+https:///github.com/repo/wTools';
  var filePath = 'git+https:///github.com/repo/wTools#bd9094b8';
  var expected = 'git+https://.#bd9094b8';
  var got = _.uriNew.relative({ basePath, filePath });
  test.identical( got, expected );

  /* */

  test.case = '/a - /b';
  var basePath = 'file:///a';
  var filePath = 'file:///b';
  var expected = 'file://../b';
  var got = _.uriNew.relative({ basePath, filePath });
  test.identical( got, expected );

  /* */

  test.case = '/a - /b';
  var basePath = 'file:///a';
  var filePath = 'file:///b';
  var expected = 'file://../b';
  var got = _.uriNew.relative({ basePath, filePath });
  test.identical( got, expected );

  /* */

  test.case = '/ - /b';
  var basePath = 'file:///';
  var filePath = 'file:///b';
  var expected = 'file://b';
  var got = _.uriNew.relative({ basePath, filePath });
  test.identical( got, expected );

  /* */

  test.case = 'same path';
  var basePath = 'file:///aa/bb/cc';
  var filePath = 'file:///aa/bb/cc';
  var expected = 'file://.';
  var got = _.uriNew.relative({ basePath, filePath });
  test.identical( got, expected );

  /* */

  test.case = 'same path';
  var basePath = 'file:///aa/bb/cc';
  var filePath = 'file:///aa/bb/cc/';
  var expected = 'file://./';
  var got = _.uriNew.relative({ basePath, filePath });
  test.identical( got, expected );

  /* */

  test.case = 'same path';
  var basePath = 'file:///aa/bb/cc/';
  var filePath = 'file:///aa/bb/cc';
  var expected = 'file://.';
  var got = _.uriNew.relative({ basePath, filePath });
  test.identical( got, expected );

  /* */

  test.case = 'same path';
  var basePath = 'file:///aa//bb/cc/';
  var filePath = 'file:////xx/yy/zz/';
  var expected = 'file://./../../../..//xx/yy/zz/';
  var got = _.uriNew.relative({ basePath, filePath });
  test.identical( got, expected );

  /* */

  test.case = 'relative filePath parent directory';
  var basePath = 'file:///aa/bb/cc';
  var filePath = 'file:///aa/bb';
  var expected = 'file://..';
  var got = _.uriNew.relative({ basePath, filePath });
  test.identical( got, expected );

  /* */

  test.case = 'relative filePath parent directory';
  var basePath = 'file:///aa/bb/cc/';
  var filePath = 'file:///aa/bb';
  var expected = 'file://./..';
  var got = _.uriNew.relative({ basePath, filePath });
  test.identical( got, expected );

  /* */

  test.case = 'relative filePath parent directory';
  var basePath = 'file:///aa/bb/cc/';
  var filePath = 'file:///aa/bb/';
  var expected = 'file://./../';
  var got = _.uriNew.relative({ basePath, filePath });
  test.identical( got, expected );

  /* */

  test.case = 'relative filePath nested';
  var basePath = 'file:///foo/bar/baz/asdf/quux';
  var filePath = 'file:///foo/bar/baz/asdf/quux/new1';
  var expected = 'file://new1';
  var got = _.uriNew.relative({ basePath, filePath });
  test.identical( got, expected );

  /* */

  test.case = 'out of relative dir';
  var basePath = 'file:///abc';
  var filePath = 'file:///a/b/z';
  var expected = 'file://../a/b/z';
  var got = _.uriNew.relative({ basePath, filePath });
  test.identical( got, expected );

  /* */

  test.case = 'relative root';
  var basePath = 'file:///';
  var filePath = 'file:///a/b/z';
  var expected = 'file://a/b/z';
  var got = _.uriNew.relative({ basePath, filePath });
  test.identical( got, expected );

  /* */

  test.case = 'relative root';
  var basePath = 'file:///';
  var filePath = 'file:///';
  var expected = 'file://.';
  var got = _.uriNew.relative({ basePath, filePath });
  test.identical( got, expected );

  /* */

  test.case = 'windows disks';
  var basePath = 'file://d:/';
  var filePath = 'file://c:/x/y';
  var expected = 'file://../c/x/y';
  var got = _.uriNew.relative({ basePath, filePath });
  test.identical( got, expected );

  /* */

  test.case = 'long, not direct';
  var basePath = 'file:///a/b/xx/yy/zz';
  var filePath = 'file:///a/b/files/x/y/z.txt';
  var expected = 'file://../../../files/x/y/z.txt';
  var got = _.uriNew.relative({ basePath, filePath });
  test.identical( got, expected );

  test.close( 'absolute - options map' );

  /* - */

  test.open( 'relative - options map' );

  /* */

  test.case = '. - .';
  var basePath = 'file://.';
  var filePath = 'file://.';
  var expected = 'file://.';
  var got = _.uriNew.relative({ basePath, filePath });
  test.identical( got, expected );

  /* */

  test.case = 'a - b';
  var basePath = 'file://a';
  var filePath = 'file://b';
  var expected = 'file://../b';
  var got = _.uriNew.relative({ basePath, filePath });
  test.identical( got, expected );

  /* */

  test.case = 'a/b - b/c';
  var basePath = 'file://a/b';
  var filePath = 'file://b/c';
  var expected = 'file://../../b/c';
  var got = _.uriNew.relative({ basePath, filePath });
  test.identical( got, expected );

  /* */

  test.case = 'a/b - a/b/c';
  var basePath = 'file://a/b';
  var filePath = 'file://a/b/c';
  var expected = 'file://c';
  var got = _.uriNew.relative({ basePath, filePath });
  test.identical( got, expected );

  /* */

  test.case = 'a/b/c - a/b';
  var basePath = 'file://a/b/c';
  var filePath = 'file://a/b';
  var expected = 'file://..';
  var got = _.uriNew.relative({ basePath, filePath });
  test.identical( got, expected );

  /* */

  test.case = 'a/b/c - a/b';
  var basePath = 'file://a/b/c';
  var filePath = 'file://a/b';
  var expected = 'file://..';
  var got = _.uriNew.relative({ basePath, filePath });
  test.identical( got, expected );

  /* */

  test.case = 'a/b/c/d - a/b/d/c';
  var basePath = 'file://a/b/c/d';
  var filePath = 'file://a/b/d/c';
  var expected = 'file://../../d/c';
  var got = _.uriNew.relative({ basePath, filePath });
  test.identical( got, expected );

  /* */

  test.case = 'a - ../a';
  var basePath = 'file://a';
  var filePath = 'file://../a';
  var expected = 'file://../../a';
  var got = _.uriNew.relative({ basePath, filePath });
  test.identical( got, expected );

  /* */

  test.case = 'a//b - a//c';
  var basePath = 'file://a//b';
  var filePath = 'file://a//c';
  var expected = 'file://../c';
  var got = _.uriNew.relative({ basePath, filePath });
  test.identical( got, expected );

  /* */

  test.case = 'a/./b - a/./c';
  var basePath = 'file://a/./b';
  var filePath = 'file://a/./c';
  var expected = 'file://../c';
  var got = _.uriNew.relative({ basePath, filePath });
  test.identical( got, expected );

  /* */

  test.case = 'a/../b - b';
  var basePath = 'file://a/../b';
  var filePath = 'file://b';
  var expected = 'file://.';
  var got = _.uriNew.relative({ basePath, filePath });
  test.identical( got, expected );

  /* */

  test.case = 'b - b/../b';
  var basePath = 'file://b';
  var filePath = 'file://b/../b';
  var expected = 'file://.';
  var got = _.uriNew.relative({ basePath, filePath });
  test.identical( got, expected );

  /* */

  test.case = '. - ..';
  var basePath = 'file://.';
  var filePath = 'file://..';
  var expected = 'file://..';
  var got = _.uriNew.relative({ basePath, filePath });
  test.identical( got, expected );

  /* */

  test.case = '. - ../..';
  var basePath = 'file://.';
  var filePath = 'file://../..';
  var expected = 'file://../..';
  var got = _.uriNew.relative({ basePath, filePath });
  test.identical( got, expected );

  /* */

  test.case = '.. - ../..';
  var basePath = 'file://..';
  var filePath = 'file://../..';
  var expected = 'file://..';
  var got = _.uriNew.relative({ basePath, filePath });
  test.identical( got, expected );

  /* */

  test.case = '.. - ..';
  var basePath = '..';
  var filePath = 'file://..';
  var expected = 'file://.';
  var got = _.uriNew.relative({ basePath, filePath });
  test.identical( got, expected );

  /* */

  test.case = '.. - ..';
  var basePath = 'file://..';
  var filePath = '..';
  var expected = 'file://.';
  var got = _.uriNew.relative({ basePath, filePath });
  test.identical( got, expected );

  /* */

  test.case = '../a/b - ../c/d';
  var basePath = 'file://../a/b';
  var filePath = 'file://../c/d';
  var expected = 'file://../../c/d';
  var got = _.uriNew.relative({ basePath, filePath });
  test.identical( got, expected );

  /* */

  test.case = 'a/../b/.. - b';
  var basePath = 'file://a/../b/..';
  var filePath = 'file://b';
  var expected = 'file://b';
  var got = _.uriNew.relative({ basePath, filePath });
  test.identical( got, expected );

  test.close( 'relative - options map' );

  /* - */

  test.open( 'absolute - global:0' );

  /* */

  test.case = 'git+https:///github.com/repo/wTools - git+https:///github.com/repo/wTools#bd9094b8';
  var basePath = 'git+https:///github.com/repo/wTools';
  var filePath = 'git+https:///github.com/repo/wTools#bd9094b8';
  var expected = '.#bd9094b8';
  var got = _.uriNew.relative({ basePath, filePath, global : 0 });
  test.identical( got, expected );

  /* */

  test.case = '/a - /b';
  var basePath = 'file:///a';
  var filePath = 'file:///b';
  var expected = '../b';
  var got = _.uriNew.relative({ basePath, filePath, global : 0 });
  test.identical( got, expected );

  /* */

  test.case = '/a - /b';
  var basePath = 'file:///a';
  var filePath = 'file:///b';
  var expected = '../b';
  var got = _.uriNew.relative({ basePath, filePath, global : 0 });
  test.identical( got, expected );

  /* */

  test.case = '/ - /b';
  var basePath = 'file:///';
  var filePath = 'file:///b';
  var expected = 'b';
  var got = _.uriNew.relative({ basePath, filePath, global : 0 });
  test.identical( got, expected );

  /* */

  test.case = 'same path';
  var basePath = 'file:///aa/bb/cc';
  var filePath = 'file:///aa/bb/cc';
  var expected = '.';
  var got = _.uriNew.relative({ basePath, filePath, global : 0 });
  test.identical( got, expected );

  /* */

  test.case = 'same path';
  var basePath = 'file:///aa/bb/cc';
  var filePath = 'file:///aa/bb/cc/';
  var expected = './';
  var got = _.uriNew.relative({ basePath, filePath, global : 0 });
  test.identical( got, expected );

  /* */

  test.case = 'same path';
  var basePath = 'file:///aa/bb/cc/';
  var filePath = 'file:///aa/bb/cc';
  var expected = '.';
  var got = _.uriNew.relative({ basePath, filePath, global : 0 });
  test.identical( got, expected );

  /* */

  test.case = 'same path';
  var basePath = 'file:///aa//bb/cc/';
  var filePath = 'file:////xx/yy/zz/';
  var expected = './../../../..//xx/yy/zz/';
  var got = _.uriNew.relative({ basePath, filePath, global : 0 });
  test.identical( got, expected );

  /* */

  test.case = 'relative filePath parent directory';
  var basePath = 'file:///aa/bb/cc';
  var filePath = 'file:///aa/bb';
  var expected = '..';
  var got = _.uriNew.relative({ basePath, filePath, global : 0 });
  test.identical( got, expected );

  /* */

  test.case = 'relative filePath parent directory';
  var basePath = 'file:///aa/bb/cc/';
  var filePath = 'file:///aa/bb';
  var expected = './..';
  var got = _.uriNew.relative({ basePath, filePath, global : 0 });
  test.identical( got, expected );

  /* */

  test.case = 'relative filePath parent directory';
  var basePath = 'file:///aa/bb/cc/';
  var filePath = 'file:///aa/bb/';
  var expected = './../';
  var got = _.uriNew.relative({ basePath, filePath, global : 0 });
  test.identical( got, expected );

  /* */

  test.case = 'relative filePath nested';
  var basePath = 'file:///foo/bar/baz/asdf/quux';
  var filePath = 'file:///foo/bar/baz/asdf/quux/new1';
  var expected = 'new1';
  var got = _.uriNew.relative({ basePath, filePath, global : 0 });
  test.identical( got, expected );

  /* */

  test.case = 'out of relative dir';
  var basePath = 'file:///abc';
  var filePath = 'file:///a/b/z';
  var expected = '../a/b/z';
  var got = _.uriNew.relative({ basePath, filePath, global : 0 });
  test.identical( got, expected );

  /* */

  test.case = 'relative root';
  var basePath = 'file:///';
  var filePath = 'file:///a/b/z';
  var expected = 'a/b/z';
  var got = _.uriNew.relative({ basePath, filePath, global : 0 });
  test.identical( got, expected );

  /* */

  test.case = 'relative root';
  var basePath = 'file:///';
  var filePath = 'file:///';
  var expected = '.';
  var got = _.uriNew.relative({ basePath, filePath, global : 0 });
  test.identical( got, expected );

  /* */

  test.case = 'windows disks';
  var basePath = 'file://d:/';
  var filePath = 'file://c:/x/y';
  var expected = '../c/x/y';
  var got = _.uriNew.relative({ basePath, filePath, global : 0 });
  test.identical( got, expected );

  /* */

  test.case = 'long, not direct';
  var basePath = 'file:///a/b/xx/yy/zz';
  var filePath = 'file:///a/b/files/x/y/z.txt';
  var expected = '../../../files/x/y/z.txt';
  var got = _.uriNew.relative({ basePath, filePath, global : 0 });
  test.identical( got, expected );

  test.close( 'absolute - global:0' );

  /* - */

  test.open( 'relative - global:0' );

  /* */

  test.case = '. - .';
  var basePath = 'file://.';
  var filePath = 'file://.';
  var expected = '.';
  var got = _.uriNew.relative({ basePath, filePath, global : 0 });
  test.identical( got, expected );

  /* */

  test.case = 'a - b';
  var basePath = 'file://a';
  var filePath = 'file://b';
  var expected = '../b';
  var got = _.uriNew.relative({ basePath, filePath, global : 0 });
  test.identical( got, expected );

  /* */

  test.case = 'a/b - b/c';
  var basePath = 'file://a/b';
  var filePath = 'file://b/c';
  var expected = '../../b/c';
  var got = _.uriNew.relative({ basePath, filePath, global : 0 });
  test.identical( got, expected );

  /* */

  test.case = 'a/b - a/b/c';
  var basePath = 'file://a/b';
  var filePath = 'file://a/b/c';
  var expected = 'c';
  var got = _.uriNew.relative({ basePath, filePath, global : 0 });
  test.identical( got, expected );

  /* */

  test.case = 'a/b/c - a/b';
  var basePath = 'file://a/b/c';
  var filePath = 'file://a/b';
  var expected = '..';
  var got = _.uriNew.relative({ basePath, filePath, global : 0 });
  test.identical( got, expected );

  /* */

  test.case = 'a/b/c - a/b';
  var basePath = 'file://a/b/c';
  var filePath = 'file://a/b';
  var expected = '..';
  var got = _.uriNew.relative({ basePath, filePath, global : 0 });
  test.identical( got, expected );

  /* */

  test.case = 'a/b/c/d - a/b/d/c';
  var basePath = 'file://a/b/c/d';
  var filePath = 'file://a/b/d/c';
  var expected = '../../d/c';
  var got = _.uriNew.relative({ basePath, filePath, global : 0 });
  test.identical( got, expected );

  /* */

  test.case = 'a - ../a';
  var basePath = 'file://a';
  var filePath = 'file://../a';
  var expected = '../../a';
  var got = _.uriNew.relative({ basePath, filePath, global : 0 });
  test.identical( got, expected );

  /* */

  test.case = 'a//b - a//c';
  var basePath = 'file://a//b';
  var filePath = 'file://a//c';
  var expected = '../c';
  var got = _.uriNew.relative({ basePath, filePath, global : 0 });
  test.identical( got, expected );

  /* */

  test.case = 'a/./b - a/./c';
  var basePath = 'file://a/./b';
  var filePath = 'file://a/./c';
  var expected = '../c';
  var got = _.uriNew.relative({ basePath, filePath, global : 0 });
  test.identical( got, expected );

  /* */

  test.case = 'a/../b - b';
  var basePath = 'file://a/../b';
  var filePath = 'file://b';
  var expected = '.';
  var got = _.uriNew.relative({ basePath, filePath, global : 0 });
  test.identical( got, expected );

  /* */

  test.case = 'b - b/../b';
  var basePath = 'file://b';
  var filePath = 'file://b/../b';
  var expected = '.';
  var got = _.uriNew.relative({ basePath, filePath, global : 0 });
  test.identical( got, expected );

  /* */

  test.case = '. - ..';
  var basePath = 'file://.';
  var filePath = 'file://..';
  var expected = '..';
  var got = _.uriNew.relative({ basePath, filePath, global : 0 });
  test.identical( got, expected );

  /* */

  test.case = '. - ../..';
  var basePath = 'file://.';
  var filePath = 'file://../..';
  var expected = '../..';
  var got = _.uriNew.relative({ basePath, filePath, global : 0 });
  test.identical( got, expected );

  /* */

  test.case = '.. - ../..';
  var basePath = 'file://..';
  var filePath = 'file://../..';
  var expected = '..';
  var got = _.uriNew.relative({ basePath, filePath, global : 0 });
  test.identical( got, expected );

  /* */

  test.case = '.. - ..';
  var basePath = '..';
  var filePath = 'file://..';
  var expected = 'file://.';
  var got = _.uriNew.relative({ basePath, filePath, global : 0 });
  test.identical( got, expected );

  /* */

  test.case = '.. - ..';
  var basePath = 'file://..';
  var filePath = '..';
  var expected = '.';
  var got = _.uriNew.relative({ basePath, filePath, global : 0 });
  test.identical( got, expected );

  /* */

  test.case = '../a/b - ../c/d';
  var basePath = 'file://../a/b';
  var filePath = 'file://../c/d';
  var expected = '../../c/d';
  var got = _.uriNew.relative({ basePath, filePath, global : 0 });
  test.identical( got, expected );

  /* */

  test.case = 'a/../b/.. - b';
  var basePath = 'file://a/../b/..';
  var filePath = 'file://b';
  var expected = 'b';
  var got = _.uriNew.relative({ basePath, filePath, global : 0 });
  test.identical( got, expected );

  test.close( 'relative - global:0' );

  /* - */

  if( !Config.debug ) //
  return;

  test.open( 'relative' );

  // must be fails

  /* */

  test.case = '../a/b - .';
  var basePath = 'file://../a/b';
  var filePath = 'file://.';
  test.shouldThrowErrorOfAnyKind( () => _.uriNew.relative( basePath, filePath ) );

  /* */

  test.case = '../a/b - ./c/d';
  var basePath = 'file://../a/b';
  var filePath = 'file://./c/d';
  test.shouldThrowErrorOfAnyKind( () => _.uriNew.relative( basePath, filePath ) );

  /* */

  test.case = '.. - .';
  var basePath = 'file://..';
  var filePath = 'file://.';
  test.shouldThrowErrorOfAnyKind( () => _.uriNew.relative( basePath, filePath ) );

  /* */

  test.case = '.. - ./a';
  var basePath = 'file://..';
  var filePath = 'file://./a';
  test.shouldThrowErrorOfAnyKind( () => _.uriNew.relative( basePath, filePath ) );

  /* */

  test.case = '../a - a';
  var basePath = 'file://../a';
  var filePath = 'file://a';
  test.shouldThrowErrorOfAnyKind( () => _.uriNew.relative( basePath, filePath ) );

  test.close( 'relative' );

  //

  test.open( 'other' )

  test.case = 'missed arguments';
  test.shouldThrowErrorSync( function( )
  {
    _.uriNew.relative( basePath );
  });

  test.case = 'extra arguments';
  test.shouldThrowErrorSync( function( )
  {
    _.uriNew.relative( 'from3', 'to3', 'to4' );
  });

  test.case = 'second argument is not string or array';
  test.shouldThrowErrorSync( function( )
  {
    _.uriNew.relative( 'from3', null );
  });

  test.case = 'relative + absolute';
  test.shouldThrowErrorSync( function( )
  {
    _.uriNew.relative( '.', '/' );
  });

  test.close( 'other' )

};

//

function commonLocalPaths( test )
{
  test.case = 'absolute-absolute'

  var got = _.uriNew.common( '/a1/b2', '/a1/b' );
  test.identical( got, '/a1/' );

  var got = _.uriNew.common( '/a1/b2', '/a1/b1' );
  test.identical( got, '/a1/' );

  var got = _.uriNew.common( '/a1/x/../b1', '/a1/b1' );
  test.identical( got, '/a1/b1' );

  var got = _.uriNew.common( '/a1/b1/c1', '/a1/b1/c' );
  test.identical( got, '/a1/b1/' );

  var got = _.uriNew.common( '/a1/../../b1/c1', '/a1/b1/c1' );
  test.identical( got, '/' );

  var got = _.uriNew.common( '/abcd', '/ab' );
  test.identical( got, '/' );

  var got = _.uriNew.common( '/.a./.b./.c.', '/.a./.b./.c' );
  test.identical( got, '/.a./.b./' );

  var got = _.uriNew.common( '//a//b//c', '//a/b' );
  test.identical( got, '//a/' );

  var got = _.uriNew.common( '//a//b//c', '/a/b' );
  test.identical( got, '/' );

  var got = _.uriNew.common( '/a//b', '/a//b' );
  test.identical( got, '/a//b' );

  var got = _.uriNew.common( '/a//', '/a//' );
  test.identical( got, '/a//' );

  var got = _.uriNew.common( '/./a/./b/./c', '/a/b' );
  test.identical( got, '/a/b' );

  var got = _.uriNew.common( '/A/b/c', '/a/b/c' );
  test.identical( got, '/' );

  var got = _.uriNew.common( '/', '/x' );
  test.identical( got, '/' );

  var got = _.uriNew.common( '/a', '/x'  );
  test.identical( got, '/' );

  // test.case = 'absolute-relative'
  //
  // var got = _.uriNew.common( '/', '..' );
  // test.identical( got, '/' );
  //
  // var got = _.uriNew.common( '/', '.' );
  // test.identical( got, '/' );
  //
  // var got = _.uriNew.common( '/', 'x' );
  // test.identical( got, '/' );
  //
  // var got = _.uriNew.common( '/', '../..' );
  // test.identical( got, '/' );

  test.case = 'relative-relative'

  var got = _.uriNew.common( 'a1/b2', 'a1/b' );
  test.identical( got, 'a1/' );

  var got = _.uriNew.common( 'a1/b2', 'a1/b1' );
  test.identical( got, 'a1/' );

  var got = _.uriNew.common( 'a1/x/../b1', 'a1/b1' );
  test.identical( got, 'a1/b1' );

  var got = _.uriNew.common( './a1/x/../b1', 'a1/b1' );
  test.identical( got, 'a1/b1' );

  var got = _.uriNew.common( './a1/x/../b1', './a1/b1' );
  test.identical( got, 'a1/b1');

  var got = _.uriNew.common( './a1/x/../b1', '../a1/b1' );
  test.identical( got, '..');

  var got = _.uriNew.common( '.', '..' );
  test.identical( got, '..' );

  var got = _.uriNew.common( './b/c', './x' );
  test.identical( got, '.' );

  var got = _.uriNew.common( './././a', './a/b' );
  test.identical( got, 'a' );

  var got = _.uriNew.common( './a/./b', './a/b' );
  test.identical( got, 'a/b' );

  var got = _.uriNew.common( './a/./b', './a/c/../b' );
  test.identical( got, 'a/b' );

  var got = _.uriNew.common( '../b/c', './x' );
  test.identical( got, '..' );

  var got = _.uriNew.common( '../../b/c', '../b' );
  test.identical( got, '../..' );

  var got = _.uriNew.common( '../../b/c', '../../../x' );
  test.identical( got, '../../..' );

  var got = _.uriNew.common( '../../b/c/../../x', '../../../x' );
  test.identical( got, '../../..' );

  var got = _.uriNew.common( './../../b/c/../../x', './../../../x' );
  test.identical( got, '../../..' );

  var got = _.uriNew.common( '../../..', './../../..' );
  test.identical( got, '../../..' );

  var got = _.uriNew.common( './../../..', './../../..' );
  test.identical( got, '../../..' );

  var got = _.uriNew.common( '../../..', '../../..' );
  test.identical( got, '../../..' );

  var got = _.uriNew.common( '../b', '../b' );
  test.identical( got, '../b' );

  var got = _.uriNew.common( '../b', './../b' );
  test.identical( got, '../b' );

  test.case = 'several absolute paths'

  var got = _.uriNew.common( '/a/b/c', '/a/b/c', '/a/b/c' );
  test.identical( got, '/a/b/c' );

  var got = _.uriNew.common( '/a/b/c', '/a/b/c', '/a/b' );
  test.identical( got, '/a/b' );

  var got = _.uriNew.common( '/a/b/c', '/a/b/c', '/a/b1' );
  test.identical( got, '/a/' );

  var got = _.uriNew.common( '/a/b/c', '/a/b/c', '/a' );
  test.identical( got, '/a' );

  var got = _.uriNew.common( '/a/b/c', '/a/b/c', '/x' );
  test.identical( got, '/' );

  var got = _.uriNew.common( '/a/b/c', '/a/b/c', '/' );
  test.identical( got, '/' );

  test.case = 'several relative paths';

  var got = _.uriNew.common( 'a/b/c', 'a/b/c', 'a/b/c' );
  test.identical( got, 'a/b/c' );

  var got = _.uriNew.common( 'a/b/c', 'a/b/c', 'a/b' );
  test.identical( got, 'a/b' );

  var got = _.uriNew.common( 'a/b/c', 'a/b/c', 'a/b1' );
  test.identical( got, 'a/' );

  var got = _.uriNew.common( 'a/b/c', 'a/b/c', '.' );
  test.identical( got, '.' );

  var got = _.uriNew.common( 'a/b/c', 'a/b/c', 'x' );
  test.identical( got, '.' );

  var got = _.uriNew.common( 'a/b/c', 'a/b/c', './' );
  test.identical( got, '.' );

  var got = _.uriNew.common( '../a/b/c', 'a/../b/c', 'a/b/../c' );
  test.identical( got, '..' );

  var got = _.uriNew.common( './a/b/c', '../../a/b/c', '../../../a/b' );
  test.identical( got, '../../..' );

  var got = _.uriNew.common( '.', './', '..' );
  test.identical( got, '..' );

  var got = _.uriNew.common( '.', './../..', '..' );
  test.identical( got, '../..' );

  /* */

  if( !Config.debug )
  return

  test.shouldThrowErrorOfAnyKind( () => _.uriNew.common( '/a', '..' ) );
  test.shouldThrowErrorOfAnyKind( () => _.uriNew.common( '/a', '.' ) );
  test.shouldThrowErrorOfAnyKind( () => _.uriNew.common( '/a', 'x' ) );
  test.shouldThrowErrorOfAnyKind( () => _.uriNew.common( '/a', '../..' ) );

  test.shouldThrowErrorOfAnyKind( () => _.uriNew.common( '/a/b/c', '/a/b/c', './' ) );
  test.shouldThrowErrorOfAnyKind( () => _.uriNew.common( '/a/b/c', '/a/b/c', '.' ) );
  test.shouldThrowErrorOfAnyKind( () => _.uriNew.common( 'x', '/a/b/c', '/a' ) );
  test.shouldThrowErrorOfAnyKind( () => _.uriNew.common( '/a/b/c', '..', '/a' ) );
  test.shouldThrowErrorOfAnyKind( () => _.uriNew.common( '../..', '../../b/c', '/a' ) );

}

//

function common( test )
{

  test.case = 'empty';

  var got = _.uriNew.common();
  test.identical( got, null );

  var got = _.uriNew.common([]);
  test.identical( got, null );

  test.case = 'array';

  var got = _.uriNew.common([ '/a1/b2', '/a1/b' ]);
  test.identical( got, '/a1/' );

  var got = _.uriNew.common( [ '/a1/b1/c', '/a1/b1/d' ], '/a1/b2' );
  test.identical( got, '/a1/' );

  test.case = 'other';

  var got = _.uriNew.common( 'npm:///wprocedure#0.3.19', 'npm:///wprocedure' );
  test.identical( got, 'npm:///wprocedure' );

  var got = _.uriNew.common( 'npm:///wprocedure', 'npm:///wprocedure#0.3.19' );
  test.identical( got, 'npm:///wprocedure' );

  var got = _.uriNew.common( 'npm:///wprocedure#0.3.19', 'npm:///wprocedure#' );
  test.identical( got, 'npm:///wprocedure' );

  var got = _.uriNew.common( 'npm:///wprocedure#', 'npm:///wprocedure#0.3.19' );
  test.identical( got, 'npm:///wprocedure' );

  var got = _.uriNew.common( 'git+https:///github.com/repo/wTools#bd9094b83', 'git+https:///github.com/repo/wTools#master' );
  test.identical( got, 'git+https:///github.com/repo/wTools' );

  var got = _.uriNew.common( '://a1/b2', '://some/staging/index.html' );
  test.identical( got, '://.' );

  var got = _.uriNew.common( '://some/staging/index.html', '://a1/b2' );
  test.identical( got, '://.' );

  var got = _.uriNew.common( '://some/staging/index.html', '://some/staging/' );
  test.identical( got, '://some/staging/' );

  var got = _.uriNew.common( '://some/staging/index.html', '://some/stagi' );
  test.identical( got, '://some/' );

  var got = _.uriNew.common( 'file:///some/staging/index.html', ':///some/stagi' );
  test.identical( got, ':///some/' );

  var got = _.uriNew.common( 'file://some/staging/index.html', '://some/stagi' );
  test.identical( got, '://some/' );

  var got = _.uriNew.common( 'file:///some/staging/index.html', '/some/stagi' );
  test.identical( got, ':///some/' );

  var got = _.uriNew.common( 'file:///some/staging/index.html', 'file:///some/staging' );
  test.identical( got, 'file:///some/staging' );

  var got = _.uriNew.common( 'http://some', 'some/staging' );
  test.identical( got, '://some' );

  var got = _.uriNew.common( 'some/staging', 'http://some' );
  test.identical( got, '://some' );

  var got = _.uriNew.common( 'http://some.come/staging/index.html', 'some/staging' );
  test.identical( got, '://.' );

  var got = _.uriNew.common( 'http:///some.come/staging/index.html', '/some/staging' );
  test.identical( got, ':///' );

  var got = _.uriNew.common( 'http://some.come/staging/index.html', 'file://some/staging' );
  test.identical( got, '' );

  var got = _.uriNew.common( 'http:///some.come/staging/index.html', 'file:///some/staging' );
  test.identical( got, '' );

  var got = _.uriNew.common( 'http:///some.come/staging/index.html', 'http:///some/staging/file.html' );
  test.identical( got, 'http:///' );

  var got = _.uriNew.common( 'http://some.come/staging/index.html', 'http://some.come/some/staging/file.html' );
  test.identical( got, 'http://some.come/' );

  // xxx !!! : implement
  var got = _.uriNew.common( 'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor', 'complex+protocol://www.site.com:13/path' );
  test.identical( got, 'complex+protocol://www.site.com:13/path' );

  var got = _.uriNew.common( 'complex+protocol://www.site.com:13/path', 'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor' );
  test.identical( got, 'complex+protocol://www.site.com:13/path' );

  var got = _.uriNew.common( 'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor', 'complex+protocol://www.site.com:13/path?query=here' );
  test.identical( got, 'complex+protocol://www.site.com:13/path' );

  var got = _.uriNew.common( 'complex+protocol://www.site.com:13/path?query=here', 'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor' );
  test.identical( got, 'complex+protocol://www.site.com:13/path' );

  var got = _.uriNew.common( 'https://user:pass@sub.host.com:8080/p/a/t/h?query=string#hash', 'https://user:pass@sub.host.com:8080/p/a' );
  test.identical( got, 'https://user:pass@sub.host.com:8080/p/a' );

  var got = _.uriNew.common( '://some/staging/a/b/c', '://some/staging/a/b/c/index.html', '://some/staging/a/x' );
  test.identical( got, '://some/staging/a/' );

  var got = _.uriNew.common( 'http:///', 'http:///' );
  test.identical( got, 'http:///' );

  var got = _.uriNew.common( '/some/staging/a/b/c' );
  test.identical( got, '/some/staging/a/b/c' );

  test.case = 'combination of diff strcutures';

  var got = _.uriNew.common( [ 'http:///' ], [ 'http:///' ] )
  test.identical( got, 'http:///' );

  var got = _.uriNew.common( [ 'http:///x' ], [ 'http:///y' ] )
  test.identical( got, 'http:///' );

  var got = _.uriNew.common( [ 'http:///a/x' ], [ 'http:///a/y' ] )
  test.identical( got, 'http:///a/' );

  var got = _.uriNew.common( [ 'http:///a/x' ], 'http:///a/y' )
  test.identical( got, 'http:///a/' );

  var got = _.uriNew.common( 'http:///a/x', [ 'http:///a/y' ] )
  test.identical( got, 'http:///a/' );

  var got = _.uriNew.common( 'http:///a/x', 'http:///a/y' )
  test.identical( got, 'http:///a/' );

  var got = _.uriNew.common( [ [ 'http:///a/x' ], 'http:///a/y' ], 'http:///a/z' )
  test.identical( got, 'http:///a/' );

  /*
  var got = _.uriNew.common( 'http://some.come/staging/index.html', 'file:///some/staging' );
  var got = _.uriNew.common( 'http://some.come/staging/index.html', 'http:///some/staging/file.html' );

  */

  /* */

  if( !Config.debug )
  return

  test.shouldThrowErrorOfAnyKind( () => _.uriNew.common( 'http://some.come/staging/index.html', 'file:///some/staging' ) );
  test.shouldThrowErrorOfAnyKind( () => _.uriNew.common( 'http://some.come/staging/index.html', 'http:///some/staging/file.html' ) );
  // test.shouldThrowErrorOfAnyKind( () => _.uriNew.common([]) );
  // test.shouldThrowErrorOfAnyKind( () => _.uriNew.common() );
  // test.shouldThrowErrorOfAnyKind( () => _.uriNew.common( [ 'http:///' ], [ 'http:///' ] ) );
  // test.shouldThrowErrorOfAnyKind( () => _.uriNew.common( [ 'http:///' ], 'http:///' ) );

}

//

function commonMapsInArgs( test )
{

  test.case = 'array with paths';
  var src1 = _.uriNew.parseFull( '/a1/b2' );
  var src2 = _.uriNew.parse( '/a1/b' );
  var got = _.uriNew.common( [ src1, src2 ] );
  test.identical( got, '/a1/' );

  test.case = 'array with paths and path';
  var src1 = _.uriNew.parseFull( '/a1/b1/c' );
  var src2 = _.uriNew.parse( '/a1/b1/d' );
  var src3 = _.uriNew.parseAtomic( '/a1/b2' );
  var got = _.uriNew.common( [ src1, src2 ], src3 );
  test.identical( got, '/a1/' );

  test.case = 'equal protocols and local path';
  var src1 = _.uriNew.parse( 'npm:///wprocedure#0.3.19' );
  var src2 = _.uriNew.parse( 'npm:///wprocedure' );
  var got = _.uriNew.common( src1, src2 );
  test.identical( got, 'npm:///wprocedure' );

  test.case = 'equal protocols, local paths has anchor tags';
  var src1 = _.uriNew.parseAtomic( 'npm:///wprocedure#0.3.19' );
  var src2 = _.uriNew.parseAtomic( 'npm:///wprocedure#' );
  var got = _.uriNew.common( src1, src2 );
  test.identical( got, 'npm:///wprocedure' );

  test.case = 'equal complex protocols and local paths';
  var src1 = _.uriNew.parseConsecutive( 'git+https:///github.com/repo/wTools#bd9094b83' );
  var src2 = _.uriNew.parseConsecutive( 'git+https:///github.com/repo/wTools#master' );
  var got = _.uriNew.common( src1, src2 );
  test.identical( got, 'git+https:///github.com/repo/wTools' );

  test.case = 'without protocols, local paths is different';
  var src1 = _.uriNew.parseFull( '://a1/b2' );
  var src2 = _.uriNew.parseFull( '://some/staging/index.html' );
  var got = _.uriNew.common( src1, src2 );
  test.identical( got, '://.' );

  test.case = 'without protocols, local paths partly equal';
  var src1 = _.uriNew.parse( '://some/staging/index.html' );
  var src2 = _.uriNew.parseFull( '://some/staging/' );
  var got = _.uriNew.common( src1, src2 );
  test.identical( got, '://some/staging/' );

  test.case = 'without protocols, local paths partly equal, not full subpath';
  var src1 = _.uriNew.parseAtomic( '://some/staging/index.html' );
  var src2 = _.uriNew.parseFull( '://some/stagi' );
  var got = _.uriNew.common( src1, src2 );
  test.identical( got, '://some/' );

  test.case = 'local paths partly equal, not full subpath';
  var src1 = _.uriNew.parseConsecutive( 'file:///some/staging/index.html' );
  var src2 = _.uriNew.parseFull( ':///some/stagi' );
  var got = _.uriNew.common( src1, src2 );
  test.identical( got, ':///some/' );

  test.case = 'local paths partly equal, not full subpath';
  var src1 = _.uriNew.parse( 'file://some/staging/index.html' );
  var src2 = _.uriNew.parseFull( '://some/stagi' );
  var got = _.uriNew.common( src1, src2 );
  test.identical( got, '://some/' );

  test.case = 'local paths partly equal, not full subpath';
  var src1 = _.uriNew.parseConsecutive( 'file:///some/staging/index.html' );
  var src2 = _.uriNew.parseAtomic( '/some/stagi' );
  var got = _.uriNew.common( src1, src2 );
  test.identical( got, ':///some/' );

  test.case = 'equal protocols, local paths partly equal, not full subpath';
  var src1 = _.uriNew.parseFull( 'file:///some/staging/index.html' );
  var src2 = _.uriNew.parseConsecutive( 'file:///some/staging' );
  var got = _.uriNew.common( src1, src2 );
  test.identical( got, 'file:///some/staging' );

  test.case = 'path with protocol and without it, partly equal';
  var src1 = _.uriNew.parse( 'http://some' );
  var src2 = _.uriNew.parse( 'some/staging' );
  var got = _.uriNew.common( src1, src2 );
  test.identical( got, '://some' );

  test.case = 'path with protocol and without it, local paths is not equal';
  var src1 = _.uriNew.parse( 'http:///some.come/staging/index.html' );
  var src2 = _.uriNew.parseFull( '/some/staging' );
  var got = _.uriNew.common( src1, src2 );
  test.identical( got, ':///' );

  test.case = 'different protocols and local paths';
  var src1 = _.uriNew.parseFull( 'http://some.come/staging/index.html' );
  var src2 = _.uriNew.parseFull( 'file://some/staging' );
  var got = _.uriNew.common( src1, src2 );
  test.identical( got, '' );

  test.case = 'path with protocol and without it, local paths is not equal';
  var src1 = _.uriNew.parseConsecutive( 'http:///some.come/staging/index.html' );
  var src2 = _.uriNew.parse( 'file:///some/staging' );
  var got = _.uriNew.common( src1, src2 );
  test.identical( got, '' );

  test.case = 'the same protocols';
  var src1 = _.uriNew.parseAtomic( 'http:///some.come/staging/index.html' );
  var src2 = _.uriNew.parseConsecutive( 'http:///some/staging/file.html' );
  var got = _.uriNew.common( src1, src2 );
  test.identical( got, 'http:///' );

  test.case = 'path with equal protocols, begin of local paths is equal';
  var src1 = _.uriNew.parseFull( 'http://some.come/staging/index.html' );
  var src2 = _.uriNew.parse( 'http://some.come/some/staging/file.html' );
  var got = _.uriNew.common( src1, src2 );
  test.identical( got, 'http://some.come/' );

  test.case = 'one path has queries and anchor';
  var src1 = _.uriNew.parse( 'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor' );
  var src2 = _.uriNew.parseConsecutive( 'complex+protocol://www.site.com:13/path' );
  var got = _.uriNew.common( src1, src2 );
  test.identical( got, 'complex+protocol://www.site.com:13/path' );

  test.case = 'two paths has equal begin, second paths has not full query and anchor';
  var src1 = _.uriNew.parse( 'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor' );
  var src2 = _.uriNew.parseAtomic( 'complex+protocol://www.site.com:13/path?query=here' );
  var got = _.uriNew.common( src1, src2 );
  test.identical( got, 'complex+protocol://www.site.com:13/path' );

  test.case = 'paths with ports';
  var src1 = _.uriNew.parseFull( 'https://user:pass@sub.host.com:8080/p/a/t/h?query=string#hash' );
  var src2 = _.uriNew.parseAtomic( 'https://user:pass@sub.host.com:8080/p/a' );
  var got = _.uriNew.common( src1, src2 );
  test.identical( got, 'https://user:pass@sub.host.com:8080/p/a' );

  test.case = 'three paths';
  var src1 = _.uriNew.parse( '://some/staging/a/b/c' );
  var src2 = _.uriNew.parse( '://some/staging/a/b/c/index.html' );
  var got = _.uriNew.common( src1, src2, '://some/staging/a/x' );
  test.identical( got, '://some/staging/a/' );

  test.case = 'one map and one string path, only protocols';
  var src = _.uriNew.parseAtomic( 'http:///' );
  var got = _.uriNew.common( src, 'http:///' );
  test.identical( got, 'http:///' );

  test.case = 'one path';
  var src = _.uriNew.parse( '/some/staging/a/b/c' );
  var got = _.uriNew.common( src );
  test.identical( got, '/some/staging/a/b/c' );

  /* */

  test.case = 'string and map path in longs, only protocols';
  var src = _.uriNew.parse( 'http:///' );
  var got = _.uriNew.common( [ 'http:///' ], [ src ] )
  test.identical( got, 'http:///' );

  test.case = 'string and map path in longs, protocols and local paths';
  var src = _.uriNew.parseFull( 'http:///y' );
  var got = _.uriNew.common( [ 'http:///x' ], [ src ] )
  test.identical( got, 'http:///' );

  test.case = 'string and map path in longs, protocols and local paths, local paths partly equal';
  var src = _.uriNew.parseAtomic( 'http:///a/x' );
  var got = _.uriNew.common( [ src ], [ 'http:///a/y' ] )
  test.identical( got, 'http:///a/' );

  test.case = 'paths nested in few levels';
  var src = _.uriNew.parseConsecutive( 'http:///a/x' );
  var got = _.uriNew.common( [ [ [ src ] ] ], 'http:///a/y' )
}

//

function groupTextualReport( test )
{
  let defaults =
  {
    explanation : '',
    groupsMap : null,
    verbosity : 3,
    spentTime : null,
  }

  test.case = 'defaults';
  var got = _.uriNew.groupTextualReport( _.mapExtend( null, defaults ) );
  var expected = '0 file(s)';
  test.identical( got, expected );

  test.case = 'explanation only';
  var o =
  {
    explanation : '- Deleted '
  }
  var got = _.uriNew.groupTextualReport( _.mapExtend( null, defaults, o ) );
  var expected = '- Deleted 0 file(s)';
  test.identical( got, expected );

  test.case = 'spentTime only';
  var o =
  {
    spentTime : 5000
  }
  var got = _.uriNew.groupTextualReport( _.mapExtend( null, defaults, o ) );
  var expected = '0 file(s), in 5.000s';
  test.identical( got, expected );

  test.open( 'locals' )

  test.case = 'groupsMap only';
  var o =
  {
    groupsMap :
    {
      '/' : [ '/a', '/a/b', '/b', '/b/c' ],
      '/a' : [ '/a', '/a/b' ],
      '/b' : [ '/b', '/b/c' ]
    }
  }
  var got = _.uriNew.groupTextualReport( _.mapExtend( null, defaults, o ) );
  var expected =
  [
    '   4 at /',
    '   2 at ./a',
    '   2 at ./b',
    '4 file(s), at /'
  ].join( '\n' )
  test.identical( got, expected );

  test.case = 'explanation + groupsMap + spentTime, verbosity : 3';
  var o =
  {
    groupsMap :
    {
      '/' : [ '/a', '/a/b', '/b', '/b/c' ],
      '/a' : [ '/a', '/a/b' ],
      '/b' : [ '/b', '/b/c' ]
    },
    spentTime : 5000,
    explanation : '- Deleted ',
    verbosity : 3
  }
  var got = _.uriNew.groupTextualReport( _.mapExtend( null, defaults, o ) );
  var expected =
  [
    '   4 at /',
    '   2 at ./a',
    '   2 at ./b',
    '- Deleted 4 file(s), at /, in 5.000s'
  ].join( '\n' )
  test.identical( got, expected );

  test.case = 'explanation + groupsMap + spentTime, verbosity : 5';
  var o =
  {
    groupsMap :
    {
      '/' : [ '/a', '/a/b', '/b', '/b/c' ],
      '/a' : [ '/a', '/a/b' ],
      '/b' : [ '/b', '/b/c' ]
    },
    spentTime : 5000,
    explanation : '- Deleted ',
    verbosity : 5
  }
  debugger;
  var got = _.uriNew.groupTextualReport( _.mapExtend( null, defaults, o ) );
  var expected =
`
'/a'
'/a/b'
'/b'
'/b/c'
 4 at /
 2 at ./a
 2 at ./b
- Deleted 4 file(s), at /, in 5.000s
`
  test.equivalent( got, expected );
  debugger;

  test.case = 'relative, explanation + groupsMap + spentTime, verbosity : 5';
  var o =
  {
    groupsMap :
    {
      '/' : [ './a', './a/b', './b', './b/c' ],
      './a' : [ './a', './a/b' ],
      './b' : [ './b', './b/c' ]
    },
    spentTime : 5000,
    explanation : '- Deleted ',
    verbosity : 5
  }
  var got = _.uriNew.groupTextualReport( _.mapExtend( null, defaults, o ) );
  var expected =
  `
    './a'
    './a/b'
    './b'
    './b/c'
     4 at .
     2 at ./a
     2 at ./b
  - Deleted 4 file(s), at ., in 5.000s`
  test.equivalent( got, expected );

  test.close( 'locals' );

  /* */

  test.open( 'globals' );

  test.case = 'groupsMap only';
  var o =
  {
    groupsMap :
    {
      '/' : [ 'file:///a', 'file:///a/b', 'file:///b', 'file:///b/c' ],
      'file:///a' : [ 'file:///a', 'file:///a/b' ],
      'file:///b' : [ 'file:///b', 'file:///b/c' ]
    },
  }
  var got = _.uriNew.groupTextualReport( _.mapExtend( null, defaults, o ) );
  var expected =
  [
    '   4 at file:///',
    '   2 at ./a',
    '   2 at ./b',
    '4 file(s), at file:///'
  ].join( '\n' )
  test.equivalent( got, expected );

  test.case = 'explanation + groupsMap + spentTime, verbosity : 3';
  var o =
  {
    groupsMap :
    {
      '/' : [ 'file:///a', 'file:///a/b', 'file:///b', 'file:///b/c' ],
      'file:///a' : [ 'file:///a', 'file:///a/b' ],
      'file:///b' : [ 'file:///b', 'file:///b/c' ]
    },
    spentTime : 5000,
    explanation : '- Deleted ',
    verbosity : 3
  }
  var got = _.uriNew.groupTextualReport( _.mapExtend( null, defaults, o ) );
  var expected =
  [
    '   4 at file:///',
    '   2 at ./a',
    '   2 at ./b',
    '- Deleted 4 file(s), at file:///, in 5.000s'
  ].join( '\n' )
  test.equivalent( got, expected );

  test.case = 'explanation + groupsMap + spentTime, verbosity : 5';
  var o =
  {
    groupsMap :
    {
      '/' : [ 'file:///a', 'file:///a/b', 'file:///b', 'file:///b/c' ],
      'file:///a' : [ 'file:///a', 'file:///a/b' ],
      'file:///b' : [ 'file:///b', 'file:///b/c' ]
    },
    spentTime : 5000,
    explanation : '- Deleted ',
    verbosity : 5
  }
  var got = _.uriNew.groupTextualReport( _.mapExtend( null, defaults, o ) );
  var expected =
  `
    'file:///a'
    'file:///a/b'
    'file:///b'
    'file:///b/c'
     4 at file:///
     2 at ./a
     2 at ./b
  - Deleted 4 file(s), at file:///, in 5.000s
`
  test.equivalent( got, expected );

  test.case = 'relative, explanation + groupsMap + spentTime, verbosity : 5';
  var o =
  {
    groupsMap :
    {
      '/' : [ 'file://a', 'file://a/b', 'file://b', 'file://b/c' ],
      'file://a' : [ 'file://a', 'file://a/b' ],
      'file://b' : [ 'file://b', 'file://b/c' ]
    },
    spentTime : 5000,
    explanation : '- Deleted ',
    verbosity : 5
  }
  var got = _.uriNew.groupTextualReport( _.mapExtend( null, defaults, o ) );
  var expected =
  `
    'file://a'
    'file://a/b'
    'file://b'
    'file://b/c'
     4 at file://.
     2 at ./a
     2 at ./b
  - Deleted 4 file(s), at file://., in 5.000s
  `
  test.equivalent( got, expected );

  test.close( 'globals' );
}

//

function commonTextualReport( test )
{
  test.open( 'globals' )

  test.case = 'single string';
  var filePath = 'npm:///wprocedure#0.3.19';
  var got = _.uriNew.commonTextualReport( filePath );
  test.identical( got, filePath );

  test.case = 'empty array';
  var filePath = [];
  var expected = '()';
  var got = _.uriNew.commonTextualReport( filePath );
  test.identical( got, expected );

  test.case = 'single string in array';
  var filePath = [ 'npm:///wprocedure#0.3.19' ];
  var expected = filePath[ 0 ];
  var got = _.uriNew.commonTextualReport( filePath );
  test.identical( got, expected );

  test.case = 'two, same';
  var filePath = [ 'npm:///wprocedure#0.3.19', 'npm:///wprocedure#0.3.19' ];
  var expected = '( npm:///wprocedure#0.3.19 + [ . , . ] )';
  var got = _.uriNew.commonTextualReport( filePath );
  test.identical( got, expected );

  test.case = 'two, same protocol and path, diffent hash';
  var filePath = [ 'npm:///wprocedure#0.3.19', 'npm:///wprocedure#0.3.18' ];
  var expected = '( npm:///wprocedure + [ .#0.3.19 , .#0.3.18 ] )';
  var got = _.uriNew.commonTextualReport( filePath );
  test.identical( got, expected );

  test.case = 'two, different, common protocol and hash';
  var filePath = [ 'npm:///wprocedure#0.3.19', 'npm:///wfiles#0.3.19' ];
  var expected = '( npm:///#0.3.19 + [ wprocedure , wfiles ] )';
  var got = _.uriNew.commonTextualReport( filePath );
  test.identical( got, expected );

  test.case = 'two, different, common protocol';
  var filePath = [ 'npm:///wprocedure#0.3.19', 'npm:///wfiles#0.3.18' ];
  var expected = '( npm:/// + [ wprocedure#0.3.19 , wfiles#0.3.18 ] )';
  var got = _.uriNew.commonTextualReport( filePath );
  test.identical( got, expected );

  test.case = 'two, different, common protocol';
  var filePath = [ 'npm:///wprocedure', 'npm:///wfiles#0.3.18' ];
  var expected = '( npm:/// + [ wprocedure , wfiles#0.3.18 ] )';
  var got = _.uriNew.commonTextualReport( filePath );
  test.identical( got, expected );

  test.case = 'two, different';
  var filePath = [ 'npm:///wprocedure', 'file:///a/b/c' ];
  var expected = '[ npm:///wprocedure , file:///a/b/c ]';
  var got = _.uriNew.commonTextualReport( filePath );
  test.identical( got, expected );

  test.case = 'three, two have common protocol';
  var filePath = [ 'npm:///wprocedure', 'file:///a/b/c', 'npm:///wfiles' ];
  var expected = '[ npm:///wprocedure , file:///a/b/c , npm:///wfiles ]';
  var got = _.uriNew.commonTextualReport( filePath );
  test.identical( got, expected );

  test.case = 'two, part of path is diffent, common protocol';
  var filePath = [ 'file:///a/b/c', 'file:///a/x/c' ];
  var expected = '( file:///a/ + [ ./b/c , ./x/c ] )';
  var got = _.uriNew.commonTextualReport( filePath );
  test.identical( got, expected );

  test.case = 'two relatives, common protocol and part of path';
  var filePath = [ 'file://a/b/c', 'file://a/x/c' ];
  var expected = '( file://a/ + [ ./b/c , ./x/c ] )';
  var got = _.uriNew.commonTextualReport( filePath );
  test.identical( got, expected );

  test.case = 'two different relatives, common protocol';
  var filePath = [ 'file://a/b', 'file://c/d' ];
  var expected = '( file://. + [ a/b , c/d ] )';
  var got = _.uriNew.commonTextualReport( filePath );
  test.identical( got, expected );

  test.close( 'globals' );

  /* */

  test.open( 'locals' );

  test.case = 'single';
  var filePath = [ '/wprocedure#0.3.19' ];
  var expected = filePath[ 0 ];
  var got = _.uriNew.commonTextualReport( filePath );
  test.identical( got, expected );

  test.case = 'two, same';
  var filePath = [ '/wprocedure#0.3.19', '/wprocedure#0.3.19' ];
  var expected = '( /wprocedure#0.3.19 + [ . , . ] )';
  var got = _.uriNew.commonTextualReport( filePath );
  test.identical( got, expected );

  test.case = 'two, same protocol and path, diffent hash';
  var filePath = [ '/wprocedure#0.3.19', '/wprocedure#0.3.18' ];
  var expected = '( / + [ wprocedure#0.3.19 , wprocedure#0.3.18 ] )';
  var got = _.uriNew.commonTextualReport( filePath );
  test.identical( got, expected );

  test.case = 'two, different';
  var filePath = [ '/wprocedure#0.3.19', '/wfiles#0.3.19' ];
  var expected = '( / + [ wprocedure#0.3.19 , wfiles#0.3.19 ] )';
  var got = _.uriNew.commonTextualReport( filePath );
  test.identical( got, expected );

  test.case = 'two, different';
  var filePath = [ '/wprocedure#0.3.19', '/wfiles#0.3.18' ];
  var expected = '( / + [ wprocedure#0.3.19 , wfiles#0.3.18 ] )';
  var got = _.uriNew.commonTextualReport( filePath );
  test.identical( got, expected );

  test.case = 'two, different';
  var filePath = [ '/wprocedure', '/wfiles#0.3.18' ];
  var expected = '( / + [ wprocedure , wfiles#0.3.18 ] )';
  var got = _.uriNew.commonTextualReport( filePath );
  test.identical( got, expected );

  test.case = 'two, different';
  var filePath = [ '/wprocedure', '/a/b/c' ];
  var expected = '( / + [ wprocedure , a/b/c ] )';
  var got = _.uriNew.commonTextualReport( filePath );
  test.identical( got, expected );

  test.case = 'three, commot part of path';
  var filePath = [ '/wprocedure', '/a/b/c', '/wfiles' ];
  var expected = '( / + [ wprocedure , a/b/c , wfiles ] )'
  var got = _.uriNew.commonTextualReport( filePath );
  test.identical( got, expected );

  test.case = 'two, part of path is diffent';
  var filePath = [ '/a/b/c', '/a/x/c' ];
  var expected = '( /a/ + [ ./b/c , ./x/c ] )';
  var got = _.uriNew.commonTextualReport( filePath );
  test.identical( got, expected );

  test.case = 'two relatives, common part of path';
  var filePath = [ 'a/b/c', 'a/x/c' ];
  var expected = '( a/ + [ ./b/c , ./x/c ] )';
  var got = _.uriNew.commonTextualReport( filePath );
  test.identical( got, expected );

  test.case = 'two different relatives';
  var filePath = [ 'a/b', 'c/d' ];
  var expected = '[ a/b , c/d ]';
  var got = _.uriNew.commonTextualReport( filePath );
  test.identical( got, expected );

  test.close( 'locals' );

  /* */

  test.open( 'map' );

  test.case = 'single key';
  var filePath = { 'npm:///wprocedure#0.3.19' : 1 };
  var got = _.uriNew.commonTextualReport( filePath );
  test.identical( got, 'npm:///wprocedure#0.3.19' );

  test.case = 'empty map';
  var filePath = {};
  var expected = '()';
  var got = _.uriNew.commonTextualReport( filePath );
  test.identical( got, expected );


  test.case = 'two, same protocol and path, diffent hash';
  var filePath = { 'npm:///wprocedure#0.3.19' : 1, 'npm:///wprocedure#0.3.18' : 1 };
  var expected = '( npm:///wprocedure + [ .#0.3.19 , .#0.3.18 ] )';
  var got = _.uriNew.commonTextualReport( filePath );
  test.identical( got, expected );

  test.case = 'two, different, common protocol and hash';
  var filePath = { 'npm:///wprocedure#0.3.19' : 1, 'npm:///wfiles#0.3.19' : 1 };
  var expected = '( npm:///#0.3.19 + [ wprocedure , wfiles ] )';
  var got = _.uriNew.commonTextualReport( filePath );
  test.identical( got, expected );

  test.case = 'two, different, common protocol';
  var filePath = { 'npm:///wprocedure#0.3.19' : 1, 'npm:///wfiles#0.3.18' : 1 };
  var expected = '( npm:/// + [ wprocedure#0.3.19 , wfiles#0.3.18 ] )';
  var got = _.uriNew.commonTextualReport( filePath );
  test.identical( got, expected );

  test.case = 'two, different, common protocol';
  var filePath = { 'npm:///wprocedure' : 1, 'npm:///wfiles#0.3.18' : 1 };
  var expected = '( npm:/// + [ wprocedure , wfiles#0.3.18 ] )';
  var got = _.uriNew.commonTextualReport( filePath );
  test.identical( got, expected );

  test.case = 'two, different';
  var filePath = { 'npm:///wprocedure' : 1, 'file:///a/b/c' : 1 };
  var expected = '[ npm:///wprocedure , file:///a/b/c ]';
  var got = _.uriNew.commonTextualReport( filePath );
  test.identical( got, expected );

  test.case = 'three, two have common protocol';
  var filePath = { 'npm:///wprocedure' : 1, 'file:///a/b/c' : 1, 'npm:///wfiles' : 1 };
  var expected = '[ npm:///wprocedure , file:///a/b/c , npm:///wfiles ]';
  var got = _.uriNew.commonTextualReport( filePath );
  test.identical( got, expected );

  test.case = 'two, part of path is diffent, common protocol';
  var filePath = { 'file:///a/b/c' : 1, 'file:///a/x/c' : 1 };
  var expected = '( file:///a/ + [ ./b/c , ./x/c ] )';
  var got = _.uriNew.commonTextualReport( filePath );
  test.identical( got, expected );

  test.case = 'two relatives, common protocol and part of path';
  var filePath = { 'file://a/b/c' : 1, 'file://a/x/c' : 1 };
  var expected = '( file://a/ + [ ./b/c , ./x/c ] )';
  var got = _.uriNew.commonTextualReport( filePath );
  test.identical( got, expected );

  test.case = 'two different relatives, common protocol';
  var filePath = { 'file://a/b' : 1, 'file://c/d' : 1 };
  var expected = '( file://. + [ a/b , c/d ] )';
  var got = _.uriNew.commonTextualReport( filePath );
  test.identical( got, expected );

  test.close( 'map' );

  /* */

  test.case = 'with hash and query';
  var filePath = [ 'npm:///wprocedure?query=1#0.3.19', 'npm:///wprocedure?query=1#0.3.18' ];
  var expected = '( npm:///wprocedure?query=1 + [ .#0.3.19 , .#0.3.18 ] )';
  var got = _.uriNew.commonTextualReport( filePath );
  test.identical( got, expected );

  test.case = 'with hash and query';
  var filePath = [ 'npm:///wprocedure?query=2#0.3.19', 'npm:///wprocedure?query=1#0.3.19' ];
  var expected = '( npm:///wprocedure#0.3.19 + [ .?query=2 , .?query=1 ] )';
  var got = _.uriNew.commonTextualReport( filePath );
  test.identical( got, expected );

  test.case = 'with hash and query';
  var filePath = [ 'npm:///wprocedure?query=2#0.3.19', 'npm:///wprocedure?query=1#0.3.18' ];
  var expected = '( npm:///wprocedure + [ .?query=2#0.3.19 , .?query=1#0.3.18 ] )';
  var got = _.uriNew.commonTextualReport( filePath );
  test.identical( got, expected );

  test.case = 'with hash and query';
  var filePath = [ 'npm:///wprocedure?query=2#0.3.19', 'npm:///wfiles?query=1#0.3.18' ];
  var expected = '( npm:/// + [ wprocedure?query=2#0.3.19 , wfiles?query=1#0.3.18 ] )';
  var got = _.uriNew.commonTextualReport( filePath );
  test.identical( got, expected );

  test.case = 'with hash and query';
  var filePath = [ 'npm:///wprocedure?query=1#0.3.19', 'npm:///wfiles?query=1#0.3.19' ];
  var expected = '( npm:///?query=1#0.3.19 + [ wprocedure , wfiles ] )';
  var got = _.uriNew.commonTextualReport( filePath );
  test.identical( got, expected );

  test.case = 'with hash and query';
  var filePath = [ 'npm:///wprocedure?query=1#0.3.18', 'npm:///wfiles?query=1#0.3.19' ];
  var expected = '( npm:///?query=1 + [ wprocedure#0.3.18 , wfiles#0.3.19 ] )';
  var got = _.uriNew.commonTextualReport( filePath );
  test.identical( got, expected );

  if( !Config.debug )
  return

  test.shouldThrowErrorSync( () => _.uriNew.commonTextualReport( null ) )
  test.shouldThrowErrorSync( () => _.uriNew.commonTextualReport([ 'npm:///wprocedure#0.3.19', null ]) )
  test.shouldThrowErrorSync( () => _.uriNew.commonTextualReport([ 'file:///a/b', 'file://c/d'  ]) )
}

//

function moveTextualReport( test )
{

  test.open( 'globals' );
  test.case = 'same';
  var expected = 'npm:///wprocedure#0.3.19 : . <- .';
  var dst = 'npm:///wprocedure#0.3.19';
  var src = 'npm:///wprocedure#0.3.19';
  var got = _.uriNew.moveTextualReport( dst, src );
  test.identical( _.ct.strip( got ), expected );

  test.case = 'dst with hash, src without hash';
  var expected = 'npm:///wprocedure : .#0.3.19 <- .';
  var dst = 'npm:///wprocedure#0.3.19';
  var src = 'npm:///wprocedure';
  var got = _.uriNew.moveTextualReport( dst, src );
  test.identical( _.ct.strip( got ), expected );

  test.case = 'dst without hash, src with hash';
  var expected = 'npm:///wprocedure : . <- .#0.3.19';
  var dst = 'npm:///wprocedure';
  var src = 'npm:///wprocedure#0.3.19';
  var got = _.uriNew.moveTextualReport( dst, src );
  test.identical( _.ct.strip( got ), expected );

  test.case = 'dst with hash, src with hash';
  var expected = 'npm:///wprocedure : .#0.3.20 <- .#0.3.19';
  var dst = 'npm:///wprocedure#0.3.20';
  var src = 'npm:///wprocedure#0.3.19';
  var got = _.uriNew.moveTextualReport( dst, src );
  test.identical( _.ct.strip( got ), expected );

  test.case = 'dst without hash, src without hash';
  var expected = 'npm:///wprocedure : . <- .';
  var dst = 'npm:///wprocedure';
  var src = 'npm:///wprocedure';
  var got = _.uriNew.moveTextualReport( dst, src );
  test.identical( _.ct.strip( got ), expected );

  test.case = 'common protocol, different paths';
  var expected = 'npm:/// : wprocedure <- wfiles';
  var dst = 'npm:///wprocedure';
  var src = 'npm:///wfiles';
  var got = _.uriNew.moveTextualReport( dst, src );
  test.identical( _.ct.strip( got ), expected );

  test.case = 'different paths';
  var expected = 'npm1:///wprocedure <- npm2:///wfiles';
  var dst = 'npm1:///wprocedure';
  var src = 'npm2:///wfiles';
  var got = _.uriNew.moveTextualReport( dst, src );
  test.identical( _.ct.strip( got ), expected );

  test.case = 'dst relative, src relative, with common';
  var expected = 'npm://. : wprocedure <- wfiles';
  var dst = 'npm://wprocedure';
  var src = 'npm://wfiles';
  var got = _.uriNew.moveTextualReport( dst, src );
  test.identical( _.ct.strip( got ), expected );

  test.case = 'dst relative, src relative, same';
  var expected = 'npm://wfiles : . <- .';
  var dst = 'npm://wfiles';
  var src = 'npm://wfiles';
  var got = _.uriNew.moveTextualReport( dst, src );
  test.identical( _.ct.strip( got ), expected );

  test.case = 'dst relative with hash, src relative with hash, same';
  var expected = 'npm://wprocedure#0.3.20 : . <- .';
  var dst = 'npm://wprocedure#0.3.20';
  var src = 'npm://wprocedure#0.3.20';
  var got = _.uriNew.moveTextualReport( dst, src );
  test.identical( _.ct.strip( got ), expected );

  test.case = 'dst relative with hash, src relative with hash, with common';
  var expected = 'npm://wprocedure : .#0.3.20 <- .#0.3.19';
  var dst = 'npm://wprocedure#0.3.20';
  var src = 'npm://wprocedure#0.3.19';
  var got = _.uriNew.moveTextualReport( dst, src );
  test.identical( _.ct.strip( got ), expected );

  test.case = 'dst relative, src relative, with common';
  var expected = 'npm://. : b/dst <- a/src';
  var dst = 'npm://b/dst';
  var src = 'npm://a/src';
  var got = _.uriNew.moveTextualReport( dst, src );
  test.identical( _.ct.strip( got ), expected );

  test.case = 'dst relative, src relative, with common';
  var expected = 'npm://a/ : ./dst <- ./src';
  var dst = 'npm://a/dst';
  var src = 'npm://a/src';
  var got = _.uriNew.moveTextualReport( dst, src );
  test.identical( _.ct.strip( got ), expected );

  test.close( 'globals' );

  /* */

  test.open( 'locals' );

  test.case = 'same, absolute';
  var expected = '/a : . <- .';
  var dst = '/a';
  var src = '/a';
  var got = _.uriNew.moveTextualReport( dst, src );
  test.identical( _.ct.strip( got ), expected );

  test.case = 'different, absolute, with common';
  var expected = '/a/ : ./dst <- ./src';
  var dst = '/a/dst';
  var src = '/a/src';
  var got = _.uriNew.moveTextualReport( dst, src );
  test.identical( _.ct.strip( got ), expected );

  test.case = 'different, absolute, without common';
  var expected = '/b/dst <- /a/src';
  var dst = '/b/dst';
  var src = '/a/src';
  var got = _.uriNew.moveTextualReport( dst, src );
  test.identical( _.ct.strip( got ), expected );

  test.case = 'same, relative';
  var expected = 'a/src : . <- .';
  var dst = 'a/src';
  var src = 'a/src';
  var got = _.uriNew.moveTextualReport( dst, src );
  test.identical( _.ct.strip( got ), expected );

  test.case = 'different, relative, with common';
  var expected = 'a/ : ./dst <- ./src';
  var dst = 'a/dst';
  var src = 'a/src';
  var got = _.uriNew.moveTextualReport( dst, src );
  test.identical( _.ct.strip( got ), expected );

  test.case = 'different, relative, without common';
  var expected = 'b/dst <- a/src';
  var dst = 'b/dst';
  var src = 'a/src';
  var got = _.uriNew.moveTextualReport( dst, src );
  test.identical( _.ct.strip( got ), expected );

  test.case = 'same, relative dotted';
  var expected = 'a/src : . <- .';
  var dst = './a/src';
  var src = './a/src';
  var got = _.uriNew.moveTextualReport( dst, src );
  test.identical( _.ct.strip( got ), expected );

  test.case = 'different, relative dotted, with common';
  var expected = 'a/ : ./dst <- ./src';
  var dst = './a/dst';
  var src = './a/src';
  var got = _.uriNew.moveTextualReport( dst, src );
  test.identical( _.ct.strip( got ), expected );

  test.case = 'different, relative dotted, without common';
  var expected = './b/dst <- ./a/src';
  var dst = './b/dst';
  var src = './a/src';
  var got = _.uriNew.moveTextualReport( dst, src );
  test.identical( _.ct.strip( got ), expected );

  test.close( 'locals' );

  test.open( 'null' );

  test.case = 'both null';
  var expected = '{null} : . <- .';
  var dst = null;
  var src = null;
  var got = _.uriNew.moveTextualReport( dst, src );
  test.identical( _.ct.strip( got ), expected );

  test.case = 'dst global, src null';
  var expected = ':/// : npm://wprocedure#0.3.19 <- {null}';
  var dst = 'npm:///wprocedure#0.3.19';
  var src = null;
  var got = _.uriNew.moveTextualReport( dst, src );
  test.identical( _.ct.strip( got ), expected );

  test.case = 'dst null, src global';
  var expected = ':/// : {null} <- npm://wprocedure#0.3.19';
  var src = 'npm:///wprocedure#0.3.19';
  var dst = null;
  var got = _.uriNew.moveTextualReport( dst, src );
  test.identical( _.ct.strip( got ), expected );

  test.case = 'dst relative, src null';
  var expected = './a/dst <- {null}';
  var dst = './a/dst';
  var src = null;
  var got = _.uriNew.moveTextualReport( dst, src );
  test.identical( _.ct.strip( got ), expected );

  test.case = 'src relative, dst null';
  var expected = '{null} <- ./a/src';
  var src = './a/src';
  var dst = null;
  var got = _.uriNew.moveTextualReport( dst, src );
  test.identical( _.ct.strip( got ), expected );

  test.case = 'src absolute, dst null';
  var expected = '/{null} <- /a/src';
  var src = '/a/src';
  var dst = null;
  var got = _.uriNew.moveTextualReport( dst, src );
  test.identical( _.ct.strip( got ), expected );

  test.case = 'dst absolute, src null';
  var expected = '/a/dst <- /{null}';
  var dst = '/a/dst';
  var src = null;
  var got = _.uriNew.moveTextualReport( dst, src );
  test.identical( _.ct.strip( got ), expected );

  test.close( 'null' );


}

//

function resolve( test )
{

  var originalPath = _.path.current();
  var current = originalPath;

  if( _.fileProvider )
  {
    _.path.current( '/' );
    current = _.strPrependOnce( _.uriNew.current(),  '/' );
  }

  try
  {

    test.open( 'with protocol' );

    var got = _.uriNew.resolve( 'http://www.site.com:13', 'a' );
    test.identical( got, _.uriNew.join( current, 'http://www.site.com:13/a' ) );

    var got = _.uriNew.resolve( 'http://www.site.com:13/', 'a' );
    test.identical( got, _.uriNew.join( current, 'http://www.site.com:13/a' ) );

    var got = _.uriNew.resolve( 'http://www.site.com:13/', 'a', 'b' );
    test.identical( got, _.uriNew.join( current, 'http://www.site.com:13/a/b' ) );

    var got = _.uriNew.resolve( 'http://www.site.com:13', 'a', '/b' );
    test.identical( got, _.uriNew.join( current, 'http:///b' ) );

    var got = _.uriNew.resolve( 'http://www.site.com:13/', 'a', 'b', '.' );
    test.identical( got, _.uriNew.join( current, 'http://www.site.com:13/a/b' ) );

    var got = _.uriNew.resolve( 'http://www.site.com:13', 'a', '/b', 'c' );
    test.identical( got, _.uriNew.join( current, 'http:///b/c' ) );

    var got = _.uriNew.resolve( 'http://www.site.com:13', '/a/', '/b/', 'c/', '.' );
    test.identical( got, _.uriNew.join( current, 'http:///b/c' ) );

    var got = _.uriNew.resolve( 'http://www.site.com:13', 'a', '.', 'b' );
    test.identical( got, _.uriNew.join( current, 'http://www.site.com:13/a/b' ) );

    var got = _.uriNew.resolve( 'http://www.site.com:13/', 'a', '.', 'b' );
    test.identical( got, _.uriNew.join( current, 'http://www.site.com:13/a/b' ) );

    var got = _.uriNew.resolve( 'http://www.site.com:13', 'a', '..', 'b' );
    test.identical( got, _.uriNew.join( current, 'http://www.site.com:13/b' ) );

    var got = _.uriNew.resolve( 'http://www.site.com:13', 'a', '..', '..', 'b' );
    test.identical( got, _.uriNew.join( current, 'http://b' ) );

    var got = _.uriNew.resolve( 'http://www.site.com:13', '.a.', 'b', '.c.' );
    test.identical( got, _.uriNew.join( current, 'http://www.site.com:13/.a./b/.c.' ) );

    var got = _.uriNew.resolve( 'http://www.site.com:13', 'a/../' );
    test.identical( got, _.uriNew.join( current, 'http://www.site.com:13/' ) );

    test.close( 'with protocol' );

    /* - */

    test.open( 'with null protocol' );

    var got = _.uriNew.resolve( '://www.site.com:13', 'a' );
    test.identical( got, _.uriNew.join( current, '://www.site.com:13/a' ) );

    var got = _.uriNew.resolve( '://www.site.com:13', 'a', '/b' );
    test.identical( got, _.uriNew.join( current, ':///b' ) );

    var got = _.uriNew.resolve( '://www.site.com:13', 'a', '/b', 'c' );
    test.identical( got, _.uriNew.join( current, ':///b/c' ) );

    var got = _.uriNew.resolve( '://www.site.com:13', '/a/', '/b/', 'c/', '.' );
    test.identical( got, _.uriNew.join( current, ':///b/c' ) );

    var got = _.uriNew.resolve( '://www.site.com:13', 'a', '.', 'b' );
    test.identical( got, _.uriNew.join( current, '://www.site.com:13/a/b' ) );

    var got = _.uriNew.resolve( '://www.site.com:13', 'a', '..', 'b' );
    test.identical( got, _.uriNew.join( current, '://www.site.com:13/b' ) );

    var got = _.uriNew.resolve( '://www.site.com:13', 'a', '..', '..', 'b' );
    test.identical( got, _.uriNew.join( current, '://b' ) );

    var got = _.uriNew.resolve( '://www.site.com:13', '.a.', 'b', '.c.' );
    test.identical( got, _.uriNew.join( current, '://www.site.com:13/.a./b/.c.' ) );

    var got = _.uriNew.resolve( '://www.site.com:13', 'a/../' );
    test.identical( got, _.uriNew.join( current, '://www.site.com:13/' ) );

    test.close( 'with null protocol' );

    /* */

    var got = _.uriNew.resolve( ':///www.site.com:13', 'a' );
    test.identical( got, ':///www.site.com:13/a' );

    var got = _.uriNew.resolve( ':///www.site.com:13/', 'a' );
    test.identical( got, ':///www.site.com:13/a' );

    var got = _.uriNew.resolve( ':///www.site.com:13', 'a', '/b' );
    test.identical( got, ':///b' );

    var got = _.uriNew.resolve( ':///www.site.com:13', 'a', '/b', 'c' );
    test.identical( got, ':///b/c' );

    var got = _.uriNew.resolve( ':///www.site.com:13', '/a/', '/b/', 'c/', '.' );
    test.identical( got, ':///b/c' );

    var got = _.uriNew.resolve( ':///www.site.com:13', 'a', '.', 'b' );
    test.identical( got, ':///www.site.com:13/a/b' );

    var got = _.uriNew.resolve( ':///www.site.com:13/', 'a', '.', 'b' );
    test.identical( got, ':///www.site.com:13/a/b' );

    var got = _.uriNew.resolve( ':///www.site.com:13', 'a', '..', 'b' );
    test.identical( got, ':///www.site.com:13/b' );

    var got = _.uriNew.resolve( ':///www.site.com:13', 'a', '..', '..', 'b' );
    test.identical( got, ':///b' );

    var got = _.uriNew.resolve( ':///www.site.com:13', '.a.', 'b', '.c.' );
    test.identical( got, ':///www.site.com:13/.a./b/.c.' );

    var got = _.uriNew.resolve( ':///www.site.com:13/', '.a.', 'b', '.c.' );
    test.identical( got, ':///www.site.com:13/.a./b/.c.' );

    var got = _.uriNew.resolve( ':///www.site.com:13', 'a/../' );
    test.identical( got, ':///www.site.com:13/' );

    var got = _.uriNew.resolve( ':///www.site.com:13/', 'a/../' );
    test.identical( got, ':///www.site.com:13/' );

    /* */

    var got = _.uriNew.resolve( '/some/staging/index.html', 'a' );
    test.identical( got, '/some/staging/index.html/a' );

    var got = _.uriNew.resolve( '/some/staging/index.html', '.' );
    test.identical( got, '/some/staging/index.html' );

    var got = _.uriNew.resolve( '/some/staging/index.html/', 'a' );
    test.identical( got, '/some/staging/index.html/a' );

    var got = _.uriNew.resolve( '/some/staging/index.html', 'a', '/b' );
    test.identical( got, '/b' );

    var got = _.uriNew.resolve( '/some/staging/index.html', 'a', '/b', 'c' );
    test.identical( got, '/b/c' );

    var got = _.uriNew.resolve( '/some/staging/index.html', '/a/', '/b/', 'c/', '.' );
    test.identical( got, '/b/c' );

    var got = _.uriNew.resolve( '/some/staging/index.html', 'a', '.', 'b' );
    test.identical( got, '/some/staging/index.html/a/b' );

    var got = _.uriNew.resolve( '/some/staging/index.html/', 'a', '.', 'b' );
    test.identical( got, '/some/staging/index.html/a/b' );

    var got = _.uriNew.resolve( '/some/staging/index.html', 'a', '..', 'b' );
    test.identical( got, '/some/staging/index.html/b' );

    var got = _.uriNew.resolve( '/some/staging/index.html', 'a', '..', '..', 'b' );
    test.identical( got, '/some/staging/b' );

    var got = _.uriNew.resolve( '/some/staging/index.html', '.a.', 'b', '.c.' );
    test.identical( got, '/some/staging/index.html/.a./b/.c.' );

    var got = _.uriNew.resolve( '/some/staging/index.html/', '.a.', 'b', '.c.' );
    test.identical( got, '/some/staging/index.html/.a./b/.c.' );

    var got = _.uriNew.resolve( '/some/staging/index.html', 'a/../' );
    test.identical( got, '/some/staging/index.html/' );

    var got = _.uriNew.resolve( '/some/staging/index.html/', 'a/../' );
    test.identical( got, '/some/staging/index.html/' );

    var got = _.uriNew.resolve( '//some/staging/index.html', '.', 'a' );
    test.identical( got, '//some/staging/index.html/a' )

    var got = _.uriNew.resolve( '///some/staging/index.html', 'a', '.', 'b', '..' );
    test.identical( got, '///some/staging/index.html/a' )

    var got = _.uriNew.resolve( 'file:///some/staging/index.html', '../..' );
    test.identical( got, 'file:///some' )

    var got = _.uriNew.resolve( 'svn+https://user@subversion.com/svn/trunk', '../a', 'b', '../c' );
    test.identical( got, _.uriNew.join( current, 'svn+https://user@subversion.com/svn/a/c' ) );

    var got = _.uriNew.resolve( 'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor', '../../path/name' );
    test.identical( got, _.uriNew.join( current, 'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor' ) );

    var got = _.uriNew.resolve( 'https://web.archive.org/web/*/http://www.heritage.org/index/ranking', '../../../a.com' );
    test.identical( got, _.uriNew.join( current, 'https://web.archive.org/web/*/http://a.com' ) );

    var got = _.uriNew.resolve( '127.0.0.1:61726', '../path'  );
    test.identical( got, _.uriNew.join( _.uriNew.current(),  'path' ) )

    var got = _.uriNew.resolve( 'http://127.0.0.1:61726', '../path'  );
    test.identical( got, _.uriNew.join( current, 'http://path' ) );

    /* */

    test.case = 'works like resolve';

    var paths = [ 'c:\\', 'foo\\', 'bar\\' ];
    var expected = '/c/foo/bar/';
    var got = _.uriNew.resolve.apply( _.uriNew, paths );
    test.identical( got, expected );

    var paths = [ '/bar/', '/baz', 'foo/', '.' ];
    var expected = '/baz/foo';
    var got = _.uriNew.resolve.apply( _.uriNew, paths );
    test.identical( got, expected );

    var paths = [  'aa', '.', 'cc' ];
    var expected = _.uriNew.join( _.uriNew.current(), 'aa/cc' );
    var got = _.uriNew.resolve.apply( _.uriNew, paths );
    test.identical( got, expected );

    var paths = [  'aa', 'cc', '.' ];
    var expected = _.uriNew.join( _.uriNew.current(), 'aa/cc' )
    var got = _.uriNew.resolve.apply( _.uriNew, paths );
    test.identical( got, expected );

    var paths = [  '.', 'aa', 'cc' ];
    var expected = _.uriNew.join( _.uriNew.current(), 'aa/cc' )
    var got = _.uriNew.resolve.apply( _.uriNew, paths );
    test.identical( got, expected );

    var paths = [  '.', 'aa', 'cc', '..' ];
    var expected = _.uriNew.join( _.uriNew.current(), 'aa' )
    var got = _.uriNew.resolve.apply( _.uriNew, paths );
    test.identical( got, expected );

    var paths = [  '.', 'aa', 'cc', '..', '..' ];
    var expected = _.uriNew.current();
    var got = _.uriNew.resolve.apply( _.uriNew, paths );
    test.identical( got, expected );

    var paths = [  'aa', 'cc', '..', '..', '..' ];
    var expected = _.uriNew.resolve( _.uriNew.current(), '..' );
    var got = _.uriNew.resolve.apply( _.uriNew, paths );
    test.identical( got, expected );

    var paths = [  '.x.', 'aa', 'bb', '.x.' ];
    var expected = _.uriNew.join( _.uriNew.current(), '.x./aa/bb/.x.' );
    var got = _.uriNew.resolve.apply( _.uriNew, paths );
    test.identical( got, expected );

    var paths = [  '..x..', 'aa', 'bb', '..x..' ];
    var expected = _.uriNew.join( _.uriNew.current(), '..x../aa/bb/..x..' );
    var got = _.uriNew.resolve.apply( _.uriNew, paths );
    test.identical( got, expected );

    var paths = [  '/abc', './../a/b' ];
    var expected = '/a/b';
    var got = _.uriNew.resolve.apply( _.uriNew, paths );
    test.identical( got, expected );

    var paths = [  '/abc', 'a/.././a/b' ];
    var expected = '/abc/a/b';
    var got = _.uriNew.resolve.apply( _.uriNew, paths );
    test.identical( got, expected );

    var paths = [  '/abc', '.././a/b' ];
    var expected = '/a/b';
    var got = _.uriNew.resolve.apply( _.uriNew, paths );
    test.identical( got, expected );

    var paths = [  '/abc', './.././a/b' ];
    var expected = '/a/b';
    var got = _.uriNew.resolve.apply( _.uriNew, paths );
    test.identical( got, expected );

    var paths = [  '/abc', './../.' ];
    var expected = '/';
    var got = _.uriNew.resolve.apply( _.uriNew, paths );
    test.identical( got, expected );

    var paths = [  '/abc', './../../.' ];
    var expected = '/..';
    var got = _.uriNew.resolve.apply( _.uriNew, paths );
    test.identical( got, expected );

    var paths = [  '/abc', './../.' ];
    var expected = '/';
    var got = _.uriNew.resolve.apply( _.uriNew, paths );
    test.identical( got, expected );

    var paths = [ null ];
    // var expected = _.uriNew.current();
    var expected = null;
    // debugger;
    var got = _.uriNew.resolve.apply( _.uriNew, paths );
    // debugger;
    test.identical( got, expected );

    /* - */

    if( _.fileProvider )
    _.uriNew.current( originalPath );

  }
  catch( err )
  {

    if( _.fileProvider )
    _.uriNew.current( originalPath );
    throw err;
  }

}

//

function rebase( test )
{

  test.case = 'replacing by empty protocol';

  var expected = ':///some2/file'; /* not src:///some2/file */
  var got = _.uriNew.rebase( 'src:///some/file', '/some', ':///some2' );
  test.identical( got, expected );

  test.case = 'removing protocol';

  var expected = '/some2/file';
  var got = _.uriNew.rebase( 'src:///some/file', 'src:///some', '/some2' );
  test.identical( got, expected );

  var expected = '/some2/file';
  var got = _.uriNew.rebase( 'src:///some/file', 'dst:///some', '/some2' );
  test.identical( got, expected );

}

//
/*
qqq : improve style, remove array of expected values and array of inputs | Dmytro : improved
 */

function name( test )
{
  test.case = 'empty path, without ext';
  var src = '';
  var got = _.uriNew.name( src );
  var exp = '';
  test.identical( got, exp );

  test.case = 'empty path, with ext';
  var src = '';
  var got = _.uriNew.name( { path : src, full : 1 } );
  var exp = '';
  test.identical( got, exp );

  /* */

  test.case = 'filename, without ext';
  var src = 'some.txt';
  var got = _.uriNew.name( src );
  var exp = 'some';
  test.identical( got, exp );

  test.case = 'filename, with ext';
  var src = 'some.txt';
  var got = _.uriNew.name( { path : src, full : 1 } );
  var exp = 'some.txt';
  test.identical( got, exp );

  /* */

  test.case = 'absolute path to file, without ext';
  var src = '/foo/bar/baz.asdf';
  var got = _.uriNew.name( src );
  var exp = 'baz';
  test.identical( got, exp );

  test.case = 'absolute path to file, with ext';
  var src = '/foo/bar/baz.asdf';
  var got = _.uriNew.name( { path : src, full : 1 } );
  var exp = 'baz.asdf';
  test.identical( got, exp );

  /* */

  test.case = 'absolute path to hidden file, without ext';
  var src = '/foo/bar/.baz';
  var got = _.uriNew.name( src );
  var exp = '';
  test.identical( got, exp );

  test.case = 'absolute path to hidden file, with ext';
  var src = '/foo/bar/.baz';
  var got = _.uriNew.name( { path : src, full : 1 } );
  var exp = '.baz';
  test.identical( got, exp );

  /* */

  test.case = 'absolute path to file with complex extention, without ext';
  var src = '/foo.coffee.md';
  var got = _.uriNew.name( src );
  var exp = 'foo.coffee';
  test.identical( got, exp );

  test.case = 'absolute path to file with complex extention, with ext';
  var src = '/foo.coffee.md';
  var got = _.uriNew.name( { path : src, full : 1 } );
  var exp = 'foo.coffee.md';
  test.identical( got, exp );

  /* */

  test.case = 'absolute path to file without extention, without ext';
  var src = '/foo/bar/baz';
  var got = _.uriNew.name( src );
  var exp = 'baz';
  test.identical( got, exp );

  test.case = 'absolute path to file without extention, with ext';
  var src = '/foo/bar/baz';
  var got = _.uriNew.name( { path : src, full : 1 } );
  var exp = 'baz';
  test.identical( got, exp );

  /* */

  test.case = 'absolute path to file, one slash, without ext';
  var src = '/some/staging/index.html';
  var got = _.uriNew.name( src );
  var exp = 'index';
  test.identical( got, exp );

  test.case = 'absolute path to file, one slash, with ext';
  var src = '/some/staging/index.html';
  var got = _.uriNew.name( { path : src, full : 1 } );
  var exp = 'index.html';
  test.identical( got, exp );

  /* */

  test.case = 'absolute path to file, two slashes, without ext';
  var src = '//some/staging/index.html';
  var got = _.uriNew.name( src );
  var exp = 'index';
  test.identical( got, exp );

  test.case = 'absolute path to file, two slashes, with ext';
  var src = '//some/staging/index.html';
  var got = _.uriNew.name( { path : src, full : 1 } );
  var exp = 'index.html';
  test.identical( got, exp );

  /* */

  test.case = 'absolute path to file, three slashes, without ext';
  var src = '///some/staging/index.html';
  var got = _.uriNew.name( src );
  var exp = 'index';
  test.identical( got, exp );

  test.case = 'absolute path to file, three slashes, with ext';
  var src = '///some/staging/index.html';
  var got = _.uriNew.name( { path : src, full : 1 } );
  var exp = 'index.html';
  test.identical( got, exp );

  /* */

  test.case = 'hard drive path to file, without ext';
  var src = 'file:///some/staging/index.html';
  var got = _.uriNew.name( src );
  var exp = 'index';
  test.identical( got, exp );

  test.case = 'hard drive path to file, with ext';
  var src = 'file:///some/staging/index.html';
  var got = _.uriNew.name( { path : src, full : 1 } );
  var exp = 'index.html';
  test.identical( got, exp );

  /* */

  test.case = 'http path to file, without ext';
  var src = 'http://some.come/staging/index.html';
  var got = _.uriNew.name( src );
  var exp = 'index';
  test.identical( got, exp );

  test.case = 'http path to file, with ext';
  var src = 'http://some.come/staging/index.html';
  var got = _.uriNew.name( { path : src, full : 1 } );
  var exp = 'index.html';
  test.identical( got, exp );

  /* */

  test.case = 'svn+https path to file, without ext';
  var src = 'svn+https://user@subversion.com/svn/trunk/index.html';
  var got = _.uriNew.name( src );
  var exp = 'index';
  test.identical( got, exp );

  test.case = 'svn+https path to file, with ext';
  var src = 'svn+https://user@subversion.com/svn/trunk/index.html';
  var got = _.uriNew.name( { path : src, full : 1 } );
  var exp = 'index.html';
  test.identical( got, exp );

  /* */

  test.case = 'complex+protocol path to file, without ext';
  var src = 'complex+protocol://www.site.com:13/path/name.html?query=here&and=here#anchor';
  var got = _.uriNew.name( src );
  var exp = 'name';
  test.identical( got, exp );

  test.case = 'complex+protocol path to file, with ext';
  var src = 'complex+protocol://www.site.com:13/path/name.html?query=here&and=here#anchor';
  var got = _.uriNew.name( { path : src, full : 1 } );
  var exp = 'name.html';
  test.identical( got, exp );

  /* */

  test.case = 'complex path to file with parameters, without ext';
  var src = '://www.site.com:13/path/name.html?query=here&and=here#anchor';
  var got = _.uriNew.name( src );
  var exp = 'name';
  test.identical( got, exp );

  test.case = 'complex path to file with parameters, with ext';
  var src = '://www.site.com:13/path/name.html?query=here&and=here#anchor';
  var got = _.uriNew.name( { path : src, full : 1 } );
  var exp = 'name.html';
  test.identical( got, exp );

  /* */

  test.case = 'complex path to file with parameters, without ext';
  var src = ':///www.site.com:13/path/name.html?query=here&and=here#anchor';
  var got = _.uriNew.name( src );
  var exp = 'name';
  test.identical( got, exp );

  test.case = 'complex path to file with parameters, with ext';
  var src = ':///www.site.com:13/path/name.html?query=here&and=here#anchor';
  var got = _.uriNew.name( { path : src, full : 1 } );
  var exp = 'name.html';
  test.identical( got, exp );

  /* */

  test.case = 'uri filePath file';
  var src = 'http://www.site.com:13/path/name.txt'
  var got = _.uriNew.name( src );
  var expected = 'name';
  test.identical( got, expected );

  test.case = 'uri with params';
  var src = 'http://www.site.com:13/path/name?query=here&and=here#anchor';
  var got = _.uriNew.name( src );
  var expected = 'name';
  test.identical( got, expected );

  test.case = 'uri without protocol';
  var src = '://www.site.com:13/path/name.js';
  var got = _.uriNew.name( src );
  var expected = 'name';
  test.identical( got, expected );

  /* - */

  if( !Config.debug )
  return;

  test.case = 'passed argument is non string';
  test.shouldThrowErrorSync( () => _.uriNew.name( false ) );
}

//

function ext( test )
{
  test.case = 'empty path';
  var src = '';
  var got = _.uriNew.ext( src );
  var exp = '';
  test.identical( got, exp );

  test.case = 'filename';
  var src = 'some.txt';
  var got = _.uriNew.ext( src );
  var exp = 'txt';
  test.identical( got, exp );

  test.case = 'absolute path to file';
  var src = '/foo/bar/baz.asdf';
  var got = _.uriNew.ext( src );
  var exp = 'asdf';
  test.identical( got, exp );

  test.case = 'absolute path to hidden file';
  var src = '/foo/bar/.baz';
  var got = _.uriNew.ext( src );
  var exp = '';
  test.identical( got, exp );

  test.case = 'absolute path to hidden file';
  var src = '/foo/bar/.baz';
  var got = _.uriNew.ext( src );
  var exp = '';
  test.identical( got, exp );

  test.case = 'absolute path to file with complex extention';
  var src = '/foo.coffee.md';
  var got = _.uriNew.ext( src );
  var exp = 'md';
  test.identical( got, exp );

  test.case = 'absolute path to file without extention';
  var src = '/foo/bar/baz';
  var got = _.uriNew.ext( src );
  var exp = '';
  test.identical( got, exp );

  test.case = 'absolute path to file, one slash';
  var src = '/some/staging/index.html';
  var got = _.uriNew.ext( src );
  var exp = 'html';
  test.identical( got, exp );

  test.case = 'absolute path to file, two slashes';
  var src = '//some/staging/index.html';
  var got = _.uriNew.ext( src );
  var exp = 'html';
  test.identical( got, exp );

  test.case = 'absolute path to file, three slashes';
  var src = '///some/staging/index.html';
  var got = _.uriNew.ext( src );
  var exp = 'html';
  test.identical( got, exp );

  test.case = 'hard drive path to file';
  var src = 'file:///some/staging/index.html';
  var got = _.uriNew.ext( src );
  var exp = 'html';
  test.identical( got, exp );

  test.case = 'http path to file';
  var src = 'http://some.come/staging/index.html';
  var got = _.uriNew.ext( src );
  var exp = 'html';
  test.identical( got, exp );

  test.case = 'svn+https path to file';
  var src = 'svn+https://user@subversion.com/svn/trunk/index.html';
  var got = _.uriNew.ext( src );
  var exp = 'html';
  test.identical( got, exp );

  test.case = 'complex+protocol path to file';
  var src = 'complex+protocol://www.site.com:13/path/name.html?query=here&and=here#anchor';
  var got = _.uriNew.ext( src );
  var exp = 'html';

  test.case = 'complex path to file with parameters';
  var src = '://www.site.com:13/path/name.html?query=here&and=here#anchor';
  var got = _.uriNew.ext( src );
  var exp = 'html';
  test.identical( got, exp );

  test.case = 'complex path to file with parameters';
  var src = ':///www.site.com:13/path/name.html?query=here&and=here#anchor';
  var got = _.uriNew.ext( src );
  var exp = 'html';
  test.identical( got, exp );

  /* */

  test.case = 'uri filePath file';
  var src = 'http://www.site.com:13/path/name.txt'
  var got = _.uriNew.ext( src );
  var expected = 'txt';
  test.identical( got, expected );

  test.case = 'uri with params';
  var src = 'http://www.site.com:13/path/name?query=here&and=here#anchor';
  var got = _.uriNew.ext( src );
  var expected = '';
  test.identical( got, expected );

  test.case = 'uri without protocol';
  var src = '://www.site.com:13/path/name.js';
  var got = _.uriNew.ext( src );
  var expected = 'js';
  test.identical( got, expected );

  /* - */

  if( !Config.debug )
  return;

  test.case = 'passed argument is non string';
  test.shouldThrowErrorSync( () => _.uriNew.ext( false ) );
}

//

function changeExt( test )
{
  test.case = 'filename with extention';
  var src = 'some.txt';
  var got = _.uriNew.changeExt( src, 'abc' );
  var exp = 'some.abc';
  test.identical( got, exp );

  test.case = 'absolute path to file with extention';
  var src = '/foo/bar/baz.asdf';
  var got = _.uriNew.changeExt( src, 'abc' );
  var exp = '/foo/bar/baz.abc';
  test.identical( got, exp );

  test.case = 'absolute path to hidden file';
  var src = '/foo/bar/.baz';
  var got = _.uriNew.changeExt( src, 'abc' );
  var exp = '/foo/bar/.baz.abc';
  test.identical( got, exp );

  test.case = 'absolute path to file with complex extention';
  var src = '/foo.coffee.md';
  var got = _.uriNew.changeExt( src, 'abc' );
  var exp = '/foo.coffee.abc';
  test.identical( got, exp );

  test.case = 'absolute path to file without extention';
  var src = '/foo/bar/baz';
  var got = _.uriNew.changeExt( src, 'abc' );
  var exp = '/foo/bar/baz.abc';
  test.identical( got, exp );

  test.case = 'absolute path to file, begins on one slash';
  var src = '/some/staging/index.html';
  var got = _.uriNew.changeExt( src, 'abc' );
  var exp = '/some/staging/index.abc';
  test.identical( got, exp );

  test.case = 'absolute path to file, begins on two slashes';
  var src = '//some/staging/index.html';
  var got = _.uriNew.changeExt( src, 'abc' );
  var exp = '//some/staging/index.abc';
  test.identical( got, exp );

  test.case = 'absolute path to file, begins on three slashes';
  var src = '///some/staging/index.html';
  var got = _.uriNew.changeExt( src, 'abc' );
  var exp = '///some/staging/index.abc';
  test.identical( got, exp );

  test.case = 'hard drive path to file';
  var src = 'file:///some/staging/index.html';
  var got = _.uriNew.changeExt( src, 'abc' );
  var exp = 'file:///some/staging/index.abc';
  test.identical( got, exp );

  test.case = 'http path to file';
  var src = 'http://some.come/staging/index.html';
  var got = _.uriNew.changeExt( src, 'abc' );
  var exp = 'http://some.come/staging/index.abc';
  test.identical( got, exp );

  test.case = 'svn+https path to file';
  var src = 'svn+https://user@subversion.com/svn/trunk/index.html';
  var got = _.uriNew.changeExt( src, 'abc' );
  var exp = 'svn+https://user@subversion.com/svn/trunk/index.abc';
  test.identical( got, exp );

  test.case = 'complex+protocol path to file';
  var src = 'complex+protocol://www.site.com:13/path/name.html?query=here&and=here#anchor';
  var got = _.uriNew.changeExt( src, 'abc' );
  var exp = 'complex+protocol://www.site.com:13/path/name.abc?query=here&and=here#anchor';
  test.identical( got, exp );

  test.case = 'path to file with options';
  var src = '://www.site.com:13/path/name.html?query=here&and=here#anchor';
  var got = _.uriNew.changeExt( src, 'abc' );
  var exp = '://www.site.com:13/path/name.abc?query=here&and=here#anchor';
  test.identical( got, exp );

  test.case = 'path to file with options';
  var src = ':///www.site.com:13/path/name.html?query=here&and=here#anchor';
  var got = _.uriNew.changeExt( src, 'abc' );
  var exp = ':///www.site.com:13/path/name.abc?query=here&and=here#anchor';
  test.identical( got, exp );

  /* - */

  if( !Config.debug )
  return;

  test.case = 'passed argument is non string';
  test.shouldThrowErrorSync( () => _.uriNew.changeExt( false ) );
}

//

/*
qqq : improve style, remove array of expected values and array of inputs | Dmytro : improved
 */

function dir( test )
{
  test.case = 'filename';
  var src = 'some.txt';
  var got = _.uriNew.dir( src );
  var exp = '.';
  test.identical( got, exp );

  test.case = 'absolute path to file';
  var src = '/foo/bar/baz.asdf';
  var got = _.uriNew.dir( src );
  var exp = '/foo/bar';
  test.identical( got, exp );

  test.case = 'absolute path to hidden file';
  var src = '/foo/bar/.baz';
  var got = _.uriNew.dir( src );
  var exp = '/foo/bar';
  test.identical( got, exp );

  test.case = 'absolute path to file with complex extention';
  var src = '/foo.coffee.md';
  var got = _.uriNew.dir( src );
  var exp = '/';
  test.identical( got, exp );

  test.case = 'absolute path to file without extention';
  var src = '/foo/bar/baz';
  var got = _.uriNew.dir( src );
  var exp = '/foo/bar';
  test.identical( got, exp );

  test.case = 'absolute path to file, begins on one slash';
  var src = '/some/staging/index.html';
  var got = _.uriNew.dir( src );
  var exp = '/some/staging';
  test.identical( got, exp );

  test.case = 'absolute path to file, begins on two slashes';
  var src = '//some/staging/index.html';
  var got = _.uriNew.dir( src );
  var exp = '//some/staging';
  test.identical( got, exp );

  test.case = 'absolute path to file, begins on three slashes';
  var src = '///some/staging/index.html';
  var got = _.uriNew.dir( src );
  var exp = '///some/staging';
  test.identical( got, exp );

  test.case = 'hard drive path to file';
  var src = 'file:///some/staging/index.html';
  var got = _.uriNew.dir( src );
  var exp = 'file:///some/staging';
  test.identical( got, exp );

  test.case = 'http path to file';
  var src = 'http://some.come/staging/index.html';
  var got = _.uriNew.dir( src );
  var exp = 'http://some.come/staging';
  test.identical( got, exp );

  test.case = 'svn+https path to file';
  var src = 'svn+https://user@subversion.com/svn/trunk/index.html';
  var got = _.uriNew.dir( src );
  var exp = 'svn+https://user@subversion.com/svn/trunk';
  test.identical( got, exp );

  test.case = 'complex+protocol path to file';
  var src = 'complex+protocol://www.site.com:13/path/name.html?query=here&and=here#anchor';
  var got = _.uriNew.dir( src );
  var exp = 'complex+protocol://www.site.com:13/path?query=here&and=here#anchor';
  test.identical( got, exp );

  test.case = 'path to file with options';
  var src = '://www.site.com:13/path/name.html?query=here&and=here#anchor';
  var got = _.uriNew.dir( src );
  var exp = '://www.site.com:13/path?query=here&and=here#anchor';
  test.identical( got, exp );

  test.case = 'path to file with options';
  var src = ':///www.site.com:13/path/name.html?query=here&and=here#anchor';
  var got = _.uriNew.dir( src );
  var exp = ':///www.site.com:13/path?query=here&and=here#anchor';
  test.identical( got, exp );

  /* xxx qqq : add such test case to each test group and test routine */
  test.case = 'path to file with options';
  var src = 'current:///pro/"a1#"/"a2@"/"a3!"/"a4?"/"#a5"/"@a6"/"!a7"/"?a8"/File1.txt';
  var got = _.uriNew.dir( src );
  var exp = `current:///pro/"a1#"/"a2@"/"a3!"/"a4?"/"#a5"/"@a6"/"!a7"/"?a8"`;
  test.identical( got, exp );

  /* */

  test.open( 'trailing slash' );

  var src = '/a/b/';
  var expected = '/a/';
  var got = _.uriNew.dir( src );
  test.identical( got, expected );

  var src = '/a/b/.';
  var expected = '/a';
  var got = _.uriNew.dir( src );
  test.identical( got, expected );

  var src = '/a/b/./';
  var expected = '/a/';
  var got = _.uriNew.dir( src );
  test.identical( got, expected );

  var src = '/a/b/././';
  var expected = '/a/';
  var got = _.uriNew.dir( src );
  test.identical( got, expected );

  var src = '/a/b/./.';
  var expected = '/a';
  var got = _.uriNew.dir( src );
  test.identical( got, expected );

  var src = 'a/b/';
  var expected = 'a/';
  var got = _.uriNew.dir( src );
  test.identical( got, expected );

  var src = 'a/b/.';
  var expected = 'a';
  var got = _.uriNew.dir( src );
  test.identical( got, expected );

  var src = 'a/b/./';
  var expected = 'a/';
  var got = _.uriNew.dir( src );
  test.identical( got, expected );

  var src = '/a/b/';
  var expected = '/a/';
  var got = _.uriNew.dir( src );
  test.identical( got, expected );

  var src = 'http:///a/b/.';
  var expected = 'http:///a';
  var got = _.uriNew.dir( src );
  test.identical( got, expected );

  var src = 'http:///a/b/./';
  var expected = 'http:///a/';
  var got = _.uriNew.dir( src );
  test.identical( got, expected );

  var src = 'http://a/b/';
  var expected = 'http://a/';
  var got = _.uriNew.dir( src );
  test.identical( got, expected );

  var src = 'http://a/b/.';
  var expected = 'http://a';
  var got = _.uriNew.dir( src );
  test.identical( got, expected );

  var src = 'http://a/b/./';
  var expected = 'http://a/';
  var got = _.uriNew.dir( src );
  test.identical( got, expected );

  test.close( 'trailing slash' );

  /* - */

  if( !Config.debug )
  return;

  test.case = 'passed argument is non string';
  test.shouldThrowErrorSync( function()
  {
    _.uriNew.dir( false );
  });

}

//

function dirFirst( test )
{

  /*
  qqq : improve style, remove array of expected values and array of inputs | Dmytro : improved
  */

  test.case = 'filename';
  var src = 'some.txt';
  var got = _.uriNew.dirFirst( src );
  var exp = './';
  test.identical( got, exp );

  test.case = 'absolute path to file';
  var src = '/foo/bar/baz.asdf';
  var got = _.uriNew.dirFirst( src );
  var exp = '/foo/bar/';
  test.identical( got, exp );

  test.case = 'absolute path to hidden file';
  var src = '/foo/bar/.baz';
  var got = _.uriNew.dirFirst( src );
  var exp = '/foo/bar/';
  test.identical( got, exp );

  test.case = 'absolute path to file with complex extention';
  var src = '/foo.coffee.md';
  var got = _.uriNew.dirFirst( src );
  var exp = '/';
  test.identical( got, exp );

  test.case = 'absolute path to file without extention';
  var src = '/foo/bar/baz';
  var got = _.uriNew.dirFirst( src );
  var exp = '/foo/bar/';
  test.identical( got, exp );

  test.case = 'absolute path to file, begins on one slash';
  var src = '/some/staging/index.html';
  var got = _.uriNew.dirFirst( src );
  var exp = '/some/staging/';
  test.identical( got, exp );

  test.case = 'absolute path to file, begins on two slashes';
  var src = '//some/staging/index.html';
  var got = _.uriNew.dirFirst( src );
  var exp = '//some/staging/';
  test.identical( got, exp );

  test.case = 'absolute path to file, begins on three slashes';
  var src = '///some/staging/index.html';
  var got = _.uriNew.dirFirst( src );
  var exp = '///some/staging/';
  test.identical( got, exp );

  test.case = 'hard drive path to file';
  var src = 'file:///some/staging/index.html';
  var got = _.uriNew.dirFirst( src );
  var exp = 'file:///some/staging/';
  test.identical( got, exp );

  test.case = 'http path to file';
  var src = 'http://some.come/staging/index.html';
  var got = _.uriNew.dirFirst( src );
  var exp = 'http://some.come/staging/';
  test.identical( got, exp );

  test.case = 'svn+https path to file';
  var src = 'svn+https://user@subversion.com/svn/trunk/index.html';
  var got = _.uriNew.dirFirst( src );
  var exp = 'svn+https://user@subversion.com/svn/trunk/';
  test.identical( got, exp );

  test.case = 'complex+protocol path to file';
  var src = 'complex+protocol://www.site.com:13/path/name.html?query=here&and=here#anchor';
  var got = _.uriNew.dirFirst( src );
  var exp = 'complex+protocol://www.site.com:13/path/?query=here&and=here#anchor';
  test.identical( got, exp );

  test.case = 'path to file with options';
  var src = '://www.site.com:13/path/name.html?query=here&and=here#anchor';
  var got = _.uriNew.dirFirst( src );
  var exp = '://www.site.com:13/path/?query=here&and=here#anchor';
  test.identical( got, exp );

  test.case = 'path to file with options';
  var src = ':///www.site.com:13/path/name.html?query=here&and=here#anchor';
  var got = _.uriNew.dirFirst( src );
  var exp = ':///www.site.com:13/path/?query=here&and=here#anchor';
  test.identical( got, exp );

  /* */

  test.open( 'trailing slash' );

  var src = '/a/b/';
  var expected = '/a/b/';
  var got = _.uriNew.dirFirst( src );
  test.identical( got, expected );

  var src = '/a/b/.';
  var expected = '/a/';
  var got = _.uriNew.dirFirst( src );
  test.identical( got, expected );

  var src = '/a/b/./';
  var expected = '/a/b/';
  var got = _.uriNew.dirFirst( src );
  test.identical( got, expected );

  var src = '/a/b/././';
  var expected = '/a/b/';
  var got = _.uriNew.dirFirst( src );
  test.identical( got, expected );

  var src = '/a/b/./.';
  var expected = '/a/';
  var got = _.uriNew.dirFirst( src );
  test.identical( got, expected );

  var src = 'a/b/';
  var expected = 'a/b/';
  var got = _.uriNew.dirFirst( src );
  test.identical( got, expected );

  var src = 'a/b/.';
  var expected = 'a/';
  var got = _.uriNew.dirFirst( src );
  test.identical( got, expected );

  var src = 'a/b/./';
  var expected = 'a/b/';
  var got = _.uriNew.dirFirst( src );
  test.identical( got, expected );

  var src = '/a/b/';
  var expected = '/a/b/';
  var got = _.uriNew.dirFirst( src );
  test.identical( got, expected );

  var src = 'http:///a/b/.';
  var expected = 'http:///a/';
  var got = _.uriNew.dirFirst( src );
  test.identical( got, expected );

  var src = 'http:///a/b/./';
  var expected = 'http:///a/b/';
  var got = _.uriNew.dirFirst( src );
  test.identical( got, expected );

  var src = 'http://a/b/';
  var expected = 'http://a/b/';
  var got = _.uriNew.dirFirst( src );
  test.identical( got, expected );

  var src = 'http://a/b/.';
  var expected = 'http://a/';
  var got = _.uriNew.dirFirst( src );
  test.identical( got, expected );

  var src = 'http://a/b/./';
  var expected = 'http://a/b/';
  var got = _.uriNew.dirFirst( src );
  test.identical( got, expected );

  test.close( 'trailing slash' );

  /* - */

  if( !Config.debug )
  return;

  test.case = 'passed argument is non string';
  test.shouldThrowErrorSync( function()
  {
    _.uriNew.dir( false );
  });

}

//

/*

a//b
a///b
127.0.0.1:61726

://some/staging/index.html
:///some/staging/index.html
/some/staging/index.html
file:///some/staging/index.html
http://some.come/staging/index.html
svn+https://user@subversion.com/svn/trunk
complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor
https://web.archive.org/web/*\/http://www.heritage.org/index/ranking
https://user:pass@sub.host.com:8080/p/a/t/h?query=string#hash
*/

// //
//
// function filter( test )
// {
//
//   test.case = 'string';
//   var src = '/a/b/c';
//   var got = _.uriNew.filter( src, onEach );
//   var expected = 'file:///a/b/c';
//   test.identical( got, expected );
//
//   test.case = 'array';
//   var src = [ '/a', '/b' ];
//   var got = _.uriNew.filter( src, onEach );
//   var expected = [ 'file:///a', 'file:///b' ];
//   test.identical( got, expected );
//   test.is( got !== src );
//
//   test.case = 'array filter';
//   var src = [ 'file:///a', '/b' ];
//   var got = _.uriNew.filter( src, onEachFilter );
//   var expected = 'file:///a';
//   test.identical( got, expected );
//   test.is( got !== src );
//
//   test.case = 'map';
//   var src = { '/src' : '/dst' };
//   var got = _.uriNew.filter( src, onEach );
//   var expected = { 'file:///src' : 'file:///dst' };
//   test.identical( got, expected );
//   test.is( got !== src );
//
//   test.case = 'map filter';
//   var src = { 'file:///src' : '/dst' };
//   var got = _.uriNew.filter( src, onEachFilter );
//   var expected = '';
//   test.identical( got, expected );
//   test.is( got !== src );
//
//   test.case = 'map filter';
//   var src = { 'file:///a' : [ 'file:///b', 'file:///c', null, undefined ] };
//   var got = _.uriNew.filter( src, onEachStructure );
//   var expected =
//   {
//     'file:///src/a' : [ 'file:///dst/b', 'file:///dst/c', 'file:///dst' ]
//   };
//   test.identical( got, expected );
//   test.is( got !== src );
//
//   test.case = 'map filter keys, onEach returns array with undefined';
//   var src = { '/a' : '/b' };
//   var got = _.uriNew.filter( src, onEachStructureKeys );
//   var expected =
//   {
//     'file:///a' : '/b'
//   };
//   test.identical( got, expected );
//   test.is( got !== src );
//
//   test.case = 'null';
//   var src = null;
//   var got = _.uriNew.filter( src, onEach );
//   var expected = 'file:///';
//   test.identical( got, expected );
//
//   if( Config.debug )
//   {
//     test.case = 'number';
//     test.shouldThrowErrorSync( () => _.uriNew.filter( 1, onEach ) )
//   }
//
//   /* */
//
//   function onEach( filePath, it )
//   {
//     if( filePath === null )
//     return 'file:///';
//     return _.uriNew.reroot( 'file:///', filePath );
//   }
//
//   function onEachFilter( filePath, it )
//   {
//     if( _.uriNew.isGlobal( filePath ) )
//     return filePath;
//   }
//
//   function onEachStructure( filePath, it )
//   {
//     if( _.arrayIs( filePath ) )
//     return filePath.map( onPath );
//     return onPath( filePath );
//
//     function onPath( path )
//     {
//       let prefix = it.side === 'src' ? 'file:///src' : 'file:///dst';
//       if( path === null || path === undefined )
//       return prefix;
//       return _.uriNew.reroot( prefix, path );
//     }
//   }
//
//   function onEachStructureKeys( filePath, it )
//   {
//     if( it.side === 'src' )
//     return [ _.uriNew.join( 'file:///src', filePath ), undefined ];
//     return filePath;
//   }
//
// }
//
// //
//
// function filterInplace( test )
// {
//   test.case = 'string';
//   var src = '/a/b/c';
//   var got = _.uriNew.filterInplace( src, onEach );
//   var expected = 'file:///a/b/c';
//   test.identical( got, expected );
//
//   test.case = 'array';
//   var src = [ '/a', '/b' ];
//   var got = _.uriNew.filterInplace( src, onEach );
//   var expected = [ 'file:///a', 'file:///b' ];
//   test.identical( got, expected );
//   test.identical( got, src );
//
//   test.case = 'array';
//   var src = [ 'file:///a', '/b' ];
//   var got = _.uriNew.filterInplace( src, onEachFilter );
//   var expected = [ 'file:///a' ];
//   test.identical( got, expected );
//   test.identical( got, src );
//
//   test.case = 'map';
//   var src = { '/src' : '/dst' };
//   var got = _.uriNew.filterInplace( src, onEach );
//   var expected = { 'file:///src' : 'file:///dst' };
//   test.identical( got, expected );
//   test.identical( got, src );
//
//   test.case = 'map';
//   var src = { 'file:///src' : '/dst' };
//   var got = _.uriNew.filterInplace( src, onEachFilter );
//   var expected = {};
//   test.identical( got, expected );
//   test.identical( got, src );
//
//   test.case = 'map';
//   var src = { 'file:///a' : [ 'file:///b', 'file:///c', null, undefined ] };
//   var got = _.uriNew.filterInplace( src, onEachStructure );
//   var expected =
//   {
//     'file:///src/a' : [ 'file:///dst/b', 'file:///dst/c', 'file:///dst' ]
//   };
//   test.identical( got, expected );
//   test.identical( got, src );
//
//   test.case = 'map filter keys, onEach returns array with undefined';
//   var src = { '/a' : '/b' };
//   var got = _.uriNew.filterInplace( src, onEachStructureKeys );
//   var expected =
//   {
//     'file:///a' : '/b'
//   };
//   test.identical( got, expected );
//   test.identical( got, src );
//
//   test.case = 'null';
//   var src = null;
//   var got = _.uriNew.filterInplace( src, onEach );
//   var expected = 'file:///';
//   test.identical( got, expected );
//
//   if( Config.debug )
//   {
//     test.case = 'number';
//     test.shouldThrowErrorSync( () => _.uriNew.filterInplace( 1, onEach ) )
//   }
//
//   /* */
//
//   function onEach( filePath, it )
//   {
//     if( filePath === null )
//     return 'file:///';
//     return _.uriNew.reroot( 'file:///', filePath );
//   }
//
//   function onEachFilter( filePath, it )
//   {
//     if( _.uriNew.isGlobal( filePath ) )
//     return filePath;
//   }
//
//   function onEachStructure( filePath, it )
//   {
//     if( _.arrayIs( filePath ) )
//     return filePath.map( onPath );
//     return onPath( filePath );
//
//     function onPath( path )
//     {
//       let prefix = it.side === 'src' ? 'file:///src' : 'file:///dst';
//       if( path === null || path === undefined )
//       return prefix;
//       return _.uriNew.reroot( prefix, path );
//     }
//   }
//
//   function onEachStructureKeys( filePath, it )
//   {
//     if( it.side === 'src' )
//     return [ _.uriNew.join( 'file:///src', filePath ), undefined ];
//     return filePath;
//   }
//
// }

function uriConstructors( test )
{
  test.case = 'instance of _.Uri constructor, without map';
  var got = new _.Uri();
  var exp =
  {
    protocol : null,
    query : null,
    hash : null,
  };
  test.identical( got.protocol, null );
}

// --
// declare
// --

let Self =
{

  name : 'Tools.l4.Uri',
  silencing : 1,

  tests :
  {

    isRelative,
    isRoot,

    normalize,
    normalizeLocalPaths,
    normalizeTolerant,
    normalizeTolerantLocalPaths,

    refine,
    urisRefine,

    /* qqq2 : refactor test routines parse, parseAtomic, parseConsecutive, parseFull. make sure all cases are similar */
    // parse,
    parseCommon,
    // parseFull,
    // parseFull2,
    // parseConsecutive,
    // parseConsecutive2,

    // parseGlob, /* xxx : enable and fix */

    // parseTagExperiment,
    localFromGlobal,

    str,
    full,
    parseAndStr,
    // basePath,
    documentGet,
    server,
    query,
    dequery,
    resolve,

    // _uriJoin_body,
    join,
    join_,
    joinRaw,
    joinRaw_,
    reroot,

    relativeLocalPaths,
    relative,

    commonLocalPaths,
    common,
    commonMapsInArgs,

    groupTextualReport,
    commonTextualReport,
    moveTextualReport,

    rebase,

    name,
    ext,
    changeExt,
    dir,
    dirFirst,

    // constructors

    uriConstructors,

    // filter,
    // filterInplace

  },

}

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self );

})();
