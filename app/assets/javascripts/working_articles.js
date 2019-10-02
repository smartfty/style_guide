# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
//
// $(document).ready(function() {
//   $('#myBtn').on('click', function() { $('#edit_working_article_288').submit(); });
// });

jQuery ->
  $('#working_articles_story_subcategory_id').parent().hide()
  story_subcategory = $('#working_articles_story_subcategory_id').html()
  $('#working_articles_story_category_id').change ->
    story_category = $('#working_articles_story_category_id :selected').text()
    escaped_story_category = story_category.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
    options = $(story_subcategory).filter("optgroup[label='#{escaped_story_category}']").html()
    if options
      $('#working_articles_story_subcategory_id').html(options)
      $('#working_articles_story_subcategory_id').parent().show()
    else
      $('#working_articles_story_subcategory_id').empty()
      $('#working_articles_story_subcategory_id').parent().hide()
