<rtable>
    <div class="rtable" id="rtable-{opts['id']}">
        <yield/>
        <table class="{this.styles.tableClass}" id="table-{opts['id']}"> 
            <thead>
            <tr class="{this.styles.colHeaderClass}"> 
                <th class="header-{c.colName} header-sort{c.sort}" each={c in this._colHeader} data-column="{c.colName}" onclick="{this.parent._click_sort}"><raw r="{c.title}"></raw> <span class="{parent.styles['sort'+c.sort+'Class']}"></span>  </th>           
             </tr> 
            </thead>
            <tbody>
            <tr each={ elem, i in this._data } class="{this.parent._activeLine(i)}" onmouseover="{parent._lineOver }"  >
                <td class="col-{d} {this.parent.parent._isActiveSort(d)}" each={ d, val in this.parent._colList } >{elem[d]}</td>
            </tr>  
            </tbody>
        </table>
   </div>
       
    <style>
        rtable table th {cursor:pointer}
    </style>
    
    <script>
    this._data        = [];
    this._data_bak    = [];    
    this._filter      = {column:'', value:''};
    this._sort        = {column:'', order:''};
    this._colExcluded = [];    
    this._colList     = [];  
    this._colHeader   = [];
    this._colTitle    = {};
    this._lineFocus   = -1; 
    this._activeColSort='';
    
    this.styles       = {tableClass:"", 
                        colHeaderClass:"", 
                        activeLineClass:"",
                        sortUpClass:"",
                        sortDownClass:"",
                        activeSortClass : ''
                    };

    this.on('mount', function() {
      this.init(); 
    });
    
    this.init = function() {
       var styles           = this._convertOpts(this.opts.styles, true);
       this.styles          = this._mergeOptions(this.styles, styles);
       
       this._filter          = this.opts.filter  || this._filter;
       this._filter          = this._convertOpts(this._filter);
       
       this._sort            = this.opts.sort || {'column':'','order':''};
       this._sort            = this._convertOpts(this._sort);
       
       this._colTitle        = this.opts.coltitle || this._colTitle;
       this._colTitle        = this._convertOpts(this._colTitle);
       
       if (this.opts['colexcluded']) {
            this._colExcluded = this.opts['colexcluded'].replace(/ /g,'').split(',');
       }
   
       if (this.styles.activeLineClass ==='') {
           this._activeLine = null;
           this._lineOver   = null;
       }  
       
       riot.tag('raw', '<span></span>', function(opts) {   
           this.root.innerHTML = opts.r;
       });
       
       if ( (this.opts.autoload || 'yes') === 'yes') {
             this.start();
       }
       
       return this;
    };

    this.start = function (data, cloneData) {
       if(!data) {
           this.loadData(this.opts.data,(this.opts.clonedata || 'no') );
       }else{
           this.loadData(data, cloneData || 'no'); 
       }
       
       this.filterTable();
       this.rebuildTable(this.opts['collist']);
       this.sortTable({column:this._sort.column, order:this._sort.order});
       this.update();
       return this;
    };
    
    this.loadData = function(data, cloneData){
        if ((cloneData || 'no') === 'no') {
              this._data = data;
        }else{
              this._data = this._deepCopy(data); 
        }
       this._data_bak = this._data;
       return this;
    };
    
    this.rebuildTable = function(colList) {
        if (colList) {
            if (typeof(colList)==='string') {
                this._colList = colList.replace(/ /g,'').split(',');
            }else{
                this._colList = colList;
            }
        }
        this._formatTable();
        return this;
        
    };
  
    this.filterTable = function(filterObject) {
        
       if (filterObject && filterObject.column && filterObject.value) {
           this._filter.column = filterObject.column;
           this._filter.value  = filterObject.value;
           this._filter.append = filterObject.append;
       }  
        
       var colFilter   = this._filter.column,
           valueFilter = this._filter.value,
           append      = this._filter.append || 'no';
        
       if (colFilter === '') {
            this._data = this._data_bak;
       }else{
           var pos = valueFilter.indexOf("*");
           var dataTofilter = (append === 'yes' ? this._data : this._data_bak);
           
           if (pos > -1 && pos === valueFilter.length-1)
           {    
               this._data = _.filter(dataTofilter, function(elem) {
                  var filval = valueFilter.replace('*',''); 
                  return (elem[colFilter].startsWith(filval)) ;
               });
           }else{
               this._data = _.filter(dataTofilter, function(elem) {
                  return (elem[colFilter] == valueFilter) ;
               });          
           }
       }
       this._cleanData();
       return this;
    };
    
    this.clearFilter = function() {
        this._filter.column='';
        this.filterTable();
        return this;
    };
   
    this.sortTable = function(sortObject) {
        var col ='';
        
        if (sortObject && sortObject.column) {
           col = sortObject.column;
           if (sortObject.order) {
               this._sort.order = sortObject.order;
           }
        } 
        
        if (col==='') {
            return;
        }
        
        if (this._sort.column !== col) {
            this._sort.column = col;
        }

        var ordre =this._sort.order;
        var colonne = this._sort.column; 
        this._activeColSort = this._sort.column;
        this._data = this._data.sort(function(elem1, elem2) {
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
        
        //this._data = _.sortBy(this._data,colonne);
        if (this._sort.order==="Down") {
            this._sort.order = 'Up';
             //this._data.reverse();
        }else{
            this._sort.order = "Down";
        };

        for (var i=0, l = this._colHeader.length; i < l; i++) {
            if (this._colHeader[i].colName === col) {
                this._colHeader[i].sort = this._sort.order;  
            }else{
                this._colHeader[i].sort = '';
            }
        }
       return this;
    };
     
    this._isActiveSort = function(colName) {
        if (colName === this._activeColSort) {
            return this.styles.activeSortClass || '';
        }else{
            return '';
        }
    };
    
    this._cleanData = function() {
       var colexclude = this._colExcluded;
       _.each(this._data, function(elem) {
         for (i=0, l=colexclude.length; i<l; i++) {
            delete elem[colexclude[i]] ;
         }
       });
    };

    this._lineOver = function(e) {
        this.parent._lineFocus = e.item.i;
    };
    
    this._activeLine = function(i) {
        return (i === this._lineFocus ? this.styles.activeLineClass : '');
    };
    
    this._click_sort = function(e) {
        var col = e.target.parentElement.getAttribute('data-column');
        if (!col) {
            return;
        }
        
        var sortOrder = _.where(this.parent._colHeader, {colName: col});
        
        if(!sortOrder){
            return;
        }
        
        sortOrder = sortOrder[0].sort || 'Up';
        this.parent.sortTable({column:col, order: sortOrder}); 
    };    
    
    this._tableau = function() {
        var indice = -1;
        var colExcluded =this._colExcluded;
        var $lignes = $('#'+opts['data-id']).children('tbody').children('tr');

        $lignes.children('th').each(function() {
            var c = $(this).attr('data-column');  
            if (c === ''  || _.contains(colExcluded,c)){
              indice = $(this).index();
              $(this).remove();
              //$lignes.each(function() {
              //   $(this).children("td:eq(" + indice + "), th:eq(" + indice+")").remove();
              //});  
            }
        });
    }; 
    
    this._formatTable = function () {
       var colExist = false;
       if (this._colList.length>0)
       {
           var keys = this._colList;
           colExist = true;
       }else{
           var keys = Object.keys(this._data[0]);
       }
       
       this._colHeader = [];
       for (var i=0, l=keys.length; i<l; i++) {
            this._colHeader.push({colName:keys[i], title: (this._colTitle[keys[i]] || keys[i]), sort:''});
            if (!colExist) {this._colList.push(keys[i]);}
       }       
       this._cleanData();
       var colexcluded = this._colExcluded;
       this._colHeader = _.filter(this._colHeader, function(elem){
           return !_.contains(colexcluded, elem.colName);
       });  
     
       this.update();        
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
   
   this._mergeOptions = function (obj1,obj2){
    var obj3 = {};
    for (var attrname in obj1) { obj3[attrname] = obj1[attrname]; }
    for (var attrname in obj2) { obj3[attrname] = obj2[attrname]; }
    return obj3;
   }; 
   
   
   this._deepCopy1 = function (obj) {
    if (Object.prototype.toString.call(obj) === '[object Array]') {
        var out = [], i = 0, len = obj.length;
        for ( ; i < len; i++ ) {
            out[i] = arguments.callee(obj[i]);
        }
        return out;
    }
    if (typeof obj === 'object') {
        var out = {}, i;
        for ( i in obj ) {
            out[i] = arguments.callee(obj[i]);
        }
        return out;
    }
    return obj;
  };
   
  this._deepCopy = function(obj) {
     return _.map(obj, _.clone);   
  } ;

  </script>
</rtable>