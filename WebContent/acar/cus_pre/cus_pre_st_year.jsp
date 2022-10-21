<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.cus_pre.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");

	float cm_rate = 0.0f;
	float cd_rate = 0.0f;
	float rm_rate = 0.0f;
	float rd_rate = 0.0f;
		
	CusPre_Database cp_db = CusPre_Database.getInstance();
	Vector mng_ids = cp_db.getCusPreAll_year();

	/*if(client[0]!=0)	cm_rate = (float)(client[2]*100/client[0]);
	if(client[3]!=0)	cd_rate = client[5]*100/(float)client[3];
	if(car[0]!=0)		rm_rate = car[2]*100/(float)car[0];
	if(car[3]!=0)		rd_rate = car[5]*100/(float)car[3];
*/
	CommonDataBase c_db = CommonDataBase.getInstance();
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" href="/include/table.css" type="text/css">
</head>

<body>
<table width="800" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td colspan="2">&lt; 거래처방문 &gt;</td>
  </tr>
  <tr> 
    <td width="20">&nbsp;</td>
    <td width="780"><table width="780" border="0" cellspacing="1" cellpadding="0">
        <tr> 
          <td width="15" height="82" valign="top" style="border-top: #000000 0px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 1px solid"><font size="1">100</font></td>
    <% for(int i=0; i<mng_ids.size(); i++){
		Hashtable mng_id = (Hashtable)mng_ids.elementAt(i);
		 int vac = AddUtil.parseInt((String)mng_id.get("VAC"));
		 int vec = AddUtil.parseInt((String)mng_id.get("VEC"));
		 int vc = AddUtil.parseInt((String)mng_id.get("VC"));
		 float	vc_rate = 0.0f;
		 if(vec != 0)	vc_rate = vc*100/(float)vec; %>
          <td width="10" rowspan="2">&nbsp;</td>
          <td width="70" rowspan="2" valign="bottom"><table width="60" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
              </tr>
              <tr> 
                <td valign="bottom"> <table width="10" border="0" cellspacing="1" cellpadding="0" height="120">
                    <tr> 
                      <td height="20" valign="bottom" align="center"></td>
                    </tr>
                    <tr> 
                      <td valign="bottom" height="100" align="center"><font size="1"><%= vac %></font><br><img src=/images/menu_back2.gif width=10 height=<%= vac %>></td>
                    </tr>
                  </table></td>
                <td valign="bottom"> <table width="10" border="0" cellspacing="1" cellpadding="0" height="120">
                    <tr> 
                      <td height="20" valign="bottom" align="center"></td>
                    </tr>
                    <tr> 
                      <td valign="bottom" height="100" align="center"><font size="1"><%= vec %></font><br><img src=/images/menu_back.gif width=10 height=<%= vec %>></td>
                    </tr>
                  </table></td>
                <td valign="bottom"> <table width="10" border="0" cellspacing="1" cellpadding="0" height="120">
                    <tr> 
                      <td height="20" valign="bottom" align="center"></td>
                    </tr>
                    <tr> 
                      <td height="100" valign="bottom" align="center"><font size="1"><%= vc %></font><br><img src=/images/result1.gif width=10 height=<%= vc %>></td>
                    </tr>
                  </table></td>
              </tr>
              <tr> 
                <td colspan="3" align="center"><font color="#999900">실시율<br><%= AddUtil.parseFloatCipher(vc_rate,2) %>%</font></td>
              </tr>
            </table></td>
          <% } %>
        </tr>
        <tr> 
          <td valign="top" style="border-top: #000000 0px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 1px solid"><font size="1">50</font></td>
        </tr>
        <tr> 
          <td></td>
    <% for(int i=0; i<mng_ids.size(); i++){
		Hashtable mng_id = (Hashtable)mng_ids.elementAt(i);%>		  
          <td colspan="2" style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid"><div align="center"></div>
            <div align="center"><%= c_db.getNameById((String)mng_id.get("CHECKER"),"USER") %></div></td>
	<% } %>			
        </tr>
      </table></td>
  </tr>
  <tr>
    <td colspan="2">&nbsp;</td>
  </tr>
  <tr> 
    <td colspan="2">&lt; 자동차정비 &gt;</td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
    <td><table width="780" border="0" cellspacing="1" cellpadding="0">
        <tr> 
          <td width="15" height="82" valign="top" style="border-top: #000000 0px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 1px solid"><font size="1">100</font></td>
          <% for(int i=0; i<mng_ids.size(); i++){
		Hashtable mng_id = (Hashtable)mng_ids.elementAt(i);
		 int sac = AddUtil.parseInt((String)mng_id.get("SAC"));
		 int sec = AddUtil.parseInt((String)mng_id.get("SEC"));
		 int sc = AddUtil.parseInt((String)mng_id.get("SC"));
		 float	sc_rate = 0.0f;
		 if(sec != 0)	sc_rate = sc*100/(float)sec; %>
          <td width="10" rowspan="2">&nbsp;</td>
          <td width="70" rowspan="2" valign="bottom"><table width="60" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
              </tr>
              <tr> 
                <td valign="bottom"> <table width="10" border="0" cellspacing="1" cellpadding="0" height="120">
                    <tr> 
                      <td height="20" valign="bottom" align="center"></td>
                    </tr>
                    <tr> 
                      <td valign="bottom" height="100" align="center"><font size="1"><%= sac %></font><br><img src=/images/menu_back2.gif width=10 height=<%= sac %>></td>
                    </tr>
                  </table></td>
                <td valign="bottom"> <table width="10" border="0" cellspacing="1" cellpadding="0" height="120">
                    <tr> 
                      <td height="20" valign="bottom" align="center"></td>
                    </tr>
                    <tr> 
                      <td valign="bottom" height="100" align="center"><font size="1"><%= sec %></font><br><img src=/images/menu_back.gif width=10 height=<%= sec %>></td>
                    </tr>
                  </table></td>
                <td valign="bottom"> <table width="10" border="0" cellspacing="1" cellpadding="0" height="120">
                    <tr> 
                      <td height="20" valign="bottom" align="center"></td>
                    </tr>
                    <tr> 
                      <td height="100" valign="bottom" align="center"><font size="1"><%= sc %></font><br><img src=/images/result1.gif width=10 height=<%= sc %>></td>
                    </tr>
                  </table></td>
              </tr>
              <tr> 
                <td colspan="3" align="center"><font color="#999900">실시율<br>
                  <%= AddUtil.parseFloatCipher(sc_rate,2) %>%</font></td>
              </tr>
            </table></td>
          <% } %>
        </tr>
        <tr> 
          <td valign="top" style="border-top: #000000 0px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 1px solid"><font size="1">50</font></td>
        </tr>
        <tr> 
          <td><div align="center"></div></td>
    <% for(int i=0; i<mng_ids.size(); i++){
		Hashtable mng_id = (Hashtable)mng_ids.elementAt(i);%>		  
          <td colspan="2" style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid"><div align="center"></div>
            <div align="center"><%= c_db.getNameById((String)mng_id.get("CHECKER"),"USER") %></div></td>
	<% } %>			
        </tr>
      </table></td>
  </tr>
</table>
<br>
</body>
</html>
