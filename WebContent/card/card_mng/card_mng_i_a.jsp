<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, card.*, acar.bill_mng.*, acar.user_mng.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	String cardno 		= request.getParameter("cardno")==null?"":request.getParameter("cardno");
	String card_user_id 	= request.getParameter("card_user_id")==null?"":request.getParameter("card_user_id");
	String seq = "";
	int chk_flag = 0;
	int flag = 0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	out.println("카드중복체크"+"<br><br>");
	
	if(!CardDb.checkCardNo(cardno)) chk_flag += 1;
	
	CardBean c_bean = new CardBean();


	if(chk_flag == 0){
		out.println("카드등록"+"<br><br>");
		
		//카드정보
		
		c_bean.setCardno(cardno);
		
		c_bean.setCard_kind_cd(request.getParameter("card_kind")==null?"":request.getParameter("card_kind"));
		c_bean.setCard_kind(c_db.getNameByIdCode("0031", c_bean.getCard_kind_cd(), ""));
		
		c_bean.setCard_st(request.getParameter("card_st")==null?"":request.getParameter("card_st"));
		c_bean.setCom_code(request.getParameter("ven_code")==null?"":request.getParameter("ven_code"));
		c_bean.setCom_name(request.getParameter("ven_name")==null?"":request.getParameter("ven_name"));
		c_bean.setCard_name(request.getParameter("card_name")==null?"":request.getParameter("card_name"));
		c_bean.setCard_sdate(request.getParameter("card_sdate")==null?"":request.getParameter("card_sdate"));
		c_bean.setCard_edate(request.getParameter("card_edate")==null?"":request.getParameter("card_edate"));
		c_bean.setPay_day(request.getParameter("pay_day")==null?"":request.getParameter("pay_day"));
		c_bean.setUse_s_m(request.getParameter("use_s_m")==null?"":request.getParameter("use_s_m"));
		c_bean.setUse_s_day(request.getParameter("use_s_day")==null?"":request.getParameter("use_s_day"));
		c_bean.setUse_e_m(request.getParameter("use_e_m")==null?"":request.getParameter("use_e_m"));
		c_bean.setUse_e_day(request.getParameter("use_e_day")==null?"":request.getParameter("use_e_day"));
		c_bean.setLimit_st(request.getParameter("limit_st")==null?"":request.getParameter("limit_st"));
		c_bean.setLimit_amt(request.getParameter("limit_amt")==null?0:AddUtil.parseDigit4(request.getParameter("limit_amt")));
		c_bean.setEtc(request.getParameter("etc")==null?"":request.getParameter("etc"));
		c_bean.setCls_dt(request.getParameter("cls_dt")==null?"":request.getParameter("cls_dt"));
		c_bean.setCls_cau(request.getParameter("cls_cau")==null?"":request.getParameter("cls_cau"));
		c_bean.setCls_dt(request.getParameter("cls_dt")==null?"":request.getParameter("cls_dt"));
		c_bean.setCls_cau(request.getParameter("cls_cau")==null?"":request.getParameter("cls_cau"));
		c_bean.setUse_yn("Y");
		c_bean.setReceive_dt(request.getParameter("receive_dt")==null?"":request.getParameter("receive_dt"));
		c_bean.setCard_mng_id(request.getParameter("card_mng_id")==null?"":request.getParameter("card_mng_id"));
		c_bean.setDoc_mng_id(request.getParameter("doc_mng_id")==null?"":request.getParameter("doc_mng_id"));
		c_bean.setCard_type(request.getParameter("card_type")==null?"":request.getParameter("card_type"));
		c_bean.setAcc_no(request.getParameter("acc_no")==null?"":request.getParameter("acc_no"));
		c_bean.setCard_paid(request.getParameter("card_paid")==null?"":request.getParameter("card_paid"));
		
		if(!CardDb.insertCard(c_bean)) flag += 1;


		if(!card_user_id.equals("")){
		
			out.println("카드사용자등록"+"<br><br>");
			
			//사용할 seq 가져오기
			seq = CardDb.getCardUserSeqNext(cardno);
			
			//카드사용자정보
			CardUserBean cu_bean = new CardUserBean();
			cu_bean.setCardno(cardno);
			cu_bean.setSeq(seq);
			cu_bean.setUser_id(card_user_id);
			cu_bean.setUse_s_dt(request.getParameter("use_s_dt2")==null?"":request.getParameter("use_s_dt2"));
			cu_bean.setUse_e_dt(request.getParameter("use_e_dt2")==null?"":request.getParameter("use_e_dt2"));
			cu_bean.setReg_id(user_id);
			
			if(!CardDb.insertCardUser(cu_bean)) flag += 1;
			
			
			out.println("카드관리에 사용자 일련번호 수정 "+"<br><br>");
			
			//카드정보
//			CardBean c_bean = CardDb.getCard(cardno);
			c_bean.setUser_seq(seq);
			if(!CardDb.updateCard(c_bean)) flag += 1;
		}
		
		
		//네오엠에 카드 입력확인후 미등록이면 네오엠에도 카드정보를 등록한다.
		if(neoe_db.getCodeByNm("cardno", cardno).equals("")){//-> neoe_db 변환
			UsersBean user_bean = umd.getUsersBean(c_bean.getCard_mng_id());
			
			Hashtable per = neoe_db.getPerinfoDept(user_bean.getUser_nm());//-> neoe_db 변환	
			
			Hashtable br = c_db.getBranch(user_bean.getBr_id());
			
			
			flag = neoe_db.insertCardmana(c_bean, per, br);//-> neoe_db 변환
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
<input type='hidden' name='cardno' 	value='<%=cardno%>'>
</form>
<a href="javascript:go_step()">다음으로</a>
<script language='javascript'>
<!--
<%	if(chk_flag > 0){//중복발생%>
		alert("이미 등록된 카드입니다. 확인하십시오.");
<%	}else{//정상%>		
<%		if(flag > 0){//에러발생%>
		alert("에러가 발생하였습니다.");
<%		}else{//정상%>
		alert("등록되었습니다.");
		go_step();
<%		}%>
<%	}%>
//-->
</script>
</body>
</html>
