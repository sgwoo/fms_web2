<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.user_mng.*" %>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	AddUserMngDatabase umd = AddUserMngDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();

	String dept_id[] = new String[17];
	
	dept_id[0] = "0004";	//�ӿ�
	dept_id[1] = "0020";	//������ȹ��
	dept_id[2] = "0001";	//������
	dept_id[3] = "0002";	//��������
	dept_id[4] = "0003";	//�ѹ���
	dept_id[5] = "0005";	//IT��
	dept_id[6] = "0009";	//��������	
	dept_id[7] = "0012";	//��õ����
	dept_id[8] = "0013";	//��������
	dept_id[9] = "0007";	//�λ�����
	dept_id[10] = "0008";	//��������	
	dept_id[11] = "0010";	//��������
	dept_id[12] = "0011";	//�뱸����
	dept_id[13] = "0014";	//��������
	dept_id[14] = "0015";	//��������
	//dept_id[14] = "0016";	//�������
	dept_id[15] = "0017";	//��ȭ������
	dept_id[16] = "0018";	//��������
	
%>

<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<title>���� ����</title>
<%@ include file="/acar/getNaviCookies.jsp" %>
<style type=text/css>
<!--
.style1 {color: #848484}
.style2 {color: #424242}
.style3 {
	color: #0a3489;
	font-weight: bold;
}
-->
</style>
<script language="JavaScript">
<!--
function UserUpdate(user_id,auth_rw)
{
	
	var SUBWIN="../menu/info_u.jsp?auth_rw="+auth_rw+"&user_id="+user_id;	
	window.open(SUBWIN, "UserDisp", "left=100, top=10, width=580, height=700, scrollbars=yes");
}
//-->
</script>
<script language='JavaScript' src='/include/common.js'></script>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
</head>
<body>
<table width=100% border=0 cellspacing=0 cellpadding=0>
    <tr>
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�λ���� > �������� > <span class=style5>������(������)</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
    	<td class=h></td>
    </tr>
    <tr>
        <td align=right><img src=../images/center/button_jjb.gif border=0>&nbsp;&nbsp;<a href="sawon_sort.jsp" target=_self><img src=../images/center/button_isb.gif border=0></a>&nbsp;</a>
		
		</td>
    </tr>
    <tr>
        <td>
            <table width=100%  border=0 cellspacing=0 cellpadding=0>
			<%for(int i =0;i<dept_id.length; i++){
				Vector vt = umd.getSawonList(dept_id[i]);
				int vt_size = vt.size();%>
                <tr>
                <!--  <td><img src=http://fms1.amazoncar.co.kr/images/group_bar_<%=i+1%>.gif width=103 height=36></td> -->
                     <td><font color='#846733'><b>[ <%=c_db.getNameById(dept_id[i], "DEPT")%> ]</b></font></td>
                </tr>
                <tr>
                    <td class=h></td>
                </tr>
            <!--�ӿ� -->
                <tr>
                    <td>
                        <table width=100%  border=0 cellpadding=0 cellspacing=0>
						<% 	if(vt_size>0){
								for(int j = 0 ; j < vt_size;){
									Hashtable ht1 = (Hashtable)vt.elementAt(j);
									Hashtable ht2 = new Hashtable();
									if(j+1 < vt_size){
										ht2 = (Hashtable)vt.elementAt(j+1);
									}%>
									
                            <tr>
                                <td width=49%>
                                    <table width=100%  border=0 cellpadding=0 cellspacing=0>
                                        <tr>
                                            <td width=103 align=center>
                                                <table width=87  border=0 cellpadding=0 cellspacing=1 bgcolor=cfcfcf>
                                                    <tr>
                                                        <td bgcolor=#FFFFFF><img name="carImg" src="https://fms3.amazoncar.co.kr<%=ht1.get("SAVE_FOLDER")%><%=ht1.get("FILE_NAME")%>" border="0" width="85" height="105"></td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td>
                                                <table width=100% border=0 cellpadding=0 cellspacing=1 bgcolor=e9e9e9>
                                                    <tr>
                                                        <td style='height:105' align=center bgcolor=#FFFFFF>
                                                            <table width=98% border=0 cellpadding=0 cellspacing=1 bgcolor=cfcfcf>
                                                                <tr>
                                                                    <td width=20% height=24 align=center style="background-color:#eaeaea; height:24; color:848484;">�� ��</td>
                                                                    <td width=30% bgcolor=#FFFFFF style='color:0a3489'>&nbsp;<b><%if(String.valueOf(ht1.get("USER_ID")).equals(ck_acar_id)){%><a href="javascript:UserUpdate('<%= ht1.get("USER_ID") %>','<%//=auth_rw%>')"><%=ht1.get("USER_NM")%></a><%}else{%><%=ht1.get("USER_NM")%><%}%></b></td>
                                                                    <td width=20% align=center style="background-color:#eaeaea; height:24; color:848484;">�� ��</td>
                                                                    <td width=30% bgcolor=#FFFFFF>&nbsp;<%=ht1.get("USER_POS")%></span></td>
                                                                </tr>
                                                                <tr>
                                                                    <td height=24 align=center style="background-color:#eaeaea; height:24; color:848484;">�� ��</td>
                                                                    <td bgcolor=#FFFFFF>&nbsp;��<%=ht1.get("AGE")%>��</td>
                                                                    <td align=center style="background-color:#eaeaea; height:24; color:848484;">�Ի���</td>
                                                                    <td bgcolor=#FFFFFF>&nbsp;<%=ht1.get("ENTER_DT")%></td>
                                                                </tr>
                                                                <tr>
																	<td height=24 align=center style="background-color:#eaeaea; height:24; color:848484;">�ڵ���</td>
																	<td bgcolor=#FFFFFF>&nbsp;<%=ht1.get("USER_M_TEL")%></td>
                                                                    
																	<td align=center style="background-color:#eaeaea; height:24; color:848484;">�����ȣ</td>
                                                                    <td bgcolor=#FFFFFF>&nbsp;<%=ht1.get("HOT_TEL")%></td>
                                                                </tr>
                                                                <tr>
																	<td align=center style="background-color:#eaeaea; height:24; color:848484;">������ȣ</td>
																	<td bgcolor=#FFFFFF>&nbsp;<%=ht1.get("IN_TEL")%></td>
																	<td height=24 align=center style="background-color:#eaeaea; height:24; color:848484;">��������</td>
                                                                    <td bgcolor=#FFFFFF>&nbsp;<%if(String.valueOf(ht1.get("LOAN_ST")).equals("1")){%>������<%}else if(String.valueOf(ht1.get("LOAN_ST")).equals("2")){%>����<%}%></td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                                <td width=2% align=center>&nbsp;</td>
                                <td width=49%>
								<%if(j+1 < vt_size){%>
                                    <table width=100%  border=0 cellpadding=0 cellspacing=0>
                                        <tr>
                                            <td width=103 align=center>
                                                <table width=87  border=0 cellpadding=0 cellspacing=1 bgcolor=cfcfcf>
                                                    <tr>
                                                        <td bgcolor=#FFFFFF><img name="carImg" src="https://fms3.amazoncar.co.kr<%=ht2.get("SAVE_FOLDER")%><%=ht2.get("FILE_NAME")%>" border="0" width="85" height="105"></td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td>
                                                <table width=100% border=0 cellpadding=0 cellspacing=1 bgcolor=e9e9e9>
                                                    <tr>
                                                        <td style='height:105' align=center bgcolor=#FFFFFF>
                                                            <table width=98% border=0 cellpadding=0 cellspacing=1 bgcolor=cfcfcf>
                                                                <tr>
                                                                    <td width=20% height=24 align=center style="background-color:#eaeaea; height:24; color:848484;">�� ��</td>
                                                                    <td width=30% bgcolor=#FFFFFF style='color:0a3489'>&nbsp;<b><%=ht2.get("USER_NM")%></b></td>
                                                                    <td width=20% align=center style="background-color:#eaeaea; height:24; color:848484;">�� ��</td>
                                                                    <td width=30% bgcolor=#FFFFFF>&nbsp;<%=ht2.get("USER_POS")%></td>
                                                                </tr>
                                                                <tr>
                                                                    <td height=24 align=center style="background-color:#eaeaea; height:24; color:848484;">�� ��</td>
                                                                    <td bgcolor=#FFFFFF>&nbsp;��<%=ht2.get("AGE")%>��</td>
                                                                    <td align=center style="background-color:#eaeaea; height:24; color:848484;">�Ի���</td>
                                                                    <td bgcolor=#FFFFFF>&nbsp;<%=ht2.get("ENTER_DT")%></td>
                                                                </tr>
                                                                <tr>
																    <td height=24 align=center style="background-color:#eaeaea; height:24; color:848484;">�ڵ���</td>
                                                                    <td bgcolor=#FFFFFF>&nbsp;<%=ht2.get("USER_M_TEL")%></td>
                                                                    <td align=center style="background-color:#eaeaea; height:24; color:848484;">�����ȣ</td>
                                                                    <td bgcolor=#FFFFFF>&nbsp;<%=ht2.get("HOT_TEL")%></td>
                                                                </tr>
                                                                <tr>

                                                                  <td align=center style="background-color:#eaeaea; height:24; color:848484;">������ȣ</td>
                                                                  <td bgcolor=#FFFFFF>&nbsp;<%=ht2.get("IN_TEL")%></td>
																  <td height=24 align=center style="background-color:#eaeaea; height:24; color:848484;">��������</td>
                                                                  <td bgcolor=#FFFFFF>&nbsp;<%if(String.valueOf(ht2.get("LOAN_ST")).equals("1")){%>������<%}else if(String.valueOf(ht2.get("LOAN_ST")).equals("2")){%>����<%}%></td>
																	
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>									
								<%}%>
                                </td>
                            </tr>
			                <tr>
            			        <td colspan="3" class=h></td>
			                </tr>							
						    <%	j+=2;}}%>	
                        </table>
                    </td>
                </tr>
             <!--�ӿ� -->
                <tr>
                    <td style='height:30'></td>
                </tr>
			<%}%>
            </table>
        </td>
    </tr>
</table>
</body>
</html>
