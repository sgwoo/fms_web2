<%//@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename=rent_board_excel_ins38.xls");
%>
<%@ page import="java.util.*, acar.util.*, acar.cont.* "%>
<%@ include file="/acar/cookies.jsp" %>
<jsp:useBean id="ec_db" scope="page" class="acar.cont.EtcContDatabase"/>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");	
	String mod_st 	= request.getParameter("mod_st")==null?"":request.getParameter("mod_st");		
	
	Vector vt = ec_db.getRentBoardInsList("99", "��Ʈ", gubun1, gubun2, st_dt, end_dt, mod_st);
	int vt_size = vt.size();
%>

<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>FMS</title>
</head>
<body>

<table border="0" cellspacing="0" cellpadding="0" width='1340'>
    <tr>
        <td height="40" align="center" style="font-size : 20pt;"><b>�������ս�û��</b></td>
    </tr>
    <tr>
        <td align='right'>�ѰǼ� : <%=vt_size%>��</td>
    </tr>    
    <tr>
	<td height="25" style="font-size : 12pt;">�ͻ�� ü���� ��� �ڵ��� ���� û�༭�� ���ʼ���(���γ���)�� �Ͽ��� �ϳ� �ε����� ������ ���Ͽ� �ϱ�ǿ� ���ؼ��� ��Ȯ�μ��� ��ü�ϰ����մϴ�.</td>
    </tr>    
    <tr> 
      <td height="10" align='center'></td>
    </tr>    
    <tr>
	<td height="25" style="font-size : 12pt;">�ͻ�� ü���� �ڵ��� ���� û�༭ ���� ��� ������ �����ϸ� Ư�� �ϱ� ���ǿ� ���Ͽ� �ٽ��ѹ� Ȯ���ϸ� ��� ���ǵ� �������� ���� ���� Ȯ���մϴ�.</td>
    </tr>    
    <tr>
	<td>&nbsp;</td>
    </tr>           
    <tr>
	<td align='right' height="50" style="font-size : 15pt;">
	    <table width="100%" border="0" cellspacing="1" cellpadding="0">
	        <tr>
	            <td width='860' >&nbsp;</td>
	            <td width='100' valign="top" >�ǰ����� : </td>
	            <td width='300' >����� �������� �ǻ���� 8,<br>
	                             802ȣ (���ǵ���, ����̾ؾ�����)<br><br>
	                             <span class=style6>(��)�Ƹ���ī ��ǥ�̻� &nbsp;&nbsp;&nbsp;&nbsp;�� &nbsp;&nbsp;&nbsp;&nbsp;�� &nbsp;&nbsp;&nbsp;&nbsp;��
	            </td>
	            <td width='80' ><img src="http://fms1.amazoncar.co.kr/acar/images/stamp.png" width="75" height="75"></td>
	        </tr>
	    </table>
	</td>
    </tr>           
    <tr>
	<td>&nbsp;</td>
    </tr>                   
    <tr bgcolor="#000000">
        <td>
	    <table width="100%" border="1" cellspacing="1" cellpadding="0">
		<tr bgcolor="#A6FFFF" align="center"> 			        
			<td align='center' width='30' rowspan='2' style="font-size : 8pt;">����</td>
			<td height="25" align='center' colspan='2' style="font-size : 8pt;">������</td>
			<td align='center' colspan='4' style="font-size : 8pt;">��������</td>
			<td align='center' colspan='4' style="font-size : 8pt;">�㺸��</td>
			<td align='center' colspan='3' style="font-size : 8pt;">���ڽ�</td>
			
		</tr>					
		<tr bgcolor="#A6FFFF" align="center"> 								
			<td height="25" align='center' width="120" style="font-size : 8pt;">��</td>
			<td align='center' width="100" style="font-size : 8pt;">����ڵ�Ϲ�ȣ</td>			
			<td align='center' width='140' style="font-size : 8pt;">����</td>				  
			<td align='center' width='80' style="font-size : 8pt;">������ȣ</td>
			<td align='center' width='150' style="font-size : 8pt;">�����ȣ</td>
			<td align='center' width='100' style="font-size : 8pt;">�����Һ��ڰ�</td>			
			<td align='center' width='80' style="font-size : 8pt;">�����ڿ���</td>
			<td align='center' width='80' style="font-size : 8pt;">�빰���</td>
			<td align='center' width='80' style="font-size : 8pt;">�ڱ��ü���</td>
			<td align='center' width='100' style="font-size : 8pt;">�����������ڵ�������</td>	
			<td align='center' width='100' style="font-size : 8pt;">���ڽ�</td>
			<td align='center' width='80' style="font-size : 8pt;">����(���ް�)</td>
			<td align='center' width='100' style="font-size : 8pt;">�ø����ȣ</td>			
		</tr>					
		<%	if(vt_size > 0){%>
		<%		for(int i = 0 ; i < vt_size ; i++){
						Hashtable ht = (Hashtable)vt.elementAt(i);
					
							String b_amt = String.valueOf(ht.get("B_AMT"));
							if(!String.valueOf(ht.get("B_MODEL_NM")).equals("") && AddUtil.parseDecimal(b_amt).equals("0")){
								b_amt = "92727";
							}
							String b_model_nm = String.valueOf(ht.get("B_COM_NM"))+"-"+String.valueOf(ht.get("B_MODEL_NM"));
							if(String.valueOf(ht.get("B_SERIAL_NO")).equals("") && AddUtil.parseDecimal(b_amt).equals("0")){
								b_model_nm = "";
							}
		%>
		<tr bgcolor="#FFFFFF" align="center">			        
			<td height="25" align='center' style="font-size : 8pt;"><%=i+1%></td>
			<td align='center' style="font-size : 8pt;"><%=ht.get("FIRM_NM")%></td>
			<td align='center' style="font-size : 8pt;"><%=AddUtil.ChangeEnpH(String.valueOf(ht.get("SSN")))%></td>
			<td align='center' style="font-size : 8pt;"><%=ht.get("CAR_NM")%>&nbsp;<%=ht.get("CAR_NAME")%></td>
			<td align='center' style="font-size : 8pt;"><%=ht.get("CAR_NO")%></td>
			<td align='center' style="font-size : 8pt;"><%=ht.get("CAR_NUM")%></td>
			<td align='right' style="font-size : 8pt;"><%=AddUtil.parseDecimal(String.valueOf(ht.get("TOT_AMT")))%></td>
			<td align='center' style="font-size : 8pt;"><%String driving_age = (String)ht.get("DRIVING_AGE");%><%if(driving_age.equals("0")){%>26���̻�<%}else if(driving_age.equals("3")){%>24���̻�<%}else if(driving_age.equals("1")){%>21���̻�<%}else if(driving_age.equals("5")){%>30���̻�<%}else if(driving_age.equals("6")){%>35���̻�<%}else if(driving_age.equals("7")){%>43���̻�<%}else if(driving_age.equals("8")){%>48���̻�<%}else if(driving_age.equals("2")){%>��������<%}%></td>			
			<td align='center' style="font-size : 8pt;"><%String gcp_kd = (String)ht.get("GCP_KD");%><%if(gcp_kd.equals("1")){%>5õ����<%}else if(gcp_kd.equals("2")){%>1���<%}else if(gcp_kd.equals("3")){%>5���<%}else if(gcp_kd.equals("4")){%>2���<%}else if(gcp_kd.equals("8")){%>3���<%}%></td>
			<td align='center' style="font-size : 8pt;"><%String bacdt_kd = (String)ht.get("BACDT_KD");%><%if(bacdt_kd.equals("1")){%>5õ����<%}else if(bacdt_kd.equals("2")){%>1���<%}%></td>
			<td align='center' style="font-size : 8pt;"><%=ht.get("COM_EMP_YN")%></td>
			<td align='center' style="font-size : 8pt;"><%=b_model_nm%></td>
			<td align='right' style="font-size : 8pt;"><%=AddUtil.parseDecimal(b_amt)%></td>
			<td align='center' style="font-size : 8pt;"><%=ht.get("B_SERIAL_NO")%></td>
		</tr>
		<%		}%>
		<%	}%>                  
	    </table>
	</td>
    </tr>  		    		  
</table>
</body>
</html>

