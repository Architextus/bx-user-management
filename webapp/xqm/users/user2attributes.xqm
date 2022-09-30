module namespace flatjson = "http://www.architextus.com/xquery/library/users-management/user2att";

declare function flatjson:transform($nodes as node()*) as xs:string {
    string-join((
        for $node in $nodes
        let $level := 
            typeswitch($node)
            case document-node() return  flatjson:transform($node/node())
            case text() return $node
            case attribute() return 
                '"' || $node/name() || '":"' || data($node) || '"'
            (: TODO: support attribute not just in user, but in all, need to  when to ass coma: when att and children :)
            case element (user) return
                let $attr := flatjson:transform($node/@*)
                let $down := flatjson:transform($node/node())
                let $debug := trace('ATTRIBUTES: ' || $attr)
                return
                    if (normalize-space($attr) = '' and normalize-space($down) = '')
                    then ()
                    else if (normalize-space($attr) = '')
                    then '{' || $down || '}'
                    else '{' || $attr || ', ' || $down || '}'
            (: TODO: Make emails and roles values arrays. Condition is if children have the same name? :)
            case element() return 
                 let $down := flatjson:transform($node/node())
                 (: IMPORTANT: We assume no complex type, so only text or children, never both:)   
                 return 
                    if (count($node/child::*) > 0)
                    then '"' || $node/name() || '":{' || $down ||  '}' 
                    else '"' || $node/name() || '":"' || $down || '"'
            default return ()
        let $debug := trace ('Returning ' || string-join($level, ', '))
        return string-join($level, ', ')), 
        ', ')
};
