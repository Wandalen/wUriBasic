( function _Uri_s_() {

'use strict';

/**
  @module Tools/base/Uri - Collection of routines to operate URIs ( URLs ) in the reliable and consistent way. Path leverages parsing, joining, extracting, normalizing, nativizing, resolving paths. Use the module to get uniform experience from playing with paths on different platforms.

*/

/**
 * @file Uri.s.
 */

if( typeof module !== 'undefined' )
{

  if( typeof _global_ === 'undefined' || !_global_.wBase )
  {
    let toolsPath = '../../../dwtools/Base.s';
    let toolsExternal = 0;
    try
    {
      toolsPath = require.resolve( toolsPath );
    }
    catch( err )
    {
      toolsExternal = 1;
      require( 'wTools' );
    }
    if( !toolsExternal )
    require( toolsPath );
  }

  let _ = _global_.wTools;

  _.include( 'wPathFundamentals' );

}

//

let _global = _global_;
let _ = _global_.wTools;
let Parent = _.path;
let Self = _.uri = _.uri || Object.create( Parent );

// --
// internal
// --

function _filterOnlyUrl( e,k,c )
{
  if( _.strIs( k ) )
  {
    if( _.strEnds( k,'Url' ) )
    return true;
    else
    return false
  }
  return this.uriIs( e );
}

//

function _filterNoInnerArray( arr )
{
  return arr.every( ( e ) => !_.arrayIs( e ) );
}

// --
// uri
// --

/**
 *
 * The URL component object.
 * @typedef {Object} UrlComponents
 * @property {string} protocol the URL's protocol scheme.;
 * @property {string} host host portion of the URL;
 * @property {string} port property is the numeric port portion of the URL
 * @property {string} localPath the entire path section of the URL.
 * @property {string} query the entire "query string" portion of the URL, not including '?' character.
 * @property {string} hash property consists of the "fragment identifier" portion of the URL.

 * @property {string} uri the whole URL
 * @property {string} hostWithPort host portion of the URL, including the port if specified.
 * @property {string} origin protocol + host + port
 * @private
 */

let _uriComponents =
{

  /* primitive */

  protocol : null, /* 'svn+http' */
  host : null, /* 'www.site.com' */
  port : null, /* '13' */
  localPath : null, /* '/path/name' */
  query : null, /* 'query=here&and=here' */
  hash : null, /* 'anchor' */

  /* composite */

  protocols : null, /* [ 'svn','http' ] */
  hostWithPort : null, /* 'www.site.com:13' */
  origin : null, /* 'svn+http://www.site.com:13' */
  full : null, /* 'svn+http://www.site.com:13/path/name?query=here&and=here#anchor' */

}

//

/*
http://www.site.com:13/path/name?query=here&and=here#anchor
2 - protocol
3 - hostWithPort( host + port )
5 - localPath
6 - query
8 - hash
*/

function _uriParse( o )
{
  let result = Object.create( null );
  let parse = new RegExp( '^(?:([^:/\\?#]*):)?(?:\/\/(([^:/\\?#]*)(?::([^/\\?#]*))?))?([^\\?#]*)(?:\\?([^#]*))?(?:#(.*))?$' );

  if( _.mapIs( o.srcPath ) )
  {
    _.assertMapHasOnly( o.srcPath, this._uriComponents );
    if( o.srcPath.protocols )
    return o.srcPath;
    else if( o.srcPath.full )
    o.srcPath = o.srcPath.full;
    else
    o.srcPath = this.uriStr( o.srcPath );
  }

  _.assert( _.strIs( o.srcPath ) );
  _.assert( arguments.length === 1, 'expects single argument' );
  _.routineOptions( this._uriParse, o );

  let e = parse.exec( o.srcPath );
  _.assert( !!e, 'cant parse :',o.srcPath );

  if( _.strIs( e[ 1 ] ) )
  result.protocol = e[ 1 ];
  if( _.strIs( e[ 3 ] ) )
  result.host = e[ 3 ];
  if( _.strIs( e[ 4 ] ) )
  result.port = e[ 4 ];
  if( _.strIs( e[ 5 ] ) )
  result.localPath = e[ 5 ];
  if( _.strIs( e[ 6 ] ) )
  result.query = e[ 6 ];
  if( _.strIs( e[ 7 ] ) )
  result.hash = e[ 7 ];

  if( !o.primitiveOnly )
  {
    if( _.strIs( result.protocol ) )
    result.protocols = result.protocol.split( '+' );
    else
    result.protocols = [];
    if( _.strIs( e[ 2 ] ) )
    result.hostWithPort = e[ 2 ];
    if( _.strIs( result.protocol ) || _.strIs( result.hostWithPort ) )
    result.origin = ( _.strIs( result.protocol ) ? result.protocol + '://' : '//' ) + result.hostWithPort;
    result.full = this.uriStr( result );
  }

  return result;
}

_uriParse.defaults =
{
  srcPath : null,
  primitiveOnly : 0,
}

_uriParse.components = _uriComponents;

//

/**
 * Method parses URL string, and returns a UrlComponents object.
 * @example
 *
   let uri = 'http://www.site.com:13/path/name?query=here&and=here#anchor'

   wTools.uriParse( uri );

   // {
   //   protocol : 'http',
   //   hostWithPort : 'www.site.com:13',
   //   localPath : /path/name,
   //   query : 'query=here&and=here',
   //   hash : 'anchor',
   //   host : 'www.site.com',
   //   port : '13',
   //   origin : 'http://www.site.com:13'
   // }

 * @param {string} path Url to parse
 * @param {Object} o - parse parameters
 * @param {boolean} o.primitiveOnly - If this parameter set to true, the `hostWithPort` and `origin` will not be
    included into result
 * @returns {UrlComponents} Result object with parsed uri components
 * @throws {Error} If passed `path` parameter is not string
 * @method uriParse
 * @memberof wTools
 */

function uriParse( srcPath )
{

  let result = this._uriParse
  ({
    srcPath : srcPath,
    primitiveOnly : 0,
  });

  _.assert( arguments.length === 1, 'expects single argument' );

  return result;
}

uriParse.components = _uriComponents;

//

function uriParsePrimitiveOnly( srcPath )
{
  let result = this._uriParse
  ({
    srcPath : srcPath,
    primitiveOnly : 1,
  });

  _.assert( arguments.length === 1, 'expects single argument' );

  return result;
}

uriParsePrimitiveOnly.components = _uriComponents;

//

/**
 * Assembles uri string from components
 *
 * @example
 *
   let components =
     {
       protocol : 'http',
       host : 'www.site.com',
       port : '13',
       localPath : '/path/name',
       query : 'query=here&and=here',
       hash : 'anchor',
     };
   wTools.uriStr( UrlComponents );
   // 'http://www.site.com:13/path/name?query=here&and=here#anchor'
 * @param {UrlComponents} components Components for uri
 * @returns {string} Complete uri string
 * @throws {Error} If `components` is not UrlComponents map
 * @see {@link UrlComponents}
 * @method uriStr
 * @memberof wTools
 */

function uriStr( components )
{
  let result = '';

  _.assert( _.strIs( components ) || _.mapIs( components ) );
  _.assert( arguments.length === 1, 'expects single argument' );
  _.assertMapHasOnly( components, this._uriComponents );
  _.assert( components.uri === undefined );

  if( components.full )
  {
    _.assert( _.strIs( components.full ) && components.full );
    return components.full;
  }

  if( _.strIs( components ) )
  return components;

  /* */

  if( components.origin )
  {
    result += components.origin;
  }
  else
  {

    let hostWithPort;
    if( components.hostWithPort )
    {
      hostWithPort = components.hostWithPort;
    }
    else
    {
      if( components.host !== undefined )
      hostWithPort = components.host;
      if( components.port !== undefined && components.port !== null )
      if( hostWithPort )
      hostWithPort += ':' + components.port;
      else
      hostWithPort = ':' + components.port;
    }

    if( _.strIs( components.protocol ) && !hostWithPort )
    hostWithPort = '';

    if( _.strIs( components.protocol ) || _.strIs( hostWithPort ) )
    // if( _.strIs( components.protocol ) || _.strIsNotEmpty( hostWithPort ) )
    result += ( _.strIs( components.protocol ) ? components.protocol + '://' : '//' ) + hostWithPort;

  }

  /* */

  if( components.localPath )
  result += _.strPrependOnce( components.localPath, this._upStr );

  _.assert( !components.query || _.strIs( components.query ) );

  if( components.query !== undefined )
  result += '?' + components.query;

  if( components.hash !== undefined )
  result += '#' + components.hash;

  return result;
}

uriStr.components = _uriComponents;

  // define classcol : null, /* 'svn+http' */
  // host : null, /* 'www.site.com' */
  // port : null, /* '13' */
  // localPath : null, /* '/path/name' */
  // query : null, /* 'query=here&and=here' */
  // hash : null, /* 'anchor' */
  //
  //
  // define classcols : null, /* [ 'svn','http' ] */
  // hostWithPort : null, /* 'www.site.com:13' */
  // origin : null, /* 'svn+http://www.site.com:13' */
  // full : null, /* 'svn+http://www.site.com:13/path/name?query=here&and=here#anchor' */

//

/**
 * Complements current window uri origin by components passed in o.
 * All components of current origin is replaced by appropriates components from o if they exist.
 * If { o.full } exists and valid, method returns it.
 * @example
 * // current uri http://www.site.com:13/foo/baz
   let components =
   {
     localPath : '/path/name',
     query : 'query=here&and=here',
     hash : 'anchor',
   };
   let res = wTools.uriFor(o);
   // 'http://www.site.com:13/path/name?query=here&and=here#anchor'
 *
 * @param {UrlComponents} o o for resolving uri
 * @returns {string} composed uri
 * @method uriFor
 * @memberof wTools
 */

function uriFor( o )
{

  if( o.full )
  return this.uriStr( o );

  _.assertMapHasOnly( o, this._uriComponents )
  let uri = this.uriServer();
  // let o = _.mapOnly( o, this._uriComponents );

  let parsed = this.uriParsePrimitiveOnly( uri );

  _.mapExtend( parsed,o );

  return this.uriStr( parsed );
}

//

function uriRefine( fileUrl )
{

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.strIsNotEmpty( fileUrl ) );

  if( this.uriIsGlobal( fileUrl ) )
  fileUrl = this.uriParsePrimitiveOnly( fileUrl );
  else
  return this.refine( fileUrl );

  if( _.strIsNotEmpty( fileUrl.localPath ) )
  fileUrl.localPath = this.refine( fileUrl.localPath );

  return this.uriStr( fileUrl );

  // throw _.err( 'deprecated' );
  //
  // if( !src.length )
  // debugger;
  //
  // if( !src.length )
  // return '';
  //
  // let result = src.replace( /\\/g,'/' );
  //
  // return result;
}

//

let urisRefine = _.routineVectorize_functor
({
  routine : uriRefine,
  vectorizingArray : 1,
  vectorizingMap : 1,
});

let urisOnlyRefine = _.routineVectorize_functor
({
  routine : uriRefine,
  fieldFilter : _filterOnlyUrl,
  vectorizingArray : 1,
  vectorizingMap : 1,
});

//

function uriNormalize( fileUrl )
{
  if( _.strIs( fileUrl ) )
  {
    if( this.uriIsGlobal( fileUrl ) )
    fileUrl = this.uriParsePrimitiveOnly( fileUrl );
    else
    return this.normalize( fileUrl );
  }
  _.assert( !!fileUrl );
  fileUrl.localPath = this.normalize( fileUrl.localPath );
  return this.uriStr( fileUrl );
}

//

let urisNormalize = _.routineVectorize_functor
({
  routine : uriNormalize,
  vectorizingArray : 1,
  vectorizingMap : 1,
});

//

let urisOnlyNormalize = _.routineVectorize_functor
({
  routine : uriNormalize,
  fieldFilter : _._filterOnlyPath,
  vectorizingArray : 1,
  vectorizingMap : 1,
});

//

function uriNormalizeTolerant( fileUrl )
{
  if( _.strIs( fileUrl ) )
  {
    if( this.uriIsGlobal( fileUrl ) )
    fileUrl = this.uriParsePrimitiveOnly( fileUrl );
    else
    return this.normalizeTolerant( fileUrl );
  }
  _.assert( !!fileUrl );
  fileUrl.localPath = this.normalizeTolerant( fileUrl.localPath );
  return this.uriStr( fileUrl );
}

//

/**
 * Joins filesystem paths fragments or uris fragment into one path/URI. Uses '/' level delimeter.
 * @param {Object} o join o.
 * @param {String[]} p.paths - Array with paths to join.
 * @param {boolean} [o.isUri=false] If true, method returns URI which consists from joined fragments, beginning
 * from element that contains '//' characters. Else method will join elements in `paths` array as os path names.
 * @param {boolean} [o.reroot=false] If this parameter set to false (by default), method joins all elements in
 * `paths` array, starting from element that begins from '/' character, or '* :', where '*' is any drive name. If it
 * is set to true, method will join all elements in array. Result
 * @returns {string}
 * @private
 * @throws {Error} If missed arguments.
 * @throws {Error} If elements of `paths` are not strings
 * @throws {Error} If o has extra parameters.
 * @method _uriJoin_body
 * @memberof wTools
 */

function _uriJoin_body( o )
{
  let self = this;
  let result = '';
  let prepending = true;

  /* */

  debugger;
  _.assert( Object.keys( o ).length === 3 );
  _.assert( o.paths.length > 0 );
  _.assert( _.boolLike( o.reroot ) );

  /* */

  function prepend( src )
  {

    _.assert( _.strIs( src ) );

    if( o.isUri )
    src = self.uriRefine( src );
    else
    src = self.refine( src );

    if( !src )
    return prepending;

    let doPrepend = prepending;
    if( !doPrepend && o.isUri )
    {
      if( src.indexOf( '//' ) !== -1 )
      {
        let i = src.indexOf( '//' );
        i = src.indexOf( '/', i+2 );
        if( i >= 0 )
        {
          src = src.substr( 0,i );
        }
        doPrepend = 1;
      }
    }

    if( doPrepend )
    {

      if( !o.isUri )
      src = src.replace( /\\/g,'/' );

      if( result && src[ src.length-1 ] === '/' && !_.strEnds( src, '//' ) )
      if( src.length > 1 || result[ 0 ] === '/' )
      src = src.substr( 0,src.length-1 );

      if( src && src[ src.length-1 ] !== '/' && result && result[ 0 ] !== '/' )
      result = '/' + result;

      result = src + result;

    }

    if( o.isUri )
    {
      if( src.indexOf( '//' ) !== -1 )
      {
        return false;
      }
    }

    if( !o.reroot )
    {
      if( src[ 0 ] === '/' )
      return false;
      // if( src[ 1 ] === ':' )
      // console.warn( 'WARNING : Path could be native for windows, but should not',src );
      // if( src[ 1 ] === ':' )
      // debugger;
      // if( src[ 1 ] === ':' )
      // if( src[ 2 ] !== '/' || src[ 3 ] !== '/' )
      // return false;
    }

    return prepending;
  }

  /* */

  for( let a = o.paths.length-1 ; a >= 0 ; a-- )
  {
    let src = o.paths[ a ];

    if( !_.strIs( src ) )
    _.assert( 0,'join :','expects strings as path arguments, but #' + a + ' argument is ' + _.strTypeOf( src ) );

    prepending = prepend( src );
    if( prepending === false && !o.isUri )
    break;

  }

  /* */

  if( result === '' )
  return '.';

  return result;
}

_uriJoin_body.defaults =
{
  paths : null,
  reroot : 0,
  isUri : 0,
}

//

function uriJoin()
{
  let result = Object.create( null );
  let srcs = [];

  let parsed = false;

  for( let s = 0 ; s < arguments.length ; s++ )
  {
    if( this.uriIsGlobal( arguments[ s ] ) )
    {
      parsed = true;
      srcs[ s ] = this.uriParsePrimitiveOnly( arguments[ s ] );
    }
    else
    {
      srcs[ s ] = { localPath : arguments[ s ] };
    }
  }

  for( let s = srcs.length-1 ; s >= 0 ; s-- )
  {
    let src = srcs[ s ];

    if( result.protocol && src.protocol )
    if( result.protocol !== src.protocol )
    continue;

    if( !result.protocol && src.protocol !== undefined )
    result.protocol = src.protocol;

    let hostWas = result.host;
    if( !result.host && src.host !== undefined )
    // if( !result.port || !src.port || result.port === src.port )
    result.host = src.host;

    if( !result.port && src.port !== undefined )
    if( !hostWas || !src.host || hostWas === src.host )
    result.port = src.port;

    if( !result.localPath && src.localPath !== undefined )
    result.localPath = src.localPath;
    else if( src.localPath )
    result.localPath = this.join( src.localPath,result.localPath );

    if( src.query !== undefined )
    if( !result.query )
    result.query = src.query;
    else
    result.query += '&' + src.query;

    if( !result.hash && src.hash !==undefined )
    result.hash = src.hash;

  }

  if( !parsed )
  return result.localPath;

  return this.uriStr( result );
}

//

let urisJoin = _.path._pathMultiplicator_functor
({
  routine : uriJoin
});

//

function uriResolve()
{
  let result = Object.create( null );
  let srcs = [];
  let parsed = false;

  for( let s = 0 ; s < arguments.length ; s++ )
  {
    if( this.uriIsGlobal( arguments[ s ] ) )
    {
      parsed = true;
      srcs[ s ] = this.uriParsePrimitiveOnly( arguments[ s ] );
    }
    else
    {
      srcs[ s ] = { localPath : arguments[ s ] };
    }
  }

  for( let s = 0 ; s < srcs.length ; s++ )
  {
    let src = srcs[ s ];

    if( !result.protocol && src.protocol !== undefined )
    result.protocol = src.protocol;

    if( !result.host && src.host !== undefined )
    result.host = src.host;

    if( !result.port && src.port !== undefined )
    result.port = src.port;

    if( !result.localPath && src.localPath !== undefined )
    {
      if( !_.strIsNotEmpty( src.localPath ) )
      src.localPath = this._rootStr;

      result.localPath = src.localPath;
    }
    else
    {
      result.localPath = this.resolve( result.localPath, src.localPath );
    }

    if( src.query !== undefined )
    if( !result.query )
    result.query = src.query;
    else
    result.query += '&' + src.query;

    if( !result.hash && src.hash !==undefined )
    result.hash = src.hash;

  }

  if( !parsed )
  return result.localPath;

  return this.uriStr( result );
}

//

function uriRelative( o )
{

  if( arguments[ 1 ] !== undefined )
  {
    o = { relative : arguments[ 0 ], path : arguments[ 1 ] }
  }

  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.routineOptions( this._pathRelative, o );

  if( !this.uriIsGlobal( o.relative ) && !this.uriIsGlobal( o.path ) )
  return this._pathRelative( o );

  let relative = this.uriParsePrimitiveOnly( o.relative );
  let path = this.uriParsePrimitiveOnly( o.path );

  let optionsForPath = _.mapExtend( null,o );
  optionsForPath.relative = relative.localPath;
  optionsForPath.path = path.localPath;

  relative.localPath = this._pathRelative( optionsForPath );

  return this.uriStr( relative );
}

uriRelative.defaults = Object.create( _.path._pathRelative.defaults );

//

function uriCommon( uris )
{
  let self = this;

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.longIs( uris ) );

  let _uris = uris.slice();

  _uris.sort( function( a, b )
  {
    return b.length - a.length;
  });

  let onlyLocals = true;

  let result = parse( _uris.pop() );

  for( let i = 0, len = _uris.length; i < len; i++ )
  {
    let currentUrl = parse( _uris[ i ] );

    if( result.protocol !== currentUrl.protocol || result.port !== currentUrl.port || result.host !== currentUrl.host )
    {
      result = '';
      return result;
    }

    result.localPath = this._pathCommon( currentUrl.localPath, result.localPath );
  }

  if( onlyLocals )
  return result.localPath;

  return this.uriStr( result );

  /* */

  function parse( uri )
  {
    let result;

    if( self.uriIsGlobal( uri ) )
    {
      result = self.uriParsePrimitiveOnly( uri );
      onlyLocals = false;
    }
    else
    {
      result = { localPath : uri };
    }

    return result;
  }

}

