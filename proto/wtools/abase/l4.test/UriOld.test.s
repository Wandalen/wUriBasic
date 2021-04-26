( function _Uri_test_s_( )
{

'use strict';

if( typeof module !== 'undefined' )
{
  const _ = require( '../../../node_modules/Tools' );
  _.include( 'wTesting' );
  // _.include( 'wStringer' );
  require( '../l4/Uri.s' );
}

const _global = _global_;
const _ = _global_.wTools;

/*
qqq : improve style, remove array of expected values and array of inputs | Dmytro : improved
*/

// --
// tests
// --

function isRelative( test )
{
  /* */

  test.case = 'relative with protocol';

  var path = 'ext://.';
  var expected = true;
  var got = _.uriOld.isRelative( path );
  test.identical( got, expected );

  /* */

  test.case = 'relative with protocol and folder';

  var path = 'ext://something';
  var expected = true;
  var got = _.uriOld.isRelative( path );
  test.identical( got, expected );

  /* */

  test.case = 'relative with protocol and 2 folders';

  var path = 'ext://something/longer';
  var expected = true;
  var got = _.uriOld.isRelative( path );
  test.identical( got, expected );

  /* */

  test.case = 'absolute with protocol';

  var path = 'ext:///';
  var expected = false;
  var got = _.uriOld.isRelative( path );
  test.identical( got, expected );
}

//

function isRoot( test )
{
  test.case = 'local';

  var path = '/src/a1';
  var got = _.uriOld.isRoot( path );
  test.identical( got, false );

  var path = '.';
  var got = _.uriOld.isRoot( path );
  test.identical( got, false );

  var path = '';
  var got = _.uriOld.isRoot( path );
  test.identical( got, false );

  var path = '/';
  var got = _.uriOld.isRoot( path );
  test.identical( got, true );

  var path = '/.';
  var got = _.uriOld.isRoot( path );
  test.identical( got, true );

  var path = '/./.';
  var got = _.uriOld.isRoot( path );
  test.identical( got, true );

  var path = '/x/..';
  var got = _.uriOld.isRoot( path );
  test.identical( got, true );

  test.case = 'global';

  var path = 'extract+src:///src/a1';
  var got = _.uriOld.isRoot( path );
  test.identical( got, false );

  var path = 'extract+src:///';
  var got = _.uriOld.isRoot( path );
  test.identical( got, true );

  var path = 'extract+src:///.';
  var got = _.uriOld.isRoot( path );
  test.identical( got, true );

  var path = 'extract+src:///./.';
  var got = _.uriOld.isRoot( path );
  test.identical( got, true );

  var path = 'extract+src:///x/..';
  var got = _.uriOld.isRoot( path );
  test.identical( got, true );

  var path = 'extract+src://';
  var got = _.uriOld.isRoot( path );
  test.identical( got, false );

  var path = 'extract+src://.';
  var got = _.uriOld.isRoot( path );
  test.identical( got, false );
}

//

function normalize( test )
{
  test.case = 'empty';
  var path = '';
  var expected = '';
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  test.case = 'dot at end';
  var path = 'ext:///.';
  var expected = 'ext:///';
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  var path = 'file:///C/proto/.';
  var expected = 'file:///C/proto';
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  var path = '://some/staging/index.html/'
  var expected ='://some/staging/index.html/'
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  var path = '://some/staging/index.html/.'
  var expected ='://some/staging/index.html'
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  var path = '://some/staging/index.html.'
  var expected ='://some/staging/index.html.'
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  var path = ':///some/staging/index.html'
  var expected =':///some/staging/index.html'
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  var path = ':///some/staging/index.html/.'
  var expected =':///some/staging/index.html'
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  var path = ':///some/staging/index.html/./'
  var expected =':///some/staging/index.html/'
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  var path = ':///some/staging/./index.html/./'
  var expected =':///some/staging/index.html/'
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  var path = ':///some/staging/.//index.html/./'
  var expected =':///some/staging//index.html/'
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  var path = ':///some/staging/index.html///.'
  var expected =':///some/staging/index.html//'
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  var path = 'file:///some/staging/index.html/..'
  var expected ='file:///some/staging'
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  var path = 'file:///some/staging/index.html/..///'
  var expected ='file:///some/staging///'
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  var path = 'file:///some\\staging\\index.html\\..\\'
  var expected ='file:///some/staging/'
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  var path = 'http:///./some.come/staging/index.html/.'
  var expected ='http:///some.come/staging/index.html'
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  var path = 'http:///./some.come/staging/index.html'
  var expected ='http:///some.come/staging/index.html'
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  var path = 'http:///./some.come/./staging/index.html'
  var expected ='http:///some.come/staging/index.html'
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  var path = 'svn+https://../user@subversion.com/svn/trunk'
  var expected ='svn+https://../user@subversion.com/svn/trunk'
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  var path = 'svn+https://..//..//user@subversion.com/svn/trunk'
  var expected ='svn+https://..//user@subversion.com/svn/trunk'
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  var path = 'svn+https://..//../user@subversion.com/svn/trunk'
  var expected ='svn+https://../user@subversion.com/svn/trunk'
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  var path = 'complex+protocol://www.site.com:13/path/name/.?query=here&and=here#anchor'
  var expected ='complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor'
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  var path = 'complex+protocol://www.site.com:13/path/name/./../?query=here&and=here#anchor'
  var expected ='complex+protocol://www.site.com:13/path/?query=here&and=here#anchor'
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  var path = 'complex+protocol://www.site.com:13/path/name/./..?query=here&and=here#anchor'
  var expected ='complex+protocol://www.site.com:13/path?query=here&and=here#anchor'
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  var path = 'complex+protocol://www.site.com:13/path/name/.//../?query=here&and=here#anchor'
  var expected ='complex+protocol://www.site.com:13/path/name/?query=here&and=here#anchor'
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  var path = 'https://web.archive.org/web/*\/http://www.heritage.org/index/ranking/.'
  var expected ='https://web.archive.org/web/*\/http://www.heritage.org/index/ranking'
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  var path = 'https://web.archive.org/web/*\/http://www.heritage.org/index/ranking//.'
  var expected ='https://web.archive.org/web/*\/http://www.heritage.org/index/ranking/'
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  var path = 'https://web.archive.org/web/*\/http://www.heritage.org//index/ranking//.'
  var expected ='https://web.archive.org/web/*\/http://www.heritage.org//index/ranking/'
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  var path = 'https://web.archive.org/web/*\/http://www.heritage.org/../index/ranking//.'
  var expected ='https://web.archive.org/web/*\/http://index/ranking/'
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  var path = 'https://web.archive.org/web/*\/http://www.heritage.org/.././index/ranking//.'
  var expected ='https://web.archive.org/web/*\/http://index/ranking/'
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  var path = 'https://web.archive.org/web/*\/http://www.heritage.org/.././index/ranking/./.'
  var expected ='https://web.archive.org/web/*\/http://index/ranking'
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );
}

//

function normalizeLocalPaths( test )
{
  /* */

  test.case = 'posix path';

  var path = '/foo/bar//baz/asdf/quux/..';
  var expected = '/foo/bar//baz/asdf';
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  var path = '/foo/bar//baz/asdf/quux/../';
  var expected = '/foo/bar//baz/asdf/';
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  var path = '//foo/bar//baz/asdf/quux/..//';
  var expected = '//foo/bar//baz/asdf//';
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  var path = 'foo/bar//baz/asdf/quux/..//.';
  var expected = 'foo/bar//baz/asdf/';
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  /* */

  test.case = 'winoows path';

  var path = 'C:\\temp\\\\foo\\bar\\..\\';
  var expected = '/C/temp//foo/';
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  var path = 'C:\\temp\\\\foo\\bar\\..\\\\';
  var expected = '/C/temp//foo//';
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  var path = 'C:\\temp\\\\foo\\bar\\..\\\\';
  var expected = '/C/temp//foo//';
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  var path = 'C:\\temp\\\\foo\\bar\\..\\..\\';
  var expected = '/C/temp//';
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  var path = 'C:\\temp\\\\foo\\bar\\..\\..\\.';
  var expected = '/C/temp/';
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  /* */

  test.case = 'empty path';

  var path = '';
  var expected = '';
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  var path = '/';
  var expected = '/';
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  var path = '//';
  var expected = '//';
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  var path = '///';
  var expected = '///';
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  var path = '/.';
  var expected = '/';
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  var path = '/./.';
  var expected = '/';
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  var path = '.';
  var expected = '.';
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  var path = './.';
  var expected = '.';
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  /* */

  test.case = 'path with "." in the middle';

  var path = 'foo/./bar/baz';
  var expected = 'foo/bar/baz';
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  var path = 'foo/././bar/baz/';
  var expected = 'foo/bar/baz/';
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  var path = 'foo/././bar/././baz/';
  var expected = 'foo/bar/baz/';
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  var path = '/foo/././bar/././baz/';
  var expected = '/foo/bar/baz/';
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  var path = '/foo/.x./baz/';
  var expected = '/foo/.x./baz/';
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  /* */

  test.case = 'path with "." in the beginning';

  var path = './foo/bar';
  var expected = './foo/bar';
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  var path = '././foo/bar/';
  var expected = './foo/bar/';
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  var path = './/.//foo/bar/';
  var expected = './//foo/bar/';
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  var path = '/.//.//foo/bar/';
  var expected = '///foo/bar/';
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  var path = '.x/foo/bar';
  var expected = '.x/foo/bar';
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  var path = '.x./foo/bar';
  var expected = '.x./foo/bar';
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  var path = './x/.';
  var expected = './x';
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  /* */

  test.case = 'path with "." in the end';

  var path = 'foo/bar.';
  var expected = 'foo/bar.';
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  var path = 'foo/.bar.';
  var expected = 'foo/.bar.';
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  var path = 'foo/bar/.';
  var expected = 'foo/bar';
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  var path = 'foo/bar/./.';
  var expected = 'foo/bar';
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  var path = 'foo/bar/././';
  var expected = 'foo/bar/';
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  var path = '/foo/bar/././';
  var expected = '/foo/bar/';
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  var path = '/foo/baz/.x./';
  var expected = '/foo/baz/.x./';
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  /* */

  test.case = 'path with ".." in the middle';

  var path = 'foo/../bar/baz';
  var expected = 'bar/baz';
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  var path = 'foo/../../bar/baz/';
  var expected = '../bar/baz/';
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  var path = 'foo/../../bar/../../baz/';
  var expected = '../../baz/';
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  var path = '/foo/../../bar/../../baz/';
  var expected = '/../../baz/';
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  /* */

  test.case = 'path with ".." in the beginning';

  var path = '../foo/bar';
  var expected = '../foo/bar';
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  var path = '../../foo/bar/';
  var expected = '../../foo/bar/';
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  var path = '..//..//foo/bar/';
  var expected = '..//foo/bar/';
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  var path = '/..//..//foo/bar/';
  var expected = '/..//foo/bar/';
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  var path = '..x/foo/bar';
  var expected = '..x/foo/bar';
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  var path = '..x../foo/bar';
  var expected = '..x../foo/bar';
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  /* */

  test.case = 'path with ".." in the end';

  var path = 'foo/bar..';
  var expected = 'foo/bar..';
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  var path = 'foo/..bar..';
  var expected = 'foo/..bar..';
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  var path = 'foo/bar/..';
  var expected = 'foo';
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  var path = 'foo/bar/../..';
  var expected = '.';
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  var path = 'foo/bar/../../';
  var expected = './';
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  var path = '/foo/bar/../../';
  var expected = '/';
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  var path = 'foo/bar/../../..';
  var expected = '..';
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  var path = 'foo/bar/../../../..';
  var expected = '../..';
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  var path = 'foo/../bar/../../../..';
  var expected = '../../..';
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  /* */

  test.case = 'path with ".." and "." combined';

  var path = '/abc/./../a/b';
  var expected = '/a/b';
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  var path = '/abc/.././a/b';
  var expected = '/a/b';
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  var path = '/abc/./.././a/b';
  var expected = '/a/b';
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  var path = '/a/b/abc/../.';
  var expected = '/a/b';
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  var path = '/a/b/abc/./..';
  var expected = '/a/b';
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  var path = '/a/b/abc/./../.';
  var expected = '/a/b';
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  var path = './../.';
  var expected = '..';
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  var path = './..';
  var expected = '..';
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );

  var path = '../.';
  var expected = '..';
  var got = _.uriOld.normalize( path );
  test.identical( got, expected );
}

//

function normalizeTolerant( test )
{
  test.case = 'dot at end';
  var path = 'ext:///.';
  var expected = 'ext:///';
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'file:///C/proto/.';
  var expected = 'file:///C/proto';
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'file:///C/proto/./';
  var expected = 'file:///C/proto/';
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  test.case = '';
  var path = '://some/staging/index.html/'
  var expected ='://some/staging/index.html/'
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  test.case = '';
  var path = '://some/staging/index.html/./'
  var expected ='://some/staging/index.html/'
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  test.case = '';
  var path = '://some/staging/index.html/.'
  var expected ='://some/staging/index.html'
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '://some/staging/index.html/.'
  var expected ='://some/staging/index.html'
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '://some/staging/index.html.'
  var expected ='://some/staging/index.html.'
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = ':///some/staging/index.html'
  var expected =':///some/staging/index.html'
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = ':///some/staging/index.html/.'
  var expected =':///some/staging/index.html'
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = ':///some/staging/index.html/./'
  var expected =':///some/staging/index.html/'
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = ':///some/staging/./index.html/./'
  var expected =':///some/staging/index.html/'
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = ':///some/staging/.//index.html/./'
  var expected =':///some/staging/index.html/'
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = ':///some/staging/index.html///.'
  var expected =':///some/staging/index.html'
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'file:///some/staging/index.html/..'
  var expected ='file:///some/staging'
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'file:///some/staging/index.html/..///'
  var expected ='file:///some/staging/'
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'file:///some\\staging\\index.html\\..\\'
  var expected ='file:///some/staging/'
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'http:///./some.come/staging/index.html/.'
  var expected ='http:///some.come/staging/index.html'
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'http:///./some.come/staging/index.html'
  var expected ='http:///some.come/staging/index.html'
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'http:///./some.come/./staging/index.html'
  var expected ='http:///some.come/staging/index.html'
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'svn+https://../user@subversion.com/svn/trunk'
  var expected ='svn+https://../user@subversion.com/svn/trunk'
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'svn+https://..//..//user@subversion.com/svn/trunk'
  var expected ='svn+https://../../user@subversion.com/svn/trunk'
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'svn+https://..//../user@subversion.com/svn/trunk'
  var expected ='svn+https://../../user@subversion.com/svn/trunk'
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'complex+protocol://www.site.com:13/path/name/.?query=here&and=here#anchor'
  var expected ='complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor'
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'complex+protocol://www.site.com:13/path/name/./../?query=here&and=here#anchor'
  var expected ='complex+protocol://www.site.com:13/path/?query=here&and=here#anchor'
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'complex+protocol://www.site.com:13/path/name/.//../?query=here&and=here#anchor'
  var expected ='complex+protocol://www.site.com:13/path/?query=here&and=here#anchor'
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'https://web.archive.org/web/*\/http://www.heritage.org/index/ranking/.'
  var expected ='https://web.archive.org/web/*\/http:/www.heritage.org/index/ranking'
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'https://web.archive.org/web/*\/http://www.heritage.org/index/ranking//.'
  var expected ='https://web.archive.org/web/*\/http:/www.heritage.org/index/ranking'
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'https://web.archive.org/web/*\/http://www.heritage.org//index/ranking//.'
  var expected ='https://web.archive.org/web/*\/http:/www.heritage.org/index/ranking'
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'https://web.archive.org/web/*\/http://www.heritage.org/../index/ranking//.'
  var expected ='https://web.archive.org/web/*\/http:/index/ranking'
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'https://web.archive.org/web/*\/http://www.heritage.org/.././index/ranking//.'
  var expected ='https://web.archive.org/web/*\/http:/index/ranking'
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'https://web.archive.org/web/*\/http://www.heritage.org/.././index/ranking/./.'
  var expected ='https://web.archive.org/web/*\/http:/index/ranking'
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'https://web.archive.org/web/*\/http://www.heritage.org/.././index/ranking/././'
  var expected ='https://web.archive.org/web/*\/http:/index/ranking/'
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );
}

//

function normalizeTolerantLocalPaths( test )
{
  /* */

  test.case = 'posix path';

  var path = '/foo/bar//baz/asdf/quux/..';
  var expected = '/foo/bar/baz/asdf';
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '/foo/bar//baz/asdf/quux/../';
  var expected = '/foo/bar/baz/asdf/';
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '//foo/bar//baz/asdf/quux/..//';
  var expected = '/foo/bar/baz/asdf/';
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'foo/bar//baz/asdf/quux/..//.';
  var expected = 'foo/bar/baz/asdf';
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  /* */

  test.case = 'winoows path';

  var path = 'C:\\temp\\\\foo\\bar\\..\\';
  var expected = '/C/temp/foo/';
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'C:\\temp\\\\foo\\bar\\..\\\\';
  var expected = '/C/temp/foo/';
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'C:\\temp\\\\foo\\bar\\..\\\\';
  var expected = '/C/temp/foo/';
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'C:\\temp\\\\foo\\bar\\..\\..\\';
  var expected = '/C/temp/';
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'C:\\temp\\\\foo\\bar\\..\\..\\.';
  var expected = '/C/temp';
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  /* */

  test.case = 'empty path';

  var path = '';
  var expected = '';
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '/';
  var expected = '/';
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '//';
  var expected = '/';
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '///';
  var expected = '/';
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '/.';
  var expected = '/';
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '/./.';
  var expected = '/';
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '.';
  var expected = '.';
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = './.';
  var expected = '.';
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  /* */

  test.case = 'path with "." in the middle';

  var path = 'foo/./bar/baz';
  var expected = 'foo/bar/baz';
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'foo/././bar/baz/';
  var expected = 'foo/bar/baz/';
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'foo/././bar/././baz/';
  var expected = 'foo/bar/baz/';
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '/foo/././bar/././baz/';
  var expected = '/foo/bar/baz/';
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '/foo/.x./baz/';
  var expected = '/foo/.x./baz/';
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  /* */

  test.case = 'path with "." in the beginning';

  var path = './foo/bar';
  var expected = './foo/bar';
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '././foo/bar/';
  var expected = './foo/bar/';
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = './/.//foo/bar/';
  var expected = './foo/bar/';
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '/.//.//foo/bar/';
  var expected = '/foo/bar/';
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '.x/foo/bar';
  var expected = '.x/foo/bar';
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '.x./foo/bar';
  var expected = '.x./foo/bar';
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = './x/.';
  var expected = './x';
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = './x/./';
  var expected = './x/';
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  /* */

  test.case = 'path with "." in the end';

  var path = 'foo/bar.';
  var expected = 'foo/bar.';
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'foo/.bar.';
  var expected = 'foo/.bar.';
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'foo/bar/.';
  var expected = 'foo/bar';
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'foo/bar/./';
  var expected = 'foo/bar/';
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'foo/bar/./.';
  var expected = 'foo/bar';
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'foo/bar/././';
  var expected = 'foo/bar/';
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '/foo/bar/././';
  var expected = '/foo/bar/';
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '/foo/baz/.x./';
  var expected = '/foo/baz/.x./';
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  /* */

  test.case = 'path with ".." in the middle';

  var path = 'foo/../bar/baz';
  var expected = 'bar/baz';
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'foo/../../bar/baz/';
  var expected = '../bar/baz/';
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'foo/../../bar/../../baz/';
  var expected = '../../baz/';
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '/foo/../../bar/../../baz/';
  var expected = '/../../baz/';
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  /* */

  test.case = 'path with ".." in the beginning';

  var path = '../foo/bar';
  var expected = '../foo/bar';
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '../../foo/bar/';
  var expected = '../../foo/bar/';
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '..//..//foo/bar/';
  var expected = '../../foo/bar/';
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '/..//..//foo/bar/';
  var expected = '/../../foo/bar/';
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '..x/foo/bar';
  var expected = '..x/foo/bar';
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '..x../foo/bar';
  var expected = '..x../foo/bar';
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  /* */

  test.case = 'path with ".." in the end';

  var path = 'foo/bar..';
  var expected = 'foo/bar..';
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'foo/..bar..';
  var expected = 'foo/..bar..';
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'foo/bar/..';
  var expected = 'foo';
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'foo/bar/../../';
  var expected = './';
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'foo/bar/../..';
  var expected = '.';
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '/foo/bar/../../';
  var expected = '/';
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'foo/bar/../../..';
  var expected = '..';
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'foo/bar/../../../..';
  var expected = '../..';
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'foo/../bar/../../../..';
  var expected = '../../..';
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  /* */

  test.case = 'path with ".." and "." combined';

  var path = '/abc/./../a/b';
  var expected = '/a/b';
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '/abc/.././a/b';
  var expected = '/a/b';
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '/abc/./.././a/b';
  var expected = '/a/b';
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '/a/b/abc/../.';
  var expected = '/a/b';
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '/a/b/abc/./..';
  var expected = '/a/b';
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '/a/b/abc/./../.';
  var expected = '/a/b';
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = './../.';
  var expected = '..';
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = './.././';
  var expected = '../';
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = './..';
  var expected = '..';
  var got = _.uriOld.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '../.';
  var expected = '..';
  var got = _.uriOld.normalizeTolerant( path );
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
//     test.shouldThrowErrorOfAnyKind( () => _.uriOld.refine( c.src ) );
//     else
//     test.identical( _.uriOld.refine( c.src ), c.expected );
//   }
//
// }

//

function refine( test )
{
  test.case = 'empty uri';
  var src = '';
  var got = _.uriOld.refine( src );
  var exp = '';
  test.identical( got, exp );

  test.case = 'dot uri';
  var src = '.';
  var got = _.uriOld.refine( src );
  var exp = '.';
  test.identical( got, exp );

  test.case = 'uri - simple string';
  var src = 'a';
  var got = _.uriOld.refine( src );
  var exp = 'a';
  test.identical( got, exp );

  test.case = 'uri ends on one slash';
  var src = 'a/';
  var got = _.uriOld.refine( src );
  var exp = 'a/';
  test.identical( got, exp );

  test.case = 'uri ends on double slash';
  var src = 'a//';
  var got = _.uriOld.refine( src );
  var exp = 'a//';
  test.identical( got, exp );

  test.case = 'uri ends on one backslash';
  var src = 'a\\';
  var got = _.uriOld.refine( src );
  var exp = 'a/';
  test.identical( got, exp );

  test.case = 'uri ends on double backslash';
  var src = 'a\\\\';
  var got = _.uriOld.refine( src );
  var exp = 'a//';
  test.identical( got, exp );

  test.case = 'uri has one slash between parts';
  var src = 'a/b';
  var got = _.uriOld.refine( src );
  var exp = 'a/b';
  test.identical( got, exp );

  test.case = 'uri has double slash between parts';
  var src = 'a//b';
  var got = _.uriOld.refine( src );
  var exp = 'a//b';
  test.identical( got, exp );

  test.case = 'uri has one backslash between parts';
  var src = 'a\\b';
  var got = _.uriOld.refine( src );
  var exp = 'a/b';
  test.identical( got, exp );

  test.case = 'uri has double backslash between parts';
  var src = 'a\\\\b';
  var got = _.uriOld.refine( src );
  var exp = 'a//b';
  test.identical( got, exp );

  test.case = 'uri has a few backslash between parts';
  var src = '\\a\\b\\c';
  var got = _.uriOld.refine( src );
  var exp = '/a/b/c';
  test.identical( got, exp );

  test.case = 'uri has a few double backslash between parts';
  var src = '\\\\a\\\\b\\\\c';
  var got = _.uriOld.refine( src );
  var exp = '//a//b//c';
  test.identical( got, exp );

  /* */

  test.case = 'uri - one slash';
  var src = '/';
  var got = _.uriOld.refine( src );
  var exp = '/';
  test.identical( got, exp );

  test.case = 'uri - double slash';
  var src = '//';
  var got = _.uriOld.refine( src );
  var exp = '//';
  test.identical( got, exp );

  test.case = 'uri - triple slash';
  var src = '///';
  var got = _.uriOld.refine( src );
  var exp = '///';
  test.identical( got, exp );

  test.case = 'uri - one backslash';
  var src = '\\';
  var got = _.uriOld.refine( src );
  var exp = '/';
  test.identical( got, exp );

  test.case = 'uri - double backslash';
  var src = '\\\\';
  var got = _.uriOld.refine( src );
  var exp = '//';
  test.identical( got, exp );

  test.case = 'uri - triple backslash';
  var src = '\\\\\\';
  var got = _.uriOld.refine( src );
  var exp = '///';
  test.identical( got, exp );

  /* */

  test.case = 'uri - simple path';
  var src = '/some/staging/index.html';
  var got = _.uriOld.refine( src );
  var exp = '/some/staging/index.html';
  test.identical( got, exp );

  test.case = 'uri - simple path, ends by slash';
  var src = '/some/staging/index.html/';
  var got = _.uriOld.refine( src );
  var exp = '/some/staging/index.html/';
  test.identical( got, exp );

  test.case = 'uri - begins by double slash';
  var src = '//some/staging/index.html';
  var got = _.uriOld.refine( src );
  var exp = '//some/staging/index.html';
  test.identical( got, exp );

  test.case = 'uri - begins by double slash, ends by slash';
  var src = '//some/staging/index.html/';
  var got = _.uriOld.refine( src );
  var exp = '//some/staging/index.html/';
  test.identical( got, exp );

  test.case = 'uri - begins by triple slash';
  var src = '///some/staging/index.html';
  var got = _.uriOld.refine( src );
  var exp = '///some/staging/index.html';
  test.identical( got, exp );

  test.case = 'uri - begins by triple slash, ends by slash';
  var src = '///some/staging/index.html/';
  var got = _.uriOld.refine( src );
  var exp = '///some/staging/index.html/';
  test.identical( got, exp );

  test.case = 'hard drive path';
  var src = 'file:///some/staging/index.html';
  var got = _.uriOld.refine( src );
  var exp = 'file:///some/staging/index.html';
  test.identical( got, exp );

  test.case = 'hard drive path, ends by slash';
  var src = 'file:///some/staging/index.html/';
  var got = _.uriOld.refine( src );
  var exp = 'file:///some/staging/index.html/';
  test.identical( got, exp );

  test.case = 'http path';
  var src = 'http://some/staging/index.html';
  var got = _.uriOld.refine( src );
  var exp = 'http://some/staging/index.html';
  test.identical( got, exp );

  test.case = 'http path, ends by slash';
  var src = 'http://some/staging/index.html/';
  var got = _.uriOld.refine( src );
  var exp = 'http://some/staging/index.html/';
  test.identical( got, exp );

  test.case = 'svn+https path';
  var src = 'svn+https://user@subversion.com/svn/trunk';
  var got = _.uriOld.refine( src );
  var exp = 'svn+https://user@subversion.com/svn/trunk';
  test.identical( got, exp );

  test.case = 'svn+https path, ends by slash';
  var src = 'svn+https://user@subversion.com/svn/trunk/';
  var got = _.uriOld.refine( src );
  var exp = 'svn+https://user@subversion.com/svn/trunk/';
  test.identical( got, exp );

  test.case = 'complex+protocol path';
  var src = 'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor';
  var got = _.uriOld.refine( src );
  var exp = 'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor';
  test.identical( got, exp );

  test.case = 'complex+protocol path, unnecessary slash';
  var src = 'complex+protocol://www.site.com:13/path/name/?query=here&and=here#anchor';
  var got = _.uriOld.refine( src );
  var exp = 'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor';
  test.identical( got, exp );

  test.case = 'a few paths in string';
  var src = 'https://web.archive.org/web/*/http://www.heritage.org/index/ranking';
  var got = _.uriOld.refine( src );
  var exp = 'https://web.archive.org/web/*/http://www.heritage.org/index/ranking';
  test.identical( got, exp );

  test.case = 'a few paths in string';
  var src = 'https://web.archive.org//web//*//http://www.heritage.org//index//ranking';
  var got = _.uriOld.refine( src );
  var exp = 'https://web.archive.org//web//*//http://www.heritage.org//index//ranking';
  test.identical( got, exp );

  test.case = 'path, one slash before query';
  var src = '://www.site.com:13/path//name/?query=here&and=here#anchor';
  var got = _.uriOld.refine( src );
  var exp = '://www.site.com:13/path//name?query=here&and=here#anchor';
  test.identical( got, exp );

  test.case = 'path, a few slash before query';
  var src = '://www.site.com:13/path//name//?query=here&and=here#anchor';
  var got = _.uriOld.refine( src );
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

  var got = _.uriOld.s.refine( srcs );
  test.identical( got, expected );
}

//

function parse( test )
{

  /* */

  test.case = 'query only';
  var remotePath = '?entry:1&format:null';
  var expected =
  {
    'resourcePath' : '',
    'query' : 'entry:1&format:null',
    'longPath' : '',
    'postfixedPath' : '?entry:1&format:null',
    'protocols' : [],
    'full' : '?entry:1&format:null'
  }
  var got = _.uriOld.parse( remotePath );
  test.identical( got, expected );

  /* */

  var expected =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/git@bitbucket.org:someorg/somerepo.git',
    longPath : '/git@bitbucket.org:someorg/somerepo.git',
    postfixedPath : '/git@bitbucket.org:someorg/somerepo.git@tag',
    protocols : [ 'git' ],
    tag : 'tag',
    hostFull : '',
    origin : 'git://',
    full : 'git:///git@bitbucket.org:someorg/somerepo.git@tag'
  }
  var got = _.uriOld.parse( 'git:///git@bitbucket.org:someorg/somerepo.git@tag' );
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
  var got = _.uriOld.parse( 'git:///git@bitbucket.org:someorg/somerepo.git#hash' );
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
  var got = _.uriOld.parse( 'git:///git@bitbucket.org:someorg/somerepo.git/#hash' );
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
  var got = _.uriOld.parse( 'git:///somerepo.git#hash' );
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
  var got = _.uriOld.parse( 'git:///somerepo.git/#hash' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/git@bitbucket.org:someorg/somerepo.git/',
    tag : 'tag',
    longPath : '/git@bitbucket.org:someorg/somerepo.git/',
    postfixedPath : '/git@bitbucket.org:someorg/somerepo.git/@tag',
    protocols : [ 'git' ],
    hostFull : '',
    origin : 'git://',
    full : 'git:///git@bitbucket.org:someorg/somerepo.git/@tag'
  }
  var got = _.uriOld.parse( 'git:///git@bitbucket.org:someorg/somerepo.git/@tag' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/somerepo.git/',
    tag : 'tag',
    longPath : '/somerepo.git/',
    postfixedPath : '/somerepo.git/@tag',
    protocols : [ 'git' ],
    hostFull : '',
    origin : 'git://',
    full : 'git:///somerepo.git/@tag'
  }
  var got = _.uriOld.parse( 'git:///somerepo.git/@tag' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/git@bitbucket.org:someorg/somerepo.git',
    hash : 'hash',
    tag : 'tag',
    longPath : '/git@bitbucket.org:someorg/somerepo.git',
    postfixedPath : '/git@bitbucket.org:someorg/somerepo.git#hash@tag',
    protocols : [ 'git' ],
    hostFull : '',
    origin : 'git://',
    full : 'git:///git@bitbucket.org:someorg/somerepo.git#hash@tag'
  }
  var got = _.uriOld.parse( 'git:///git@bitbucket.org:someorg/somerepo.git#hash@tag' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/git@bitbucket.org:someorg/somerepo.git/',
    hash : 'hash',
    tag : 'tag',
    longPath : '/git@bitbucket.org:someorg/somerepo.git/',
    postfixedPath : '/git@bitbucket.org:someorg/somerepo.git/#hash@tag',
    protocols : [ 'git' ],
    hostFull : '',
    origin : 'git://',
    full : 'git:///git@bitbucket.org:someorg/somerepo.git/#hash@tag'
  }
  var got = _.uriOld.parse( 'git:///git@bitbucket.org:someorg/somerepo.git/#hash@tag' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/somerepo.git',
    hash : 'hash',
    tag : 'tag',
    longPath : '/somerepo.git',
    postfixedPath : '/somerepo.git#hash@tag',
    protocols : [ 'git' ],
    hostFull : '',
    origin : 'git://',
    full : 'git:///somerepo.git#hash@tag'
  }
  var got = _.uriOld.parse( 'git:///somerepo.git#hash@tag' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/somerepo.git/',
    hash : 'hash',
    tag : 'tag',
    longPath : '/somerepo.git/',
    postfixedPath : '/somerepo.git/#hash@tag',
    protocols : [ 'git' ],
    hostFull : '',
    origin : 'git://',
    full : 'git:///somerepo.git/#hash@tag'
  }
  var got = _.uriOld.parse( 'git:///somerepo.git/#hash@tag' );
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
    postfixedPath : '/git@bitbucket.org:someorg/somerepo.git?query=1#hash@tag',
    protocols : [ 'git' ],
    hostFull : '',
    origin : 'git://',
    full : 'git:///git@bitbucket.org:someorg/somerepo.git?query=1#hash@tag'
  }
  var got = _.uriOld.parse( 'git:///git@bitbucket.org:someorg/somerepo.git?query=1#hash@tag' );
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
    postfixedPath : '/git@bitbucket.org:someorg/somerepo.git/?query=1#hash@tag',
    protocols : [ 'git' ],
    hostFull : '',
    origin : 'git://',
    full : 'git:///git@bitbucket.org:someorg/somerepo.git/?query=1#hash@tag'
  }
  var got = _.uriOld.parse( 'git:///git@bitbucket.org:someorg/somerepo.git/?query=1#hash@tag' );
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
    postfixedPath : '/somerepo.git?query=1#hash@tag',
    protocols : [ 'git' ],
    hostFull : '',
    origin : 'git://',
    full : 'git:///somerepo.git?query=1#hash@tag'
  }
  var got = _.uriOld.parse( 'git:///somerepo.git?query=1#hash@tag' );
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
    postfixedPath : '/somerepo.git/?query=1#hash@tag',
    protocols : [ 'git' ],
    hostFull : '',
    origin : 'git://',
    full : 'git:///somerepo.git/?query=1#hash@tag'
  }
  var got = _.uriOld.parse( 'git:///somerepo.git/?query=1#hash@tag' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/git@bitbucket.org:someorg/somerepo.git',
    query : 'query=1',
    tag : 'tag',
    longPath : '/git@bitbucket.org:someorg/somerepo.git',
    postfixedPath : '/git@bitbucket.org:someorg/somerepo.git?query=1@tag',
    protocols : [ 'git' ],
    hostFull : '',
    origin : 'git://',
    full : 'git:///git@bitbucket.org:someorg/somerepo.git?query=1@tag'
  }
  var got = _.uriOld.parse( 'git:///git@bitbucket.org:someorg/somerepo.git?query=1@tag' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/git@bitbucket.org:someorg/somerepo.git/',
    query : 'query=1',
    tag : 'tag',
    longPath : '/git@bitbucket.org:someorg/somerepo.git/',
    postfixedPath : '/git@bitbucket.org:someorg/somerepo.git/?query=1@tag',
    protocols : [ 'git' ],
    hostFull : '',
    origin : 'git://',
    full : 'git:///git@bitbucket.org:someorg/somerepo.git/?query=1@tag'
  }
  var got = _.uriOld.parse( 'git:///git@bitbucket.org:someorg/somerepo.git/?query=1@tag' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/somerepo.git',
    query : 'query=1',
    tag : 'tag',
    longPath : '/somerepo.git',
    postfixedPath : '/somerepo.git?query=1@tag',
    protocols : [ 'git' ],
    hostFull : '',
    origin : 'git://',
    full : 'git:///somerepo.git?query=1@tag'
  }
  var got = _.uriOld.parse( 'git:///somerepo.git?query=1@tag' );
  test.identical( got, expected );


  var expected =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/somerepo.git/',
    query : 'query=1',
    tag : 'tag',
    longPath : '/somerepo.git/',
    postfixedPath : '/somerepo.git/?query=1@tag',
    protocols : [ 'git' ],
    hostFull : '',
    origin : 'git://',
    full : 'git:///somerepo.git/?query=1@tag'
  }
  var got = _.uriOld.parse( 'git:///somerepo.git/?query=1@tag' );
  test.identical( got, expected );
}

