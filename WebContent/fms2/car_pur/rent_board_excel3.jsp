<%//@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename=rent_board_excel3.xls");
%>

<%@ page import="java.util.*,acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>
<jsp:useBean id="ec_db" scope="page" class="acar.cont.EtcContDatabase"/>

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
	
	String mod_st = request.getParameter("mod_st")==null?"":request.getParameter("mod_st");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	int count =0;
	
	Vector vt = ec_db.getRentBoardInsList(s_kd, t_wd, gubun1, gubun2, st_dt, end_dt, mod_st);
	int vt_size = vt.size();
%>

<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
</head>
<body>
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>        
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='from_page' value='/fms2/car_pur/pur_doc_frame.jsp'>
<table border="0" cellspacing="0" cellpadding="0" width='1650'>
	<tr>
		<td class='line' width='100%'>
			<table border="1" cellspacing="1" cellpadding="0" width='100%'>
			    <tr>					
					<td width='30' class='title'>����</td>					
					<td width="100" class='title'>��</td>
					<td width="110" class='title'>����ڵ�Ϲ�ȣ</td>					
					<td width='50' class='title'>�뵵</td>
					<td width='50' class='title'>�����ؽ�ƼĿ</td>
					<td width='50' class='title'>���ΰ�</td>
					<td width='90' class='title'>����</td>				  					
					<td width='100' class='title'>��Ͽ�����</td>					
					<td width='90' class='title'>������ȣ</td>
					<td width='140' class='title'>�����ȣ</td>
					<td width='140' class='title'>�����Һ��ڰ�</td>
					<td width='100' class='title'>��������</td>
					<td width='100' class='title'>�Ǻ�����</td>
					<td width='100' class='title'>�����ڿ���</td>					
					<td width='100' class='title'>�빰���</td>					
					<td width='100' class='title'>���ڽ�</td>
					<td width='100' class='title'>����(���ް�)</td>
					<td width='100' class='title'>�ø����ȣ</td>					
					<td width='100' class='title'>�����������ڵ�������</td>
			  </tr>
			</table>
		</td>
	</tr>
<%
	if(vt_size > 0)
	{
%>
	<tr>
		<td class='line' width='100%'>
			<table border="1" cellspacing="1" cellpadding="0" width='100%'>
<%
		for(int i = 0 ; i < vt_size ; i++)
		{
			Hashtable ht = (Hashtable)vt.elementAt(i);
			
%>
				<tr>					
					<td  width='30' align='center'><%=i+1%></td>
					<td  width='100' align='center'><%=ht.get("FIRM_NM")%></td>
					<td  width='110' align='center'><%=AddUtil.ChangeEnpH(String.valueOf(ht.get("SSN")))%></td>						
					<td  width='50' align='center'><%if(String.valueOf(ht.get("CAR_ST")).equals("����")){%><font color=red><%}%><%=ht.get("CAR_ST")%><%if(String.valueOf(ht.get("CAR_ST")).equals("����")){%></font><%}%></td>
					<td  width='50' align='center'><%if(String.valueOf(ht.get("JG_G_16")).equals("1")){%><font color=red>[������]</font><%}%></td>
					<td  width='50' align='center'><%if(String.valueOf(ht.get("HOOK_YN")).equals("Y")){%><font color=red>[���ΰ�]</font><%}%></td>
					<td  width='90' align='center'><%=ht.get("CAR_NM")%>&nbsp;<%=ht.get("CAR_NAME")%></td>
					<td  width='100' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REG_EST_DT")))%></td>					
					<td  width='90' align='center'><%=ht.get("CAR_NO")%></td>
					<td  width='140' align='center'><%=ht.get("CAR_NUM")%></td>										
					<td  width='140' align='center'><%=ht.get("TOT_AMT")%></td>
					<td  width='100' align='center'><%=ht.get("INSURANT")%></td>
					<td  width='100' align='center'><%=ht.get("INSUR_PER")%></td>
					<td  width='100' align='center'>
						<%String driving_age = (String)ht.get("DRIVING_AGE");%><%if(driving_age.equals("0")){%>26���̻�<%}else if(driving_age.equals("3")){%>24���̻�<%}else if(driving_age.equals("1")){%>21���̻�<%}else if(driving_age.equals("5")){%>30���̻�<%}else if(driving_age.equals("6")){%>35���̻�<%}else if(driving_age.equals("7")){%>43���̻�<%}else if(driving_age.equals("8")){%>48���̻�<%}else if(driving_age.equals("2")){%>��������<%}%>
					</td>					
					<td  width='100' align='center'><%String gcp_kd = (String)ht.get("GCP_KD");%><%if(gcp_kd.equals("1")){%>5õ����<%}else if(gcp_kd.equals("2")){%>1���<%}else if(gcp_kd.equals("3")){%>5���<%}else if(gcp_kd.equals("4")){%>2���<%}else if(gcp_kd.equals("8")){%>3���<%}%></td>
					<td  width='100' align='center'>
					<%if(String.valueOf(ht.get("CAR_COMP_ID")).equals("0056")){%>
						������
					<%}else{%>
					<%=ht.get("B_COM_NM")%>-<%=ht.get("B_MODEL_NM")%>
					<%}%>
					</td>
					<td  width='100' align='right'>
					<%if(String.valueOf(ht.get("B_COM_NM")).equals("�̳��Ƚ�") &&String.valueOf(ht.get("B_COM_NM")).equals("�̳��Ƚ�") && (String.valueOf(ht.get("B_MODEL_NM")).equals("LX100") || String.valueOf(ht.get("B_MODEL_NM")).equals("IX200") || String.valueOf(ht.get("B_MODEL_NM")).equals("IX-200")) && AddUtil.parseDecimal(String.valueOf(ht.get("B_AMT"))).equals("0")){%>
						<%//if(AddUtil.parseInt(String.valueOf(ht.get("REG_EST_DT")).substring(0,8)) < 20160201){%>
						<!--104,545-->
						<%//}else{%>
						92,727
						<%//}%>
					<%}else{%>
					<%=AddUtil.parseDecimal(String.valueOf(ht.get("B_AMT")))%>
					<%}%>
					</td>
					<td  width='100' align='center'>
					<%if(String.valueOf(ht.get("CAR_COMP_ID")).equals("0056")){%>
						������
					<%}else{%>
						<%=ht.get("B_SERIAL_NO")%>
					<%}%>
					
					</td>										
					<td  width='100' align='center'><%=ht.get("COM_EMP_YN")%></td>										
				</tr>
<%
		}
%>
			</table>
		</td>
<%	}                  
	else               
	{
%>                     
	<tr>
		<td class='line' width='100%'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td align='center'>
					<%if(t_wd.equals("")){%>�˻�� �Է��Ͻʽÿ�.
					<%}else{%>��ϵ� ����Ÿ�� �����ϴ�<%}%></td>
				</tr>
			</table>
		</td>
	</tr>
<%                     
	}                  
%>
</table>
</form>

<script language='javascript'>
<!--
	parent.document.form1.size.value = '<%=vt_size%>';
//-->
</script>
</body>
</html>

