function OpenAmazonCAR(arg,end_dt,cur_dt,id,attend_dt,loan_st,open_type,user_id,password){
	var SUBWIN = '';
	
	//����
	if(arg=='1'){
		
			var theForm = document.flogin;
					

			SUBWIN="/acar/menu/emp_frame.jsp";
			
			var window_name = "EMP";
					
			//����â ���		
			if(theForm.name.value == "2005003" || theForm.name.value == "2002013"){
				today = new Date();
				window_name = "EMP"+today.getTime();				
			}
			
			//����â���� - ����ϱ��
			if(theForm.open_type.value == '2'){
				theForm.action = "/acar/menu/emp_frame.jsp";
				theForm.submit();			
			//�˾�â���� - �׽�ũž(PC)
			}else{			
				newwin=window.open(SUBWIN, window_name, "scrollbars=yes, status=yes, resizable=1");
				if (document.all){
					newwin.moveTo(0,0);
					newwin.resizeTo(screen.width,screen.height-50);
				}					
				self.opener=self;
				window.close();				
			}			



	//����
	}else if(arg=='4'){
		alert('�����ͺ��̽� �����Դϴ�. ����� �ٽ� �õ��Ͻʽÿ�');
		return;
	}	
}
