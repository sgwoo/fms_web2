//function OpenAmazonCAR(arg,open_type,dept_id){
function OpenAmazonCAR(arg,open_type,dept_id,id){	
	
	var SUBWIN = '';
			
	//����
	if(arg=='1'){
		
		var theForm = document.flogin;
		var cookievalue = theForm.cv.value;
			
		setCookie("fmsCookie",cookievalue,1);

	//	SUBWIN=getContextPath()+"/menu/emp_frame.jsp";
		
		SUBWIN="/agent/menu/emp_frame.jsp";
    		
  //      alert(id);
         
		if(dept_id == '1000')	{
				SUBWIN="https://fms5.amazoncar.co.kr/agent/menu/emp_frame.jsp";
				var addwin = location.host;
				
		//		if (id  == 'd4a7a7486b8b0568703b62e2cd08c477'  || id  == '94453a1d17d679cae1090c8ec0bfea0f' ) { //carbay (이현우), autodc( 유우재)
		//			if( addwin.indexOf("fms6") == -1 ){
		//				SUBWIN="https://fms6.amazoncar.co.kr/agent/index.jsp";				
		//			} else {
		//				SUBWIN="/agent/menu/emp_frame.jsp";
		//			}
					
		//		} else 	{			
					if( addwin.indexOf("fms5") == -1 ){
						SUBWIN="https://fms5.amazoncar.co.kr/agent/index.jsp";				
					}
		//		}
		}
		if(dept_id == '8888')	{
				SUBWIN="https://fms5.amazoncar.co.kr/off_web2/menu/emp_frame.jsp";
				var addwin = location.host;
				if( addwin.indexOf("fms5") == -1 ){
					SUBWIN="https://fms5.amazoncar.co.kr/off_web2/index.jsp";
			//	}else if( addwin.indexOf("dev") > -1){
			//		SUBWIN="/off/menu/emp_frame.jsp";
				}
		}	
		var window_name = "AGENT";
		
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
