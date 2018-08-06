( function _Path_s_() {

'use strict'; /*aaa*/

/**
  @module Tools/base/Path - Collection of routines to operate paths, URLs, URIs in the reliable and consistent way. Path leverages parsing, joining, extracting, normalizing, nativizing, resolving paths. Use the module to get uniform experience from playing with paths on different platforms.
*/

/**
 * @file Path.s.
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

}

//

let _global = _global_;
let _ = _global_.wTools;
let Self = _.path = _.path || Object.create( null );

// --
// internal
// --

/*
qqq : use routineVectorize_functor instead
*/

function _pathMultiplicator_functor( o )
{

  if( _.routineIs( o ) || _.strIs( o ) )
  o = { routine : o }

  _.routineOptions( _pathMultiplicator_functor,o );
  _.assert( _.routineIs( o.routine ) );
  _.assert( o.fieldNames === null || _.longIs( o.fieldNames ) )

  /* */

  let routine = o.routine;
  let fieldNames = o.fieldNames;

  function supplement( src, l )
  {
    if( !_.longIs( src ) )
    src = _.arrayFillTimes( [], l, src );
    _.assert( src.length === l, 'routine expects arrays with same length' );
    return src;
  }

  function inputMultiplicator( o )
  {
    let result = [];
    let l = 0;
    let onlyScalars = true;

    if( arguments.length > 1 )
    {
      let args = [].slice.call( arguments );

      for( let i = 0; i < args.length; i++ )
      {
        if( onlyScalars && _.longIs( args[ i ] ) )
        onlyScalars = false;

        l = Math.max( l, _.arrayAs( args[ i ] ).length );
      }

      for( let i = 0; i < args.length; i++ )
      args[ i ] = supplement( args[ i ], l );

      for( let i = 0; i < l; i++ )
      {
        let argsForCall = [];

        for( let j = 0; j < args.length; j++ )
        argsForCall.push( args[ j ][ i ] );

        let r = routine.apply( this, argsForCall );
        result.push( r )
      }
    }
    else
    {
      if( fieldNames === null || !_.objectIs( o ) )
      return routine.apply( this, arguments );

      let fields = [];

      for( let i = 0; i < fieldNames.length; i++ )
      {
        let field = o[ fieldNames[ i ] ];

        if( onlyScalars && _.longIs( field ) )
        onlyScalars = false;

        l = Math.max( l, _.arrayAs( field ).length );
        fields.push( field );
      }

      for( let i = 0; i < fields.length; i++ )
      fields[ i ] = supplement( fields[ i ], l );

      for( let i = 0; i < l; i++ )
      {
        let options = _.mapExtend( null, o );
        for( let j = 0; j < fieldNames.length; j++ )
        {
          let fieldName = fieldNames[ j ];
          options[ fieldName ] = fields[ j ][ i ];
        }

        result.push( routine.call( this, options ) );
      }
    }

    _.assert( result.length === l );

    if( onlyScalars )
    return result[ 0 ];

    return result;
  }

  return inputMultiplicator;
}

_pathMultiplicator_functor.defaults =
{
  routine : null,
  fieldNames : null
}

//

function _filterNoInnerArray( arr )
{
  return arr.every( ( e ) => !_.arrayIs( e ) );
}

//

function _filterOnlyPath( e,k,c )
{
  if( _.strIs( k ) )
  {
    if( _.strEnds( k,'Path' ) )
    return true;
    else
    return false
  }
  return this.pathIs( e );
}

// --
// normalizer
// --

function pathRefine( src )
{

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.strIs( src ) );

  if( !src.length )
  return this._hereStr;

  let result = src;

  if( result[ 1 ] === ':' && ( result[ 2 ] === '\\' || result[ 2 ] === '/' || result.length === 2 ) )
  result = '/' + result[ 0 ] + '/' + result.substring( 3 );

  result = result.replace( /\\/g,'/' );

  /* remove right "/" */

  if( result !== this._upStr && !_.strEnds( result, this._upStr + this._upStr ))
  result = _.strRemoveEnd( result,this._upStr );

  // if( result !== this._upStr )
  // result = result.replace( this._delUpRegexp, '' );

  return result;
}

//

let pathsRefine = _.routineVectorize_functor
({
  routine : pathRefine,
  vectorizingArray : 1,
  vectorizingMap : 1,
});

let pathsOnlyRefine = _.routineVectorize_functor
({
  routine : pathRefine,
  fieldFilter : _filterOnlyPath,
  vectorizingArray : 1,
  vectorizingMap : 1,
});

//

function _pathNormalize( o )
{
  if( !o.src.length )
  return '.';

  let result = o.src;
  let endsWithUpStr = o.src === this._upStr || _.strEnds( o.src,this._upStr );
  result = this.pathRefine( o.src );
  let beginsWithHere = o.src === this._hereStr || _.strBegins( o.src,this._hereUpStr );

  /* remove "." */

  if( result.indexOf( this._hereStr ) !== -1 )
  {
    while( this._delHereRegexp.test( result ) )
    result = result.replace( this._delHereRegexp,this._upStr );
  }

  if( _.strBegins( result,this._hereUpStr ) && !_.strBegins( result, this._hereUpStr + this._upStr ) )
  result = _.strRemoveBegin( result,this._hereUpStr );

  /* remove ".." */

  if( result.indexOf( this._downStr ) !== -1 )
  {
    while( this._delDownRegexp.test( result ) )
    result = result.replace( this._delDownRegexp,this._upStr );
  }

  /* remove first ".." */

  if( result.indexOf( this._downStr ) !== -1 )
  {
    while( this._delDownFirstRegexp.test( result ) )
    result = result.replace( this._delDownFirstRegexp,'' );
  }

  if( !o.tolerant )
  {
    /* remove right "/" */

    if( result !== this._upStr && !_.strEnds( result, this._upStr + this._upStr ) )
    result = _.strRemoveEnd( result,this._upStr );
  }
  else
  {
    /* remove "/" duplicates */

    result = result.replace( this._delUpDupRegexp, this._upStr );

    if( endsWithUpStr )
    result = _.strAppendOnce( result, this._upStr );
  }

  /* nothing left */

  if( !result.length )
  result = '.';

  /* get back left "." */

  if( beginsWithHere )
  result = this.pathDot( result );

  return result;
}

//

/**
 * Regularize a path by collapsing redundant delimeters and resolving '..' and '.' segments, so A//B, A/./B and
    A/foo/../B all become A/B. This string manipulation may change the meaning of a path that contains symbolic links.
    On Windows, it converts forward slashes to backward slashes. If the path is an empty string, method returns '.'
    representing the current working directory.
 * @example
   let path = '/foo/bar//baz1/baz2//some/..'
   path = wTools.pathNormalize( path ); // /foo/bar/baz1/baz2
 * @param {string} src path for normalization
 * @returns {string}
 * @method pathNormalize
 * @memberof wTools
 */

function pathNormalize( src )
{
  _.assert( _.strIs( src ),'expects string' );

  let result = this._pathNormalize({ src : src, tolerant : false });

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( result.length > 0 );
  _.assert( result === this._upStr || _.strEnds( result,this._upStr + this._upStr ) ||  !_.strEnds( result,this._upStr ) );
  _.assert( result.lastIndexOf( this._upStr + this._hereStr + this._upStr ) === -1 );
  _.assert( !_.strEnds( result,this._upStr + this._hereStr ) );

  if( Config.debug )
  {
    let i = result.lastIndexOf( this._upStr + this._downStr + this._upStr );
    _.assert( i === -1 || !/\w/.test( result.substring( 0,i ) ) );
  }

  return result;
}

//

let pathsNormalize = _.routineVectorize_functor
({
  routine : pathNormalize,
  vectorizingArray : 1,
  vectorizingMap : 1,
});

let pathsOnlyNormalize = _.routineVectorize_functor
({
  routine : pathNormalize,
  fieldFilter : _filterOnlyPath,
  vectorizingArray : 1,
  vectorizingMap : 1,
});

//

function pathNormalizeTolerant( src )
{
  _.assert( _.strIs( src ),'expects string' );

  let result = this._pathNormalize({ src : src, tolerant : true });

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( result.length > 0 );
  _.assert( result === this._upStr || _.strEnds( result,this._upStr ) || !_.strEnds( result,this._upStr + this._upStr ) );
  _.assert( result.lastIndexOf( this._upStr + this._hereStr + this._upStr ) === -1 );
  _.assert( !_.strEnds( result,this._upStr + this._hereStr ) );

  if( Config.debug )
  {
    _.assert( !this._delUpDupRegexp.test( result ) );
  }

  return result;
}

//

function pathDot( path )
{

  if( path !== this._hereStr && !_.strBegins( path,this._hereUpStr ) && path !== this._downStr && !_.strBegins( path,this._downUpStr ) )
  {
    _.assert( !_.strBegins( path,this._upStr ) );
    path = this._hereUpStr + path;
  }

  return path;
}

//

let pathsDot = _.routineVectorize_functor
({
  routine : pathDot,
  vectorizingArray : 1,
  vectorizingMap : 1,
})

let pathsOnlyDot = _.routineVectorize_functor
({
  routine : pathDot,
  fieldFilter : _filterOnlyPath,
  vectorizingArray : 1,
  vectorizingMap : 1,
})

//

function pathUndot( path )
{
  return _.strRemoveBegin( path, this._hereUpStr );
}

let pathsUndot = _.routineVectorize_functor
({
  routine : pathUndot,
  vectorizingArray : 1,
  vectorizingMap : 1,
})

let pathsOnlyUndot = _.routineVectorize_functor
({
  routine : pathUndot,
  fieldFilter : _filterOnlyPath,
  vectorizingArray : 1,
  vectorizingMap : 1,
})

//

function _pathNativizeWindows( filePath )
{
  let self = this;
  _.assert( _.strIs( filePath ) ) ;
  let result = filePath.replace( /\//g,'\\' );

  if( result[ 0 ] === '\\' )
  if( result.length === 2 || result[ 2 ] === ':' || result[ 2 ] === '\\' )
  result = result[ 1 ] + ':' + result.substring( 2 );

  return result;
}

//

function _pathNativizeUnix( filePath )
{
  let self = this;
  _.assert( _.strIs( filePath ) );
  return filePath;
}

//

let pathNativize;
if( _global.process && _global.process.platform === 'win32' )
pathNativize = _pathNativizeWindows;
else
pathNativize = _pathNativizeUnix;

// --
// path join
// --

/**
 * Joins filesystem paths fragments or urls fragment into one path/url. Uses '/' level delimeter.
 * @param {Object} o join o.
 * @param {String[]} p.paths - Array with paths to join.
 * @param {boolean} [o.reroot=false] If this parameter set to false (by default), method joins all elements in
 * `paths` array, starting from element that begins from '/' character, or '* :', where '*' is any drive name. If it
 * is set to true, method will join all elements in array. Result
 * @returns {string}
 * @private
 * @throws {Error} If missed arguments.
 * @throws {Error} If elements of `paths` are not strings
 * @throws {Error} If o has extra parameters.
 * @method _pathJoin_body
 * @memberof wTools
 */

function _pathJoin_body( o )
{
  let self = this;
  let result = '';
  let prepending = true;

  /* */

  _.assert( Object.keys( o ).length === 2 );
  _.assert( o.paths.length > 0 );
  _.assert( _.boolLike( o.reroot ) );

  /* */

  function prepend( src )
  {

    _.assert( _.strIs( src ) );

    src = self.pathRefine( src );

    if( !src )
    return prepending;

    let doPrepend = prepending;

    if( doPrepend )
    {

      src = src.replace( /\\/g,'/' );

      if( result && src[ src.length-1 ] === '/' && !_.strEnds( src, '//' ) )
      if( src.length > 1 || result[ 0 ] === '/' )
      src = src.substr( 0,src.length-1 );

      if( src && src[ src.length-1 ] !== '/' && result && result[ 0 ] !== '/' )
      result = '/' + result;

      result = src + result;

    }

    if( !o.reroot )
    {
      if( src[ 0 ] === '/' )
      return false;
    }

    return prepending;
  }

  /* */

  for( let a = o.paths.length-1 ; a >= 0 ; a-- )
  {
    let src = o.paths[ a ];

    if( !_.strIs( src ) )
    _.assert( 0,'pathJoin :','expects strings as path arguments, but #' + a + ' argument is ' + _.strTypeOf( src ) );

    prepending = prepend( src );
    if( prepending === false /*&& !o.isUri*/ )
    break;

  }

  /* */

  if( result === '' )
  return '.';

  return result;
}

_pathJoin_body.defaults =
{
  paths : null,
  reroot : 0,
}

//

function _pathsJoin_body( o )
{
  let isArray = false;
  let length = 0;

  /* */

  for( let p = 0 ; p < o.paths.length ; p++ )
  {
    let path = o.paths[ p ];
    if( _.arrayIs( path ) )
    {
      _.assert( _filterNoInnerArray( path ), 'Array must not have inner array( s ).' )

      if( isArray )
      _.assert( path.length === length, 'Arrays must have same length.' );
      else
      {
        length = Math.max( path.length,length );
        isArray = true;
      }
    }
    else
    {
      length = Math.max( 1,length );
    }
  }

  if( isArray === false )
  return this._pathJoin_body( o );

  /* */

  let paths = o.paths;
  function argsFor( i )
  {
    let res = [];
    for( let p = 0 ; p < paths.length ; p++ )
    {
      let path = paths[ p ];
      if( _.arrayIs( path ) )
      res[ p ] = path[ i ];
      else
      res[ p ] = path;
    }
    return res;
  }

  /* */

  let result = new Array( length );
  for( let i = 0 ; i < length ; i++ )
  {
    o.paths = argsFor( i );
    result[ i ] = this._pathJoin_body( o );
  }

  return result;
}

//

/**
 * Method joins all `paths` together, beginning from string that starts with '/', and normalize the resulting path.
 * @example
 * let res = wTools.pathJoin( '/foo', 'bar', 'baz', '.');
 * // '/foo/bar/baz'
 * @param {...string} paths path strings
 * @returns {string} Result path is the concatenation of all `paths` with '/' directory delimeter.
 * @throws {Error} If one of passed arguments is not string
 * @method pathJoin
 * @memberof wTools
 */

function pathJoin()
{

  let result = this._pathJoin_body
  ({
    paths : arguments,
    reroot : 0,
    // isUri : 0,
  });

  return result;
}

//

let pathsJoin = _pathMultiplicator_functor
({
  routine : pathJoin
});

//

/**
 * Method joins all `paths` strings together.
 * @example
 * let res = wTools.pathReroot( '/foo', '/bar/', 'baz', '.');
 * // '/foo/bar/baz/.'
 * @param {...string} paths path strings
 * @returns {string} Result path is the concatenation of all `paths` with '/' directory delimeter.
 * @throws {Error} If one of passed arguments is not string
 * @method pathReroot
 * @memberof wTools
 */

function pathReroot()
{
  let result = this._pathJoin_body
  ({
    paths : arguments,
    reroot : 1,
    // isUri : 0,
  });
  return result;
}

//

function pathsReroot()
{
  let result = this._pathsJoin_body
  ({
    paths : arguments,
    reroot : 1,
    // isUri : 0,
  });

  return result;
}

//

function pathsOnlyReroot()
{
  let result = arguments[ 0 ];
  let length = 0;
  let firstArr = true;

  for( let i = 1; i <= arguments.length - 1; i++ )
  {
    if( this.pathIs( arguments[ i ] ) )
    result = this.pathReroot( result, arguments[ i ] );

    if( _.arrayIs( arguments[ i ]  ) )
    {
      let arr = arguments[ i ];

      if( !firstArr )
      _.assert( length === arr.length );

      for( let j = 0; j < arr.length; j++ )
      {
        if( _.arrayIs( arr[ j ] ) )
        throw _.err( 'Inner arrays are not allowed.' );

        if( this.pathIs( arr[ j ] ) )
        result = this.pathReroot( result, arr[ j ] );
      }

      length = arr.length;
      firstArr = false;
    }
  }

  return result;
}

//

/**
 * Method resolves a sequence of paths or path segments into an absolute path.
 * The given sequence of paths is processed from right to left, with each subsequent path prepended until an absolute
 * path is constructed. If after processing all given path segments an absolute path has not yet been generated,
 * the current working directory is used.
 * @example
 * let absPath = wTools.pathResolve('work/wFiles'); // '/home/user/work/wFiles';
 * @param [...string] paths A sequence of paths or path segments
 * @returns {string}
 * @method pathResolve
 * @memberof wTools
 */

function pathResolve()
{
  let path;

  _.assert( arguments.length > 0 );

  path = this.pathJoin.apply( this, arguments );

  if( path[ 0 ] !== this._upStr )
  path = this.pathJoin( this.pathCurrent(),path );

  path = this.pathNormalize( path );

  _.assert( path.length > 0 );

  return path;
}

//

function _pathsResolveAct( join,paths )
{
  let paths;

  _.assert( paths.length > 0 );

  paths = join.apply( this, paths );
  paths = _.arrayAs( paths );

  for( let i = 0; i < paths.length; i++ )
  {
    if( paths[ i ][ 0 ] !== this._upStr )
    paths[ i ] = this.pathJoin( this.pathCurrent(),paths[ i ] );
  }

  paths = this.pathsNormalize( paths );

  _.assert( paths.length > 0 );

  return paths;
}

//

let pathsResolve = _pathMultiplicator_functor
({
  routine : pathResolve
});

//

function pathsOnlyResolve()
{
  debugger;
  throw _.err( 'not tested' );
  let result = this._pathsResolveAct( pathsOnlyJoin, arguments );
  return result;
}

// --
// path cut off
// --

/**
 * Returns the directory name of `path`.
 * @example
 * let path = '/foo/bar/baz/text.txt'
 * wTools.pathDir( path ); // '/foo/bar/baz'
 * @param {string} path path string
 * @returns {string}
 * @throws {Error} If argument is not string
 * @method pathDir
 * @memberof wTools
 */

function pathDir( path )
{

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.strIsNotEmpty( path ) , 'pathDir','expects not empty string ( path )' );

  // if( path.length > 1 )
  // if( path[ path.length-1 ] === '/' && path[ path.length-2 ] !== '/' )
  // path = path.substr( 0,path.length-1 )

  path = this.pathRefine( path );

  if( path === this._rootStr )
  {
    return path + this._downStr;
  }

  if( _.strEnds( path,this._upStr + this._downStr ) || path === this._downStr )
  {
    return path + this._upStr + this._downStr;
  }

  let i = path.lastIndexOf( this._upStr );

  if( i === -1 )
  {

    if( path === this._hereStr )
    return this._downStr;
    else
    return this._hereStr;

  }

  if( path[ i - 1 ] === '/' )
  return path;

  let result = path.substr( 0,i );

  // _.assert( result.length > 0 );

  if( result === '' )
  result = this._rootStr;

  return result;
}

//

function _pathSplit( path )
{
  return path.split( this._upStr );
}

//

function pathSplit( path )
{
  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.strIs( path ) )
  let result = this._pathSplit( this.pathRefine( path ) );
  return result;
}

