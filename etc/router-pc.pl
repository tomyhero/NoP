
return router {
    submapper('/', {controller => 'Root'})
        ->connect('', {action => 'index' }) 
        ->connect('paste/{code}/', {action => 'detail' }) 
        ;

};
