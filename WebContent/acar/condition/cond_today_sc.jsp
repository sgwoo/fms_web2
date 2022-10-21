<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.condition.*" %>
<%@ include file="/acar/cookies.jsp" %>
<%
	ConditionDatabase cdb = ConditionDatabase.getInstance();

	String ref_dt1 = Util.getDate();
	String ref_dt2 = Util.getDate();
	String auth_rw = "";
	String dt = "1";
	
	if(request.getParameter("auth_rw") != null)	auth_rw = request.getParameter("auth_rw");
	if(request.getParameter("dt") != null)	dt = request.getParameter("dt");
	if(request.getParameter("ref_dt1") != null)	ref_dt1 = request.getParameter("ref_dt1");
	if(request.getParameter("ref_dt2") != null)	ref_dt2 = request.getParameter("ref_dt2");
	
	String [] rcst = cdb.getRentCondSta(dt,ref_dt1,ref_dt2);
	
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link><script language="JavaScript">
<!--
function CarRegList(rent_mng_id, rent_l_cd, car_mng_id, reg_gubun, rpt_no, firm_nm, client_nm, imm_amt)
{
	var theForm = document.CarRegDispForm;
	theForm.rent_mng_id.value = rent_mng_id;
	theForm.rent_l_cd.value = rent_l_cd;
	theForm.car_mng_id.value = car_mng_id;
	theForm.cmd.value = reg_gubun;
	theForm.rpt_no.value = rpt_no;
	theForm.firm_nm.value = firm_nm;
	theForm.client_nm.value = client_nm;
	theForm.imm_amt.value = imm_amt;
	
<% 
	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6"))
	{
%>
		//theForm.action = "./register_frame.jsp";
		theForm.action = "./register_frame.jsp";
<%
	}else{
%>
		if(reg_gubun=="id")
		{
			alert("�̵�� �����Դϴ�.");
			return;
		}
		//theForm.action = "./register_r_frame.jsp";
		theForm.action = "./register_frame.jsp";
<%
	}
%>
	theForm.target = "d_content"
	theForm.submit();
}
//-->
</script>
</head>
<body>


<table border=0 cellspacing=0 cellpadding=0 width=800>
    <tr>
		<td>
			 <table border="0" cellspacing="1" cellpadding="0" width=800>
				<tr>
					<td><iframe src="./rent_cond_sc_in.jsp?auth_rw=<%=auth_rw%>&dt=<%=dt%>&ref_dt1=<%=ref_dt1%>&ref_dt2=<%=ref_dt2%>" name="RegCondList" width="800" height="459" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe></td>
				</tr>							
	
			</table>
		</td>
	</tr>
    <tr>
        <table border=0 cellspacing=0 cellpadding=0 width=800>
        	<tr>
        		<td>< �뿩���(��) ></td>
        		<td>&nbsp;</td>
        		<td>< �뿩����(��) ></td>
        		<td>&nbsp;</td>
        		<td>< �뿩���(��) ></td>
        	</tr>
        	<tr>
    		    <td class=line>
		            <table border=0 cellspacing=1 width=100%>
		            	<tr>
		            		<td class=title>�Ϲݽ�</td>
		            		<td class=title>�����</td>
		            		<td class=title>�⺻��</td>
		            	</tr>
		            	<tr>
		            		<td align="right"><%=rcst[0]%> �� </td>
		            		<td align="right"><%=rcst[1]%> �� </td>
		            		<td align="right"><%=rcst[2]%> �� </td>
		            	</tr>
		            </table>
		        </td>
		        <td>&nbsp;</td>
		        <td class=line>
		        	<table border=0 cellspacing=1 width=100%>
		            	<tr>
		            		<td class=title>48����</td>
		            		<td class=title>36����</td>
		            		<td class=title>24����</td>
		            		<td class=title>12����</td>
		            		<td class=title>��Ÿ</td>

		            	</tr>
		            	<tr>
		            		<td align="right"><%=rcst[6]%> �� </td>
		            		<td align="right"><%=rcst[5]%> �� </td>
		            		<td align="right"><%=rcst[4]%> �� </td>
		            		<td align="right"><%=rcst[3]%> �� </td>
		            		<td align="right"><%=rcst[7]%> �� </td>
		            	</tr>
		            </table>
		        </td>
		        <td>&nbsp;</td>
		        <td class=line>
		            <table border=0 cellspacing=1 width=100%>
		            	<tr>
		            		<td class=title>���ް�</td>
		            		<td class=title>�ΰ���</td>
		            		<td class=title>�հ�</td>
		            	</tr>
		            	<tr>
		            		<td align="right"><%=Util.parseDecimal(rcst[8])%> ��</td>
		            		<td align="right"><%=Util.parseDecimal(rcst[9])%> ��</td>
		            		<td align="right"><%=Util.parseDecimal(rcst[10])%> ��</td>
		            	</tr>
		            </table>
		        </td>
			</tr>
		</table>
    </tr>
</table>

</body>
</html>