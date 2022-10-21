<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.user_mng.*, acar.partner.*" %>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<jsp:useBean id="po_db" scope="page" class="acar.partner.PartnerDatabase"/>
<%@ include file="/agent/cookies.jsp" %>

<%
	UserMngDatabase umd = UserMngDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	UsersBean user1 	= umd.getUsersBean(nm_db.getWorkAuthUser("�ɻ�"));
	UsersBean user2 	= umd.getUsersBean(nm_db.getWorkAuthUser("������ݱ����"));
	UsersBean user3 	= umd.getUsersBean(nm_db.getWorkAuthUser("���ݰ�꼭�����"));
	UsersBean user4 	= umd.getUsersBean(nm_db.getWorkAuthUser("����������"));
	UsersBean user5 	= umd.getUsersBean(nm_db.getWorkAuthUser("�������������"));
	UsersBean user6 	= umd.getUsersBean(nm_db.getWorkAuthUser("������Ʈ����"));
	UsersBean user7 	= umd.getUsersBean(nm_db.getWorkAuthUser("������Ʈ����2"));
	UsersBean user8 	= umd.getUsersBean(nm_db.getWorkAuthUser("���������"));
	

	UsersBean user_r [] = umd.getUserAllSostel("", "0020", "");
	
	Vector vt = po_db.PartnerAll("", "", "", "", "", "");
	int vt_size = vt.size();		
%>

<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<title>���� ����</title>
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
//-->
</script>
<script language='JavaScript' src='/include/common.js'></script>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
</head>
<body>
<table width=100% border=0 cellspacing=0 cellpadding=0>
    <tr>
        <td align=center>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>�Ƹ���ī ���� ������</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td>&nbsp;</td>
    </tr>
    <!--  ������ȹ�� ���� -->
   
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
            <table border=0 cellspacing=1 width=100%>
            	<tr>
					      <td width=16% class=title>����</td>
					      <td width=20% class=title>��ü</td>
            		<td width=8% class=title>����</td>
            		<td width=8% class=title>����</td>
            		<td width=12% class=title>�޴���</td>
            		<td width=12% class=title>��ȭ</td>
               	<td width=24% class=title>���</td>
            	</tr>
            	<tr>
            		<td align="center">�ɻ�</td>
            		<td align="center">�Ƹ���ī</td>
            		<td align=center><%=user1.getUser_pos()  %></td>
            		<td align=center><%=user1.getUser_nm() %></td>
            		<td align=center><%=user1.getUser_m_tel()%></td>
            		<td align=center><%=user1.getHot_tel() %></td>
            		<td align=center></td>
            	</tr>            	
