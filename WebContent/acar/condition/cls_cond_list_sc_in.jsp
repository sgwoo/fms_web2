<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.condition.*" %>
<%@ include file="/acar/cookies.jsp" %>
<%

	ConditionDatabase cdb = ConditionDatabase.getInstance();
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	
	String ref_dt1 = request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 = request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");

	
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String dt = request.getParameter("dt")==null?"":request.getParameter("dt");
	String st_year = request.getParameter("st_year")==null?"":request.getParameter("st_year");
	
	Vector ccl = new Vector();
	
	ccl = cdb.getClsCondList(dt, st_year, ref_dt1, ref_dt2, gubun1, gubun2);
	int ccl_size = ccl.size();
	
	long r_cnt1 = 0;
	long r_cnt2 = 0;
	long r_cnt3 = 0;
	long r_cnt4 = 0;
	long r_cnt5 = 0;
	long r_cnt6 = 0;
	long r_cnt7 = 0;
	long r_cnt8 = 0;
	long r_cnt9 = 0;
	long r_cnt10 = 0;
	
	long l_cnt1 = 0;
	long l_cnt2 = 0;
	long l_cnt3 = 0;
	long l_cnt4 = 0;
	long l_cnt5 = 0;
	long l_cnt6 = 0;
	long l_cnt7 = 0;
	long l_cnt8 = 0;
	long l_cnt9 = 0;
	long l_cnt10 = 0;
	
	long m_cnt1 = 0;
	long m_cnt2 = 0;
	long m_cnt3 = 0;
	long m_cnt4 = 0;
	long m_cnt5 = 0;
	long m_cnt6 = 0;
	long m_cnt7 = 0;
	long m_cnt8 = 0;
	long m_cnt9 = 0;
	long m_cnt10 = 0;
	
	long rl_cnt1 = 0;
	long rl_cnt2 = 0;
	long rl_cnt3 = 0;
	long rl_cnt4 = 0;
	long rl_cnt5 = 0;
	long rl_cnt6 = 0;
	long rl_cnt7 = 0;
	long rl_cnt8 = 0;
	long rl_cnt9 = 0;
	long rl_cnt10 = 0;
	
	String gubun = "";
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript">
<!--

/* Title ���� */
function setupEvents()
{
		window.onscroll = moveTitle ;
		window.onresize = moveTitle ; 
}

