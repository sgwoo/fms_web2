<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.admin.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>

<html><head><title>FMS</title>
</head>
<body>
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //����
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	//System.out.println("user_id=" + user_id);	
	
	//cms card  incom ����Ÿ ���� -  ī��� ���忡�� Ȯ�κҰ� ���ι�ȣó�� ����ó���ؾ� ��.
	String adate 	= request.getParameter("adate")==null?"":request.getParameter("adate");//�����Ƿ�����	  
//	String r_adate 	= ad_db.getValidDt(adate); //���ó������ �����Ƿ��� �������̴�. ������üũ

//	String incom_dt 	= request.getParameter("incom_dt")==null?"": request.getParameter("incom_dt") ;
   String incom_dt = adate;
	incom_dt = AddUtil.replace(incom_dt, "-", "");
	
//	long  incom_amt 		= request.getParameter("incom_amt")	==null? 0:AddUtil.parseDigit4(request.getParameter("incom_amt"));
	String ama_id 	= request.getParameter("ama_id")==null?"":request.getParameter("ama_id"); //����ڵ� 	
//	String v_gubun 	= request.getParameter("v_gubun")==null?"N":request.getParameter("v_gubun");
			
	int chkdtflag = 0;
	String s_flag = "";
	
	//cms����ó��

	if(adate.equals(incom_dt) ) {  //���ٸ�

		System.out.println("card adate = " + adate);
//		System.out.println("r_adate = " + r_adate);
		System.out.println("incom_dt = " + incom_dt);
	//	System.out.println("incom_amt = " + incom_amt);
	//	System.out.println("v_gubun = " + v_gubun);
	//	
		//�űԻ���				
		// call procedure
	//	s_flag = "0";	
		s_flag =   ad_db.call_sp_incom_card_cms_magam(adate,  user_id, incom_dt,  ama_id );
		System.out.println("card cms�Ա�ó�� ��� " + s_flag);			
	
	} else { //�Ƿ���+1 �� cms ���� �Ա����� (���̰� �ִٸ� cms ó�� �Ұ� )
	 	chkdtflag = 1;
	} 
	    
%>
<form name='form1' action='/fms2/cms/incom_card_cms_reg.jsp' target='d_content' method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
</form>
<script language='javascript'>

<%  if(chkdtflag == 1){%>
		alert('�����Ա��� �Է� ����!');
				
<%	} else if(!s_flag.equals("0") ){%>
		alert('CMS ó�� �����߻�!');		
		
<%	}else{%>
		alert('ó���Ǿ����ϴ�');
<%	}%>

</script>
</body>
</html>