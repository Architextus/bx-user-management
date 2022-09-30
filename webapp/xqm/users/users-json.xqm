module namespace jn-users = "http://www.architextus.com/xquery/library/users-management/jn-users";
import module namespace users = "http://www.architextus.com/xquery/library/users-management/users" at "users.xqm";
import module namespace flatjson = "http://www.architextus.com/xquery/library/users-management/user2att" at "user2attributes.xqm";



declare namespace file = 'http://expath.org/ns/file'; 
declare namespace json = 'http://basex.org/modules/json';
declare namespace map = 'http://www.w3.org/2005/xpath-functions/map';
declare namespace output = 'http://www.w3.org/2010/xslt-xquery-serialization';
declare namespace rest ="http://exquery.org/ns/restxq";
declare namespace update ='http://basex.org/modules/update';
declare namespace web = 'http://basex.org/modules/web';

declare variable $jn-users:jn-serialize-options := map {
    'format': 'jsonml'
};
(: Returns the new user as json :)
(: Expects password to be hashed, will save as is without further encrypting:)
declare %updating
    %rest:path('/users/user')
    %rest:GET
    %rest:query-param('fname', '{$fname}', '')
    %rest:query-param('mname', '{$mname}', '')
    %rest:query-param('lname1', '{$lname1}', '')
    %rest:query-param('lname2', '{$lname2}', '')
    %rest:query-param('email', '{$email}', '')
    %rest:query-param('password', '{$password}', '')
    %rest:query-param('google-profile-id', '{$google-profile-id}', '')
    %rest:query-param('step', '{$step}', 1)
    %output:method('json')
    (:%output:html-version('5.0'):)
function jn-users:jn-add($fname as xs:string, $mname as xs:string, 
    $lname1 as xs:string, $lname2 as xs:string, 
    $email as xs:string, $password as xs:string, 
    $google-profile-id as xs:string, $step as xs:integer) {
    (: TODO: validate that fname, lname and email are provided and valid:)
    try {
        let $debug := trace('In jn-add, step... ' || $step)
        let $steps := <steps>
            <step>add-user</step>
            <step>return-user</step>
        </steps>
        let $step-name := $steps/self::*/*[name()='step'][$step]/text()
        let $next-step-num := $step + 1
        let $next-call := '/users/user?email=' || $email || '&amp;step=' || $next-step-num
        let $debug := trace('Next call: ' || $next-call)
        return 
            switch($step-name)
            case 'add-user'
             return let $debug := trace('case add-user') return (
                 users:add($fname, $mname, $lname1, $lname2, $email, $password, $google-profile-id),
                 update:output(web:redirect($next-call))
             )    
            case 'return-user' return 
                let $debug := trace('case return-user') 
                let $user := users:get-by-email($email)
                (:let $jn-user := json:serialize($user, $jn-users:jn-serialize-options):)
                let $jn-user := flatjson:transform($user)

                (:let $jn-user := json:serialize($user, $jn-users:jn-serialize-options):)
                let $debug := trace('*** User and jn-user')
           
                let $debug := trace($jn-user)
                return (
                    (), 
                    update:output($jn-user)
                )
            default return 
             let $message := <div>Sign up got one step too far</div>
             return 
                 ((), web:error('400', $message))
     } catch * {
        (
            web:error(400, $err:description)
        )
        
        (:
        TODO: Define standard for sending errors with BX. We could send .have a send details to admin or something
        .   $err:code error code
            $err:description: error message
            $err:value: value associated with the error (optional)
            $err:module: URI of the module where the error occurred
            $err:line-number: line number where the error occurred
            $err:column-number: column number where the error occurred
            $err:additional: error stack trace:)
        
        
        
     }
};

declare
    %rest:path('/users/user/by-email')
    %rest:GET
    %rest:query-param('email', '{$email}', '')
    %output:method('json')
    (:%output:html-version('5.0'):)
function jn-users:jn-get-by-email($email as xs:string) {
    let $user := users:get-by-email($email)
    (:let $jn-user := json:serialize($user, $jn-users:jn-serialize-options):)
    let $jn-user := flatjson:transform($user)
    let $debug := trace('JSON GET BY EMAIL')
    let $debug := trace($jn-user)
    return $jn-user
};

declare
    %rest:path('/users/user/by-id')
    %rest:GET
    %rest:query-param('id', '{$id}', '')
    %output:method('json')
    (:%output:html-version('5.0'):)
function jn-users:jn-get-by-id($id as xs:string) {
    let $user := users:get-by-id($id)
    (:let $jn-user := json:serialize($user, $jn-users:jn-serialize-options):)
    let $jn-user := flatjson:transform($user)
    let $debug := trace('JSON GET BY ID')
    let $debug := trace($jn-user)
    return $jn-user
};