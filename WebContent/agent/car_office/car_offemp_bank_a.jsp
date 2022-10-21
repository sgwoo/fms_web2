<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.common.*" %>

<%@ include file="/agent/cookies.jsp" %>

<%
	String emp_id = request.getParameter("emp_id")==null?"":request.getParameter("emp_id");
	
	String cmd 		= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String mode 		= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	int seq 		= request.getParameter("seq")==null?0:AddUtil.parseInt(request.getParameter("seq"));
	String acc_nm 		= request.getParameter("acc_nm")==null?"":request.getParameter("acc_nm");
	String acc_ssn 		= request.getParameter("acc_ssn")==null?"":request.getParameter("acc_ssn");
	String etc	 	= request.getParameter("etc")==null?"":request.getParameter("etc");
	String bank 		= request.getParameter("bank")==null?"":request.getParameter("bank");
	String bank_cd 		= request.getParameter("bank_cd")==null?"":request.getParameter("bank_cd");
	String acc_no 		= request.getParameter("acc_no")==null?"":request.getParameter("acc_no");
	String acc_zip 		= request.getParameter("t_zip")==null?"":request.getParameter("t_zip");
	String acc_addr		= request.getParameter("t_addr")==null?"":request.getParameter("t_addr");
	
	int count = 0;
	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	
	
	//기타계좌리스트
	Vector vt = c_db.getBankAccList("emp_id", emp_id, "");
	int vt_size = vt.size();
	
	out.println("<br>cmd="+cmd);
	out.println("<br>emp_id="+emp_id);
	out.println("<br>seq="+seq);
	
	BankAccBean ba_bean = new BankAccBean();
	
	if(seq > 0){
		ba_bean = c_db.getBankAcc("emp_id", emp_id, seq);
	}
	
	ba_bean.setBank_id	(bank_cd);
	ba_bean.setAcc_no		(acc_no);
	ba_bean.setAcc_nm		(acc_nm);
	ba_bean.setAcc_st		("");
	ba_bean.setUse_yn		("");
	ba_bean.setAcc_ssn	(acc_ssn);
	ba_bean.setEtc			(etc);
	ba_bean.setAcc_zip	(acc_zip);
	ba_bean.setAcc_addr	(acc_addr);
	
	if(cmd.equals("i")){
		ba_bean.setOff_st	("emp_id");
		ba_bean.setOff_id	(emp_id);
		ba_bean.setSeq		(vt_size+1);
		ba_bean.setReg_id	(ck_acar_id);
		count = c_db.insertBankAcc(ba_bean);
	}else if(cmd.equals("u")){
		out.println("<br>ba_bean.getOff_st	()="+ba_bean.getOff_st	());
		out.println("<br>ba_bean.getOff_id	()="+ba_bean.getOff_id	());
		out.println("<br>ba_bean.getSeq		()="+ba_bean.getSeq		());
		ba_bean.setUpdate_id(ck_acar_id);
		count = c_db.updateBankAcc(ba_bean);
	}else if(cmd.equals("d")){
		count = c_db.deleteBankAcc(ba_bean);
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