module namespace sign-xf = "http://www.architextus.com/xquery/library/users-management/sign-xf";

declare namespace db = 'http://basex.org/modules/db';
declare namespace file = 'http://expath.org/ns/file';
declare namespace map = 'http://www.w3.org/2005/xpath-functions/map';
declare namespace output = 'http://www.w3.org/2010/xslt-xquery-serialization';
declare namespace rest = "http://exquery.org/ns/restxq";

declare %rest:path('/user/form/sign-in')
   %rest:GET
   %rest:query-param('http-context', '{$http-context}', '')
   %output:method("html")
   %output:html-version("5.0")
function sign-xf:sign-in-form($http-context as xs:string) {
    <div class="sign-x">
      <div>
         <h1>Sign in</h1>
         <form class="req-and-refresh-page" data-http-req="/node/handlebars/user/sign-in" method="post" data-res-id="res-sign-in">
             <div style="display:none;"><input name="http-context" value="{$http-context}"/></div>
             <div class="entry input">
                 <label for="email">Email</label>
                 <input autocomplete="email" id="email" name="email" value="" type="email" required="required"/>
             </div>
             <div class="entry input">
                 <label for="pass">Password</label>
                 <input autocomplete="current-password" id="pass" name="pass" type="password" required="required"/>
             </div>
             <div class="redirect-link"><a href="./sign-up">Not registered? Sign up!</a></div>
             <div class="redirect-link"><a href="./reset-password">Forgot password?</a></div>
             <button type="submit">Sign in</button>
         </form>
        
         <div class="res" id="res-sign-in"></div>
      </div>
    </div>
};

declare %rest:path('/user/form/sign-up')
   %rest:GET
   %rest:query-param('http-context', '{$http-context}', '')
   %output:method("html")
   %output:html-version("5.0")
function sign-xf:sign-up-form($http-context as xs:string) {
    <div class="sign-x">
      <div>
         <h1>Sign up</h1>
         <form class="req-and-update-res" data-http-req="/user-mngt/user/create" method="post" data-res-id="res-sign-up">
            <div style="display:none;"><input name="http-context" value="{$http-context}"/></div>
            <div class="entry input">
                <label for="fname">First name *</label>
                <input autocomplete="given-name" id="fname" name="fname" required="required"/>
            </div>
            <div class="entry input">
                <label for="mname">Middle name</label>
                <input autocomplete="additional-name" id="mnname" name="mname"/>
            </div>
            <div class="entry input">
                <label for="lname">Last name</label>
                <input autocomplete="family-name" id="lname" name="lname"/>
            </div>
            <div class="entry input">
                <label for="email">Email *</label>
                <input autocomplete="email" id="email" name="email" type="email" required="required"/>
            </div>
            <div class="entry input">
                <label for="pass">Password *</label>
                <input autocomplete="new-password" id="pass" name="pass" type="password" required="required"/>
            </div>
            <div class="entry input">
                <label for="pass2">Confirm password *</label>
                <div class="must-match-message info" style="display: none;">Passwords must match</div>
                <input autocomplete="new-password" id="pass2" type="password" required="required" data-must-match-id="pass"/>
            </div>
            <button type="submit">Sign up</button>
         </form>
         <div class="res" id="res-sign-up"></div>
      </div>
    </div>
};