//

let pathsDir = _.routineVectorize_functor
({
  routine : pathDir,
  vectorizingArray : 1,
  vectorizingMap : 1,
})

//

let pathsOnlyDir = _.routineVectorize_functor
({
  routine : pathDir,
  fieldFilter : _filterOnlyPath,
  vectorizingArray : 1,
  vectorizingMap : 1,
})

//

/**
 * Returns dirname + filename without extension
 * @example
 * _.path.pathPrefixGet( '/foo/bar/baz.ext' ); // '/foo/bar/baz'
 * @param {string} path Path string
 * @returns {string}
 * @throws {Error} If passed argument is not string.
 * @method pathPrefixGet
 * @memberof wTools
 */

function pathPrefixGet( path )
{

  if( !_.strIs( path ) )
  throw _.err( 'pathPrefixGet :','expects strings as path' );

  let n = path.lastIndexOf( '/' );
  if( n === -1 ) n = 0;

  let parts = [ path.substr( 0,n ),path.substr( n ) ];

  n = parts[ 1 ].indexOf( '.' );
  if( n === -1 )
  n = parts[ 1 ].length;

  let result = parts[ 0 ] + parts[ 1 ].substr( 0, n );

  return result;
}

//

let pathsPrefixesGet = _.routineVectorize_functor
({
  routine : pathPrefixGet,
  vectorizingArray : 1,
  vectorizingMap : 1,
})

