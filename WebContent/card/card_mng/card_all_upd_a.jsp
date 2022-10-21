<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, card.*, acar.bill_mng.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	int flag = 0;
	
	String vid1[] 	= request.getParameterValues("cardno");
	String vid2[] 	= request.getParameterValues("u_chk");
	
	String cls_dt 	= request.getParameter("cls_dt")==null?"":request.getParameter("cls_dt");
	String cls_cau 	= request.getParameter("cls_cau")==null?"":request.getParameter("cls_cau");
	
	String cardno 	= "";
	String u_chk 	= "";
	
	int vid_size1 = vid1.length;
	int vid_size2 = vid2.length;
	
	out.println("vid_size1="+vid_size1);
	out.println("vid_size2="+vid_size2);
	
	System.out.println("법인카드 일괄 수정-----------------------------");
	
	if(vid_size2>0){
		for(int i=0;i < vid_size1;i++){
			cardno = vid1[i];
			
			//카드정보
			CardBean c_bean = CardDb.getCard(cardno);
			
			for(int j=0;j < vid_size2;j++){
				u_chk = vid2[0]==null?"":vid2[0];
				
				if(u_chk.equals("1")) 	c_bean.setCard_st		(request.getParameter("card_st")==null?"":request.getParameter("card_st"));
				if(u_chk.equals("2"))	c_bean.setCard_type		(request.getParameter("card_type")==null?"":request.getParameter("card_type"));
				if(u_chk.equals("3")){
					c_bean.setCard_kind_cd	(request.getParameter("card_kind")==null?"":request.getParameter("card_kind"));
					c_bean.setCard_kind			(c_db.getNameByIdCode("0031", c_bean.getCard_kind_cd(), ""));
				}	
				if(u_chk.equals("4")){
				 						c_bean.setCom_code		(request.getParameter("ven_code")==null?"":request.getParameter("ven_code"));
										c_bean.setCom_name		(request.getParameter("ven_name")==null?"":request.getParameter("ven_name"));
				}
				if(u_chk.equals("5")) 	c_bean.setPay_day		(request.getParameter("pay_day")==null?"":request.getParameter("pay_day"));
				if(u_chk.equals("6")){
				 						c_bean.setUse_s_m		(request.getParameter("use_s_m")==null?"":request.getParameter("use_s_m"));
										c_bean.setUse_s_day		(request.getParameter("use_s_day")==null?"":request.getParameter("use_s_day"));
										c_bean.setUse_e_m		(request.getParameter("use_e_m")==null?"":request.getParameter("use_e_m"));
										c_bean.setUse_e_day		(request.getParameter("use_e_day")==null?"":request.getParameter("use_e_day"));
				}
				if(u_chk.equals("7")) 	c_bean.setLimit_st		(request.getParameter("limit_st")==null?"":request.getParameter("limit_st"));
				if(u_chk.equals("8")) 	c_bean.setLimit_amt		(request.getParameter("limit_amt")==null?0:AddUtil.parseDigit4(request.getParameter("limit_amt")));
				if(u_chk.equals("9")) 	c_bean.setReceive_dt	(request.getParameter("receive_dt")==null?"":request.getParameter("receive_dt"));
				if(u_chk.equals("10")) 	c_bean.setMile_st		(request.getParameter("mile_st")==null?"":request.getParameter("mile_st"));
				if(u_chk.equals("11")) 	c_bean.setMile_per		(request.getParameter("mile_per")==null?"":request.getParameter("mile_per"));
				if(u_chk.equals("12")) 	c_bean.setMile_amt		(request.getParameter("mile_amt")==null?0:AddUtil.parseDigit(request.getParameter("mile_amt")));
				if(u_chk.equals("13")) 	c_bean.setCard_mng_id	(request.getParameter("card_mng_id")==null?"":request.getParameter("card_mng_id"));
				if(u_chk.equals("14")) 	c_bean.setDoc_mng_id	(request.getParameter("doc_mng_id")==null?"":request.getParameter("doc_mng_id"));
				if(u_chk.equals("15")) 	c_bean.setCard_sdate	(request.getParameter("card_sdate")==null?"":request.getParameter("card_sdate"));
				if(u_chk.equals("16")) 	c_bean.setCard_edate	(request.getParameter("card_edate")==null?"":request.getParameter("card_edate"));
				if(u_chk.equals("17")) 	c_bean.setAcc_no		(request.getParameter("acc_no")==null?"":request.getParameter("acc_no"));
				if(u_chk.equals("18")) 	c_bean.setCard_paid		(request.getParameter("card_paid")==null?"":request.getParameter("card_paid"));
				
				if(u_chk.equals("1")) 	System.out.println(u_chk+") "+c_bean.getCard_st			());
				if(u_chk.equals("2")) 	System.out.println(u_chk+") "+c_bean.getCard_type		());
				if(u_chk.equals("3")) 	System.out.println(u_chk+") "+c_bean.getCard_kind		());
				if(u_chk.equals("4")) 	System.out.println(u_chk+") "+c_bean.getCom_code		());
				if(u_chk.equals("4")) 	System.out.println(u_chk+") "+c_bean.getCom_name		());
				if(u_chk.equals("5")) 	System.out.println(u_chk+") "+c_bean.getPay_day			());
				if(u_chk.equals("6")) 	System.out.println(u_chk+") "+c_bean.getUse_s_m			());
				if(u_chk.equals("6")) 	System.out.println(u_chk+") "+c_bean.getUse_s_day		());
				if(u_chk.equals("6")) 	System.out.println(u_chk+") "+c_bean.getUse_e_m			());
				if(u_chk.equals("6")) 	System.out.println(u_chk+") "+c_bean.getUse_e_day		());
				if(u_chk.equals("7")) 	System.out.println(u_chk+") "+c_bean.getLimit_st		());
				if(u_chk.equals("8")) 	System.out.println(u_chk+") "+c_bean.getLimit_amt		());
				if(u_chk.equals("9")) 	System.out.println(u_chk+") "+c_bean.getReceive_dt		());
				if(u_chk.equals("10")) 	System.out.println(u_chk+") "+c_bean.getMile_st			());
				if(u_chk.equals("11")) 	System.out.println(u_chk+") "+c_bean.getMile_per		());
				if(u_chk.equals("12")) 	System.out.println(u_chk+") "+c_bean.getMile_amt		());
				if(u_chk.equals("13")) 	System.out.println(u_chk+") "+c_bean.getCard_mng_id		());
				if(u_chk.equals("14")) 	System.out.println(u_chk+") "+c_bean.getDoc_mng_id		());
				if(u_chk.equals("15")) 	System.out.println(u_chk+") "+c_bean.getCard_sdate		());
				if(u_chk.equals("16")) 	System.out.println(u_chk+") "+c_bean.getCard_edate		());
				if(u_chk.equals("17")) 	System.out.println(u_chk+") "+c_bean.getAcc_no			());
				if(u_chk.equals("18")) 	System.out.println(u_chk+") "+c_bean.getCard_paid		());
			}
			
			if(!CardDb.updateCard(c_bean)) flag += 1;
		}
	}
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function go_step(){
		var fm = document.form1;
		fm.action = 'card_mng_sc.jsp';
		fm.target = "c_foot";
		fm.submit();

		parent.window.close();		
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
</head>
<body>
<form name='form1' action='' method='post'>
<%@ include file="/include/search_hidden.jsp" %>
</form>
<a href="javascript:go_step()">다음으로</a>
<script language='javascript'>
<!--
<%	if(flag > 0){//에러발생%>
		alert("에러가 발생하였습니다.");
<%	}else{//정상%>
		alert("수정되었습니다.");
		go_step();
<%	}%>
//-->
</script>
</body>
</html>
