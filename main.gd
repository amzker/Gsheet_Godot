extends Node2D


onready var http = $HTTPRequest
var sheetname = "RESULTS"
var date = ""
var time = ""
var cate = ""
var amount = ""
var desc = ""
var respheader = ""
var SEND = false
var apiurl = "https://script.google.com/macros/s/AKfycbwNyfgHW1uRnNiw-8_8jrkPzKqffpDtHROVRsAQl2cD451qHlFq_kiyFQ8h3zil0y8EJg/exec"
var geturl = apiurl+"?sheetname="+sheetname

func _ready():
	getdata()
	
func getdata():
	$Label.text = "Fetching: "+sheetname
	$HTTPRequest.request(geturl)
	SEND = false

func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	if SEND:
		pass
	else:
		respheader = headers
		if response_code == 200:
			$Label.text = "Fetched: "+sheetname
			var data = body.get_string_from_utf8()
			data = data.replace("[","").replace("]","")
			data = parse_json(data)
			#print(data)
			$CASH_IN_HAND.text = "CASH IN HAND:  "+str(data["TOTAL_CASH_IN_HAND"])
			$TOTAL_INCOME.text = "TOTAL INCOME:  "+str(data["TOTAL_INCOME"])
			$TOTAL_EXPENSE.text = "TOTAL EXPENSE: "+str(data["TOTAL_EXPENSE"])
		else:
			print(response_code)
			$Label.text = "Trying again response code: "+str(response_code)
			getdata()

func _on_SEND_pressed():
	SEND = true
	$Label.text = "SENDING DATA"
	date = str($DATE.text)
	time = str($TIME.text)
	cate = $I_E.get_item_text($I_E.selected)
	amount = str($AMOUNT.text)
	desc = str($DESC.text)
	
	var datasend = "?date="+date+"&time="+time+"&cate="+cate+"&amount="+amount+"&desc="+desc
	var headers = ["Content-Length: 0"]
	var posturl = apiurl+datasend
	$HTTPRequest.request(posturl,headers,true, HTTPClient.METHOD_POST)
	SEND = true
	$Label.text = "SEND COMPLETED"


func _on_ref_pressed():
	getdata()


