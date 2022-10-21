<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename=settle_account_list_excel23.xls");
%>
<%@ page import="java.util.*, acar.util.*, acar.admin.*" %>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String settle_year 	= request.getParameter("settle_year")==null?"":request.getParameter("settle_year");
	String table_width	= request.getParameter("table_width")==null?"":request.getParameter("table_width");
	
	
	Vector vt = ad_db.getSettleAccount_list23(settle_year);
	int vt_size = vt.size();
	
	table_width = "1100";
	
	int r_cal = 0;
	int r_amt = 0;
	int t_amt = 0;
	
	float f_amt = 0;
	
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<form name='form1' action='' method='post'>
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type='hidden' name='br_id' value='<%=br_id%>'>
  <input type='hidden' name='user_id' value='<%=user_id%>'>
  <input type='hidden' name='settle_year' value='<%=settle_year%>'>
  <table border="0" cellspacing="1" cellpadding="0" width=<%=table_width%>>
	<tr>
	  <td align="center"><%=AddUtil.parseInt(settle_year)%>��  �̻�뿬����Ȳ </td>
	</tr>		
	<tr>
	  <td align="right"><%=AddUtil.parseInt(settle_year)%>��12��31�� ����</td>	  
    </tr>		
	<tr>
		<td class=line2></td>
	</tr>
	<tr> 
		<td class=line>
			<table border=1 cellspacing=1 width=100%>
			      <tr>
			      <td width="50" rowspan='3' align="center">����</td>
				  <td width="100" rowspan='3' align="center">�ٹ���</td>			   
				  <td width="100" rowspan='3' align="center">���</td>
				  <td width="100" rowspan='3' align="center">����</td>				  
			      <td width="100" rowspan='3' align="center">�Ի�����</td>
			      <td colspan='6' align="center">���߻�������Ȳ</td>
			      <td colspan='4' align="center">��⸻���� �̹߻�(����Ⱓ)����</td>			
			      <td colspan='3' align="center"></td>	
			     </tr>
			   <tr>     
				  <td colspan='3' align="center">��ӱٹ��Ⱓ</td>
				  <td colspan='3' align="center">������Ȳ</td>	
				  <td colspan='2' align="center">����Ⱓ(�̹߻�����)</td>	
				  <td colspan='2' align="center">�̹߻����� ������</td>
				  <td colspan='2' align="center">������</td>
				  <td rowspan='2' width="150" align="center">���������<br>(�ӿ�����)</td>	
				  			  
			    </tr>	
			    <tr>
			      <td width="50" align="center">��</td>
				  <td width="50" align="center">��</td>
			      <td width="50" align="center">��</td>
				  <td width="100" align="center">�����ϼ�</td>
				  <td width="100" align="center">���</td>		
				  <td width="100" align="center">�̻��<br>(�Ҽ���=����)<br>��A��</td>				
				  <td width="50" align="center">��</td>
			      <td width="50" align="center">��</td>
			      <td width="100" align="center">����������<br>�����ϼ�<br>(�ּ���)</td>
				  <td width="100" align="center">�̹߻������ϼ�<br>(�ּ���)<br>��B��</td>	
				  <td width="100" align="center">�����ϼ�<br>��A��+��B��</td>
			      <td width="100" align="center">���ر޿�</td>			  		  
			    </tr>				    		    
			    <%	for(int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);
					r_cal = (int) (AddUtil.parseDouble((String)ht.get("VACATION"))-AddUtil.parseDouble((String)ht.get("SU"))+AddUtil.parseDouble((String)ht.get("R_VACATION")));

					f_amt = AddUtil.parseFloat("1000000") / AddUtil.parseFloat("209")  *r_cal*8;
					
					r_amt = (int) f_amt;
					
					t_amt = t_amt + AddUtil.l_th_rnd(r_amt);
									
					
				%>
			    <tr>
				  <td align="center"><%=i+1%></td>			
				  <td align="center"><%=ht.get("DEPT_NM")%></td>
				  <td align="center"><%=ht.get("ID")%></td>
				  <td align="center"><%=ht.get("USER_NM")%></td>
				  <td align="center"><%=ht.get("ENTER_DT")%></td>
				  <td align="center"><%=ht.get("YEAR")%></td>
				  <td align="center"><%=ht.get("MONTH")%></td>
				  <td align="center"><%=ht.get("DAY")%></td>
				  <td align="center"><%=ht.get("VACATION")%></td>
				  <td align="center"><%=ht.get("SU")%></td>
				  <td align="center"><%= AddUtil.parseDouble((String)ht.get("VACATION"))-AddUtil.parseDouble((String)ht.get("SU")) %></td>
				  <td align="center"><%=ht.get("R_MONTH")%></td>
				  <td align="center"><%=ht.get("R_DAY")%></td>
				  <td align="center"><%=ht.get("VACATION")%></td>
				  <td align="center"><%=ht.get("R_VACATION")%></td>
				  <td align="center"><%=r_cal%></td>
				  <td align="right">1,000,000</td>
				  <td align="right"><%=Util.parseDecimal(AddUtil.l_th_rnd(r_amt))%></td>
			    </tr>
			    <%	}%>	
			     <tr> 
                    <td colspan="16"  class="title">�Ұ�(A)</td>
                    <td align="right"><%=Util.parseDecimal(1000000*vt_size) %></td>
                    <td align="right"><%=Util.parseDecimal(t_amt) %></td>
                </tr>
			</table>
		</td>
	</tr>
	
	<tr> 
        <td><div align="left"> <span class=style2>�� �ٷα��ع�</span></div></td>
    </tr>
    <tr> 
        <td>
          <p> �� ����ڴ� 1�Ⱓ 80�ۼ�Ʈ �̻� ����� �ٷ��ڿ��� 15���� �����ް��� �־�� �Ѵ�.	<br>
            �� ����ڴ� ����Ͽ� �ٷ��� �Ⱓ�� 1�� �̸��� �ٷ��� �Ǵ� 1�Ⱓ 80�ۼ�Ʈ �̸� ����� �ٷ��ڿ��� 1���� ���� �� 1���� �����ް��� �־�� �Ѵ�.	
          </p>     
        </td>
     </tr>
     <tr> 
        <td><div align="left"> <span class=style2>�� �ּ�</span></div></td>
    </tr>
    <tr> 
        <td>
          <p> �� 1�⸸���� �ƴ����� ���꿹���ϼ�(1�� �Ǵ� 0��)�� �ݿ����� ���� <br>
            �� �����������ϼ�/12*�̹߻���������Ⱓ�� ��, �ϼ��� ������ �ȵ������� ����
          </p>     
        </td>
     </tr> 		    
     			    
  </table>
</form>
</body>
</html>