let pathsOnlyPrefixesGet = _.routineVectorize_functor
({
  routine : pathPrefixGet,
  fieldFilter : _filterOnlyPath,
  vectorizingArray : 1,
  vectorizingMap : 1,
})

//

/**
 * Returns path name (file name).
 * @example
 * wTools.pathName( '/foo/bar/baz.asdf' ); // 'baz'
 * @param {string|object} path|o Path string, or options
 * @param {boolean} o.withExtension if this parameter set to true method return name with extension.
 * @returns {string}
 * @throws {Error} If passed argument is not string
 * @method pathName
 * @memberof wTools
 */

function pathName( o )
{

  if( _.strIs( o ) )
  o = { path : o };

  _.assert( arguments.length === 1, 'expects single argument' );
  _.routineOptions( pathName,o );
  _.assert( _.strIs( o.path ),'pathName :','expects strings {-o.path-}' );

  let i = o.path.lastIndexOf( '/' );
  if( i !== -1 )
  o.path = o.path.substr( i+1 );

  if( !o.withExtension )
  {
    let i = o.path.lastIndexOf( '.' );
    if( i !== -1 ) o.path = o.path.substr( 0,i );
  }

  return o.path;
}

pathName.defaults =
{
  path : null,
  withExtension : 0,
}

//

function pathNameWithExtension( path )
{

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.strIs( path ),'pathName :','expects strings {-path-}' );

  let i = path.lastIndexOf( '/' );
  if( i !== -1 )
  path = path.substr( i+1 );

  return path;
}

//

let pathsName = _.routineVectorize_functor
({
  routine : pathName,
  vectorizingArray : 1,
  vectorizingMap : 1,
})

let pathsOnlyName = _.routineVectorize_functor
({
  routine : pathName,
  vectorizingArray : 1,
  vectorizingMap : 1,
  fieldFilter : function( e )
  {
    let path = _.objectIs( e ) ? e.path : e;
    return this.pathIs( path );
  }
})

//

