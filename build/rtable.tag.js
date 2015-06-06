riot.tag('rtable', '<div class="rtable" id="rtable-{opts[\'id\']}"> <yield></yield> <table class="{this.styles.tableClass}" id="{table-opts[\'id\']}"> <tr class="{this.styles.colHeaderClass}"> <th class="header-{c.colName} header-sort{c.sort}" each="{c in this.colHeader}" data-column="{c.colName}" onclick="{this.parent._click_sort}"><raw r="{c.title}"></raw> <span class="{parent.styles[\'sort\'+c.sort+\'Class\']}"></span> </th> </tr> <tr each="{ elem, i in this.data }" class="{this.parent._activeLine(i)}" onmouseover="{parent._lineOver }" > <td class="col-{d} {this.parent.parent._isActiveSort(d)}" each="{ d, val in elem }" >{val}</td> </tr> </table> </div>', 'rtable table th {cursor:pointer}', function(opts) {
    this.data         = [];
    this.data_bak     = [];
    this.sortOrder    = 'Up';
    this.colHeader    = [];
    this.colExcluded  = [];
    this.colTitle     = {};
    this.lineFocus    = -1;
    this.filter       = {column:'', value:''};
    this.sort         = {column:'', order:''};
    this.col          = '';
    this.activeColSort='';
    
    this.on('mount', function() {
      this.init(); 
    });
    
    this.init = function() {
       this.styles          = this._convertOpts(this.opts.styles,true);
       
       this.filter          = this.opts.filter  || this.filter;
       this.filter          = this._convertOpts(this.filter);
       
       this.sort            = this.opts.sort || this.sort;
       this.sort            = this._convertOpts(this.sort);
       
       this.colTitle        = this.opts.colTitle || this.colTitle;
       
       if (this.opts['colexcluded']) {
            this.colExcluded = this.opts['colexcluded'].replace(/ /g,'').split(',');
       }
       
       if (this.styles.activeLineClass ==='') {
           this._activeLine = null;
           this._lineOver = null;
       }  
       
       riot.tag('raw', '<span></span>', function(opts) {   
           this.root.innerHTML = opts.r;
       });
    };
    
    this.formatTable = function () {
       var keys = Object.keys(this.data[0]);
       
       this.colHeader = [];
       for (var i=0, l=keys.length; i<l; i++) {
           this.colHeader.push({colName:keys[i], title: (this.colTitle[keys[i]] || keys[i]), sort:''});
       }       
       
        this._cleanData();
        var colexcluded = this.colExcluded;
        this.colHeader = _.filter(this.colHeader, function(elem){
            return !_.contains(colexcluded, elem.colName);
        });  
     
        this.update();        
    };
    

    this.start = function (data) {
        if (!data) {
           this.data = this.opts.data; 
        }else{
            this.data = data;
        }
       this.data_bak = this.data;
       this.filterTable();
       
       this.formatTable();
       this.sortTable(this.sort.column);
       this.update();
       
    };
  
    this.filterTable = function() {
       var colFilter = this.filter.column;
       var valueFilter = this.filter.value;        
        
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
                  return (elem[colFilter] == valueFilter) ;
               });          
           }
       } 
       
       this._cleanData();
       this.update();
    };
   
    this.sortTable = function(col) {
        if (this.sort.column !== col) {
            this.sort.column = col;
        }

        var ordre =this.sort.order;
        var colonne = this.sort.column; 
        
        this.activeColSort = this.sort.column;
        
         
        this.data = this.data.sort(function(elem1, elem2) {
            var e1 = elem1[colonne];
            var e2 = elem2[colonne]; 
            if (!isNaN(Number(e1) && !isNaN(Number(e2))))   
            {   
                e1 = Number(e1);
                e2 = Number(e2);
            }
            
            if (e1 < e2) {
                return (ordre==='Down' ? 1 :-1);
            }else{
                return (ordre==='Up'? 1 : -1);
            }
        });

        if (this.sort.order==="Down") {
            this.sort.order = 'Up';

        }else{
            this.sort.order = "Down";
        };

        for (var i=0, l = this.colHeader.length; i < l; i++) {
            if (this.colHeader[i].colName === col) {
                this.colHeader[i].sort = this.sort.order;  
            }else{
                this.colHeader[i].sort = '';
            }
        }
    };
     
    this._isActiveSort = function(colName) {
        console.log(colName);
        if (colName === this.activeColSort) {
            return this.opts.styles.activeSortClass || '';
        }else{
            return '';
        }
    }
    
    
    this._cleanData = function() {
       var colexclude = this.colExcluded;
       _.each(this.data, function(elem) {
         for (i=0, l=colexclude.length; i<l; i++) {
            delete elem[colexclude[i]] ;
         }
       });
    };

    this._lineOver = function(e) {
        this.parent.lineFocus = e.item.i;
    };
    
    this._activeLine = function(i) {
        return (i === this.lineFocus ? this.styles.activeLineClass : '');
    };
    
    this._click_sort = function(e) {
        var col = e.target.parentElement.getAttribute('data-column');
        this.parent.sortTable(col); 
    };    
    
    this._tableau = function() {
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
    
    this._convertOpts = function(opt, noStripBlank) {
        if (!opt) {
            return;
        };
        if (typeof(opt)==='object') { 
            return opt;
        }else{
            var r = opt;
            if (!noStripBlank) {
                r = r.replace(/ /g,'');
            }else{
                r = r.replace(/, /,',');
            }
            var r = r.split(',') ;
            var o = {};
            for (var i=0,l = r.length;i<l;i++) {
               var t = (r[i].split(':')); 
               o[t[0].replace(/ /g,'')] = t[1].trim(); 
            }
            return o;
        }
   };
    
    
    
});