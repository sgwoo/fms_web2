function OpenAmazonCAR(arg,id,open_type,dept_id){
	var SUBWIN = '';
	
	//정상
	if(arg=='1'){
		
			var theForm = document.flogin;
			var cookievalue = theForm.cv.value;
			
			setCookie("fmsCookie",cookievalue,1);		

			SUBWIN="/fms2/menu/emp_frame.jsp";
			
			// it팀은  fms1, fms5, fms6  사용가능  
		//	if( dept_id == '0005'  )	{
							 		
		//	} else if(dept_id == '0003' || dept_id == '0020' )	{  // 총무팀 , 영업기획팀   - fms1, fms5 사용 가능 
			 if( dept_id == '0005'  || dept_id == '0003' || dept_id == '0020' )	{  // 총무팀 , 영업기획팀   - fms1, fms5 사용 가능 	
				var addwin = location.host;
				
			//	if( addwin.indexOf("fms6") > -1 ){  //있다면  fms1 으로
			//		SUBWIN="https://fms1.amazoncar.co.kr/fms2/index.jsp";
			//	}
				
			} else if(dept_id == '1000')	{  //agent
					SUBWIN="https://fms5.amazoncar.co.kr/agent/menu/emp_frame.jsp";
					var addwin = location.host;
					if( addwin.indexOf("fms5") == -1 ){
						SUBWIN="https://fms5.amazoncar.co.kr/agent/index.jsp";
				//	}else if( addwin.indexOf("dev") > -1){
				//		SUBWIN="/agent/menu/emp_frame.jsp";
					}
			} else if(dept_id == '8888')	{ //off_web2 
				SUBWIN="https://fms5.amazoncar.co.kr/off_web2/menu/emp_frame.jsp";
				var addwin = location.host;
				if( addwin.indexOf("fms5") == -1 ){
					SUBWIN="https://fms5.amazoncar.co.kr/off_web2/index.jsp";
			//	}else if( addwin.indexOf("dev") > -1){
			//		SUBWIN="/off/menu/emp_frame.jsp";
				}
		 
			} else {
				SUBWIN="https://fms1.amazoncar.co.kr/fms2/menu/emp_frame.jsp";
				var addwin = location.host;
				if( addwin.indexOf("fms1") == -1 ){
					SUBWIN="https://fms1.amazoncar.co.kr/fms2/index.jsp";
			//	}else if( addwin.indexOf("dev") > -1){
			//		SUBWIN="/fms2/menu/emp_frame.jsp";
				}								
			}
												
			var window_name = "FMS";
						
			//본인창열기 - 모바일기기
			if(theForm.open_type.value == '2'){
				theForm.action = SUBWIN;
				theForm.submit();			
			//팝업창열기 - 테스크탑(PC)
			}else{	
				theForm.action = SUBWIN;
				theForm.submit();							
			}			



	//에러
	}else if(arg=='4'){
		alert('데이터베이스 오류입니다. 잠시후 다시 시도하십시오');
		return;
	}	
}

function setCookie(cName, cValue, cMinutes){

    cookies = cName + '=' + escape(cValue) + '; path=/ ; domain=.amazoncar.co.kr;';
    document.cookie = cookies;
    
}

