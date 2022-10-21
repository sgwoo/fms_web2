<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%@ page import="java.util.*, acar.util.*, acar.car_service.*, acar.common.*, acar.cus_reg.*" %>
<jsp:useBean id="si_bean" class="acar.car_service.ServItem2Bean" scope="page"/>

<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename="+AddUtil.getDate(4)+"_cus0401_popup_excel.xls");
%>

<%
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	
	CusReg_Database cr_db = CusReg_Database.getInstance();
	ServInfoBean[] siBns = cr_db.getServiceAll(car_mng_id);
	ServInfoBean siBn = new ServInfoBean();
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	LoginBean login = LoginBean.getInstance();
	
	CarServDatabase csd = CarServDatabase.getInstance();
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
</head>
<body>
<table border="0" cellspacing="1" cellpadding="1" width=953>
  <tr> 
    <td rowspan="2" colspan="3"><img src="../../images/logo.gif" width="160" height="38"></td>
    <td rowspan="2" width="74">&nbsp;</td>
    <td rowspan="2" width="56">&nbsp;</td>
    <td colspan="2" align="right"><font size="2" face="����">�����̷�Ȯ�μ���ȣ : <%=AddUtil.getDate(1)+AddUtil.getDate(2)%>-000</font></td>
  </tr>
  <tr> 
    <td width="486">&nbsp;</td>
    <td align="right" width="130">&nbsp;</td>
  </tr>
  <tr align="center"> 
    <td height="2" width="29">&nbsp;</td>
    <td height="2" width="91">&nbsp;</td>
    <td height="2" width="87">&nbsp;</td>
    <td height="2" width="74">&nbsp;</td>
    <td height="2" width="56">&nbsp;</td>
    <td height="2" width="486">&nbsp;</td>
    <td height="2" width="130">&nbsp;</td>
  </tr>
  <tr align="center"> 
    <td colspan="7"><font size="6" face="����"><b><font size="5">�� �� �� �� �� �� Ȯ �� 
      ��</font></b></font></td>
  </tr>
  <tr> 
    <td colspan="2"><font size="4" face="����"><b><font size="3">[�����̷�]</font></b></font></td>
    <td colspan="2">������ȣ:<%= c_db.getNameById(car_mng_id, "CAR_NO") %></td>
    <td width="56">&nbsp;</td>
    <td width="486">&nbsp;</td>
    <td width="130">&nbsp;</td>
  </tr>
</table>  	
<table border="1" cellspacing="0" cellpadding="0" width=953 bordercolor="#000000">
  <tr bgcolor="#00FFFF" valign="middle"> 
    <td width=29 align=center height="20"><font size="2" face="����">&nbsp;</font></td>
    <td width=91 align=center height="20">&nbsp;&nbsp;<b><font face="����" size="2">��������</font></b>&nbsp;&nbsp;</td>
    <td width=87 align=center height="20">&nbsp;&nbsp;<b><font face="����" size="2">����Ÿ�</font></b>&nbsp;&nbsp;</td>
    <td width=74 align=center height="20">&nbsp;<b><font face="����" size="2">���񱸺�</font></b>&nbsp;</td>
    <td width=56 align=center height="20">&nbsp;<b><font face="����" size="2">�����</font></b>&nbsp;</td>
    <td width=486 align=center height="20"><b><font face="����" size="2">���񳻿�</font></b></td>
    <td width=130 align=center height="20"><b><font face="����" size="2">�����ü</font></b></td>
  </tr>