//

function uriRebase( srcPath, oldPath, newPath )
{
  _.assert( arguments.length === 3, 'expects exactly three argument' );

  srcPath = this.uriParsePrimitiveOnly( srcPath );
  oldPath = this.uriParsePrimitiveOnly( oldPath );
  newPath = this.uriParsePrimitiveOnly( newPath );

  let dstPath = _.mapExtend( null,srcPath,newPath );

  if( srcPath.protocol !== undefined && oldPath.protocol !== undefined )
  {
    if( srcPath.protocol === oldPath.protocol && newPath.protocol === undefined )
    delete dstPath.protocol;
  }

  if( srcPath.host !== undefined && oldPath.host !== undefined )
  {
    if( srcPath.host === oldPath.host && newPath.host === undefined )
    delete dstPath.host;
  }

  dstPath.localPath = this.rebase( srcPath.localPath, oldPath.localPath, newPath.localPath );

  return this.uriStr( dstPath );
}

//

function uriName( o )
{
  if( _.strIs( o ) )
  o = { path : o }

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.strIsNotEmpty( o.path ) );
  _.routineOptions( uriName, o );

  if( !this.uriIsGlobal( o.path ) )
  return this.name( o );

  let path = this.uriParse( o.path );

  let optionsForName = _.mapExtend( null,o );
  optionsForName.path = path.localPath;
  return this.name( optionsForName );
}

