module namespace users = "http://www.architextus.com/xquery/library/users-management/users";

declare namespace db = 'http://basex.org/modules/db';

declare namespace usrerr="http://www.architextus/xquery/library/usrerr";


declare updating function users:add ($fname as xs:string, $mname as xs:string, 
    $lname1 as xs:string, $lname2 as xs:string, 
    $email as xs:string, $password as xs:string,
    $google-profile-id as xs:string) {
        let $debug := trace('In users: add ')
        return 
            if (users:get-by-email($email))
            then 
                error(xs:QName('usrerr:USREXST'), 'User already exists')
            else 
                 let $user-id := users:create-unique-id()
                 let $user := 
                     <user id="{$user-id}" status="approved">
                         <contact>
                            <fname>{$fname}</fname>
                            <mname>{$mname}</mname>
                            <lname1>{$lname1}</lname1>
                            <lname2>{$lname2}</lname2>
                            <emails>
                                <email>{$email}</email>
                            </emails>
                            <password>{$password}</password>
                         </contact>
                         <oauth>
                             <google-profile-id>{$google-profile-id}</google-profile-id>
                         </oauth>
                         <roles>
                            <role>user</role>
                         </roles>
                      </user>
                 let $debug := trace ($user)
                 return
                    db:add('users', $user, $user-id || '.xml')
};

declare updating function users:set-google-profile-id($id as xs:string, $google-profile-id as xs:string) {
    let $debug := trace('Adding google profile id ' || $google-profile-id || ' to user ' || $id)
    let $user := users:get-by-id($id)
    let $debug := trace($user)
    return 
        if (count($user) = 1)
        then 
            let $debug := trace('Found user, adding value')
            let $new-user := 
                copy $copy := $user
                modify (
                    let $debug := trace('fname' || $copy/self::*/contact/fname) return
                   replace value of node $copy/self::*/oauth/google-profile-id with $google-profile-id
                )
                return $copy
            let $debug := trace($new-user)
            let $subpath := substring-after($user/base-uri(), 'users')
            let $debug := trace('Saving at ' || $subpath)
            return db:put ('users', $new-user, $subpath)
        else error(xs:QName('usrerr:USREXST'), 'User does not exist (' || count($user) || ')' )

};

declare function users:get-by-email ($email as xs:string) as node()* {
    let $user := db:get('users')/*[descendant::*[name()='email'][. = $email]]
    return 
        if (count($user) = 1)
        then $user
        else ()
};

declare function users:get-by-google-profile-id ($google-profile-id as xs:string) as node()* {
    let $user := db:get('users')/*[descendant::*[name()='google-profile-id'][. = $google-profile-id]]
    return 
        if (count($user) = 1)
        then $user
        else ()
};

declare function users:get-by-id ($id as xs:string) as node()* {
    let $user := db:get('users')/*[@id=$id]
    return 
        if (count($user) = 1)
        then $user
        else ()
};

declare function users:create-unique-id () as xs:string {
    let $debug := trace('In create-unique-id')
    let $date-string := format-dateTime(current-dateTime(), "[Y01][M01][D01][H01][m01][s01]")
    let $debug := trace('Date string', $date-string || '&#10;')
    (:let $short-date-string := substring-after(substring-before($date-string, '\.'), '20')
    let $debug := trace('Short date string', $short-date-string  || '&#10;')
    let $date-numbers := replace(replace(replace(replace($short-date-string, 'T', ''), ':', ''), '\+', ''), '-', ''):)
    let $id := 'U' || $date-string
    let $debug := trace('Id is: ' || $id || '; matches: ' || count(db:get('users')/*[@id=$id]))
    return
         if (count(db:get('users')/*[@id=$id]) > 0)
         then users:create-unique-id()
         else $id
};