# Gsheet_Godot
Connecting Google Sheet into godot with READ and WRITE access

# YouTube Video Tutorial

[![VIDEO](https://img.youtube.com/vi/jeg0boRWdxM/0.jpg)](https://www.youtube.com/watch?v=jeg0boRWdxM)

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

# READING DATA FROM SHEET [GET]

```
#geturl = Your appscirpt web app url + ?sheetname=YourSheetname
#apiurl = Your appscript web app url 
var apiurl = "https://script.google.com/macros/s/AKfycbwNyfgHW1uRnNiw-8_8jrkPzKqffpDtHROVRsAQl2cD451qHlFq_kiyFQ8h3zil0y8EJg/exec"
var geturl = apiurl+"?sheetname="+sheetname

func getdata():
  $HTTPRequest.request(geturl)

func _on_HTTPRequest_request_completed(result, response_code, headers, body):
			var data = body.get_string_from_utf8()
			data = data.replace("[","").replace("]","")
			data = parse_json(data)
			#print(data)
			print(data["TOTAL_CASH_IN_HAND"]) # you can access data based on key name 
```

# SENDING DATA/WRITING DATA TO SHEET [POST]
```
var sheetname = DATA # name of sheet in which you want to add data
#this is just example variables
#date, time, cate, amount, desc = 12/11/22,08:15,INCOME,250,SOAP
var datasend = "?date="+date+"&time="+time+"&cate="+cate+"&amount="+amount+"&desc="+desc+"&sheetname="+sheetname #LOOK into appsheet code's doPost func to understand this 
var headers = ["Content-Length: 0"]
var posturl = apiurl+datasend
$HTTPRequest.request(posturl,headers,true,HTTPClient.METHOD_POST)
```
