/*
function click(e) {
  chrome.tabs.executeScript(null,
      {code:"Spincles();"});
  window.close();
}
*/

function click(e) {
  chrome.tabs.executeScript(null,
      {file:"spincles.js"});
  window.close();
}


document.addEventListener('DOMContentLoaded', function () {
  var divs = document.querySelectorAll('button');
  for (var i = 0; i < divs.length; i++) {
    divs[i].addEventListener('click', click);
  }
});