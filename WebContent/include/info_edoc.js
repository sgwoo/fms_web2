function OpenAmazonCAR(arg){
	if(arg=='1'){
	   	var fm = document.form1;
	   	fm.action = fm.doc_url.value;
	   	fm.submit();
	}else if(arg=='2'){
		alert('error');
		return;
	}	
}