/**
 * Return path without extension.
 * @example
 * wTools.pathWithoutExt( '/foo/bar/baz.txt' ); // '/foo/bar/baz'
 * @param {string} path String path
 * @returns {string}
 * @throws {Error} If passed argument is not string
 * @method pathWithoutExt
 * @memberof wTools
 */

function pathWithoutExt( path )
{

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.strIs( path ) );

  let name = _.strIsolateEndOrNone( path,'/' )[ 2 ] || path;

  let i = name.lastIndexOf( '.' );
  if( i === -1 || i === 0 )
  return path;

  let halfs = _.strIsolateEndOrNone( path,'.' );
  return halfs[ 0 ];
}

//

let pathsWithoutExt = _.routineVectorize_functor
({
  routine : pathWithoutExt,
  vectorizingArray : 1,
  vectorizingMap : 1,
})

let pathsOnlyWithoutExt = _.routineVectorize_functor
({
  routine : pathWithoutExt,
  fieldFilter : _filterOnlyPath,
  vectorizingArray : 1,
  vectorizingMap : 1,
})

//

/**
 * Replaces existing path extension on passed in `ext` parameter. If path has no extension, adds passed extension
    to path.
 * @example
 * wTools.pathChangeExt( '/foo/bar/baz.txt', 'text' ); // '/foo/bar/baz.text'
 * @param {string} path Path string
 * @param {string} ext
 * @returns {string}
 * @throws {Error} If passed argument is not string
 * @method pathChangeExt
 * @memberof wTools
 */

// qqq : extend tests

function pathChangeExt( path,ext )
{

  if( arguments.length === 2 )
  {
    _.assert( _.strIs( ext ) );
  }
  else if( arguments.length === 3 )
  {
    let sub = arguments[ 1 ];
    let ext = arguments[ 2 ];

    _.assert( _.strIs( sub ) );
    _.assert( _.strIs( ext ) );

    let cext = this.pathExt( path );

    if( cext !== sub )
    return path;
  }
  else _.assert( 'Expects 2 or 3 arguments' );

  if( ext === '' )
  return this.pathWithoutExt( path );
  else
  return this.pathWithoutExt( path ) + '.' + ext;

}

//

function _pathsChangeExt( src )
{
  _.assert( _.longIs( src ) );
  _.assert( src.length === 2 );

  return pathChangeExt.apply( this, src );
}

let pathsChangeExt = _.routineVectorize_functor
({
  routine : _pathsChangeExt,
  vectorizingArray : 1,
  vectorizingMap : 1,
})

let pathsOnlyChangeExt = _.routineVectorize_functor
({
  routine : _pathsChangeExt,
  vectorizingArray : 1,
  vectorizingMap : 1,
  fieldFilter : function( e )
  {
    return this.pathIs( e[ 0 ] )
  }
})

//

/**
 * Returns file extension of passed `path` string.
 * If there is no '.' in the last portion of the path returns an empty string.
 * @example
 * _.path.pathExt( '/foo/bar/baz.ext' ); // 'ext'
 * @param {string} path path string
 * @returns {string} file extension
 * @throws {Error} If passed argument is not string.
 * @method pathExt
 * @memberof wTools
 */

function pathExt( path )
{

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.strIs( path ), 'expects string {-path-}, but got', _.strTypeOf( path ) );

  let index = path.lastIndexOf( '/' );
  if( index >= 0 )
  path = path.substr( index+1,path.length-index-1  );

  index = path.lastIndexOf( '.' );
  if( index === -1 || index === 0 )
  return '';

  index += 1;

  return path.substr( index,path.length-index ).toLowerCase();
}

//

let pathsExt = _.routineVectorize_functor
({
  routine : pathExt,
  vectorizingArray : 1,
  vectorizingMap : 1,
})

//

let pathsOnlyExt = _.routineVectorize_functor
({
  routine : pathExt,
  fieldFilter : _filterOnlyPath,
  vectorizingArray : 1,
  vectorizingMap : 1,
})

//

/*
qqq : not covered by tests
*/

function pathExts( path )
{

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.strIs( path ), 'expects string {-path-}, but got', _.strTypeOf( path ) );

  path = this.pathName({ path : path, withExtension : 1 });

  let exts = path.split( '.' );
  exts.splice( 0,1 );
  exts = _.entityFilter( exts , ( e ) => !e ? undefined : e.toLowerCase() );

  return exts;
}

// --
// path tester
// --

function pathIs( path )
{
  _.assert( arguments.length === 1, 'expects single argument' );
  return _.strIs( path );
}

//

function pathLike( path )
{
  _.assert( arguments.length === 1, 'expects single argument' );
  if( this.pathIs( path ) )
  return true;
  if( _.FileRecord )
  if( path instanceof _.FileRecord )
  return true;
  return false;
}

//

/**
 * Checks if string is correct possible for current OS path and represent file/directory that is safe for modification
 * (not hidden for example).
 * @param filePath
 * @returns {boolean}
 * @method pathIsSafe
 * @memberof wTools
 */

function pathIsSafe( filePath,concern )
{
  filePath = this.pathNormalize( filePath );

  if( concern === undefined )
  concern = 1;

  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( _.numberIs( concern ) );

  if( concern >= 2 )
  if( /(^|\/)\.(?!$|\/|\.)/.test( filePath ) )
  return false;

  if( concern >= 1 )
  if( filePath.indexOf( '/' ) === 1 )
  if( filePath[ 0 ] === '/' )
  {
    throw _.err( 'not tested' );
    return false;
  }

  if( concern >= 3 )
  if( /(^|\/)node_modules($|\/)/.test( filePath ) )
  return false;

  if( concern >= 1 )
  {
    let isAbsolute = this.pathIsAbsolute( filePath );
    if( isAbsolute )
    if( this.pathIsAbsolute( filePath ) )
    {
      let level = _.strCount( filePath,this._upStr );
      if( this._upStr.indexOf( this._rootStr ) !== -1 )
      level -= 1;
      if( filePath.split( this._upStr )[ 1 ].length === 1 )
      level -= 1;
      if( level <= 0 )
      return false;
    }
  }

  // if( safe )
  // safe = filePath.length > 8 || ( filePath[ 0 ] !== '/' && filePath[ 1 ] !== ':' );

  return true;
}

//

function pathIsNormalized( path )
{
  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.strIs( path ) );
  return this.pathNormalize( path ) === path;
}

//

function pathIsAbsolute( path )
{

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.strIs( path ), 'expects string {-path-}, but got', _.strTypeOf( path ) );
  _.assert( path.indexOf( '\\' ) === -1,'expects normalized {-path-}, but got', path );

  return _.strBegins( path,this._upStr );
}

//

function pathIsRefined( path )
{
  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.strIs( path ), 'expects string {-path-}, but got', _.strTypeOf( path ) );

  if( !path.length )
  return false;

  if( path[ 1 ] === ':' && path[ 2 ] === '\\' )
  return false;

  let leftSlash = /\\/g;
  let doubleSlash = /\/\//g;

  if( leftSlash.test( path ) /* || doubleSlash.test( path ) */ )
  return false;

  /* check right "/" */
  if( path !== this._upStr && !_.strEnds( path,this._upStr + this._upStr ) && _.strEnds( path,this._upStr ) )
  return false;

  return true;
}

//

function pathIsDotted( srcPath )
{
  return _.strBegins( srcPath,this._hereStr );
}

// --
// path transformer
// --

function pathCurrent()
{
  _.assert( arguments.length === 0 );
  return this._upStr;
}

//

function pathGet( src )
{

  _.assert( arguments.length === 1, 'expects single argument' );

  if( _.strIs( src ) )
  return src;
  else
  _.assert( 0,'pathGet : unexpected type of argument : ' + _.strTypeOf( src ) );

}