function moveTitle()
{
    var X ;
    document.all.title.style.pixelTop = document.body.scrollTop ;
                                                                              
    document.all.title_col0.style.pixelLeft	= document.body.scrollLeft ; 
    document.all.D1_col.style.pixelLeft	= document.body.scrollLeft ;   
    
}
function init() {
	
	setupEvents();
}
//-->
</script>
</head>
<body rightmargin=0>
<form name='form1' action='' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='st_year' value='<%=st_year%>'>
<input type='hidden' name='dt' value='<%=dt%>'>
<table border=0 cellspacing=0 cellpadding=0 width="100%">
    <tr>
        <td class=line2></td>
    </tr>
	<tr>
		<td class='line'>			 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width=10% class=title>����</td>
                    <td width=10% class=title>���</td>
                    <td width=8% class=title>��ุ��</td>
                    <td width=8% class=title>�ߵ�����</td>
                    <td width=8% class=title>�����Һ���</td>
                    <td width=8% class=title>��������</td>
                    <td width=8% class=title>���°�</td>
					<td width=8% class=title>���������</td>
					<td width=8% class=title>����������</td>
					<td width=8% class=title>���Կɼ�</td>                    
                    <td width=8% class=title>�Ű�</td>
					<td width=8% class=title>����</td>
					
                </tr>
	  
        <%	for (int i = 0 ; i < ccl_size ; i++){
						Hashtable ht = (Hashtable)ccl.elementAt(i); 
						if(String.valueOf(ht.get("����")).equals("��Ʈ")){
						gubun = "��Ʈ";
					r_cnt1 +=  AddUtil.parseLong(String.valueOf(ht.get("��ุ��")));	
					r_cnt2 +=  AddUtil.parseLong(String.valueOf(ht.get("�ߵ�����")));
					r_cnt3 +=  AddUtil.parseLong(String.valueOf(ht.get("�����Һ���")));
					r_cnt4 +=  AddUtil.parseLong(String.valueOf(ht.get("��������")));
					r_cnt5 +=  AddUtil.parseLong(String.valueOf(ht.get("���°�")));
					r_cnt6 +=  AddUtil.parseLong(String.valueOf(ht.get("���������")));
					r_cnt7 +=  AddUtil.parseLong(String.valueOf(ht.get("����������")));
					r_cnt8 +=  AddUtil.parseLong(String.valueOf(ht.get("���Կɼ�")));
					r_cnt9 +=  AddUtil.parseLong(String.valueOf(ht.get("�Ű�")));
					r_cnt10 +=  AddUtil.parseLong(String.valueOf(ht.get("����")));
					
					rl_cnt1 +=  AddUtil.parseLong(String.valueOf(ht.get("��ุ��")));	
					rl_cnt2 +=  AddUtil.parseLong(String.valueOf(ht.get("�ߵ�����")));
					rl_cnt3 +=  AddUtil.parseLong(String.valueOf(ht.get("�����Һ���")));
					rl_cnt4 +=  AddUtil.parseLong(String.valueOf(ht.get("��������")));
					rl_cnt5 +=  AddUtil.parseLong(String.valueOf(ht.get("���°�")));
					rl_cnt6 +=  AddUtil.parseLong(String.valueOf(ht.get("���������")));
					rl_cnt7 +=  AddUtil.parseLong(String.valueOf(ht.get("����������")));
					rl_cnt8 +=  AddUtil.parseLong(String.valueOf(ht.get("���Կɼ�")));
					rl_cnt9 +=  AddUtil.parseLong(String.valueOf(ht.get("�Ű�")));
					rl_cnt10 +=  AddUtil.parseLong(String.valueOf(ht.get("����")));					
%>
                <tr> 
                    <td align="center"><%=ht.get("����")%></td>
                    <td align="center"><%=ht.get("���")%></td>
                    <td align="center"><%=ht.get("��ุ��")%></td>
                    <td align="center"><%=ht.get("�ߵ�����")%></td>
                    <td align="center"><%=ht.get("�����Һ���")%></td>
                    <td align="center"><%=ht.get("��������")%></td>
                    <td align="center"><%=ht.get("���°�")%></td>
                    <td align="center"><%=ht.get("���������")%></td>
					<td align="center"><%=ht.get("����������")%></td>
					<td align="center"><%=ht.get("���Կɼ�")%></td>
					<td align="center"><%=ht.get("�Ű�")%></td>
					<td align="center"><%=ht.get("����")%></td>
                </tr>
        <%}}%>
		<%if(gubun.equals("��Ʈ")){%>
				<tr>
					<td align="center" colspan="2">��Ʈ �հ�</td>
					<td align="right"><%=r_cnt1%> ��&nbsp;</td>
					<td align="right"><%=r_cnt2%> ��&nbsp;</td>
					<td align="right"><%=r_cnt3%> ��&nbsp;</td>
					<td align="right"><%=r_cnt4%> ��&nbsp;</td>
					<td align="right"><%=r_cnt5%> ��&nbsp;</td>
					<td align="right"><%=r_cnt6%> ��&nbsp;</td>
					<td align="right"><%=r_cnt7%> ��&nbsp;</td>
					<td align="right"><%=r_cnt8%> ��&nbsp;</td>
					<td align="right"><%=r_cnt9%> ��&nbsp;</td>
					<td align="right"><%=r_cnt10%> ��&nbsp;</td>
				</tr>
		<%}%>
			<%	for (int i = 0 ; i < ccl_size ; i++){
						Hashtable ht2 = (Hashtable)ccl.elementAt(i); 
						if(String.valueOf(ht2.get("����")).equals("����")){
						gubun = "����";
					l_cnt1 +=  AddUtil.parseLong(String.valueOf(ht2.get("��ุ��")));	
					l_cnt2 +=  AddUtil.parseLong(String.valueOf(ht2.get("�ߵ�����")));
					l_cnt3 +=  AddUtil.parseLong(String.valueOf(ht2.get("�����Һ���")));
					l_cnt4 +=  AddUtil.parseLong(String.valueOf(ht2.get("��������")));
					l_cnt5 +=  AddUtil.parseLong(String.valueOf(ht2.get("���°�")));
					l_cnt6 +=  AddUtil.parseLong(String.valueOf(ht2.get("���������")));
					l_cnt7 +=  AddUtil.parseLong(String.valueOf(ht2.get("����������")));
					l_cnt8 +=  AddUtil.parseLong(String.valueOf(ht2.get("���Կɼ�")));
					l_cnt9 +=  AddUtil.parseLong(String.valueOf(ht2.get("�Ű�")));
					l_cnt10 +=  AddUtil.parseLong(String.valueOf(ht2.get("����")));
						
					rl_cnt1 +=  AddUtil.parseLong(String.valueOf(ht2.get("��ุ��")));	
					rl_cnt2 +=  AddUtil.parseLong(String.valueOf(ht2.get("�ߵ�����")));
					rl_cnt3 +=  AddUtil.parseLong(String.valueOf(ht2.get("�����Һ���")));
					rl_cnt4 +=  AddUtil.parseLong(String.valueOf(ht2.get("��������")));
					rl_cnt5 +=  AddUtil.parseLong(String.valueOf(ht2.get("���°�")));
					rl_cnt6 +=  AddUtil.parseLong(String.valueOf(ht2.get("���������")));
					rl_cnt7 +=  AddUtil.parseLong(String.valueOf(ht2.get("����������")));
					rl_cnt8 +=  AddUtil.parseLong(String.valueOf(ht2.get("���Կɼ�")));
					rl_cnt9 +=  AddUtil.parseLong(String.valueOf(ht2.get("�Ű�")));
					rl_cnt10 +=  AddUtil.parseLong(String.valueOf(ht2.get("����")));	
%>
                <tr> 
                    <td align="center"><%=ht2.get("����")%></td>
                    <td align="center"><%=ht2.get("���")%></td>
                    <td align="center"><%=ht2.get("��ุ��")%></td>
                    <td align="center"><%=ht2.get("�ߵ�����")%></td>
                    <td align="center"><%=ht2.get("�����Һ���")%></td>
                    <td align="center"><%=ht2.get("��������")%></td>
                    <td align="center"><%=ht2.get("���°�")%></td>
                    <td align="center"><%=ht2.get("���������")%></td>
					<td align="center"><%=ht2.get("����������")%></td>
					<td align="center"><%=ht2.get("���Կɼ�")%></td>
					<td align="center"><%=ht2.get("�Ű�")%></td>
					<td align="center"><%=ht2.get("����")%></td>
                </tr>
        <%}}%>
		<%if(gubun.equals("����")){%>
				<tr>
					<td align="center" colspan="2">���� �հ�</td>
					<td align="right"><%=l_cnt1%> ��&nbsp;</td>
					<td align="right"><%=l_cnt2%> ��&nbsp;</td>
					<td align="right"><%=l_cnt3%> ��&nbsp;</td>
					<td align="right"><%=l_cnt4%> ��&nbsp;</td>
					<td align="right"><%=l_cnt5%> ��&nbsp;</td>
					<td align="right"><%=l_cnt6%> ��&nbsp;</td>
					<td align="right"><%=l_cnt7%> ��&nbsp;</td>
					<td align="right"><%=l_cnt8%> ��&nbsp;</td>
					<td align="right"><%=l_cnt9%> ��&nbsp;</td>
					<td align="right"><%=l_cnt10%> ��&nbsp;</td>
				</tr>
		<%}%>		

            </table>
        </td>            		            		
	</tr>
	<tr>
        <td class=h></td>
    </tr>
	<tr>
        <td class=line2></td>
    </tr>
	<tr>
		<td class='line'>			 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr> 
                    <td width=20% class=title colspan="2" rowspan="2">��   ��</td>
                    <td width=8% class=title>��ุ��</td>
                    <td width=8% class=title>�ߵ�����</td>
                    <td width=8% class=title>�����Һ���</td>
                    <td width=8% class=title>��������</td>
                    <td width=8% class=title>���°�</td>
					<td width=8% class=title>���������<br>(����)</td>
					<td width=8% class=title>����������<br>(�縮��)</td>
					<td width=8% class=title>���Կɼ�</td>                    
                    <td width=8% class=title>�Ű�</td>
					<td width=8% class=title>����</td>
                </tr>
				<tr>
					<td align="right" width=8%> <%=rl_cnt1%> ��&nbsp;</td>
					<td align="right" width=8%> <%=rl_cnt2%> ��&nbsp;</td>
					<td align="right" width=8%> <%=rl_cnt3%> ��&nbsp;</td>
					<td align="right" width=8%> <%=rl_cnt4%> ��&nbsp;</td>
					<td align="right" width=8%> <%=rl_cnt5%> ��&nbsp;</td>
					<td align="right" width=8%> <%=rl_cnt6%> ��&nbsp;</td>
					<td align="right" width=8%> <%=rl_cnt7%> ��&nbsp;</td>
					<td align="right" width=8%> <%=rl_cnt8%> ��&nbsp;</td>
					<td align="right" width=8%> <%=rl_cnt9%> ��&nbsp;</td>
					<td align="right" width=8%> <%=rl_cnt10%> ��&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</form>
</body>
</html>