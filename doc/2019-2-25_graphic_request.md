# Graphic Request

## Graphic Request using ActiveStorage

I have merged GraphicRequest into ReporterGraphic
GraphicRequest table is no longer needed.

ReporterGraphic
  has_many_attached :uploaded
  has_one_attached :finished_job


## uploading initial reporter_graphic
- case1 graphic from wire serive
    when graphic is selected from wire
    it gets attached as activestorage attachment in one of the uploads
- case2 graphic request with uploaded data
    mutiple files can be uploaded

## downloding initial reporter_graphic by designer
    chick one of the uploads and, it gets downloaded to designer's local machine

## uploading finished reporter_graphic by designer
    choose file and upload

## TODO

1. show reporter_graphic for last few days?
1. attach it wire-graphic as one of the uploads
    since we are showing preview attach highres
    download buttom to download highres
1. make it previewable
1. make it downloadable when clicked
1. upload finished_job

- 기자가 그래픽을 나의 그래픽으로 선택한 후 출고 하기전 디자이너에게 무조건 의뢰 하나?
- 아니면 기자가 의뢰를 뱔도로 해야 하나?

- where should it be stored?
  - in user directory?
  - in issue directory?
    1/graphic/user/date_file.pdf
- filename?
- attaching to story?
- relation with graphic?

- How to attach file to activestorage?
- How to show resizeable, previewable, download?
- Does mupdf convert AI files to jpg?
- How should we handle Hangul file?
- How is table copy pasted for Hangul text?
    it can show .txt files, so how can we do that with Hangul?