function OpenAmazonCAR(arg,id){
	var SUBWIN = '';
		
	if(arg=='1'){//����
		SUBWIN="/cust/menu/main_frame.jsp";
		newwin=window.open(SUBWIN,"CUST_EMP","scrollbars=yes, status=yes, resizable=1");		
		if (document.all){
			newwin.moveTo(0,0);
			newwin.resizeTo(screen.width,screen.height-50);
		}	
		document.form1.name.value="";
		document.form1.passwd.value="";
	}else if(arg=='2'){
		alert('�����ͺ��̽� �����Դϴ�. ����� �ٽ� �õ��Ͻʽÿ�');
		return;
	}	
}
