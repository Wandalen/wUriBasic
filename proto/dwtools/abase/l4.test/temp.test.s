// EXAMPLE

/* */

  test.case = 'local';
  var src = '/a/!a.js';

  test.description = 'atomic';
  var expected =
  {
    'longPath' : '/a/',
    'tag' : 'a.js'
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
    'host' : 'a',
    'protocols' : [],
    'full' : '/a/!a.js'
  }
  var got = _.uriNew.parseFull( src );
  test.identical( got, expected );
  var str = _.uriNew.str( got );
  test.identical( str, src );

  /* - */

test.case = 'query only';
  var remotePath = '?entry:1&format:null';
  var expected =
  {
    'longPath' : '',
    'query' : 'entry:1&format:null',
    'postfixedPath' : '?entry:1&format:null',
    'protocols' : [],
    'full' : '?entry:1&format:null',
  }
  var got = _.uriNew.parseFull( remotePath );
  test.identical( got, expected );

  /* */

  test.case = 'global, relative, with hash, with query';
  var remotePath = 'git://../repo/Tools?out=out/wTools.out.will#master';
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
  var got = _.uriNew.parseFull( remotePath );
  test.identical( got, expected );

  /* */

  test.case = 'global, absolute, with hash, with query';
  var remotePath = "git:///../repo/Tools?out=out/wTools.out.will#master"
  var expected =
  {
    'protocol' : 'git',
    'longPath' : '/../repo/Tools',
    'query' : 'out=out/wTools.out.will',
    'hash' : 'master',
    'postfixedPath' : '/../repo/Tools?out=out/wTools.out.will#master',
    'hostFull' : '/..',
    'protocols' : [ 'git' ],
    'resourcePath' : 'repo/Tools',
    'host' : '..',
    'origin' : 'git:///..',
    'full' : 'git:///../repo/Tools?out=out/wTools.out.will#master',
  }
  var got = _.uriNew.parseFull( remotePath );
  test.identical( got, expected );

  /* */

  test.case = 'query with equal. relative';
  var remotePath = 'http://127.0.0.1:5000/a/b?q=3#anch';
  var expected =
  {
    'protocol' : 'http',
    'longPath' : '127.0.0.1:5000/a/b',
    'query' : 'q=3',
    'hash' : 'anch'
  }
  var got = _.uriNew.parseAtomic( remotePath );
  test.identical( got, expected );

  /* */

  test.case = 'query with equal. absolute';
  var remotePath = 'http:///127.0.0.1:5000/a/b?q=3#anch';
  var expected =
  {
    'protocol' : 'http',
    'longPath' : '/127.0.0.1:5000/a/b',
    'query' : 'q=3',
    'hash' : 'anch',
    'postfixedPath' : '/127.0.0.1:5000/a/b?q=3#anch',
    'hostFull' : '/127.0.0.1:5000',
    'resourcePath' : 'a/b',
    'host' : '127.0.0.1',
    'port' : 5000,
    'protocols' : [ 'http' ],
    'origin' : 'http:///127.0.0.1:5000',
    'full' : 'http:///127.0.0.1:5000/a/b?q=3#anch',
  }
  var got = _.uriNew.parseFull( remotePath );
  test.identical( got, expected );

  /* */

  test.case = 'query with colon. relative';
  var remotePath = 'http://127.0.0.1:5000/a/b?q:3#anch';
  var expected =
  {
    'protocol' : 'http',
    'longPath' : '127.0.0.1:5000/a/b',
    'query' : 'q:3',
    'hash' : 'anch',
    'postfixedPath' : '127.0.0.1:5000/a/b?q:3#anch',
    'hostFull' : '127.0.0.1:5000',
    'resourcePath' : 'a/b',
    'host' : '127.0.0.1',
    'port' : 5000,
    'protocols' : [ 'http' ],
    'origin' : 'http://127.0.0.1:5000',
    'full' : 'http://127.0.0.1:5000/a/b?q:3#anch'
  }
  var got = _.uriNew.parseFull( remotePath );
  test.identical( got, expected );

  /* */

  test.case = 'query with colon. absolute';
  var remotePath = 'http:///127.0.0.1:5000/a/b?q:3#anch';
  var expected =
  {
    'protocol' : 'http',
    'longPath' : '/127.0.0.1:5000/a/b',
    'query' : 'q:3',
    'hash' : 'anch',
    'postfixedPath' : '/127.0.0.1:5000/a/b?q:3#anch',
    'hostFull' : '/127.0.0.1:5000',
    'resourcePath' : 'a/b',
    'host' : '127.0.0.1',
    'port' : 5000,
    'protocols' : [ 'http' ],
    'origin' : 'http:///127.0.0.1:5000',
    'full' : 'http:///127.0.0.1:5000/a/b?q:3#anch',
  }
  var got = _.uriNew.parseFull( remotePath );
  test.identical( got, expected );

  /* */

  test.case = 'no protocol';
  var uri = '127.0.0.1:61726/../path';
  var expected =
  {
    'longPath' : '127.0.0.1:61726/../path',
    'postfixedPath' : '127.0.0.1:61726/../path',
    'hostFull' : '127.0.0.1:61726',
    'resourcePath' : '../path',
    'host' : '127.0.0.1',
    'port' : 61726,
    'protocols' : [],
    'origin' : 'undefined://127.0.0.1:61726',
    'full' : '127.0.0.1:61726/../path'
  }
  var got = _.uriNew.parseFull( uri );
  test.identical( got, expected );

  debugger; return; /* qqq2 : update all other test cases */

  /* */

  test.case = 'full uri with all components';
  var expected =
  {
    protocol : 'http',
    longPath : 'www.site.com:13/path/name',
    query : 'query=here&and=here',
    hash : 'anchor',
  }
  var uri1 = 'http://www.site.com:13/path/name?query=here&and=here#anchor';
  var got = _.uriNew.parseFull( uri1 );
  test.identical( got, expected );

  /* */

  test.case = 'full uri with all components, primitiveOnly';

  var expected =
  {
    protocol : 'http',
    longPath : 'www.site.com:13/path/name',
    query : 'query=here&and=here',
    hash : 'anchor',
  }

  var uri1 = 'http://www.site.com:13/path/name?query=here&and=here#anchor';
  var got = _.uriNew.parseFull( uri1 );
  test.identical( got, expected );

  /* */

  test.case = 'reparse with non primitives';

  var expected =
  {
    protocol : 'http',
    longPath : 'www.site.com:13/path/name',
    query : 'query=here&and=here',
    hash : 'anchor',
  }

  var parsed = got;
  var got = _.uriNew.parseFull( parsed );
  test.identical( got, expected );

  /* */

  test.case = 'reparse with primitives';

  var uri1 = 'http://www.site.com:13/path/name?query=here&and=here#anchor';
  var expected =
  {
    protocol : 'http',
    longPath : 'www.site.com:13/path/name',
    query : 'query=here&and=here',
    hash : 'anchor',
  }

  var got = _.uriNew.parseFull( uri1 );
  test.identical( got, expected );

  /* */

  test.case = 'uri with zero length protocol';
  var uri = '://some.domain.com/something/filePath/add';
  var expected =
  {
    protocol : '',
    longPath : 'some.domain.com/something/filePath/add',
  }
  var got = _.uriNew.parseFull( uri );
  test.identical( got, expected );

  /* */

  test.case = 'uri with zero length hostFull';
  var uri = 'file:///something/filePath/add';
  var expected =
  {
    protocol : 'file',
    longPath : '/something/filePath/add',
  }
  var got = _.uriNew.parseFull( uri );
  test.identical( got, expected );

  /* */

  test.case = 'uri with double protocol, user';
  var uri = 'svn+https://user@subversion.com:13/svn/trunk';
  var expected =
  {
    protocol : 'svn+https',
    longPath : 'user@subversion.com:13/svn/trunk',
  }
  var got = _.uriNew.parseFull( uri );
  test.identical( got, expected );

  /* */

  test.case = 'uri with double protocol, user and tag';
  var uri = 'svn+https://user@subversion.com:13/svn/trunk!tag1';
  var expected =
  {
    protocol : 'svn+https',
    longPath : 'user@subversion.com:13/svn/trunk',
    tag : 'tag1',
  }
  var got = _.uriNew.parseFull( uri );
  test.identical( got, expected );

  /* */

  test.case = 'simple path';
  var uri = '/some/file';
  var expected =
  {
    longPath : '/some/file',
  }
  var got = _.uriNew.parseFull( uri );
  test.identical( got, expected );

  /* */

  test.case = 'without ":"';
  var uri = '//some.domain.com/was';
  var expected =
  {
    longPath : '//some.domain.com/was',
  }
  var got = _.uriNew.parseFull( uri );
  test.identical( got, expected );

  /* */

  test.case = 'with ":" and protocol';

  var uri = 'protocol://some.domain.com/was';
  var expected =
  {
    protocol : 'protocol',
    longPath : 'some.domain.com/was',
  }

  var got = _.uriNew.parseFull( uri );
  test.identical( got, expected );

  /* */

  test.case = 'simple path';
  var uri = '//';
  var expected =
  {
    longPath : '//',
  }
  var got = _.uriNew.parseFull( uri );
  test.identical( got, expected );
  /* */

  test.case = 'simple path';

  var uri = '///';
  var expected =
  {
    longPath : '///',
  }

  var got = _.uriNew.parseFull( uri );
  test.identical( got, expected );

  /* */

  test.case = 'simple path';

  var uri = '///a/b/c';
  var expected =
  {
    longPath : '///a/b/c',
  }

  var got = _.uriNew.parseFull( uri );
  test.identical( got, expected );

  /* */

  test.case = '???'; /* qqq : describe cases without description ( short! ) */
  var uri = 'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor';
  var expected =
  {
    protocol : 'complex+protocol',
    longPath : 'www.site.com:13/path/name',
    query : 'query=here&and=here',
    hash : 'anchor',
  }

  var got = _.uriNew.parseFull( uri );
  test.identical( got, expected );

  /* */

  test.case = '???';
  var uri = '://www.site.com:13/path//name//?query=here&and=here#anchor';
  var got = _.uriNew.parseFull( uri );
  var expected =
  {
    protocol : '',
    longPath : 'www.site.com:13/path//name//',
    query : 'query=here&and=here',
    hash : 'anchor',
  }
  test.identical( got, expected );

  /* */

  test.case = '???';
  var uri = ':///www.site.com:13/path//name//?query=here&and=here#anchor';
  var got = _.uriNew.parseFull( uri );
  var expected =
  {
    protocol : '',
    longPath : '/www.site.com:13/path//name//',
    query : 'query=here&and=here',
    hash : 'anchor',
  }
  test.identical( got, expected );

  /* */

  test.case = 'not ://, but //';

  var expected =
  {
    longPath : '///some.com:99/staging/index.html',
    query : 'query=here&and=here',
    hash : 'anchor',
  }
  var got = _.uriNew.parseFull( '///some.com:99/staging/index.html?query=here&and=here#anchor' );
  test.identical( got, expected );

  /* */

  test.case = 'tag and user';

  var expected =
  {
    longPath : 'git@bitbucket.org:someorg/somerepo.git',
    tag : 'tag',
    protocol : 'git',
  }
  var got = _.uriNew.parseFull( 'git://git@bitbucket.org:someorg/somerepo.git!tag' );
  test.identical( got, expected );

  /* */

  test.case = '???';

  var expected =
  {
    longPath : '/git@bitbucket.org',
    protocol : 'git',
  }
  var got = _.uriNew.parseFull( 'git:///git@bitbucket.org' );
  test.identical( got, expected );

  /* */

  test.case = '???';

  var expected =
  {
    longPath : '/git@bitbucket.org',
    tag : 'tag',
    protocol : 'git',
  }
  var got = _.uriNew.parseFull( 'git:///git@bitbucket.org!tag' );
  test.identical( got, expected );

  /* */

  test.case = '???';

  var expected =
  {
    longPath : '/git@bitbucket.org/somerepo.git',
    tag : 'tag',
    protocol : 'git',
  }
  var got = _.uriNew.parseFull( 'git:///git@bitbucket.org/somerepo.git!tag' );
  test.identical( got, expected );

  /* */

  test.case = '???';

  var expected =
  {
    longPath : '/git@bitbucket.org:someorg/somerepo.git',
    tag : 'tag',
    protocol : 'git',
  }
  var got = _.uriNew.parseFull( 'git:///git@bitbucket.org:someorg/somerepo.git!tag' );
  test.identical( got, expected );

  /* */

  test.case = '???';

  var expected =
  {
    protocol : 'git',
    longPath : '/git@bitbucket.org:someorg/somerepo.git',
    hash : 'hash'
  }
  var got = _.uriNew.parseFull( 'git:///git@bitbucket.org:someorg/somerepo.git#hash' );
  test.identical( got, expected );

  /* */

  test.case = '???';

  var expected =
  {
    protocol : 'git',
    longPath : '/git@bitbucket.org:someorg/somerepo.git/',
    hash : 'hash'
  }
  var got = _.uriNew.parseFull( 'git:///git@bitbucket.org:someorg/somerepo.git/#hash' );
  test.identical( got, expected );

  /* */

  test.case = '???';

  var expected =
  {
    protocol : 'git',
    longPath : '/somerepo.git',
    hash : 'hash'
  }
  var got = _.uriNew.parseFull( 'git:///somerepo.git#hash' );
  test.identical( got, expected );

  /* */

  test.case = '???';

  var expected =
  {
    protocol : 'git',
    longPath : '/somerepo.git/',
    hash : 'hash'
  }
  var got = _.uriNew.parseFull( 'git:///somerepo.git/#hash' );
  test.identical( got, expected );

  /* */

  test.case = '???';

  var expected =
  {
    protocol : 'git',
    longPath : '/git@bitbucket.org:someorg/somerepo.git/',
    tag : 'tag',
  }
  var got = _.uriNew.parseFull( 'git:///git@bitbucket.org:someorg/somerepo.git/!tag' );
  test.identical( got, expected );

  /* */

  test.case = '???';

  var expected =
  {
    protocol : 'git',
    longPath : '/somerepo.git/',
    tag : 'tag',
  }
  var got = _.uriNew.parseFull( 'git:///somerepo.git/!tag' );
  test.identical( got, expected );

  /* */

  test.case = '???';

  var expected =
  {
    protocol : 'git',
    longPath : '/git@bitbucket.org:someorg/somerepo.git',
    hash : 'hash',
    tag : 'tag'
  }
  var got = _.uriNew.parseFull( 'git:///git@bitbucket.org:someorg/somerepo.git#hash!tag' );
  test.identical( got, expected );

  /* */

  test.case = '???';

  var expected =
  {
    protocol : 'git',
    longPath : '/git@bitbucket.org:someorg/somerepo.git/',
    hash : 'hash',
    tag : 'tag'
  }
  var got = _.uriNew.parseFull( 'git:///git@bitbucket.org:someorg/somerepo.git/#hash!tag' );
  test.identical( got, expected );

  /* */

  test.case = '???';

  var expected =
  {
    protocol : 'git',
    longPath : '/somerepo.git',
    hash : 'hash',
    tag : 'tag',
  }
  var got = _.uriNew.parseFull( 'git:///somerepo.git#hash!tag' );
  test.identical( got, expected );

  /* */

  test.case = '???';

  var expected =
  {
    protocol : 'git',
    longPath : '/somerepo.git/',
    hash : 'hash',
    tag : 'tag',
  }
  var got = _.uriNew.parseFull( 'git:///somerepo.git/#hash!tag' );
  test.identical( got, expected );

  /* */

  test.case = '???';

  var expected =
  {
    protocol : 'git',
    longPath : '/git@bitbucket.org:someorg/somerepo.git',
    query : 'query=1',
    hash : 'hash',
    tag : 'tag',
  }
  var got = _.uriNew.parseFull( 'git:///git@bitbucket.org:someorg/somerepo.git?query=1#hash!tag' );
  test.identical( got, expected );

  /* */

  test.case = '???';

  var expected =
  {
    protocol : 'git',
    longPath : '/git@bitbucket.org:someorg/somerepo.git/',
    query : 'query=1',
    hash : 'hash',
    tag : 'tag',
  }
  var got = _.uriNew.parseFull( 'git:///git@bitbucket.org:someorg/somerepo.git/?query=1#hash!tag' );
  test.identical( got, expected );

  /* */

  test.case = '???';

  var expected =
  {
    protocol : 'git',
    longPath : '/somerepo.git',
    query : 'query=1',
    hash : 'hash',
    tag : 'tag',
  }
  var got = _.uriNew.parseFull( 'git:///somerepo.git?query=1#hash!tag' );
  test.identical( got, expected );

  /* */

  test.case = '???';

  var expected =
  {
    protocol : 'git',
    longPath : '/somerepo.git/',
    query : 'query=1',
    hash : 'hash',
    tag : 'tag',
  }
  var got = _.uriNew.parseFull( 'git:///somerepo.git/?query=1#hash!tag' );
  test.identical( got, expected );

  /* */

  test.case = '???';

  var expected =
  {
    protocol : 'git',
    longPath : '/git@bitbucket.org:someorg/somerepo.git',
    query : 'query=1',
    tag : 'tag',
  }
  var got = _.uriNew.parseFull( 'git:///git@bitbucket.org:someorg/somerepo.git?query=1!tag' );
  test.identical( got, expected );

  /* */

  test.case = '???';

  var expected =
  {
    protocol : 'git',
    longPath : '/git@bitbucket.org:someorg/somerepo.git/',
    query : 'query=1',
    tag : 'tag',
  }
  var got = _.uriNew.parseFull( 'git:///git@bitbucket.org:someorg/somerepo.git/?query=1!tag' );
  test.identical( got, expected );

  /* */

  test.case = '???';

  var expected =
  {
    protocol : 'git',
    longPath : '/somerepo.git',
    query : 'query=1',
    tag : 'tag',
  }
  var got = _.uriNew.parseFull( 'git:///somerepo.git?query=1!tag' );
  test.identical( got, expected );

  /* */

  test.case = '???';

  var expected =
  {
    protocol : 'git',
    longPath : '/somerepo.git/',
    query : 'query=1',
    tag : 'tag',
  }
  var got = _.uriNew.parseFull( 'git:///somerepo.git/?query=1!tag' );
  test.identical( got, expected );

  /* */

  test.case = '# @ ?';
  var expected =
  {
    longPath : '',
    query : 'query1',
    tag : 'tag1/',
    hash : 'hash1/',
    protocol : '',
  }
  var got = _.uriNew.parseFull( '://#hash1/!tag1/?query1' );
  test.identical( got, expected );

  /* */

  test.case = 'escaped # @ ?';
  var expected =
  {
    longPath : '"#hash1"/"!tag1"/"?query1"',
    protocol : '',
  }
  var got = _.uriNew.parseFull( '://"#hash1"/"!tag1"/"?query1"' );
  test.identical( got, expected );

  /* - */

  if( !Config.debug )
  return;

  test.case = 'missed arguments';
  test.shouldThrowErrorSync( function()
  {
    _.uriNew.parseFull();
  });

  test.case = 'redundant argument';
  test.shouldThrowErrorSync( function()
  {
    _.uriNew.parseFull( 'http://www.site.com:13/path/name?query=here&and=here#anchor','' );
  });

  test.case = 'argument is not string';
  test.shouldThrowErrorSync( function()
  {
    _.uriNew.parseFull( 34 );
  });



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
  var got = _.uriNew.parseFull( remotePath );
  test.identical( got, expected );

  /* */

  test.case = 'global, relative, with hash, with query';
  var remotePath = "git://../repo/Tools?out=out/wTools.out.will#master"
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
  var got = _.uriNew.parseFull( remotePath );
  test.identical( got, expected );

  /* */

  test.case = 'global, absolute, with hash, with query';
  var remotePath = "git:///../repo/Tools?out=out/wTools.out.will#master"
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
  var got = _.uriNew.parseFull( remotePath );
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
  var got = _.uriNew.parseFull( remotePath );
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
  var got = _.uriNew.parseFull( remotePath );
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
  var got = _.uriNew.parseFull( uri );
  test.identical( got, expected );

  var expected =
  {
    'resourcePath' : '127.0.0.1:61726/../path',
    'longPath' : '127.0.0.1:61726/../path',
    'postfixedPath' : '127.0.0.1:61726/../path',
    'protocols' : [],
    'full' : '127.0.0.1:61726/../path'
  }
  var got = _.uriNew.parseFull( uri );
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
  var got = _.uriNew.parseFull( uri1 );
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
  var got = _.uriNew.parseFull( uri1 );
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
  var got = _.uriNew.parseFull( parsed );
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
  var got = _.uriNew.parseFull( uri1 );
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

  var got = _.uriNew.parseFull( uri );
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

  var got = _.uriNew.parseFull( uri );
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
    protocols : [ 'svn','https' ],
    hostFull : 'user@subversion.com',
    origin : 'svn+https://user@subversion.com',
    full : 'svn+https://user@subversion.com/svn/trunk',
  }

  var got = _.uriNew.parseFull( uri );
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

  var got = _.uriNew.parseFull( uri );
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

  var got = _.uriNew.parseFull( uri );
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

  var got = _.uriNew.parseFull( uri );
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

  var got = _.uriNew.parseFull( uri );
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

  var got = _.uriNew.parseFull( uri );
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

  var got = _.uriNew.parseFull( uri );
  test.identical( got, expected );

  test.case = '???';
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

  var got = _.uriNew.parseFull( uri );
  test.identical( got, expected );

  var uri = '://www.site.com:13/path//name//?query=here&and=here#anchor';
  var got = _.uriNew.parseFull( uri );
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
  var got = _.uriNew.parseFull( uri );
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
  var got = _.uriNew.parseFull( uri );
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
  var got = _.uriNew.parseFull( uri );
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
  var got = _.uriNew.parseFull( '///some.com:99/staging/index.html?query=here&and=here#anchor' );
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
    hostFull : '',
    tag : 'tag',
    origin : 'git://',
    full : 'git:///git@bitbucket.org:someorg/somerepo.git!tag'
  }
  var got = _.uriNew.parseFull( 'git:///git@bitbucket.org:someorg/somerepo.git!tag' );
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
  var got = _.uriNew.parseFull( 'git:///git@bitbucket.org:someorg/somerepo.git#hash' );
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
  var got = _.uriNew.parseFull( 'git:///git@bitbucket.org:someorg/somerepo.git/#hash' );
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
  var got = _.uriNew.parseFull( 'git:///somerepo.git#hash' );
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
  var got = _.uriNew.parseFull( 'git:///somerepo.git/#hash' );
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
  var got = _.uriNew.parseFull( 'git:///git@bitbucket.org:someorg/somerepo.git/!tag' );
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
  var got = _.uriNew.parseFull( 'git:///somerepo.git/!tag' );
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
  var got = _.uriNew.parseFull( 'git:///git@bitbucket.org:someorg/somerepo.git#hash!tag' );
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
  var got = _.uriNew.parseFull( 'git:///git@bitbucket.org:someorg/somerepo.git/#hash!tag' );
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
  var got = _.uriNew.parseFull( 'git:///somerepo.git#hash!tag' );
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
  var got = _.uriNew.parseFull( 'git:///somerepo.git/#hash!tag' );
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
  var got = _.uriNew.parseFull( 'git:///git@bitbucket.org:someorg/somerepo.git?query=1#hash!tag' );
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
  var got = _.uriNew.parseFull( 'git:///git@bitbucket.org:someorg/somerepo.git/?query=1#hash!tag' );
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
  var got = _.uriNew.parseFull( 'git:///somerepo.git?query=1#hash!tag' );
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
  var got = _.uriNew.parseFull( 'git:///somerepo.git/?query=1#hash!tag' );
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
  var got = _.uriNew.parseFull( 'git:///git@bitbucket.org:someorg/somerepo.git?query=1!tag' );
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
  var got = _.uriNew.parseFull( 'git:///git@bitbucket.org:someorg/somerepo.git/?query=1!tag' );
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
  var got = _.uriNew.parseFull( 'git:///somerepo.git?query=1!tag' );
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
  var got = _.uriNew.parseFull( 'git:///somerepo.git/?query=1!tag' );
  test.identical( got, expected );