uriName.defaults = Object.create( _.path.name.defaults );

//

function uriExt( path )
{
  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.strIsNotEmpty( path ) );

  if( this.uriIsGlobal( path ) )
  path = this.uriParse( path ).localPath;

  return this.ext( path );
}

//

function uriExts( path )
{
  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.strIsNotEmpty( path ) );

  if( this.uriIsGlobal( path ) )
  path = this.uriParse( path ).localPath;

  return this.exts( path );
}

//

function uriChangeExt( path, ext )
{
  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( _.strIsNotEmpty( path ) );
  _.assert( _.strIs( ext ) );

  if( !this.uriIsGlobal( path ) )
  return this.changeExt( path, ext );

  path = this.uriParse( path );
  path.localPath = this.changeExt( path.localPath, ext );

  path.full = null;
  path.origin = null;

  return this.uriStr( path );
}

//

function uriDir( path )
{
  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.strIsNotEmpty( path ) );

  if( !this.uriIsGlobal( path ) )
  return this.dir( path );

  path = this.uriParse( path );
  path.localPath = this.dir( path.localPath );

  path.full = null;
  path.origin = null;

  return this.uriStr( path );
}

//

/**
 * Returns origin plus path without query part of uri string.
 * @example
 *
   let path = 'https://www.site.com:13/path/name?query=here&and=here#anchor';
   wTools.uriDocument( path, { withoutProtocol : 1 } );
   // 'www.site.com:13/path/name'
 * @param {string} path uri string
 * @param {Object} [o] uriDocument o
 * @param {boolean} o.withoutServer if true rejects origin part from result
 * @param {boolean} o.withoutProtocol if true rejects protocol part from result uri
 * @returns {string} Return document uri.
 * @method uriDocument
 * @memberof wTools
 */

