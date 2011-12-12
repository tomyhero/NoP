
jQuery.fn.extend({
    template : function(data){
        var tmpl_data = $(this).html();

        var fn = new Function("obj",
                     "var p=[];" +

                     // Introduce the data as local variables using with(){}
                     "with(obj){p.push('" +

                     // Convert the template into pure JavaScript
                    tmpl_data 
                     .replace(/[\r\t\n]/g, " ")
                     .split("<%").join("\t")
                     .replace(/(^|%>)[^\t]*?(\t|$)/g, function(){return arguments[0].split("'").join("\\'");})
                     .replace(/\t==(.*?)%>/g,"',$1,'")
                     .replace(/\t=(.*?)%>/g, "',(($1)+'').replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/\"/g,'&quot;'),'")
                     .split("\t").join("');")
                     .split("%>").join("p.push('")
                     + "');}return p.join('');");
        return fn( data );
            
    }

});

// firebug console..
if (window.console && window.console.log ) {
    window.log = window.console.log
} else {
    window.console = {
log: function () {}
    }
}

