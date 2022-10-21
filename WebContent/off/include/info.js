function OpenAmazonCAR(arg,open_type,dept_id,id){
	
	var SUBWIN = '';
	
	
	//����
	if(arg=='1'){
		
		var theForm = document.flogin;
		var cookievalue = theForm.cv.value;
		
	
	 //id:	573fccf69dda928b647882c9a707f13f - 아마존탁송 , 09828f7d40d2975a95e9bc447e61179b :이의상   	f8b2e0ce67c966e4f9394864d8ba0d1b:강지현(과태료)
		setCookie("fmsCookie",cookievalue,1);	
			
		SUBWIN="/off/menu/emp_frame.jsp";
		//협력업체는 fms5로 : 
       
		if(dept_id == '1000')	{
				SUBWIN="http://fms5.amazoncar.co.kr/agent/menu/emp_frame.jsp";
				var addwin = location.host;
				if( addwin.indexOf("fms5") == -1 &&  addwin.indexOf("dev") == -1){
					SUBWIN="http://fms5.amazoncar.co.kr/agent/index.jsp";
				}else if( addwin.indexOf("dev") > -1){
					SUBWIN="/agent/menu/emp_frame.jsp";
				}
		}
		
		if(dept_id == '8888')	{
				SUBWIN="http://fms5.amazoncar.co.kr/off_web2/menu/emp_frame.jsp";
				var addwin = location.host;
			
				if( addwin.indexOf("fms5") == -1 &&  addwin.indexOf("dev") == -1 && (id != '09828f7d40d2975a95e9bc447e61179b' && id != '573fccf69dda928b647882c9a707f13f' ) ){
					SUBWIN="http://fms5.amazoncar.co.kr/off_web2/index.jsp";
			
				}else if( addwin.indexOf("dev") > -1  || (id == '09828f7d40d2975a95e9bc447e61179b' || id == '573fccf69dda928b647882c9a707f13f'  )  ){
				//	SUBWIN="/off_web2/menu/emp_frame.jsp";
					SUBWIN="http://fms5.amazoncar.co.kr/off_web2/menu/emp_frame.jsp";
					
				}
		}
		
		var window_name = "OFF";
		

		//����â���� - ����ϱ��
		if(theForm.open_type.value == '2'){
			theForm.action = SUBWIN;
			theForm.submit();
		//�˾�â���� - �׽�ũž(PC)
		}else{
			theForm.action = SUBWIN;
			theForm.submit();	
			/*
			newwin=window.open(SUBWIN, window_name, "scrollbars=yes, status=yes, resizable=1");
			if (document.all){
				newwin.moveTo(0,0);
				newwin.resizeTo(screen.width,screen.height-50);
			}
			self.opener=self;
			window.close();
			*/
		}
	//����
	}else if(arg=='4'){
		alert('�����ͺ��̽� �����Դϴ�. ����� �ٽ� �õ��Ͻʽÿ�');
		return;
	}	
}

function setCookie(cName, cValue, cMinutes){

    cookies = cName + '=' + escape(cValue) + '; path=/ ; domain=.amazoncar.co.kr;';
    document.cookie = cookies;
    
}