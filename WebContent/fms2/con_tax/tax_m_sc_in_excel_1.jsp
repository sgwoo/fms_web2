<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.con_tax.*"%>
<jsp:useBean id="t_db" scope="page" class="acar.con_tax.TaxDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String gubun6 	= request.getParameter("gubun6")==null?"":request.getParameter("gubun6");
	String gubun7 	= request.getParameter("gubun7")==null?"":request.getParameter("gubun7");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	String asc 		= request.getParameter("asc")==null?"":request.getParameter("asc");
	
	int total_su = 0;
	long total_amt = 0;
	long rtn_amt = 0;
	
	Vector taxs = t_db.getTaxMngList(gubun1, gubun2, gubun3, gubun4, gubun5, gubun6, gubun7, st_dt, end_dt, s_kd, t_wd, sort, asc);
	int tax_size = taxs.size();
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--

//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body onLoad="javascript:init()">

<form name='form1' method='post'>
<table border="0" cellspacing="0" cellpadding="0" width=1100>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr>
	<td class='line' >
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<tr>
		    <td rowspan="2" class='title'>����</td>
		    <td rowspan="2" class='title'>���⿬��</td>
		    <td rowspan="2" class='title'>ȣ�񱸺�</td>
		    <td rowspan="2" class='title'>��ǰ��</td>
		    <td rowspan="2" class='title'>�����ڵ�</td>
		    <td rowspan="2" class='title'>�԰�</td>
		    <td rowspan="2" class='title'>�����ȣ</td>
		    <td rowspan="2" class='title'>����</td>
		    <td rowspan="2" class='title'>�ܰ�</td>
		    <td rowspan="2" class='title'>���Ⱑ��</td>
		    <td rowspan="2" class='title'>����ǥ��</td>
		    <td rowspan="2" class='title'>����</td>
		    <td rowspan="2" class='title'>����</td>
		    <td rowspan="2" class='title'>���⼼��</td>
		    <td rowspan="2" class='title'>��������</td>
		    <td class='title' colspan='2'>���꼼</td>
		    <!--
		    <td rowspan="2" class='title'>����ó</td>
		    <td rowspan="2" class='title'>����.�Խ��ι�ȣ</td>		    
		    -->
		</tr>
		<tr>
		  <td class='title'>�Ű�<br>�Ҽ���</td>
		  <td class='title'>����<br>�Ҽ���</td>
		</tr>
		<%if(tax_size > 0){%>
            	<%	for(int i = 0 ; i < tax_size ; i++){
				Hashtable tax = (Hashtable)taxs.elementAt(i);%>
                <tr> 
                    <td rowspan="3" align='center'>��������</td>
                    <td rowspan="3" align='center'><%=tax.get("TAX_COME_DT")%></td>
                    <td rowspan="3" align='center'>�Ϲݽ¿��ڵ���<%if(AddUtil.parseInt(String.valueOf(tax.get("DPM"))) > 2000){%>(2000cc�ʰ�)(2-3��)<%}else{%>(2000cc�̸�)(2011��ͼӺ���)(2-3<%}%></td>
                    <td rowspan="3" align='center'><%=tax.get("CAR_NO")%></td>
                    <td rowspan="3" align='center'></td>
                    <td rowspan="3" align='right'>0</td>
                    <td rowspan="3" align='center'><%=tax.get("CAR_NUM")%></td>
                    <td rowspan="3" align='right'>1</td>
                    <td rowspan="3" align='right'><%=Util.parseDecimal(String.valueOf(tax.get("SUR_AMT")))%></td>
                    <td rowspan="3" align='right'><%=Util.parseDecimal(String.valueOf(tax.get("SUR_AMT")))%></td>
                    <td rowspan="3" align='right'><%=Util.parseDecimal(String.valueOf(tax.get("SUR_AMT")))%></td>
                    <td rowspan="3" align='right'><%=tax.get("TAX_RATE")%></td>
                    <td align='center'>�����Һ�</td>
                    <td align='right'><%=Util.parseDecimal(String.valueOf(tax.get("SPE_TAX_AMT")))%></td>
                    <td align='right'>0</td>
                    <td align='right'>0</td>
                    <td align='right'>0</td>
                    <!--
                    <td rowspan="3" align='center'></td>
                    <td rowspan="3" align='center'></td>
                    -->
                </tr>
                <tr>
                  <td align='center'>������</td>
                  <td align='right'><%=Util.parseDecimal(String.valueOf(tax.get("EDU_TAX_AMT")))%></td>
                  <td align='right'>0</td>
                  <td align='right'>0</td>
                  <td align='right'>0</td>
                </tr>
                <tr>
                  <td align='center'>�����Ư����</td>
                  <td align='right'>0</td>
                  <td align='right'>0</td>
                  <td align='right'>0</td>
                  <td align='right'>0</td>
                </tr>
                <%}}%>
            </table>
      </td>
</table>
</form>
</body>
</html>
