<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>  

<%@ page import="java.util.*, acar.util.*, acar.car_service.*, acar.common.*" %>
<jsp:useBean id="sb_bean" class="acar.car_service.ServiceBean" scope="page"/>
<jsp:useBean id="si_bean" class="acar.car_service.ServItem2Bean" scope="page"/>

<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename="+AddUtil.getDate(4)+"_car_service_popup_excel.xls");
%>

<%
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");

	CarServDatabase csd = CarServDatabase.getInstance();	
	ServiceBean sb_r [] = csd.getServiceAll(car_mng_id, "asc");
	
	LoginBean login = LoginBean.getInstance();
	
	CommonDataBase c_db = CommonDataBase.getInstance();	
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
</head>
<body>
<table border="0" cellspacing="1" cellpadding="1" width=953>
  <tr> 
    <td rowspan="2" colspan="3"><img src="http://fms1.amazoncar.co.kr/acar/images/logo.gif" width="160" height="38"></td>
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
    <td colspan="5"><div align="right"><b><font size="3">������ȣ:<%= c_db.getNameById(car_mng_id, "CAR_NO") %>, 
        &nbsp;����:<%= c_db.getNameById(car_mng_id, "CAR_NM2") %></font></b></div></td>
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
  <% for(int i=0; i<sb_r.length; i++){
		sb_bean = sb_r[i];%>
  <tr valign="middle"> 
    <td width=29 align=center bgcolor="#00FFFF" height="20"><b><font face="����" size="2"><%=i+1%></font></b></td>
    <td width=91 align=center height="20"><font face="����" size="2"><%if(!sb_bean.getServ_dt().equals("")){%>
		  								<%= AddUtil.ChangeDate2(sb_bean.getServ_dt()) %>
										<%}%></font></td>
    <td width=87 align=right height="20"><font face="����" size="2"><%=Util.parseDecimal(sb_bean.getTot_dist())%>&nbsp;km</font></td>
    <td width=74 align=center height="20"><font face="����" size="2"><%=sb_bean.getServ_st_nm()%></font></td>
    <td width=56 align=center height="20"><font face="����" size="2">
	<%if(!sb_bean.getChecker().equals("")){
		  								if(sb_bean.getChecker().substring(0,2).equals("00")){%>
										<%= login.getAcarName(sb_bean.getChecker()) %>
									<%}else{%>
										<%= sb_bean.getChecker() %>
									<% }
									} %></font></td>
    <td width=486 height="20"><font size="2" face="����">&nbsp;
	<%if((sb_bean.getServ_st().equals("2")||sb_bean.getServ_st().equals("3")||sb_bean.getServ_st().equals("4"))&&(AddUtil.parseInt(sb_bean.getServ_dt())>20031231)){
					ServItem2Bean si_r [] = csd.getServItem2All(sb_bean.getCar_mng_id(), sb_bean.getServ_id());
					for(int j=0; j<si_r.length; j++){
						si_bean = si_r[j];
						if(j==si_r.length-1){
							out.print(si_bean.getItem());
						}else{
							out.print(si_bean.getItem()+",");
						}            	
					}										
				}else{%>
					<%=sb_bean.getRep_cont()%>		
			<%  } %></font></td>
    <td width=130 align=left height="20"><font face="����" size="2"><%=sb_bean.getOff_nm()%></font></td>
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
      ���ǵ��� 17-3 ��ȯ��º��� 6��</font></td>
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