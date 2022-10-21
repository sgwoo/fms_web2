function OpenAmazonCAR(arg,end_dt,cur_dt,id){
	var SUBWIN = '';
	
	
	 if(arg=='5'){

			var theForm = document.flogin;
			var cookievalue = theForm.cv.value;
			
			setCookie("fmsCookie",cookievalue,1);	
			
			SUBWIN="/acct/menu/emp_frame.jsp";
			
		//	newwin=window.open("","ACCT","scrollbars=yes, status=yes, resizable=1");
		//	if (document.all){
		//		newwin.moveTo(0,0);
		//		newwin.resizeTo(screen.width,screen.height-50);
		//	}	
		//	newwin.location=SUBWIN;
		//	document.flogin.name.value="";
		//	document.flogin.passwd.value="";
		
			theForm.action = SUBWIN;
			theForm.submit();	
		
	}else if(arg=='4'){

		alert('�����ͺ��̽� �����Դϴ�. ����� �ٽ� �õ��Ͻʽÿ�');
		return;

	}	
//				window.resizeTo(100,100);
//				window.moveTo(-200,-200);

}

function setCookie(cName, cValue, cMinutes){

    cookies = cName + '=' + escape(cValue) + '; path=/ ; domain=.amazoncar.co.kr;';
    document.cookie = cookies;
    
}