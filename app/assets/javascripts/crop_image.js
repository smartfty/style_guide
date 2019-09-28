document.addEventListener("turbolinks:load", function() {
  // 변수 설정
  var $cropbox = $("#cropbox");
  var $dataX = $("#dataX");
  var $dataY = $("#dataY");
  var $dataW = $("#dataW");
  var $dataH = $("#dataH");
  var $getColumnNumber = $("#image_column").val();
  var $getRowNumber = $("#image_row").val();
  var $getLineNumber = $("#image_extra_height_in_lines").val();
  var $setWidth = $getColumnNumber * 171.496062992123;
  var $setHeight =
    $getRowNumber * 97.32283464566807 + $getLineNumber * 13.903262092238295;
  var cropBoxData;
  var canvasData;
  var saveCropData = $("#saveCropData");

  // 이벤트 핸들러 설정
  // 크롭박스 설정

  $cropbox.cropper({
    viewMode: 1,
    dragMode: "move",
    aspectRatio: $setWidth / $setHeight,
    autoCropArea: 1,
    restore: false,
    guides: true,
    center: false,
    highlight: true,
    cropBoxMovable: true,
    cropBoxResizable: false,
    toggleDragModeOnDblclick: false,
    modal: true,
    crop: e => {
      $dataX.val(Math.round(e.detail.x));
      $dataY.val(Math.round(e.detail.y));
      $dataW.val(Math.round(e.detail.width));
      $dataH.val(Math.round(e.detail.height));
    },
    ready: function() {
      var $getDataX = $dataX.val();
      var $getDataY = $dataY.val();
      var $getDataW = $dataW.val();
      var $getDataH = $dataH.val();
      $cropbox.cropper("setCropBoxData", {
        left: $getDataX,
        top: $getDataY,
        width: $getDataW,
        height: $getDataH
      });
    }
  });

  // 함수 기능 설정
  // 사진 사이즈를 동적으로 변경시 값을 가져오게 만들어야 한다.\
  // function imgCropping() {
  //   if (!croppable) {
  //     return false;
  //   }
  //   let croppedData = $image.cropper("getCroppedCanvas").toDataURL();
  //   $preview.attr("src", croppedData);
  // }
});
