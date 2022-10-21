<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.serv_off.*, acar.bill_mng.*, acar.cus0601.*" %>
<jsp:useBean id="so_bean" class="acar.serv_off.ServOffBean" scope="page"/>
<jsp:useBean id="c61_soBn" class="acar.cus0601.ServOffBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	ServOffDatabase sod = ServOffDatabase.getInstance();
	String page_gubun = request.getParameter("h_page_gubun")==null?"":request.getParameter("h_page_gubun");
	
	int count = 0;

	if(page_gubun.equals("NEW")){ //신규등록한 고객
		c61_soBn.setCar_comp_id(request.getParameter("car_comp_id"));
		c61_soBn.setOff_nm(request.getParameter("off_nm"));
		c61_soBn.setOff_st(request.getParameter("off_st"));
		c61_soBn.setOwn_nm(request.getParameter("own_nm"));
		c61_soBn.setEnt_no(request.getParameter("t_ent_no1")+request.getParameter("t_ent_no2")+request.getParameter("t_ent_no3"));
		c61_soBn.setOff_sta(request.getParameter("off_sta"));
		c61_soBn.setOff_item(request.getParameter("off_item"));
		c61_soBn.setOff_tel(request.getParameter("off_tel"));
		c61_soBn.setOff_fax(request.getParameter("off_fax"));
		c61_soBn.setOff_post(request.getParameter("t_zip"));
		c61_soBn.setOff_addr(request.getParameter("t_addr"));
		c61_soBn.setBank(request.getParameter("bank"));
		c61_soBn.setAcc_no(request.getParameter("acc_no"));
		c61_soBn.setAcc_nm(request.getParameter("acc_nm"));
		c61_soBn.setNote(request.getParameter("note"));
		c61_soBn.setOff_type("1");
		
		Cus0601_Database c61_db = Cus0601_Database.getInstance();
	
		count = c61_db.insertServOff(c61_soBn);
	
		//네오엠 거래처 등록하기-------------------------------------------------------------------
		NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
		
		int ven_chk  = neoe_db.getTradeCheck("s_idno", c61_soBn.getEnt_no());
		int flag = 0;
		if(ven_chk == 0){
			
			TradeBean t_bean = new TradeBean();		
			
			t_bean.setCust_name	(c61_soBn.getOff_nm());
			t_bean.setS_idno		(c61_soBn.getEnt_no());
			t_bean.setDname			(c61_soBn.getOwn_nm());
			t_bean.setMail_no		(c61_soBn.getOff_post());
			t_bean.setS_address	(c61_soBn.getOff_addr());
			
			if(!neoe_db.insertTrade(t_bean)) flag += 1;			//-> neoe_db 변환
		}
		//-------------------------------------------------------------------------------------------

	}else if(page_gubun.equals("EXT")){ // 검색결과 선택한 정비업체를 정비등록 화면으로 보내준다
		String off_id = request.getParameter("off_id");
		so_bean = sod.getServOff(off_id);
	}
%>
<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table.css">
<script language='JavaScript' src='../../include/common.js'></script>
</head>
<body leftmargin="15">
<script language='javascript'>
<%if(so_bean != null){ //정상
	if(page_gubun.equals("NEW")){	%>
		alert('정상적으로 등록되었습니다');
<%	}	%>
	var fm = parent.opener.form1;
	fm.off_id.value = <%= "'"+so_bean.getOff_id()+"'" %>;
	fm.off_nm.value = <%= "'"+so_bean.getOff_nm()+"'" %>;
<%}else{ //에러
	if(page_gubun.equals("NEW")){	%>
		alert('등록되지 않았습니다');
<%	}
}%>
parent.close();
</script>
</body>
</html>