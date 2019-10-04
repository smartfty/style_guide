// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require datatables
//= require bootstrap-sprockets
//= require jcrop
//= require moment
//= require activestorage
//= require_tree .

jQuery(function() {
  var subcategory_code;
  $('#working_article_subcategory_code').parent().hide();
  subcategory_code = $('#working_article_subcategory_code').html();
  console.log(subcategory_code);
  return $('#working_article_category_code').change(function() {
    var category_code, escaped_category, options;
    category_code = $('#working_article_category_code :selected').text();
    escaped_category = category_code.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1');
    options = $(subcategory_code).filter("optgroup[label=" + escaped_category + "]").html();
    console.log(options);
    if (options) {
      $('#working_article_subcategory_code').html(options);
      return $('#working_article_subcategory_code').parent().show();
    } else {
      $('#working_article_subcategory_code').empty();
      return $('#working_article_subcategory_code').parent().hide();
    }
  });
});