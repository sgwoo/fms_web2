<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.cont.*, acar.util.*, acar.user_mng.*, acar.partner.*"%>
<jsp:useBean id="u_bean" class="acar.user_mng.UsersBean" scope="page" />
<%@ include file="/acar/cookies.jsp" %>

<%
	
	String po_id = request.getParameter("po_id")==null?"":request.getParameter("po_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String reg_dt = request.getParameter("reg_dt")==null?"":request.getParameter("reg_dt");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String upd_dt = request.getParameter("upd_dt")==null?"":request.getParameter("upd_dt");
	String upd_id = request.getParameter("upd_id")==null?"":request.getParameter("upd_id");
	String po_gubun = request.getParameter("po_gubun")==null?"":request.getParameter("po_gubun");
	String po_nm = request.getParameter("po_nm")==null?"":request.getParameter("po_nm");
	String po_own = request.getParameter("po_own")==null?"":request.getParameter("po_own");
	String po_no = request.getParameter("po_no")==null?"":request.getParameter("po_no");
	String po_sta = request.getParameter("po_sta")==null?"":request.getParameter("po_sta");
	String po_item = request.getParameter("po_item")==null?"":request.getParameter("po_item");
	String po_o_tel = request.getParameter("po_o_tel")==null?"":request.getParameter("po_o_tel");
	String po_m_tel = request.getParameter("po_m_tel")==null?"":request.getParameter("po_m_tel");
	String po_fax = request.getParameter("po_fax")==null?"":request.getParameter("po_fax");
	String po_post = request.getParameter("po_post")==null?"":request.getParameter("po_post");
	String po_addr = request.getParameter("po_addr")==null?"":request.getParameter("po_addr");
	String po_web = request.getParameter("po_web")==null?"":request.getParameter("po_web");
	String po_note = request.getParameter("po_note")==null?"":request.getParameter("po_note");
	String po_agnt_nm = request.getParameter("po_agnt_nm")==null?"":request.getParameter("po_agnt_nm");
	String po_agnt_m_tel = request.getParameter("po_agnt_m_tel")==null?"":request.getParameter("po_agnt_m_tel");
	String po_agnt_o_tel = request.getParameter("po_agnt_o_tel")==null?"":request.getParameter("po_agnt_o_tel");
	String po_email = request.getParameter("po_email")==null?"":request.getParameter("po_email");
	String cmd		= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	int count = 0;
	
	PartnerDatabase po = PartnerDatabase.getInstance();	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	u_bean = umd.getUsersBean(user_id);
	
	Partner_Bean po_bean = new Partner_Bean();
	
	
 if(cmd.equals("i")){
	po_bean.setPo_id(po_id);
	po_bean.setBr_id(br_id);
	po_bean.setReg_dt(reg_dt);
	po_bean.setUser_id(user_id);
	po_bean.setUpd_dt(upd_dt);
	po_bean.setUpd_id(upd_id);
	po_bean.setPo_gubun(po_gubun);
	po_bean.setPo_nm(po_nm);
	po_bean.setPo_own(po_own);
	po_bean.setPo_no(po_no);
	po_bean.setPo_sta(po_sta);
	po_bean.setPo_item(po_item);
	po_bean.setPo_o_tel(po_o_tel);
	po_bean.setPo_m_tel(po_m_tel);
	po_bean.setPo_fax(po_fax);
	po_bean.setPo_post(po_post);
	po_bean.setPo_addr(po_addr);
	po_bean.setPo_web(po_web);
	po_bean.setPo_note(po_note);
	po_bean.setPo_agnt_nm(po_agnt_nm);
	po_bean.setPo_agnt_m_tel(po_agnt_m_tel);
	po_bean.setPo_agnt_o_tel(po_agnt_o_tel);
	po_bean.setPo_email(po_email);
	
	count = po.insertPartner(po_bean);
	
}else if(cmd.equals("u")){

	po_bean.setPo_id(po_id);
	po_bean.setUpd_id(user_id);
	po_bean.setPo_gubun(po_gubun);
	po_bean.setPo_nm(po_nm);
	po_bean.setPo_own(po_own);
	po_bean.setPo_no(po_no);
	po_bean.setPo_sta(po_sta);
	po_bean.setPo_item(po_item);
	po_bean.setPo_o_tel(po_o_tel);
	po_bean.setPo_m_tel(po_m_tel);
	po_bean.setPo_fax(po_fax);
	po_bean.setPo_post(po_post);
	po_bean.setPo_addr(po_addr);
	po_bean.setPo_web(po_web);
	po_bean.setPo_note(po_note);
	po_bean.setPo_agnt_nm(po_agnt_nm);
	po_bean.setPo_agnt_m_tel(po_agnt_m_tel);
	po_bean.setPo_agnt_o_tel(po_agnt_o_tel);
	po_bean.setPo_email(po_email);
	
	count = po.Update_Partner(po_bean);
	
}else if(cmd.equals("d")){

	po_bean.setPo_id(po_id);
	
	count = po.Del_Partner(po_bean);
	
}
%>
<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15" >

<form name='form1' method='post'>


</form>
<script language='javascript'>
<!--
	var fm = document.form1;

<%	if(cmd.equals("i")){
		if(count==1){		
%>
		alert("정상적으로 등록되었습니다.");
		fm.action='/acar/user_mng/sostel_frame.jsp';
		fm.target='d_content';
		fm.submit();				
		parent.window.close();	

<%}
	}else if(cmd.equals("u")){
	if(count==1){		
%>
		alert("정상적으로 수정되었습니다.");
		fm.action='/acar/user_mng/sostel_frame.jsp';
		fm.target='d_content';
		parent.window.close();
		fm.submit();				
//		window.close();	

<%}
	}else if(cmd.equals("d")){
	if(count==1){		
%>
		alert("정상적으로 삭제되었습니다.");
		fm.action='/acar/user_mng/sostel_frame.jsp';
		fm.target='d_content';
		parent.window.close();
		fm.submit();				
//		top.window.close();
		
<%}
}
%>

//-->

</script>
</body>
</html>
