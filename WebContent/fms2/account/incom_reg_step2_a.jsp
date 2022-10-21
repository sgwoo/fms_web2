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
	
	//1. 입금처리전 기본정보 ----------------------------------------------------------------------------------------------
	
	//bankincom
	String incom_dt 		= request.getParameter("incom_dt")==null?"":request.getParameter("incom_dt");
	int    incom_seq 	 	= request.getParameter("incom_seq")	==null?0 :AddUtil.parseDigit(request.getParameter("incom_seq"));
	int    incom_amt 	 	= request.getParameter("incom_amt")	==null?0 :AddUtil.parseDigit(request.getParameter("incom_amt"));
	
	String ip_method 		= request.getParameter("ip_method")==null?"":request.getParameter("ip_method");  //입금구분  2:카드
	String card_cd 		= request.getParameter("card_cd")==null?"":request.getParameter("card_cd");  //입금구분  2:카드
	  
	String brch_id 			= request.getParameter("brch_id")==null?"":request.getParameter("brch_id");		
	String p_gubun 			= request.getParameter("p_gubun")==null?"1":request.getParameter("p_gubun");  //처리구분 :1:해당건처리 2:cms 처리 3:카드사입금처리 5:보험사입금처리

	String from_page 	= "incom_reg_scd_step2.jsp";
				
	if (p_gubun .equals("1") ) { //해당건처리  - 대여료, 선수금 등 
		from_page = "incom_reg_scd_step2.jsp";
	} else if (p_gubun .equals("3") ) { //카드사입금
		from_page = "incom_reg_card_step2.jsp";	
	} else if (p_gubun .equals("4") ) { //보험사입금
		from_page = "incom_reg_ins_step2.jsp";	
	}		
	
	int flag = 0;
	
	//  -- 일단 제외 - 20170920  - 페이엣은 더이상 진행안됨.
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
		alert('등록되지 않았습니다');
<%	}else{	%>
		alert("등록되었습니다");
		fm.action = '<%=from_page%>';
		fm.target = 'd_content';
		fm.submit();
<%	}	%>
</script>
</body>
</html>
