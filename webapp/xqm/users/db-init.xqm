module namespace db-init = "http://www.architextus.com/xquery/library/users-management/db-init";

declare namespace db = 'http://basex.org/modules/db';
declare namespace file = 'http://expath.org/ns/file';
declare namespace map = 'http://www.w3.org/2005/xpath-functions/map';
declare namespace output = 'http://www.w3.org/2010/xslt-xquery-serialization';
declare namespace rest = "http://exquery.org/ns/restxq";


declare variable $db-init:users := map:merge((
   map:entry('addarchives', 'false'),
   map:entry('addraw', 'false'),
   map:entry('attrindex', 'true'),
   map:entry('chop', 'false'),
   map:entry('intparse', 'true'),
   map:entry('createfilter', '*.xml'),
   map:entry('updindex', 'true'),
   map:entry('autooptimize', 'true')
));

declare %rest:path('/user-mngt/create-db/users')
   %rest:GET
   %rest:query-param('http-context', '{$http-context}', '')
   %output:method("html")
   %output:html-version("5.0")
%updating function db-init:create-users-db($http-context as xs:string) {
    let $t := ''
    return 
      db:create('users', (), (), $db-init:users),
      update:output(<p>DB ready</p>)
    
   (:let $t := 
   return ():)

};
