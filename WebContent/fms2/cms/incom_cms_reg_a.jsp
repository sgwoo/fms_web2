<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.admin.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //����
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	//System.out.println("user_id=" + user_id);	
	//cms incom ����Ÿ ����
	String adate 	= request.getParameter("adate")==null?"":request.getParameter("adate");//����Ƿ�����	
	//String r_adate 	= ad_db.getValidDt(adate); //���Ա����� ����Ƿ��� �������̴�. ������üũ

	String incom_dt 	= request.getParameter("incom_dt")==null?"": request.getParameter("incom_dt") ;
	//incom_dt = AddUtil.replace(incom_dt, "-", "");
	
	long  incom_amt 		= request.getParameter("incom_amt")	==null? 0:AddUtil.parseDigit4(request.getParameter("incom_amt"));
	String org_code 	= request.getParameter("org_code")==null?"":request.getParameter("org_code"); //����ڵ� 	
	String v_gubun 	= request.getParameter("v_gubun")==null?"N":request.getParameter("v_gubun");
			
	String s_flag = "";
	String nonVencode = "";
	
	System.out.println("adate = " + adate);
	System.out.println("r_adate = " + r_adate);
	System.out.println("incom_dt = " + incom_dt);
	System.out.println("incom_amt = " + incom_amt);
	System.out.println("v_gubun = " + v_gubun);

%>

<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>
<body>
<form name='form1' action='' method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=ck_acar_id%>'>
<input type='hidden' name='adate' value='<%=adate%>'>
<input type='hidden' name='incom_dt' value='<%=incom_dt%>'>
<input type='hidden' name='org_code' value='<%=org_code%>'>
<input type='hidden' name='incom_amt' value='<%=incom_amt%>'>
<input type="hidden" name="v_gubun" value="<%=v_gubun%>"> 

����ó�����Դϴ�. ��ٷ� �ֽʽÿ�.

</form>

<script language="JavaScript">

	    modalPop();
	    
		function modalPop(){ 
			var fm = document.form1;
			
//			location.href="http://cms.amazoncar.co.kr:8080/acar/admin/incom_cms_reg.jsp?ck_acar_id=<%=ck_acar_id%>&s_width=<%=s_width%>&s_height=<%=s_height%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&sh_height=<%=sh_height%>";
//			 var objectName = new Object(); // object ���� modal�� �̸��� �ȴ�.
	 // 		 objectName.message = "����";  // ������ �� �ִ�.
	    
//		    	var site = "http://211.174.180.197/acar/admin/man_cost_j_campaign_null.jsp?gubun=3";    
	 //		var style ="dialogWidth:5px;dialogHeight:5px"; // ������� style�� ����
	  //		var vReturn = window.showModalDialog(site, objectName ,style ); // modal ���� window.showModalDialog ����Ʈ!!
	     
	 		var site = "http://cms.amazoncar.co.kr:8080/acar/admin/incom_file22_cms_reg_a.jsp?user_id="+fm.user_id.value+"&adate="+fm.adate.value+"&incom_dt="+fm.incom_dt.value+"&incom_amt="+fm.incom_amt.value+"&v_gubun="+fm.v_gubun.value+"&org_code="+fm.org_code.value;    			
			var popOptions = "dialogWidth: 15px; dialogHeight: 5px; center: yes; resizable: yes; status: no; scroll: no;"; 		
		//	var vReturn = window.showModalDialog(site, window,  popOptions ); 	
			var vReturn = window.open(site, "_parent",  popOptions ); 	
			
			
			//����â ����
		//	window.close();	
		 	
		//	alert(vReturn);
		//	if (vReturn == 'ok'){
		//	//	alert("aaa");
		//		// (���â���� ��ư �̺�Ʈ ���� �Ǵ� �ݱ� ��)���â�� ������ �� �θ�â���� ���� �� �Լ�			
		//	//	opener.parent.location.reload();  			
		//		return;
				
		//	}else{
		//	//	alert("bbb");
		//		return;
				
		//	}
			
			return vReturn;
		} 

//		 var objectName = new Object(); // object ���� modal�� �̸��� �ȴ�.
	    //	 objectName.message = "����";  // ������ �� �ִ�.
	 
	    //	var site = "http://211.174.180.197/acar/admin/man_cost_j_campaign_null.jsp?gubun=3";    
	   //	var style ="dialogWidth:255px;dialogHeight:250px"; // ������� style�� ����
	    //	window.showModalDialog(site, objectName ,style ); // modal ���� window.showModalDialog ����Ʈ!!
	 
	 
	    	// modal �� �Ѱ���� ���� �ٽ� �θ�â�� �޾� ����    
	    //	document.getElementById("test1").value = objectName.message;

</script>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
