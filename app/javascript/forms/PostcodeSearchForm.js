////
// Adds event listeners to postcode_search form and displays output to users


////
// Display text output to user
//
// text - The String to display
//
// Returns void
function displayOutput(text) {
  const output = document.querySelector('.postcode_search__output')
  output.innerHTML = text;
}

function onSubmit() {
  displayOutput(`Searching...`)
}

function onSuccess(event) {
  const [data, _status, _xhr] = event.detail
  if (data.in_service_area) {
    displayOutput(`Great! We service your area ${data.lsoa}!`)
  } else {
    displayOutput(`Sorry! We don't service your area '${data.lsoa}' yet`)
  }
}

function onError(event) {
  const [data,_status, _xhr] = event.detail;
  const input = document.querySelector(".postcode_search__input")
  displayOutput(`Error! '${input.value}' ${data["errors"]["postcode"]}`)
}

////
// Callback method fired when page loads. Adds event listeners to form elements
function init() {
  const form = document.querySelector('.postcode_search');
  if (form == null || form == undefined) { return }

  // Display a message while waiting to hear back from server...
  form.addEventListener("ajax:before", onSubmit);

  // Display feedback when server responds 200
  form.addEventListener("ajax:success", onSuccess);

  // Display feedback when server responds 4--
  form.addEventListener("ajax:error", onError);
}

export { init };
