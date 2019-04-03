json.set! :data do
  json.array! @exert_writers do |exert_writer|
    json.partial! 'exert_writers/exert_writer', exert_writer: exert_writer
    json.url  "
              #{link_to 'Show', exert_writer }
              #{link_to 'Edit', edit_exert_writer_path(exert_writer)}
              #{link_to 'Destroy', exert_writer, method: :delete, data: { confirm: '정말 삭제하시겠습니까??' }}
              "
  end
end