//

function parseAtomic( test )
{

  /* */

  test.case = 'query only';
  var remotePath = '?entry:1&format:null';
  var expected = { 'resourcePath' : '', 'query' : 'entry:1&format:null' }
  var got = _.uriOld.parseAtomic( remotePath );
  test.identical( got, expected );

  /* */

  test.case = 'global, relative, with hash, with query';
  var remotePath = 'git://../repo/Tools?out=out/wTools.out.will#master';
  var expected =
  {
    'protocol' : 'git',
    'host' : '..',
    'resourcePath' : '/repo/Tools',
    'query' : 'out=out/wTools.out.will',
    'hash' : 'master'
  }
  var got = _.uriOld.parseAtomic( remotePath );
  test.identical( got, expected );

  /* */

  test.case = 'global, absolute, with hash, with query';
  var remotePath = 'git:///../repo/Tools?out=out/wTools.out.will#master'
  var expected =
  {
    'protocol' : 'git',
    'host' : '',
    'resourcePath' : '/../repo/Tools',
    'query' : 'out=out/wTools.out.will',
    'hash' : 'master'
  }
  var got = _.uriOld.parseAtomic( remotePath );
  test.identical( got, expected );

  /* */

  test.case = 'query with equal';
  var remotePath = 'http://127.0.0.1:5000/a/b?q=3#anch';
  var expected =
  {
    'protocol' : 'http',
    'host' : '127.0.0.1',
    'port' : 5000,
    'resourcePath' : '/a/b',
    'query' : 'q=3',
    'hash' : 'anch'
  }
  var got = _.uriOld.parseAtomic( remotePath );
  test.identical( got, expected );

  /* */

  test.case = 'query with colon';
  var remotePath = 'http://127.0.0.1:5000/a/b?q:3#anch';
  var expected =
  {
    'protocol' : 'http',
    'host' : '127.0.0.1',
    'port' : 5000,
    'resourcePath' : '/a/b',
    'query' : 'q:3',
    'hash' : 'anch'
  }
  var got = _.uriOld.parseAtomic( remotePath );
  test.identical( got, expected );

  /* */

  test.case = 'no protocol';

  var uri = '127.0.0.1:61726/../path';

  var expected =
  {
    resourcePath : '127.0.0.1:61726/../path',
  }
  var got = _.uriOld.parseAtomic( uri );
  test.identical( got, expected );

  var expected =
  {
    resourcePath : '127.0.0.1:61726/../path'
  }

  var got = _.uriOld.parseAtomic( uri );
  test.identical( got, expected );

  /* */

  test.case = 'full uri with all components';

  var expected =
  {
    protocol : 'http',
    host : 'www.site.com',
    port : 13,
    resourcePath : '/path/name',
    query : 'query=here&and=here',
    hash : 'anchor',
  }

  var uri1 = 'http://www.site.com:13/path/name?query=here&and=here#anchor';
  var got = _.uriOld.parseAtomic( uri1 );
  test.identical( got, expected );

  /* */

  test.case = 'full uri with all components, primitiveOnly';

  var expected =
  {
    protocol : 'http',
    host : 'www.site.com',
    port : 13,
    resourcePath : '/path/name',
    query : 'query=here&and=here',
    hash : 'anchor',
  }

  var uri1 = 'http://www.site.com:13/path/name?query=here&and=here#anchor';
  var got = _.uriOld.parseAtomic( uri1 );
  test.identical( got, expected );

  test.case = 'reparse with non primitives';

  var expected =
  {
    protocol : 'http',
    host : 'www.site.com',
    port : 13,
    resourcePath : '/path/name',
    query : 'query=here&and=here',
    hash : 'anchor',
  }

  var parsed = got;
  var got = _.uriOld.parseAtomic( parsed );
  test.identical( got, expected );

  test.case = 'reparse with primitives';

  var uri1 = 'http://www.site.com:13/path/name?query=here&and=here#anchor';
  var expected =
  {
    protocol : 'http',
    host : 'www.site.com',
    port : 13,
    resourcePath : '/path/name',
    query : 'query=here&and=here',
    hash : 'anchor',
  }

  var got = _.uriOld.parseAtomic( uri1 );
  test.identical( got, expected );

  /* */

  test.case = 'uri with zero length protocol';

  var uri = '://some.domain.com/something/filePath/add';

  var expected =
  {
    protocol : '',
    host : 'some.domain.com',
    resourcePath : '/something/filePath/add',
  }

  var got = _.uriOld.parseAtomic( uri );
  test.identical( got, expected );

  /* */

  test.case = 'uri with zero length hostFull';

  var uri = 'file:///something/filePath/add';

  var expected =
  {
    protocol : 'file',
    host : '',
    resourcePath : '/something/filePath/add',
  }

  var got = _.uriOld.parseAtomic( uri );
  test.identical( got, expected );

  /* */

  test.case = 'uri with double protocol';

  var uri = 'svn+https://user@subversion.com/svn/trunk';

  var expected =
  {
    protocol : 'svn+https',
    host : 'user@subversion.com',
    resourcePath : '/svn/trunk',
  }

  var got = _.uriOld.parseAtomic( uri );
  test.identical( got, expected );

  /* */

  test.case = 'simple path';

  var uri = '/some/file';

  var expected =
  {
    resourcePath : '/some/file',
  }

  var got = _.uriOld.parseAtomic( uri );
  test.identical( got, expected );

  /* */

  test.case = 'without ":"';

  var uri = '//some.domain.com/was';
  var expected =
  {
    resourcePath : '//some.domain.com/was',
  }

  var got = _.uriOld.parseAtomic( uri );
  test.identical( got, expected );

  /* */

  test.case = 'with ":"';

  var uri = '://some.domain.com/was';
  var expected =
  {
    protocol : '',
    host : 'some.domain.com',
    resourcePath : '/was',
  }

  /* */

  test.case = 'with ":" and protocol';

  var uri = 'protocol://some.domain.com/was';
  var expected =
  {
    protocol : 'protocol',
    host : 'some.domain.com',
    resourcePath : '/was',
  }

  var got = _.uriOld.parseAtomic( uri );
  test.identical( got, expected );

  /* */

  test.case = 'simple path';

  var uri = '//';
  var expected =
  {
    resourcePath : '//',
  }

  var got = _.uriOld.parseAtomic( uri );
  test.identical( got, expected );

  var uri = '///';
  var expected =
  {
    resourcePath : '///',
  }

  var got = _.uriOld.parseAtomic( uri );
  test.identical( got, expected );

  var uri = '///a/b/c';
  var expected =
  {
    resourcePath : '///a/b/c',
  }

  var got = _.uriOld.parseAtomic( uri );
  test.identical( got, expected );

  test.case = 'complex';
  var uri = 'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor';
  var expected =
  {
    protocol : 'complex+protocol',
    host : 'www.site.com',
    port : 13,
    resourcePath : '/path/name',
    query : 'query=here&and=here',
    hash : 'anchor',
  }

  var got = _.uriOld.parseAtomic( uri );
  test.identical( got, expected );

  var uri = '://www.site.com:13/path//name//?query=here&and=here#anchor';
  var got = _.uriOld.parseAtomic( uri );
  var expected =
  {
    protocol : '',
    host : 'www.site.com',
    port : 13,
    resourcePath : '/path//name//',
    query : 'query=here&and=here',
    hash : 'anchor'
  }
  test.identical( got, expected );

  var uri = ':///www.site.com:13/path//name//?query=here&and=here#anchor';
  var got = _.uriOld.parseAtomic( uri );
  var expected =
  {
    protocol : '',
    host : '',
    resourcePath : '/www.site.com:13/path//name//',
    query : 'query=here&and=here',
    hash : 'anchor',
  }
  test.identical( got, expected );

  /* */

  var expected =
  {
    resourcePath : '///some.com:99/staging/index.html',
    query : 'query=here&and=here',
    hash : 'anchor',
  }
  var got = _.uriOld.parseAtomic( '///some.com:99/staging/index.html?query=here&and=here#anchor' );
  test.identical( got, expected );

  /*  */

  var expected =
  {
    host : 'git@bitbucket.org',
    port : 'someorg',
    resourcePath : '/somerepo.git',
    tag : 'tag',
    protocol : 'git',
  }
  var got = _.uriOld.parseAtomic( 'git://git@bitbucket.org:someorg/somerepo.git@tag' );
  test.identical( got, expected );

  /*  */

  var expected =
  {
    resourcePath : '/git',
    host : '',
    protocol : 'git',
    tag : 'bitbucket.org',
  }
  var got = _.uriOld.parseAtomic( 'git:///git@bitbucket.org' );
  test.identical( got, expected );

  var expected =
  {
    resourcePath : '/git@bitbucket.org',
    host : '',
    tag : 'tag',
    protocol : 'git',
  }
  var got = _.uriOld.parseAtomic( 'git:///git@bitbucket.org@tag' );
  test.identical( got, expected );

  var expected =
  {
    resourcePath : '/git@bitbucket.org/somerepo.git',
    host : '',
    tag : 'tag',
    protocol : 'git',
  }
  var got = _.uriOld.parseAtomic( 'git:///git@bitbucket.org/somerepo.git@tag' );
  test.identical( got, expected );

  var expected =
  {
    resourcePath : '/git@bitbucket.org:someorg/somerepo.git',
    host : '',
    tag : 'tag',
    protocol : 'git',
  }
  var got = _.uriOld.parseAtomic( 'git:///git@bitbucket.org:someorg/somerepo.git@tag' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/git@bitbucket.org:someorg/somerepo.git',
    hash : 'hash'
  }
  var got = _.uriOld.parseAtomic( 'git:///git@bitbucket.org:someorg/somerepo.git#hash' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/git@bitbucket.org:someorg/somerepo.git/',
    hash : 'hash'
  }
  var got = _.uriOld.parseAtomic( 'git:///git@bitbucket.org:someorg/somerepo.git/#hash' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/somerepo.git',
    hash : 'hash'
  }
  var got = _.uriOld.parseAtomic( 'git:///somerepo.git#hash' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/somerepo.git/',
    hash : 'hash'
  }
  var got = _.uriOld.parseAtomic( 'git:///somerepo.git/#hash' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/git@bitbucket.org:someorg/somerepo.git/',
    tag : 'tag',
  }
  var got = _.uriOld.parseAtomic( 'git:///git@bitbucket.org:someorg/somerepo.git/@tag' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/somerepo.git/',
    tag : 'tag',
  }
  var got = _.uriOld.parseAtomic( 'git:///somerepo.git/@tag' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/git@bitbucket.org:someorg/somerepo.git',
    hash : 'hash',
    tag : 'tag'
  }
  var got = _.uriOld.parseAtomic( 'git:///git@bitbucket.org:someorg/somerepo.git#hash@tag' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/git@bitbucket.org:someorg/somerepo.git/',
    hash : 'hash',
    tag : 'tag'
  }
  var got = _.uriOld.parseAtomic( 'git:///git@bitbucket.org:someorg/somerepo.git/#hash@tag' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/somerepo.git',
    hash : 'hash',
    tag : 'tag',
  }
  var got = _.uriOld.parseAtomic( 'git:///somerepo.git#hash@tag' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/somerepo.git/',
    hash : 'hash',
    tag : 'tag',
  }
  var got = _.uriOld.parseAtomic( 'git:///somerepo.git/#hash@tag' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/git@bitbucket.org:someorg/somerepo.git',
    query : 'query=1',
    hash : 'hash',
    tag : 'tag',
  }
  var got = _.uriOld.parseAtomic( 'git:///git@bitbucket.org:someorg/somerepo.git?query=1#hash@tag' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/git@bitbucket.org:someorg/somerepo.git/',
    query : 'query=1',
    hash : 'hash',
    tag : 'tag',
  }
  var got = _.uriOld.parseAtomic( 'git:///git@bitbucket.org:someorg/somerepo.git/?query=1#hash@tag' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/somerepo.git',
    query : 'query=1',
    hash : 'hash',
    tag : 'tag',
  }
  var got = _.uriOld.parseAtomic( 'git:///somerepo.git?query=1#hash@tag' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/somerepo.git/',
    query : 'query=1',
    hash : 'hash',
    tag : 'tag',
  }
  var got = _.uriOld.parseAtomic( 'git:///somerepo.git/?query=1#hash@tag' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/git@bitbucket.org:someorg/somerepo.git',
    query : 'query=1',
    tag : 'tag',
  }
  var got = _.uriOld.parseAtomic( 'git:///git@bitbucket.org:someorg/somerepo.git?query=1@tag' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/git@bitbucket.org:someorg/somerepo.git/',
    query : 'query=1',
    tag : 'tag',
  }
  var got = _.uriOld.parseAtomic( 'git:///git@bitbucket.org:someorg/somerepo.git/?query=1@tag' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/somerepo.git',
    query : 'query=1',
    tag : 'tag',
  }
  var got = _.uriOld.parseAtomic( 'git:///somerepo.git?query=1@tag' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/somerepo.git/',
    query : 'query=1',
    tag : 'tag',
  }
  var got = _.uriOld.parseAtomic( 'git:///somerepo.git/?query=1@tag' );
  test.identical( got, expected );

  // xxx
  // var expected =
  // {
  //   'protocol' : '',
  //   'host' : '"',
  //   'resourcePath' : '',
  //   'hash' : 'some"/"',
  //   'tag' : 'path"'
  // }
  // var got = _.uriOld.parseAtomic( '://"#some"/"@path"' );
  // test.identical( got, expected );

  /* - */

  if( !Config.debug )
  return;

  test.case = 'missed arguments';
  test.shouldThrowErrorSync( function()
  {
    _.uriOld.parseAtomic();
  });

  test.case = 'redundant argument';
  test.shouldThrowErrorSync( function()
  {
    _.uriOld.parseAtomic( 'http://www.site.com:13/path/name?query=here&and=here#anchor', '' );
  });

  test.case = 'argument is not string';
  test.shouldThrowErrorSync( function()
  {
    _.uriOld.parseAtomic( 34 );
  });

}

//

function parseConsecutive( test )
{

  /* */

  test.case = 'query only';
  var remotePath = '?entry:1&format:null';
  var expected =
  {
    'query' : 'entry:1&format:null',
    'longPath' : '',
    'postfixedPath' : '?entry:1&format:null',
  }
  var got = _.uriOld.parseConsecutive( remotePath );
  test.identical( got, expected );

  /* */

  test.case = 'global, relative, with hash, with query';
  var remotePath = 'git://../repo/Tools?out=out/wTools.out.will#master'
  var expected =
  {
    'protocol' : 'git',
    'query' : 'out=out/wTools.out.will',
    'hash' : 'master',
    'longPath' : '../repo/Tools',
    'postfixedPath' : '../repo/Tools?out=out/wTools.out.will#master'
  }
  var got = _.uriOld.parseConsecutive( remotePath );
  test.identical( got, expected );

  /* */

  test.case = 'global, absolute, with hash, with query';
  var remotePath = 'git:///../repo/Tools?out=out/wTools.out.will#master'
  var expected =
  {
    'protocol' : 'git',
    'query' : 'out=out/wTools.out.will',
    'hash' : 'master',
    'longPath' : '/../repo/Tools',
    'postfixedPath' : '/../repo/Tools?out=out/wTools.out.will#master'
  }
  var got = _.uriOld.parseConsecutive( remotePath );
  test.identical( got, expected );

  /* */

  test.case = 'query with equal';
  var remotePath = 'http://127.0.0.1:5000/a/b?q=3#anch';
  var expected =
  {
    'protocol' : 'http',
    'query' : 'q=3',
    'hash' : 'anch',
    'longPath' : '127.0.0.1:5000/a/b',
    'postfixedPath' : '127.0.0.1:5000/a/b?q=3#anch'
  }
  var got = _.uriOld.parseConsecutive( remotePath );
  test.identical( got, expected );

  /* */

  test.case = 'query with colon';
  var remotePath = 'http://127.0.0.1:5000/a/b?q:3#anch';
  var expected =
  {
    'protocol' : 'http',
    'query' : 'q:3',
    'hash' : 'anch',
    'longPath' : '127.0.0.1:5000/a/b',
    'postfixedPath' : '127.0.0.1:5000/a/b?q:3#anch'
  }
  var got = _.uriOld.parseConsecutive( remotePath );
  test.identical( got, expected );

  /* */

  test.case = 'no protocol';
  var uri = '127.0.0.1:61726/../path';
  var expected =
  {
    longPath : '127.0.0.1:61726/../path',
    postfixedPath : '127.0.0.1:61726/../path',
  }
  var got = _.uriOld.parseConsecutive( uri );
  test.identical( got, expected );

  var expected =
  {
    longPath : '127.0.0.1:61726/../path',
    postfixedPath : '127.0.0.1:61726/../path',
  }

  var got = _.uriOld.parseConsecutive( uri );
  test.identical( got, expected );

  /* */

  test.case = 'full uri with all components';

  var expected =
  {
    protocol : 'http',
    query : 'query=here&and=here',
    hash : 'anchor',
    longPath : 'www.site.com:13/path/name',
    postfixedPath : 'www.site.com:13/path/name?query=here&and=here#anchor',
  }

  var uri1 = 'http://www.site.com:13/path/name?query=here&and=here#anchor';
  var got = _.uriOld.parseConsecutive( uri1 );
  test.identical( got, expected );

  /* */

  test.case = 'full uri with all components, primitiveOnly';

  var expected =
  {
    protocol : 'http',
    longPath : 'www.site.com:13/path/name',
    postfixedPath : 'www.site.com:13/path/name?query=here&and=here#anchor',
    query : 'query=here&and=here',
    hash : 'anchor',
  }

  var uri1 = 'http://www.site.com:13/path/name?query=here&and=here#anchor';
  var got = _.uriOld.parseConsecutive( uri1 );
  test.identical( got, expected );

  test.case = 'reparse with non primitives';

  var expected =
  {
    protocol : 'http',
    query : 'query=here&and=here',
    hash : 'anchor',
    longPath : 'www.site.com:13/path/name',
    postfixedPath : 'www.site.com:13/path/name?query=here&and=here#anchor',
  }

  var parsed = got;
  var got = _.uriOld.parseConsecutive( parsed );
  test.identical( got, expected );

  test.case = 'reparse with primitives';

  var uri1 = 'http://www.site.com:13/path/name?query=here&and=here#anchor';
  var expected =
  {
    protocol : 'http',
    query : 'query=here&and=here',
    hash : 'anchor',
    longPath : 'www.site.com:13/path/name',
    postfixedPath : 'www.site.com:13/path/name?query=here&and=here#anchor',
  }

  var got = _.uriOld.parseConsecutive( uri1 );
  test.identical( got, expected );

  /* */

  test.case = 'uri with zero length protocol';

  var uri = '://some.domain.com/something/filePath/add';

  var expected =
  {
    protocol : '',
    longPath : 'some.domain.com/something/filePath/add',
    postfixedPath : 'some.domain.com/something/filePath/add',
  }

  var got = _.uriOld.parseConsecutive( uri );
  test.identical( got, expected );

  /* */

  test.case = 'uri with zero length hostFull';

  var uri = 'file:///something/filePath/add';

  var expected =
  {
    protocol : 'file',
    longPath : '/something/filePath/add',
    postfixedPath : '/something/filePath/add',
  }

  var got = _.uriOld.parseConsecutive( uri );
  test.identical( got, expected );

  /* */

  test.case = 'uri with double protocol';

  var uri = 'svn+https://user@subversion.com/svn/trunk';

  var expected =
  {
    protocol : 'svn+https',
    longPath : 'user@subversion.com/svn/trunk',
    postfixedPath : 'user@subversion.com/svn/trunk',
  }

  var got = _.uriOld.parseConsecutive( uri );
  test.identical( got, expected );

  /* */

  test.case = 'simple path';

  var uri = '/some/file';

  var expected =
  {
    longPath : '/some/file',
    postfixedPath : '/some/file',
  }

  var got = _.uriOld.parseConsecutive( uri );
  test.identical( got, expected );

  /* */

  test.case = 'without ":"';

  var uri = '//some.domain.com/was';
  var expected =
  {
    longPath : '//some.domain.com/was',
    postfixedPath : '//some.domain.com/was',
  }

  var got = _.uriOld.parseConsecutive( uri );
  test.identical( got, expected );

  /* */

  test.case = 'with ":"';

  var uri = '://some.domain.com/was';
  var expected =
  {
    protocol : '',
    host : 'some.domain.com',
    resourcePath : '/was',
    longPath : 'some.domain.com/was',
    postfixedPath : 'some.domain.com/was',
    protocols : [ '' ],
    hostFull : 'some.domain.com',
    origin : '://some.domain.com',
    full : '://some.domain.com/was'
  }

  /* */

  test.case = 'with ":" and protocol';

  var uri = 'protocol://some.domain.com/was';
  var expected =
  {
    protocol : 'protocol',
    longPath : 'some.domain.com/was',
    postfixedPath : 'some.domain.com/was',
  }

  var got = _.uriOld.parseConsecutive( uri );
  test.identical( got, expected );

  /* */

  test.case = 'simple path';

  var uri = '//';
  var expected =
  {
    longPath : '//',
    postfixedPath : '//',
  }

  var got = _.uriOld.parseConsecutive( uri );
  test.identical( got, expected );

  var uri = '///';
  var expected =
  {
    longPath : '///',
    postfixedPath : '///',
  }

  var got = _.uriOld.parseConsecutive( uri );
  test.identical( got, expected );

  var uri = '///a/b/c';
  var expected =
  {
    longPath : '///a/b/c',
    postfixedPath : '///a/b/c',
  }

  var got = _.uriOld.parseConsecutive( uri );
  test.identical( got, expected );

  test.case = 'complex';
  var uri = 'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor';
  var expected =
  {
    protocol : 'complex+protocol',
    query : 'query=here&and=here',
    hash : 'anchor',
    longPath : 'www.site.com:13/path/name',
    postfixedPath : 'www.site.com:13/path/name?query=here&and=here#anchor',
  }

  var got = _.uriOld.parseConsecutive( uri );
  test.identical( got, expected );

  var uri = '://www.site.com:13/path//name//?query=here&and=here#anchor';
  var got = _.uriOld.parseConsecutive( uri );
  var expected =
  {
    protocol : '',
    query : 'query=here&and=here',
    hash : 'anchor',
    longPath : 'www.site.com:13/path//name//',
    postfixedPath : 'www.site.com:13/path//name//?query=here&and=here#anchor',
  }
  test.identical( got, expected );

  var uri = '://www.site.com:13/path//name//?query=here&and=here#anchor';
  var got = _.uriOld.parseConsecutive( uri );
  var expected =
  {
    protocol : '',
    query : 'query=here&and=here',
    hash : 'anchor',
    longPath : 'www.site.com:13/path//name//',
    postfixedPath : 'www.site.com:13/path//name//?query=here&and=here#anchor',
  }
  test.identical( got, expected );

  var uri = ':///www.site.com:13/path//name//?query=here&and=here#anchor';
  var got = _.uriOld.parseConsecutive( uri );
  var expected =
  {
    protocol : '',
    query : 'query=here&and=here',
    hash : 'anchor',
    longPath : '/www.site.com:13/path//name//',
    postfixedPath : '/www.site.com:13/path//name//?query=here&and=here#anchor',
  }
  test.identical( got, expected );

  var uri = ':///www.site.com:13/path//name//?query=here&and=here#anchor';
  var got = _.uriOld.parseConsecutive( uri );
  var expected =
  {
    protocol : '',
    query : 'query=here&and=here',
    hash : 'anchor',
    longPath : '/www.site.com:13/path//name//',
    postfixedPath : '/www.site.com:13/path//name//?query=here&and=here#anchor',
  }
  test.identical( got, expected );

  /* */

  var expected =
  {
    query : 'query=here&and=here',
    hash : 'anchor',
    longPath : '///some.com:99/staging/index.html',
    postfixedPath : '///some.com:99/staging/index.html?query=here&and=here#anchor',
  }
  var got = _.uriOld.parseConsecutive( '///some.com:99/staging/index.html?query=here&and=here#anchor' );
  test.identical( got, expected );

  /*  */

  var expected =
  {
    protocol : 'git',
    longPath : '/git@bitbucket.org:someorg/somerepo.git',
    postfixedPath : '/git@bitbucket.org:someorg/somerepo.git@tag',
    tag : 'tag'
  }
  var got = _.uriOld.parseConsecutive( 'git:///git@bitbucket.org:someorg/somerepo.git@tag' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    longPath : '/git@bitbucket.org:someorg/somerepo.git',
    postfixedPath : '/git@bitbucket.org:someorg/somerepo.git#hash',
    hash : 'hash'
  }
  var got = _.uriOld.parseConsecutive( 'git:///git@bitbucket.org:someorg/somerepo.git#hash' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    hash : 'hash',
    longPath : '/git@bitbucket.org:someorg/somerepo.git/',
    postfixedPath : '/git@bitbucket.org:someorg/somerepo.git/#hash',
  }
  var got = _.uriOld.parseConsecutive( 'git:///git@bitbucket.org:someorg/somerepo.git/#hash' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    hash : 'hash',
    longPath : '/somerepo.git',
    postfixedPath : '/somerepo.git#hash',
  }
  var got = _.uriOld.parseConsecutive( 'git:///somerepo.git#hash' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    hash : 'hash',
    longPath : '/somerepo.git/',
    postfixedPath : '/somerepo.git/#hash',
  }
  var got = _.uriOld.parseConsecutive( 'git:///somerepo.git/#hash' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    tag : 'tag',
    longPath : '/git@bitbucket.org:someorg/somerepo.git/',
    postfixedPath : '/git@bitbucket.org:someorg/somerepo.git/@tag',
  }
  var got = _.uriOld.parseConsecutive( 'git:///git@bitbucket.org:someorg/somerepo.git/@tag' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    tag : 'tag',
    longPath : '/somerepo.git/',
    postfixedPath : '/somerepo.git/@tag',
  }
  var got = _.uriOld.parseConsecutive( 'git:///somerepo.git/@tag' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    hash : 'hash',
    tag : 'tag',
    longPath : '/git@bitbucket.org:someorg/somerepo.git',
    postfixedPath : '/git@bitbucket.org:someorg/somerepo.git#hash@tag',
  }
  var got = _.uriOld.parseConsecutive( 'git:///git@bitbucket.org:someorg/somerepo.git#hash@tag' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    hash : 'hash',
    tag : 'tag',
    longPath : '/git@bitbucket.org:someorg/somerepo.git/',
    postfixedPath : '/git@bitbucket.org:someorg/somerepo.git/#hash@tag',
  }
  var got = _.uriOld.parseConsecutive( 'git:///git@bitbucket.org:someorg/somerepo.git/#hash@tag' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    hash : 'hash',
    tag : 'tag',
    longPath : '/somerepo.git',
    postfixedPath : '/somerepo.git#hash@tag',
  }
  var got = _.uriOld.parseConsecutive( 'git:///somerepo.git#hash@tag' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    hash : 'hash',
    tag : 'tag',
    longPath : '/somerepo.git/',
    postfixedPath : '/somerepo.git/#hash@tag',
  }
  var got = _.uriOld.parseConsecutive( 'git:///somerepo.git/#hash@tag' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    query : 'query=1',
    hash : 'hash',
    tag : 'tag',
    longPath : '/git@bitbucket.org:someorg/somerepo.git',
    postfixedPath : '/git@bitbucket.org:someorg/somerepo.git?query=1#hash@tag',
  }
  var got = _.uriOld.parseConsecutive( 'git:///git@bitbucket.org:someorg/somerepo.git?query=1#hash@tag' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    query : 'query=1',
    hash : 'hash',
    tag : 'tag',
    longPath : '/git@bitbucket.org:someorg/somerepo.git/',
    postfixedPath : '/git@bitbucket.org:someorg/somerepo.git/?query=1#hash@tag',
  }
  var got = _.uriOld.parseConsecutive( 'git:///git@bitbucket.org:someorg/somerepo.git/?query=1#hash@tag' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    query : 'query=1',
    hash : 'hash',
    tag : 'tag',
    longPath : '/somerepo.git',
    postfixedPath : '/somerepo.git?query=1#hash@tag',
  }
  var got = _.uriOld.parseConsecutive( 'git:///somerepo.git?query=1#hash@tag' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    query : 'query=1',
    hash : 'hash',
    tag : 'tag',
    longPath : '/somerepo.git/',
    postfixedPath : '/somerepo.git/?query=1#hash@tag',
  }
  var got = _.uriOld.parseConsecutive( 'git:///somerepo.git/?query=1#hash@tag' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    query : 'query=1',
    tag : 'tag',
    longPath : '/git@bitbucket.org:someorg/somerepo.git',
    postfixedPath : '/git@bitbucket.org:someorg/somerepo.git?query=1@tag',
  }
  var got = _.uriOld.parseConsecutive( 'git:///git@bitbucket.org:someorg/somerepo.git?query=1@tag' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    query : 'query=1',
    tag : 'tag',
    longPath : '/git@bitbucket.org:someorg/somerepo.git/',
    postfixedPath : '/git@bitbucket.org:someorg/somerepo.git/?query=1@tag',
  }
  var got = _.uriOld.parseConsecutive( 'git:///git@bitbucket.org:someorg/somerepo.git/?query=1@tag' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    query : 'query=1',
    tag : 'tag',
    longPath : '/somerepo.git',
    postfixedPath : '/somerepo.git?query=1@tag',
  }
  var got = _.uriOld.parseConsecutive( 'git:///somerepo.git?query=1@tag' );
  test.identical( got, expected );


  var expected =
  {
    protocol : 'git',
    query : 'query=1',
    tag : 'tag',
    longPath : '/somerepo.git/',
    postfixedPath : '/somerepo.git/?query=1@tag',
  }
  var got = _.uriOld.parseConsecutive( 'git:///somerepo.git/?query=1@tag' );
  test.identical( got, expected );

  /* - */

  if( !Config.debug )
  return;

  test.case = 'missed arguments';
  test.shouldThrowErrorSync( function()
  {
    _.uriOld.parseConsecutive();
  });

  test.case = 'redundant argument';
  test.shouldThrowErrorSync( function()
  {
    _.uriOld.parseConsecutive( 'http://www.site.com:13/path/name?query=here&and=here#anchor', '' );
  });

  test.case = 'argument is not string';
  test.shouldThrowErrorSync( function()
  {
    _.uriOld.parseConsecutive( 34 );
  });

}

//

