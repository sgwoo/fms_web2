<%//@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename=rent_board_ac_excel_incheon.xls");
%>
<%@ page import="java.util.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="ec_db" scope="page" class="acar.cont.EtcContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	String vid[] 	= request.getParameterValues("ch_cd");
	int vid_size = vid.length;
	
	String vid_num		= "";
	String rent_mng_id 	= "";
	String rent_l_cd 	= "";
	
	long total_amt1	= 0;
	long total_amt2 = 0;
	long total_amt3	= 0;
	
	//��õ����
	Hashtable br = c_db.getBranch("I1");
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
//-->
</script>
<body>
<% int col_cnt = 31;%>
<table border="0" cellspacing="0" cellpadding="0" width=1970>
  <tr>
	  <td colspan='<%=col_cnt%>' align='center' style="font-size : 20pt;" height="50">(��)�Ƹ���ī �ڵ��� �űԵ�� ��û ����Ʈ (<%=AddUtil.getDate()%>)</td>
	</tr>
  <tr>
	  <td colspan='<%=col_cnt%>' height="20"></td>
	</tr>
</table>
<table border="1" cellspacing="0" cellpadding="0" width=1870>
	<tr>
    <td colspan="13" align='center' style="font-size : 15pt;" height="40">�������� �Է�</td>
    <td colspan="9" align='center' style="font-size : 15pt;">����� �Է�</td>
		<td colspan="8" align='center' style="font-size : 15pt;">��Ÿ�Է�</td>
  </tr>
  <tr>
    <td colspan="2"  align='center' style="font-size : 8pt;" height="30">����</td>
    <td colspan="3"  align='center' style="font-size : 8pt;">����������</td>
    <td colspan="6" align='center' style="font-size : 8pt;">����������</td>
    <td colspan="2" align='center' style="font-size : 8pt;">����������</td>
    <td align='center' style="font-size : 8pt;">����</td>
	  <td align='center' style="font-size : 8pt;">ä��</td>
	  <td colspan="3" align='center' style="font-size : 8pt;">Ư�̻���</td>
    <td colspan="4" align='center' style="font-size : 8pt;">��������</td>
    <td align='center' style="font-size : 8pt;">������ȣ</td>
    <td align='center' style="font-size : 8pt;" colspan='2'>�ڻ�������</td>
	  <td colspan="3" align='center' style="font-size : 8pt;">���������(����)</td>
    <td colspan="2" align='center' style="font-size : 8pt;">���Ⱑ�� �� ��������</td>
    <td rowspan='2' align='center' style="font-size : 8pt;">�������</td>
  </tr>
  <tr>
		<td width='30' align='center' style="font-size : 8pt;">����</td>
		<td width='30' align='center' style="font-size : 8pt;">����</td>
		<td width='70' align='center' style="font-size : 8pt;">�����ڸ�</td>
	  <td width='60' align='center' style="font-size : 8pt;">���ι�ȣ</td>
	  <td width='150' align='center' style="font-size : 8pt;">��뺻����</td>
	  <td width='50' align='center' style="font-size : 8pt;">������������</td>
	  <td width='100' align='center' style="font-size : 8pt;">����</td>
	  <td width='50' align='center' style="font-size : 8pt;">����������</td>
	  <td width='100' align='center' style="font-size : 8pt;">�����ȣ</td>
	  <td width='60' align='center' style="font-size : 8pt;">����������ȣ</td>
	  <td width='80' align='center' style="font-size : 8pt;">���ް���</td>
	  <td width='60' align='center' style="font-size : 8pt;">���ԽŰ��ȣ</td>
	  <td width='60' align='center' style="font-size : 8pt;">���ԽŰ���</td>
	  <td width='60' align='center' style="font-size : 8pt;">����ȣ</td>
	  <td width='60' align='center' style="font-size : 8pt;">ä������</td>
	  <td width='50' align='center' style="font-size : 8pt;">����</td>
	  <td width='60' align='center' style="font-size : 8pt;">���ǹ�ȣ</td>
	  <td width='60' align='center' style="font-size : 8pt;">��ȣ��Ư�̻���</td>
	  <td width='50' align='center' style="font-size : 8pt;">����������</td>
	  <td width='50' align='center' style="font-size : 8pt;">�ֹι�ȣ</td>
	  <td width='50' align='center' style="font-size : 8pt;">�ּ�</td>
	  <td width='50' align='center' style="font-size : 8pt;">������</td>
	  <td width='80' align='center' style="font-size : 8pt;">����ī�ο���ȣ</td>
    <td width='80' align='center' style="font-size : 8pt;">����Ÿ�</td>
    <td width='80' align='center' style="font-size : 8pt;">�ܱ�������</td>
	  <td width='70' align='center' style="font-size : 8pt;">����ڸ�</td>
	  <td width='60' align='center' style="font-size : 8pt;">���ι�ȣ</td>
	  <td width='150' align='center' style="font-size : 8pt;">�ּ�</td>
	  <td width='60' align='center' style="font-size : 8pt;">�ڵ������Ⱑ��������ȣ</td>
	  <td width='60' align='center' style="font-size : 8pt;">�ڵ�������������ȣ</td>
	</tr>
	<%	for(int i=0;i < vid_size;i++){
				rent_l_cd = vid[i];
				Hashtable ht = ec_db.getRentBoardSubAcCase(rent_l_cd);
				total_amt1 	= total_amt1 + Long.parseLong(String.valueOf(ht.get("CAR_AMT")));
	%>
	<tr>
    <td align='center' style="font-size : 8pt;"><%=i+1%></td>
    <td align='center' style="font-size : 8pt;">��Ʈ</td>
    <td align='center' style="font-size : 8pt;">(��)�Ƹ���ī</td>
    <td align='center' style="font-size : 8pt;">115611-0019610</td>
    <td align='center' style="font-size : 8pt;"><%=br.get("BR_ADDR")%></td>
    <td align='center' style="font-size : 8pt;"></td>
    <td align='center' style="font-size : 8pt;"><%=ht.get("CAR_NM")%>&nbsp;<%=ht.get("CAR_NAME")%></td>
    <td align='center' style="font-size : 8pt;"></td>
    <td align='center' style="font-size : 8pt;"><%=ht.get("CAR_NUM")%></td>
    <td align='center' style="font-size : 8pt;"></td>
    <td align='right' style="font-size : 8pt;"><%=AddUtil.parseDecimal(String.valueOf(ht.get("CAR_AMT")))%></td>
    <td align='center' style="font-size : 8pt;"></td>
    <td align='center' style="font-size : 8pt;"></td>
    <td align='center' style="font-size : 8pt;"></td>
    <td align='center' style="font-size : 8pt;"></td>
    <td align='center' style="font-size : 8pt;"></td>
    <td align='center' style="font-size : 8pt;">�ӽÿ���̹߱�</td>
    <td align='center' style="font-size : 8pt;"></td>
    <td align='center' style="font-size : 8pt;"></td>
    <td align='center' style="font-size : 8pt;"></td>
    <td align='center' style="font-size : 8pt;"></td>
    <td align='center' style="font-size : 8pt;"></td>
    <td align='center' style="font-size : 8pt;"><%=ht.get("EST_CAR_NO")%></td>
    <td align='right' style="font-size : 8pt;"><%=AddUtil.parseDecimal(String.valueOf(ht.get("SH_KM")))%></td>
    <td align='center' style="font-size : 8pt;"><%=ht.get("PUR_PAY_DT")%></td>
    <td align='center' style="font-size : 8pt;"></td>
		<td align='center' style="font-size : 8pt;"></td>
    <td align='center' style="font-size : 8pt;"></td>
    <td align='center' style="font-size : 8pt;"></td>
    <td align='center' style="font-size : 8pt;"></td>
    <td align='center' style="font-size : 8pt;"></td>
	</tr>
	<%}%>
</table>
<script language='javascript'>
<!--
//-->
</script>
</body>
</html>

