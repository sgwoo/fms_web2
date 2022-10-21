<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.incom.*"%>
<jsp:useBean id="in_db" scope="page" class="acar.incom.IncomDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	//if(1==1)return;
	
	String auth_rw 			= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 			= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 			= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	//1. �Ա�ó���� �⺻���� ----------------------------------------------------------------------------------------------
	
	//bankincom
	String incom_dt 		= request.getParameter("incom_dt")==null?"":request.getParameter("incom_dt");
	int    incom_seq 	 	= request.getParameter("incom_seq")	==null?0 :AddUtil.parseDigit(request.getParameter("incom_seq"));
	int    incom_amt 	 	= request.getParameter("incom_amt")	==null?0 :AddUtil.parseDigit(request.getParameter("incom_amt"));
	
	String ip_method 		= request.getParameter("ip_method")==null?"":request.getParameter("ip_method");  //�Աݱ���  2:ī��
	String card_cd 		= request.getParameter("card_cd")==null?"":request.getParameter("card_cd");  //�Աݱ���  2:ī��
	  
	String brch_id 			= request.getParameter("brch_id")==null?"":request.getParameter("brch_id");		
	String p_gubun 			= request.getParameter("p_gubun")==null?"1":request.getParameter("p_gubun");  //ó������ :1:�ش��ó�� 2:cms ó�� 3:ī����Ա�ó�� 5:������Ա�ó��

	String from_page 	= "incom_reg_scd_step2.jsp";
				
	if (p_gubun .equals("1") ) { //�ش��ó��  - �뿩��, ������ �� 
		from_page = "incom_reg_scd_step2.jsp";
	} else if (p_gubun .equals("3") ) { //ī����Ա�
		from_page = "incom_reg_card_step2.jsp";	
	} else if (p_gubun .equals("4") ) { //������Ա�
		from_page = "incom_reg_ins_step2.jsp";	
	}		
	
	int flag = 0;
	
	//  -- �ϴ� ���� - 20170920  - ���̿��� ���̻� ����ȵ�.
    if (incom_amt < 0  &&   ip_method.equals("2")  &&  card_cd.equals("12")  )  { 
      	  	if(!in_db.updateIncomCardCanel( incom_dt, incom_seq )) flag += 1;	
     	  	from_page = "incom_reg_step1.jsp";
    } 
             	
	//=====[incom] insert=====
	if(!in_db.updateIncomGubun( incom_dt, incom_seq, p_gubun )) flag += 1;	
					
%>
<form name='form1' action='' method='post'>
  <input type="hidden" name="auth_rw" 			value="<%=auth_rw%>">
  <input type="hidden" name="user_id" 			value="<%=user_id%>">
  <input type="hidden" name="br_id" 			value="<%=br_id%>">    
  <input type="hidden" name="incom_dt" 			value="<%=AddUtil.ChangeString(incom_dt)%>">
  <input type="hidden" name="incom_seq" 		value="<%=incom_seq%>">
  <input type="hidden" name="incom_amt" 		value="<%=incom_amt%>">
  <input type='hidden' name='v_gubun' value='Y'> 
 </form>
<script language='javascript'>
	var fm = document.form1;
<%	if(flag != 0){ 	//%>
		alert('��ϵ��� �ʾҽ��ϴ�');
<%	}else{	%>
		alert("��ϵǾ����ϴ�");
		fm.action = '<%=from_page%>';
		fm.target = 'd_content';
		fm.submit();
<%	}	%>
</script>
</body>
</html>