let pathsGet = _.routineVectorize_functor
({
  routine : pathGet,
  vectorizingArray : 1,
  vectorizingMap : 1,
});

//

function _pathRelative( o )
{
  let self = this;
  let result = '';
  let relative = this.pathGet( o.relative );
  let path = this.pathGet( o.path );

  _.assert( _.strIs( relative ),'pathRelative expects string {-relative-}, but got',_.strTypeOf( relative ) );
  _.assert( _.strIs( path ) || _.arrayIs( path ) );

  if( !o.resolving )
  {
    relative = this.pathNormalize( relative );
    path = this.pathNormalize( path );

    let relativeIsAbsolute = this.pathIsAbsolute( relative );
    let pathIsAbsoulute = this.pathIsAbsolute( path );

    _.assert( relativeIsAbsolute && pathIsAbsoulute || !relativeIsAbsolute && !pathIsAbsoulute, 'Resolving is disabled, paths must be both absolute or relative.' );
  }
  else
  {
    relative = this.pathResolve( relative );
    path = this.pathResolve( path );

    _.assert( this.pathIsAbsolute( relative ) );
    _.assert( this.pathIsAbsolute( path ) );
  }

  _.assert( relative.length > 0 );
  _.assert( path.length > 0 );

  /* */

  let common = _.strCommonLeft( relative,path );

  function goodEnd( s )
  {
    return s.length === common.length || s.substring( common.length,common.length + self._upStr.length ) === self._upStr;
  }

  while( common.length > 1 )
  {
    if( !goodEnd( relative ) || !goodEnd( path ) )
    common = common.substring( 0,common.length-1 );
    else break;
  }

  /* */

  if( common === relative )
  {
    if( path === common )
    {
      result = '.';
    }
    else
    {
      result = _.strEndOf( path,common );
      if( !_.strBegins( result,this._upStr+this._upStr ) && common !== this._upStr )
      result = _.strRemoveBegin( result,this._upStr );
    }
  }
  else
  {
    relative = _.strEndOf( relative,common );
    path = _.strEndOf( path,common );
    let count = _.strCount( relative,this._upStr );
    if( common === this._upStr )
    count += 1;

    if( !_.strBegins( path,this._upStr+this._upStr ) && common !== this._upStr )
    path = _.strRemoveBegin( path,this._upStr );

    result = _.strDup( this._downUpStr,count ) + path;

    if( _.strEnds( result,this._upStr ) )
    _.assert( result.length > this._upStr.length );
    result = _.strRemoveEnd( result,this._upStr );
  }

  if( _.strBegins( result,this._upStr + this._upStr ) )
  result = this._hereStr + result;
  else
  result = _.strRemoveBegin( result,this._upStr );

  _.assert( result.length > 0 );
  _.assert( !_.strEnds( result,this._upStr ) );
  _.assert( result.lastIndexOf( this._upStr + this._hereStr + this._upStr ) === -1 );
  _.assert( !_.strEnds( result,this._upStr + this._hereStr ) );

  if( Config.debug )
  {
    let i = result.lastIndexOf( this._upStr + this._downStr + this._upStr );
    _.assert( i === -1 || !/\w/.test( result.substring( 0,i ) ) );
  }

  return result;
}

_pathRelative.defaults =
{
  relative : null,
  path : null,
  resolving : 0
}

//

/**
 * Returns a relative path to `path` from an `relative` path. This is a path computation : the filesystem is not
   accessed to confirm the existence or nature of path or start. As second argument method can accept array of paths,
   in this case method returns array of appropriate relative paths. If `relative` and `path` each resolve to the same
   path method returns '.'.
 * @example
 * let pathFrom = '/foo/bar/baz',
   pathsTo =
   [
     '/foo/bar',
     '/foo/bar/baz/dir1',
   ],
   relatives = wTools.pathRelative( pathFrom, pathsTo ); //  [ '..', 'dir1' ]
 * @param {string|wFileRecord} relative start path
 * @param {string|string[]} path path to.
 * @returns {string|string[]}
 * @method pathRelative
 * @memberof wTools
 */

function pathRelative( o )
{

  if( arguments[ 1 ] !== undefined )
  {
    o = { relative : arguments[ 0 ], path : arguments[ 1 ] }
  }

  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.routineOptions( pathRelative, o );

  // debugger;
  _.assert( !!this );

  let relative = this.pathGet( o.relative );
  let path = this.pathGet( o.path );

  return this._pathRelative( o );
}

pathRelative.defaults = Object.create( _pathRelative.defaults );

//

function _pathsRelative( o )
{
  _.assert( _.objectIs( o ) || _.longIs( o ) );
  let args = _.arrayAs( o );

  return pathRelative.apply( this, args );
}

let pathsRelative = _pathMultiplicator_functor
({
  routine : pathRelative,
  fieldNames : [ 'relative', 'path' ]
})

function _filterForPathRelative( e )
{
  let paths = [];

  if( _.arrayIs( e ) )
  _.arrayAppendArrays( paths, e );

  if( _.objectIs( e ) )
  _.arrayAppendArrays( paths, [ e.relative, e.path ] );

  if( !paths.length )
  return false;

  return paths.every( ( path ) => this.pathIs( path ) );
}

let pathsOnlyRelative = _.routineVectorize_functor
({
  routine : _pathsRelative,
  fieldFilter : _filterForPathRelative,
  vectorizingArray : 1,
  vectorizingMap : 1,
})

//

function _pathCommon( src1, src2 )
{
  let self = this;

  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( _.strIs( src1 ) && _.strIs( src2 ) );

  let split = function( src )
  {
    // debugger;
    return _.strSplitFast( { src : src, delimeter : [ '/' ], preservingDelimeters : 1, preservingEmpty : 1 } );
  }

  // let fill = function( value, times )
  // {
  //   return _.arrayFillTimes( result : [], value : value, times : times } );
  // }

  function getCommon()
  {
    let length = Math.min( first.splitted.length, second.splitted.length );
    for( let i = 0; i < length; i++ )
    {
      if( first.splitted[ i ] === second.splitted[ i ] )
      {
        if( first.splitted[ i ] === self._upStr && first.splitted[ i + 1 ] === self._upStr )
        break;
        else
        result.push( first.splitted[ i ] );
      }
      else
      break;
    }
  }

  function parsePath( path )
  {
    let result =
    {
      isRelativeDown : false,
      isRelativeHereThen : false,
      isRelativeHere : false,
      levelsDown : 0
    };

    result.normalized = self.pathNormalize( path );
    result.splitted = split( result.normalized );
    result.isAbsolute = self.pathIsAbsolute( result.normalized );
    result.isRelative = !result.isAbsolute;

    if( result.isRelative )
    if( result.splitted[ 0 ] === self._downStr )
    {
      result.levelsDown = _.arrayCount( result.splitted, self._downStr );
      let substr = _.arrayFillTimes( [], result.levelsDown, self._downStr ).join( '/' );
      let withoutLevels = _.strRemoveBegin( result.normalized, substr );
      result.splitted = split( withoutLevels );
      result.isRelativeDown = true;
    }
    else if( result.splitted[ 0 ] === '.' )
    {
      result.splitted = result.splitted.splice( 2 );
      result.isRelativeHereThen = true;
    }
    else
    result.isRelativeHere = true;

    return result;
  }

  let result = [];
  let first = parsePath( src1 );
  let second = parsePath( src2 );

  let needToSwap = first.isRelative && second.isAbsolute;

  if( needToSwap )
  {
    let tmp = second;
    second = first;
    first = tmp;
  }

  let bothAbsolute = first.isAbsolute && second.isAbsolute;
  let bothRelative = first.isRelative && second.isRelative;
  let absoluteAndRelative = first.isAbsolute && second.isRelative;

  if( absoluteAndRelative )
  {
    // if( first.splitted.length > 1 )
    if( first.splitted.length > 3 || first.splitted[ 0 ] !== '' || first.splitted[ 2 ] !== '' || first.splitted[ 1 ] !== '/' )
    {
      debugger;
      throw _.err( 'Incompatible paths.' );
    }
    else
    return '/';
  }

  if( bothAbsolute )
  {
    getCommon();

    result = result.join('');

    if( !result.length )
    result = '/';
  }

  if( bothRelative )
  {
    // console.log(  first.splitted, second.splitted );

    if( first.levelsDown === second.levelsDown )
    getCommon();

    result = result.join('');

    let levelsDown = Math.max( first.levelsDown, second.levelsDown );

    if( levelsDown > 0 )
    {
      let prefix = _.arrayFillTimes( [], levelsDown, self._downStr );
      prefix = prefix.join( '/' );
      result = prefix + result;
    }

    if( !result.length )
    {
      if( first.isRelativeHereThen && second.isRelativeHereThen )
      result = self._hereStr;
      else
      result = '.';
    }
  }

  // if( result.length > 1 )
  // if( _.strEnds( result, '/' ) )
  // result = result.slice( 0, -1 );

  return result;
}

