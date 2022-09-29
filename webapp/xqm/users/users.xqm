module namespace users = "http://www.architextus.com/xquery/library/users-management/users";

declare namespace db = 'http://basex.org/modules/db';
declare namespace file = 'http://expath.org/ns/file';
declare namespace map = 'http://www.w3.org/2005/xpath-functions/map';
declare namespace output = 'http://www.w3.org/2010/xslt-xquery-serialization';
declare namespace random = "http://basex.org/modules/random";
declare namespace rest = "http://exquery.org/ns/restxq";
declare namespace update = "http://basex.org/modules/update";

declare %rest:path('/user-mngt/user/get')
   %rest:GET
   %rest:query-param('id', '{$id}', '')
   %rest:query-param('http-context', '{$http-context}', '')
   %output:method("html")
   %output:html-version("5.0")
function users:get-user($id as xs:string, $http-context as xs:string) {
   let $user := db:open('users')/*[@id = $id]
   return $user
};

declare %rest:path('/user-mngt/user/create')
   %rest:POST
   %rest:form-param('email', '{$email}', '')
   %rest:form-param('fname', '{$fname}', '')
   %rest:form-param('mname', '{$mname}', '')
   %rest:form-param('lname1', '{$lname1}', '')
   %rest:form-param('lname2', '{$lname2}', '')
   %rest:form-param('password', '{$password}', '')
   %rest:form-param('role', '{$roles}', '')
   %rest:form-param('http-context', '{$http-context}', '')
   %output:method("html")
   %output:html-version("5.0")
%updating function users:set-user($email as xs:string, $fname as xs:string, $mname as xs:string,
   $lname1 as xs:string, $lname2 as xs:string, $password as xs:string, $roles as xs:string*,
   $http-context as xs:string) {
   let $exists := db:exists(db:open('users')/*[descendant::*[name()='email'] = $email])
   let $id := 'u' || random:uuid()
   (: TODO, eventually make configurable:)
   let $roles := 
      if (count($roles) = 0)
      then ('administrators', 'authors', 'developers', 'publishers', 'readers', 'subscribers', 'translation-managers')
      else $roles
   (: Will set to new and will ask admin to approve new users. but for now anyone who signs is is approved :)
   let $new-user := 
      <user id="{$id}" status="approved">
         <contact>
            <fname>{$fname}</fname>
            <mname>{$mname}</mname>
            <lname1>{$lname1}</lname1>
            <lname2>{$lname2}</lname2>
            <email>{$email}</email>
         </contact>
         <password>{$password}</password>
         <roles>{
            for $role in $roles
            return <role>{$role}</role>
         }</roles>
      </user>
   return 
      if ($exists)
      then (
         (),
         update:output(<div class="error">A user with this email already exists</div>)
      )
      else 
         db:add('users', $new-user, $id), 
         update:output(<div class="success">
            <p>Welcome {$fname}</p>
            <p>Your have the access to features available to:</p>
            <ul>{
               for $role in $roles
               return <li>{$role}</li>
            }</ul>
            <p>If this is not sufficient, go to Account/Administration/Roles.</p>
         </div>)
};