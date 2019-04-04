json.set! :data do
  json.array! @exeprt_writers do |exeprt_writer|
    json.partial! 'exeprt_writers/exeprt_writer', exeprt_writer: exeprt_writer
    json.url  "
              #{link_to 'Show', exeprt_writer }
              #{link_to 'Edit', edit_exeprt_writer_path(exeprt_writer)}
              #{link_to 'Destroy', exeprt_writer, method: :delete, data: { confirm: '정말 삭제하시겠습니까??' }}
              "
  end
end