function parseFull( test )
{

  /* */

  test.case = 'query only';
  var remotePath = '?entry:1&format:null';
  var expected =
  {
    'resourcePath' : '',
    'query' : 'entry:1&format:null',
    'longPath' : '',
    'postfixedPath' : '?entry:1&format:null',
    'protocols' : [],
    'full' : '?entry:1&format:null'
  }
  var got = _.uriOld.parseFull( remotePath );
  test.identical( got, expected );

  /* */

  test.case = 'global, relative, with hash, with query';
  var remotePath = 'git://../repo/Tools?out=out/wTools.out.will#master'
  var expected =
  {
    'protocol' : 'git',
    'host' : '..',
    'resourcePath' : '/repo/Tools',
    'query' : 'out=out/wTools.out.will',
    'hash' : 'master',
    'longPath' : '../repo/Tools',
    'postfixedPath' : '../repo/Tools?out=out/wTools.out.will#master',
    'protocols' : [ 'git' ],
    'hostFull' : '..',
    'origin' : 'git://..',
    'full' : 'git://../repo/Tools?out=out/wTools.out.will#master'
  }
  var got = _.uriOld.parseFull( remotePath );
  test.identical( got, expected );

  /* */

  test.case = 'global, absolute, with hash, with query';
  var remotePath = 'git:///../repo/Tools?out=out/wTools.out.will#master'
  var expected =
  {
    'protocol' : 'git',
    'host' : '',
    'resourcePath' : '/../repo/Tools',
    'query' : 'out=out/wTools.out.will',
    'hash' : 'master',
    'longPath' : '/../repo/Tools',
    'postfixedPath' : '/../repo/Tools?out=out/wTools.out.will#master',
    'protocols' : [ 'git' ],
    'hostFull' : '',
    'origin' : 'git://',
    'full' : 'git:///../repo/Tools?out=out/wTools.out.will#master'
  }
  var got = _.uriOld.parseFull( remotePath );
  test.identical( got, expected );

  /* */

  test.case = 'query with equal';
  var remotePath = 'http://127.0.0.1:5000/a/b?q=3#anch';
  var expected =
  {
    'protocol' : 'http',
    'host' : '127.0.0.1',
    'port' : 5000,
    'resourcePath' : '/a/b',
    'query' : 'q=3',
    'hash' : 'anch',
    'longPath' : '127.0.0.1:5000/a/b',
    'postfixedPath' : '127.0.0.1:5000/a/b?q=3#anch',
    'protocols' : [ 'http' ],
    'hostFull' : '127.0.0.1:5000',
    'origin' : 'http://127.0.0.1:5000',
    'full' : 'http://127.0.0.1:5000/a/b?q=3#anch'
  }
  var got = _.uriOld.parseFull( remotePath );
  test.identical( got, expected );

  /* */

  test.case = 'query with colon';
  var remotePath = 'http://127.0.0.1:5000/a/b?q:3#anch';
  var expected =
  {
    'protocol' : 'http',
    'host' : '127.0.0.1',
    'port' : 5000,
    'resourcePath' : '/a/b',
    'query' : 'q:3',
    'hash' : 'anch',
    'longPath' : '127.0.0.1:5000/a/b',
    'postfixedPath' : '127.0.0.1:5000/a/b?q:3#anch',
    'protocols' : [ 'http' ],
    'hostFull' : '127.0.0.1:5000',
    'origin' : 'http://127.0.0.1:5000',
    'full' : 'http://127.0.0.1:5000/a/b?q:3#anch'
  }
  var got = _.uriOld.parseFull( remotePath );
  test.identical( got, expected );

  /* */

  test.case = 'no protocol';
  var uri = '127.0.0.1:61726/../path';
  var expected =
  {
    resourcePath : '127.0.0.1:61726/../path',
    longPath : '127.0.0.1:61726/../path',
    postfixedPath : '127.0.0.1:61726/../path',
    protocols : [],
    full : '127.0.0.1:61726/../path'
  }
  var got = _.uriOld.parseFull( uri );
  test.identical( got, expected );

  var expected =
  {
    'resourcePath' : '127.0.0.1:61726/../path',
    'longPath' : '127.0.0.1:61726/../path',
    'postfixedPath' : '127.0.0.1:61726/../path',
    'protocols' : [],
    'full' : '127.0.0.1:61726/../path'
  }
  var got = _.uriOld.parseFull( uri );
  test.identical( got, expected );

  /* */

  test.case = 'full uri with all components';

  var expected =
  {
    protocol : 'http',
    host : 'www.site.com',
    port : 13,
    resourcePath : '/path/name',
    query : 'query=here&and=here',
    hash : 'anchor',
    longPath : 'www.site.com:13/path/name',
    postfixedPath : 'www.site.com:13/path/name?query=here&and=here#anchor',
    protocols : [ 'http' ],
    hostFull : 'www.site.com:13',
    origin : 'http://www.site.com:13',
    full : 'http://www.site.com:13/path/name?query=here&and=here#anchor',
  }

  var uri1 = 'http://www.site.com:13/path/name?query=here&and=here#anchor';
  var got = _.uriOld.parseFull( uri1 );
  test.identical( got, expected );

  /* */

  test.case = 'full uri with all components, primitiveOnly';

  var expected =
  {
    'protocol' : 'http',
    'host' : 'www.site.com',
    'port' : 13,
    'resourcePath' : '/path/name',
    'query' : 'query=here&and=here',
    'hash' : 'anchor',
    'longPath' : 'www.site.com:13/path/name',
    'postfixedPath' : 'www.site.com:13/path/name?query=here&and=here#anchor',
    'protocols' : [ 'http' ],
    'hostFull' : 'www.site.com:13',
    'origin' : 'http://www.site.com:13',
    'full' : 'http://www.site.com:13/path/name?query=here&and=here#anchor'
  }
  var uri1 = 'http://www.site.com:13/path/name?query=here&and=here#anchor';
  var got = _.uriOld.parseFull( uri1 );
  test.identical( got, expected );

  test.case = 'reparse with non primitives';

  var expected =
  {
    protocol : 'http',
    host : 'www.site.com',
    port : 13,
    resourcePath : '/path/name',
    query : 'query=here&and=here',
    hash : 'anchor',

    longPath : 'www.site.com:13/path/name',
    postfixedPath : 'www.site.com:13/path/name?query=here&and=here#anchor',
    protocols : [ 'http' ],
    hostFull : 'www.site.com:13',
    origin : 'http://www.site.com:13',
    full : 'http://www.site.com:13/path/name?query=here&and=here#anchor',
  }

  var parsed = got;
  var got = _.uriOld.parseFull( parsed );
  test.identical( got, expected );

  test.case = 'reparse with primitives';

  var uri1 = 'http://www.site.com:13/path/name?query=here&and=here#anchor';
  var expected =
  {
    'protocol' : 'http',
    'host' : 'www.site.com',
    'port' : 13,
    'resourcePath' : '/path/name',
    'query' : 'query=here&and=here',
    'hash' : 'anchor',
    'longPath' : 'www.site.com:13/path/name',
    'postfixedPath' : 'www.site.com:13/path/name?query=here&and=here#anchor',
    'protocols' : [ 'http' ],
    'hostFull' : 'www.site.com:13',
    'origin' : 'http://www.site.com:13',
    'full' : 'http://www.site.com:13/path/name?query=here&and=here#anchor'
  }
  var got = _.uriOld.parseFull( uri1 );
  test.identical( got, expected );

  /* */

  test.case = 'uri with zero length protocol';

  var uri = '://some.domain.com/something/filePath/add';

  var expected =
  {
    protocol : '',
    host : 'some.domain.com',
    resourcePath : '/something/filePath/add',
    longPath : 'some.domain.com/something/filePath/add',
    postfixedPath : 'some.domain.com/something/filePath/add',
    protocols : [],
    hostFull : 'some.domain.com',
    origin : '://some.domain.com',
    full : '://some.domain.com/something/filePath/add',
  }

  var got = _.uriOld.parseFull( uri );
  test.identical( got, expected );

  /* */

  test.case = 'uri with zero length hostFull';

  var uri = 'file:///something/filePath/add';

  var expected =
  {
    protocol : 'file',
    host : '',
    resourcePath : '/something/filePath/add',
    longPath : '/something/filePath/add',
    postfixedPath : '/something/filePath/add',
    protocols : [ 'file' ],
    hostFull : '',
    origin : 'file://',
    full : 'file:///something/filePath/add',
  }

  var got = _.uriOld.parseFull( uri );
  test.identical( got, expected );

  /* */

  test.case = 'uri with double protocol';

  var uri = 'svn+https://user@subversion.com/svn/trunk';

  var expected =
  {
    protocol : 'svn+https',
    host : 'user@subversion.com',
    resourcePath : '/svn/trunk',
    longPath : 'user@subversion.com/svn/trunk',
    postfixedPath : 'user@subversion.com/svn/trunk',
    protocols : [ 'svn', 'https' ],
    hostFull : 'user@subversion.com',
    origin : 'svn+https://user@subversion.com',
    full : 'svn+https://user@subversion.com/svn/trunk',
  }

  var got = _.uriOld.parseFull( uri );
  test.identical( got, expected );

  /* */

  test.case = 'simple path';

  var uri = '/some/file';

  var expected =
  {
    resourcePath : '/some/file',
    longPath : '/some/file',
    postfixedPath : '/some/file',
    protocols : [],
    full : '/some/file',
  }

  var got = _.uriOld.parseFull( uri );
  test.identical( got, expected );

  /* */

  test.case = 'without ":"';

  var uri = '//some.domain.com/was';
  var expected =
  {
    resourcePath : '//some.domain.com/was',
    longPath : '//some.domain.com/was',
    postfixedPath : '//some.domain.com/was',
    protocols : [],
    full : '//some.domain.com/was'
  }

  var got = _.uriOld.parseFull( uri );
  test.identical( got, expected );

  /* */

  test.case = 'with ":"';

  var uri = '://some.domain.com/was';
  var expected =
  {
    protocol : '',
    host : 'some.domain.com',
    resourcePath : '/was',
    longPath : 'some.domain.com/was',
    postfixedPath : 'some.domain.com/was',
    protocols : [ '' ],
    hostFull : 'some.domain.com',
    origin : '://some.domain.com',
    full : '://some.domain.com/was'
  }

  /* */

  test.case = 'with ":" and protocol';

  var uri = 'protocol://some.domain.com/was';
  var expected =
  {
    protocol : 'protocol',
    host : 'some.domain.com',
    resourcePath : '/was',
    longPath : 'some.domain.com/was',
    postfixedPath : 'some.domain.com/was',
    protocols : [ 'protocol' ],
    hostFull : 'some.domain.com',
    origin : 'protocol://some.domain.com',
    full : 'protocol://some.domain.com/was'
  }

  var got = _.uriOld.parseFull( uri );
  test.identical( got, expected );

  /* */

  test.case = 'simple path';

  var uri = '//';
  var expected =
  {
    resourcePath : '//',
    longPath : '//',
    postfixedPath : '//',
    protocols : [],
    full : '//'
  }

  var got = _.uriOld.parseFull( uri );
  test.identical( got, expected );

  var uri = '///';
  var expected =
  {
    resourcePath : '///',
    longPath : '///',
    postfixedPath : '///',
    protocols : [],
    full : '///'
  }

  var got = _.uriOld.parseFull( uri );
  test.identical( got, expected );

  var uri = '///a/b/c';
  var expected =
  {
    resourcePath : '///a/b/c',
    longPath : '///a/b/c',
    postfixedPath : '///a/b/c',
    protocols : [],
    full : '///a/b/c'
  }

  var got = _.uriOld.parseFull( uri );
  test.identical( got, expected );

  test.case = 'complex';
  var uri = 'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor';
  var expected =
  {
    protocol : 'complex+protocol',
    host : 'www.site.com',
    port : 13,
    resourcePath : '/path/name',
    query : 'query=here&and=here',
    hash : 'anchor',
    longPath : 'www.site.com:13/path/name',
    postfixedPath : 'www.site.com:13/path/name?query=here&and=here#anchor',
    protocols : [ 'complex', 'protocol' ],
    hostFull : 'www.site.com:13',
    origin : 'complex+protocol://www.site.com:13',
    full : uri,
  }

  var got = _.uriOld.parseFull( uri );
  test.identical( got, expected );

  var uri = '://www.site.com:13/path//name//?query=here&and=here#anchor';
  var got = _.uriOld.parseFull( uri );
  var expected =
  {
    protocol : '',
    host : 'www.site.com',
    port : 13,
    resourcePath : '/path//name//',
    query : 'query=here&and=here',
    hash : 'anchor',
    longPath : 'www.site.com:13/path//name//',
    postfixedPath : 'www.site.com:13/path//name//?query=here&and=here#anchor',
    protocols : [],
    hostFull : 'www.site.com:13',
    origin : '://www.site.com:13',
    full : uri,
  }
  test.identical( got, expected );

  var uri = '://www.site.com:13/path//name//?query=here&and=here#anchor';
  var got = _.uriOld.parseFull( uri );
  var expected =
  {
    'protocol' : '',
    'host' : 'www.site.com',
    'port' : 13,
    'resourcePath' : '/path//name//',
    'query' : 'query=here&and=here',
    'hash' : 'anchor',
    'longPath' : 'www.site.com:13/path//name//',
    'postfixedPath' : 'www.site.com:13/path//name//?query=here&and=here#anchor',
    'protocols' : [],
    'hostFull' : 'www.site.com:13',
    'origin' : '://www.site.com:13',
    'full' : '://www.site.com:13/path//name//?query=here&and=here#anchor'
  }
  test.identical( got, expected );

  var uri = ':///www.site.com:13/path//name//?query=here&and=here#anchor';
  var got = _.uriOld.parseFull( uri );
  var expected =
  {
    protocol : '',
    host : '',
    resourcePath : '/www.site.com:13/path//name//',
    query : 'query=here&and=here',
    hash : 'anchor',
    protocols : [],
    hostFull : '',
    origin : '://',
    full : uri,
    longPath : '/www.site.com:13/path//name//',
    postfixedPath : '/www.site.com:13/path//name//?query=here&and=here#anchor',
  }
  test.identical( got, expected );

  var uri = ':///www.site.com:13/path//name//?query=here&and=here#anchor';
  var got = _.uriOld.parseFull( uri );
  var expected =
  {
    'protocol' : '',
    'host' : '',
    'resourcePath' : '/www.site.com:13/path//name//',
    'query' : 'query=here&and=here',
    'hash' : 'anchor',
    'longPath' : '/www.site.com:13/path//name//',
    'postfixedPath' : '/www.site.com:13/path//name//?query=here&and=here#anchor',
    'protocols' : [],
    'hostFull' : '',
    'origin' : '://',
    'full' : ':///www.site.com:13/path//name//?query=here&and=here#anchor'
  }
  test.identical( got, expected );

  /* */

  var expected =
  {
    resourcePath : '///some.com:99/staging/index.html',
    query : 'query=here&and=here',
    hash : 'anchor',
    longPath : '///some.com:99/staging/index.html',
    postfixedPath : '///some.com:99/staging/index.html?query=here&and=here#anchor',
    protocols : [],
    full : '///some.com:99/staging/index.html?query=here&and=here#anchor',
  }
  var got = _.uriOld.parseFull( '///some.com:99/staging/index.html?query=here&and=here#anchor' );
  test.identical( got, expected );

  /* */

  var expected =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/git@bitbucket.org:someorg/somerepo.git',
    longPath : '/git@bitbucket.org:someorg/somerepo.git',
    postfixedPath : '/git@bitbucket.org:someorg/somerepo.git@tag',
    protocols : [ 'git' ],
    hostFull : '',
    tag : 'tag',
    origin : 'git://',
    full : 'git:///git@bitbucket.org:someorg/somerepo.git@tag'
  }
  var got = _.uriOld.parseFull( 'git:///git@bitbucket.org:someorg/somerepo.git@tag' );
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
  var got = _.uriOld.parseFull( 'git:///git@bitbucket.org:someorg/somerepo.git#hash' );
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
  var got = _.uriOld.parseFull( 'git:///git@bitbucket.org:someorg/somerepo.git/#hash' );
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
  var got = _.uriOld.parseFull( 'git:///somerepo.git#hash' );
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
  var got = _.uriOld.parseFull( 'git:///somerepo.git/#hash' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/git@bitbucket.org:someorg/somerepo.git/',
    tag : 'tag',
    longPath : '/git@bitbucket.org:someorg/somerepo.git/',
    postfixedPath : '/git@bitbucket.org:someorg/somerepo.git/@tag',
    protocols : [ 'git' ],
    hostFull : '',
    origin : 'git://',
    full : 'git:///git@bitbucket.org:someorg/somerepo.git/@tag'
  }
  var got = _.uriOld.parseFull( 'git:///git@bitbucket.org:someorg/somerepo.git/@tag' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/somerepo.git/',
    tag : 'tag',
    longPath : '/somerepo.git/',
    postfixedPath : '/somerepo.git/@tag',
    protocols : [ 'git' ],
    hostFull : '',
    origin : 'git://',
    full : 'git:///somerepo.git/@tag'
  }
  var got = _.uriOld.parseFull( 'git:///somerepo.git/@tag' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/git@bitbucket.org:someorg/somerepo.git',
    hash : 'hash',
    tag : 'tag',
    longPath : '/git@bitbucket.org:someorg/somerepo.git',
    postfixedPath : '/git@bitbucket.org:someorg/somerepo.git#hash@tag',
    protocols : [ 'git' ],
    hostFull : '',
    origin : 'git://',
    full : 'git:///git@bitbucket.org:someorg/somerepo.git#hash@tag'
  }
  var got = _.uriOld.parseFull( 'git:///git@bitbucket.org:someorg/somerepo.git#hash@tag' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/git@bitbucket.org:someorg/somerepo.git/',
    hash : 'hash',
    tag : 'tag',
    longPath : '/git@bitbucket.org:someorg/somerepo.git/',
    postfixedPath : '/git@bitbucket.org:someorg/somerepo.git/#hash@tag',
    protocols : [ 'git' ],
    hostFull : '',
    origin : 'git://',
    full : 'git:///git@bitbucket.org:someorg/somerepo.git/#hash@tag'
  }
  var got = _.uriOld.parseFull( 'git:///git@bitbucket.org:someorg/somerepo.git/#hash@tag' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/somerepo.git',
    hash : 'hash',
    tag : 'tag',
    longPath : '/somerepo.git',
    postfixedPath : '/somerepo.git#hash@tag',
    protocols : [ 'git' ],
    hostFull : '',
    origin : 'git://',
    full : 'git:///somerepo.git#hash@tag'
  }
  var got = _.uriOld.parseFull( 'git:///somerepo.git#hash@tag' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/somerepo.git/',
    hash : 'hash',
    tag : 'tag',
    longPath : '/somerepo.git/',
    postfixedPath : '/somerepo.git/#hash@tag',
    protocols : [ 'git' ],
    hostFull : '',
    origin : 'git://',
    full : 'git:///somerepo.git/#hash@tag'
  }
  var got = _.uriOld.parseFull( 'git:///somerepo.git/#hash@tag' );
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
    postfixedPath : '/git@bitbucket.org:someorg/somerepo.git?query=1#hash@tag',
    protocols : [ 'git' ],
    hostFull : '',
    origin : 'git://',
    full : 'git:///git@bitbucket.org:someorg/somerepo.git?query=1#hash@tag'
  }
  var got = _.uriOld.parseFull( 'git:///git@bitbucket.org:someorg/somerepo.git?query=1#hash@tag' );
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
    postfixedPath : '/git@bitbucket.org:someorg/somerepo.git/?query=1#hash@tag',
    protocols : [ 'git' ],
    hostFull : '',
    origin : 'git://',
    full : 'git:///git@bitbucket.org:someorg/somerepo.git/?query=1#hash@tag'
  }
  var got = _.uriOld.parseFull( 'git:///git@bitbucket.org:someorg/somerepo.git/?query=1#hash@tag' );
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
    postfixedPath : '/somerepo.git?query=1#hash@tag',
    protocols : [ 'git' ],
    hostFull : '',
    origin : 'git://',
    full : 'git:///somerepo.git?query=1#hash@tag'
  }
  var got = _.uriOld.parseFull( 'git:///somerepo.git?query=1#hash@tag' );
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
    postfixedPath : '/somerepo.git/?query=1#hash@tag',
    protocols : [ 'git' ],
    hostFull : '',
    origin : 'git://',
    full : 'git:///somerepo.git/?query=1#hash@tag'
  }
  var got = _.uriOld.parseFull( 'git:///somerepo.git/?query=1#hash@tag' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/git@bitbucket.org:someorg/somerepo.git',
    query : 'query=1',
    tag : 'tag',
    longPath : '/git@bitbucket.org:someorg/somerepo.git',
    postfixedPath : '/git@bitbucket.org:someorg/somerepo.git?query=1@tag',
    protocols : [ 'git' ],
    hostFull : '',
    origin : 'git://',
    full : 'git:///git@bitbucket.org:someorg/somerepo.git?query=1@tag'
  }
  var got = _.uriOld.parseFull( 'git:///git@bitbucket.org:someorg/somerepo.git?query=1@tag' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/git@bitbucket.org:someorg/somerepo.git/',
    query : 'query=1',
    tag : 'tag',
    longPath : '/git@bitbucket.org:someorg/somerepo.git/',
    postfixedPath : '/git@bitbucket.org:someorg/somerepo.git/?query=1@tag',
    protocols : [ 'git' ],
    hostFull : '',
    origin : 'git://',
    full : 'git:///git@bitbucket.org:someorg/somerepo.git/?query=1@tag'
  }
  var got = _.uriOld.parseFull( 'git:///git@bitbucket.org:someorg/somerepo.git/?query=1@tag' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/somerepo.git',
    query : 'query=1',
    tag : 'tag',
    longPath : '/somerepo.git',
    postfixedPath : '/somerepo.git?query=1@tag',
    protocols : [ 'git' ],
    hostFull : '',
    origin : 'git://',
    full : 'git:///somerepo.git?query=1@tag'
  }
  var got = _.uriOld.parseFull( 'git:///somerepo.git?query=1@tag' );
  test.identical( got, expected );


  var expected =
  {
    protocol : 'git',
    host : '',
    resourcePath : '/somerepo.git/',
    query : 'query=1',
    tag : 'tag',
    longPath : '/somerepo.git/',
    postfixedPath : '/somerepo.git/?query=1@tag',
    protocols : [ 'git' ],
    hostFull : '',
    origin : 'git://',
    full : 'git:///somerepo.git/?query=1@tag'
  }
  var got = _.uriOld.parseFull( 'git:///somerepo.git/?query=1@tag' );
  test.identical( got, expected );

  /* - */

  if( !Config.debug )
  return;

  test.case = 'missed arguments';
  test.shouldThrowErrorSync( function()
  {
    _.uriOld.parseFull();
  });

  test.case = 'redundant argument';
  test.shouldThrowErrorSync( function()
  {
    _.uriOld.parseFull( 'http://www.site.com:13/path/name?query=here&and=here#anchor', '' );
  });

  test.case = 'argument is not string';
  test.shouldThrowErrorSync( function()
  {
    _.uriOld.parseFull( 34 );
  });

}

//

