<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename=over_time_excel_list.xls");
%>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*" %>
<jsp:useBean id="ot_db" scope="page" class="acar.over_time.OverTimeDatabase"/>

<%@ include file="/acar/cookies.jsp" %>
<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
-->
</script>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr"><!--������ export�� �ѱ۱��� ���� ����-->
<link rel=stylesheet type="text/css" href="../../include/table.css">
<body>

<%
	
	
	
	String acar_id = ck_acar_id;
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_br_id = request.getParameter("s_br_id")==null?"":request.getParameter("s_br_id");
	String dept_id = request.getParameter("dept_id")==null?"":request.getParameter("dept_id");
	String user_nm = request.getParameter("user_nm")==null?"":request.getParameter("user_nm");
	
	String st_mon = request.getParameter("st_mon")==null?"":request.getParameter("st_mon");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String st_year = request.getParameter("st_year")==null?"":request.getParameter("st_year");
	String asc 	= request.getParameter("asc")==null?"":request.getParameter("asc");
	
	int count = 0;
	
	Vector vt = ot_db.Over_List_Excel(user_id, st_year, st_mon, asc);
	int vt_size = vt.size();
	
	String doc_bit 	= request.getParameter("doc_bit")==null?"":request.getParameter("doc_bit");
	String doc_no 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String doc_step 	= request.getParameter("doc_step")==null?"":request.getParameter("doc_step");

	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String start_dt = request.getParameter("start_dt")==null?"":request.getParameter("start_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	int jg_time_t = 0;
%>

<!--
<p>* �μ⸦ �ϽǷ��� ���� ��ܸ޴����� ����>������������ ���� -> ���������� �������� ���ο� üũ�ϰ� �μ��Ͻʽÿ�. </p>
<P>�� �ϴ��� ������ ���� �� ��ġ�� ���� �� ������ �� �����ϴ�. (������)</P>
<P>��Ģ1 - �����ȣ�� 8�ڸ����� ����(������ �Ǵ� ����, Ư�����ڴ� - ����)</P>
<P>��Ģ2 - �����׸� ���� �Է� ������ XINSA �λ�޿��ý��ۿ��� ���� ��Ģ���� �Է��ؾ� �մϴ�. (��, �ð������� �Է��ϴ� ���� �ð����� �Է�)</P>
-->
<table border="1" cellspacing="0" cellpadding="1" width='100%' bordercolor="#000000">
	 <tr> 
        <td >
	        <table border="1" cellspacing="0" cellpadding="1" width='100%' bordercolor="#000000">
                <tr> 
                  <td align='center' width='5%'>����</td>
                  <td  align='center'  width='10%'>��û��</td>
                  <td  align='center'  width='7%'>�μ�</td>
                  <td  align='center'  width='10%'>�ͼӳ��</td>
                  <td  align='center'  width='15%'>��ٽð�</td>
                  <td  align='center'  width='15%'>��ٽð�</td>
                  <td  align='center'  width='10%'>�ٹ��ð�</td>
                  <td  align='center'  width='9%'>�ٷνð�</td>
                </tr>
			</table>
    	</td>
	</tr>
    <tr>
        <td >
            <table border="1" cellspacing="0" cellpadding="1" width='100%' bordercolor="#000000">
<% if(vt_size > 0)	{
	for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
			jg_time_t = jg_time_t + AddUtil.parseInt((String)ht.get("JB_TIME"));
%>             	
            	<tr>
            		<td width='5%' align="center"><%=i+1%></td>
            		<td width='10%' align="center"><%=ht.get("USER_NM")%></td>
            		<td width='7%' align="center"><%=ht.get("DEPT_NM")%></td>
            		<td width='10%' align="center"><%=ht.get("OVER_TIME_YEAR")%>��&nbsp;<%=ht.get("OVER_TIME_MON")%>��</td>
            		<td width='15%' align="center"><%=ht.get("START_DTHM")%></td>
            		<td width='15%' align="center"><%=ht.get("END_DTHM")%></td>
            		<td width='10%' align="center"><%=ht.get("HHMI")%></td>
            		<td width='9%' align="center"><%=ht.get("JB_TIME")%></td>
            	</tr>
<%}%>
				<tr>
					<td colspan="7" align="center">�հ�</td>
					<td align="center"><%=jg_time_t%></td>
				</tr>
<%}else{%>            	
	            <tr>
    	            <td colspan=9 align=center height=25>��ϵ� ����Ÿ�� �����ϴ�.</td>
        	    </tr>
<%}%>        	    
            </table>
        </td>
    </tr>
</table>
</body>
</html>
