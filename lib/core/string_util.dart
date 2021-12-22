class StringUtil {
  static String getUrlForRunPlatform(String imageUrl) {
    if (imageUrl.isNotEmpty && imageUrl.contains("localhost")) {
      imageUrl = imageUrl.replaceAll("localhost", "10.0.2.2");
    }
    return imageUrl;
  }

  static String getSanitizedContent(String htmlContent) {
    htmlContent = htmlContent.replaceAll(RegExp("<(.*?)\\>"), "");
    htmlContent = htmlContent.replaceAll(RegExp("<(.*?)\\\n"), "");
    htmlContent = htmlContent.replaceAll(RegExp("(.*?)\\>"), "");
    htmlContent = htmlContent.replaceAll(RegExp("&nbsp"), "");
    htmlContent = htmlContent.replaceAll(RegExp("&amp"), "");

    return htmlContent;
  }
}
