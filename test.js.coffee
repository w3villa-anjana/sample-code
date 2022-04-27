$ ->
  $("#btn-remove-query-filter-for-spot-drafts").on "click", ->
    $("#spot-drafts-filter-form input[name='q']").val("")
    $("#spot-drafts-filter-form input[name='q']").closest("form").submit()

  $("#per_page").on "change", ->
    $("#spot-drafts-per-page").val($("#per_page").val())
    $("#spot-drafts-filter-form input[name='q']").closest("form").submit()