function uriDocument( path, o )
{
  o = o || Object.create( null );

  if( path === undefined )
  path = _realGlobal_.location.href;

  if( path.indexOf( '//' ) === -1 )
  {
    path = 'http:/' + ( path[ 0 ] === '/' ? '' : '/' ) + path;
  }

  let a = path.split( '//' );
  let b = a[ 1 ].split( '?' );

  /* */

  if( o.withoutServer )
  {
    let i = b[ 0 ].indexOf( '/' );
    if( i === -1 ) i = 0;
    return b[ 0 ].substr( i );
  }
  else
  {
    if( o.withoutProtocol ) return b[0];
    else return a[ 0 ] + '//' + b[ 0 ];
  }

}

uriDocument.defaults =
{
  path : null,
  withoutServer : null,
  withoutProtocol : null,
}

//

/**
 * Return origin (protocol + host + port) part of passed `path` string. If missed arguments, returns origin of
 * current document.
 * @example
 *
   let path = 'http://www.site.com:13/path/name?query=here'
   wTools.uriServer( path );
   // 'http://www.site.com:13/'
 * @param {string} [path] uri
 * @returns {string} Origin part of uri.
 * @method uriServer
 * @memberof wTools
 */

function uriServer( path )
{
  let a,b;

  if( path === undefined )
  path = _realGlobal_.location.origin;

  if( path.indexOf( '//' ) === -1 )
  {
    if( path[ 0 ] === '/' ) return '/';
    a = [ '',path ]
  }
  else
  {
    a = path.split( '//' );
    a[ 0 ] += '//';
  }

  b = a[ 1 ].split( '/' );

  return a[ 0 ] + b[ 0 ] + '/';
}

