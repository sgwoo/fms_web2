<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*"%>
<%@ page import="acar.cont.*, acar.commi_mng.*, acar.car_office.*"%>
<jsp:useBean id="acm_db" scope="page" class="acar.commi_mng.AddCommiDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
				
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	
	String emp_id = request.getParameter("emp_id")==null?"":request.getParameter("emp_id");//�������  id	
//	String emp_acc_nm = request.getParameter("emp_acc_nm")==null?"":request.getParameter("emp_acc_nm");//�Ǽ�����
	
	//default:�������	
	CarOffEmpBean coe_bean = cod.getCarOffEmpBean(emp_id);
	
//	Hashtable emp_i = acm_db.getEmpAccNm(emp_id, emp_acc_nm);	

    String st_dt =  acm_db.getMaxSetDt(emp_id);	
	
	//�� ���̺� �⺻ ����
	int table1_h = 315+120;
	
	String r_name="";
	
%>

<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript" type="text/JavaScript">	

	function onprint(){
		factory.printing.header 	= ""; //��������� �μ�
		factory.printing.footer 	= ""; //�������ϴ� �μ�
		factory.printing.portrait 	= true; //true-�����μ�, false-�����μ�    
		factory.printing.leftMargin 	= 12.0; //��������   
		factory.printing.rightMargin 	= 12.0; //��������
		factory.printing.topMargin 	= 20.0; //��ܿ���    
		factory.printing.bottomMargin 	= 30.0; //�ϴܿ���
		factory.printing.Print(true, window);//arg1-��ȭ����ǥ�ÿ���(true or false), arg2-��ü������orƯ��������
	}

</script>
</head>
<object id=factory style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,3,439,30">
</object>
<body onLoad="javascript:onprint();">
<div id="Layer1" style="position:absolute; left:535px; top:850px; width:109px; height:108px; z-index:1"><img src="/images/square.png" width="109" height="108"></div>
<form action="" name="form1" method="POST" >
  <table width='670' height="<%=table1_h%>" border="0" cellpadding="0" cellspacing="0">
    <tr> 
      <td colspan="2" height="40" align="left" style="font-size : 18pt;"><b><font face="����">(��)�Ƹ���ī</font></b></td>
    </tr>
    <tr> 
      <td colspan="2" height="15" align="left" style="font-size : 10pt; "><b><font face="����">Pick 
        amazoncar! We'll pick you up.</font></b></td>
    </tr>
    
    <tr bgcolor="#999999"> 
      <td colspan=2 align='center' height="1" bgcolor="#333333"></td>
    </tr>
    
    <tr> 
      <td colspan="2" align='center' height="10"> <table width="100%" border="0" cellspacing="1" cellpadding="0">
          <tr bgcolor="#FFFFFF"> 
            <td height="40"> <table width="100%" border="0" cellspacing="0" cellpadding="5">
                <tr> 
                  <td height="20"  style="font-size : 9pt;"><font face="����">07236 ����Ư���� �������� �ǻ���� 8 ������� 802ȣ</font></td>
                </tr>
                <tr>    
                  <td height="20" style="font-size : 9pt;" ><font face="����">Tel:02-392-4243</font>
                 <font face="����">Fax:02-757-0803</font>
                 <font face="����">http://www.amazoncar.co.kr</font></td>
                </tr>
              </table></td>
          </tr>
        </table></td>
    </tr>
    <tr> 
      <td height="120" colspan="2" align='center'></td>
    </tr>
	<tr>
        <td align=center valign=top><SPAN STYLE='font-size:22.0pt;font-family:"����";font-weight:bold;text-decoration: underline;line-height:150%;'>�� �� �� �� ��</SPAN></td>
       
   	</tr>	
   	<tr>
   		<td height=30></td>
   	</tr>			       
    <tr>
	       <td>
	       	<table width="700" border="1" cellspacing="0" cellpadding="0">
	            <TR>
	           		<TD width="100" height="40" rowspan=2  align=center>�� �� <br>�� ��</TD>
					<TD width="140" height="40"  align=center>�� ��</TD>
					<TD width="150"  align=center>&nbsp;&nbsp;<%=coe_bean.getEmp_nm()%></TD>
					<TD width="140"  align=center>�ֹε�Ϲ�ȣ</TD>
					<TD align=center>&nbsp;&nbsp<%= coe_bean.getEmp_ssn1() %> - <%= coe_bean.getEmp_ssn2() %></td>
					</TD>
	            </TR>
				<TR>
					<TD height="40"  align=center>�� ��</TD>				
				    <TD align=left colspan=3>&nbsp;&nbsp;<%= coe_bean.getEmp_addr() %></TD>
			    </TR>
				<TR>
					<TD width="100" height="44" rowspan=3  align=center>�� �� <br>�� ��</TD>
					<TD height="44"  align=center>�� ��</TD>
					<TD >&nbsp;&nbsp;</TD>
					<TD align=center>�� ��</TD>
					<TD >&nbsp;&nbsp;</TD>
			    </TR>
				<TR>
					<TD height="40" align=center>�Ի�����</TD>
				 	<TD width="100" align=center>&nbsp;&nbsp;</TD>
					<TD width="140" align=center>�������</TD>
					<TD align=center>&nbsp;&nbsp;<%=AddUtil.ChangeDate2(st_dt)%></TD>
			    </TR>
			   	<TR>
					<TD height="40" align=center>�� ��</TD>
				 	<TD width="100" align=center>&nbsp;&nbsp;�����</TD>
					<TD width="100" align=center>����ó</TD>
					<TD  align=center>&nbsp;&nbsp;</TD>
			    </TR>
			</table>
		</td>
	</tr> 
 	<tr>
        <td align=center>
        	<table width="700" border="0" cellspacing="0" cellpadding="0" align="center">
            	<TR>
					<TD height="160" align="center" class=style5 colspan="2">��� ������ ��ǰ� �ٸ��� ������ �����մϴ�.</TD>
	    		</TR>
						
				<TR>
					<TD height="22" align=center class=style5 colspan="2"><%=AddUtil.getDate2(1)%> �� &nbsp;&nbsp;<%=AddUtil.getDate2(2)%> �� &nbsp;&nbsp;<%=AddUtil.getDate2(8)%> ��</td>
				</TR>
				<tr>
					<td height="120" colspan="2"></td>
				</tr>
				
				<tr>
					<td height="20"></td>
				</tr>
				<TR>
					<td align=right STYLE="font-size:13.0pt;line-height:160%;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�� &nbsp;ǥ &nbsp;��&nbsp;��</td>
					<TD height="22" STYLE="font-size:13.0pt;line-height:160%;font-weight:bold;"> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�� &nbsp;&nbsp;�� &nbsp;&nbsp;�� &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��&nbsp;��</TD>
				</TR>
			</table>
		</td>
    </tr>
			    <tr>
			        <td height=60></td>
			    </tr>
			</table>
		</td>
	</tr>
</table>
</form>
</body>
</html>