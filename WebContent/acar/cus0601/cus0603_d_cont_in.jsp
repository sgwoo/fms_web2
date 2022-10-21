<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*, acar.common.*" %>
<%@ page import="acar.cus0601.*, acar.bill_mng.*" %>
<jsp:useBean id="c61_soBn" class="acar.cus0601.ServOffBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	CommonDataBase c_db = CommonDataBase.getInstance();

	int count = 0;
	int count2 = 0;
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_comp_id = request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String off_nm = request.getParameter("off_nm")==null?"":request.getParameter("off_nm");
	String off_st = request.getParameter("off_st")==null?"":request.getParameter("off_st");
	String own_nm = request.getParameter("own_nm")==null?"":request.getParameter("own_nm");
	String ent_no = request.getParameter("ent_no")==null?"":request.getParameter("ent_no");
	String off_sta = request.getParameter("off_sta")==null?"":request.getParameter("off_sta");
	String off_item = request.getParameter("off_item")==null?"":request.getParameter("off_item");
	String off_tel = request.getParameter("off_tel")==null?"":request.getParameter("off_tel");
	String off_fax = request.getParameter("off_fax")==null?"":request.getParameter("off_fax");
	String off_post = request.getParameter("t_zip")==null?"":request.getParameter("t_zip");
	String off_addr = request.getParameter("t_addr")==null?"":request.getParameter("t_addr");
	String bank = request.getParameter("bank")==null?"":request.getParameter("bank");
	String acc_no = request.getParameter("acc_no")==null?"":request.getParameter("acc_no");
	String acc_nm = request.getParameter("acc_nm")==null?"":request.getParameter("acc_nm");
	String note = request.getParameter("note")==null?"":request.getParameter("note");
	String reg_id = request.getParameter("reg_id")==null?"":request.getParameter("reg_id");
	String off_type = "3";
	String bank_cd = request.getParameter("bank_cd")==null?"":request.getParameter("bank_cd");


	c61_soBn.setCar_comp_id(car_comp_id); 
	c61_soBn.setOff_nm(off_nm); 
	c61_soBn.setOff_st(off_st); 
	c61_soBn.setOwn_nm(own_nm); 
	c61_soBn.setEnt_no(ent_no); 
	c61_soBn.setOff_sta(off_sta); 
	c61_soBn.setOff_item(off_item); 
	c61_soBn.setOff_tel(off_tel); 
	c61_soBn.setOff_fax(off_fax); 
	c61_soBn.setOff_post(off_post); 
	c61_soBn.setOff_addr(off_addr); 
	c61_soBn.setBank(bank);
	c61_soBn.setAcc_no(acc_no);
	c61_soBn.setAcc_nm(acc_nm);
	c61_soBn.setNote(note);
	c61_soBn.setReg_id(reg_id);
	c61_soBn.setOff_type(off_type);
	c61_soBn.setBank_cd(bank_cd);
	
	if(!c61_soBn.getBank_cd().equals("")){
			c61_soBn.setBank		(c_db.getNameById(c61_soBn.getBank_cd(), "BANK"));
	}
	
	Cus0601_Database c61_db = Cus0601_Database.getInstance();
	
	count = c61_db.insertServOff(c61_soBn);
	
		//네오엠 거래처 등록하기-------------------------------------------------------------------
		NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
		
		int ven_chk  = neoe_db.getTradeCheck("s_idno", c61_soBn.getEnt_no());
		int flag = 0;
		if(ven_chk == 0){
			
			TradeBean t_bean = new TradeBean();		
			
			t_bean.setCust_name	(c61_soBn.getOff_nm());
			t_bean.setS_idno	(c61_soBn.getEnt_no());
			t_bean.setDname		(c61_soBn.getOwn_nm());
			t_bean.setMail_no	(c61_soBn.getOff_post());
			t_bean.setS_address	(c61_soBn.getOff_addr());
			
			if(!neoe_db.insertTrade(t_bean)) flag += 1;	//-> neoe_db 변환
			
			String cust_code = neoe_db.getCustCode2(t_bean.getS_idno(), t_bean.getCust_name());  //-> neoe_db 변환
			
			c61_soBn.setVen_code(cust_code);
			
			count2 = c61_db.updateServOff(c61_soBn);
		}
		//-------------------------------------------------------------------------------------------
	
%>
<html>
<head>
<title>FMS</title>
</head>
<body>
<script language="JavaScript">
<!--
<% if(count==1){ %>
	alert("정상적으로 등록되었습니다.");
	//parent.close();
<% }else{ %>
	alert("데이터베이스에 문제가 발생하였습니다.\n관리자님께 문의하세요!");
	history.back();
<% } %>
//-->
</script>
</body>
</html>