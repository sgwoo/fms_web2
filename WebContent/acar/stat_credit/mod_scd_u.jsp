<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*"%>
<%@ page import="acar.stat_credit.*"%>
<%@ page import="acar.util.*"%>
<jsp:useBean id="cr_db" scope="page" class="acar.stat_credit.CreditDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String cls_gubun = request.getParameter("cls_gubun")==null?"":request.getParameter("cls_gubun");
	String rent_st = request.getParameter("r_st")==null?"":request.getParameter("r_st");
	String tm = request.getParameter("tm")==null?"":request.getParameter("tm");
	String tm_st = request.getParameter("tm_st")==null?"0":request.getParameter("tm_st");
	if(!tm_st.equals("")) 	tm_st = "1"; //�ܾ�
	else					tm_st = "0";
	String table_nm = "";
	
	cls_gubun = AddUtil.replace(cls_gubun, " ","");
	if(cls_gubun.equals("�뿩��")) table_nm = "scd_fee";
	if(cls_gubun.equals("�����")) table_nm = "scd_ext";
	int count = 0;
	
	if(!table_nm.equals("")){
		if(!cr_db.updateCreditScd(cmd, table_nm, m_id, l_cd, rent_st, tm, tm_st)) 	count = 1;
%>
<script language='javascript'>
<%		if(count == 1){%>
			alert('�����߻�!');
<%		}else{%>
			alert('ó���Ǿ����ϴ�');
			parent.i_in.document.URL='/acar/stat_credit/credit_c_in.jsp?auth=<%=auth%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&m_id=<%=m_id%>&l_cd=<%=l_cd%>';
<%		}%>
<%	}%>
</script>