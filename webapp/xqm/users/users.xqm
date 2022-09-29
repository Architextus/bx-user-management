module namespace users = "http://www.architextus.com/xquery/library/users-management/users";

declare namespace db = 'http://basex.org/modules/db';

declare updating function users:add ($fname as xs:string, $mname as xs:string, 
    $lname1 as xs:string, $lname2 as xs:string, 
    $email as xs:string, $password as xs:string,
    $google-profile-id as xs:string) {
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
        let $jn-user := json:parse($user)
        let $debug := trace ('jn-user')
        let $debug := trace ($jn-user)
    return
        db:add('users', $user, $user-id || '.xml')
};

declare function users:get-by-email ($email) as item() {
    let $user := db:get('users')//*[name()='email'][. = $email]
    return 
        if (count($user) = 1)
        then $user
        else if (count($user) = 0)
        then error((), 'User not found (0)')
        else error((), 'User not found (x)')
};

declare function users:create-unique-id () as xs:string {
    let $date-string := xs:string(current-dateTime())
    let $short-date-string := substring-after(substring-before($date-string, '\.'), '20')
    let $date-numbers := replace(replace(replace(replace(replace($short-date-string, 'T', ''), ':', ''), '+', ''), '-', ''), '\.', '')
    let $id := 'U' || $date-numbers
    return
         if (db:exists('users')/*[@id=$id])
         then users:create-unique-id()
         else $id
};