//

/**
 * Returns query part of uri. If method is called without arguments, it returns current query of current document uri.
 * @example
   let uri = 'http://www.site.com:13/path/name?query=here&and=here#anchor',
   wTools.uriQuery( uri ); // 'query=here&and=here#anchor'
 * @param {string } [path] uri
 * @returns {string}
 * @method uriQuery
 * @memberof wTools
 */

function uriQuery( path )
{

  if( path === undefined )
  path = _realGlobal_.location.href;

  if( path.indexOf( '?' ) === -1 ) return '';
  return path.split( '?' )[ 1 ];
}

//

/**
 * Parse a query string passed as a 'query' argument. Result is returned as a dictionary.
 * The dictionary keys are the unique query variable names and the values are decoded from uri query variable values.
 * @example
 *
   let query = 'k1=&k2=v2%20v3&k3=v4_v4';

   let res = wTools.uriDequery( query );
   // {
   //   k1 : '',
   //   k2 : 'v2 v3',
   //   k3 : 'v4_v4'
   // },

 * @param {string} query query string
 * @returns {Object}
 * @method uriDequery
 * @memberof wTools
 */

function uriDequery( query )
{

  let result = Object.create( null );
  query = query || _global.location.search.split('?')[1];
  if( !query || !query.length )
  return result;
  let vars = query.split( '&' );

  for( let i = 0 ; i < vars.length ; i++ )
  {

    let w = vars[ i ].split( '=' );
    w[ 0 ] = decodeURIComponent( w[ 0 ] );
    if( w[ 1 ] === undefined ) w[ 1 ] = '';
    else w[ 1 ] = decodeURIComponent( w[ 1 ] );

    if( (w[ 1 ][ 0 ] == w[ 1 ][ w[ 1 ].length-1 ] ) && ( w[ 1 ][ 0 ] == '"') )
    w[ 1 ] = w[ 1 ].substr( 1,w[ 1 ].length-1 );

    if( result[ w[ 0 ] ] === undefined )
    {
      result[ w[ 0 ] ] = w[ 1 ];
    }
    else if( _.strIs( result[ w[ 0 ] ] ) )
    {
      result[ w[ 0 ] ] = result[ result[ w[ 0 ] ], w[ 1 ] ]
    }
    else
    {
      result[ w[ 0 ] ].push( w[ 1 ] );
    }

  }

  return result;
}

