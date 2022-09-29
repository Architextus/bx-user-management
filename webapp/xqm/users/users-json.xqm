module namespace jn-users = "http://www.architextus.com/xquery/library/users-management/jn-users";
import module namespace users = "http://www.architextus.com/xquery/library/users-management/users" at "users.xqm";


declare namespace file = 'http://expath.org/ns/file'; 
declare namespace json = 'http://basex.org/modules/json';
declare namespace map = 'http://www.w3.org/2005/xpath-functions/map';
declare namespace output = 'http://www.w3.org/2010/xslt-xquery-serialization';
declare namespace rest ="http://exquery.org/ns/restxq";
declare namespace update ='http://basex.org/modules/update';
declare namespace web = 'http://basex.org/modules/web';


(: User is a json object received as a string :)
declare %updating
    %rest:path('/users/user')
    %rest:GET
    %rest:query-param('step', '{$step}', 1)
    %rest:query-param('user', '{$user}', 'allo')
    %output:method('xhtml')
    %output:html-version('5.0')
function jn-users:jn-add($step as xs:integer, $user as xs:string) {
    let $debug := trace('In jn-add')
    (:let $steps := <steps>
        <step>add-user</step>
        <step>return-user</step>
    </steps>
    let $step-name := $steps/self::*/*[name()='step'][$step]/text()
    let $next-step := $step + 1 
    let $debug := trace($user)
    let $debug := trace('Parsed')
    let $values := json:parse($user)
    let $debug := trace($values)
    let $email := $values//*[name()='email']/text()
    return 
        switch($step-name)
        case 'add-user'
         return 
             users:add($values//*[name()='/fname']/text(), $values//*[name()='/mname']/text(), 
                 $values//*[name()='/lname1']/text(), $values//*[name()='/lname2']/text(), 
                 $email, $values//*[name()='/password']/text(), $values//*[name()='google-profile-id']/text()
             )
        case 'return-user' return (
            (), 
            update:output(users:get-by-email($email))
        )
        default return 
         let $message := map {error: "oups"}
         return 
             ((), update:output($message))
    :)
    return ((), update:output('<div>Users in dev</div>'))
};