//

function pathCommon( paths )
{

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.arrayIs( paths ) );

  paths = paths.slice();

  paths.sort( function( a, b )
  {
    return b.length - a.length;
  });

  let result = paths.pop();

  for( let i = 0, len = paths.length; i < len; i++ )
  result = this._pathCommon( paths[ i ], result );

  return result;
}

//

function _pathsCommon( o )
{
  let isArray = false;
  let length = 0;

  _.assertRoutineOptions( _pathsCommon, o );

  /* */

  for( let p = 0 ; p < o.paths.length ; p++ )
  {
    let path = o.paths[ p ];
    if( _.arrayIs( path ) )
    {
      _.assert( _filterNoInnerArray( path ), 'Array must not have inner array( s ).' )

      if( isArray )
      _.assert( path.length === length, 'Arrays must have same length.' );
      else
      {
        length = Math.max( path.length,length );
        isArray = true;
      }
    }
    else
    {
      length = Math.max( 1,length );
    }
  }

  if( isArray === false )
  return this.pathCommon( o.paths );

  /* */

  let paths = o.paths;
  function argsFor( i )
  {
    let res = [];
    for( let p = 0 ; p < paths.length ; p++ )
    {
      let path = paths[ p ];
      if( _.arrayIs( path ) )
      res[ p ] = path[ i ];
      else
      res[ p ] = path;
    }
    return res;
  }

  /* */

  // let result = _.entityMake( o.paths );
  let result = new Array( length );
  for( let i = 0 ; i < length ; i++ )
  {
    o.paths = argsFor( i );
    result[ i ] = this.pathCommon( o.paths );
  }

  return result;
}

_pathsCommon.defaults =
{
  paths : null,
}

//

function pathsCommon( paths )
{
  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.arrayIs( paths ) );

  paths = paths.slice();

  let result = this._pathsCommon
  ({
    paths : paths
  })

  return result;
}

//

let pathsOnlyCommon = _.routineVectorize_functor
({
  routine : pathCommon,
  fieldFilter : _filterOnlyPath,
  vectorizingArray : 1,
  vectorizingMap : 1,
})

//

function pathRebase( filePath,oldPath,newPath )
{

  _.assert( arguments.length === 3, 'expects exactly three argument' );

  filePath = this.pathNormalize( filePath );
  if( oldPath )
  oldPath = this.pathNormalize( oldPath );
  newPath = this.pathNormalize( newPath );

  if( oldPath )
  {
    let commonPath = this.pathCommon([ filePath,oldPath ]);
    filePath = _.strRemoveBegin( filePath,commonPath );
  }

  filePath = this.pathReroot( newPath,filePath )

  return filePath;
}

// --
// glob
// --

/*
(\*\*)| -- **
([?*])| -- ?*
(\[[!^]?.*\])| -- [!^]
([+!?*@]\(.*\))| -- @+!?*()
(\{.*\}) -- {}
*/

/* xxx */

let _pathIsGlobRegexp = /(\*\*)|([?*])|(\[[!^]?.*\])|([+!?*@]?\(.*\))|\{.*\}/;
function pathIsGlob( src )
{
  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.strIs( src ) );

  /* let regexp = /(\*\*)|([!?*])|(\[.*\])|(\(.*\))|\{.*\}+(?![^[]*\])/g; */

  return _pathIsGlobRegexp.test( src );
}

//

function pathFromGlob( globIn )
{
  let result;

  _.assert( _.strIs( globIn ) );
  _.assert( arguments.length === 1, 'expects single argument' );

  let i = globIn.search( /[^\\\/]*?(\*\*|\?|\*|\[.*\]|\{.*\}+(?![^[]*\]))[^\\\/]*/ );
  if( i === -1 )
  result = globIn;
  else
  result = globIn.substr( 0,i );

  /* replace urlNormalize by detrail */
  result = _.uri.uriNormalize( result );

  // if( !result && _.path.pathRealMainDir )
  // debugger;
  // if( !result && _.path.pathRealMainDir )
  // result = _.path.pathRealMainDir();

  return result;
}

//

/**
 * Turn a *-wildcard style _glob into a regular expression
 * @example
 * let _glob = '* /www/*.js';
 * wTools.globRegexpsForTerminalSimple( _glob );
 * // /^.\/[^\/]*\/www\/[^\/]*\.js$/m
 * @param {String} _glob *-wildcard style _glob
 * @returns {RegExp} RegExp that represent passed _glob
 * @throw {Error} If missed argument, or got more than one argumet
 * @throw {Error} If _glob is not string
 * @function globRegexpsForTerminalSimple
 * @memberof wTools
 */

function globRegexpsForTerminalSimple( _glob )
{

  function strForGlob( _glob )
  {

    let result = '';
    _.assert( arguments.length === 1, 'expects single argument' );
    _.assert( _.strIs( _glob ) );

    let w = 0;
    _glob.replace( /(\*\*[\/\\]?)|\?|\*/g, function( matched,a,offset,str )
    {

      result += _.regexpEscape( _glob.substr( w,offset-w ) );
      w = offset + matched.length;

      if( matched === '?' )
      result += '.';
      else if( matched === '*' )
      result += '[^\\\/]*';
      else if( matched.substr( 0,2 ) === '**' )
      result += '.*';
      else _.assert( 0,'unexpected' );

    });

    result += _.regexpEscape( _glob.substr( w,_glob.length-w ) );
    if( result[ 0 ] !== '^' )
    {
      result = _.strPrependOnce( result,'./' );
      result = _.strPrependOnce( result,'^' );
    }
    result = _.strAppendOnce( result,'$' );

    return result;
  }

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.strIs( _glob ) || _.strsAre( _glob ) );

  if( _.strIs( _glob ) )
  _glob = [ _glob ];

  let result = _.entityMap( _glob,( _glob ) => strForGlob( _glob ) );
  result = RegExp( '(' + result.join( ')|(' ) + ')','m' );

  return result;
}

//

