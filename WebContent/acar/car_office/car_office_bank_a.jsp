<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.common.*" %>
<%@ page import="acar.car_office.*" %>
<jsp:useBean id="co_bean" class="acar.car_office.CarOffBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String car_off_id 	= request.getParameter("car_off_id")==null?"":request.getParameter("car_off_id");
	String car_off_nm 	= request.getParameter("car_off_nm")==null?"":request.getParameter("car_off_nm");
	String car_comp_id 	= request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String car_comp_nm 	= request.getParameter("car_comp_nm")==null?"":request.getParameter("car_comp_nm");
	
	String st 			= request.getParameter("st")==null?"":request.getParameter("st");
	int seq 			= request.getParameter("seq")==null?0:AddUtil.parseInt(request.getParameter("seq"));
	String cmd 			= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String bank 		= request.getParameter("bank")==null?"":request.getParameter("bank");
	String bank_cd 		= request.getParameter("bank_cd")==null?"":request.getParameter("bank_cd");
	String acc_st 		= request.getParameter("acc_st")==null?"":request.getParameter("acc_st");
	String acc_no 		= request.getParameter("acc_no")==null?"":request.getParameter("acc_no");
	String acc_nm 		= request.getParameter("acc_nm")==null?"":request.getParameter("acc_nm");
	String use_yn 		= request.getParameter("use_yn")==null?"":request.getParameter("use_yn");
	
	String mode 		= request.getParameter("mode")==null?"":request.getParameter("mode");
	int count = 0;
	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	CarOfficeDatabase umd = CarOfficeDatabase.getInstance();
	
	
	//기타계좌리스트
	Vector vt = c_db.getBankAccList("car_off_id", car_off_id, "");
	int vt_size = vt.size();
	
	out.println("<br>st="+st);
	out.println("<br>cmd="+cmd);
	out.println("<br>car_off_id="+car_off_id);
	out.println("<br>seq="+seq);
	
	//기타계좌
	if(st.equals("etc")){
		
		BankAccBean ba_bean = new BankAccBean();
		
		if(seq > 0){
			ba_bean = c_db.getBankAcc("car_off_id", car_off_id, seq);
		}
		
		ba_bean.setBank_id(bank_cd);
		ba_bean.setAcc_no	(acc_no);
		ba_bean.setAcc_nm	(acc_nm);
		ba_bean.setAcc_st	(acc_st);
		ba_bean.setUse_yn	(use_yn);
		
		if(cmd.equals("i")){
			ba_bean.setOff_st	("car_off_id");
			ba_bean.setOff_id	(car_off_id);
			ba_bean.setSeq		(vt_size+1);
			ba_bean.setReg_id	(ck_acar_id);
			count = c_db.insertBankAcc(ba_bean);
		}else if(cmd.equals("u")){
			out.println("<br>ba_bean.getOff_st()="+ba_bean.getOff_st());
			out.println("<br>ba_bean.getOff_id()="+ba_bean.getOff_id());
			out.println("<br>ba_bean.getSeq()="+ba_bean.getSeq());
			ba_bean.setUpdate_id(ck_acar_id);
			count = c_db.updateBankAcc(ba_bean);
		}else if(cmd.equals("d")){
			count = c_db.deleteBankAcc(ba_bean);
		}
		
	//대표계좌
	}else{
		
		//영업소정보
		co_bean = umd.getCarOffBean(car_off_id);
		co_bean.setBank_cd(bank_cd);
		co_bean.setAcc_no	(acc_no);
		co_bean.setAcc_nm	(acc_nm);
		
		if(!co_bean.getBank_cd().equals("")){
			co_bean.setBank		(c_db.getNameById(co_bean.getBank_cd(), "BANK"));
		}
		
		if(cmd.equals("u")){
			count = umd.updateCarOff(co_bean);
		}
	}
%>
<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
</head>
<body>
<script language="JavaScript">
<!--
<%	if(cmd.equals("i")){%>
<%		if(count==1){%>
			alert("정상적으로 등록되었습니다.");
			parent.SelfReload();
<%		}else{%>	
			alert("오류발행!");
<%		}%>

<%	}else if(cmd.equals("u")){%>
<%		if(count==1){%>
			alert("정상적으로 수정되었습니다.");
			parent.SelfReload();
<%		}else{%>	
			alert("오류발행!");
<%		}%>

<%	}else if(cmd.equals("d")){%>
<%		if(count==1){%>
			alert("정상적으로 삭제되었습니다.");
			parent.SelfReload();
<%		}else{%>	
			alert("오류발행!");
<%		}%>
<%	}%>
//-->
</script>
</body>
</html>