<%	for(int i=0; i<siBns.length; i++){
		siBn = siBns[i];
		
		ServItem2Bean si_r [] = csd.getServItem2All(siBn.getCar_mng_id(), siBn.getServ_id());
		String f_item = "";
		String a_item = "";
		for(int j=0; j<si_r.length; j++){
 			si_bean = si_r[j];
			if(j==0) f_item = si_bean.getItem();
			if(j==si_r.length-1){
            	a_item += si_bean.getItem();
            }else{
            	a_item += si_bean.getItem()+",";
            }
        }
		%>
  <tr valign="middle"> 
    <td align=center bgcolor="#00FFFF" height="20"><b><font face="����" size="2"><%=i+1%></font></b></td>
    <td align=center height="20"><font face="����" size="2">
			<%	if(siBn.getServ_dt().equals("")){%>
			  	<%= AddUtil.ChangeDate2(siBn.getSpdchk_dt()) %>
			<% 	}else{ %>
				<%= AddUtil.ChangeDate2(siBn.getServ_dt()) %>
			<% 	} %></font></td>
    <td align=right height="20"><font face="����" size="2">&nbsp;<%=Util.parseDecimal(siBn.getTot_dist())%>km</font></td>
    <td align=center height="20"><font face="����" size="2">
			<% 	if(siBn.getServ_st().equals("8")||siBn.getServ_st().equals("9")||siBn.getServ_st().equals("10")){ %>
				<%=siBn.getServ_st_nm()%>
			<% 	}else{ %>			
				<%=siBn.getServ_st_nm()%><%if(siBn.getServ_st().equals("")){%>��ȸ����<%}%>
			<% 	} %></font></td>
    <td align=center height="20"><font face="����" size="2">
			<%	if(!siBn.getChecker().equals("")){
					if(siBn.getChecker().substring(0,2).equals("00")){%>
					<%= login.getAcarName(siBn.getChecker()) %>
			<%		}else{%>
					<%= siBn.getChecker() %>
			<%		}
			  	}%></font></td>
    <td height="20"><font size="2" face="����">
			<% 	if(!siBn.getServ_dt().equals("")){ 
			  		if((siBn.getServ_st().equals("2")||siBn.getServ_st().equals("3"))&&(AddUtil.parseInt(siBn.getServ_dt())>20031231)&&!siBn.getSpd_chk().equals("")){ %>
			  	[��ȸ]
            <%		}
			  	} %>
				<%	if(!a_item.equals("")){%>
				<%=a_item%>
			<%	}else{%>
				<%=siBn.getRep_cont()%>
			<%	}%> 
			</font></td>
    <td align=center height="20"><font face="����" size="2"><%=siBn.getOff_nm()%></font></td>
  </tr>
  <% }	%>
</table>
<table border="0" cellspacing="1" cellpadding="1" width=953>
  <tr> 
    <td width="29">&nbsp;</td>
    <td width="91">&nbsp;</td>
    <td width="87">&nbsp;</td>
    <td width="74">&nbsp;</td>
    <td width="56">&nbsp;</td>
    <td width="486">&nbsp;</td>
    <td width="130">&nbsp;</td>
  </tr>
  <tr> 
    <td colspan="5"><font face="����" size="2">���� ����� �����̷��� ������� Ȯ���մϴ�.</font></td>
    <td width="486">&nbsp;</td>
    <td width="130">&nbsp;</td>
  </tr>
  <tr> 
    <td align="center" width="29"></td>
    <td align="center" width="91"></td>
    <td align="center" width="87"></td>
    <td align="center" width="74"></td>
    <td align="left" colspan="2"><font face="����" size="2"><%=AddUtil.getDate3()%></font></td>
    <td align="center" width="130">&nbsp;</td>
  </tr>
  <tr> 
    <td align="center" width="29"></td>
    <td align="center" width="91"></td>
    <td align="center" width="87"></td>
    <td align="center" width="74"></td>
    <td align="left" width="56"></td>
    <td align="left" width="486">&nbsp;</td>
    <td align="center" width="130">&nbsp;</td>
  </tr>
  <tr> 
    <td align="center" width="29" height="20"></td>
    <td align="center" width="91" height="20"></td>
    <td align="center" width="87" height="20"></td>
    <td align="center" width="74" height="20"></td>
    <td align="left" colspan="3" height="20"><font face="����" size="2">����� �������� 
      ���ǵ��� 17-3 ����̾ؾ����� 8��</font></td>
  </tr>
  <tr> 
    <td align="center" width="29" height="20"></td>
    <td align="center" width="91" height="20"></td>
    <td align="center" width="87" height="20"></td>
    <td align="center" width="74" height="20"></td>
    <td align="left" colspan="2" height="20"><font face="����" size="2">�� �� ȸ �� 
      &nbsp;&nbsp;&nbsp;&nbsp;�� �� �� ī</font></td>
    <td align="center" width="130" height="20">&nbsp;</td>
  </tr>
  <tr> 
    <td width="29" height="20"><font size="4" face="����"><b></b></font></td>
    <td width="91" height="20">&nbsp;</td>
    <td width="87" height="20">&nbsp;</td>
    <td width="74" height="20">&nbsp;</td>
    <td colspan="2" align="left" height="20"><font face="����" size="2">�� ǥ �� �� 
      &nbsp;&nbsp;&nbsp;&nbsp;�� �� �� &nbsp;&nbsp;(��)</font></td>
    <td width="130" height="20">&nbsp;</td>
  </tr>
</table>
</body>
</html>