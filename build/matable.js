riot.tag('rtable', '<div class="rtable"> <raw r="cat&eacute;go&eacute;ie"></raw> <yield></yield> <table class="table table-striped" id="{opts[\'data-id\']}"> <tr class="{this.colHeaderClass}"> <th each="{c in this.colHeader}" data-column="{c.colName}" onclick="{this.parent.click_sort}"><raw r="{c.title}"></raw> <span class="glyphicon glyphicon-arrow-{c.sort}"></span> </th> </tr> <tr each="{ elem, i in this.data }" class="{this.parent.activeLine(i)}" onmouseover="{parent.lineOver }" > <td each="{ d in elem }" >{elem[d]}</td> </tr> </table> </div>', 'rtable table th {cursor:pointer} rtable span.glyphicon { padding-left:10px}', function(opts) {
    this.data         = [];
    this.data_bak     = [];
    this.sortOrder    = 'up';
    this.colHeader    = [];
    this.colExcluded  = [];
    this.colTitle     = {};
    this.lineFocus  = -1;
    this.colHeaderClass  = "";
    this.activeLineClass = '';
    this.colFilter    = '';
    this.valueFilter    = '';
    
    this.on('mount', function() {
      this.init(); 
    });
    
    this.init = function() {
       this.colHeaderClass  = this.opts.styles.colHeaderClass || this.colHeaderClass;
       this.activeLineClass = this.opts.styles.activeLineClass || this.activeLineClass;
       this.colFilter       = this.opts.colFilter || this.colFilter;
       this.valueFilter     = this.opts.valueFilter || this.valueFilter;
       this.colTitle        = this.opts.colTitle || this.colTitle;
       
       if (this.opts['colexcluded']) {
            this.colExcluded = this.opts['colexcluded'].replace(/ /g,'').split(',');
       }
       
       if (this.activeLineClass ==='') {
           this.activeLine = function() { return };
       }  
       
       riot.tag('raw', '<span></span>', function(opts) {   
           this.root.innerHTML = opts.r;
       });
       
    };
    
    this.formatTable = function () {
       var keys = Object.keys(this.data[0]);
       
       this.colHeader = [];
       for (var i=0, l=keys.length; i<l; i++) {
           this.colHeader.push({colName:keys[i], title: (this.colTitle[keys[i]] || keys[i]),    tri:''});
       }       
       
       var colexclude = this.colExcluded;
       _.each(this.data, function(elem) {
         for (i=0, l=colexclude.length; i<l; i++) {
            delete elem[colexclude[i]] ;
         }
       });
       
        this.colHeader = _.filter(this.colHeader, function(elem){
            return !_.contains(colexclude,elem.colName);
        });  

        if (this.opts.defaultSort) {
            this.sortTable(this.opts.defaultSort); 
        }
        this.update();        
    };
    

    this.start = function (data) {
        if (!data) {
           this.data = this.opts.data; 
        }else{
            this.data = data;
        }
       this.data_bak = this.data;
       this.filtrer();
       this.formatTable();
    };
   
    this.filtrer = function() {
       var colFilter = this.colFilter;
       var valueFilter = this.valueFilter;        
        
       if (colFilter === '') {
            this.data = this.data_bak;
       }else{
           var pos = valueFilter.indexOf("*");
           if (pos > -1 && pos === valueFilter.length-1)
           {    
               this.data = _.filter(this.data_bak, function(elem) {
                  var filval = valueFilter.replace('*',''); 
                  return (elem[colFilter].startsWith(filval)) ;
               });
           }else{
               this.data = _.filter(this.data_bak, function(elem) {
                  var r =  (elem[colFilter] == valueFilter) ;
                  console.log (elem[colFilter] + ' - ' + valueFilter + ' - ' + colFilter + ' - ' + r);
                  return r;
               });          
           }
       } 

       this.update();
    };
   
   
    this.tableau = function() {
        var indice = -1;
        var colExcluded =this.colExcluded;
        var $lignes = $('#'+opts['data-id']).children('tbody').children('tr');

        $lignes.children('th').each(function() {
            var c = $(this).attr('data-column');  
            if (c === ''  || _.contains(colExcluded,c)){
              indice = $(this).index();
              $(this).remove();



            }
        });
    };
     
    this.lineOver = function(e) {
        this.parent.lineFocus = e.item.i;
    };
    
    this.activeLine = function(i) {
        if (i == this.lineFocus)
        {
            return this.activeLineClass;
        }else{
            return '';
        }
    };
    
    this.click_sort = function(e) {

        var col = e.target.parentElement.getAttribute('data-column')
        this.parent.sortTable(col); 
    };
    
    
    this.sortTable = function(col) {
        if (col !== this.col) {
            this.sortOrder = 'up';
            this.col = col;
        }
        
        this.data = _.sortBy(this.data, col);
        
        if (this.sortOrder==="down") {
            this.sortOrder = 'up';
            this.data.reverse();
        }else{
            this.sortOrder = "down";
        };

        for (var i=0, l = this.colHeader.length; i < l; i++) {
            if (this.colHeader[i].colName === col) {
                this.colHeader[i].sort = this.sortOrder;  
            }else{
                this.colHeader[i].sort = '';
            }
        }
    };
    
    
});