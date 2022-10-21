function OpenAmazonCAR(arg,end_dt,cur_dt,id,attend_dt,loan_st,open_type,user_id,dept_id){
	var SUBWIN = '';
	
	//정상
	if(arg=='1'){
		
			var theForm = document.flogin;
			var cookievalue = theForm.cv.value;
			
			setCookie("fmsCookie",cookievalue,1);		

			SUBWIN="/fms2/menu/emp_frame.jsp";
						
										
			if(dept_id == '1000')	SUBWIN="/agent/menu/emp_frame.jsp";
			if(dept_id == '8888')	SUBWIN="/off/menu/emp_frame.jsp";
					
	//		alert(SUBWIN);
			
			var window_name = "EMP";
					
			//다중창 허용			
			if(theForm.name.value == "2005003" || theForm.name.value == "2002013"){
				today = new Date();
				window_name = "EMP"+today.getTime();				
			}
			
			//본인창열기 - 모바일기기
			if(theForm.open_type.value == '2'){
				theForm.action = SUBWIN;
				theForm.submit();			
			//팝업창열기 - 테스크탑(PC)
			}else{	
				if( opener != null ){
					
					var openerTitle = opener.top.document.title;
					
					if( openerTitle.indexOf("FMS") != -1 ){
						opener.top.location.href = SUBWIN;
						self.close();
					}else{
						location.href = SUBWIN;						
					}
					
				}else{				
					newwin=window.open(SUBWIN, window_name, "scrollbars=yes, status=yes, width="+screen.width+",height="+screen.height-50+", resizable=yes ");
					if (document.all){
						//newwin.moveTo(0,0);
						//newwin.resizeTo(screen.width,screen.height-50);
					}					
					//self.opener=self;
					window.close();
				}
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

