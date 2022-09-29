module namespace db-init-forms = "http://www.architextus.com/xquery/library/users-management/forms/db-init";

declare namespace db = 'http://basex.org/modules/db';
declare namespace file = 'http://expath.org/ns/file';
declare namespace map = 'http://www.w3.org/2005/xpath-functions/map';
declare namespace output = 'http://www.w3.org/2010/xslt-xquery-serialization';
declare namespace rest = "http://exquery.org/ns/restxq";



declare %rest:path('/user-mngt/form/create-db/users')
  %rest:GET
  %rest:query-param('http-context', '{$http-context}', '')
  %output:method("html")
  %output:html-version("5.0")
function db-init-forms:create-users-db($http-context as xs:string) {
  <div>
      <form class="req-and-update-res" data-http-req="/user-mngt/create-db/users" data-res-id="res-create-users-db">
      <div style="display:none;"><input name="http-context" value="{$http-context}"></input></div>
      <p><i>If you already have a user DB, this will overwrite it. All current users will be erased. Users will no longer be able to log in.</i></p>
         <button type="submit">Create users database</button>
      </form>
      <div class="res" id="res-create-users-db"/>
   </div> 
};


