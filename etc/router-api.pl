
return router {
    submapper('/', {controller => 'Root'})
        ->connect('me', {action => 'me' }) 
        ;

};
