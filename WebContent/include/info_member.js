function OpenAmazonCAR(arg,id){
	var SUBWIN = '';
		
	if(arg=='1'){//정상
		SUBWIN="/cust/menu/main_frame.jsp";
		newwin=window.open(SUBWIN,"CUST_EMP","scrollbars=yes, status=yes, resizable=1");		
		if (document.all){
			newwin.moveTo(0,0);
			newwin.resizeTo(screen.width,screen.height-50);
		}	
		document.form1.name.value="";
		document.form1.passwd.value="";
	}else if(arg=='2'){
		alert('데이터베이스 오류입니다. 잠시후 다시 시도하십시오');
		return;
	}	
}
