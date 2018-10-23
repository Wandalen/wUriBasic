( function _Uris_s_() {

'use strict';

/**
 * @file Uris.s.
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
let Parent = _.uri;
let Self = _.uris = _.uris || Object.create( Parent );

// --
//
// --

function _keyEndsUriFilter( e,k,c )
{
  _.assert( 0, 'not tested' );

  if( _.strIs( k ) )
  {
    if( _.strEnds( k,'Uri' ) )
    return true;
    else
    return false
  }
  return this.is( e );
}

//

function _isUriFilter( e )
{
  return this.is( e[ 0 ] )
}

//

function vectorize( routine, select )
{
  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( _.strIs( routine ) );
  select = select || 1;
  return _.routineVectorize_functor
  ({
    routine : [ 'single', routine ],
    vectorizingArray : 1,
    vectorizingMap : 0,
    vectorizingKeys : 1,
    select : select,
  });
}

//

function vectorizeAsArray( routine, select )
{
  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( _.strIs( routine ) );
  select = select || 1;

  let after = _.routineVectorize_functor
  ({
    routine : [ 'single', routine ],
    vectorizingArray : 1,
    vectorizingMap : 0,
    vectorizingKeys : 0,
    select : select,
  });

  return wrap;

  function wrap( srcs )
  {
    _.assert( arguments.length === 1 );
    if( _.mapIs( srcs ) )
    srcs = _.mapKeys( srcs );
    return after.call( this, srcs );
  }

}

//

function vectorizeAll( routine, select )
{
  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( _.strIs( routine ) );

  let routine2 = vectorizeAsArray( routine, select );

  return all;

  function all()
  {
    let result = routine2.apply( this, arguments );
    return _.all( result );
  }

}

//

function vectorizeAny( routine, select )
{
  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( _.strIs( routine ) );

  let routine2 = vectorizeAsArray( routine, select );

  return any;

  function any()
  {
    let result = routine2.apply( this, arguments );
    return _.any( result );
  }

}

//

function vectorizeNone( routine, select )
{
  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( _.strIs( routine ) );

  let routine2 = vectorizeAsArray( routine, select );

  return none;

  function none()
  {
    let result = routine2.apply( this, arguments );
    return _.none( result );
  }

}

//

function vectorizeOnly( routine )
{
  _.assert( arguments.length === 1 );
  _.assert( _.strIs( routine ) );
  return _.routineVectorize_functor
  ({
    routine : [ 'single', routine ],
    fieldFilter : _keyEndsUriFilter,
    vectorizingArray : 1,
    vectorizingMap : 1,
  });
}

// --
// meta
// --

let OriginalInit = Parent.Init;
Parent.Init = function Init()
{
  let result = OriginalInit.apply( this, arguments );

  _.assert( _.objectIs( this.s ) );
  _.assert( this.s.single !== undefined );
  this.s = Object.create( this.s );
  this.s.single = this;

  return result;
}

// --
// fields
// --

let Fields =
{
  uri : Parent,
}

// --
// routines
// --

let Routines =
{

  _keyEndsUriFilter : _keyEndsUriFilter,
  _isUriFilter : _isUriFilter,

  // uri checker

  are : vectorizeAsArray( 'is' ),
  areSafe : vectorizeAsArray( 'isSafe' ),
  areNormalized : vectorizeAsArray( 'isNormalized' ),
  areAbsolute : vectorizeAsArray( 'isAbsolute' ),

  all : vectorizeAll( 'is' ),
  allSafe : vectorizeAll( 'isSafe' ),
  allNormalized : vectorizeAll( 'isNormalized' ),
  allAbsolute : vectorizeAll( 'isAbsolute' ),

  anyAre : vectorizeAny( 'is' ),
  anyAreSafe : vectorizeAny( 'isSafe' ),
  anyAreNormalized : vectorizeAny( 'isNormalized' ),
  anyAreAbsolute : vectorizeAny( 'isAbsolute' ),

  noneAre : vectorizeNone( 'is' ),
  noneAreSafe : vectorizeNone( 'isSafe' ),
  noneAreNormalized : vectorizeNone( 'isNormalized' ),
  noneAreAbsolute : vectorizeNone( 'isAbsolute' ),

  // uri

  parse : vectorize( 'parse' ),
  parseAtomic : vectorize( 'parseAtomic' ),
  parseConsecutive : vectorize( 'parseConsecutive' ),

  onlyParse : vectorizeOnly( 'parse' ),
  onlyParseAtomic : vectorizeOnly( 'parseAtomic' ),
  onlyParseConsecutive : vectorizeOnly( 'parseConsecutive' ),

  str : vectorize( 'str' ),
  full : vectorize( 'full' ),

  refine : vectorize( 'refine' ),
  normalize : vectorize( 'normalize' ),
  normalizeTolerant : vectorize( 'normalizeTolerant' ),

  onlyRefine : vectorizeOnly( 'refine' ),
  onlyNormalize : vectorizeOnly( 'normalize' ),
  onlyTormalizeTolerant : vectorizeOnly( 'normalizeTolerant' ),

  join : vectorize( 'join', Infinity ),
  resolve : vectorize( 'resolve', Infinity ),

  relative : vectorize( 'relative', 2 ),
  common : vectorize( 'common', Infinity ),
  rebase : vectorize( 'rebase', 3 ),

  dir : vectorize( 'dir' ),
  name : vectorize( 'name' ),
  ext : vectorize( 'ext' ),
  exts : vectorize( 'exts' ),
  changeExt : vectorize( 'changeExt', 2 ),

  onlyDir : vectorizeOnly( 'dir' ),
  onlyName : vectorizeOnly( 'name' ),
  onlyExt : vectorizeOnly( 'ext' ),

  documentGet : vectorize( 'documentGet', 2 ),
  server : vectorize( 'server' ),
  query : vectorize( 'query' ),
  dequery : vectorize( 'dequery' )

}

_.mapSupplementOwn( Self, Fields );
_.mapSupplementOwn( Self, Routines );

// _.assert( _.uri.s === null );
_.uri.s = Self;

// --
// export
// --

if( typeof module !== 'undefined' )
if( _global_.WTOOLS_PRIVATE )
delete require.cache[ module.id ];

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;

})();
