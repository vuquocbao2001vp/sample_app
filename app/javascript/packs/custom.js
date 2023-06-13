import Settings from "../settings";
$(document).ready(function() {
  $("#micropost_image").bind("change", function() {
    var size_in_megabytes = this.files[0].size/1024/1024;
    if (size_in_megabytes > Settings.max_image_size_5_MB) {
      alert(I18n.t("microposts.max_file_size_warning"));
    }
  });
})