<%
    for(int i=0; i<user_r.length; i++){
        user_bean = user_r[i];
%>
				<%if(user_bean.getUser_id().equals("000077") || user_bean.getUser_id().equals("000144")){%>
            	<tr>
            		<td align="center">��������</td>
            		<td align="center">�Ƹ���ī</td>
            		<td align=center><%=user_bean.getUser_pos()  %></td>
            		<td align=center><%= user_bean.getUser_nm() %></td>
            		<td align=center><%= user_bean.getUser_m_tel()%></td>
            		<td align=center><%= user_bean.getHot_tel() %></td>
            		<td align=center></td>
            	</tr>
				<%}%>
<%}%>
            	<tr>
            		<td align="center">��������</td>
            		<td align="center">�Ƹ���ī</td>
            		<td align=center><%=user6.getUser_pos()  %></td>
            		<td align=center><%=user6.getUser_nm() %></td>
            		<td align=center><%=user6.getUser_m_tel()%></td>
            		<td align=center><%=user6.getHot_tel() %></td>
            		<td align=center></td>
            	</tr>
            	<tr>
            		<td align="center">��������</td>
            		<td align="center">�Ƹ���ī</td>
            		<td align=center><%=user7.getUser_pos()  %></td>
            		<td align=center><%=user7.getUser_nm() %></td>
            		<td align=center><%=user7.getUser_m_tel()%></td>
            		<td align=center><%=user7.getHot_tel() %></td>
            		<td align=center></td>
            	</tr>            	
            	<tr>
            		<td align="center">������ݰ���</td>
            		<td align="center">�Ƹ���ī</td>
            		<td align=center><%=user2.getUser_pos()  %></td>
            		<td align=center><%=user2.getUser_nm() %></td>
            		<td align=center><%=user2.getUser_m_tel()%></td>
            		<td align=center><%=user2.getHot_tel() %></td>
            		<td align=center></td>
            	</tr>
				<tr>
					<td align=center>�������</td>
					<td align=center>�Ƹ���ī</td>
            		<td align=center><%=user8.getUser_pos()  %></td>
            		<td align=center><%=user8.getUser_nm() %></td>
            		<td align=center><%=user8.getUser_m_tel()%></td>
            		<td align=center><%=user8.getHot_tel() %></td>
					<td>&nbsp;</td>
				</tr>
            	<tr>
            		<td align="center">���ݰ�꼭</td>
            		<td align="center">�Ƹ���ī</td>
            		<td align=center><%=user3.getUser_pos()  %></td>
            		<td align=center><%=user3.getUser_nm() %></td>
            		<td align=center><%=user3.getUser_m_tel()%></td>
            		<td align=center><%=user3.getHot_tel() %></td>
            		<td align=center></td>
            	</tr>    
            	<tr>
            		<td align="center">����</td>
            		<td align="center">�Ƹ���ī</td>
            		<td align=center><%=user4.getUser_pos()  %></td>
            		<td align=center><%=user4.getUser_nm() %></td>
            		<td align=center><%=user4.getUser_m_tel()%></td>
            		<td align=center><%=user4.getHot_tel() %></td>
            		<td align=center></td>
            	</tr>      
            	<tr>
            		<td align="center">������ �����μ�</td>
            		<td align="center">�Ƹ���ī</td>
            		<td align=center><%=user5.getUser_pos()  %></td>
            		<td align=center><%=user5.getUser_nm() %></td>
            		<td align=center><%=user5.getUser_m_tel()%></td>
            		<td align=center><%=user5.getHot_tel() %></td>
            		<td align=center></td>
            	</tr>                	            	  
            </table>
        </td>
    </tr>
    <!--  ������ȹ�� �� -->
    
    <tr>
		<td>&nbsp;</td>
	</tr>
     <!--  ���¾�ü ���� -->
	<tr>
    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���¾�ü</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>    
    <tr>
        <td class=line>    
			<table border=0 cellspacing=1 width=100%>
				<tr>
					<td width=16% class=title>����</td>
					<td width=20% class=title>��ü</td>
            		<td width=16% class=title>����/����</td>
            		<td width=12% class=title>�޴���</td>
            		<td width=12% class=title>��ȭ</td>
               		<td width=24% class=title>���</td>
				</tr>
				
				<tr>
					<td align=center>��ǰ��ü(����)</td>
					<td align=center>�ٿȹ�</td>
					<td align=center>��ǥ ������</td>
					<td align=center>010-5218-2164</td>
					<td align=center>02-2068-7582</td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td align=center>��ǰ��ü(����)</td>
					<td align=center>(��)�̼���ũ</td>
					<td align=center>���� �ֵ�ȣ</td>
					<td align=center>010-9386-0990</td>
					<td align=center>042-488-2437</td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td align=center>��ǰ��ü(�뱸)</td>
					<td align=center>�ƽþƳ����</td>
					<td align=center>��ǥ ������</td>
					<td align=center>010-3509-9435</td>
					<td align=center>053-587-1550</td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td align=center>��ǰ��ü(����)</td>
					<td align=center>������ڵ�����ǰ��</td>
					<td align=center>��ǥ �缱��</td>
					<td align=center>010-5414-5710</td>
					<td align=center>062-453-5710</td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td align=center>��ǰ��ü(�λ�)</td>
					<td align=center>������TS</td>
					<td align=center>��ǥ �̹���</td>
					<td align=center>010-2000-8018</td>
					<td align=center>&nbsp;</td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td align=center>��ǰ��ü(���ֵ�)</td>
					<td align=center>�縶���ֿ�����</td>
					<td align=center>��ǥ �����</td>
					<td align=center>010-2693-4851</td>
					<td align=center>064-749-4851</td>
					<td>&nbsp;�ּ�: ���ֽ� ���ּ��� 7818</td>
				</tr>
				<tr>
					<td align=center>&nbsp;</td>
					<td align=center>&nbsp;</td>
					<td align=center>&nbsp;</td>
					<td align=center>&nbsp;</td>
					<td align=center>&nbsp;</td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td align=center>Ź�۾�ü</td>
					<td align=center>(��)�Ƹ���Ź��</td>
					<td align=center>��ǥ ������</td>
					<td align=center>010-7302-8839</td>
					<td align=center>02-2644-2225</td>
					<td>&nbsp;070-8868-2227 ���̿� ����    ����</td>
				</tr>
				<tr>
					<td align=center>Ź�۾�ü</td>
					<td align=center>�ϵ�����Ź��</td>
					<td align=center>��ǥ �����</td>
					<td align=center>&nbsp;</td>
					<td align=center>1800-2612</td>
					<td>&nbsp;�뱸/�λ�/���� (������Ƽ�ڸ���)</td>
				</tr>
				<tr>
					<td align=center>Ź�۾�ü</td>
					<td align=center>����ī��(����)</td>
					<td align=center>��ǥ �Ӹ��</td>
					<td align=center>010-2890-0802</td>
					<td align=center>042-639-1230</td>
					<td>&nbsp;����Ź��</td>
				</tr>
				<tr>
					<td align=center>Ź�۾�ü</td>
					<td align=center>�۽�Ʈ����̺�</td>
					<td align=center>��ǥ �ڿ���</td>
					<td align=center>010-4449-7986</td>
					<td align=center>010-4449-7986</td>
					<td>&nbsp;����Ź��(�� ��ȭ�� ��ǥ�ڿ��� ��ȭ�޶�� ��û)</td>
				</tr>
				<tr>
					<td align=center>&nbsp;</td>
					<td align=center>&nbsp;</td>
					<td align=center>&nbsp;</td>
					<td align=center>&nbsp;</td>
					<td align=center>&nbsp;</td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td align=center>��üŹ�۾�ü (ĳ����)</td>
					<td align=center>���������(�� ��������)</td>
					<td align=center>���� �ڿ���</td>
					<td align=center>010-3262-5080</td>
					<td align=center>02-2277-7265</td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td align=center>��üŹ�۾�ü (ĳ����)</td>
					<td align=center>�߻���Ư��</td>
					<td align=center>���� �ŵ���</td>
					<td align=center>010-4311-3882</td>
					<td align=center>031-288-0995</td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td align=center>&nbsp;</td>
					<td align=center>&nbsp;</td>
					<td align=center>&nbsp;</td>
					<td align=center>&nbsp;</td>
					<td align=center>&nbsp;</td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td align=center>����⵿</td>
					<td align=center>����Ÿ �ڵ�������</td>
					<td align=center>&nbsp;</td>
					<td align=center>&nbsp;</td>
					<td align=center>1588-6688</td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td align=center>����⵿</td>
					<td align=center>�Ｚ�ִ�ī����</td>
					<td align=center>&nbsp;</td>
					<td align=center>&nbsp;</td>
					<td align=center>02-2119-3117</td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td align=center>&nbsp;</td>
					<td align=center>&nbsp;</td>
					<td align=center>&nbsp;</td>
					<td align=center>&nbsp;</td>
					<td align=center>&nbsp;</td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td align=center>�����</td>
					<td align=center>����ī��������</td>
					<td align=center>�������</td>
					<td align=center>&nbsp;</td>
					<td align=center>1661-7977</td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td align=center>�����</td>
					<td align=center>����ȭ��</td>
					<td align=center>�������</td>
					<td align=center>&nbsp;</td>
					<td align=center>1588-0100</td>
					<td>&nbsp;</td>
				</tr>
			</table>
        </td>
    </tr>
    <tr>
        <td>&nbsp;</td>
    </tr>    
</body>
</html>
