var catalogillo = (function($, klass) {
  klass.catalog = klass.catalog || {};

  klass.catalog.category = {
    initialize : function() {
      klass.catalog.category.bindEventHandlers();
    },

    bindEventHandlers: function() {
      $('#sort_by').on('change', function(e){
        this.parentElement.submit();
      })
    }
  };
  return klass;
})(jQuery, catalogillo || {});