function globRegexpsForTerminalOld( src )
{

  _.assert( _.strIs( src ) || _.strsAre( src ) );
  _.assert( arguments.length === 1, 'expects single argument' );

/*
  (\*\*\\\/|\*\*)|
  (\*)|
  (\?)|
  (\[.*\])
*/

  let map =
  {
    0 : '.*', /* doubleAsterix */
    1 : '[^\/]*', /* singleAsterix */
    2 : '.', /* questionMark */
    3 : handleSquareBrackets, /* handleSquareBrackets */
    '{' : '(',
    '}' : ')',
  }

  /* */

  let result = '';

  if( _.strIs( src ) )
  {
    result = adjustGlobStr( src );
  }
  else
  {
    if( src.length > 1 )
    for( let i = 0; i < src.length; i++ )
    {
      let r = adjustGlobStr( src[ i ] );
      result += `(${r})`;
      if( i + 1 < src.length )
      result += '|'
    }
    else
    {
      result = adjustGlobStr( src[ 0 ] );
    }
  }

  result = _.strPrependOnce( result,'\\/' );
  result = _.strPrependOnce( result,'\\.' );

  result = _.strPrependOnce( result,'^' );
  result = _.strAppendOnce( result,'$' );

  return RegExp( result );

  /* */

  function handleSquareBrackets( src )
  {
    src = _.strInbetweenOf( src, '[', ']' );
    /* escape inner [] */
    src = src.replace( /[\[\]]/g, ( m ) => '\\' + m );
    /* replace ! -> ^ at the beginning */
    src = src.replace( /^\\!/g, '^' );
    return '[' + src + ']';
  }

  function curlyBrackets( src )
  {
    debugger;
    src = src.replace( /[\}\{]/g, ( m ) => map[ m ] );
    /* replace , with | to separate regexps */
    src = src.replace( /,+(?![^[|(]*]|\))/g, '|' );
    return src;
  }

  function globToRegexp()
  {
    let args = _.longSlice( arguments );
    let i = args.indexOf( args[ 0 ], 1 ) - 1;

    /* i - index of captured group from regexp is equivalent to key from map  */

    if( _.strIs( map[ i ] ) )
    return map[ i ];
    else if( _.routineIs( map[ i ] ) )
    return map[ i ]( args[ 0 ] );
    else _.assert( 0 );
  }

  function adjustGlobStr( src )
  {
    _.assert( !_.path.pathIsAbsolute( src ) );

    /* espace simple text */
    src = src.replace( /[^\*\[\]\{\}\?]+/g, ( m ) => _.regexpEscape( m ) );
    /* replace globs with regexps from map */
    src = src.replace( /(\*\*\\\/|\*\*)|(\*)|(\?)|(\[.*\])/g, globToRegexp );
    /* replace {} -> () and , -> | to make proper regexp */
    src = src.replace( /\{.*\}/g, curlyBrackets );
    // src = src.replace( /\{.*\}+(?![^[]*\])/g, curlyBrackets );

    return src;
  }

}

//

function globRegexpsForTerminal( src )
{
  let self = this;

  _.assert( _.strIs( src ) || _.strsAre( src ) );
  _.assert( arguments.length === 1, 'expects single argument' );

  let result = '';

  if( _.strIs( src ) )
  {
    result = adjustGlobStr( src );
  }
  else
  {
    if( src.length > 1 )
    for( let i = 0; i < src.length; i++ )
    {
      let r = adjustGlobStr( src[ i ] );
      result += `(${r})`;
      if( i + 1 < src.length )
      result += '|'
    }
    else
    {
      result = adjustGlobStr( src[ 0 ] );
    }
  }

  result = _.strPrependOnce( result,'\\/' );
  result = _.strPrependOnce( result,'\\.' );

  result = _.strPrependOnce( result,'^' );
  result = _.strAppendOnce( result,'$' );

  return RegExp( result );

  /* */

  function adjustGlobStr( src )
  {
    _.assert( !_.path.pathIsAbsolute( src ) );
    src = self._globRegexpForSplit( src );
    return src;
  }

}

//

function globSplit( glob )
{
  _.assert( arguments.length === 1, 'expects single argument' );

  debugger;

  return _.path.pathSplit( glob );
}

//

function _globRegexpForSplit( src )
{

  _.assert( _.strIs( src ) );
  _.assert( arguments.length === 1, 'expects single argument' );

  let transformation1 =
  [
    [ /\[(.*)]/g, handleSquareBrackets ], /* square brackets */
    [ /\{(.*)\}/g, handleCurlyBrackets ], /* curly brackets */
  ]

  let transformation2 =
  [
    [ /([!?*@+]+)\((.*?(?:\|(.*?))*)\)/g, hanleParentheses ], /* parentheses */
    [ /(\*\*\\\/|\*\*)/g, '.*', ], /* double asterix */
    [ /(\*)/g, '[^\/]*' ], /* single asterix */
    [ /(\?)/g, '.', ], /* question mark */
  ]

  let result = adjustGlobStr( src );

  return result;

  /* */

  function handleCurlyBrackets( src, it )
  {
    xxx
  }

  /* */

  function handleSquareBrackets( src, it )
  {
    let inside = it.groups[ 0 ];
    /* escape inner [] */
    inside = inside.replace( /[\[\]]/g, ( m ) => '\\' + m );
    /* replace ! -> ^ at the beginning */
    inside = inside.replace( /^\\!/g, '^' );
    if( inside[ 0 ] === '^' )
    inside = inside + '\/';
    return '[' + inside + ']';
  }

  /* */

  function hanleParentheses( src, it )
  {

    let inside = it.groups[ 1 ].split( '|' );
    let multiplicator = it.groups[ 0 ];
    multiplicator = _.strReverse( multiplicator );
    if( multiplicator === '*' )
    multiplicator += '?';

    _.assert( _.strCount( multiplicator, '!' ) === 0 || multiplicator === '!' );
    _.assert( _.strCount( multiplicator, '@' ) === 0 || multiplicator === '@' );

    let result = '(?:' + inside.join( '|' ) + ')';
    if( multiplicator === '@' )
    result = result;
    else if( multiplicator === '!' )
    result = '(?:(?!(?:' + result + '|\/' + ')).)*?';
    else
    result += multiplicator;

    /* (?:(?!(?:abc)).)+ */

    return result;
  }

  // /* */
  //
  // function curlyBrackets( src )
  // {
  //   debugger;
  //   src = src.replace( /[\}\{]/g, ( m ) => map[ m ] );
  //   /* replace , with | to separate regexps */
  //   src = src.replace( /,+(?![^[|(]*]|\))/g, '|' );
  //   return src;
  // }

  /* */

  function adjustGlobStr( src )
  {
    let result = src;

    _.assert( !_.path.pathIsAbsolute( result ) );

    result = _.strReplaceAll( result, transformation1 );
    result = _.strReplaceAll( result, transformation2 );

    // /* espace ordinary text */
    // result = result.replace( /[^\*\+\[\]\{\}\?\@\!\^\(\)]+/g, ( m ) => _.regexpEscape( m ) );

    // /* replace globs with regexps from map */
    // result = result.replace( /(\*\*\\\/|\*\*)|(\*)|(\?)|(\[.*\])/g, globToRegexp );

    // /* replace {} -> () and , -> | to make proper regexp */
    // result = result.replace( /\{.*\}/g, curlyBrackets );
    // result = result.replace( /\{.*\}+(?![^[]*\])/g, curlyBrackets );

    return result;
  }

}

//

/*
for d1/d2/** _globRegexpsForDirectory generates /^.(\/d1(\/d2(\/.*)?)?)?$/
*/

