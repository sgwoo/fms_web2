<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.cont.*, acar.util.*, acar.user_mng.*, acar.partner.*"%>
<jsp:useBean id="fm_bean" class="acar.partner.FinManBean" scope="page" />

<%@ include file="/acar/cookies.jsp" %>

<%
	
	int fin_seq = request.getParameter("fin_seq")==null?0:Integer.parseInt(request.getParameter("fin_seq"));
	String cmd		= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	int count = 0;
	
	
	PartnerDatabase po = PartnerDatabase.getInstance();		
	
 if(cmd.equals("i")){
       
	fm_bean.setCom_nm(request.getParameter("com_nm")==null?"":		request.getParameter("com_nm"));
	fm_bean.setBr_nm(request.getParameter("br_nm")==null?"":		request.getParameter("br_nm"));
	fm_bean.setAgnt_nm(request.getParameter("agnt_nm")==null?"":		request.getParameter("agnt_nm"));
	fm_bean.setAgnt_title(request.getParameter("agnt_title")==null?"":		request.getParameter("agnt_title"));
	fm_bean.setFin_tel(request.getParameter("fin_tel")==null?"":		request.getParameter("fin_tel"));
	fm_bean.setFin_fax(request.getParameter("fin_fax")==null?"":		request.getParameter("fin_fax"));
	fm_bean.setFin_email(request.getParameter("fin_email")==null?"":		request.getParameter("fin_email"));
	fm_bean.setFin_zip(request.getParameter("fin_zip")==null?"":		request.getParameter("fin_zip"));
	fm_bean.setFin_addr(request.getParameter("fin_addr")==null?"":		request.getParameter("fin_addr"));
	fm_bean.setUse_yn(request.getParameter("use_yn")==null?"":		request.getParameter("use_yn"));
	fm_bean.setGubun(request.getParameter("gubun")==null?"":		request.getParameter("gubun"));
	fm_bean.setFin_m_tel(request.getParameter("fin_m_tel")==null?"":		request.getParameter("fin_m_tel"));
	fm_bean.setSort(request.getParameter("sort")==null?0:	AddUtil.parseDigit(request.getParameter("sort")));
	count = po.insertFinMan(fm_bean);
	
}else if(cmd.equals("u")){

	fm_bean.setFin_seq(fin_seq);
	fm_bean.setCom_nm(request.getParameter("com_nm")==null?"":		request.getParameter("com_nm"));
	fm_bean.setBr_nm(request.getParameter("br_nm")==null?"":		request.getParameter("br_nm"));
	fm_bean.setAgnt_nm(request.getParameter("agnt_nm")==null?"":		request.getParameter("agnt_nm"));
	fm_bean.setAgnt_title(request.getParameter("agnt_title")==null?"":		request.getParameter("agnt_title"));
	fm_bean.setFin_tel(request.getParameter("fin_tel")==null?"":		request.getParameter("fin_tel"));
	fm_bean.setFin_fax(request.getParameter("fin_fax")==null?"":		request.getParameter("fin_fax"));
	fm_bean.setFin_email(request.getParameter("fin_email")==null?"":		request.getParameter("fin_email"));
	fm_bean.setFin_zip(request.getParameter("fin_zip")==null?"":		request.getParameter("fin_zip"));
	fm_bean.setFin_addr(request.getParameter("fin_addr")==null?"":		request.getParameter("fin_addr"));
	fm_bean.setUse_yn(request.getParameter("use_yn")==null?"":		request.getParameter("use_yn"));
	fm_bean.setGubun(request.getParameter("gubun")==null?"":		request.getParameter("gubun"));
	fm_bean.setFin_m_tel(request.getParameter("fin_m_tel")==null?"":		request.getParameter("fin_m_tel"));
	fm_bean.setSort(request.getParameter("sort")==null?0:	AddUtil.parseDigit(request.getParameter("sort")));
	count = po.UpdateFinMan(fm_bean);
	
}else if(cmd.equals("d")){

	fm_bean.setFin_seq(fin_seq);	
	count = po.delFinMan(fm_bean);	
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
		fm.action='partner_s_frame.jsp';
		fm.target='d_content';
		fm.submit();				
		parent.window.close();	

<%}
	}else if(cmd.equals("u")){
	if(count==1){		
%>
		alert("정상적으로 수정되었습니다.");
		fm.action='partner_s_frame.jsp';
		fm.target='d_content';
		parent.window.close();
		fm.submit();				
//		window.close();	

<%}
	}else if(cmd.equals("d")){
	if(count==1){		
%>
		alert("정상적으로 삭제되었습니다.");
		fm.action='partner_s_frame.jsp';
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
