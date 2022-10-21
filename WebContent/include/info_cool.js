function OpenAmazonCAR(arg,end_dt,cur_dt,id,url,attend_dt,loan_st,m_url){
	var SUBWIN = '';
	
	var s_width2 = screen.width;
	var s_height2 = screen.height;
		
	//정상
	if(arg=='1'){
		
			var theForm = document.flogin;
			var cookievalue = theForm.cv.value;
			
			setCookie("fmsCookie",cookievalue,1);		
			
			var window_name = "FMS";			
			
			SUBWIN="/fms2/menu/cool_frame.jsp?url="+url+"&s_width2="+s_width2+"&s_height2="+s_height2+"&m_url="+m_url;
			
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
						//	alert('self.close');
						//	self.close();
							self.open('about:blank','_self').close();
						}else{
							location.href = SUBWIN;						
						}
						
					}else{
						
						newwin=window.open(SUBWIN, window_name, "scrollbars=yes, status=yes,width="+screen.width+",height="+screen.height-50+", resizable=yes ");
						if (document.all){
							//newwin.moveTo(0,0);
							//newwin.resizeTo(screen.width,screen.height-50);
						}						
						//alert('window.close');				
						//window.close();
						window.open('about:blank','_self').close();
					}

			  }		
	
				
		/*		}else{			
					newwin=window.open(SUBWIN, window_name, "scrollbars=yes, status=yes, resizable=1");
					if (document.all){
						newwin.moveTo(0,0);
						newwin.resizeTo(screen.width,screen.height-50);
					}					
					self.opener=self;
					//window.close();				
				}			
*/

		
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

