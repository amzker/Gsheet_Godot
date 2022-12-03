# Gsheet_Godot
Connecting Google Sheet into godot with READ and WRITE access

# YouTube Video Tutorial

LINK WILL BE ADDED SOON

# Appsheet code
~~~
function json(sheetName) {
  const spreadsheet = SpreadsheetApp.openById("1h_KlXz9IWt2MtQQWYUSk4FJbIr02MbfXWU3ZRqY7U3I") //CHANGE WITH YOUR SHEET ID ( see url of you sheet d/)
  const sheet = spreadsheet.getSheetByName(sheetName)
  const data = sheet.getDataRange().getValues()
  const jsonData = convertToJson(data)
  return ContentService
        .createTextOutput(JSON.stringify(jsonData))
        .setMimeType(ContentService.MimeType.JSON)
}
function convertToJson(data) {
  const headers = data[0]
  const raw_data = data.slice(1,)
  let json = []
  raw_data.forEach(d => {
      let object = {}
      for (let i = 0; i < headers.length; i++) {
        object[headers[i]] = d[i]
      }
      json.push(object)
  });
  return json
}
function doGet(params) {
  const sheetname = params.parameter.sheetname
  return json(sheetname)
}

function doPost(params) {
  const datee = params.parameter.date
  const timee = params.parameter.time
  const catee = params.parameter.cate
  const amounte = params.parameter.amount
  const desce = params.parameter.desc
  const sheetname = params.parameter.sheetname

  
  if(typeof params !== 'undefined')
  Logger.log(params.parameter);

  var ss  = SpreadsheetApp.openById("1h_KlXz9IWt2MtQQWYUSk4FJbIr02MbfXWU3ZRqY7U3I") //CHANGE WITH YOUR SHEET ID ( see url of you sheet d/)
  var sheet = ss.getSheetByName(sheetname)
  var Rowtoenter = sheet.getLastRow()+1
  sheet.appendRow([datee,timee,catee,amounte,desce])
  

/* 
  var datecol = sheet.getRange(Rowtoenter,1)
  var timecol = sheet.getRange(Rowtoenter,2)
  var catecol = sheet.getRange(Rowtoenter,3)
  var amountcol = sheet.getRange(Rowtoenter,4)
  var descol = sheet.getRange(Rowtoenter,5)
  
  datecol.setValue(datee)
  timecol.setValue(timee)
  catecol.setValue(catee)
  amountcol.setValue(amounte)
  descol.setValue(desce)
*/
  
}
~~~
