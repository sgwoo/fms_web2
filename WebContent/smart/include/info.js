function OpenAmazonCAR(arg,end_dt,cur_dt,id,attend_dt,loan_st,dept_id){
	var SUBWIN = '';
	
	//정상
	if(arg=='1'){
		
		var theForm = document.flogin;
		var cookievalue = theForm.cv.value;
		
		setCookie("fmsCookie",cookievalue,1);	
					
		if(dept_id == '1000')	{
			location.href="http://fms5.amazoncar.co.kr/agent/index.jsp";	
			alert('fms5���� �ٽ� �α����� �ּ���');
		}
		else if(dept_id == '8888')	{
			location.href="http://fms5.amazoncar.co.kr/off/index.jsp";	
			alert('fms5���� �ٽ� �α����� �ּ���');
		}else{
			location.href="/smart/main.jsp";	
		}
						
	//error
	}else if(arg=='4'){
		alert('�����ͺ��̽� �����Դϴ�. ����� �ٽ� �õ��Ͻʽÿ�!!');	
		return;
	}else if(arg=='3'){
	
	}else {
		alert('��ϵ� ����ڰ� �ƴմϴ�. Ȯ���ϼ���!!');
		return;
			
	}	
}

function setCookie(cName, cValue, cMinutes){

    cookies = cName + '=' + escape(cValue) + '; path=/ ; domain=.amazoncar.co.kr;';
    document.cookie = cookies;
    
}
