<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.cus_pre.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	//String year = request.getParameter("year")==null?"":request.getParameter("year");

	CommonDataBase c_db = CommonDataBase.getInstance();
	
	CusPre_Database cp_db = CusPre_Database.getInstance();
	int[] mng = cp_db.getTg_month();
	int[] pre = cp_db.getTg_month_pre();
	
	float cm_rate = 0.0f;
	float rm_rate = 0.0f;
	if(pre[0]!=0)	cm_rate = pre[2]*100/(float)pre[0];
	if(pre[3]!=0)	rm_rate = pre[5]*100/(float)pre[3];
	
	Vector cpams = cp_db.getCusPreAll_month();
	Vector rs = cp_db.getTg_month_rs();			//����,������Ȳ

%>
<html>
<head>
<title>:: ��������������Ȳ ::</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<link rel=stylesheet type="text/css" href="/include/table.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
-->
</script>
</head>

<body>
<form name='form1' method='post' action=''>
  <table width="800" border="0" cellspacing="0" cellpadding="0">
    <tr> 
      <td width="800" height="20" colspan="2" class=line> <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td width="330">&lt; ������Ȳ &gt;</td>
            <td width="10" rowspan="5">&nbsp;</td>
            <td width="460">&lt; ��� ����������Ȳ &gt;</td>
          </tr>
          <tr> 
            <td class=line width="330"> <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                  <td width="90" class='title' align="center">����</td>
                  <td width="120" class='title' align="center">�ŷ�ó</td>
                  <td width="120" class='title' align="center">�ڵ���</td>
                </tr>
                <tr> 
                  <td class='title' align="center">�ܵ�����</td>
                  <td align="center"> <a href="#"><%= mng[0] %>��</a></td>
                  <td align="center"> <a href="#"><%= mng[2] %>��</a></td>
                </tr>
                <tr> 
                  <td class='title' align="center">��������</td>
                  <td align="center"><a href="#"><%= mng[1] %>��</a></td>
                  <td align="center"><a href="#"><%= mng[3] %>��</a></td>
                </tr>
                <tr> 
                  <td class='title' align="center">�հ�</td>
                  <td align="center"><a href="#"><%= mng[0]+mng[1] %>��</a></td>
                  <td align="center"><a href="#"><%= mng[2]+mng[3] %>��</a></td>
                </tr>
              </table></td>
            <td class=line rowspan="4"> <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr align="center"> 
                  <td class=title>�ŷ�ó�湮</td>
                  <td class=title>�ڵ�������</td>
                </tr>
                <tr> 
                  <td> <table width="180" border="0" cellspacing="0" cellpadding="0" align="center">
                      <tr> 
                        <td style="border-top: #000000 0px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 1px solid" height="120" valign="top"> 
                          <br> <font size="1">100</font> </td>
                        <td>&nbsp;</td>
                        <td> <table width="30" border="0" cellspacing="0" cellpadding="0" height="120">
                            <tr> 
                              <td height="20" valign="bottom" align="center"><a href="#"><%= pre[0] %>��</a></td>
                            </tr>
                            <tr> 
                              <td valign="bottom" height="100"><img src=../../images/menu_back2.gif width=30 height=<%= 100-(100-pre[0])%>></td>
                            </tr>
                          </table></td>
                        <td>&nbsp;</td>
                        <td> <table width="30" border="0" cellspacing="0" cellpadding="0" height="120">
                            <tr> 
                              <td height="19" valign="bottom" align="center"><a href="#"><%= pre[1] %>��</a></td>
                            </tr>
                            <tr> 
                              <td valign="bottom" height="81"><img src=../../images/menu_back.gif width=30 height=<%= 100-(100-pre[1])%>></td>
                            </tr>
                          </table></td>
                        <td>&nbsp;</td>
                        <td> <table width="30" border="0" cellspacing="0" cellpadding="0" height="120">
                            <tr> 
                              <td height="68" valign="bottom" align="center"><a href="#"><%= pre[2] %>��</a></td>
                            </tr>
                            <tr> 
                              <td height="32" valign="bottom"><img src=../../images/result1.gif width=30 height=<%= 100-(100-pre[2])%>></td>
                            </tr>
                          </table></td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td>&nbsp;</td>
                        <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid">&nbsp;</td>
                        <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid" align="center">��ü</td>
                        <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid" align="center">&nbsp;</td>
                        <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid" align="center">����</td>
                        <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid" align="center">&nbsp;</td>
                        <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid" align="center">�ǽ�</td>
                        <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid">&nbsp;</td>
                      </tr>
                      <tr> 
                        <td align="center">&nbsp;</td>
                        <td colspan="7" align="center"><font color="#999900">�ǽ��� <%= AddUtil.parseFloatCipher(cm_rate,2) %>%</font><br> <br></td>
                      </tr>
                    </table></td>
                  <td> <table width="180" border="0" cellspacing="0" cellpadding="0" align="center">
                      <tr> 
                        <td style="border-top: #000000 0px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 1px solid" height="120" valign="top"> 
                          <br> <font size="1">100</font> </td>
                        <td>&nbsp;</td>
                        <td> <table width="30" border="0" cellspacing="0" cellpadding="0" height="120">
                            <tr> 
                              <td height="20" valign="bottom" align="center"><a href="#"><%= pre[3] %>��</a></td>
                            </tr>
                            <tr> 
                              <td valign="bottom" height="100"><img src=../../images/menu_back2.gif width=30 height=<%= 100-(100-pre[3])%>></td>
                            </tr>
                          </table></td>
                        <td>&nbsp;</td>
                        <td> <table width="30" border="0" cellspacing="0" cellpadding="0" height="120">
                            <tr> 
                              <td height="19" valign="bottom" align="center"><a href="#"><%= pre[4] %>��</a></td>
                            </tr>
                            <tr> 
                              <td valign="bottom" height="81"><img src=../../images/menu_back.gif width=30 height=<%= 100-(100-pre[4])%>></td>
                            </tr>
                          </table></td>
                        <td>&nbsp;</td>
                        <td> <table width="30" border="0" cellspacing="0" cellpadding="0" height="120">
                            <tr> 
                              <td height="68" valign="bottom" align="center"><a href="#"><%= pre[5] %>��</a></td>
                            </tr>
                            <tr> 
                              <td height="32" valign="bottom"><img src=../../images/result1.gif width=30 height=<%= 100-(100-pre[5])%>></td>
                            </tr>
                          </table></td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td>&nbsp;</td>
                        <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid">&nbsp;</td>
                        <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid" align="center">��ü</td>
                        <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid" align="center">&nbsp;</td>
                        <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid" align="center">����</td>
                        <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid" align="center">&nbsp;</td>
                        <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid" align="center">�ǽ�</td>
                        <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid">&nbsp;</td>
                      </tr>
                      <tr> 
                        <td align="center">&nbsp;</td>
                        <td colspan="7" align="center"><font color="#999900">�ǽ��� <%= AddUtil.parseFloatCipher(rm_rate,2) %>%</font><br> <br></td>
                      </tr>
                    </table></td>
                </tr>
              </table></td>
          </tr>
          <tr> 
            <td width="330">&nbsp;</td>
          </tr>
          <tr> 
            <td class=line width="330"> <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                  <td width="90" class=title>����</td>
                  <td width="80" class=title>�Ϲݽ�</td>
                  <td width="80" class=title>�⺻��/�����</td>
                  <td class=title width="80">�հ�</td>
                </tr>
                <tr> 
                  <td class=title>��Ʈ</td>
                  <td align="center"><a href="#"><%= mng[4] %>��</a></td>
                  <td align="center"><a href="#"><%= mng[5] %>��</a></td>
                  <td align="center"><a href="#"><%= mng[4]+ mng[5] %>��</a></td>
                </tr>
                <tr> 
                  <td class=title>����</td>
                  <td align="center"><a href="#"><%= mng[6] %>��</a></td>
                  <td align="center"><a href="#"><%= mng[7] %>��</a></td>
                  <td align="center"><a href="#"><%= mng[6]+ mng[7] %>��</a></td>
                </tr>
                <tr> 
                  <td class=title>�հ�</td>
                  <td align="center"><a href="#"><%= mng[4]+ mng[6] %>��</a></td>
                  <td align="center"><a href="#"><%= mng[5]+ mng[7] %>��</a></td>
                  <td align="center"><a href="#"><%= mng[4]+ mng[5]+mng[6]+mng[7] %>��</a></td>
                </tr>
              </table></td>
          </tr>
        </table></td>
    </tr>
    <tr> 
      <td colspan="2">&lt; ��� ������Ȳ &gt;</td>
    </tr>
    <tr> 
      <td class=line colspan="2" height="20"> <table width="100%" border="0" cellspacing="1" cellpadding="0">
          <tr> 
            <td class='title' align="center" width="30" rowspan="3">����</td>
            <td class='title' align="center" width="80" rowspan="3">����</td>
            <td rowspan="3" class='title' align="center" width="95">�ѽǽ���</td>
            <td class='title' align="center" colspan="4">�ŷ�ó�湮</td>
            <td class='title' align="center" colspan="7">�ڵ�������</td>
            <td class='title' align="center" colspan="4">����/���а˻�</td>
            <td class='title' align="center" colspan="4">�������û</td>
          </tr>
          <tr> 
            <td width="40" class='title' align="center" rowspan="2">��ü</td>
            <td width="40" class='title' align="center" rowspan="2">����</td>
            <td width="40" class='title' align="center" rowspan="2">�ǽ�</td>
            <td width="50" class='title' align="center" rowspan="2">�ǽ���</td>
            <td width="40" class='title' align="center" rowspan="2">��ü</td>
            <td width="40" class='title' align="center" rowspan="2">����</td>
            <td class='title' align="center" colspan="4">�ǽ�(�ǽ���)</td>
            <td width="50" class='title' align="center" rowspan="2">�ǽ���</td>
            <td width="40" class='title' align="center" rowspan="2">��ü</td>
            <td width="40" class='title' align="center" rowspan="2">����</td>
            <td width="40" class='title' align="center" rowspan="2">�ǽ�</td>
            <td width="45" class='title' align="center" rowspan="2">�ǽ���</td>
            <td width="40" class='title' align="center" rowspan="2">��ü</td>
            <td width="40" class='title' align="center" rowspan="2">����</td>
            <td width="40" class='title' align="center" rowspan="2">�ǽ�</td>
            <td width="50" class='title' align="center" rowspan="2">�ǽ���</td>
          </tr>
          <tr> 
            <td width="40" class='title' align="center">����</td>
            <td width="40" class='title' align="center">����</td>
            <td width="40" class='title' align="center">��</td>
            <td width="40" class='title' align="center">��</td>
          </tr>
          <%for(int i=0; i<cpams.size(); i++){
				Hashtable ht = (Hashtable)cpams.elementAt(i);
				float v_rate = 0.0f;
				float s_rate = 0.0f;
				v_rate = (float)AddUtil.parseInt((String)ht.get("VC"))*100/(AddUtil.parseInt((String)ht.get("VAC")));
				s_rate = (float)AddUtil.parseInt((String)ht.get("SC"))*100/(AddUtil.parseInt((String)ht.get("SAC")));
//System.out.println("v_rate="+v_rate);
//System.out.println("s_rate="+s_rate);				 %>
          <tr> 
            <td align="center"><%= i+1 %></td>
            <td align="center"><a href="cus_pre_frame.jsp?auth_rw=<%= auth_rw %>&br_id=<%= br_id %>&user_id=<%= ht.get("CHECKER") %>&cmd=pre" target="d_content"><%= c_db.getNameById((String)ht.get("CHECKER"),"USER") %></a></td>
            <td align="right">&nbsp;</td>
            <td align="right"><%= ht.get("VAC") %>&nbsp;</td>
            <td align="right"><%= ht.get("VEC") %>&nbsp;</td>
            <td align="right"><%= ht.get("VC") %>&nbsp;</td>
            <td align="right"><%=AddUtil.parseFloatCipher(v_rate,2) %>&nbsp;</td>
            <td align="right"><%= ht.get("SAC") %>&nbsp;</td>
            <td align="right"><%= ht.get("SEC") %>&nbsp;</td>
            <td align="right"><%= ht.get("CS1") %>&nbsp;</td>
            <td align="right"><%= ht.get("CS2") %>&nbsp;</td>
            <td align="right"><%= ht.get("CS3") %>&nbsp;</td>
            <td align="right"><%= ht.get("SC") %>&nbsp;</td>
            <td align="right"><%= AddUtil.parseFloatCipher(s_rate,2) %>&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
          </tr>
		  <% } %>
          <tr> 
            <td class='title' align="center">&nbsp;</td>
            <td class='title' align="center">�հ�</td>
            <td class='title' align="right">&nbsp;</td>
            <td class='title' align="right">&nbsp;</td>
            <td class='title' align="right">&nbsp;</td>
            <td class='title' align="right">&nbsp;</td>
            <td class='title' align="right">&nbsp;</td>
            <td class='title' align="right">&nbsp;</td>
            <td class='title' align="right">&nbsp;</td>
            <td class='title' align="right">&nbsp;</td>
            <td class='title' align="right">&nbsp;</td>
            <td class='title' align="right">&nbsp;</td>
            <td class='title' align="right">&nbsp;</td>
            <td class='title' align="right">&nbsp;</td>
            <td class='title' align="right">&nbsp;</td>
            <td class='title' align="right">&nbsp;</td>
            <td class='title' align="right">&nbsp;</td>
            <td class='title' align="right">&nbsp;</td>
            <td class='title' align="right">&nbsp;</td>
            <td class='title' align="right">&nbsp;</td>
            <td class='title' align="right">&nbsp;</td>
            <td class='title' align="right">&nbsp;</td>
          </tr>
        </table></td>
    </tr>
    <tr> 
      <td colspan="2">&lt; ��� ��ຯ����Ȳ &gt;</td>
    </tr>
    <tr> 
      <td class=line colspan="2" height="20"> <table width="100%" border="0" cellspacing="1" cellpadding="0">
          <tr> 
            <td class='title' align="center" width="100">�ű԰�ళ��</td>
            <td align="center" width="300">35��</td>
            <td class='title' align="center" width="100">��ุ�ᵵ��</td>
            <td width="300" align="center">10��</td>
          </tr>
        </table></td>
    </tr>
    <tr> 
      <td colspan="2">&lt; ��� ����/����������Ȳ &gt;</td>
    </tr>
    <tr> 
      <td class=line colspan="2" height="20"> <table width="100%" border="0" cellspacing="1" cellpadding="0">
          <tr> 
            <td class='title' align="center" width="30" rowspan="2">����</td>
            <td class='title' align="center" width="80" rowspan="2">����</td>
            <td class='title' align="center" width="90" rowspan="2">�հ�</td>
            <td class='title' align="center" colspan="2">�ܱ�뿩</td>
            <td class='title' align="center" colspan="2">�������</td>
            <td class='title' align="center" colspan="2">��������</td>
            <td class='title' align="center" colspan="2">�������</td>
            <td class='title' align="center" colspan="2">������</td>
            <td class='title' align="center" colspan="2">��������</td>
          </tr>
          <tr> 
            <td width="50" class='title' align="center">����</td>
            <td width="50" class='title' align="center">����</td>
            <td width="50" class='title' align="center">����</td>
            <td width="50" class='title' align="center">����</td>
            <td width="50" class='title' align="center">����</td>
            <td width="50" class='title' align="center">����</td>
            <td width="50" class='title' align="center">����</td>
            <td width="50" class='title' align="center">����</td>
            <td width="50" class='title' align="center">����</td>
            <td width="50" class='title' align="center">����</td>
            <td width="50" class='title' align="center">����</td>
            <td width="50" class='title' align="center">����</td>
          </tr>
          <%for(int i=0; i<rs.size(); i++){
				Hashtable ht = (Hashtable)rs.elementAt(i);
				String id = (String)ht.get("ID");
				if(id.equals("")) continue;
				 %>
          <tr> 
            <td align="center"><%= i+1 %></td>
            <td align="center"><%= c_db.getNameById((String)ht.get("ID"),"USER") %></td>
            <td align="right"><%= AddUtil.parseInt((String)ht.get("RSR1"))+AddUtil.parseInt((String)ht.get("RSR9"))+AddUtil.parseInt((String)ht.get("RSR10"))+AddUtil.parseInt((String)ht.get("RSR2"))+AddUtil.parseInt((String)ht.get("RSR3"))+AddUtil.parseInt((String)ht.get("RSR6"))+AddUtil.parseInt((String)ht.get("RSR7"))+AddUtil.parseInt((String)ht.get("RSD1"))+AddUtil.parseInt((String)ht.get("RSD9"))+AddUtil.parseInt((String)ht.get("RSD10"))+AddUtil.parseInt((String)ht.get("RSD2"))+AddUtil.parseInt((String)ht.get("RSD3"))+AddUtil.parseInt((String)ht.get("RSD6"))+AddUtil.parseInt((String)ht.get("RSD7")) %>&nbsp;</td>
            <td align="right"><%= ht.get("RSD1") %>&nbsp;</td>
            <td align="right"><%= ht.get("RSR1") %>&nbsp;</td>
            <td align="right"><%= ht.get("RSD9") %>&nbsp;</td>
            <td align="right"><%= ht.get("RSR9") %>&nbsp;</td>
            <td align="right"><%= ht.get("RSD10") %>&nbsp;</td>
            <td align="right"><%= ht.get("RSR10") %>&nbsp;</td>
            <td align="right"><%= ht.get("RSD2") %>&nbsp;</td>
            <td align="right"><%= ht.get("RSR2") %>&nbsp;</td>
            <td align="right"><%= ht.get("RSD3") %>&nbsp;</td>
            <td align="right"><%= ht.get("RSR3") %>&nbsp;</td>
            <td align="right"><%= AddUtil.parseInt((String)ht.get("RSD6"))+AddUtil.parseInt((String)ht.get("RSD7")) %>&nbsp;</td>
            <td align="right"><%= AddUtil.parseInt((String)ht.get("RSR6"))+AddUtil.parseInt((String)ht.get("RSR7")) %>&nbsp;</td>
          </tr>
		  <% } %>		  
          <tr> 
            <td class='title' align="center">&nbsp;</td>
            <td class='title' align="center">�հ�</td>
            <td class='title' align="right">&nbsp;</td>
            <td class='title' align="right">&nbsp;</td>
            <td class='title' align="right">&nbsp;</td>
            <td class='title' align="right">&nbsp;</td>
            <td class='title' align="right">&nbsp;</td>
            <td class='title' align="right">&nbsp;</td>
            <td class='title' align="right">&nbsp;</td>
            <td class='title' align="right">&nbsp;</td>
            <td class='title' align="right">&nbsp;</td>
            <td class='title' align="right">&nbsp;</td>
            <td class='title' align="right">&nbsp;</td>
            <td class='title' align="right">&nbsp;</td>
            <td class='title' align="right">&nbsp;</td>
          </tr>
        </table></td>
    </tr>
  </table>
</form>
</body>
</html>
<script language="JavaScript">
	//cng_input()
</script>