// --
// uri tester
// --

  // '^(https?:\\/\\/)?'                                     // define classcol
  // + '(\\/)?'                                              // relative
  // + '((([a-z\\d]([a-z\\d-]*[a-z\\d])*)\\.)+[a-z]{2,}|'    // domain
  // + '((\\d{1,3}\\.){3}\\d{1,3}))'                         // ip
  // + '(\\:\\d+)?'                                          // port
  // + '(\\/[-a-z\\d%_.~+]*)*'                               // path
  // + '(\\?[;&a-z\\d%_.~+=-]*)?'                            // query
  // + '(\\#[-a-z\\d_]*)?$';                                 // anchor

let uriIsRegExpString =
  '^([\w\d]*:\\/\\/)?'                                    // define classcol
  + '(\\/)?'                                              // relative
  + '((([a-z\\d]([a-z\\d-]*[a-z\\d])*)\\.)+[a-z]{2,}|'    // domain
  + '((\\d{1,3}\\.){3}\\d{1,3}))'                         // ip
  + '(\\:\\d+)?'                                          // port
  + '(\\/[-a-z\\d%_.~+]*)*'                               // path
  + '(\\?[;&a-z\\d%_.~+=-]*)?'                            // query
  + '(\\#[-a-z\\d_]*)?$';                                 // anchor