function parseGlob( test )
{

  test.open( 'local path' );

  var src = '!a.js';
  var got = _.uriOld.parseFull( src );
  var expected = { resourcePath : src, longPath : src };
  test.contains( got, expected );

  var src = '/a/!a.js';
  var got = _.uriOld.parseFull( src );
  var expected = { resourcePath : src, longPath : src };
  test.contains( got, expected );

  var src = '/a/!a.js';
  var got = _.uriOld.parseFull( src );
  var expected = { resourcePath : src, longPath : src };
  test.contains( got, expected );

  var src = '/a/^a.js';
  var got = _.uriOld.parseFull( src );
  var expected = { resourcePath : src, longPath : src };
  test.contains( got, expected );

  var src = '/a/+a.js';
  var got = _.uriOld.parseFull( src );
  var expected = { resourcePath : src, longPath : src };
  test.contains( got, expected );

  var src = '/a/!';
  var got = _.uriOld.parseFull( src );
  var expected = { resourcePath : src, longPath : src };
  test.contains( got, expected );

  var src = '/a/???abc';
  var got = _.uriOld.parseFull( src );
  var expected = { resourcePath : src, longPath : src };
  test.contains( got, expected );

  var src = '/a/???abc#';
  var got = _.uriOld.parseFull( src );
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
  var got = _.uriOld.parseFull( src );
  var expected = { resourcePath : src, longPath : src };
  test.contains( got, expected );

  var src = '/a/+';
  var got = _.uriOld.parseFull( src );
  var expected = { resourcePath : src, longPath : src };
  test.contains( got, expected );

  var src = '?';
  var got = _.uriOld.parseFull( src );
  var expected = { resourcePath : src, longPath : src };
  test.contains( got, expected );

  var src = '*';
  var got = _.uriOld.parseFull( src );
  var expected = { resourcePath : src, longPath : src };
  test.contains( got, expected );

  var src = '**';
  var got = _.uriOld.parseFull( src );
  var expected = { resourcePath : src, longPath : src };
  test.contains( got, expected );

  var src = '?c.js';
  var got = _.uriOld.parseFull( src );
  var expected = { resourcePath : src, longPath : src };
  test.contains( got, expected );

  var src = '*.js';
  var got = _.uriOld.parseFull( src );
  var expected = { resourcePath : src, longPath : src };
  test.contains( got, expected );

  var src = '**/a.js';
  var got = _.uriOld.parseFull( src );
  var expected = { resourcePath : src, longPath : src };
  test.contains( got, expected );

  var src = 'dir?c/a.js';
  var got = _.uriOld.parseFull( src );
  var expected = { resourcePath : src, longPath : src };
  test.contains( got, expected );

  var src = 'dir/*.js';
  var got = _.uriOld.parseFull( src );
  var expected = { resourcePath : src, longPath : src };
  test.contains( got, expected );

  var src = 'dir/**.js';
  var got = _.uriOld.parseFull( src );
  var expected = { resourcePath : src, longPath : src };
  test.contains( got, expected );

  var src = 'dir/**/a.js';
  var got = _.uriOld.parseFull( src );
  var expected = { resourcePath : src, longPath : src };
  test.contains( got, expected );

  var src = '/dir?c/a.js';
  var got = _.uriOld.parseFull( src );
  var expected = { resourcePath : src, longPath : src };
  test.contains( got, expected );

  var src = '/dir/*.js';
  var got = _.uriOld.parseFull( src );
  var expected = { resourcePath : src, longPath : src };
  test.contains( got, expected );

  var src = '/dir/**.js';
  var got = _.uriOld.parseFull( src );
  var expected = { resourcePath : src, longPath : src };
  test.contains( got, expected );

  var src = '/dir/**/a.js';
  var got = _.uriOld.parseFull( src );
  var expected = { resourcePath : src, longPath : src };
  test.contains( got, expected );

  var src = '[a-c]';
  var got = _.uriOld.parseFull( src );
  var expected = { resourcePath : src, longPath : src };
  test.contains( got, expected );

  var src = '{a,c}';
  var got = _.uriOld.parseFull( src );
  var expected = { resourcePath : src, longPath : src };
  test.contains( got, expected );

  var src = '(a|b)';
  var got = _.uriOld.parseFull( src );
  var expected = { resourcePath : src, longPath : src };
  test.contains( got, expected );

  var src = '(ab)';
  var got = _.uriOld.parseFull( src );
  var expected = { resourcePath : src, longPath : src };
  test.contains( got, expected );

  var src = '@(ab)';
  var got = _.uriOld.parseFull( src );
  var expected = { resourcePath : src, longPath : src };
  test.contains( got, expected );

  var src = '!(ab)';
  var got = _.uriOld.parseFull( src );
  var expected = { resourcePath : src, longPath : src };
  test.contains( got, expected );

  var src = '?(ab)';
  var got = _.uriOld.parseFull( src );
  var expected = { resourcePath : src, longPath : src };
  test.contains( got, expected );

  var src = '*(ab)';
  var got = _.uriOld.parseFull( src );
  var expected = { resourcePath : src, longPath : src };
  test.contains( got, expected );

  var src = '+(ab)';
  var got = _.uriOld.parseFull( src );
  var expected = { resourcePath : src, longPath : src };
  test.contains( got, expected );

  var src = 'dir/[a-c].js';
  var got = _.uriOld.parseFull( src );
  var expected = { resourcePath : src, longPath : src };
  test.contains( got, expected );

  var src = 'dir/{a,c}.js';
  var got = _.uriOld.parseFull( src );
  var expected = { resourcePath : src, longPath : src };
  test.contains( got, expected );

  var src = 'dir/(a|b).js';
  var got = _.uriOld.parseFull( src );
  var expected = { resourcePath : src, longPath : src };
  test.contains( got, expected );

  var src = 'dir/(ab).js';
  var got = _.uriOld.parseFull( src );
  var expected = { resourcePath : src, longPath : src };
  test.contains( got, expected );

  var src = 'dir/@(ab).js';
  var got = _.uriOld.parseFull( src );
  var expected =
  {
    resourcePath : 'dir/',
    tag : '(ab).js',
    longPath : 'dir/',
    full : src
  }
  test.contains( got, expected );

  var src = 'dir/!(ab).js';
  var got = _.uriOld.parseFull( src );
  var expected = { resourcePath : src, longPath : src };
  test.contains( got, expected );

  var src = 'dir/?(ab).js';
  var got = _.uriOld.parseFull( src );
  var expected = { resourcePath : src, longPath : src };
  test.contains( got, expected );

  var src = 'dir/*(ab).js';
  var got = _.uriOld.parseFull( src );
  var expected = { resourcePath : src, longPath : src };
  test.contains( got, expected );

  var src = 'dir/+(ab).js';
  var got = _.uriOld.parseFull( src );
  var expected = { resourcePath : src, longPath : src };
  test.contains( got, expected );

  var src = '/index/**';
  var got = _.uriOld.parseFull( src );
  var expected = { resourcePath : src, longPath : src };
  test.contains( got, expected );

  test.close( 'local path' );

  /* */

  test.open( 'complex uri' );

  var src = '/!a.js?';
  var uri = 'complex+protocol://www.site.com:13/!a.js??query=here&and=here#anchor';
  var got = _.uriOld.parseFull( uri );
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
  var got = _.uriOld.parseFull( uri );
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
  var got = _.uriOld.parseFull( uri );
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
  var got = _.uriOld.parseFull( uri );
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
  var got = _.uriOld.parseFull( uri );
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
  var got = _.uriOld.parseFull( uri );
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
  var got = _.uriOld.parseFull( uri );
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
  var got = _.uriOld.parseFull( uri );
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
  var got = _.uriOld.parseFull( uri );
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
  var got = _.uriOld.parseFull( uri );
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
  var got = _.uriOld.parseFull( uri );
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
  var got = _.uriOld.parseFull( uri );
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
  var got = _.uriOld.parseFull( uri );
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
  var got = _.uriOld.parseFull( uri );
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
  var got = _.uriOld.parseFull( uri );
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
  var got = _.uriOld.parseFull( uri );
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
  var got = _.uriOld.parseFull( uri );
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
  var got = _.uriOld.parseFull( uri );
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
  var got = _.uriOld.parseFull( uri );
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
  var got = _.uriOld.parseFull( uri );
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
  var got = _.uriOld.parseFull( uri );
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
  var got = _.uriOld.parseFull( uri );
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
  var got = _.uriOld.parseFull( uri );
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
  var got = _.uriOld.parseFull( uri );
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
  var got = _.uriOld.parseFull( uri );
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
  var got = _.uriOld.parseFull( uri );
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
  var got = _.uriOld.parseFull( uri );
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
  var got = _.uriOld.parseFull( uri );
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
  var got = _.uriOld.parseFull( uri );
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
  var got = _.uriOld.parseFull( uri );
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
  var got = _.uriOld.parseFull( uri );
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
  var got = _.uriOld.parseFull( uri );
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
  var got = _.uriOld.parseFull( uri );
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
  var got = _.uriOld.parseFull( uri );
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
  var got = _.uriOld.parseFull( uri );
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
  var got = _.uriOld.parseFull( uri );
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
  var got = _.uriOld.parseFull( uri );
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

//

function parseTagExperiment( test )
{

  var exp =
  {
    'protocol' : 'git',
    'host' : '',
    'resourcePath' : '/git@bitbucket.org:org/repo.git/some/long/path',
    'hash' : 'master',
    'longPath' : '/git@bitbucket.org:org/repo.git/some/long/path',
    'postfixedPath' : '/git@bitbucket.org:org/repo.git/some/long/path',
    'protocols' : [ 'git' ],
    'hostFull' : '',
    'origin' : 'git://',
    'full' : 'git:///git@bitbucket.org:org/repo.git/some/long/path#master'
  }
  var got =_.uriOld.parseFull( 'git:///git@bitbucket.org:org/repo.git/some/long/path#master' );
  test.identical( got, exp );

  var exp =
  {
    'protocol' : 'git',
    'host' : '',
    'resourcePath' : '/git@bitbucket.org:org/repo.git/some/long/path',
    'tag' : 'master',
    'longPath' : '/git@bitbucket.org:org/repo.git/some/long/path',
    'postfixedPath' : '/git@bitbucket.org:org/repo.git/some/long/path',
    'protocols' : [ 'git' ],
    'hostFull' : '',
    'origin' : 'git://',
    'full' : 'git:///git@bitbucket.org:org/repo.git/some/long/path#master'
  }
  var got =_.uriOld.parseFull( 'git:///git@bitbucket.org:org/repo.git/some/long/path@master' );
  test.identical( got, exp );
}

parseTagExperiment.experimental = 1;

//

function localFromGlobal( test )
{
  var src = '/some/staging/index.html'
  var expected = '/some/staging/index.html'
  var got = _.uriOld.localFromGlobal( src );
  test.identical( got, expected );

  var src = '/some/staging/index.html/'
  var expected =     '/some/staging/index.html/'
  var got = _.uriOld.localFromGlobal( src );
  test.identical( got, expected );

  var src = '//some/staging/index.html'
  var expected =     '//some/staging/index.html'
  var got = _.uriOld.localFromGlobal( src );
  test.identical( got, expected );

  var src = '//some/staging/index.html/'
  var expected =     '//some/staging/index.html/'
  var got = _.uriOld.localFromGlobal( src );
  test.identical( got, expected );

  var src = '///some/staging/index.html'
  var expected =     '///some/staging/index.html'
  var got = _.uriOld.localFromGlobal( src );
  test.identical( got, expected );

  var src = '///some/staging/index.html/'
  var expected =     '///some/staging/index.html/'
  var got = _.uriOld.localFromGlobal( src );
  test.identical( got, expected );

  var src = 'file:///some/staging/index.html'
  var expected =     '/some/staging/index.html'
  var got = _.uriOld.localFromGlobal( src );
  test.identical( got, expected );

  var src = 'file:///some/staging/index.html/'
  var expected =     '/some/staging/index.html/'
  var got = _.uriOld.localFromGlobal( src );
  test.identical( got, expected );

  var src = 'http://some.come/staging/index.html'
  var expected =     'some.come/staging/index.html'
  var got = _.uriOld.localFromGlobal( src );
  test.identical( got, expected );

  var src = 'http://some.come/staging/index.html/'
  var expected =     'some.come/staging/index.html/'
  var got = _.uriOld.localFromGlobal( src );
  test.identical( got, expected );

  var src = 'svn+https://user@subversion.com/svn/trunk'
  var expected =     'user@subversion.com/svn/trunk'
  var got = _.uriOld.localFromGlobal( src );
  test.identical( got, expected );

  var src = 'svn+https://user@subversion.com/svn/trunk/'
  var expected =     'user@subversion.com/svn/trunk/'
  var got = _.uriOld.localFromGlobal( src );
  test.identical( got, expected );

  var src = 'complex+protocol://www.site.com:13/path/name/?query=here&and=here#anchor'
  var expected =     'www.site.com:13/path/name/'
  var got = _.uriOld.localFromGlobal( src );
  test.identical( got, expected );

  var src = 'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor'
  var expected =     'www.site.com:13/path/name'
  var got = _.uriOld.localFromGlobal( src );
  test.identical( got, expected );

  var src = 'https://web.archive.org/web/*/http://www.heritage.org/index/ranking'
  var expected =     'web.archive.org/web/*/http://www.heritage.org/index/ranking'
  var got = _.uriOld.localFromGlobal( src );
  test.identical( got, expected );

  var src = 'https://web.archive.org//web//*//http://www.heritage.org//index//ranking'
  var expected =     'web.archive.org//web//*//http://www.heritage.org//index//ranking'
  var got = _.uriOld.localFromGlobal( src );
  test.identical( got, expected );

  var src = '://www.site.com:13/path//name//?query=here&and=here#anchor'
  var expected =     'www.site.com:13/path//name//'
  var got = _.uriOld.localFromGlobal( src );
  test.identical( got, expected );

  var src = ':///www.site.com:13/path//name/?query=here&and=here#anchor'
  var expected =     '/www.site.com:13/path//name/'
  var got = _.uriOld.localFromGlobal( src );
  test.identical( got, expected );

  /*  */

  var src = _.uriOld.parse( ':///www.site.com:13/path//name/?query=here&and=here#anchor' );
  var expected =     '/www.site.com:13/path//name/'
  var got = _.uriOld.localFromGlobal( src );
  test.identical( got, expected );

}

//

function str( test )
{

  var uri = 'http://www.site.com:13/path/name?query=here&and=here#anchor';
  var components0 =
  {
    full : uri
  }

  var components2 =
  {
    resourcePath : '/path/name',
    query : 'query=here&and=here',
    hash : 'anchor',

    origin : 'http://www.site.com:13'
  }

  var components3 =
  {
    protocol : 'http',
    resourcePath : '/path/name',
    query : 'query=here&and=here',
    hash : 'anchor',

    hostFull : 'www.site.com:13'
  }

  /* */

  test.case = 'string basePath string';
  var expected = 'http://www.site.com:13/path/name?query=here&and=here#anchor';
  var got = _.uriOld.str( 'http://www.site.com:13/path/name?query=here&and=here#anchor' );
  test.identical( got, expected );

  /* */

  test.case = 'make uri basePath components uri';
  var expected1 = uri;
  var got = _.uriOld.str( components0 );
  test.identical( got, expected1 );

  /* */

  test.case = 'make uri basePath atomic components';
  var components =
  {
    protocol : 'http',
    host : 'www.site.com',
    port : 13,
    resourcePath : '/path/name',
    query : 'query=here&and=here',
    hash : 'anchor',
  }
  var got = _.uriOld.str( components );
  test.identical( got, expected1 );

  /* */

  test.case = 'make uri basePath composites components: origin';
  var got = _.uriOld.str( components2 );
  test.identical( got, expected1 );

  /* */

  test.case = 'make uri basePath composites components: hostFull';
  var got = _.uriOld.str( components3 );
  test.identical( got, expected1 );

  /* */

  test.case = 'make uri basePath composites components: hostFull';
  var expected = '//some.domain.com/was';
  var components =
  {
    host : 'some.domain.com',
    resourcePath : '/was',
  }
  var got = _.uriOld.str( components );
  test.identical( got, expected );

  /* */

  test.case = 'no host, but protocol'

  var components =
  {
    resourcePath : '/some2',
    protocol : 'src',
  }
  var expected = 'src:///some2';
  var got = _.uriOld.str( components );
  test.identical( got, expected );

  var components =
  {
    resourcePath : 'some2',
    protocol : 'src',
  }
  var expected = 'src://some2';
  var got = _.uriOld.str( components );
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
  var got = _.uriOld.str( components );
  test.identical( got, expected );

  /*  */

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
  var got = _.uriOld.str( components );
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
  var got = _.uriOld.str( components );
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
  var got = _.uriOld.str ( components);
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
  var got = _.uriOld.str( components );
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
  var expected = 'git:///git@bitbucket.org:someorg/somerepo.git/@tag'
  var got = _.uriOld.str( components );
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
  var expected = 'git:///somerepo.git/@tag'
  var got = _.uriOld.str( components );
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
  var expected = 'git:///git@bitbucket.org:someorg/somerepo.git#hash@tag'
  var got = _.uriOld.str( components );
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
  var expected = 'git:///git@bitbucket.org:someorg/somerepo.git/#hash@tag'
  var got = _.uriOld.str( components );
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
  var expected = 'git:///somerepo.git#hash@tag'
  var got = _.uriOld.str( components );
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
  var expected = 'git:///somerepo.git/#hash@tag'
  var got = _.uriOld.str( components );
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
  var expected = 'git:///git@bitbucket.org:someorg/somerepo.git?query=1#hash@tag'
  var got = _.uriOld.str( components );
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
  var expected = 'git:///git@bitbucket.org:someorg/somerepo.git/?query=1#hash@tag'
  var got = _.uriOld.str( components );
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
  var expected = 'git:///somerepo.git?query=1#hash@tag'
  var got = _.uriOld.str( components );
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
  var expected = 'git:///somerepo.git/?query=1#hash@tag'
  var got = _.uriOld.str( components );
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
  var expected = 'git:///git@bitbucket.org:someorg/somerepo.git?query=1@tag'
  var got = _.uriOld.str( components );
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
  var expected = 'git:///git@bitbucket.org:someorg/somerepo.git/?query=1@tag'
  var got = _.uriOld.str( components );
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
  var expected = 'git:///somerepo.git?query=1@tag'
  var got = _.uriOld.str( components );
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
  var expected = 'git:///somerepo.git/?query=1@tag'
  var got = _.uriOld.str( components );
  test.identical( got, expected );

  /* - */

  if( !Config.debug )
  return;

  test.shouldThrowErrorSync( () => _.uriOld.str() );
  test.shouldThrowErrorSync( () => _.uriOld.str( 'a', 'b' ) );
  test.shouldThrowErrorSync( () => _.uriOld.str({ x : 'x' }) );

}

//

function full( test )
{
  var uri = 'http://www.site.com:13/path/name?query=here&and=here#anchor';
  var components0 =
  {
    full : uri
  }

  var components2 =
  {
    resourcePath : '/path/name',
    query : 'query=here&and=here',
    hash : 'anchor',

    origin : 'http://www.site.com:13'
  }

  var components3 =
  {
    protocol : 'http',
    resourcePath : '/path/name',
    query : 'query=here&and=here',
    hash : 'anchor',

    hostFull : 'www.site.com:13'
  }

  /* */

  test.case = 'string basePath string';
  var expected = 'http://www.site.com:13/path/name?query=here&and=here#anchor';
  var got = _.uriOld.full( 'http://www.site.com:13/path/name?query=here&and=here#anchor' );
  test.identical( got, expected );

  /* */

  test.case = 'make uri basePath components uri';
  var expected1 = uri;
  var got = _.uriOld.full( components0 );
  test.identical( got, expected1 );

  /* */

  test.case = 'make uri basePath atomic components';
  var components =
  {
    protocol : 'http',
    host : 'www.site.com',
    port : 13,
    resourcePath : '/path/name',
    query : 'query=here&and=here',
    hash : 'anchor',
  }
  var got = _.uriOld.full( components );
  test.identical( got, expected1 );

  /* */

  test.case = 'make uri basePath composites components: origin';
  var got = _.uriOld.full( components2 );
  test.identical( got, expected1 );

  /* */

  test.case = 'make uri basePath composites components: hostFull';
  var got = _.uriOld.full( components3 );
  test.identical( got, expected1 );

  /* */

  test.case = 'make uri basePath composites components: hostFull';
  var expected = '//some.domain.com/was';
  var components =
  {
    host : 'some.domain.com',
    resourcePath : '/was',
  }
  var got = _.uriOld.full( components );
  test.identical( got, expected );

  /* */

  test.case = 'no host, but protocol'

  var components =
  {
    resourcePath : '/some2',
    protocol : 'src',
  }
  var expected = 'src:///some2';
  var got = _.uriOld.full( components );
  test.identical( got, expected );

  var components =
  {
    resourcePath : 'some2',
    protocol : 'src',
  }
  var expected = 'src://some2';
  var got = _.uriOld.full( components );
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
  var got = _.uriOld.full( components );
  test.identical( got, expected );

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
  var got = _.uriOld.full( components );
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
  var got = _.uriOld.full( components );
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
  var got = _.uriOld.full ( components);
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
  var got = _.uriOld.full( components );
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
  var expected = 'git:///git@bitbucket.org:someorg/somerepo.git/@tag'
  var got = _.uriOld.full( components );
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
  var expected = 'git:///somerepo.git/@tag'
  var got = _.uriOld.full( components );
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
  var expected = 'git:///git@bitbucket.org:someorg/somerepo.git#hash@tag'
  var got = _.uriOld.full( components );
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
  var expected = 'git:///git@bitbucket.org:someorg/somerepo.git/#hash@tag'
  var got = _.uriOld.full( components );
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
  var expected = 'git:///somerepo.git#hash@tag'
  var got = _.uriOld.full( components );
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
  var expected = 'git:///somerepo.git/#hash@tag'
  var got = _.uriOld.full( components );
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
  var expected = 'git:///git@bitbucket.org:someorg/somerepo.git?query=1#hash@tag'
  var got = _.uriOld.full( components );
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
  var expected = 'git:///git@bitbucket.org:someorg/somerepo.git/?query=1#hash@tag'
  var got = _.uriOld.full( components );
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
  var expected = 'git:///somerepo.git?query=1#hash@tag'
  var got = _.uriOld.full( components );
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
  var expected = 'git:///somerepo.git/?query=1#hash@tag'
  var got = _.uriOld.full( components );
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
  var expected = 'git:///git@bitbucket.org:someorg/somerepo.git?query=1@tag'
  var got = _.uriOld.full( components );
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
  var expected = 'git:///git@bitbucket.org:someorg/somerepo.git/?query=1@tag'
  var got = _.uriOld.full( components );
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
  var expected = 'git:///somerepo.git?query=1@tag'
  var got = _.uriOld.full( components );
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
  var expected = 'git:///somerepo.git/?query=1@tag'
  var got = _.uriOld.full( components );
  test.identical( got, expected );

  /*  */

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
  var got = _.uriOld.full( components );
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
  var parsed = _.uriOld.parse( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  test.case = 'other';

  var uri = '/some/staging/index.html';
  var parsed = _.uriOld.parse( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = '//some/staging/index.html';
  var parsed = _.uriOld.parse( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = '//www.site.com/index.html';
  var parsed = _.uriOld.parse( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = '///index.html';
  var parsed = _.uriOld.parse( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = '//www.site.com:/index.html';
  var parsed = _.uriOld.parse( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = '//www.site.com:13/index.html';
  var parsed = _.uriOld.parse( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = '//www.site.com:13/index.html?query=here&and=here#anchor';
  var parsed = _.uriOld.parse( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = '///some/staging/index.html';
  var parsed = _.uriOld.parse( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = '///some.com:99/staging/index.html';
  var parsed = _.uriOld.parse( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = '///some.com:99/staging/index.html?query=here&and=here#anchor';
  var parsed = _.uriOld.parse( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = 'file:///some/staging/index.html';
  var parsed = _.uriOld.parse( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = 'file:///some.com:/staging/index.html?query=here&and=here#anchor';
  var parsed = _.uriOld.parse( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = 'http://some.come/staging/index.html';
  var parsed = _.uriOld.parse( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = 'http://some.come:88/staging/index.html';
  var parsed = _.uriOld.parse( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = 'http://some.come:88/staging/?query=here&and=here#anchor';
  var parsed = _.uriOld.parse( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = 'svn+https://user@subversion.com/svn/trunk';
  var parsed = _.uriOld.parse( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = 'svn+https://user@subversion.com:99/svn/trunk';
  var parsed = _.uriOld.parse( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = 'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor';
  var parsed = _.uriOld.parse( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = 'complex+protocol://www.site.com:13/path/name?';
  var parsed = _.uriOld.parse( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = 'complex+protocol://www.site.com:13/path/name?#';
  var parsed = _.uriOld.parse( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = 'https://web.archive.org/web/*/http://www.heritage.org/index/ranking';
  var parsed = _.uriOld.parse( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = '://www.site.com:13/path//name//?query=here&and=here#anchor';
  var parsed = _.uriOld.parse( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = ':///www.site.com:13/path//name//?query=here&and=here#anchor';
  var parsed = _.uriOld.parse( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = 'protocol://';
  var parsed = _.uriOld.parse( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = '//:99';
  var parsed = _.uriOld.parse( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = '://:99';
  var parsed = _.uriOld.parse( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = '//?q=1#x';
  var parsed = _.uriOld.parse( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = '//';
  var parsed = _.uriOld.parse( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = '//a/b/c';
  var parsed = _.uriOld.parse( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = '///';
  var parsed = _.uriOld.parse( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = '///a/b/c';
  var parsed = _.uriOld.parse( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var expectedParsed =
  {
    'protocol' : 'ext',
    'host' : '..',
    'resourcePath' : '/src',
    'longPath' : '../src',
    'postfixedPath' : '../src',
    'protocols' : [ 'ext' ],
    'hostFull' : '..',
    'origin' : 'ext://..',
    'full' : 'ext://../src'
  }
  var uri = 'ext://../src';
  var parsed = _.uriOld.parse( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );
  test.identical( parsed, expectedParsed );

  // full: "ext://../src"
  // host: ".."
  // hostFull: ".."
  // resourcePath: "/src"
  // longPath: "../src"
  // origin: "ext://.."
  // protocol: "ext"
  // protocols: ["ext"]

  /* - */

  test.close( 'all' );
  test.open( 'atomic' );

  /* - */

  test.case = 'no protocol';

  var uri = '127.0.0.1:61726/../path';
  var parsed = _.uriOld.parseAtomic( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  test.case = 'other';

  var uri = '/some/staging/index.html';
  var parsed = _.uriOld.parseAtomic( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = '//some/staging/index.html';
  var parsed = _.uriOld.parseAtomic( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = '//www.site.com/index.html';
  var parsed = _.uriOld.parseAtomic( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = '///index.html';
  var parsed = _.uriOld.parseAtomic( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = '//www.site.com:/index.html';
  var parsed = _.uriOld.parseAtomic( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = '//www.site.com:13/index.html';
  var parsed = _.uriOld.parseAtomic( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = '//www.site.com:13/index.html?query=here&and=here#anchor';
  var parsed = _.uriOld.parseAtomic( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = '///some/staging/index.html';
  var parsed = _.uriOld.parseAtomic( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = '///some.com:99/staging/index.html';
  var parsed = _.uriOld.parseAtomic( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = '///some.com:99/staging/index.html?query=here&and=here#anchor';
  var parsed = _.uriOld.parseAtomic( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = 'file:///some/staging/index.html';
  var parsed = _.uriOld.parseAtomic( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = 'file:///some.com:/staging/index.html?query=here&and=here#anchor';
  var parsed = _.uriOld.parseAtomic( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = 'http://some.come/staging/index.html';
  var parsed = _.uriOld.parseAtomic( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = 'http://some.come:88/staging/index.html';
  var parsed = _.uriOld.parseAtomic( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = 'http://some.come:88/staging/?query=here&and=here#anchor';
  var parsed = _.uriOld.parseAtomic( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = 'svn+https://user@subversion.com/svn/trunk';
  var parsed = _.uriOld.parseAtomic( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = 'svn+https://user@subversion.com:99/svn/trunk';
  var parsed = _.uriOld.parseAtomic( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = 'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor';
  var parsed = _.uriOld.parseAtomic( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = 'complex+protocol://www.site.com:13/path/name?';
  var parsed = _.uriOld.parseAtomic( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = 'complex+protocol://www.site.com:13/path/name?#';
  var parsed = _.uriOld.parseAtomic( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = 'https://web.archive.org/web/*/http://www.heritage.org/index/ranking';
  var parsed = _.uriOld.parseAtomic( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = '://www.site.com:13/path//name//?query=here&and=here#anchor';
  var parsed = _.uriOld.parseAtomic( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = ':///www.site.com:13/path//name//?query=here&and=here#anchor';
  var parsed = _.uriOld.parseAtomic( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = 'protocol://';
  var parsed = _.uriOld.parseAtomic( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = '//:99';
  var parsed = _.uriOld.parseAtomic( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = '://:99';
  var parsed = _.uriOld.parseAtomic( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = '//?q=1#x';
  var parsed = _.uriOld.parseAtomic( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = '//';
  var parsed = _.uriOld.parseAtomic( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = '//a/b/c';
  var parsed = _.uriOld.parseAtomic( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = '///';
  var parsed = _.uriOld.parseAtomic( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = '///a/b/c';
  var parsed = _.uriOld.parseAtomic( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = 'git:///github.com/user/repo.git';
  var parsed = _.uriOld.parseAtomic( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  /* - */

  test.close( 'atomic' );
  test.open( 'consecutive' );

  /* - */

  test.case = 'no protocol';

  var uri = '127.0.0.1:61726/../path';
  var parsed = _.uriOld.parseConsecutive( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  test.case = 'other';

  var uri = '/some/staging/index.html';
  var parsed = _.uriOld.parseConsecutive( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = '//some/staging/index.html';
  var parsed = _.uriOld.parseConsecutive( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = '//www.site.com/index.html';
  var parsed = _.uriOld.parseConsecutive( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = '///index.html';
  var parsed = _.uriOld.parseConsecutive( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = '//www.site.com:/index.html';
  var parsed = _.uriOld.parseConsecutive( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = '//www.site.com:13/index.html';
  var parsed = _.uriOld.parseConsecutive( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = '//www.site.com:13/index.html?query=here&and=here#anchor';
  var parsed = _.uriOld.parseConsecutive( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = '///some/staging/index.html';
  var parsed = _.uriOld.parseConsecutive( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = '///some.com:99/staging/index.html';
  var parsed = _.uriOld.parseConsecutive( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = '///some.com:99/staging/index.html?query=here&and=here#anchor';
  var parsed = _.uriOld.parseConsecutive( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = 'file:///some/staging/index.html';
  var parsed = _.uriOld.parseConsecutive( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = 'file:///some.com:/staging/index.html?query=here&and=here#anchor';
  var parsed = _.uriOld.parseConsecutive( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = 'http://some.come/staging/index.html';
  var parsed = _.uriOld.parseConsecutive( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = 'http://some.come:88/staging/index.html';
  var parsed = _.uriOld.parseConsecutive( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = 'http://some.come:88/staging/?query=here&and=here#anchor';
  var parsed = _.uriOld.parseConsecutive( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = 'svn+https://user@subversion.com/svn/trunk';
  var parsed = _.uriOld.parseConsecutive( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = 'svn+https://user@subversion.com:99/svn/trunk';
  var parsed = _.uriOld.parseConsecutive( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = 'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor';
  var parsed = _.uriOld.parseConsecutive( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = 'complex+protocol://www.site.com:13/path/name?';
  var parsed = _.uriOld.parseConsecutive( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = 'complex+protocol://www.site.com:13/path/name?#';
  var parsed = _.uriOld.parseConsecutive( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = 'https://web.archive.org/web/*/http://www.heritage.org/index/ranking';
  var parsed = _.uriOld.parseConsecutive( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = '://www.site.com:13/path//name//?query=here&and=here#anchor';
  var parsed = _.uriOld.parseConsecutive( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = ':///www.site.com:13/path//name//?query=here&and=here#anchor';
  var parsed = _.uriOld.parseConsecutive( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = 'protocol://';
  var parsed = _.uriOld.parseConsecutive( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = '//:99';
  var parsed = _.uriOld.parseConsecutive( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = '://:99';
  var parsed = _.uriOld.parseConsecutive( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = '//?q=1#x';
  var parsed = _.uriOld.parseConsecutive( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = '//';
  var parsed = _.uriOld.parseConsecutive( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = '//a/b/c';
  var parsed = _.uriOld.parseConsecutive( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = '///';
  var parsed = _.uriOld.parseConsecutive( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = '///a/b/c';
  var parsed = _.uriOld.parseConsecutive( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  var uri = 'git:///github.com/user/repo.git';
  var parsed = _.uriOld.parseConsecutive( uri );
  var got = _.uriOld.str( parsed );
  test.identical( got, uri );

  /* - */

  test.close( 'consecutive' );

}

//
//
// function basePath( test )
// {
//   var string = 'http://www.site.com:13/path/name?query=here&and=here#anchor';
//   var options1 =
//   {
//     full : string,
//   }
//   var expected1 = string;
//
//   test.case = 'call with options.uri';
//   var got = _.uriOld.basePath( options1 );
//   test.contains( got, expected1 );
//
//   if( !Config.debug )
//   return;
//
//   test.case = 'missed arguments';
//   test.shouldThrowErrorSync( function()
//   {
//     _.uriOld.basePath();
//   });
//
// }

//

function documentGet( test )
{

  var uri1 = 'https://www.site.com:13/path/name?query=here&and=here#anchor';
  var uriOld = 'www.site.com:13/path/name?query=here&and=here#anchor';
  var uri3 = 'http://www.site.com:13/path/name';
  var options1 = { withoutServer : 1 };
  var options2 = { withoutProtocol : 1 };
  var expected1 = 'https://www.site.com:13/path/name';
  var expected2 = 'http://www.site.com:13/path/name';
  var expected3 = 'www.site.com:13/path/name';
  var expected4 = '/path/name';

  test.case = 'full components uri';
  var got = _.uriOld.documentGet( uri1 );
  test.contains( got, expected1 );

  test.case = 'uri without protocol';
  var got = _.uriOld.documentGet( uriOld );
  test.contains( got, expected2 );

  test.case = 'uri without query, options withoutProtocol = 1';
  var got = _.uriOld.documentGet( uri3, options2 );
  test.contains( got, expected3 );

  test.case = 'get path only';
  var got = _.uriOld.documentGet( uri1, options1 );
  test.contains( got, expected4 );

}

//

function server( test )
{
  var string = 'http://www.site.com:13/path/name?query=here&and=here#anchor';
  var expected = 'http://www.site.com:13/';

  test.case = 'get server part of uri';
  var got = _.uriOld.server( string );
  test.contains( got, expected );

}

//

function query( test )
{
  var string = 'http://www.site.com:13/path/name?query=here&and=here#anchor';
  var expected = 'query=here&and=here#anchor';

  test.case = 'get query part of uri';
  var got = _.uriOld.query( string );
  test.contains( got, expected );

}

//

function dequery( test )
{
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
  var got = _.uriOld.dequery( query1 );
  test.contains( got, expected1 );

  test.case = 'parse query with several key/value pair';
  var got = _.uriOld.dequery( query2 );
  test.contains( got, expected2 );

  test.case = 'parse query with several key/value pair and decoding';
  var got = _.uriOld.dequery( query3 );
  test.contains( got, expected3 );

}

//

function join( test )
{

  test.case = 'join empty';
  var paths = [ '' ];
  var expected = '';
  var got = _.uriOld.join.apply( _.uriOld, paths );
  test.identical( got, expected );

  test.case = 'join several empties';
  var paths = [ '', '' ];
  var expected = '';
  var got = _.uriOld.join.apply( _.uriOld, paths );
  test.identical( got, expected );

  test.case = 'join with empty';
  var paths = [ '', 'a/b', '', 'c', '' ];
  var expected = 'a/b/c';
  var got = _.uriOld.join.apply( _.uriOld, paths );
  test.identical( got, expected );

  test.case = 'replace protocol';
  var got = _.uriOld.join( 'src:///in', 'fmap://' );
  var expected = 'fmap:///in';
  test.identical( got, expected );

  test.case = 'join different protocols';
  var got = _.uriOld.join( 'file://www.site.com:13', 'a', 'http:///dir', 'b' );
  var expected = 'http:///dir/b';
  test.identical( got, expected );

  var got = _.uriOld.join( 'file:///d', 'a', 'http:///dir', 'b' );
  var expected = 'http:///dir/b';
  test.identical( got, expected );

  test.case = 'join same protocols';

  var got = _.uriOld.join( 'http://www.site.com:13', 'a', 'http:///dir', 'b' );
  var expected = 'http:///dir/b';
  test.identical( got, expected );

  var got = _.uriOld.join( 'http:///www.site.com:13', 'a', 'http:///dir', 'b' );
  var expected = 'http:///dir/b';
  test.identical( got, expected );

  var got = _.uriOld.join( 'http://server1', 'a', 'http://server2', 'b' );
  var expected = 'http://server1/a/server2/b';
  test.identical( got, expected );

  var got = _.uriOld.join( 'http:///server1', 'a', 'http://server2', 'b' );
  var expected = 'http:///server1/a/server2/b';
  test.identical( got, expected );

  var got = _.uriOld.join( 'http://server1', 'a', 'http:///server2', 'b' );
  var expected = 'http:///server2/b';
  test.identical( got, expected );

  test.case = 'join protocol with protocol-less';

  var got = _.uriOld.join( 'http://www.site.com:13', 'a', ':///dir', 'b' );
  var expected = 'http:///dir/b';
  test.identical( got, expected );

  var got = _.uriOld.join( 'http:///www.site.com:13', 'a', '://dir', 'b' );
  var expected = 'http:///www.site.com:13/a/dir/b';
  test.identical( got, expected );

  var got = _.uriOld.join( 'http:///www.site.com:13', 'a', ':///dir', 'b' );
  var expected = 'http:///dir/b';
  test.identical( got, expected );

  var got = _.uriOld.join( 'http://www.site.com:13', 'a', '://dir', 'b' );
  var expected = 'http://www.site.com:13/a/dir/b';
  test.identical( got, expected );

  var got = _.uriOld.join( 'http://dir:13', 'a', '://dir', 'b' );
  var expected = 'http://dir:13/a/dir/b';
  test.identical( got, expected );

  var got = _.uriOld.join( 'http://www.site.com:13', 'a', '://:14', 'b' );
  var expected = 'http://www.site.com:13/a/:14/b';
  test.identical( got, expected );

  /**/

  var got = _.uriOld.join( 'a', '://dir1/x', 'b', 'http://dir2/y', 'c' );
  var expected = 'http://a/dir1/x/b/dir2/y/c';
  test.identical( got, expected );

  var got = _.uriOld.join( 'a', ':///dir1/x', 'b', 'http://dir2/y', 'c' );
  var expected = 'http:///dir1/x/b/dir2/y/c';
  test.identical( got, expected );

  var got = _.uriOld.join( 'a', '://dir1/x', 'b', 'http:///dir2/y', 'c' );
  var expected = 'http:///dir2/y/c';
  test.identical( got, expected );

  var got = _.uriOld.join( 'a', ':///dir1/x', 'b', 'http:///dir2/y', 'c' );
  var expected = 'http:///dir2/y/c';
  test.identical( got, expected );

  /* */

  test.case = 'server join absolute path 1';
  var got = _.uriOld.join( 'http://www.site.com:13', '/x', '/y', '/z' );
  test.identical( got, 'http:///z' );

  test.case = 'server join absolute path 2';
  var got = _.uriOld.join( 'http://www.site.com:13/', 'x', '/y', '/z' );
  test.identical( got, 'http:///z' );

  test.case = 'server join absolute path 2';
  var got = _.uriOld.join( 'http://www.site.com:13/', 'x', 'y', '/z' );
  test.identical( got, 'http:///z' );

  test.case = 'server join absolute path';
  var got = _.uriOld.join( 'http://www.site.com:13/', 'x', '/y', 'z' );
  test.identical( got, 'http:///y/z' );

  test.case = 'server join relative path';
  var got = _.uriOld.join( 'http://www.site.com:13/', 'x', 'y', 'z' );
  test.identical( got, 'http://www.site.com:13/x/y/z' );

  test.case = 'server with path join absolute path 2';
  var got = _.uriOld.join( 'http://www.site.com:13/ab', '/y', '/z' );
  test.identical( got, 'http:///z' );

  test.case = 'server with path join absolute path 2';
  var got = _.uriOld.join( 'http://www.site.com:13/ab', '/y', 'z' );
  test.identical( got, 'http:///y/z' );

  test.case = 'server with path join absolute path 2';
  var got = _.uriOld.join( 'http://www.site.com:13/ab', 'y', 'z' );
  test.identical( got, 'http://www.site.com:13/ab/y/z' );

  test.case = 'add relative filePath uri with no resourcePath';
  var got = _.uriOld.join( 'https://some.domain.com/', 'something/filePath/add' );
  test.identical( got, 'https://some.domain.com/something/filePath/add' );

  test.case = 'add relative filePath uri with resourcePath';
  var got = _.uriOld.join( 'https://some.domain.com/was', 'something/filePath/add' );
  test.identical( got, 'https://some.domain.com/was/something/filePath/add' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriOld.join( 'https://some.domain.com/was', '/something/filePath/add' );
  test.identical( got, 'https:///something/filePath/add' );

  /* */

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriOld.join( '//some.domain.com/was', '/something/filePath/add' );
  test.identical( got, '/something/filePath/add' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriOld.join( '://some.domain.com/was', '/something/filePath/add' );
  test.identical( got, ':///something/filePath/add' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriOld.join( '//some.domain.com/was', 'x', '/something/filePath/add' );
  test.identical( got, '/something/filePath/add' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriOld.join( '://some.domain.com/was', 'x', '/something/filePath/add' );
  test.identical( got, ':///something/filePath/add' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriOld.join( '//some.domain.com/was', '/something/filePath/add', 'x' );
  test.identical( got, '/something/filePath/add/x' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriOld.join( '://some.domain.com/was', '/something/filePath/add', 'x' );
  test.identical( got, ':///something/filePath/add/x' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriOld.join( '//some.domain.com/was', '/something/filePath/add', '/x' );
  test.identical( got, '/x' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriOld.join( '://some.domain.com/was', '/something/filePath/add', '/x' );
  test.identical( got, ':///x' );

  /* */

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriOld.join( '/some/staging/index.html', '/something/filePath/add' );
  test.identical( got, '/something/filePath/add' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriOld.join( '/some/staging/index.html', 'x', '/something/filePath/add' );
  test.identical( got, '/something/filePath/add' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriOld.join( '/some/staging/index.html', 'x', '/something/filePath/add', 'y' );
  test.identical( got, '/something/filePath/add/y' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriOld.join( '/some/staging/index.html', '/something/filePath/add', '/y' );
  test.identical( got, '/y' );

  /* */

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriOld.join( '///some/staging/index.html', '/something/filePath/add' );
  test.identical( got, '/something/filePath/add' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriOld.join( ':///some/staging/index.html', '/something/filePath/add' );
  test.identical( got, ':///something/filePath/add' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriOld.join( '///some/staging/index.html', 'x', '/something/filePath/add' );
  test.identical( got, '/something/filePath/add' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriOld.join( ':///some/staging/index.html', 'x', '/something/filePath/add' );
  test.identical( got, ':///something/filePath/add' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriOld.join( '///some/staging/index.html', 'x', '/something/filePath/add', 'y' );
  test.identical( got, '/something/filePath/add/y' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriOld.join( ':///some/staging/index.html', 'x', '/something/filePath/add', 'y' );
  test.identical( got, ':///something/filePath/add/y' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriOld.join( '///some/staging/index.html', '/something/filePath/add', '/y' );
  test.identical( got, '/y' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriOld.join( ':///some/staging/index.html', '/something/filePath/add', '/y' );
  test.identical( got, ':///y' );

  /* */

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriOld.join( 'svn+https://user@subversion.com/svn/trunk', '/something/filePath/add' );
  test.identical( got, 'svn+https:///something/filePath/add' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriOld.join( 'svn+https://user@subversion.com/svn/trunk', 'x', '/something/filePath/add' );
  test.identical( got, 'svn+https:///something/filePath/add' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriOld.join( 'svn+https://user@subversion.com/svn/trunk', 'x', '/something/filePath/add', 'y' );
  test.identical( got, 'svn+https:///something/filePath/add/y' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriOld.join( 'svn+https://user@subversion.com/svn/trunk', '/something/filePath/add', '/y' );
  test.identical( got, 'svn+https:///y' );

  /* */

  var uri = 'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor';
  var parsed = _.uriOld.parse( uri );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriOld.join( uri, '/something/filePath/add' );
  test.identical( got, 'complex+protocol:///something/filePath/add?query=here&and=here#anchor' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriOld.join( uri, 'x', '/something/filePath/add' );
  test.identical( got, 'complex+protocol:///something/filePath/add?query=here&and=here#anchor' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriOld.join( uri, 'x', '/something/filePath/add', 'y' );
  test.identical( got, 'complex+protocol:///something/filePath/add/y?query=here&and=here#anchor' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriOld.join( uri, '/something/filePath/add', '/y' );
  test.identical( got, 'complex+protocol:///y?query=here&and=here#anchor' );

  test.case = 'prased uri at the end';
  var got = _.uriOld.join( '/something/filePath/add', 'y', uri );
  test.identical( got, 'complex+protocol:///something/filePath/add/y/www.site.com:13/path/name?query=here&and=here#anchor' );

  /* */

  test.case = 'several queries and hashes'
  var uri1 = '://user:pass@sub.host.com:8080/p/a/t/h?query1=string1#hash1';
  var uriOld = '://user:pass@sub.host.com:8080/p/a/t/h?query2=string2#hash2';
  var got = _.uriOld.join( uri1, uriOld, '/x//y//z' );
  var expected = ':///x//y//z?query1=string1&query2=string2#hash2';
  test.identical( got, expected );

  var uri = '://user:pass@sub.host.com:8080/p/a/t/h?query=string#hash';
  var got = _.uriOld.join( uri, 'x' );
  var expected = '://user:pass@sub.host.com:8080/p/a/t/h/x?query=string#hash'
  test.identical( got, expected );

  var uri = '://user:pass@sub.host.com:8080/p/a/t/h?query=string#hash';
  var got = _.uriOld.join( uri, 'x', '/y' );
  var expected = ':///y?query=string#hash';
  test.identical( got, expected );

  var uri = '://user:pass@sub.host.com:8080/p/a/t/h?query=string#hash';
  var got = _.uriOld.join( uri, '/x//y//z' );
  var expected = ':///x//y//z?query=string#hash';
  test.identical( got, expected );

  var uri = '://user:pass@sub.host.com:8080/p//a//t//h?query=string#hash';
  var got = _.uriOld.join( uri, 'x/' );
  var expected = '://user:pass@sub.host.com:8080/p//a//t//h/x?query=string#hash'
  test.identical( got, expected );

  var uri = ':///user:pass@sub.host.com:8080/p/a/t/h?query=string#hash';
  var got = _.uriOld.join( uri, 'x' );
  // var expected = ':///user:pass/x#hash@sub.host.com:8080/p/a/t/h?query=string';
  var expected = ':///user:pass@sub.host.com:8080/p/a/t/h/x?query=string#hash';
  test.identical( got, expected );

  var uri = ':///user:pass@sub.host.com:8080/p/a/t/h?query=string#hash';
  var got = _.uriOld.join( uri, 'x', '/y' );
  var expected = ':///y?query=string#hash'
  test.identical( got, expected );

  var uri = ':///user:pass@sub.host.com:8080/p/a/t/h?query=string#hash';
  var got = _.uriOld.join( uri, '/x//y//z' );
  var expected = ':///x//y//z?query=string#hash'
  test.identical( got, expected );

  var uri = ':///user:pass@sub.host.com:8080/p/a/t/h?query=string#hash';
  var got = _.uriOld.join( uri, 'x/' );
  var expected = ':///user:pass@sub.host.com:8080/p/a/t/h/x?query=string#hash'
  test.identical( got, expected );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriOld.join( 'file:///some/file', '/something/filePath/add' );
  test.identical( got, 'file:///something/filePath/add' );

  /* */

  test.case = 'add uris';

  var got = _.uriOld.join( '//a', '//b', 'c' );
  test.identical( got, '//b/c' )

  var got = _.uriOld.join( 'b://c', 'd://e', 'f' );
  test.identical( got, 'd://c/e/f' );

  var got = _.uriOld.join( 'a://b', 'c://d/e', '//f/g' );
  test.identical( got, 'c:////f/g' )

  /* - */

  test.case = 'not global, windows path';
  var paths = [ 'c:\\', 'foo\\', 'bar\\' ];
  var expected = '/c/foo/bar/';
  var got = _.uriOld.join.apply( _.uriOld, paths );
  test.identical( got, expected );

  test.case = 'not global';
  var paths = [ '/bar/', '/baz', 'foo/', '.' ];
  var expected = '/baz/foo';
  var got = _.uriOld.join.apply( _.uriOld, paths );
  test.identical( got, expected );

  /* - */

  test.open( 'with nulls' );

  var paths = [ 'a', null ];
  var expected = null;
  var got = _.uriOld.join.apply( _.uriOld, paths );
  test.identical( got, expected );

  var paths = [ '/', null ];
  var expected = null;
  var got = _.uriOld.join.apply( _.uriOld, paths );
  test.identical( got, expected );

  var paths = [ 'a', null, 'b' ];
  var expected = 'b';
  var got = _.uriOld.join.apply( _.uriOld, paths );
  test.identical( got, expected );

  var paths = [ '/a', null, 'b' ];
  var expected = 'b';
  var got = _.uriOld.join.apply( _.uriOld, paths );
  test.identical( got, expected );

  var paths = [ '/a', null, '/b' ];
  var expected = '/b';
  var got = _.uriOld.join.apply( _.uriOld, paths );
  test.identical( got, expected );

  test.close( 'with nulls' );

  /* - */

  test.open( 'other special cases' );

  var paths = [ '/aa', 'bb//', 'cc' ];
  var expected = '/aa/bb//cc';
  var got = _.uriOld.join.apply( _.uriOld, paths );
  test.identical( got, expected );

  var paths = [ '/aa', 'bb//', 'cc', '.' ];
  var expected = '/aa/bb//cc';
  var got = _.uriOld.join.apply( _.uriOld, paths );
  test.identical( got, expected );

  var paths = [ '/', 'a', '//b', '././c', '../d', '..e' ];
  var expected = '//b/d/..e';
  var got = _.uriOld.join.apply( _.uriOld, paths );
  test.identical( got, expected );

  var paths = [ '/', 'a', '//b', '././c', '../d', '..e' ];
  var expected = '//b/d/..e';
  var got = _.uriOld.join.apply( _.uriOld, paths );
  test.identical( got, expected );

  var paths = [ 'git+https:///github.com/repo/wTools#master', '../wTools/**#master' ];
  var expected = 'git+https:///github.com/repo/wTools/**#master#master';
  var got = _.uriOld.join.apply( _.uriOld, paths );
  test.identical( got, expected );

  var paths = [ 'git+https:///github.com/repo/wTools#master', 'git+https://../wTools/**#master' ];
  var expected = 'git+https:///github.com/repo/wTools/**#master';
  var got = _.uriOld.join.apply( _.uriOld, paths );
  test.identical( got, expected );

  var paths = [ 'git+https:///github.com/repo/wTools#master1', 'git+https://../wTools/**#master2' ];
  var expected = 'git+https:///github.com/repo/wTools/**#master2';
  var got = _.uriOld.join.apply( _.uriOld, paths );
  test.identical( got, expected );

  var paths = [ 'http://127.0.0.1:15000/F1.html', '://?entry:1&format:null' ];
  var expected = 'http://127.0.0.1:15000/F1.html?entry:1&format:null';
  var got = _.uriOld.join.apply( _.uriOld, paths );
  test.identical( got, expected );

  var paths = [ 'http://127.0.0.1:15000/F1.html', '?entry:1&format:null' ];
  var expected = 'http://127.0.0.1:15000/F1.html/?entry:1&format:null';
  var got = _.uriOld.join.apply( _.uriOld, paths );
  test.identical( got, expected );

  test.close( 'other special cases' );

}

//

function joinRaw( test )
{

  test.case = 'joinRaw with empty';
  var paths = [ '', 'a/b', '', 'c', '' ];
  var expected = 'a/b/c';
  var got = _.uriOld.joinRaw.apply( _.uriOld, paths );
  test.identical( got, expected );

  test.case = 'replace protocol';

  var got = _.uriOld.joinRaw( 'src:///in', 'fmap://' );
  var expected = 'fmap:///in';
  test.identical( got, expected );

  test.case = 'joinRaw different protocols';

  var got = _.uriOld.joinRaw( 'file://www.site.com:13', 'a', 'http:///dir', 'b' );
  var expected = 'http:///dir/b';
  test.identical( got, expected );

  var got = _.uriOld.joinRaw( 'file:///d', 'a', 'http:///dir', 'b' );
  var expected = 'http:///dir/b';
  test.identical( got, expected );

  test.case = 'joinRaw same protocols';

  var got = _.uriOld.joinRaw( 'http://www.site.com:13', 'a', 'http:///dir', 'b' );
  var expected = 'http:///dir/b';
  test.identical( got, expected );

  var got = _.uriOld.joinRaw( 'http:///www.site.com:13', 'a', 'http:///dir', 'b' );
  var expected = 'http:///dir/b';
  test.identical( got, expected );

  var got = _.uriOld.joinRaw( 'http://server1', 'a', 'http://server2', 'b' );
  var expected = 'http://server1/a/server2/b';
  test.identical( got, expected );

  var got = _.uriOld.joinRaw( 'http:///server1', 'a', 'http://server2', 'b' );
  var expected = 'http:///server1/a/server2/b';
  test.identical( got, expected );

  var got = _.uriOld.joinRaw( 'http://server1', 'a', 'http:///server2', 'b' );
  var expected = 'http:///server2/b';
  test.identical( got, expected );

  test.case = 'joinRaw protocol with protocol-less';

  var got = _.uriOld.joinRaw( 'http://www.site.com:13', 'a', ':///dir', 'b' );
  var expected = 'http:///dir/b';
  test.identical( got, expected );

  var got = _.uriOld.joinRaw( 'http:///www.site.com:13', 'a', '://dir', 'b' );
  var expected = 'http:///www.site.com:13/a/dir/b';
  test.identical( got, expected );

  var got = _.uriOld.joinRaw( 'http:///www.site.com:13', 'a', ':///dir', 'b' );
  var expected = 'http:///dir/b';
  test.identical( got, expected );

  var got = _.uriOld.joinRaw( 'http://www.site.com:13', 'a', '://dir', 'b' );
  var expected = 'http://www.site.com:13/a/dir/b';
  test.identical( got, expected );

  var got = _.uriOld.joinRaw( 'http://dir:13', 'a', '://dir', 'b' );
  var expected = 'http://dir:13/a/dir/b';
  test.identical( got, expected );

  var got = _.uriOld.joinRaw( 'http://www.site.com:13', 'a', '://:14', 'b' );
  var expected = 'http://www.site.com:13/a/:14/b';
  test.identical( got, expected );

  /**/

  var got = _.uriOld.joinRaw( 'a', '://dir1/x', 'b', 'http://dir2/y', 'c' );
  var expected = 'http://a/dir1/x/b/dir2/y/c';
  test.identical( got, expected );

  var got = _.uriOld.joinRaw( 'a', ':///dir1/x', 'b', 'http://dir2/y', 'c' );
  var expected = 'http:///dir1/x/b/dir2/y/c';
  test.identical( got, expected );

  var got = _.uriOld.joinRaw( 'a', '://dir1/x', 'b', 'http:///dir2/y', 'c' );
  var expected = 'http:///dir2/y/c';
  test.identical( got, expected );

  var got = _.uriOld.joinRaw( 'a', ':///dir1/x', 'b', 'http:///dir2/y', 'c' );
  var expected = 'http:///dir2/y/c';
  test.identical( got, expected );

  /* */

  test.case = 'server joinRaw absolute path 1';
  var got = _.uriOld.joinRaw( 'http://www.site.com:13', '/x', '/y', '/z' );
  test.identical( got, 'http:///z' );

  test.case = 'server joinRaw absolute path 2';
  var got = _.uriOld.joinRaw( 'http://www.site.com:13/', 'x', '/y', '/z' );
  test.identical( got, 'http:///z' );

  test.case = 'server joinRaw absolute path 2';
  var got = _.uriOld.joinRaw( 'http://www.site.com:13/', 'x', 'y', '/z' );
  test.identical( got, 'http:///z' );

  test.case = 'server joinRaw absolute path';
  var got = _.uriOld.joinRaw( 'http://www.site.com:13/', 'x', '/y', 'z' );
  test.identical( got, 'http:///y/z' );

  test.case = 'server joinRaw relative path';
  var got = _.uriOld.joinRaw( 'http://www.site.com:13/', 'x', 'y', 'z' );
  test.identical( got, 'http://www.site.com:13/x/y/z' );

  test.case = 'server with path joinRaw absolute path 2';
  var got = _.uriOld.joinRaw( 'http://www.site.com:13/ab', '/y', '/z' );
  test.identical( got, 'http:///z' );

  test.case = 'server with path joinRaw absolute path 2';
  var got = _.uriOld.joinRaw( 'http://www.site.com:13/ab', '/y', 'z' );
  test.identical( got, 'http:///y/z' );

  test.case = 'server with path joinRaw absolute path 2';
  var got = _.uriOld.joinRaw( 'http://www.site.com:13/ab', 'y', 'z' );
  test.identical( got, 'http://www.site.com:13/ab/y/z' );

  test.case = 'add relative filePath uri with no resourcePath';
  var got = _.uriOld.joinRaw( 'https://some.domain.com/', 'something/filePath/add' );
  test.identical( got, 'https://some.domain.com/something/filePath/add' );

  test.case = 'add relative filePath uri with resourcePath';
  var got = _.uriOld.joinRaw( 'https://some.domain.com/was', 'something/filePath/add' );
  test.identical( got, 'https://some.domain.com/was/something/filePath/add' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriOld.joinRaw( 'https://some.domain.com/was', '/something/filePath/add' );
  test.identical( got, 'https:///something/filePath/add' );

  /* */

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriOld.joinRaw( '//some.domain.com/was', '/something/filePath/add' );
  test.identical( got, '/something/filePath/add' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriOld.joinRaw( '://some.domain.com/was', '/something/filePath/add' );
  test.identical( got, ':///something/filePath/add' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriOld.joinRaw( '//some.domain.com/was', 'x', '/something/filePath/add' );
  test.identical( got, '/something/filePath/add' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriOld.joinRaw( '://some.domain.com/was', 'x', '/something/filePath/add' );
  test.identical( got, ':///something/filePath/add' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriOld.joinRaw( '//some.domain.com/was', '/something/filePath/add', 'x' );
  test.identical( got, '/something/filePath/add/x' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriOld.joinRaw( '://some.domain.com/was', '/something/filePath/add', 'x' );
  test.identical( got, ':///something/filePath/add/x' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriOld.joinRaw( '//some.domain.com/was', '/something/filePath/add', '/x' );
  test.identical( got, '/x' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriOld.joinRaw( '://some.domain.com/was', '/something/filePath/add', '/x' );
  test.identical( got, ':///x' );

  /* */

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriOld.joinRaw( '/some/staging/index.html', '/something/filePath/add' );
  test.identical( got, '/something/filePath/add' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriOld.joinRaw( '/some/staging/index.html', 'x', '/something/filePath/add' );
  test.identical( got, '/something/filePath/add' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriOld.joinRaw( '/some/staging/index.html', 'x', '/something/filePath/add', 'y' );
  test.identical( got, '/something/filePath/add/y' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriOld.joinRaw( '/some/staging/index.html', '/something/filePath/add', '/y' );
  test.identical( got, '/y' );

  /* */

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriOld.joinRaw( '///some/staging/index.html', '/something/filePath/add' );
  test.identical( got, '/something/filePath/add' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriOld.joinRaw( ':///some/staging/index.html', '/something/filePath/add' );
  test.identical( got, ':///something/filePath/add' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriOld.joinRaw( '///some/staging/index.html', 'x', '/something/filePath/add' );
  test.identical( got, '/something/filePath/add' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriOld.joinRaw( ':///some/staging/index.html', 'x', '/something/filePath/add' );
  test.identical( got, ':///something/filePath/add' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriOld.joinRaw( '///some/staging/index.html', 'x', '/something/filePath/add', 'y' );
  test.identical( got, '/something/filePath/add/y' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriOld.joinRaw( ':///some/staging/index.html', 'x', '/something/filePath/add', 'y' );
  test.identical( got, ':///something/filePath/add/y' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriOld.joinRaw( '///some/staging/index.html', '/something/filePath/add', '/y' );
  test.identical( got, '/y' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriOld.joinRaw( ':///some/staging/index.html', '/something/filePath/add', '/y' );
  test.identical( got, ':///y' );

  /* */

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriOld.joinRaw( 'svn+https://user@subversion.com/svn/trunk', '/something/filePath/add' );
  test.identical( got, 'svn+https:///something/filePath/add' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriOld.joinRaw( 'svn+https://user@subversion.com/svn/trunk', 'x', '/something/filePath/add' );
  test.identical( got, 'svn+https:///something/filePath/add' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriOld.joinRaw( 'svn+https://user@subversion.com/svn/trunk', 'x', '/something/filePath/add', 'y' );
  test.identical( got, 'svn+https:///something/filePath/add/y' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriOld.joinRaw( 'svn+https://user@subversion.com/svn/trunk', '/something/filePath/add', '/y' );
  test.identical( got, 'svn+https:///y' );

  /* */

  var uri = 'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor';
  var parsed = _.uriOld.parse( uri );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriOld.joinRaw( uri, '/something/filePath/add' );
  test.identical( got, 'complex+protocol:///something/filePath/add?query=here&and=here#anchor' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriOld.joinRaw( uri, 'x', '/something/filePath/add' );
  test.identical( got, 'complex+protocol:///something/filePath/add?query=here&and=here#anchor' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriOld.joinRaw( uri, 'x', '/something/filePath/add', 'y' );
  test.identical( got, 'complex+protocol:///something/filePath/add/y?query=here&and=here#anchor' );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriOld.joinRaw( uri, '/something/filePath/add', '/y' );
  test.identical( got, 'complex+protocol:///y?query=here&and=here#anchor' );

  test.case = 'prased uri at the end';
  var got = _.uriOld.joinRaw( '/something/filePath/add', 'y', uri );
  test.identical( got, 'complex+protocol:///something/filePath/add/y/www.site.com:13/path/name?query=here&and=here#anchor' );

  /* */

  test.case = 'several queries and hashes'
  var uri1 = '://user:pass@sub.host.com:8080/p/a/t/h?query1=string1#hash1';
  var uriOld = '://user:pass@sub.host.com:8080/p/a/t/h?query2=string2#hash2';
  var got = _.uriOld.joinRaw( uri1, uriOld, '/x//y//z' );
  var expected = ':///x//y//z?query1=string1&query2=string2#hash2';
  test.identical( got, expected );

  var uri = '://user:pass@sub.host.com:8080/p/a/t/h?query=string#hash';
  var got = _.uriOld.joinRaw( uri, 'x' );
  var expected = '://user:pass@sub.host.com:8080/p/a/t/h/x?query=string#hash'
  test.identical( got, expected );

  var uri = '://user:pass@sub.host.com:8080/p/a/t/h?query=string#hash';
  var got = _.uriOld.joinRaw( uri, 'x', '/y' );
  var expected = ':///y?query=string#hash';
  test.identical( got, expected );

  var uri = '://user:pass@sub.host.com:8080/p/a/t/h?query=string#hash';
  var got = _.uriOld.joinRaw( uri, '/x//y//z' );
  var expected = ':///x//y//z?query=string#hash';
  test.identical( got, expected );

  var uri = '://user:pass@sub.host.com:8080/p//a//t//h?query=string#hash';
  var got = _.uriOld.joinRaw( uri, 'x/' );
  var expected = '://user:pass@sub.host.com:8080/p//a//t//h/x?query=string#hash'
  test.identical( got, expected );

  var uri = ':///user:pass@sub.host.com:8080/p/a/t/h?query=string#hash';
  var got = _.uriOld.joinRaw( uri, 'x' );
  var expected = ':///user:pass@sub.host.com:8080/p/a/t/h/x?query=string#hash'
  test.identical( got, expected );

  var uri = ':///user:pass@sub.host.com:8080/p/a/t/h?query=string#hash';
  var got = _.uriOld.joinRaw( uri, 'x', '/y' );
  var expected = ':///y?query=string#hash'
  test.identical( got, expected );

  var uri = ':///user:pass@sub.host.com:8080/p/a/t/h?query=string#hash';
  var got = _.uriOld.joinRaw( uri, '/x//y//z' );
  var expected = ':///x//y//z?query=string#hash'
  test.identical( got, expected );

  var uri = ':///user:pass@sub.host.com:8080/p/a/t/h?query=string#hash';
  var got = _.uriOld.joinRaw( uri, 'x/' );
  var expected = ':///user:pass@sub.host.com:8080/p/a/t/h/x?query=string#hash'
  test.identical( got, expected );

  test.case = 'add absolute filePath uri with resourcePath';
  var got = _.uriOld.joinRaw( 'file:///some/file', '/something/filePath/add' );
  test.identical( got, 'file:///something/filePath/add' );

  /* */

  test.case = 'add uris';

  var got = _.uriOld.joinRaw( '//a', '//b', 'c' );
  test.identical( got, '//b/c' )

  var got = _.uriOld.joinRaw( 'b://c', 'd://e', 'f' );
  test.identical( got, 'd://c/e/f' );

  var got = _.uriOld.joinRaw( 'a://b', 'c://d/e', '//f/g' );
  test.identical( got, 'c:////f/g' )

  /* - */

  test.case = 'not global, windows path';
  var paths = [ 'c:\\', 'foo\\', 'bar\\' ];
  var expected = '/c/foo/bar/';
  var got = _.uriOld.joinRaw.apply( _.uriOld, paths );
  test.identical( got, expected );

  test.case = 'not global';
  var paths = [ '/bar/', '/baz', 'foo/', '.' ];
  var expected = '/baz/foo/.';
  var got = _.uriOld.joinRaw.apply( _.uriOld, paths );
  test.identical( got, expected );

  /* - */

  test.open( 'with nulls' );

  var paths = [ 'a', null ];
  var expected = null;
  var got = _.uriOld.joinRaw.apply( _.uriOld, paths );
  test.identical( got, expected );

  var paths = [ '/', null ];
  var expected = null;
  var got = _.uriOld.joinRaw.apply( _.uriOld, paths );
  test.identical( got, expected );

  var paths = [ 'a', null, 'b' ];
  var expected = 'b';
  var got = _.uriOld.joinRaw.apply( _.uriOld, paths );
  test.identical( got, expected );

  var paths = [ '/a', null, 'b' ];
  var expected = 'b';
  var got = _.uriOld.joinRaw.apply( _.uriOld, paths );
  test.identical( got, expected );

  var paths = [ '/a', null, '/b' ];
  var expected = '/b';
  var got = _.uriOld.joinRaw.apply( _.uriOld, paths );
  test.identical( got, expected );

  test.close( 'with nulls' );

  /* - */

  test.case = 'other special cases';

  /* xxx */

  var paths = [ '/aa', 'bb//', 'cc' ];
  var expected = '/aa/bb//cc';
  var got = _.uriOld.joinRaw.apply( _.uriOld, paths );
  test.identical( got, expected );

  var paths = [ '/aa', 'bb//', 'cc', '.' ];
  var expected = '/aa/bb//cc/.';
  var got = _.uriOld.joinRaw.apply( _.uriOld, paths );
  test.identical( got, expected );

  var paths = [ '/', 'a', '//b', '././c', '../d', '..e' ];
  var expected = '//b/././c/../d/..e';
  var got = _.uriOld.joinRaw.apply( _.uriOld, paths );
  test.identical( got, expected );

}

//

function reroot( test )
{

  // var expected = 'file:///src/file:///a';
  var expected = 'file:///src/a';
  var a = 'file:///src';
  var b = 'file:///a';
  var got = _.uriOld.reroot( a, b );
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
  var got = _.uriOld.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = '/a - /b';
  var basePath = '/a';
  var filePath = '/b';
  var expected = '../b';
  var got = _.uriOld.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = '/ - /b';
  var basePath = '/';
  var filePath = '/b';
  var expected = 'b';
  var got = _.uriOld.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'same path';
  var basePath = '/aa/bb/cc';
  var filePath = '/aa/bb/cc';
  var expected = '.';
  var got = _.uriOld.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'same path';
  var basePath = '/aa/bb/cc';
  var filePath = '/aa/bb/cc/';
  var expected = './';
  var got = _.uriOld.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'same path';
  var basePath = '/aa/bb/cc/';
  var filePath = '/aa/bb/cc';
  var expected = '.';
  var got = _.uriOld.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = '4 down';
  var basePath = '/aa//bb/cc/';
  var filePath = '//xx/yy/zz/';
  var expected = './../../../..//xx/yy/zz/';
  var got = _.uriOld.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'relative filePath parent directory';
  var basePath = '/aa/bb/cc';
  var filePath = '/aa/bb';
  var expected = '..';
  var got = _.uriOld.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'relative filePath parent directory';
  var basePath = '/aa/bb/cc/';
  var filePath = '/aa/bb';
  var expected = './..';
  var got = _.uriOld.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'relative filePath parent directory';
  var basePath = '/aa/bb/cc/';
  var filePath = '/aa/bb/';
  var expected = './../';
  var got = _.uriOld.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'relative filePath nested';
  var basePath = '/foo/bar/baz/asdf/quux';
  var filePath = '/foo/bar/baz/asdf/quux/new1';
  var expected = 'new1';
  var got = _.uriOld.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'out of relative dir';
  var basePath = '/abc';
  var filePath = '/a/b/z';
  var expected = '../a/b/z';
  var got = _.uriOld.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'relative root';
  var basePath = '/';
  var filePath = '/a/b/z';
  var expected = 'a/b/z';
  var got = _.uriOld.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'relative root';
  var basePath = '/';
  var filePath = '/';
  var expected = '.';
  var got = _.uriOld.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'windows disks';
  var basePath = 'd:/';
  var filePath = 'c:/x/y';
  var expected = '../c/x/y';
  var got = _.uriOld.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'long, not direct';
  var basePath = '/a/b/xx/yy/zz';
  var filePath = '/a/b/files/x/y/z.txt';
  var expected = '../../../files/x/y/z.txt';
  var got = _.uriOld.relative( basePath, filePath );
  test.identical( got, expected );

  test.close( 'absolute' );

  //

  test.open( 'relative' );

  /* */

  test.case = '. - .';
  var basePath = '.';
  var filePath = '.';
  var expected = '.';
  var got = _.uriOld.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'a - b';
  var basePath = 'a';
  var filePath = 'b';
  var expected = '../b';
  var got = _.uriOld.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'a/b - b/c';
  var basePath = 'a/b';
  var filePath = 'b/c';
  var expected = '../../b/c';
  var got = _.uriOld.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'a/b - a/b/c';
  var basePath = 'a/b';
  var filePath = 'a/b/c';
  var expected = 'c';
  var got = _.uriOld.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'a/b/c - a/b';
  var basePath = 'a/b/c';
  var filePath = 'a/b';
  var expected = '..';
  var got = _.uriOld.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'a/b/c - a/b';
  var basePath = 'a/b/c';
  var filePath = 'a/b';
  var expected = '..';
  var got = _.uriOld.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'a/b/c/d - a/b/d/c';
  var basePath = 'a/b/c/d';
  var filePath = 'a/b/d/c';
  var expected = '../../d/c';
  var got = _.uriOld.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'a - ../a';
  var basePath = 'a';
  var filePath = '../a';
  var expected = '../../a';
  var got = _.uriOld.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'a//b - a//c';
  var basePath = 'a//b';
  var filePath = 'a//c';
  var expected = '../c';
  var got = _.uriOld.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'a/./b - a/./c';
  var basePath = 'a/./b';
  var filePath = 'a/./c';
  var expected = '../c';
  var got = _.uriOld.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'a/../b - b';
  var basePath = 'a/../b';
  var filePath = 'b';
  var expected = '.';
  var got = _.uriOld.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'b - b/../b';
  var basePath = 'b';
  var filePath = 'b/../b';
  var expected = '.';
  var got = _.uriOld.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = '. - ..';
  var basePath = '.';
  var filePath = '..';
  var expected = '..';
  var got = _.uriOld.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = '. - ../..';
  var basePath = '.';
  var filePath = '../..';
  var expected = '../..';
  var got = _.uriOld.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = '.. - ../..';
  var basePath = '..';
  var filePath = '../..';
  var expected = '..';
  var got = _.uriOld.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = '.. - ..';
  var basePath = '..';
  var filePath = '..';
  var expected = '.';
  var got = _.uriOld.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = '../a/b - ../c/d';
  var basePath = '../a/b';
  var filePath = '../c/d';
  var expected = '../../c/d';
  var got = _.uriOld.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'a/../b/.. - b';
  var basePath = 'a/../b/..';
  var filePath = 'b';
  var expected = 'b';
  var got = _.uriOld.relative( basePath, filePath );
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
  test.shouldThrowErrorOfAnyKind( () => _.uriOld.relative( basePath, filePath ) );

  /* */

  test.case = '../a/b - ./c/d';
  var basePath = '../a/b';
  var filePath = './c/d';
  test.shouldThrowErrorOfAnyKind( () => _.uriOld.relative( basePath, filePath ) );

  /* */

  test.case = '.. - .';
  var basePath = '..';
  var filePath = '.';
  test.shouldThrowErrorOfAnyKind( () => _.uriOld.relative( basePath, filePath ) );

  /* */

  test.case = '.. - ./a';
  var basePath = '..';
  var filePath = './a';
  test.shouldThrowErrorOfAnyKind( () => _.uriOld.relative( basePath, filePath ) );

  /* */

  test.case = '../a - a';
  var basePath = '../a';
  var filePath = 'a';
  test.shouldThrowErrorOfAnyKind( () => _.uriOld.relative( basePath, filePath ) );

  test.close( 'relative' );

  //

  test.open( 'other' )

  test.case = 'missed arguments';
  test.shouldThrowErrorSync( function( )
  {
    _.uriOld.relative( basePath );
  });

  test.case = 'extra arguments';
  test.shouldThrowErrorSync( function( )
  {
    _.uriOld.relative( 'from3', 'to3', 'to4' );
  });

  test.case = 'second argument is not string or array';
  test.shouldThrowErrorSync( function( )
  {
    _.uriOld.relative( 'from3', null );
  });

  test.case = 'relative + absolute';
  test.shouldThrowErrorSync( function( )
  {
    _.uriOld.relative( '.', '/' );
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
  var got = _.uriOld.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = '/a - /b';
  var basePath = 'file:///a';
  var filePath = 'file:///b';
  var expected = 'file://../b';
  var got = _.uriOld.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = '/a - /b';
  var basePath = 'file:///a';
  var filePath = 'file:///b';
  var expected = 'file://../b';
  var got = _.uriOld.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = '/ - /b';
  var basePath = 'file:///';
  var filePath = 'file:///b';
  var expected = 'file://b';
  var got = _.uriOld.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'same path';
  var basePath = 'file:///aa/bb/cc';
  var filePath = 'file:///aa/bb/cc';
  var expected = 'file://.';
  var got = _.uriOld.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'same path';
  var basePath = 'file:///aa/bb/cc';
  var filePath = 'file:///aa/bb/cc/';
  var expected = 'file://./';
  var got = _.uriOld.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'same path';
  var basePath = 'file:///aa/bb/cc/';
  var filePath = 'file:///aa/bb/cc';
  var expected = 'file://.';
  var got = _.uriOld.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'same path';
  var basePath = 'file:///aa//bb/cc/';
  var filePath = 'file:////xx/yy/zz/';
  var expected = 'file://./../../../..//xx/yy/zz/';
  var got = _.uriOld.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'relative filePath parent directory';
  var basePath = 'file:///aa/bb/cc';
  var filePath = 'file:///aa/bb';
  var expected = 'file://..';
  var got = _.uriOld.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'relative filePath parent directory';
  var basePath = 'file:///aa/bb/cc/';
  var filePath = 'file:///aa/bb';
  var expected = 'file://./..';
  var got = _.uriOld.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'relative filePath parent directory';
  var basePath = 'file:///aa/bb/cc/';
  var filePath = 'file:///aa/bb/';
  var expected = 'file://./../';
  var got = _.uriOld.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'relative filePath nested';
  var basePath = 'file:///foo/bar/baz/asdf/quux';
  var filePath = 'file:///foo/bar/baz/asdf/quux/new1';
  var expected = 'file://new1';
  var got = _.uriOld.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'out of relative dir';
  var basePath = 'file:///abc';
  var filePath = 'file:///a/b/z';
  var expected = 'file://../a/b/z';
  var got = _.uriOld.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'relative root';
  var basePath = 'file:///';
  var filePath = 'file:///a/b/z';
  var expected = 'file://a/b/z';
  var got = _.uriOld.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'relative root';
  var basePath = 'file:///';
  var filePath = 'file:///';
  var expected = 'file://.';
  var got = _.uriOld.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'windows disks';
  var basePath = 'file://d:/';
  var filePath = 'file://c:/x/y';
  var expected = 'file://../c/x/y';
  var got = _.uriOld.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'long, not direct';
  var basePath = 'file:///a/b/xx/yy/zz';
  var filePath = 'file:///a/b/files/x/y/z.txt';
  var expected = 'file://../../../files/x/y/z.txt';
  var got = _.uriOld.relative( basePath, filePath );
  test.identical( got, expected );

  test.close( 'absolute' );

  /* - */

  test.open( 'relative' );

  /* */

  test.case = '. - .';
  var basePath = 'file://.';
  var filePath = 'file://.';
  var expected = 'file://.';
  var got = _.uriOld.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'a - b';
  var basePath = 'file://a';
  var filePath = 'file://b';
  var expected = 'file://../b';
  var got = _.uriOld.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'a/b - b/c';
  var basePath = 'file://a/b';
  var filePath = 'file://b/c';
  var expected = 'file://../../b/c';
  var got = _.uriOld.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'a/b - a/b/c';
  var basePath = 'file://a/b';
  var filePath = 'file://a/b/c';
  var expected = 'file://c';
  var got = _.uriOld.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'a/b/c - a/b';
  var basePath = 'file://a/b/c';
  var filePath = 'file://a/b';
  var expected = 'file://..';
  var got = _.uriOld.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'a/b/c - a/b';
  var basePath = 'file://a/b/c';
  var filePath = 'file://a/b';
  var expected = 'file://..';
  var got = _.uriOld.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'a/b/c/d - a/b/d/c';
  var basePath = 'file://a/b/c/d';
  var filePath = 'file://a/b/d/c';
  var expected = 'file://../../d/c';
  var got = _.uriOld.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'a - ../a';
  var basePath = 'file://a';
  var filePath = 'file://../a';
  var expected = 'file://../../a';
  var got = _.uriOld.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'a//b - a//c';
  var basePath = 'file://a//b';
  var filePath = 'file://a//c';
  var expected = 'file://../c';
  var got = _.uriOld.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'a/./b - a/./c';
  var basePath = 'file://a/./b';
  var filePath = 'file://a/./c';
  var expected = 'file://../c';
  var got = _.uriOld.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'a/../b - b';
  var basePath = 'file://a/../b';
  var filePath = 'file://b';
  var expected = 'file://.';
  var got = _.uriOld.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'b - b/../b';
  var basePath = 'file://b';
  var filePath = 'file://b/../b';
  var expected = 'file://.';
  var got = _.uriOld.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = '. - ..';
  var basePath = 'file://.';
  var filePath = 'file://..';
  var expected = 'file://..';
  var got = _.uriOld.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = '. - ../..';
  var basePath = 'file://.';
  var filePath = 'file://../..';
  var expected = 'file://../..';
  var got = _.uriOld.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = '.. - ../..';
  var basePath = 'file://..';
  var filePath = 'file://../..';
  var expected = 'file://..';
  var got = _.uriOld.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = '.. - ..';
  var basePath = '..';
  var filePath = 'file://..';
  var expected = 'file://.';
  var got = _.uriOld.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = '.. - ..';
  var basePath = 'file://..';
  var filePath = '..';
  var expected = 'file://.';
  var got = _.uriOld.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = '../a/b - ../c/d';
  var basePath = 'file://../a/b';
  var filePath = 'file://../c/d';
  var expected = 'file://../../c/d';
  var got = _.uriOld.relative( basePath, filePath );
  test.identical( got, expected );

  /* */

  test.case = 'a/../b/.. - b';
  var basePath = 'file://a/../b/..';
  var filePath = 'file://b';
  var expected = 'file://b';
  var got = _.uriOld.relative( basePath, filePath );
  test.identical( got, expected );

  test.close( 'relative' );

  /* - */

  test.open( 'absolute - options map' );

  /* */

  test.case = 'git+https:///github.com/repo/wTools - git+https:///github.com/repo/wTools#bd9094b8';
  var basePath = 'git+https:///github.com/repo/wTools';
  var filePath = 'git+https:///github.com/repo/wTools#bd9094b8';
  var expected = 'git+https://.#bd9094b8';
  var got = _.uriOld.relative({ basePath, filePath });
  test.identical( got, expected );

  /* */

  test.case = '/a - /b';
  var basePath = 'file:///a';
  var filePath = 'file:///b';
  var expected = 'file://../b';
  var got = _.uriOld.relative({ basePath, filePath });
  test.identical( got, expected );

  /* */

  test.case = '/a - /b';
  var basePath = 'file:///a';
  var filePath = 'file:///b';
  var expected = 'file://../b';
  var got = _.uriOld.relative({ basePath, filePath });
  test.identical( got, expected );

  /* */

  test.case = '/ - /b';
  var basePath = 'file:///';
  var filePath = 'file:///b';
  var expected = 'file://b';
  var got = _.uriOld.relative({ basePath, filePath });
  test.identical( got, expected );

  /* */

  test.case = 'same path';
  var basePath = 'file:///aa/bb/cc';
  var filePath = 'file:///aa/bb/cc';
  var expected = 'file://.';
  var got = _.uriOld.relative({ basePath, filePath });
  test.identical( got, expected );

  /* */

  test.case = 'same path';
  var basePath = 'file:///aa/bb/cc';
  var filePath = 'file:///aa/bb/cc/';
  var expected = 'file://./';
  var got = _.uriOld.relative({ basePath, filePath });
  test.identical( got, expected );

  /* */

  test.case = 'same path';
  var basePath = 'file:///aa/bb/cc/';
  var filePath = 'file:///aa/bb/cc';
  var expected = 'file://.';
  var got = _.uriOld.relative({ basePath, filePath });
  test.identical( got, expected );

  /* */

  test.case = 'same path';
  var basePath = 'file:///aa//bb/cc/';
  var filePath = 'file:////xx/yy/zz/';
  var expected = 'file://./../../../..//xx/yy/zz/';
  var got = _.uriOld.relative({ basePath, filePath });
  test.identical( got, expected );

  /* */

  test.case = 'relative filePath parent directory';
  var basePath = 'file:///aa/bb/cc';
  var filePath = 'file:///aa/bb';
  var expected = 'file://..';
  var got = _.uriOld.relative({ basePath, filePath });
  test.identical( got, expected );

  /* */

  test.case = 'relative filePath parent directory';
  var basePath = 'file:///aa/bb/cc/';
  var filePath = 'file:///aa/bb';
  var expected = 'file://./..';
  var got = _.uriOld.relative({ basePath, filePath });
  test.identical( got, expected );

  /* */

  test.case = 'relative filePath parent directory';
  var basePath = 'file:///aa/bb/cc/';
  var filePath = 'file:///aa/bb/';
  var expected = 'file://./../';
  var got = _.uriOld.relative({ basePath, filePath });
  test.identical( got, expected );

  /* */

  test.case = 'relative filePath nested';
  var basePath = 'file:///foo/bar/baz/asdf/quux';
  var filePath = 'file:///foo/bar/baz/asdf/quux/new1';
  var expected = 'file://new1';
  var got = _.uriOld.relative({ basePath, filePath });
  test.identical( got, expected );

  /* */

  test.case = 'out of relative dir';
  var basePath = 'file:///abc';
  var filePath = 'file:///a/b/z';
  var expected = 'file://../a/b/z';
  var got = _.uriOld.relative({ basePath, filePath });
  test.identical( got, expected );

  /* */

  test.case = 'relative root';
  var basePath = 'file:///';
  var filePath = 'file:///a/b/z';
  var expected = 'file://a/b/z';
  var got = _.uriOld.relative({ basePath, filePath });
  test.identical( got, expected );

  /* */

  test.case = 'relative root';
  var basePath = 'file:///';
  var filePath = 'file:///';
  var expected = 'file://.';
  var got = _.uriOld.relative({ basePath, filePath });
  test.identical( got, expected );

  /* */

  test.case = 'windows disks';
  var basePath = 'file://d:/';
  var filePath = 'file://c:/x/y';
  var expected = 'file://../c/x/y';
  var got = _.uriOld.relative({ basePath, filePath });
  test.identical( got, expected );

  /* */

  test.case = 'long, not direct';
  var basePath = 'file:///a/b/xx/yy/zz';
  var filePath = 'file:///a/b/files/x/y/z.txt';
  var expected = 'file://../../../files/x/y/z.txt';
  var got = _.uriOld.relative({ basePath, filePath });
  test.identical( got, expected );

  test.close( 'absolute - options map' );

  /* - */

  test.open( 'relative - options map' );

  /* */

  test.case = '. - .';
  var basePath = 'file://.';
  var filePath = 'file://.';
  var expected = 'file://.';
  var got = _.uriOld.relative({ basePath, filePath });
  test.identical( got, expected );

  /* */

  test.case = 'a - b';
  var basePath = 'file://a';
  var filePath = 'file://b';
  var expected = 'file://../b';
  var got = _.uriOld.relative({ basePath, filePath });
  test.identical( got, expected );

  /* */

  test.case = 'a/b - b/c';
  var basePath = 'file://a/b';
  var filePath = 'file://b/c';
  var expected = 'file://../../b/c';
  var got = _.uriOld.relative({ basePath, filePath });
  test.identical( got, expected );

  /* */

  test.case = 'a/b - a/b/c';
  var basePath = 'file://a/b';
  var filePath = 'file://a/b/c';
  var expected = 'file://c';
  var got = _.uriOld.relative({ basePath, filePath });
  test.identical( got, expected );

  /* */

  test.case = 'a/b/c - a/b';
  var basePath = 'file://a/b/c';
  var filePath = 'file://a/b';
  var expected = 'file://..';
  var got = _.uriOld.relative({ basePath, filePath });
  test.identical( got, expected );

  /* */

  test.case = 'a/b/c - a/b';
  var basePath = 'file://a/b/c';
  var filePath = 'file://a/b';
  var expected = 'file://..';
  var got = _.uriOld.relative({ basePath, filePath });
  test.identical( got, expected );

  /* */

  test.case = 'a/b/c/d - a/b/d/c';
  var basePath = 'file://a/b/c/d';
  var filePath = 'file://a/b/d/c';
  var expected = 'file://../../d/c';
  var got = _.uriOld.relative({ basePath, filePath });
  test.identical( got, expected );

  /* */

  test.case = 'a - ../a';
  var basePath = 'file://a';
  var filePath = 'file://../a';
  var expected = 'file://../../a';
  var got = _.uriOld.relative({ basePath, filePath });
  test.identical( got, expected );

  /* */

  test.case = 'a//b - a//c';
  var basePath = 'file://a//b';
  var filePath = 'file://a//c';
  var expected = 'file://../c';
  var got = _.uriOld.relative({ basePath, filePath });
  test.identical( got, expected );

  /* */

  test.case = 'a/./b - a/./c';
  var basePath = 'file://a/./b';
  var filePath = 'file://a/./c';
  var expected = 'file://../c';
  var got = _.uriOld.relative({ basePath, filePath });
  test.identical( got, expected );

  /* */

  test.case = 'a/../b - b';
  var basePath = 'file://a/../b';
  var filePath = 'file://b';
  var expected = 'file://.';
  var got = _.uriOld.relative({ basePath, filePath });
  test.identical( got, expected );

  /* */

  test.case = 'b - b/../b';
  var basePath = 'file://b';
  var filePath = 'file://b/../b';
  var expected = 'file://.';
  var got = _.uriOld.relative({ basePath, filePath });
  test.identical( got, expected );

  /* */

  test.case = '. - ..';
  var basePath = 'file://.';
  var filePath = 'file://..';
  var expected = 'file://..';
  var got = _.uriOld.relative({ basePath, filePath });
  test.identical( got, expected );

  /* */

  test.case = '. - ../..';
  var basePath = 'file://.';
  var filePath = 'file://../..';
  var expected = 'file://../..';
  var got = _.uriOld.relative({ basePath, filePath });
  test.identical( got, expected );

  /* */

  test.case = '.. - ../..';
  var basePath = 'file://..';
  var filePath = 'file://../..';
  var expected = 'file://..';
  var got = _.uriOld.relative({ basePath, filePath });
  test.identical( got, expected );

  /* */

  test.case = '.. - ..';
  var basePath = '..';
  var filePath = 'file://..';
  var expected = 'file://.';
  var got = _.uriOld.relative({ basePath, filePath });
  test.identical( got, expected );

  /* */

  test.case = '.. - ..';
  var basePath = 'file://..';
  var filePath = '..';
  var expected = 'file://.';
  var got = _.uriOld.relative({ basePath, filePath });
  test.identical( got, expected );

  /* */

  test.case = '../a/b - ../c/d';
  var basePath = 'file://../a/b';
  var filePath = 'file://../c/d';
  var expected = 'file://../../c/d';
  var got = _.uriOld.relative({ basePath, filePath });
  test.identical( got, expected );

  /* */

  test.case = 'a/../b/.. - b';
  var basePath = 'file://a/../b/..';
  var filePath = 'file://b';
  var expected = 'file://b';
  var got = _.uriOld.relative({ basePath, filePath });
  test.identical( got, expected );

  test.close( 'relative - options map' );

  /* - */

  test.open( 'absolute - global:0' );

  /* */

  test.case = 'git+https:///github.com/repo/wTools - git+https:///github.com/repo/wTools#bd9094b8';
  var basePath = 'git+https:///github.com/repo/wTools';
  var filePath = 'git+https:///github.com/repo/wTools#bd9094b8';
  var expected = '.#bd9094b8';
  var got = _.uriOld.relative({ basePath, filePath, global : 0 });
  test.identical( got, expected );

  /* */

  test.case = '/a - /b';
  var basePath = 'file:///a';
  var filePath = 'file:///b';
  var expected = '../b';
  var got = _.uriOld.relative({ basePath, filePath, global : 0 });
  test.identical( got, expected );

  /* */

  test.case = '/a - /b';
  var basePath = 'file:///a';
  var filePath = 'file:///b';
  var expected = '../b';
  var got = _.uriOld.relative({ basePath, filePath, global : 0 });
  test.identical( got, expected );

  /* */

  test.case = '/ - /b';
  var basePath = 'file:///';
  var filePath = 'file:///b';
  var expected = 'b';
  var got = _.uriOld.relative({ basePath, filePath, global : 0 });
  test.identical( got, expected );

  /* */

  test.case = 'same path';
  var basePath = 'file:///aa/bb/cc';
  var filePath = 'file:///aa/bb/cc';
  var expected = '.';
  var got = _.uriOld.relative({ basePath, filePath, global : 0 });
  test.identical( got, expected );

  /* */

  test.case = 'same path';
  var basePath = 'file:///aa/bb/cc';
  var filePath = 'file:///aa/bb/cc/';
  var expected = './';
  var got = _.uriOld.relative({ basePath, filePath, global : 0 });
  test.identical( got, expected );

  /* */

  test.case = 'same path';
  var basePath = 'file:///aa/bb/cc/';
  var filePath = 'file:///aa/bb/cc';
  var expected = '.';
  var got = _.uriOld.relative({ basePath, filePath, global : 0 });
  test.identical( got, expected );

  /* */

  test.case = 'same path';
  var basePath = 'file:///aa//bb/cc/';
  var filePath = 'file:////xx/yy/zz/';
  var expected = './../../../..//xx/yy/zz/';
  var got = _.uriOld.relative({ basePath, filePath, global : 0 });
  test.identical( got, expected );

  /* */

  test.case = 'relative filePath parent directory';
  var basePath = 'file:///aa/bb/cc';
  var filePath = 'file:///aa/bb';
  var expected = '..';
  var got = _.uriOld.relative({ basePath, filePath, global : 0 });
  test.identical( got, expected );

  /* */

  test.case = 'relative filePath parent directory';
  var basePath = 'file:///aa/bb/cc/';
  var filePath = 'file:///aa/bb';
  var expected = './..';
  var got = _.uriOld.relative({ basePath, filePath, global : 0 });
  test.identical( got, expected );

  /* */

  test.case = 'relative filePath parent directory';
  var basePath = 'file:///aa/bb/cc/';
  var filePath = 'file:///aa/bb/';
  var expected = './../';
  var got = _.uriOld.relative({ basePath, filePath, global : 0 });
  test.identical( got, expected );

  /* */

  test.case = 'relative filePath nested';
  var basePath = 'file:///foo/bar/baz/asdf/quux';
  var filePath = 'file:///foo/bar/baz/asdf/quux/new1';
  var expected = 'new1';
  var got = _.uriOld.relative({ basePath, filePath, global : 0 });
  test.identical( got, expected );

  /* */

  test.case = 'out of relative dir';
  var basePath = 'file:///abc';
  var filePath = 'file:///a/b/z';
  var expected = '../a/b/z';
  var got = _.uriOld.relative({ basePath, filePath, global : 0 });
  test.identical( got, expected );

  /* */

  test.case = 'relative root';
  var basePath = 'file:///';
  var filePath = 'file:///a/b/z';
  var expected = 'a/b/z';
  var got = _.uriOld.relative({ basePath, filePath, global : 0 });
  test.identical( got, expected );

  /* */

  test.case = 'relative root';
  var basePath = 'file:///';
  var filePath = 'file:///';
  var expected = '.';
  var got = _.uriOld.relative({ basePath, filePath, global : 0 });
  test.identical( got, expected );

  /* */

  test.case = 'windows disks';
  var basePath = 'file://d:/';
  var filePath = 'file://c:/x/y';
  var expected = '../c/x/y';
  var got = _.uriOld.relative({ basePath, filePath, global : 0 });
  test.identical( got, expected );

  /* */

  test.case = 'long, not direct';
  var basePath = 'file:///a/b/xx/yy/zz';
  var filePath = 'file:///a/b/files/x/y/z.txt';
  var expected = '../../../files/x/y/z.txt';
  var got = _.uriOld.relative({ basePath, filePath, global : 0 });
  test.identical( got, expected );

  test.close( 'absolute - global:0' );

  /* - */

  test.open( 'relative - global:0' );

  /* */

  test.case = '. - .';
  var basePath = 'file://.';
  var filePath = 'file://.';
  var expected = '.';
  var got = _.uriOld.relative({ basePath, filePath, global : 0 });
  test.identical( got, expected );

  /* */

  test.case = 'a - b';
  var basePath = 'file://a';
  var filePath = 'file://b';
  var expected = '../b';
  var got = _.uriOld.relative({ basePath, filePath, global : 0 });
  test.identical( got, expected );

  /* */

  test.case = 'a/b - b/c';
  var basePath = 'file://a/b';
  var filePath = 'file://b/c';
  var expected = '../../b/c';
  var got = _.uriOld.relative({ basePath, filePath, global : 0 });
  test.identical( got, expected );

  /* */

  test.case = 'a/b - a/b/c';
  var basePath = 'file://a/b';
  var filePath = 'file://a/b/c';
  var expected = 'c';
  var got = _.uriOld.relative({ basePath, filePath, global : 0 });
  test.identical( got, expected );

  /* */

  test.case = 'a/b/c - a/b';
  var basePath = 'file://a/b/c';
  var filePath = 'file://a/b';
  var expected = '..';
  var got = _.uriOld.relative({ basePath, filePath, global : 0 });
  test.identical( got, expected );

  /* */

  test.case = 'a/b/c - a/b';
  var basePath = 'file://a/b/c';
  var filePath = 'file://a/b';
  var expected = '..';
  var got = _.uriOld.relative({ basePath, filePath, global : 0 });
  test.identical( got, expected );

  /* */

  test.case = 'a/b/c/d - a/b/d/c';
  var basePath = 'file://a/b/c/d';
  var filePath = 'file://a/b/d/c';
  var expected = '../../d/c';
  var got = _.uriOld.relative({ basePath, filePath, global : 0 });
  test.identical( got, expected );

  /* */

  test.case = 'a - ../a';
  var basePath = 'file://a';
  var filePath = 'file://../a';
  var expected = '../../a';
  var got = _.uriOld.relative({ basePath, filePath, global : 0 });
  test.identical( got, expected );

  /* */

  test.case = 'a//b - a//c';
  var basePath = 'file://a//b';
  var filePath = 'file://a//c';
  var expected = '../c';
  var got = _.uriOld.relative({ basePath, filePath, global : 0 });
  test.identical( got, expected );

  /* */

  test.case = 'a/./b - a/./c';
  var basePath = 'file://a/./b';
  var filePath = 'file://a/./c';
  var expected = '../c';
  var got = _.uriOld.relative({ basePath, filePath, global : 0 });
  test.identical( got, expected );

  /* */

  test.case = 'a/../b - b';
  var basePath = 'file://a/../b';
  var filePath = 'file://b';
  var expected = '.';
  var got = _.uriOld.relative({ basePath, filePath, global : 0 });
  test.identical( got, expected );

  /* */

  test.case = 'b - b/../b';
  var basePath = 'file://b';
  var filePath = 'file://b/../b';
  var expected = '.';
  var got = _.uriOld.relative({ basePath, filePath, global : 0 });
  test.identical( got, expected );

  /* */

  test.case = '. - ..';
  var basePath = 'file://.';
  var filePath = 'file://..';
  var expected = '..';
  var got = _.uriOld.relative({ basePath, filePath, global : 0 });
  test.identical( got, expected );

  /* */

  test.case = '. - ../..';
  var basePath = 'file://.';
  var filePath = 'file://../..';
  var expected = '../..';
  var got = _.uriOld.relative({ basePath, filePath, global : 0 });
  test.identical( got, expected );

  /* */

  test.case = '.. - ../..';
  var basePath = 'file://..';
  var filePath = 'file://../..';
  var expected = '..';
  var got = _.uriOld.relative({ basePath, filePath, global : 0 });
  test.identical( got, expected );

  /* */

  test.case = '.. - ..';
  var basePath = '..';
  var filePath = 'file://..';
  var expected = 'file://.';
  var got = _.uriOld.relative({ basePath, filePath, global : 0 });
  test.identical( got, expected );

  /* */

  test.case = '.. - ..';
  var basePath = 'file://..';
  var filePath = '..';
  var expected = '.';
  var got = _.uriOld.relative({ basePath, filePath, global : 0 });
  test.identical( got, expected );

  /* */

  test.case = '../a/b - ../c/d';
  var basePath = 'file://../a/b';
  var filePath = 'file://../c/d';
  var expected = '../../c/d';
  var got = _.uriOld.relative({ basePath, filePath, global : 0 });
  test.identical( got, expected );

  /* */

  test.case = 'a/../b/.. - b';
  var basePath = 'file://a/../b/..';
  var filePath = 'file://b';
  var expected = 'b';
  var got = _.uriOld.relative({ basePath, filePath, global : 0 });
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
  test.shouldThrowErrorOfAnyKind( () => _.uriOld.relative( basePath, filePath ) );

  /* */

  test.case = '../a/b - ./c/d';
  var basePath = 'file://../a/b';
  var filePath = 'file://./c/d';
  test.shouldThrowErrorOfAnyKind( () => _.uriOld.relative( basePath, filePath ) );

  /* */

  test.case = '.. - .';
  var basePath = 'file://..';
  var filePath = 'file://.';
  test.shouldThrowErrorOfAnyKind( () => _.uriOld.relative( basePath, filePath ) );

  /* */

  test.case = '.. - ./a';
  var basePath = 'file://..';
  var filePath = 'file://./a';
  test.shouldThrowErrorOfAnyKind( () => _.uriOld.relative( basePath, filePath ) );

  /* */

  test.case = '../a - a';
  var basePath = 'file://../a';
  var filePath = 'file://a';
  test.shouldThrowErrorOfAnyKind( () => _.uriOld.relative( basePath, filePath ) );

  test.close( 'relative' );

  //

  test.open( 'other' )

  test.case = 'missed arguments';
  test.shouldThrowErrorSync( function( )
  {
    _.uriOld.relative( basePath );
  });

  test.case = 'extra arguments';
  test.shouldThrowErrorSync( function( )
  {
    _.uriOld.relative( 'from3', 'to3', 'to4' );
  });

  test.case = 'second argument is not string or array';
  test.shouldThrowErrorSync( function( )
  {
    _.uriOld.relative( 'from3', null );
  });

  test.case = 'relative + absolute';
  test.shouldThrowErrorSync( function( )
  {
    _.uriOld.relative( '.', '/' );
  });

  test.close( 'other' )

};

//

function commonLocalPaths( test )
{
  test.case = 'absolute-absolute'

  var got = _.uriOld.common( '/a1/b2', '/a1/b' );
  test.identical( got, '/a1/' );

  var got = _.uriOld.common( '/a1/b2', '/a1/b1' );
  test.identical( got, '/a1/' );

  var got = _.uriOld.common( '/a1/x/../b1', '/a1/b1' );
  test.identical( got, '/a1/b1' );

  var got = _.uriOld.common( '/a1/b1/c1', '/a1/b1/c' );
  test.identical( got, '/a1/b1/' );

  var got = _.uriOld.common( '/a1/../../b1/c1', '/a1/b1/c1' );
  test.identical( got, '/' );

  var got = _.uriOld.common( '/abcd', '/ab' );
  test.identical( got, '/' );

  var got = _.uriOld.common( '/.a./.b./.c.', '/.a./.b./.c' );
  test.identical( got, '/.a./.b./' );

  var got = _.uriOld.common( '//a//b//c', '//a/b' );
  test.identical( got, '//a/' );

  var got = _.uriOld.common( '//a//b//c', '/a/b' );
  test.identical( got, '/' );

  var got = _.uriOld.common( '/a//b', '/a//b' );
  test.identical( got, '/a//b' );

  var got = _.uriOld.common( '/a//', '/a//' );
  test.identical( got, '/a//' );

  var got = _.uriOld.common( '/./a/./b/./c', '/a/b' );
  test.identical( got, '/a/b' );

  var got = _.uriOld.common( '/A/b/c', '/a/b/c' );
  test.identical( got, '/' );

  var got = _.uriOld.common( '/', '/x' );
  test.identical( got, '/' );

  var got = _.uriOld.common( '/a', '/x' );
  test.identical( got, '/' );

  // test.case = 'absolute-relative'
  //
  // var got = _.uriOld.common( '/', '..' );
  // test.identical( got, '/' );
  //
  // var got = _.uriOld.common( '/', '.' );
  // test.identical( got, '/' );
  //
  // var got = _.uriOld.common( '/', 'x' );
  // test.identical( got, '/' );
  //
  // var got = _.uriOld.common( '/', '../..' );
  // test.identical( got, '/' );

  test.case = 'relative-relative'

  var got = _.uriOld.common( 'a1/b2', 'a1/b' );
  test.identical( got, 'a1/' );

  var got = _.uriOld.common( 'a1/b2', 'a1/b1' );
  test.identical( got, 'a1/' );

  var got = _.uriOld.common( 'a1/x/../b1', 'a1/b1' );
  test.identical( got, 'a1/b1' );

  var got = _.uriOld.common( './a1/x/../b1', 'a1/b1' );
  test.identical( got, 'a1/b1' );

  var got = _.uriOld.common( './a1/x/../b1', './a1/b1' );
  test.identical( got, 'a1/b1');

  var got = _.uriOld.common( './a1/x/../b1', '../a1/b1' );
  test.identical( got, '..');

  var got = _.uriOld.common( '.', '..' );
  test.identical( got, '..' );

  var got = _.uriOld.common( './b/c', './x' );
  test.identical( got, '.' );

  var got = _.uriOld.common( './././a', './a/b' );
  test.identical( got, 'a' );

  var got = _.uriOld.common( './a/./b', './a/b' );
  test.identical( got, 'a/b' );

  var got = _.uriOld.common( './a/./b', './a/c/../b' );
  test.identical( got, 'a/b' );

  var got = _.uriOld.common( '../b/c', './x' );
  test.identical( got, '..' );

  var got = _.uriOld.common( '../../b/c', '../b' );
  test.identical( got, '../..' );

  var got = _.uriOld.common( '../../b/c', '../../../x' );
  test.identical( got, '../../..' );

  var got = _.uriOld.common( '../../b/c/../../x', '../../../x' );
  test.identical( got, '../../..' );

  var got = _.uriOld.common( './../../b/c/../../x', './../../../x' );
  test.identical( got, '../../..' );

  var got = _.uriOld.common( '../../..', './../../..' );
  test.identical( got, '../../..' );

  var got = _.uriOld.common( './../../..', './../../..' );
  test.identical( got, '../../..' );

  var got = _.uriOld.common( '../../..', '../../..' );
  test.identical( got, '../../..' );

  var got = _.uriOld.common( '../b', '../b' );
  test.identical( got, '../b' );

  var got = _.uriOld.common( '../b', './../b' );
  test.identical( got, '../b' );

  test.case = 'several absolute paths'

  var got = _.uriOld.common( '/a/b/c', '/a/b/c', '/a/b/c' );
  test.identical( got, '/a/b/c' );

  var got = _.uriOld.common( '/a/b/c', '/a/b/c', '/a/b' );
  test.identical( got, '/a/b' );

  var got = _.uriOld.common( '/a/b/c', '/a/b/c', '/a/b1' );
  test.identical( got, '/a/' );

  var got = _.uriOld.common( '/a/b/c', '/a/b/c', '/a' );
  test.identical( got, '/a' );

  var got = _.uriOld.common( '/a/b/c', '/a/b/c', '/x' );
  test.identical( got, '/' );

  var got = _.uriOld.common( '/a/b/c', '/a/b/c', '/' );
  test.identical( got, '/' );

  test.case = 'several relative paths';

  var got = _.uriOld.common( 'a/b/c', 'a/b/c', 'a/b/c' );
  test.identical( got, 'a/b/c' );

  var got = _.uriOld.common( 'a/b/c', 'a/b/c', 'a/b' );
  test.identical( got, 'a/b' );

  var got = _.uriOld.common( 'a/b/c', 'a/b/c', 'a/b1' );
  test.identical( got, 'a/' );

  var got = _.uriOld.common( 'a/b/c', 'a/b/c', '.' );
  test.identical( got, '.' );

  var got = _.uriOld.common( 'a/b/c', 'a/b/c', 'x' );
  test.identical( got, '.' );

  var got = _.uriOld.common( 'a/b/c', 'a/b/c', './' );
  test.identical( got, '.' );

  var got = _.uriOld.common( '../a/b/c', 'a/../b/c', 'a/b/../c' );
  test.identical( got, '..' );

  var got = _.uriOld.common( './a/b/c', '../../a/b/c', '../../../a/b' );
  test.identical( got, '../../..' );

  var got = _.uriOld.common( '.', './', '..' );
  test.identical( got, '..' );

  var got = _.uriOld.common( '.', './../..', '..' );
  test.identical( got, '../..' );

  /* */

  if( !Config.debug )
  return

  test.shouldThrowErrorOfAnyKind( () => _.uriOld.common( '/a', '..' ) );
  test.shouldThrowErrorOfAnyKind( () => _.uriOld.common( '/a', '.' ) );
  test.shouldThrowErrorOfAnyKind( () => _.uriOld.common( '/a', 'x' ) );
  test.shouldThrowErrorOfAnyKind( () => _.uriOld.common( '/a', '../..' ) );

  test.shouldThrowErrorOfAnyKind( () => _.uriOld.common( '/a/b/c', '/a/b/c', './' ) );
  test.shouldThrowErrorOfAnyKind( () => _.uriOld.common( '/a/b/c', '/a/b/c', '.' ) );
  test.shouldThrowErrorOfAnyKind( () => _.uriOld.common( 'x', '/a/b/c', '/a' ) );
  test.shouldThrowErrorOfAnyKind( () => _.uriOld.common( '/a/b/c', '..', '/a' ) );
  test.shouldThrowErrorOfAnyKind( () => _.uriOld.common( '../..', '../../b/c', '/a' ) );

}

//

function common( test )
{

  test.case = 'empty';

  var got = _.uriOld.common();
  test.identical( got, null );

  var got = _.uriOld.common([]);
  test.identical( got, null );

  test.case = 'array';

  var got = _.uriOld.common([ '/a1/b2', '/a1/b' ]);
  test.identical( got, '/a1/' );

  var got = _.uriOld.common( [ '/a1/b1/c', '/a1/b1/d' ], '/a1/b2' );
  test.identical( got, '/a1/' );

  test.case = 'other';

  var got = _.uriOld.common( 'npm:///wprocedure#0.3.19', 'npm:///wprocedure' );
  test.identical( got, 'npm:///wprocedure' );

  var got = _.uriOld.common( 'npm:///wprocedure', 'npm:///wprocedure#0.3.19' );
  test.identical( got, 'npm:///wprocedure' );

  var got = _.uriOld.common( 'npm:///wprocedure#0.3.19', 'npm:///wprocedure#' );
  test.identical( got, 'npm:///wprocedure' );

  var got = _.uriOld.common( 'npm:///wprocedure#', 'npm:///wprocedure#0.3.19' );
  test.identical( got, 'npm:///wprocedure' );

  var got = _.uriOld.common( 'git+https:///github.com/repo/wTools#bd9094b83', 'git+https:///github.com/repo/wTools#master' );
  test.identical( got, 'git+https:///github.com/repo/wTools' );

  var got = _.uriOld.common( '://a1/b2', '://some/staging/index.html' );
  test.identical( got, '://.' );

  var got = _.uriOld.common( '://some/staging/index.html', '://a1/b2' );
  test.identical( got, '://.' );

  var got = _.uriOld.common( '://some/staging/index.html', '://some/staging/' );
  test.identical( got, '://some/staging/' );

  var got = _.uriOld.common( '://some/staging/index.html', '://some/stagi' );
  test.identical( got, '://some/' );

  var got = _.uriOld.common( 'file:///some/staging/index.html', ':///some/stagi' );
  test.identical( got, ':///some/' );

  var got = _.uriOld.common( 'file://some/staging/index.html', '://some/stagi' );
  test.identical( got, '://some/' );

  var got = _.uriOld.common( 'file:///some/staging/index.html', '/some/stagi' );
  test.identical( got, ':///some/' );

  var got = _.uriOld.common( 'file:///some/staging/index.html', 'file:///some/staging' );
  test.identical( got, 'file:///some/staging' );

  var got = _.uriOld.common( 'http://some', 'some/staging' );
  test.identical( got, '://some' );

  var got = _.uriOld.common( 'some/staging', 'http://some' );
  test.identical( got, '://some' );

  var got = _.uriOld.common( 'http://some.come/staging/index.html', 'some/staging' );
  test.identical( got, '://.' );

  var got = _.uriOld.common( 'http:///some.come/staging/index.html', '/some/staging' );
  test.identical( got, ':///' );

  var got = _.uriOld.common( 'http://some.come/staging/index.html', 'file://some/staging' );
  test.identical( got, '' );

  var got = _.uriOld.common( 'http:///some.come/staging/index.html', 'file:///some/staging' );
  test.identical( got, '' );

  var got = _.uriOld.common( 'http:///some.come/staging/index.html', 'http:///some/staging/file.html' );
  test.identical( got, 'http:///' );

  var got = _.uriOld.common( 'http://some.come/staging/index.html', 'http://some.come/some/staging/file.html' );
  test.identical( got, 'http://some.come/' );

  // xxx !!! : implement
  var got = _.uriOld.common( 'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor', 'complex+protocol://www.site.com:13/path' );
  test.identical( got, 'complex+protocol://www.site.com:13/path' );

  var got = _.uriOld.common( 'complex+protocol://www.site.com:13/path', 'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor' );
  test.identical( got, 'complex+protocol://www.site.com:13/path' );

  var got = _.uriOld.common( 'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor', 'complex+protocol://www.site.com:13/path?query=here' );
  test.identical( got, 'complex+protocol://www.site.com:13/path' );

  var got = _.uriOld.common( 'complex+protocol://www.site.com:13/path?query=here', 'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor' );
  test.identical( got, 'complex+protocol://www.site.com:13/path' );

  var got = _.uriOld.common( 'https://user:pass@sub.host.com:8080/p/a/t/h?query=string#hash', 'https://user:pass@sub.host.com:8080/p/a' );
  test.identical( got, 'https://user:pass@sub.host.com:8080/p/a' );

  var got = _.uriOld.common( '://some/staging/a/b/c', '://some/staging/a/b/c/index.html', '://some/staging/a/x' );
  test.identical( got, '://some/staging/a/' );

  var got = _.uriOld.common( 'http:///', 'http:///' );
  test.identical( got, 'http:///' );

  var got = _.uriOld.common( '/some/staging/a/b/c' );
  test.identical( got, '/some/staging/a/b/c' );

  test.case = 'combination of diff strcutures';

  var got = _.uriOld.common( [ 'http:///' ], [ 'http:///' ] )
  test.identical( got, 'http:///' );

  var got = _.uriOld.common( [ 'http:///x' ], [ 'http:///y' ] )
  test.identical( got, 'http:///' );

  var got = _.uriOld.common( [ 'http:///a/x' ], [ 'http:///a/y' ] )
  test.identical( got, 'http:///a/' );

  var got = _.uriOld.common( [ 'http:///a/x' ], 'http:///a/y' )
  test.identical( got, 'http:///a/' );

  var got = _.uriOld.common( 'http:///a/x', [ 'http:///a/y' ] )
  test.identical( got, 'http:///a/' );

  var got = _.uriOld.common( 'http:///a/x', 'http:///a/y' )
  test.identical( got, 'http:///a/' );

  var got = _.uriOld.common( [ [ 'http:///a/x' ], 'http:///a/y' ], 'http:///a/z' )
  test.identical( got, 'http:///a/' );

  /*
    var got = _.uriOld.common( 'http://some.come/staging/index.html', 'file:///some/staging' );
    var got = _.uriOld.common( 'http://some.come/staging/index.html', 'http:///some/staging/file.html' );

  */

  /* */

  if( !Config.debug )
  return

  test.shouldThrowErrorOfAnyKind( () => _.uriOld.common( 'http://some.come/staging/index.html', 'file:///some/staging' ) );
  test.shouldThrowErrorOfAnyKind( () => _.uriOld.common( 'http://some.come/staging/index.html', 'http:///some/staging/file.html' ) );
  // test.shouldThrowErrorOfAnyKind( () => _.uriOld.common([]) );
  // test.shouldThrowErrorOfAnyKind( () => _.uriOld.common() );
  // test.shouldThrowErrorOfAnyKind( () => _.uriOld.common( [ 'http:///' ], [ 'http:///' ] ) );
  // test.shouldThrowErrorOfAnyKind( () => _.uriOld.common( [ 'http:///' ], 'http:///' ) );

}

//

function commonMapsInArgs( test )
{
  test.case = 'array with paths';
  var src1 = _.uriOld.parseFull( '/a1/b2' );
  var src2 = _.uriOld.parse( '/a1/b' );
  var got = _.uriOld.common( [ src1, src2 ] );
  test.identical( got, '/a1/' );

  test.case = 'array with paths and path';
  var src1 = _.uriOld.parseFull( '/a1/b1/c' );
  var src2 = _.uriOld.parse( '/a1/b1/d' );
  var src3 = _.uriOld.parseAtomic( '/a1/b2' );
  var got = _.uriOld.common( [ src1, src2 ], src3 );
  test.identical( got, '/a1/' );

  /* */

  test.case = 'equal protocols and local path';
  var src1 = _.uriOld.parse( 'npm:///wprocedure#0.3.19' );
  var src2 = _.uriOld.parse( 'npm:///wprocedure' );
  var got = _.uriOld.common( src1, src2 );
  test.identical( got, 'npm:///wprocedure' );

  test.case = 'equal protocols, local paths has anchor tags';
  var src1 = _.uriOld.parseAtomic( 'npm:///wprocedure#0.3.19' );
  var src2 = _.uriOld.parseAtomic( 'npm:///wprocedure#' );
  var got = _.uriOld.common( src1, src2 );
  test.identical( got, 'npm:///wprocedure' );

  test.case = 'equal complex protocols and local paths';
  var src1 = _.uriOld.parseConsecutive( 'git+https:///github.com/repo/wTools#bd9094b83' );
  var src2 = _.uriOld.parseConsecutive( 'git+https:///github.com/repo/wTools#master' );
  var got = _.uriOld.common( src1, src2 );
  test.identical( got, 'git+https:///github.com/repo/wTools' );

  test.case = 'without protocols, local paths is different';
  var src1 = _.uriOld.parseFull( '://a1/b2' );
  var src2 = _.uriOld.parseFull( '://some/staging/index.html' );
  var got = _.uriOld.common( src1, src2 );
  test.identical( got, '://.' );

  test.case = 'without protocols, local paths partly equal';
  var src1 = _.uriOld.parse( '://some/staging/index.html' );
  var src2 = _.uriOld.parseFull( '://some/staging/' );
  var got = _.uriOld.common( src1, src2 );
  test.identical( got, '://some/staging/' );

  test.case = 'without protocols, local paths partly equal, not full subpath';
  var src1 = _.uriOld.parseAtomic( '://some/staging/index.html' );
  var src2 = _.uriOld.parseFull( '://some/stagi' );
  var got = _.uriOld.common( src1, src2 );
  test.identical( got, '://some/' );

  test.case = 'local paths partly equal, not full subpath';
  var src1 = _.uriOld.parseConsecutive( 'file:///some/staging/index.html' );
  var src2 = _.uriOld.parseFull( ':///some/stagi' );
  var got = _.uriOld.common( src1, src2 );
  test.identical( got, ':///some/' );

  test.case = 'local paths partly equal, not full subpath';
  var src1 = _.uriOld.parse( 'file://some/staging/index.html' );
  var src2 = _.uriOld.parseFull( '://some/stagi' );
  var got = _.uriOld.common( src1, src2 );
  test.identical( got, '://some/' );

  test.case = 'local paths partly equal, not full subpath';
  var src1 = _.uriOld.parseConsecutive( 'file:///some/staging/index.html' );
  var src2 = _.uriOld.parseAtomic( '/some/stagi' );
  var got = _.uriOld.common( src1, src2 );
  test.identical( got, ':///some/' );

  test.case = 'equal protocols, local paths partly equal, not full subpath';
  var src1 = _.uriOld.parseFull( 'file:///some/staging/index.html' );
  var src2 = _.uriOld.parseConsecutive( 'file:///some/staging' );
  var got = _.uriOld.common( src1, src2 );
  test.identical( got, 'file:///some/staging' );

  test.case = 'path with protocol and without it, partly equal';
  var src1 = _.uriOld.parse( 'http://some' );
  var src2 = _.uriOld.parse( 'some/staging' );
  var got = _.uriOld.common( src1, src2 );
  test.identical( got, '://some' );

  test.case = 'path with protocol and without it, local paths is not equal';
  var src1 = _.uriOld.parse( 'http:///some.come/staging/index.html' );
  var src2 = _.uriOld.parseFull( '/some/staging' );
  var got = _.uriOld.common( src1, src2 );
  test.identical( got, ':///' );

  test.case = 'different protocols and local paths';
  var src1 = _.uriOld.parseFull( 'http://some.come/staging/index.html' );
  var src2 = _.uriOld.parseFull( 'file://some/staging' );
  var got = _.uriOld.common( src1, src2 );
  test.identical( got, '' );

  test.case = 'path with protocol and without it, local paths is not equal';
  var src1 = _.uriOld.parseConsecutive( 'http:///some.come/staging/index.html' );
  var src2 = _.uriOld.parse( 'file:///some/staging' );
  var got = _.uriOld.common( src1, src2 );
  test.identical( got, '' );

  test.case = 'the same protocols';
  var src1 = _.uriOld.parseAtomic( 'http:///some.come/staging/index.html' );
  var src2 = _.uriOld.parseConsecutive( 'http:///some/staging/file.html' );
  var got = _.uriOld.common( src1, src2 );
  test.identical( got, 'http:///' );

  test.case = 'path with equal protocols, begin of local paths is equal';
  var src1 = _.uriOld.parseFull( 'http://some.come/staging/index.html' );
  var src2 = _.uriOld.parse( 'http://some.come/some/staging/file.html' );
  var got = _.uriOld.common( src1, src2 );
  test.identical( got, 'http://some.come/' );

  test.case = 'one path has queries and anchor';
  var src1 = _.uriOld.parse( 'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor' );
  var src2 = _.uriOld.parseConsecutive( 'complex+protocol://www.site.com:13/path' );
  var got = _.uriOld.common( src1, src2 );
  test.identical( got, 'complex+protocol://www.site.com:13/path' );

  test.case = 'two paths has equal begin, second paths has not full query and anchor';
  var src1 = _.uriOld.parse( 'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor' );
  var src2 = _.uriOld.parseAtomic( 'complex+protocol://www.site.com:13/path?query=here' );
  var got = _.uriOld.common( src1, src2 );
  test.identical( got, 'complex+protocol://www.site.com:13/path' );

  test.case = 'paths with ports';
  var src1 = _.uriOld.parseFull( 'https://user:pass@sub.host.com:8080/p/a/t/h?query=string#hash' );
  var src2 = _.uriOld.parseAtomic( 'https://user:pass@sub.host.com:8080/p/a' );
  var got = _.uriOld.common( src1, src2 );
  test.identical( got, 'https://user:pass@sub.host.com:8080/p/a' );

  test.case = 'three paths';
  var src1 = _.uriOld.parse( '://some/staging/a/b/c' );
  var src2 = _.uriOld.parse( '://some/staging/a/b/c/index.html' );
  var got = _.uriOld.common( src1, src2, '://some/staging/a/x' );
  test.identical( got, '://some/staging/a/' );

  test.case = 'one map and one string path, only protocols';
  var src = _.uriOld.parseAtomic( 'http:///' );
  var got = _.uriOld.common( src, 'http:///' );
  test.identical( got, 'http:///' );

  test.case = 'one path';
  var src = _.uriOld.parse( '/some/staging/a/b/c' );
  var got = _.uriOld.common( src );
  test.identical( got, '/some/staging/a/b/c' );

  /* */

  test.case = 'string and map path in longs, only protocols';
  var src = _.uriOld.parse( 'http:///' );
  var got = _.uriOld.common( [ 'http:///' ], [ src ] )
  test.identical( got, 'http:///' );

  test.case = 'string and map path in longs, protocols and local paths';
  var src = _.uriOld.parseFull( 'http:///y' );
  var got = _.uriOld.common( [ 'http:///x' ], [ src ] )
  test.identical( got, 'http:///' );

  test.case = 'string and map path in longs, protocols and local paths, local paths partly equal';
  var src = _.uriOld.parseAtomic( 'http:///a/x' );
  var got = _.uriOld.common( [ src ], [ 'http:///a/y' ] )
  test.identical( got, 'http:///a/' );

  test.case = 'paths nested in few levels';
  var src = _.uriOld.parseConsecutive( 'http:///a/x' );
  var got = _.uriOld.common( [ [ [ src ] ] ], 'http:///a/y' )
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
  var got = _.uriOld.groupTextualReport( _.props.extend( null, defaults ) );
  var expected = '0 file(s)';
  test.identical( got, expected );

  test.case = 'explanation only';
  var o =
  {
    explanation : '- Deleted '
  }
  var got = _.uriOld.groupTextualReport( _.props.extend( null, defaults, o ) );
  var expected = '- Deleted 0 file(s)';
  test.identical( got, expected );

  test.case = 'spentTime only';
  var o =
  {
    spentTime : 5000
  }
  var got = _.uriOld.groupTextualReport( _.props.extend( null, defaults, o ) );
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
  var got = _.uriOld.groupTextualReport( _.props.extend( null, defaults, o ) );
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
  var got = _.uriOld.groupTextualReport( _.props.extend( null, defaults, o ) );
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
  var got = _.uriOld.groupTextualReport( _.props.extend( null, defaults, o ) );
  var expected =
`  '/a'
            '/a/b'
            '/b'
            '/b/c'
             4 at /
             2 at ./a
             2 at ./b
          - Deleted 4 file(s), at /, in 5.000s
`
  test.equivalent( got, expected );

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
  var got = _.uriOld.groupTextualReport( _.props.extend( null, defaults, o ) );
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

  /*  */

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
  var got = _.uriOld.groupTextualReport( _.props.extend( null, defaults, o ) );
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
  var got = _.uriOld.groupTextualReport( _.props.extend( null, defaults, o ) );
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
  var got = _.uriOld.groupTextualReport( _.props.extend( null, defaults, o ) );
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
  var got = _.uriOld.groupTextualReport( _.props.extend( null, defaults, o ) );
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
  var got = _.uriOld.commonTextualReport( filePath );
  test.identical( got, filePath );

  test.case = 'empty array';
  var filePath = [];
  var expected = '()';
  var got = _.uriOld.commonTextualReport( filePath );
  test.identical( got, expected );

  test.case = 'single string in array';
  var filePath = [ 'npm:///wprocedure#0.3.19' ];
  var expected = filePath[ 0 ];
  var got = _.uriOld.commonTextualReport( filePath );
  test.identical( got, expected );

  test.case = 'two, same';
  var filePath = [ 'npm:///wprocedure#0.3.19', 'npm:///wprocedure#0.3.19' ];
  var expected = '( npm:///wprocedure#0.3.19 + [ . , . ] )';
  var got = _.uriOld.commonTextualReport( filePath );
  test.identical( got, expected );

  test.case = 'two, same protocol and path, diffent hash';
  var filePath = [ 'npm:///wprocedure#0.3.19', 'npm:///wprocedure#0.3.18' ];
  var expected = '( npm:///wprocedure + [ .#0.3.19 , .#0.3.18 ] )';
  var got = _.uriOld.commonTextualReport( filePath );
  test.identical( got, expected );

  test.case = 'two, different, common protocol and hash';
  var filePath = [ 'npm:///wprocedure#0.3.19', 'npm:///wfiles#0.3.19' ];
  var expected = '( npm:///#0.3.19 + [ wprocedure , wfiles ] )';
  var got = _.uriOld.commonTextualReport( filePath );
  test.identical( got, expected );

  test.case = 'two, different, common protocol';
  var filePath = [ 'npm:///wprocedure#0.3.19', 'npm:///wfiles#0.3.18' ];
  var expected = '( npm:/// + [ wprocedure#0.3.19 , wfiles#0.3.18 ] )';
  var got = _.uriOld.commonTextualReport( filePath );
  test.identical( got, expected );

  test.case = 'two, different, common protocol';
  var filePath = [ 'npm:///wprocedure', 'npm:///wfiles#0.3.18' ];
  var expected = '( npm:/// + [ wprocedure , wfiles#0.3.18 ] )';
  var got = _.uriOld.commonTextualReport( filePath );
  test.identical( got, expected );

  test.case = 'two, different';
  var filePath = [ 'npm:///wprocedure', 'file:///a/b/c' ];
  var expected = '[ npm:///wprocedure , file:///a/b/c ]';
  var got = _.uriOld.commonTextualReport( filePath );
  test.identical( got, expected );

  test.case = 'three, two have common protocol';
  var filePath = [ 'npm:///wprocedure', 'file:///a/b/c', 'npm:///wfiles' ];
  var expected = '[ npm:///wprocedure , file:///a/b/c , npm:///wfiles ]';
  var got = _.uriOld.commonTextualReport( filePath );
  test.identical( got, expected );

  test.case = 'two, part of path is diffent, common protocol';
  var filePath = [ 'file:///a/b/c', 'file:///a/x/c' ];
  var expected = '( file:///a/ + [ ./b/c , ./x/c ] )';
  var got = _.uriOld.commonTextualReport( filePath );
  test.identical( got, expected );

  test.case = 'two relatives, common protocol and part of path';
  var filePath = [ 'file://a/b/c', 'file://a/x/c' ];
  var expected = '( file://a/ + [ ./b/c , ./x/c ] )';
  var got = _.uriOld.commonTextualReport( filePath );
  test.identical( got, expected );

  test.case = 'two different relatives, common protocol';
  var filePath = [ 'file://a/b', 'file://c/d' ];
  var expected = '( file://. + [ a/b , c/d ] )';
  var got = _.uriOld.commonTextualReport( filePath );
  test.identical( got, expected );

  test.close( 'globals' );

  /*  */

  test.open( 'locals' );

  test.case = 'single';
  var filePath = [ '/wprocedure#0.3.19' ];
  var expected = filePath[ 0 ];
  var got = _.uriOld.commonTextualReport( filePath );
  test.identical( got, expected );

  test.case = 'two, same';
  var filePath = [ '/wprocedure#0.3.19', '/wprocedure#0.3.19' ];
  var expected = '( /wprocedure#0.3.19 + [ . , . ] )';
  var got = _.uriOld.commonTextualReport( filePath );
  test.identical( got, expected );

  test.case = 'two, same protocol and path, diffent hash';
  var filePath = [ '/wprocedure#0.3.19', '/wprocedure#0.3.18' ];
  var expected = '( / + [ wprocedure#0.3.19 , wprocedure#0.3.18 ] )';
  var got = _.uriOld.commonTextualReport( filePath );
  test.identical( got, expected );

  test.case = 'two, different';
  var filePath = [ '/wprocedure#0.3.19', '/wfiles#0.3.19' ];
  var expected = '( / + [ wprocedure#0.3.19 , wfiles#0.3.19 ] )';
  var got = _.uriOld.commonTextualReport( filePath );
  test.identical( got, expected );

  test.case = 'two, different';
  var filePath = [ '/wprocedure#0.3.19', '/wfiles#0.3.18' ];
  var expected = '( / + [ wprocedure#0.3.19 , wfiles#0.3.18 ] )';
  var got = _.uriOld.commonTextualReport( filePath );
  test.identical( got, expected );

  test.case = 'two, different';
  var filePath = [ '/wprocedure', '/wfiles#0.3.18' ];
  var expected = '( / + [ wprocedure , wfiles#0.3.18 ] )';
  var got = _.uriOld.commonTextualReport( filePath );
  test.identical( got, expected );

  test.case = 'two, different';
  var filePath = [ '/wprocedure', '/a/b/c' ];
  var expected = '( / + [ wprocedure , a/b/c ] )';
  var got = _.uriOld.commonTextualReport( filePath );
  test.identical( got, expected );

  test.case = 'three, commot part of path';
  var filePath = [ '/wprocedure', '/a/b/c', '/wfiles' ];
  var expected = '( / + [ wprocedure , a/b/c , wfiles ] )'
  var got = _.uriOld.commonTextualReport( filePath );
  test.identical( got, expected );

  test.case = 'two, part of path is diffent';
  var filePath = [ '/a/b/c', '/a/x/c' ];
  var expected = '( /a/ + [ ./b/c , ./x/c ] )';
  var got = _.uriOld.commonTextualReport( filePath );
  test.identical( got, expected );

  test.case = 'two relatives, common part of path';
  var filePath = [ 'a/b/c', 'a/x/c' ];
  var expected = '( a/ + [ ./b/c , ./x/c ] )';
  var got = _.uriOld.commonTextualReport( filePath );
  test.identical( got, expected );

  test.case = 'two different relatives';
  var filePath = [ 'a/b', 'c/d' ];
  var expected = '[ a/b , c/d ]';
  var got = _.uriOld.commonTextualReport( filePath );
  test.identical( got, expected );

  test.close( 'locals' );

  /*  */

  test.open( 'map' );

  test.case = 'single key';
  var filePath = { 'npm:///wprocedure#0.3.19' : 1 };
  var got = _.uriOld.commonTextualReport( filePath );
  test.identical( got, 'npm:///wprocedure#0.3.19' );

  test.case = 'empty map';
  var filePath = {};
  var expected = '()';
  var got = _.uriOld.commonTextualReport( filePath );
  test.identical( got, expected );


  test.case = 'two, same protocol and path, diffent hash';
  var filePath = { 'npm:///wprocedure#0.3.19' : 1, 'npm:///wprocedure#0.3.18' : 1 };
  var expected = '( npm:///wprocedure + [ .#0.3.19 , .#0.3.18 ] )';
  var got = _.uriOld.commonTextualReport( filePath );
  test.identical( got, expected );

  test.case = 'two, different, common protocol and hash';
  var filePath = { 'npm:///wprocedure#0.3.19' : 1, 'npm:///wfiles#0.3.19' : 1 };
  var expected = '( npm:///#0.3.19 + [ wprocedure , wfiles ] )';
  var got = _.uriOld.commonTextualReport( filePath );
  test.identical( got, expected );

  test.case = 'two, different, common protocol';
  var filePath = { 'npm:///wprocedure#0.3.19' : 1, 'npm:///wfiles#0.3.18' : 1 };
  var expected = '( npm:/// + [ wprocedure#0.3.19 , wfiles#0.3.18 ] )';
  var got = _.uriOld.commonTextualReport( filePath );
  test.identical( got, expected );

  test.case = 'two, different, common protocol';
  var filePath = { 'npm:///wprocedure' : 1, 'npm:///wfiles#0.3.18' : 1 };
  var expected = '( npm:/// + [ wprocedure , wfiles#0.3.18 ] )';
  var got = _.uriOld.commonTextualReport( filePath );
  test.identical( got, expected );

  test.case = 'two, different';
  var filePath = { 'npm:///wprocedure' : 1, 'file:///a/b/c' : 1 };
  var expected = '[ npm:///wprocedure , file:///a/b/c ]';
  var got = _.uriOld.commonTextualReport( filePath );
  test.identical( got, expected );

  test.case = 'three, two have common protocol';
  var filePath = { 'npm:///wprocedure' : 1, 'file:///a/b/c' : 1, 'npm:///wfiles' : 1 };
  var expected = '[ npm:///wprocedure , file:///a/b/c , npm:///wfiles ]';
  var got = _.uriOld.commonTextualReport( filePath );
  test.identical( got, expected );

  test.case = 'two, part of path is diffent, common protocol';
  var filePath = { 'file:///a/b/c' : 1, 'file:///a/x/c' : 1 };
  var expected = '( file:///a/ + [ ./b/c , ./x/c ] )';
  var got = _.uriOld.commonTextualReport( filePath );
  test.identical( got, expected );

  test.case = 'two relatives, common protocol and part of path';
  var filePath = { 'file://a/b/c' : 1, 'file://a/x/c' : 1 };
  var expected = '( file://a/ + [ ./b/c , ./x/c ] )';
  var got = _.uriOld.commonTextualReport( filePath );
  test.identical( got, expected );

  test.case = 'two different relatives, common protocol';
  var filePath = { 'file://a/b' : 1, 'file://c/d' : 1 };
  var expected = '( file://. + [ a/b , c/d ] )';
  var got = _.uriOld.commonTextualReport( filePath );
  test.identical( got, expected );

  test.close( 'map' );

  /*  */

  test.case = 'with hash and query';
  var filePath = [ 'npm:///wprocedure?query=1#0.3.19', 'npm:///wprocedure?query=1#0.3.18' ];
  var expected = '( npm:///wprocedure?query=1 + [ .#0.3.19 , .#0.3.18 ] )';
  var got = _.uriOld.commonTextualReport( filePath );
  test.identical( got, expected );

  test.case = 'with hash and query';
  var filePath = [ 'npm:///wprocedure?query=2#0.3.19', 'npm:///wprocedure?query=1#0.3.19' ];
  var expected = '( npm:///wprocedure#0.3.19 + [ .?query=2 , .?query=1 ] )';
  var got = _.uriOld.commonTextualReport( filePath );
  test.identical( got, expected );

  test.case = 'with hash and query';
  var filePath = [ 'npm:///wprocedure?query=2#0.3.19', 'npm:///wprocedure?query=1#0.3.18' ];
  var expected = '( npm:///wprocedure + [ .?query=2#0.3.19 , .?query=1#0.3.18 ] )';
  var got = _.uriOld.commonTextualReport( filePath );
  test.identical( got, expected );

  test.case = 'with hash and query';
  var filePath = [ 'npm:///wprocedure?query=2#0.3.19', 'npm:///wfiles?query=1#0.3.18' ];
  var expected = '( npm:/// + [ wprocedure?query=2#0.3.19 , wfiles?query=1#0.3.18 ] )';
  var got = _.uriOld.commonTextualReport( filePath );
  test.identical( got, expected );

  test.case = 'with hash and query';
  var filePath = [ 'npm:///wprocedure?query=1#0.3.19', 'npm:///wfiles?query=1#0.3.19' ];
  var expected = '( npm:///?query=1#0.3.19 + [ wprocedure , wfiles ] )';
  var got = _.uriOld.commonTextualReport( filePath );
  test.identical( got, expected );

  test.case = 'with hash and query';
  var filePath = [ 'npm:///wprocedure?query=1#0.3.18', 'npm:///wfiles?query=1#0.3.19' ];
  var expected = '( npm:///?query=1 + [ wprocedure#0.3.18 , wfiles#0.3.19 ] )';
  var got = _.uriOld.commonTextualReport( filePath );
  test.identical( got, expected );

  if( !Config.debug )
  return

  test.shouldThrowErrorSync( () => _.uriOld.commonTextualReport( null ) )
  test.shouldThrowErrorSync( () => _.uriOld.commonTextualReport([ 'npm:///wprocedure#0.3.19', null ]) )
  test.shouldThrowErrorSync( () => _.uriOld.commonTextualReport([ 'file:///a/b', 'file://c/d' ]) )
}

//

function moveTextualReport( test )
{
  test.open( 'globals' );

  test.case = 'same';
  var expected = 'npm:///wprocedure#0.3.19 : . <- .';
  var dst = 'npm:///wprocedure#0.3.19';
  var src = 'npm:///wprocedure#0.3.19';
  var got = _.uriOld.moveTextualReport( dst, src );
  test.identical( _.ct.strip( got ), expected );

  test.case = 'dst with hash, src without hash';
  var expected = 'npm:///wprocedure : .#0.3.19 <- .';
  var dst = 'npm:///wprocedure#0.3.19';
  var src = 'npm:///wprocedure';
  var got = _.uriOld.moveTextualReport( dst, src );
  test.identical( _.ct.strip( got ), expected );

  test.case = 'dst without hash, src with hash';
  var expected = 'npm:///wprocedure : . <- .#0.3.19';
  var dst = 'npm:///wprocedure';
  var src = 'npm:///wprocedure#0.3.19';
  var got = _.uriOld.moveTextualReport( dst, src );
  test.identical( _.ct.strip( got ), expected );

  test.case = 'dst with hash, src with hash';
  var expected = 'npm:///wprocedure : .#0.3.20 <- .#0.3.19';
  var dst = 'npm:///wprocedure#0.3.20';
  var src = 'npm:///wprocedure#0.3.19';
  var got = _.uriOld.moveTextualReport( dst, src );
  test.identical( _.ct.strip( got ), expected );

  test.case = 'dst without hash, src without hash';
  var expected = 'npm:///wprocedure : . <- .';
  var dst = 'npm:///wprocedure';
  var src = 'npm:///wprocedure';
  var got = _.uriOld.moveTextualReport( dst, src );
  test.identical( _.ct.strip( got ), expected );

  test.case = 'common protocol, different paths';
  var expected = 'npm:/// : wprocedure <- wfiles';
  var dst = 'npm:///wprocedure';
  var src = 'npm:///wfiles';
  var got = _.uriOld.moveTextualReport( dst, src );
  test.identical( _.ct.strip( got ), expected );

  test.case = 'different paths';
  var expected = 'npm1:///wprocedure <- npm2:///wfiles';
  var dst = 'npm1:///wprocedure';
  var src = 'npm2:///wfiles';
  var got = _.uriOld.moveTextualReport( dst, src );
  test.identical( _.ct.strip( got ), expected );

  test.case = 'dst relative, src relative, with common';
  var expected = 'npm://. : wprocedure <- wfiles';
  var dst = 'npm://wprocedure';
  var src = 'npm://wfiles';
  var got = _.uriOld.moveTextualReport( dst, src );
  test.identical( _.ct.strip( got ), expected );

  test.case = 'dst relative, src relative, same';
  var expected = 'npm://wfiles : . <- .';
  var dst = 'npm://wfiles';
  var src = 'npm://wfiles';
  var got = _.uriOld.moveTextualReport( dst, src );
  test.identical( _.ct.strip( got ), expected );

  test.case = 'dst relative with hash, src relative with hash, same';
  var expected = 'npm://wprocedure#0.3.20 : . <- .';
  var dst = 'npm://wprocedure#0.3.20';
  var src = 'npm://wprocedure#0.3.20';
  var got = _.uriOld.moveTextualReport( dst, src );
  test.identical( _.ct.strip( got ), expected );

  test.case = 'dst relative with hash, src relative with hash, with common';
  var expected = 'npm://wprocedure : .#0.3.20 <- .#0.3.19';
  var dst = 'npm://wprocedure#0.3.20';
  var src = 'npm://wprocedure#0.3.19';
  var got = _.uriOld.moveTextualReport( dst, src );
  test.identical( _.ct.strip( got ), expected );

  test.case = 'dst relative, src relative, with common';
  var expected = 'npm://. : b/dst <- a/src';
  var dst = 'npm://b/dst';
  var src = 'npm://a/src';
  var got = _.uriOld.moveTextualReport( dst, src );
  test.identical( _.ct.strip( got ), expected );

  test.case = 'dst relative, src relative, with common';
  var expected = 'npm://a/ : ./dst <- ./src';
  var dst = 'npm://a/dst';
  var src = 'npm://a/src';
  var got = _.uriOld.moveTextualReport( dst, src );
  test.identical( _.ct.strip( got ), expected );

  test.close( 'globals' );

  /*  */

  test.open( 'locals' );

  test.case = 'same, absolute';
  var expected = '/a : . <- .';
  var dst = '/a';
  var src = '/a';
  var got = _.uriOld.moveTextualReport( dst, src );
  test.identical( _.ct.strip( got ), expected );

  test.case = 'different, absolute, with common';
  var expected = '/a/ : ./dst <- ./src';
  var dst = '/a/dst';
  var src = '/a/src';
  var got = _.uriOld.moveTextualReport( dst, src );
  test.identical( _.ct.strip( got ), expected );

  test.case = 'different, absolute, without common';
  var expected = '/b/dst <- /a/src';
  var dst = '/b/dst';
  var src = '/a/src';
  var got = _.uriOld.moveTextualReport( dst, src );
  test.identical( _.ct.strip( got ), expected );

  test.case = 'same, relative';
  var expected = 'a/src : . <- .';
  var dst = 'a/src';
  var src = 'a/src';
  var got = _.uriOld.moveTextualReport( dst, src );
  test.identical( _.ct.strip( got ), expected );

  test.case = 'different, relative, with common';
  var expected = 'a/ : ./dst <- ./src';
  var dst = 'a/dst';
  var src = 'a/src';
  var got = _.uriOld.moveTextualReport( dst, src );
  test.identical( _.ct.strip( got ), expected );

  test.case = 'different, relative, without common';
  var expected = 'b/dst <- a/src';
  var dst = 'b/dst';
  var src = 'a/src';
  var got = _.uriOld.moveTextualReport( dst, src );
  test.identical( _.ct.strip( got ), expected );

  test.case = 'same, relative dotted';
  var expected = 'a/src : . <- .';
  var dst = './a/src';
  var src = './a/src';
  var got = _.uriOld.moveTextualReport( dst, src );
  test.identical( _.ct.strip( got ), expected );

  test.case = 'different, relative dotted, with common';
  var expected = 'a/ : ./dst <- ./src';
  var dst = './a/dst';
  var src = './a/src';
  var got = _.uriOld.moveTextualReport( dst, src );
  test.identical( _.ct.strip( got ), expected );

  test.case = 'different, relative dotted, without common';
  var expected = './b/dst <- ./a/src';
  var dst = './b/dst';
  var src = './a/src';
  var got = _.uriOld.moveTextualReport( dst, src );
  test.identical( _.ct.strip( got ), expected );

  test.close( 'locals' );

  test.open( 'null' );

  test.case = 'both null';
  var expected = '{null} : . <- .';
  var dst = null;
  var src = null;
  var got = _.uriOld.moveTextualReport( dst, src );
  test.identical( _.ct.strip( got ), expected );

  test.case = 'dst global, src null';
  var expected = ':/// : npm://wprocedure#0.3.19 <- {null}';
  var dst = 'npm:///wprocedure#0.3.19';
  var src = null;
  var got = _.uriOld.moveTextualReport( dst, src );
  test.identical( _.ct.strip( got ), expected );

  test.case = 'dst null, src global';
  var expected = ':/// : {null} <- npm://wprocedure#0.3.19';
  var src = 'npm:///wprocedure#0.3.19';
  var dst = null;
  var got = _.uriOld.moveTextualReport( dst, src );
  test.identical( _.ct.strip( got ), expected );

  test.case = 'dst relative, src null';
  var expected = './a/dst <- {null}';
  var dst = './a/dst';
  var src = null;
  var got = _.uriOld.moveTextualReport( dst, src );
  test.identical( _.ct.strip( got ), expected );

  test.case = 'src relative, dst null';
  var expected = '{null} <- ./a/src';
  var src = './a/src';
  var dst = null;
  var got = _.uriOld.moveTextualReport( dst, src );
  test.identical( _.ct.strip( got ), expected );

  test.case = 'src absolute, dst null';
  var expected = '/{null} <- /a/src';
  var src = '/a/src';
  var dst = null;
  var got = _.uriOld.moveTextualReport( dst, src );
  test.identical( _.ct.strip( got ), expected );

  test.case = 'dst absolute, src null';
  var expected = '/a/dst <- /{null}';
  var dst = '/a/dst';
  var src = null;
  var got = _.uriOld.moveTextualReport( dst, src );
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
    current = _.strPrependOnce( _.uriOld.current(), '/' );
  }

  try
  {

    test.open( 'with protocol' );

    var got = _.uriOld.resolve( 'http://www.site.com:13', 'a' );
    test.identical( got, _.uriOld.join( current, 'http://www.site.com:13/a' ) );

    var got = _.uriOld.resolve( 'http://www.site.com:13/', 'a' );
    test.identical( got, _.uriOld.join( current, 'http://www.site.com:13/a' ) );

    var got = _.uriOld.resolve( 'http://www.site.com:13/', 'a', 'b' );
    test.identical( got, _.uriOld.join( current, 'http://www.site.com:13/a/b' ) );

    var got = _.uriOld.resolve( 'http://www.site.com:13', 'a', '/b' );
    test.identical( got, _.uriOld.join( current, 'http:///b' ) );

    var got = _.uriOld.resolve( 'http://www.site.com:13/', 'a', 'b', '.' );
    test.identical( got, _.uriOld.join( current, 'http://www.site.com:13/a/b' ) );

    var got = _.uriOld.resolve( 'http://www.site.com:13', 'a', '/b', 'c' );
    test.identical( got, _.uriOld.join( current, 'http:///b/c' ) );

    var got = _.uriOld.resolve( 'http://www.site.com:13', '/a/', '/b/', 'c/', '.' );
    test.identical( got, _.uriOld.join( current, 'http:///b/c' ) );

    var got = _.uriOld.resolve( 'http://www.site.com:13', 'a', '.', 'b' );
    test.identical( got, _.uriOld.join( current, 'http://www.site.com:13/a/b' ) );

    var got = _.uriOld.resolve( 'http://www.site.com:13/', 'a', '.', 'b' );
    test.identical( got, _.uriOld.join( current, 'http://www.site.com:13/a/b' ) );

    var got = _.uriOld.resolve( 'http://www.site.com:13', 'a', '..', 'b' );
    test.identical( got, _.uriOld.join( current, 'http://www.site.com:13/b' ) );

    var got = _.uriOld.resolve( 'http://www.site.com:13', 'a', '..', '..', 'b' );
    test.identical( got, _.uriOld.join( current, 'http://b' ) );

    var got = _.uriOld.resolve( 'http://www.site.com:13', '.a.', 'b', '.c.' );
    test.identical( got, _.uriOld.join( current, 'http://www.site.com:13/.a./b/.c.' ) );

    var got = _.uriOld.resolve( 'http://www.site.com:13', 'a/../' );
    test.identical( got, _.uriOld.join( current, 'http://www.site.com:13/' ) );

    test.close( 'with protocol' );

    /* - */

    test.open( 'with null protocol' );

    var got = _.uriOld.resolve( '://www.site.com:13', 'a' );
    test.identical( got, _.uriOld.join( current, '://www.site.com:13/a' ) );

    var got = _.uriOld.resolve( '://www.site.com:13', 'a', '/b' );
    test.identical( got, _.uriOld.join( current, ':///b' ) );

    var got = _.uriOld.resolve( '://www.site.com:13', 'a', '/b', 'c' );
    test.identical( got, _.uriOld.join( current, ':///b/c' ) );

    var got = _.uriOld.resolve( '://www.site.com:13', '/a/', '/b/', 'c/', '.' );
    test.identical( got, _.uriOld.join( current, ':///b/c' ) );

    var got = _.uriOld.resolve( '://www.site.com:13', 'a', '.', 'b' );
    test.identical( got, _.uriOld.join( current, '://www.site.com:13/a/b' ) );

    var got = _.uriOld.resolve( '://www.site.com:13', 'a', '..', 'b' );
    test.identical( got, _.uriOld.join( current, '://www.site.com:13/b' ) );

    var got = _.uriOld.resolve( '://www.site.com:13', 'a', '..', '..', 'b' );
    test.identical( got, _.uriOld.join( current, '://b' ) );

    var got = _.uriOld.resolve( '://www.site.com:13', '.a.', 'b', '.c.' );
    test.identical( got, _.uriOld.join( current, '://www.site.com:13/.a./b/.c.' ) );

    var got = _.uriOld.resolve( '://www.site.com:13', 'a/../' );
    test.identical( got, _.uriOld.join( current, '://www.site.com:13/' ) );

    test.close( 'with null protocol' );

    /* */

    var got = _.uriOld.resolve( ':///www.site.com:13', 'a' );
    test.identical( got, ':///www.site.com:13/a' );

    var got = _.uriOld.resolve( ':///www.site.com:13/', 'a' );
    test.identical( got, ':///www.site.com:13/a' );

    var got = _.uriOld.resolve( ':///www.site.com:13', 'a', '/b' );
    test.identical( got, ':///b' );

    var got = _.uriOld.resolve( ':///www.site.com:13', 'a', '/b', 'c' );
    test.identical( got, ':///b/c' );

    var got = _.uriOld.resolve( ':///www.site.com:13', '/a/', '/b/', 'c/', '.' );
    test.identical( got, ':///b/c' );

    var got = _.uriOld.resolve( ':///www.site.com:13', 'a', '.', 'b' );
    test.identical( got, ':///www.site.com:13/a/b' );

    var got = _.uriOld.resolve( ':///www.site.com:13/', 'a', '.', 'b' );
    test.identical( got, ':///www.site.com:13/a/b' );

    var got = _.uriOld.resolve( ':///www.site.com:13', 'a', '..', 'b' );
    test.identical( got, ':///www.site.com:13/b' );

    var got = _.uriOld.resolve( ':///www.site.com:13', 'a', '..', '..', 'b' );
    test.identical( got, ':///b' );

    var got = _.uriOld.resolve( ':///www.site.com:13', '.a.', 'b', '.c.' );
    test.identical( got, ':///www.site.com:13/.a./b/.c.' );

    var got = _.uriOld.resolve( ':///www.site.com:13/', '.a.', 'b', '.c.' );
    test.identical( got, ':///www.site.com:13/.a./b/.c.' );

    var got = _.uriOld.resolve( ':///www.site.com:13', 'a/../' );
    test.identical( got, ':///www.site.com:13/' );

    var got = _.uriOld.resolve( ':///www.site.com:13/', 'a/../' );
    test.identical( got, ':///www.site.com:13/' );

    /* */

    var got = _.uriOld.resolve( '/some/staging/index.html', 'a' );
    test.identical( got, '/some/staging/index.html/a' );

    var got = _.uriOld.resolve( '/some/staging/index.html', '.' );
    test.identical( got, '/some/staging/index.html' );

    var got = _.uriOld.resolve( '/some/staging/index.html/', 'a' );
    test.identical( got, '/some/staging/index.html/a' );

    var got = _.uriOld.resolve( '/some/staging/index.html', 'a', '/b' );
    test.identical( got, '/b' );

    var got = _.uriOld.resolve( '/some/staging/index.html', 'a', '/b', 'c' );
    test.identical( got, '/b/c' );

    var got = _.uriOld.resolve( '/some/staging/index.html', '/a/', '/b/', 'c/', '.' );
    test.identical( got, '/b/c' );

    var got = _.uriOld.resolve( '/some/staging/index.html', 'a', '.', 'b' );
    test.identical( got, '/some/staging/index.html/a/b' );

    var got = _.uriOld.resolve( '/some/staging/index.html/', 'a', '.', 'b' );
    test.identical( got, '/some/staging/index.html/a/b' );

    var got = _.uriOld.resolve( '/some/staging/index.html', 'a', '..', 'b' );
    test.identical( got, '/some/staging/index.html/b' );

    var got = _.uriOld.resolve( '/some/staging/index.html', 'a', '..', '..', 'b' );
    test.identical( got, '/some/staging/b' );

    var got = _.uriOld.resolve( '/some/staging/index.html', '.a.', 'b', '.c.' );
    test.identical( got, '/some/staging/index.html/.a./b/.c.' );

    var got = _.uriOld.resolve( '/some/staging/index.html/', '.a.', 'b', '.c.' );
    test.identical( got, '/some/staging/index.html/.a./b/.c.' );

    var got = _.uriOld.resolve( '/some/staging/index.html', 'a/../' );
    test.identical( got, '/some/staging/index.html/' );

    var got = _.uriOld.resolve( '/some/staging/index.html/', 'a/../' );
    test.identical( got, '/some/staging/index.html/' );

    var got = _.uriOld.resolve( '//some/staging/index.html', '.', 'a' );
    test.identical( got, '//some/staging/index.html/a' )

    var got = _.uriOld.resolve( '///some/staging/index.html', 'a', '.', 'b', '..' );
    test.identical( got, '///some/staging/index.html/a' )

    var got = _.uriOld.resolve( 'file:///some/staging/index.html', '../..' );
    test.identical( got, 'file:///some' )

    var got = _.uriOld.resolve( 'svn+https://user@subversion.com/svn/trunk', '../a', 'b', '../c' );
    test.identical( got, _.uriOld.join( current, 'svn+https://user@subversion.com/svn/a/c' ) );

    var got = _.uriOld.resolve( 'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor', '../../path/name' );
    test.identical( got, _.uriOld.join( current, 'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor' ) );

    var got = _.uriOld.resolve( 'https://web.archive.org/web/*\/http://www.heritage.org/index/ranking', '../../../a.com' );
    test.identical( got, _.uriOld.join( current, 'https://web.archive.org/web/*\/http://a.com' ) );

    var got = _.uriOld.resolve( '127.0.0.1:61726', '../path' );
    test.identical( got, _.uriOld.join( _.uriOld.current(), 'path' ) )

    var got = _.uriOld.resolve( 'http://127.0.0.1:61726', '../path' );
    test.identical( got, _.uriOld.join( current, 'http://path' ) );

    /* */

    test.case = 'works like resolve';

    var paths = [ 'c:\\', 'foo\\', 'bar\\' ];
    var expected = '/c/foo/bar/';
    var got = _.uriOld.resolve.apply( _.uriOld, paths );
    test.identical( got, expected );

    var paths = [ '/bar/', '/baz', 'foo/', '.' ];
    var expected = '/baz/foo';
    var got = _.uriOld.resolve.apply( _.uriOld, paths );
    test.identical( got, expected );

    var paths = [ 'aa', '.', 'cc' ];
    var expected = _.uriOld.join( _.uriOld.current(), 'aa/cc' );
    var got = _.uriOld.resolve.apply( _.uriOld, paths );
    test.identical( got, expected );

    var paths = [ 'aa', 'cc', '.' ];
    var expected = _.uriOld.join( _.uriOld.current(), 'aa/cc' )
    var got = _.uriOld.resolve.apply( _.uriOld, paths );
    test.identical( got, expected );

    var paths = [ '.', 'aa', 'cc' ];
    var expected = _.uriOld.join( _.uriOld.current(), 'aa/cc' )
    var got = _.uriOld.resolve.apply( _.uriOld, paths );
    test.identical( got, expected );

    var paths = [ '.', 'aa', 'cc', '..' ];
    var expected = _.uriOld.join( _.uriOld.current(), 'aa' )
    var got = _.uriOld.resolve.apply( _.uriOld, paths );
    test.identical( got, expected );

    var paths = [ '.', 'aa', 'cc', '..', '..' ];
    var expected = _.uriOld.current();
    var got = _.uriOld.resolve.apply( _.uriOld, paths );
    test.identical( got, expected );

    var paths = [ 'aa', 'cc', '..', '..', '..' ];
    var expected = _.uriOld.resolve( _.uriOld.current(), '..' );
    var got = _.uriOld.resolve.apply( _.uriOld, paths );
    test.identical( got, expected );

    var paths = [ '.x.', 'aa', 'bb', '.x.' ];
    var expected = _.uriOld.join( _.uriOld.current(), '.x./aa/bb/.x.' );
    var got = _.uriOld.resolve.apply( _.uriOld, paths );
    test.identical( got, expected );

    var paths = [ '..x..', 'aa', 'bb', '..x..' ];
    var expected = _.uriOld.join( _.uriOld.current(), '..x../aa/bb/..x..' );
    var got = _.uriOld.resolve.apply( _.uriOld, paths );
    test.identical( got, expected );

    var paths = [ '/abc', './../a/b' ];
    var expected = '/a/b';
    var got = _.uriOld.resolve.apply( _.uriOld, paths );
    test.identical( got, expected );

    var paths = [ '/abc', 'a/.././a/b' ];
    var expected = '/abc/a/b';
    var got = _.uriOld.resolve.apply( _.uriOld, paths );
    test.identical( got, expected );

    var paths = [ '/abc', '.././a/b' ];
    var expected = '/a/b';
    var got = _.uriOld.resolve.apply( _.uriOld, paths );
    test.identical( got, expected );

    var paths = [ '/abc', './.././a/b' ];
    var expected = '/a/b';
    var got = _.uriOld.resolve.apply( _.uriOld, paths );
    test.identical( got, expected );

    var paths = [ '/abc', './../.' ];
    var expected = '/';
    var got = _.uriOld.resolve.apply( _.uriOld, paths );
    test.identical( got, expected );

    var paths = [ '/abc', './../../.' ];
    var expected = '/..';
    var got = _.uriOld.resolve.apply( _.uriOld, paths );
    test.identical( got, expected );

    var paths = [ '/abc', './../.' ];
    var expected = '/';
    var got = _.uriOld.resolve.apply( _.uriOld, paths );
    test.identical( got, expected );

    var paths = [ null ];
    // var expected = _.uriOld.current();
    var expected = null;
    var got = _.uriOld.resolve.apply( _.uriOld, paths );
    test.identical( got, expected );

    /* - */

    if( _.fileProvider )
    _.uriOld.current( originalPath );

  }
  catch( err )
  {

    if( _.fileProvider )
    _.uriOld.current( originalPath );
    throw err;
  }

}

//

function rebase( test )
{

  test.case = 'replacing by empty protocol';

  var expected = ':///some2/file'; /* not src:///some2/file */
  var got = _.uriOld.rebase( 'src:///some/file', '/some', ':///some2' );
  test.identical( got, expected );

  test.case = 'removing protocol';

  var expected = '/some2/file';
  var got = _.uriOld.rebase( 'src:///some/file', 'src:///some', '/some2' );
  test.identical( got, expected );

  var expected = '/some2/file';
  var got = _.uriOld.rebase( 'src:///some/file', 'dst:///some', '/some2' );
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
  var got = _.uriOld.name( src );
  var exp = '';
  test.identical( got, exp );

  test.case = 'empty path, with ext';
  var src = '';
  var got = _.uriOld.name( { path : src, full : 1 } );
  var exp = '';
  test.identical( got, exp );

  /* */

  test.case = 'filename, without ext';
  var src = 'some.txt';
  var got = _.uriOld.name( src );
  var exp = 'some';
  test.identical( got, exp );

  test.case = 'filename, with ext';
  var src = 'some.txt';
  var got = _.uriOld.name( { path : src, full : 1 } );
  var exp = 'some.txt';
  test.identical( got, exp );

  /* */

  test.case = 'absolute path to file, without ext';
  var src = '/foo/bar/baz.asdf';
  var got = _.uriOld.name( src );
  var exp = 'baz';
  test.identical( got, exp );

  test.case = 'absolute path to file, with ext';
  var src = '/foo/bar/baz.asdf';
  var got = _.uriOld.name( { path : src, full : 1 } );
  var exp = 'baz.asdf';
  test.identical( got, exp );

  /* */

  test.case = 'absolute path to hidden file, without ext';
  var src = '/foo/bar/.baz';
  var got = _.uriOld.name( src );
  var exp = '';
  test.identical( got, exp );

  test.case = 'absolute path to hidden file, with ext';
  var src = '/foo/bar/.baz';
  var got = _.uriOld.name( { path : src, full : 1 } );
  var exp = '.baz';
  test.identical( got, exp );

  /* */

  test.case = 'absolute path to file with complex extention, without ext';
  var src = '/foo.coffee.md';
  var got = _.uriOld.name( src );
  var exp = 'foo.coffee';
  test.identical( got, exp );

  test.case = 'absolute path to file with complex extention, with ext';
  var src = '/foo.coffee.md';
  var got = _.uriOld.name( { path : src, full : 1 } );
  var exp = 'foo.coffee.md';
  test.identical( got, exp );

  /* */

  test.case = 'absolute path to file without extention, without ext';
  var src = '/foo/bar/baz';
  var got = _.uriOld.name( src );
  var exp = 'baz';
  test.identical( got, exp );

  test.case = 'absolute path to file without extention, with ext';
  var src = '/foo/bar/baz';
  var got = _.uriOld.name( { path : src, full : 1 } );
  var exp = 'baz';
  test.identical( got, exp );

  /* */

  test.case = 'absolute path to file, one slash, without ext';
  var src = '/some/staging/index.html';
  var got = _.uriOld.name( src );
  var exp = 'index';
  test.identical( got, exp );

  test.case = 'absolute path to file, one slash, with ext';
  var src = '/some/staging/index.html';
  var got = _.uriOld.name( { path : src, full : 1 } );
  var exp = 'index.html';
  test.identical( got, exp );

  /* */

  test.case = 'absolute path to file, two slashes, without ext';
  var src = '//some/staging/index.html';
  var got = _.uriOld.name( src );
  var exp = 'index';
  test.identical( got, exp );

  test.case = 'absolute path to file, two slashes, with ext';
  var src = '//some/staging/index.html';
  var got = _.uriOld.name( { path : src, full : 1 } );
  var exp = 'index.html';
  test.identical( got, exp );

  /* */

  test.case = 'absolute path to file, three slashes, without ext';
  var src = '///some/staging/index.html';
  var got = _.uriOld.name( src );
  var exp = 'index';
  test.identical( got, exp );

  test.case = 'absolute path to file, three slashes, with ext';
  var src = '///some/staging/index.html';
  var got = _.uriOld.name( { path : src, full : 1 } );
  var exp = 'index.html';
  test.identical( got, exp );

  /* */

  test.case = 'hard drive path to file, without ext';
  var src = 'file:///some/staging/index.html';
  var got = _.uriOld.name( src );
  var exp = 'index';
  test.identical( got, exp );

  test.case = 'hard drive path to file, with ext';
  var src = 'file:///some/staging/index.html';
  var got = _.uriOld.name( { path : src, full : 1 } );
  var exp = 'index.html';
  test.identical( got, exp );

  /* */

  test.case = 'http path to file, without ext';
  var src = 'http://some.come/staging/index.html';
  var got = _.uriOld.name( src );
  var exp = 'index';
  test.identical( got, exp );

  test.case = 'http path to file, with ext';
  var src = 'http://some.come/staging/index.html';
  var got = _.uriOld.name( { path : src, full : 1 } );
  var exp = 'index.html';
  test.identical( got, exp );

  /* */

  test.case = 'svn+https path to file, without ext';
  var src = 'svn+https://user@subversion.com/svn/trunk/index.html';
  var got = _.uriOld.name( src );
  var exp = 'index';
  test.identical( got, exp );

  test.case = 'svn+https path to file, with ext';
  var src = 'svn+https://user@subversion.com/svn/trunk/index.html';
  var got = _.uriOld.name( { path : src, full : 1 } );
  var exp = 'index.html';
  test.identical( got, exp );

  /* */

  test.case = 'complex+protocol path to file, without ext';
  var src = 'complex+protocol://www.site.com:13/path/name.html?query=here&and=here#anchor';
  var got = _.uriOld.name( src );
  var exp = 'name';
  test.identical( got, exp );

  test.case = 'complex+protocol path to file, with ext';
  var src = 'complex+protocol://www.site.com:13/path/name.html?query=here&and=here#anchor';
  var got = _.uriOld.name( { path : src, full : 1 } );
  var exp = 'name.html';
  test.identical( got, exp );

  /* */

  test.case = 'complex path to file with parameters, without ext';
  var src = '://www.site.com:13/path/name.html?query=here&and=here#anchor';
  var got = _.uriOld.name( src );
  var exp = 'name';
  test.identical( got, exp );

  test.case = 'complex path to file with parameters, with ext';
  var src = '://www.site.com:13/path/name.html?query=here&and=here#anchor';
  var got = _.uriOld.name( { path : src, full : 1 } );
  var exp = 'name.html';
  test.identical( got, exp );

  /* */

  test.case = 'complex path to file with parameters, without ext';
  var src = ':///www.site.com:13/path/name.html?query=here&and=here#anchor';
  var got = _.uriOld.name( src );
  var exp = 'name';
  test.identical( got, exp );

  test.case = 'complex path to file with parameters, with ext';
  var src = ':///www.site.com:13/path/name.html?query=here&and=here#anchor';
  var got = _.uriOld.name( { path : src, full : 1 } );
  var exp = 'name.html';
  test.identical( got, exp );

  /* */

  test.case = 'uri filePath file';
  var src = 'http://www.site.com:13/path/name.txt'
  var got = _.uriOld.name( src );
  var expected = 'name';
  test.identical( got, expected );

  test.case = 'uri with params';
  var src = 'http://www.site.com:13/path/name?query=here&and=here#anchor';
  var got = _.uriOld.name( src );
  var expected = 'name';
  test.identical( got, expected );

  test.case = 'uri without protocol';
  var src = '://www.site.com:13/path/name.js';
  var got = _.uriOld.name( src );
  var expected = 'name';
  test.identical( got, expected );

  /* - */

  if( !Config.debug )
  return;

  test.case = 'passed argument is non string';
  test.shouldThrowErrorSync( () => _.uriOld.name( false ) );
}

//

function ext( test )
{
  test.case = 'empty path';
  var src = '';
  var got = _.uriOld.ext( src );
  var exp = '';
  test.identical( got, exp );

  test.case = 'filename';
  var src = 'some.txt';
  var got = _.uriOld.ext( src );
  var exp = 'txt';
  test.identical( got, exp );

  test.case = 'absolute path to file';
  var src = '/foo/bar/baz.asdf';
  var got = _.uriOld.ext( src );
  var exp = 'asdf';
  test.identical( got, exp );

  test.case = 'absolute path to hidden file';
  var src = '/foo/bar/.baz';
  var got = _.uriOld.ext( src );
  var exp = '';
  test.identical( got, exp );

  test.case = 'absolute path to hidden file';
  var src = '/foo/bar/.baz';
  var got = _.uriOld.ext( src );
  var exp = '';
  test.identical( got, exp );

  test.case = 'absolute path to file with complex extention';
  var src = '/foo.coffee.md';
  var got = _.uriOld.ext( src );
  var exp = 'md';
  test.identical( got, exp );

  test.case = 'absolute path to file without extention';
  var src = '/foo/bar/baz';
  var got = _.uriOld.ext( src );
  var exp = '';
  test.identical( got, exp );

  test.case = 'absolute path to file, one slash';
  var src = '/some/staging/index.html';
  var got = _.uriOld.ext( src );
  var exp = 'html';
  test.identical( got, exp );

  test.case = 'absolute path to file, two slashes';
  var src = '//some/staging/index.html';
  var got = _.uriOld.ext( src );
  var exp = 'html';
  test.identical( got, exp );

  test.case = 'absolute path to file, three slashes';
  var src = '///some/staging/index.html';
  var got = _.uriOld.ext( src );
  var exp = 'html';
  test.identical( got, exp );

  test.case = 'hard drive path to file';
  var src = 'file:///some/staging/index.html';
  var got = _.uriOld.ext( src );
  var exp = 'html';
  test.identical( got, exp );

  test.case = 'http path to file';
  var src = 'http://some.come/staging/index.html';
  var got = _.uriOld.ext( src );
  var exp = 'html';
  test.identical( got, exp );

  test.case = 'svn+https path to file';
  var src = 'svn+https://user@subversion.com/svn/trunk/index.html';
  var got = _.uriOld.ext( src );
  var exp = 'html';
  test.identical( got, exp );

  test.case = 'complex+protocol path to file';
  var src = 'complex+protocol://www.site.com:13/path/name.html?query=here&and=here#anchor';
  var got = _.uriOld.ext( src );
  var exp = 'html';

  test.case = 'complex path to file with parameters';
  var src = '://www.site.com:13/path/name.html?query=here&and=here#anchor';
  var got = _.uriOld.ext( src );
  var exp = 'html';
  test.identical( got, exp );

  test.case = 'complex path to file with parameters';
  var src = ':///www.site.com:13/path/name.html?query=here&and=here#anchor';
  var got = _.uriOld.ext( src );
  var exp = 'html';
  test.identical( got, exp );

  /* */

  test.case = 'uri filePath file';
  var src = 'http://www.site.com:13/path/name.txt'
  var got = _.uriOld.ext( src );
  var expected = 'txt';
  test.identical( got, expected );

  test.case = 'uri with params';
  var src = 'http://www.site.com:13/path/name?query=here&and=here#anchor';
  var got = _.uriOld.ext( src );
  var expected = '';
  test.identical( got, expected );

  test.case = 'uri without protocol';
  var src = '://www.site.com:13/path/name.js';
  var got = _.uriOld.ext( src );
  var expected = 'js';
  test.identical( got, expected );

  /* - */

  if( !Config.debug )
  return;

  test.case = 'passed argument is non string';
  test.shouldThrowErrorSync( () => _.uriOld.ext( false ) );
}

//

function changeExt( test )
{
  test.case = 'filename with extention';
  var src = 'some.txt';
  var got = _.uriOld.changeExt( src, 'abc' );
  var exp = 'some.abc';
  test.identical( got, exp );

  test.case = 'absolute path to file with extention';
  var src = '/foo/bar/baz.asdf';
  var got = _.uriOld.changeExt( src, 'abc' );
  var exp = '/foo/bar/baz.abc';
  test.identical( got, exp );

  test.case = 'absolute path to hidden file';
  var src = '/foo/bar/.baz';
  var got = _.uriOld.changeExt( src, 'abc' );
  var exp = '/foo/bar/.baz.abc';
  test.identical( got, exp );

  test.case = 'absolute path to file with complex extention';
  var src = '/foo.coffee.md';
  var got = _.uriOld.changeExt( src, 'abc' );
  var exp = '/foo.coffee.abc';
  test.identical( got, exp );

  test.case = 'absolute path to file without extention';
  var src = '/foo/bar/baz';
  var got = _.uriOld.changeExt( src, 'abc' );
  var exp = '/foo/bar/baz.abc';
  test.identical( got, exp );

  test.case = 'absolute path to file, begins on one slash';
  var src = '/some/staging/index.html';
  var got = _.uriOld.changeExt( src, 'abc' );
  var exp = '/some/staging/index.abc';
  test.identical( got, exp );

  test.case = 'absolute path to file, begins on two slashes';
  var src = '//some/staging/index.html';
  var got = _.uriOld.changeExt( src, 'abc' );
  var exp = '//some/staging/index.abc';
  test.identical( got, exp );

  test.case = 'absolute path to file, begins on three slashes';
  var src = '///some/staging/index.html';
  var got = _.uriOld.changeExt( src, 'abc' );
  var exp = '///some/staging/index.abc';
  test.identical( got, exp );

  test.case = 'hard drive path to file';
  var src = 'file:///some/staging/index.html';
  var got = _.uriOld.changeExt( src, 'abc' );
  var exp = 'file:///some/staging/index.abc';
  test.identical( got, exp );

  test.case = 'http path to file';
  var src = 'http://some.come/staging/index.html';
  var got = _.uriOld.changeExt( src, 'abc' );
  var exp = 'http://some.come/staging/index.abc';
  test.identical( got, exp );

  test.case = 'svn+https path to file';
  var src = 'svn+https://user@subversion.com/svn/trunk/index.html';
  var got = _.uriOld.changeExt( src, 'abc' );
  var exp = 'svn+https://user@subversion.com/svn/trunk/index.abc';
  test.identical( got, exp );

  test.case = 'complex+protocol path to file';
  var src = 'complex+protocol://www.site.com:13/path/name.html?query=here&and=here#anchor';
  var got = _.uriOld.changeExt( src, 'abc' );
  var exp = 'complex+protocol://www.site.com:13/path/name.abc?query=here&and=here#anchor';
  test.identical( got, exp );

  test.case = 'path to file with options';
  var src = '://www.site.com:13/path/name.html?query=here&and=here#anchor';
  var got = _.uriOld.changeExt( src, 'abc' );
  var exp = '://www.site.com:13/path/name.abc?query=here&and=here#anchor';
  test.identical( got, exp );

  test.case = 'path to file with options';
  var src = ':///www.site.com:13/path/name.html?query=here&and=here#anchor';
  var got = _.uriOld.changeExt( src, 'abc' );
  var exp = ':///www.site.com:13/path/name.abc?query=here&and=here#anchor';
  test.identical( got, exp );

  /* - */

  if( !Config.debug )
  return;

  test.case = 'passed argument is non string';
  test.shouldThrowErrorSync( () => _.uriOld.changeExt( false ) );
}

//

/*
qqq : improve style, remove array of expected values and array of inputs | Dmytro : improved
 */

function dir( test )
{
  test.case = 'filename';
  var src = 'some.txt';
  var got = _.uriOld.dir( src );
  var exp = '.';
  test.identical( got, exp );

  test.case = 'absolute path to file';
  var src = '/foo/bar/baz.asdf';
  var got = _.uriOld.dir( src );
  var exp = '/foo/bar';
  test.identical( got, exp );

  test.case = 'absolute path to hidden file';
  var src = '/foo/bar/.baz';
  var got = _.uriOld.dir( src );
  var exp = '/foo/bar';
  test.identical( got, exp );

  test.case = 'absolute path to file with complex extention';
  var src = '/foo.coffee.md';
  var got = _.uriOld.dir( src );
  var exp = '/';
  test.identical( got, exp );

  test.case = 'absolute path to file without extention';
  var src = '/foo/bar/baz';
  var got = _.uriOld.dir( src );
  var exp = '/foo/bar';
  test.identical( got, exp );

  test.case = 'absolute path to file, begins on one slash';
  var src = '/some/staging/index.html';
  var got = _.uriOld.dir( src );
  var exp = '/some/staging';
  test.identical( got, exp );

  test.case = 'absolute path to file, begins on two slashes';
  var src = '//some/staging/index.html';
  var got = _.uriOld.dir( src );
  var exp = '//some/staging';
  test.identical( got, exp );

  test.case = 'absolute path to file, begins on three slashes';
  var src = '///some/staging/index.html';
  var got = _.uriOld.dir( src );
  var exp = '///some/staging';
  test.identical( got, exp );

  test.case = 'hard drive path to file';
  var src = 'file:///some/staging/index.html';
  var got = _.uriOld.dir( src );
  var exp = 'file:///some/staging';
  test.identical( got, exp );

  test.case = 'http path to file';
  var src = 'http://some.come/staging/index.html';
  var got = _.uriOld.dir( src );
  var exp = 'http://some.come/staging';
  test.identical( got, exp );

  test.case = 'svn+https path to file';
  var src = 'svn+https://user@subversion.com/svn/trunk/index.html';
  var got = _.uriOld.dir( src );
  var exp = 'svn+https://user@subversion.com/svn/trunk';
  test.identical( got, exp );

  test.case = 'complex+protocol path to file';
  var src = 'complex+protocol://www.site.com:13/path/name.html?query=here&and=here#anchor';
  var got = _.uriOld.dir( src );
  var exp = 'complex+protocol://www.site.com:13/path?query=here&and=here#anchor';
  test.identical( got, exp );

  test.case = 'path to file with options';
  var src = '://www.site.com:13/path/name.html?query=here&and=here#anchor';
  var got = _.uriOld.dir( src );
  var exp = '://www.site.com:13/path?query=here&and=here#anchor';
  test.identical( got, exp );

  test.case = 'path to file with options';
  var src = ':///www.site.com:13/path/name.html?query=here&and=here#anchor';
  var got = _.uriOld.dir( src );
  var exp = ':///www.site.com:13/path?query=here&and=here#anchor';
  test.identical( got, exp );

  /* */

  test.open( 'trailing slash' );

  var src = '/a/b/';
  var expected = '/a/';
  var got = _.uriOld.dir( src );
  test.identical( got, expected );

  var src = '/a/b/.';
  var expected = '/a';
  var got = _.uriOld.dir( src );
  test.identical( got, expected );

  var src = '/a/b/./';
  var expected = '/a/';
  var got = _.uriOld.dir( src );
  test.identical( got, expected );

  var src = '/a/b/././';
  var expected = '/a/';
  var got = _.uriOld.dir( src );
  test.identical( got, expected );

  var src = '/a/b/./.';
  var expected = '/a';
  var got = _.uriOld.dir( src );
  test.identical( got, expected );

  var src = 'a/b/';
  var expected = 'a/';
  var got = _.uriOld.dir( src );
  test.identical( got, expected );

  var src = 'a/b/.';
  var expected = 'a';
  var got = _.uriOld.dir( src );
  test.identical( got, expected );

  var src = 'a/b/./';
  var expected = 'a/';
  var got = _.uriOld.dir( src );
  test.identical( got, expected );

  var src = '/a/b/';
  var expected = '/a/';
  var got = _.uriOld.dir( src );
  test.identical( got, expected );

  var src = 'http:///a/b/.';
  var expected = 'http:///a';
  var got = _.uriOld.dir( src );
  test.identical( got, expected );

  var src = 'http:///a/b/./';
  var expected = 'http:///a/';
  var got = _.uriOld.dir( src );
  test.identical( got, expected );

  var src = 'http://a/b/';
  var expected = 'http://a/';
  var got = _.uriOld.dir( src );
  test.identical( got, expected );

  var src = 'http://a/b/.';
  var expected = 'http://a';
  var got = _.uriOld.dir( src );
  test.identical( got, expected );

  var src = 'http://a/b/./';
  var expected = 'http://a/';
  var got = _.uriOld.dir( src );
  test.identical( got, expected );

  test.close( 'trailing slash' );

  /* - */

  if( !Config.debug )
  return;

  test.case = 'passed argument is non string';
  test.shouldThrowErrorSync( function()
  {
    _.uriOld.dir( false );
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
  var got = _.uriOld.dirFirst( src );
  var exp = './';
  test.identical( got, exp );

  test.case = 'absolute path to file';
  var src = '/foo/bar/baz.asdf';
  var got = _.uriOld.dirFirst( src );
  var exp = '/foo/bar/';
  test.identical( got, exp );

  test.case = 'absolute path to hidden file';
  var src = '/foo/bar/.baz';
  var got = _.uriOld.dirFirst( src );
  var exp = '/foo/bar/';
  test.identical( got, exp );

  test.case = 'absolute path to file with complex extention';
  var src = '/foo.coffee.md';
  var got = _.uriOld.dirFirst( src );
  var exp = '/';
  test.identical( got, exp );

  test.case = 'absolute path to file without extention';
  var src = '/foo/bar/baz';
  var got = _.uriOld.dirFirst( src );
  var exp = '/foo/bar/';
  test.identical( got, exp );

  test.case = 'absolute path to file, begins on one slash';
  var src = '/some/staging/index.html';
  var got = _.uriOld.dirFirst( src );
  var exp = '/some/staging/';
  test.identical( got, exp );

  test.case = 'absolute path to file, begins on two slashes';
  var src = '//some/staging/index.html';
  var got = _.uriOld.dirFirst( src );
  var exp = '//some/staging/';
  test.identical( got, exp );

  test.case = 'absolute path to file, begins on three slashes';
  var src = '///some/staging/index.html';
  var got = _.uriOld.dirFirst( src );
  var exp = '///some/staging/';
  test.identical( got, exp );

  test.case = 'hard drive path to file';
  var src = 'file:///some/staging/index.html';
  var got = _.uriOld.dirFirst( src );
  var exp = 'file:///some/staging/';
  test.identical( got, exp );

  test.case = 'http path to file';
  var src = 'http://some.come/staging/index.html';
  var got = _.uriOld.dirFirst( src );
  var exp = 'http://some.come/staging/';
  test.identical( got, exp );

  test.case = 'svn+https path to file';
  var src = 'svn+https://user@subversion.com/svn/trunk/index.html';
  var got = _.uriOld.dirFirst( src );
  var exp = 'svn+https://user@subversion.com/svn/trunk/';
  test.identical( got, exp );

  test.case = 'complex+protocol path to file';
  var src = 'complex+protocol://www.site.com:13/path/name.html?query=here&and=here#anchor';
  var got = _.uriOld.dirFirst( src );
  var exp = 'complex+protocol://www.site.com:13/path/?query=here&and=here#anchor';
  test.identical( got, exp );

  test.case = 'path to file with options';
  var src = '://www.site.com:13/path/name.html?query=here&and=here#anchor';
  var got = _.uriOld.dirFirst( src );
  var exp = '://www.site.com:13/path/?query=here&and=here#anchor';
  test.identical( got, exp );

  test.case = 'path to file with options';
  var src = ':///www.site.com:13/path/name.html?query=here&and=here#anchor';
  var got = _.uriOld.dirFirst( src );
  var exp = ':///www.site.com:13/path/?query=here&and=here#anchor';
  test.identical( got, exp );

  /* */

  test.open( 'trailing slash' );

  var src = '/a/b/';
  var expected = '/a/b/';
  var got = _.uriOld.dirFirst( src );
  test.identical( got, expected );

  var src = '/a/b/.';
  var expected = '/a/';
  var got = _.uriOld.dirFirst( src );
  test.identical( got, expected );

  var src = '/a/b/./';
  var expected = '/a/b/';
  var got = _.uriOld.dirFirst( src );
  test.identical( got, expected );

  var src = '/a/b/././';
  var expected = '/a/b/';
  var got = _.uriOld.dirFirst( src );
  test.identical( got, expected );

  var src = '/a/b/./.';
  var expected = '/a/';
  var got = _.uriOld.dirFirst( src );
  test.identical( got, expected );

  var src = 'a/b/';
  var expected = 'a/b/';
  var got = _.uriOld.dirFirst( src );
  test.identical( got, expected );

  var src = 'a/b/.';
  var expected = 'a/';
  var got = _.uriOld.dirFirst( src );
  test.identical( got, expected );

  var src = 'a/b/./';
  var expected = 'a/b/';
  var got = _.uriOld.dirFirst( src );
  test.identical( got, expected );

  var src = '/a/b/';
  var expected = '/a/b/';
  var got = _.uriOld.dirFirst( src );
  test.identical( got, expected );

  var src = 'http:///a/b/.';
  var expected = 'http:///a/';
  var got = _.uriOld.dirFirst( src );
  test.identical( got, expected );

  var src = 'http:///a/b/./';
  var expected = 'http:///a/b/';
  var got = _.uriOld.dirFirst( src );
  test.identical( got, expected );

  var src = 'http://a/b/';
  var expected = 'http://a/b/';
  var got = _.uriOld.dirFirst( src );
  test.identical( got, expected );

  var src = 'http://a/b/.';
  var expected = 'http://a/';
  var got = _.uriOld.dirFirst( src );
  test.identical( got, expected );

  var src = 'http://a/b/./';
  var expected = 'http://a/b/';
  var got = _.uriOld.dirFirst( src );
  test.identical( got, expected );

  test.close( 'trailing slash' );

  /* - */

  if( !Config.debug )
  return;

  test.case = 'passed argument is non string';
  test.shouldThrowErrorSync( function()
  {
    _.uriOld.dir( false );
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
//   var got = _.uriOld.filter( src, onEach );
//   var expected = 'file:///a/b/c';
//   test.identical( got, expected );
//
//   test.case = 'array';
//   var src = [ '/a', '/b' ];
//   var got = _.uriOld.filter( src, onEach );
//   var expected = [ 'file:///a', 'file:///b' ];
//   test.identical( got, expected );
//   test.true( got !== src );
//
//   test.case = 'array filter';
//   var src = [ 'file:///a', '/b' ];
//   var got = _.uriOld.filter( src, onEachFilter );
//   var expected = 'file:///a';
//   test.identical( got, expected );
//   test.true( got !== src );
//
//   test.case = 'map';
//   var src = { '/src' : '/dst' };
//   var got = _.uriOld.filter( src, onEach );
//   var expected = { 'file:///src' : 'file:///dst' };
//   test.identical( got, expected );
//   test.true( got !== src );
//
//   test.case = 'map filter';
//   var src = { 'file:///src' : '/dst' };
//   var got = _.uriOld.filter( src, onEachFilter );
//   var expected = '';
//   test.identical( got, expected );
//   test.true( got !== src );
//
//   test.case = 'map filter';
//   var src = { 'file:///a' : [ 'file:///b', 'file:///c', null, undefined ] };
//   var got = _.uriOld.filter( src, onEachStructure );
//   var expected =
//   {
//     'file:///src/a' : [ 'file:///dst/b', 'file:///dst/c', 'file:///dst' ]
//   };
//   test.identical( got, expected );
//   test.true( got !== src );
//
//   test.case = 'map filter keys, onEach returns array with undefined';
//   var src = { '/a' : '/b' };
//   var got = _.uriOld.filter( src, onEachStructureKeys );
//   var expected =
//   {
//     'file:///a' : '/b'
//   };
//   test.identical( got, expected );
//   test.true( got !== src );
//
//   test.case = 'null';
//   var src = null;
//   var got = _.uriOld.filter( src, onEach );
//   var expected = 'file:///';
//   test.identical( got, expected );
//
//   if( Config.debug )
//   {
//     test.case = 'number';
//     test.shouldThrowErrorSync( () => _.uriOld.filter( 1, onEach ) )
//   }
//
//   /*  */
//
//   function onEach( filePath, it )
//   {
//     if( filePath === null )
//     return 'file:///';
//     return _.uriOld.reroot( 'file:///', filePath );
//   }
//
//   function onEachFilter( filePath, it )
//   {
//     if( _.uriOld.isGlobal( filePath ) )
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
//       return _.uriOld.reroot( prefix, path );
//     }
//   }
//
//   function onEachStructureKeys( filePath, it )
//   {
//     if( it.side === 'src' )
//     return [ _.uriOld.join( 'file:///src', filePath ), undefined ];
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
//   var got = _.uriOld.filterInplace( src, onEach );
//   var expected = 'file:///a/b/c';
//   test.identical( got, expected );
//
//   test.case = 'array';
//   var src = [ '/a', '/b' ];
//   var got = _.uriOld.filterInplace( src, onEach );
//   var expected = [ 'file:///a', 'file:///b' ];
//   test.identical( got, expected );
//   test.identical( got, src );
//
//   test.case = 'array';
//   var src = [ 'file:///a', '/b' ];
//   var got = _.uriOld.filterInplace( src, onEachFilter );
//   var expected = [ 'file:///a' ];
//   test.identical( got, expected );
//   test.identical( got, src );
//
//   test.case = 'map';
//   var src = { '/src' : '/dst' };
//   var got = _.uriOld.filterInplace( src, onEach );
//   var expected = { 'file:///src' : 'file:///dst' };
//   test.identical( got, expected );
//   test.identical( got, src );
//
//   test.case = 'map';
//   var src = { 'file:///src' : '/dst' };
//   var got = _.uriOld.filterInplace( src, onEachFilter );
//   var expected = {};
//   test.identical( got, expected );
//   test.identical( got, src );
//
//   test.case = 'map';
//   var src = { 'file:///a' : [ 'file:///b', 'file:///c', null, undefined ] };
//   var got = _.uriOld.filterInplace( src, onEachStructure );
//   var expected =
//   {
//     'file:///src/a' : [ 'file:///dst/b', 'file:///dst/c', 'file:///dst' ]
//   };
//   test.identical( got, expected );
//   test.identical( got, src );
//
//   test.case = 'map filter keys, onEach returns array with undefined';
//   var src = { '/a' : '/b' };
//   var got = _.uriOld.filterInplace( src, onEachStructureKeys );
//   var expected =
//   {
//     'file:///a' : '/b'
//   };
//   test.identical( got, expected );
//   test.identical( got, src );
//
//   test.case = 'null';
//   var src = null;
//   var got = _.uriOld.filterInplace( src, onEach );
//   var expected = 'file:///';
//   test.identical( got, expected );
//
//   if( Config.debug )
//   {
//     test.case = 'number';
//     test.shouldThrowErrorSync( () => _.uriOld.filterInplace( 1, onEach ) )
//   }
//
//   /*  */
//
//   function onEach( filePath, it )
//   {
//     if( filePath === null )
//     return 'file:///';
//     return _.uriOld.reroot( 'file:///', filePath );
//   }
//
//   function onEachFilter( filePath, it )
//   {
//     if( _.uriOld.isGlobal( filePath ) )
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
//       return _.uriOld.reroot( prefix, path );
//     }
//   }
//
//   function onEachStructureKeys( filePath, it )
//   {
//     if( it.side === 'src' )
//     return [ _.uriOld.join( 'file:///src', filePath ), undefined ];
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

const Proto =
{

  name : 'Tools.l4.Uri.Old',
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

    /* qqq : refactor test routines parse, parseAtomic, parseConsecutive, parseFull. ask how to */
    parse,
    parseAtomic,
    parseConsecutive,
    parseFull,
    parseGlob,
    parseTagExperiment,

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
    joinRaw,
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

const Self = wTestSuite( Proto );

if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self );

})();
