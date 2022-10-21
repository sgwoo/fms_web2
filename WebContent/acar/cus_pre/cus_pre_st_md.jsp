<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.cus_pre.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");	

	float cm_rate = 0.0f;
	float cd_rate = 0.0f;
	float rm_rate = 0.0f;
	float rd_rate = 0.0f;
		
	CusPre_Database cp_db = CusPre_Database.getInstance();
	
	Vector cpams = cp_db.getCusPreAll_md(cmd);

	
	CommonDataBase c_db = CommonDataBase.getInstance();
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" href="/include/table_t.css" type="text/css">
</head>

<body>
<table width="100% border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>거래처방문</span></td>
    </tr>
    <tr> 
        <td width="20">&nbsp;</td>
        <td width="780">
            <table width="780" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td width="15" height="82" valign="top" style="border-top: #000000 0px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 1px solid"><font size="1">100</font></td>
    <%/* for(int i=0; i<mng_ids.size(); i++){
		Hashtable mng_id = (Hashtable)mng_ids.elementAt(i);
		 int vac = AddUtil.parseInt((String)mng_id.get("VAC"));
		 int vec = AddUtil.parseInt((String)mng_id.get("VEC"));
		 int vc = AddUtil.parseInt((String)mng_id.get("VC"));
		 float	vc_rate = 0.0f;
		 if(vac != 0)	vc_rate = vc*100/(float)vac; */
		 for(int i=0; i<cpams.size(); i++){
				Hashtable ht = (Hashtable)cpams.elementAt(i);
				int vac = AddUtil.parseInt((String)ht.get("VAC"));
				int vec = AddUtil.parseInt((String)ht.get("VEC"));
				int vc = AddUtil.parseInt((String)ht.get("VC"));
				
				float v_rate = 0.0f, s_rate = 0.0f, vs_rate = 0.0f;
				if(vec>0) v_rate = (float)vc*100/vec;
				//if(AddUtil.parseInt((String)ht.get("SEC"))>0) s_rate = (float)AddUtil.parseInt((String)ht.get("SC"))*100/(AddUtil.parseInt((String)ht.get("SEC")));
				//vs_rate = (float)(AddUtil.parseInt((String)ht.get("VC"))+AddUtil.parseInt((String)ht.get("SC")))*100/(AddUtil.parseInt((String)ht.get("VAC"))+(AddUtil.parseInt((String)ht.get("SAC"))));
				//vs_rate = (v_rate+s_rate)/2;
				//tot_v_rate += v_rate; tot_s_rate += s_rate; tot_vs_rate += vs_rate;
				//vac += AddUtil.parseInt((String)ht.get("VAC")); vec += AddUtil.parseInt((String)ht.get("VEC")); vc += AddUtil.parseInt((String)ht.get("VC"));
				//sac += AddUtil.parseInt((String)ht.get("SAC")); sec += AddUtil.parseInt((String)ht.get("SEC")); sc += AddUtil.parseInt((String)ht.get("SC"));
				//cs1 += AddUtil.parseInt((String)ht.get("CS1")); cs2 += AddUtil.parseInt((String)ht.get("CS2")); cs3 += AddUtil.parseInt((String)ht.get("CS3"));
				//mac1 += AddUtil.parseInt((String)ht.get("MAC1")); mac2 += AddUtil.parseInt((String)ht.get("MAC2")); irh += AddUtil.parseInt((String)ht.get("IRH")); irc += AddUtil.parseInt((String)ht.get("IRC"));
		 %>
                    <td width="10" rowspan="2">&nbsp;</td>
                    <td width="80" rowspan="2">
                        <table width="70" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                            </tr>
                            <tr> 
                                <td align=right> 
                                    <table width="15" border="0" cellspacing="1" cellpadding="0" height="120">
                                        <tr> 
                                            <td height="20" valign="bottom" align="center"></td>
                                        </tr>
                                        <tr> 
                                            <td valign="bottom" height="100" align="center"><font size="1"><%= vac %></font><br><img src=/images/menu_back2.gif width=15 height=<%= vac %>></td>
                                        </tr>
                                    </table>
                                </td>
                                <td align=middle> 
                                    <table width="15" border="0" cellspacing="1" cellpadding="0" height="120">
                                        <tr> 
                                            <td height="20" valign="bottom" align="center"></td>
                                        </tr>
                                        <tr> 
                                            <td valign="bottom" height="100" align="center"><font size="1"><%= vec %></font><br><img src=/images/menu_back.gif width=15 height=<%= vec %>></td>
                                        </tr>
                                    </table>
                                </td>
                                <td> 
                                    <table width="15" border="0" cellspacing="1" cellpadding="0" height="120">
                                        <tr> 
                                            <td height="20" valign="bottom" align="center"></td>
                                        </tr>
                                        <tr> 
                                            <td height="100" valign="bottom" align="center"><font size="1"><%= vc %></font><br><img src=/images/result1.gif width=15 height=<%= vc %>></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr> 
                                <td colspan="3" align="center"><font color="#999900">실시율<br><%= AddUtil.parseFloatCipher(v_rate,2) %>%</font></td>
                            </tr>
                        </table>
                    </td>
          <% } %>
                </tr>
                <tr> 
                    <td valign="top" style="border-top: #000000 0px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 1px solid"><font size="1">50</font></td>
                </tr>
                <tr> 
                    <td></td>
                <% for(int i=0; i<cpams.size(); i++){
            				Hashtable ht = (Hashtable)cpams.elementAt(i);%>		  
                      <td colspan="2" style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid"><div align="center"></div>
                        <div align="center"><%= c_db.getNameById((String)ht.get("USER_ID"),"USER") %></div></td>
            	<% } %>			
                </tr>
                  
            </table>
        </td>
    </tr>
    <tr>
        <td colspan="2">&nbsp;</td>
    </tr>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>자동차정비</span></td>
    </tr>
    <tr> 
        <td>&nbsp;</td>
        <td>
            <table width="780" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td width="15" height="82" valign="top" style="border-top: #000000 0px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 1px solid"><font size="1">100</font></td>
          <% /*for(int i=0; i<mng_ids.size(); i++){
		Hashtable mng_id = (Hashtable)mng_ids.elementAt(i);
		 int sac = AddUtil.parseInt((String)mng_id.get("SAC"));
		 int sec = AddUtil.parseInt((String)mng_id.get("SEC"));
		 int sc = AddUtil.parseInt((String)mng_id.get("SC"));
		 float	sc_rate = 0.0f;
		 if(sac != 0)	sc_rate = sc*100/(float)sac; */
		 for(int i=0; i<cpams.size(); i++){
				Hashtable ht = (Hashtable)cpams.elementAt(i);
				int sac = AddUtil.parseInt((String)ht.get("SAC"));
				int sec = AddUtil.parseInt((String)ht.get("SEC"));
				int sc = AddUtil.parseInt((String)ht.get("SC"));
				
				float s_rate = 0.0f;
				if(sec>0) s_rate = (float)sc*100/sec;				
		 %>
                    <td width="10" rowspan="2">&nbsp;</td>
                    <td width="80" rowspan="2">
                        <table width="70" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                            </tr>
                            <tr> 
                                <td align=right> 
                                    <table width="10" border="0" cellspacing="1" cellpadding="0" height="120">
                                        <tr> 
                                            <td height="20" valign="bottom" align="center"></td>
                                        </tr>
                                        <tr> 
                                            <td valign="bottom" height="100" align="center"><font size="1"><%= sac %></font><br><img src=/images/menu_back2.gif width=15 height=<%= sac %>></td>
                                        </tr>
                                    </table>
                                </td>
                                <td align=middle> 
                                    <table width="10" border="0" cellspacing="1" cellpadding="0" height="120">
                                        <tr> 
                                          <td height="20" valign="bottom" align="center"></td>
                                        </tr>
                                        <tr> 
                                          <td valign="bottom" height="100" align="center"><font size="1"><%= sec %></font><br><img src=/images/menu_back.gif width=15 height=<%= sec %>></td>
                                        </tr>
                                    </table>
                                </td>
                                <td> 
                                    <table width="10" border="0" cellspacing="1" cellpadding="0" height="120">
                                        <tr> 
                                            <td height="20" valign="bottom" align="center"></td>
                                        </tr>
                                        <tr> 
                                            <td height="100" valign="bottom" align="center"><font size="1"><%= sc %></font><br><img src=/images/result1.gif width=15 height=<%= sc %>></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr> 
                                <td colspan="3" align="center"><font color="#999900">실시율<br>
                              <%= AddUtil.parseFloatCipher(s_rate,2) %>%</font></td>
                            </tr>
                        </table>
                    </td>
          <% } %>
                </tr>
                <tr> 
                    <td valign="top" style="border-top: #000000 0px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 1px solid"><font size="1">50</font></td>
                </tr>
                <tr> 
                    <td><div align="center"></div></td>
    <% for(int i=0; i<cpams.size(); i++){
				Hashtable ht = (Hashtable)cpams.elementAt(i);%>		  
                    <td colspan="2" style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid"><div align="center"></div>
                    <div align="center"><%= c_db.getNameById((String)ht.get("USER_ID"),"USER") %></div></td>
	<% } %>			
                </tr>
            </table>
        </td>
    </tr>
</table>
<br>
</body>
</html>
