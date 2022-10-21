<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*"%>
<%@ page import="acar.con_ins.*"%>
<%@ page import="acar.util.*"%>
<jsp:useBean id="ai_db" scope="page" class="acar.con_ins.AddInsurDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title></head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String idx 	= request.getParameter("idx")==null?"":request.getParameter("idx");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	InsurComBean ins = new InsurComBean();
	ins.setIns_com_id	(request.getParameter("ins_com_id")==null?"":request.getParameter("ins_com_id"));
	ins.setIns_com_nm	(request.getParameter("ins_com_nm")==null?"":request.getParameter("ins_com_nm"));
	ins.setCar_rate		(request.getParameter("car_rate")==null?"":request.getParameter("car_rate"));
	ins.setIns_rate		(request.getParameter("ins_rate")==null?"":request.getParameter("ins_rate"));
	ins.setExt_date		(request.getParameter("ext_date")==null?"":request.getParameter("ext_date"));
	ins.setAgnt_tel		(request.getParameter("agnt_tel")==null?"":request.getParameter("agnt_tel"));
	ins.setAgnt_fax		(request.getParameter("agnt_fax")==null?"":request.getParameter("agnt_fax"));
	ins.setAgnt_imgn_tel	(request.getParameter("agnt_imgn_tel")==null?"":request.getParameter("agnt_imgn_tel"));
	ins.setAcc_tel		(request.getParameter("acc_tel")==null?"":request.getParameter("acc_tel"));
	ins.setZip		(request.getParameter("t_zip")==null?"":request.getParameter("t_zip"));
	ins.setZip1		(request.getParameter("t_zip1")==null?"":request.getParameter("t_zip1"));
	ins.setAddr		(request.getParameter("t_addr")==null?"":request.getParameter("t_addr"));
	ins.setAddr1		(request.getParameter("t_addr1")==null?"":request.getParameter("t_addr1"));
	ins.setIns_com_f_nm	(request.getParameter("ins_com_f_nm")==null?"":request.getParameter("ins_com_f_nm"));
	
	if(ins.getIns_com_f_nm().equals("")){
		ins.setIns_com_f_nm(ins.getIns_com_nm());
	}
	
	
	int count = 0;
	if(cmd.equals("i")){		//등록
		if(!ai_db.insertInsCom(ins))	count += 1;
	}else if(cmd.equals("u")){	//수정
		if(!ai_db.updateInsCom(ins))	count += 1;
	}else{}
%>
<script language='javascript'>
<%	if(count != 0){%>
		alert('오류발생!');
		location='about:blank';
<%	}else{%>
		alert('처리되었습니다');
		if('<%=from_page%>' == '/acar/accid_mng/find_gov_search.jsp'){
			parent.parent.location='<%=from_page%>?t_wd=<%=t_wd%>&idx=<%=idx%>';
		}else{
			parent.parent.location='/acar/con_ins/ins_com_frame.jsp?auth_rw=<%=auth_rw%>';
		}		
<%	}%>
</script>
</body>
</html>
