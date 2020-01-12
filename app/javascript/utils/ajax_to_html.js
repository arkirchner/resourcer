export default function ajaxToHtml(data) {
  const [,, xhr] = data.detail || data;

  return xhr.responseText;
}
