// PARSEFULL2


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






//PARSECONSECUTIVE2

  var uri = ':///www.site.com:13/path//name//?query=here&and=here#anchor';
  var got = _.uriNew.parseConsecutive( uri );
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
  var got = _.uriNew.parseConsecutive( '///some.com:99/staging/index.html?query=here&and=here#anchor' );
  test.identical( got, expected );

  /* */

  var expected =
  {
    protocol : 'git',
    longPath : '/git@bitbucket.org:someorg/somerepo.git',
    postfixedPath : '/git@bitbucket.org:someorg/somerepo.git!tag',
    tag : 'tag'
  }
  var got = _.uriNew.parseConsecutive( 'git:///git@bitbucket.org:someorg/somerepo.git!tag' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    longPath : '/git@bitbucket.org:someorg/somerepo.git',
    postfixedPath : '/git@bitbucket.org:someorg/somerepo.git#hash',
    hash : 'hash'
  }
  var got = _.uriNew.parseConsecutive( 'git:///git@bitbucket.org:someorg/somerepo.git#hash' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    hash : 'hash',
    longPath : '/git@bitbucket.org:someorg/somerepo.git/',
    postfixedPath : '/git@bitbucket.org:someorg/somerepo.git/#hash',
  }
  var got = _.uriNew.parseConsecutive( 'git:///git@bitbucket.org:someorg/somerepo.git/#hash' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    hash : 'hash',
    longPath : '/somerepo.git',
    postfixedPath : '/somerepo.git#hash',
  }
  var got = _.uriNew.parseConsecutive( 'git:///somerepo.git#hash' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    hash : 'hash',
    longPath : '/somerepo.git/',
    postfixedPath : '/somerepo.git/#hash',
  }
  var got = _.uriNew.parseConsecutive( 'git:///somerepo.git/#hash' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    tag : 'tag',
    longPath : '/git@bitbucket.org:someorg/somerepo.git/',
    postfixedPath : '/git@bitbucket.org:someorg/somerepo.git/!tag',
  }
  var got = _.uriNew.parseConsecutive( 'git:///git@bitbucket.org:someorg/somerepo.git/!tag' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    tag : 'tag',
    longPath : '/somerepo.git/',
    postfixedPath : '/somerepo.git/!tag',
  }
  var got = _.uriNew.parseConsecutive( 'git:///somerepo.git/!tag' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    hash : 'hash',
    tag : 'tag',
    longPath : '/git@bitbucket.org:someorg/somerepo.git',
    postfixedPath : '/git@bitbucket.org:someorg/somerepo.git#hash!tag',
  }
  var got = _.uriNew.parseConsecutive( 'git:///git@bitbucket.org:someorg/somerepo.git#hash!tag' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    hash : 'hash',
    tag : 'tag',
    longPath : '/git@bitbucket.org:someorg/somerepo.git/',
    postfixedPath : '/git@bitbucket.org:someorg/somerepo.git/#hash!tag',
  }
  var got = _.uriNew.parseConsecutive( 'git:///git@bitbucket.org:someorg/somerepo.git/#hash!tag' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    hash : 'hash',
    tag : 'tag',
    longPath : '/somerepo.git',
    postfixedPath : '/somerepo.git#hash!tag',
  }
  var got = _.uriNew.parseConsecutive( 'git:///somerepo.git#hash!tag' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    hash : 'hash',
    tag : 'tag',
    longPath : '/somerepo.git/',
    postfixedPath : '/somerepo.git/#hash!tag',
  }
  var got = _.uriNew.parseConsecutive( 'git:///somerepo.git/#hash!tag' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    query : 'query=1',
    hash : 'hash',
    tag : 'tag',
    longPath : '/git@bitbucket.org:someorg/somerepo.git',
    postfixedPath : '/git@bitbucket.org:someorg/somerepo.git?query=1#hash!tag',
  }
  var got = _.uriNew.parseConsecutive( 'git:///git@bitbucket.org:someorg/somerepo.git?query=1#hash!tag' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    query : 'query=1',
    hash : 'hash',
    tag : 'tag',
    longPath : '/git@bitbucket.org:someorg/somerepo.git/',
    postfixedPath : '/git@bitbucket.org:someorg/somerepo.git/?query=1#hash!tag',
  }
  var got = _.uriNew.parseConsecutive( 'git:///git@bitbucket.org:someorg/somerepo.git/?query=1#hash!tag' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    query : 'query=1',
    hash : 'hash',
    tag : 'tag',
    longPath : '/somerepo.git',
    postfixedPath : '/somerepo.git?query=1#hash!tag',
  }
  var got = _.uriNew.parseConsecutive( 'git:///somerepo.git?query=1#hash!tag' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    query : 'query=1',
    hash : 'hash',
    tag : 'tag',
    longPath : '/somerepo.git/',
    postfixedPath : '/somerepo.git/?query=1#hash!tag',
  }
  var got = _.uriNew.parseConsecutive( 'git:///somerepo.git/?query=1#hash!tag' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    query : 'query=1',
    tag : 'tag',
    longPath : '/git@bitbucket.org:someorg/somerepo.git',
    postfixedPath : '/git@bitbucket.org:someorg/somerepo.git?query=1!tag',
  }
  var got = _.uriNew.parseConsecutive( 'git:///git@bitbucket.org:someorg/somerepo.git?query=1!tag' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    query : 'query=1',
    tag : 'tag',
    longPath : '/git@bitbucket.org:someorg/somerepo.git/',
    postfixedPath : '/git@bitbucket.org:someorg/somerepo.git/?query=1!tag',
  }
  var got = _.uriNew.parseConsecutive( 'git:///git@bitbucket.org:someorg/somerepo.git/?query=1!tag' );
  test.identical( got, expected );

  var expected =
  {
    protocol : 'git',
    query : 'query=1',
    tag : 'tag',
    longPath : '/somerepo.git',
    postfixedPath : '/somerepo.git?query=1!tag',
  }
  var got = _.uriNew.parseConsecutive( 'git:///somerepo.git?query=1!tag' );
  test.identical( got, expected );


  var expected =
  {
    protocol : 'git',
    query : 'query=1',
    tag : 'tag',
    longPath : '/somerepo.git/',
    postfixedPath : '/somerepo.git/?query=1!tag',
  }
  var got = _.uriNew.parseConsecutive( 'git:///somerepo.git/?query=1!tag' );
  test.identical( got, expected );

  /* - */

  if( !Config.debug )
  return;

  test.case = 'missed arguments';
  test.shouldThrowErrorSync( function()
  {
    _.uriNew.parseConsecutive();
  });

  test.case = 'redundant argument';
  test.shouldThrowErrorSync( function()
  {
    _.uriNew.parseConsecutive( 'http://www.site.com:13/path/name?query=here&and=here#anchor','' );
  });

  test.case = 'argument is not string';
  test.shouldThrowErrorSync( function()
  {
    _.uriNew.parseConsecutive( 34 );
  });