let uriIsRegExp = new RegExp( uriIsRegExpString,'i' );
function uriIs( uri )
{
  _.assert( arguments.length === 1, 'expects single argument' );
  return _.strIs( path );
}

//

function uriIsGlobal( fileUrl )
{
  _.assert( _.strIs( fileUrl ) );
  return _.strHas( fileUrl,'://' );
}

//

function uriIsSafe( path )
{
  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.strIsNotEmpty( path ) );

  if( this.uriIsGlobal( path ) )
  path = this.uriParse( path ).localPath;

  return this.isSafe( path );
}

//

function uriIsNormalized( path )
{
  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.strIs( path ) );
  return this.uriNormalize( path ) === path;
}

//

function uriIsAbsolute( path )
{
  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.strIsNotEmpty( path ) );

  if( this.uriIsGlobal( path ) )
  path = this.uriParse( path ).localPath;

  return this.isAbsolute( path );
}

// --
// declare Fields
// --

let Fields =
{

  _uriComponents : _uriComponents,

}

// --
// declare routines
// --

let Routines =
{

  // internal

  _filterOnlyUrl : _filterOnlyUrl,
  _filterNoInnerArray : _filterNoInnerArray,

  // uri

  _uriParse : _uriParse,
  uriParse : uriParse,
  uriParsePrimitiveOnly : uriParsePrimitiveOnly,

  uriStr : uriStr,
  uriFor : uriFor,

  uriRefine : uriRefine,
  urisRefine : urisRefine,
  urisOnlyRefine : urisOnlyRefine,

  uriNormalize : uriNormalize,
  urisNormalize : urisNormalize,
  urisOnlyNormalize : urisOnlyNormalize,

  uriNormalizeTolerant : uriNormalizeTolerant,

  _uriJoin_body : _uriJoin_body,
  uriJoin : uriJoin,
  urisJoin : urisJoin,

  uriResolve : uriResolve,
  uriRelative : uriRelative,
  uriCommon : uriCommon,
  uriRebase : uriRebase,

  uriName : uriName,
  uriExt : uriExt,
  uriExts : uriExts,
  uriChangeExt : uriChangeExt,
  uriDir : uriDir,

  uriDocument : uriDocument,
  uriServer : uriServer,
  uriQuery : uriQuery,
  uriDequery : uriDequery,

  // uri tester

  uriIs : uriIs,
  uriIsGlobal : uriIsGlobal,
  uriIsSafe : uriIsSafe,
  uriIsNormalized : uriIsNormalized,
  uriIsAbsolute : uriIsAbsolute,

}

_.mapSupplement( Self, Fields );
_.mapSupplement( Self, Routines );

// --
// export
// --

if( typeof module !== 'undefined' )
if( _global_.WTOOLS_PRIVATE )
delete require.cache[ module.id ];

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;

})();
