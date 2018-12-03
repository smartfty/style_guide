class StoryDatatable < AjaxDatatablesRails::ActiveRecord

  def view_columns
    puts __method__
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      group: { source: "Story.group"},
      reporter: { source: "Story.reporter"},
      title: { source: "Story.title"},
    }
  end

  def data
    puts __method__

    records.map do |record|
      {
        # example:
        # id: record.id,
        group: record.group,
        reporter: record.reporter,
        title: record.title,
      }
    end
  end

  def get_raw_records
    puts __method__
    # insert query here
    Story.all
  end

end