function _globRegexpsForDirectory( src )
{

  _.assert( _.strIs( src ) );
  _.assert( arguments.length === 1, 'expects single argument' );

  /* */

  let result = forGlob( src );
  result = _.regexpsJoin([ '^', result, '$' ]);
  return result;

  /* */

  function forGlob( glob )
  {
    let prefix = '';
    let postfix = '';
    let path = _.path.pathFromGlob( glob );
    path = glob;
    path = _.path.pathDot( path );

    // debugger;
    _.assert( !_.path.pathIsAbsolute( glob ) );

    let pathArray = _.path.pathSplit( path );
    // pathArray = pathArray.map( ( e ) => '\\/' + e );
    pathArray = pathArray.map( ( e ) => '\\/' + _globRegexpForSplit( e ) );
    pathArray[ 0 ] = '\\.';
    // pathArray.push( '\\/.*' );
    let result = _.regexpsAtLeastFirst( pathArray );

    // debugger;
    return result;
  }

}

// --
//
// --

function _init()
{

  _.assert( _.strIs( this._rootStr ) );
  _.assert( _.strIs( this._upStr ) );
  _.assert( _.strIs( this._hereStr ) );
  _.assert( _.strIs( this._downStr ) );

  if( !this._hereUpStr )
  this._hereUpStr = this._hereStr + this._upStr;
  if( !this._downUpStr )
  this._downUpStr = this._downStr + this._upStr;

  this._upEscapedStr = _.regexpEscape( this._upStr );
  this._butDownUpEscapedStr = '(?!' + _.regexpEscape( this._downStr ) + this._upEscapedStr + ')';
  this._delDownEscapedStr = this._butDownUpEscapedStr + '((?!' + this._upEscapedStr + ').)+' + this._upEscapedStr + _.regexpEscape( this._downStr ) + '(' + this._upEscapedStr + '|$)';
  this._delDownEscaped2Str = this._butDownUpEscapedStr + '((?!' + this._upEscapedStr + ').|)+' + this._upEscapedStr + _.regexpEscape( this._downStr ) + '(' + this._upEscapedStr + '|$)';
  this._delUpRegexp = new RegExp( this._upEscapedStr + '+$' );
  this._delHereRegexp = new RegExp( this._upEscapedStr + _.regexpEscape( this._hereStr ) + '(' + this._upEscapedStr + '|$)','' );
  this._delDownRegexp = new RegExp( this._upEscapedStr + this._delDownEscaped2Str,'' );
  this._delDownFirstRegexp = new RegExp( '^' + this._delDownEscapedStr,'' );
  this._delUpDupRegexp = /\/{2,}/g;

}

//

function cloneExtending( o )
{
  debugger;
  _.assert( arguments.length === 1 );
  let result = _.mapExtend( null, this, Fields, o );
  result._init();
  return result;
}

// --
// fields
// --

let Fields =
{

  _rootStr : '/',
  _upStr : '/',
  _hereStr : '.',
  _downStr : '..',
  _hereUpStr : null,
  _downUpStr : null,

  _upEscapedStr : null,
  _butDownUpEscapedStr : null,
  _delDownEscapedStr : null,
  _delDownEscaped2Str : null,
  _delUpRegexp : null,
  _delHereRegexp : null,
  _delDownRegexp : null,
  _delDownFirstRegexp : null,
  _delUpDupRegexp : null,

}

// --
// routines
// --

let Routines =
{

  // internal

  _pathMultiplicator_functor : _pathMultiplicator_functor,
  _filterNoInnerArray : _filterNoInnerArray,
  _filterOnlyPath : _filterOnlyPath,

  _init : _init,
  cloneExtending : cloneExtending,

  // normalizer

  pathRefine : pathRefine,
  pathsRefine : pathsRefine,
  pathsOnlyRefine : pathsOnlyRefine,

  _pathNormalize : _pathNormalize,
  pathNormalize : pathNormalize,
  pathsNormalize : pathsNormalize,
  pathsOnlyNormalize : pathsOnlyNormalize,

  pathNormalizeTolerant : pathNormalizeTolerant,

  pathDot : pathDot,
  pathsDot : pathsDot,
  pathsOnlyDot : pathsOnlyDot,

  pathUndot : pathUndot,
  pathsUndot : pathsUndot,
  pathsOnlyUndot : pathsOnlyUndot,

  _pathNativizeWindows : _pathNativizeWindows,
  _pathNativizeUnix : _pathNativizeUnix,
  pathNativize : pathNativize,

  // path join

  _pathJoin_body : _pathJoin_body,
  _pathsJoin_body : _pathsJoin_body,

  pathJoin : pathJoin,
  pathsJoin : pathsJoin,

  pathReroot : pathReroot,
  pathsReroot : pathsReroot,
  pathsOnlyReroot : pathsOnlyReroot,

  pathResolve : pathResolve,
  pathsResolve : pathsResolve,
  pathsOnlyResolve : pathsOnlyResolve,

  // path cut off

  pathSplit : pathSplit,
  _pathSplit : _pathSplit,

  pathDir : pathDir,
  pathsDir : pathsDir,
  pathsOnlyDir : pathsOnlyDir,

  pathPrefixGet : pathPrefixGet,
  pathsPrefixesGet : pathsPrefixesGet,
  pathsOnlyPrefixesGet : pathsOnlyPrefixesGet,

  pathName : pathName,
  pathsName : pathsName,
  pathsOnlyName : pathsOnlyName,

  pathNameWithExtension : pathNameWithExtension,

  pathWithoutExt : pathWithoutExt,
  pathsWithoutExt : pathsWithoutExt,
  pathsOnlyWithoutExt : pathsOnlyWithoutExt,

  pathChangeExt : pathChangeExt,
  pathsChangeExt : pathsChangeExt,
  pathsOnlyChangeExt : pathsOnlyChangeExt,

  pathExt : pathExt,
  pathsExt : pathsExt,
  pathsOnlyExt : pathsOnlyExt,

  pathExts : pathExts,

  // path tester

  pathIs : pathIs,
  pathLike : pathLike,
  pathIsSafe : pathIsSafe,
  pathIsNormalized : pathIsNormalized,
  pathIsAbsolute : pathIsAbsolute,
  pathIsRefined : pathIsRefined,
  pathIsDotted : pathIsDotted,

  // path transformer

  pathCurrent : pathCurrent,
  pathGet : pathGet,
  pathsGet : pathsGet,

  _pathRelative : _pathRelative,
  pathRelative : pathRelative,
  pathsRelative : pathsRelative,
  pathsOnlyRelative : pathsOnlyRelative,

  _pathCommon : _pathCommon,
  pathCommon : pathCommon,
  _pathsCommon : _pathsCommon,
  pathsCommon : pathsCommon,
  pathsOnlyCommon : pathsOnlyCommon,

  pathRebase : pathRebase,

  // glob

  pathIsGlob : pathIsGlob,

  pathFromGlob : pathFromGlob,

  globRegexpsForTerminalSimple : globRegexpsForTerminalSimple,
  globRegexpsForTerminalOld : globRegexpsForTerminalOld,
  globRegexpsForTerminal : globRegexpsForTerminal,

  globSplit : globSplit,
  _globRegexpForSplit : _globRegexpForSplit,
  _globRegexpsForDirectory : _globRegexpsForDirectory,
  globRegexpsForDirectory : _.routineVectorize_functor( _globRegexpsForDirectory ),

}

// _.mapExtend( _,Extend );
// _.mapSupplement( _,Supplement );

_.mapSupplement( Self, Fields );
_.mapSupplement( Self, Routines );

Self._init();

// --
// export
// --

if( typeof module !== 'undefined' )
if( _global_.WTOOLS_PRIVATE )
delete require.cache[ module.id ];

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;

})();
