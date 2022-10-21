<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.condition.*" %>
<jsp:useBean id="cc_bean" class="acar.condition.ClsCondBean" scope="page"/>

<%
	ConditionDatabase cdb = ConditionDatabase.getInstance();
	String ref_dt1 = Util.getDate();
	String ref_dt2 = Util.getDate();
	String auth_rw = "";
	String dt = "3";
	
	if(request.getParameter("auth_rw") != null)	auth_rw = request.getParameter("auth_rw");
	if(request.getParameter("dt") != null)	dt = request.getParameter("dt");
	if(request.getParameter("ref_dt1") != null)	ref_dt1 = request.getParameter("ref_dt1");
	if(request.getParameter("ref_dt2") != null)	ref_dt2 = request.getParameter("ref_dt2");
	
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page"); //	
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3"); //����
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4"); //��Ʈ
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5"); //�Ϲݽ�
	
	String bm = request.getParameter("bm")==null?"1":request.getParameter("bm");//Ÿ��
	

	String gubun = "";
	
	if ( from_page.equals("/fms2/stat_month/stat_cls1.jsp") ) {	
		gubun = "2";	
	} else {
	 	gubun = "1";
	} 
	
	ClsCondBean cc_r [] = cdb.getClsCondAll2(gubun,ref_dt1,ref_dt2, gubun3, gubun4, gubun5, bm);
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
<input type='hidden' name='from_page' 	value='<%=from_page%>'>  
<table border=0 cellspacing=0 cellpadding=0 width="100%">
    <tr>
        <td class=line2></td>
    </tr>
	<tr>
		<td class='line'>			 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width=4% class=title>����</td>
                    <td width=10% class=title>����</td>
                    <td width=11% class=title>����ȣ</td>
                    <td width=12% class=title>��ȣ</td>
                    <td width=8% class=title>�����</td>
                    <td width=10% class=title>������ȣ</td>
                    <td width=9% class=title>����</td>
                    <td width=8% class=title>��������</td>
                    <td width=20% class=title>��������</td>
                    <td width=8% class=title>�����</td>
                </tr>
	  
        <%
    for(int i=0; i<cc_r.length; i++){
        cc_bean = cc_r[i];
%>
                <tr> 
                    <td align="center"><%=i+1%></td>
                    <td align="center"><%= cc_bean.getCls_st_nm() %></td>
                    <td align="center"><%= cc_bean.getRent_l_cd() %></td>
                    <td>&nbsp;<span title='<%=cc_bean.getFirm_nm()%>'><%=AddUtil.subData(cc_bean.getFirm_nm(), 8)%></span></td>
                    <td align="center"><span title='<%=cc_bean.getClient_nm()%>'><%=AddUtil.subData(cc_bean.getClient_nm(), 4)%></span></td>
                    <td align="center"><%= cc_bean.getCar_no() %></td>
                    <td>&nbsp;<span title='<%=cc_bean.getCar_name()%>'><%=AddUtil.subData(cc_bean.getCar_name(), 6)%></span></td>
                    <td align="center"><%=AddUtil.ChangeDate2(cc_bean.getCls_dt())%></td>
                    <td>&nbsp;<span title='<%=cc_bean.getCls_cau()%>'><%=AddUtil.subData(cc_bean.getCls_cau(), 16)%></span></td>
                    <td align="center"><%= cc_bean.getReg_nm() %></td>
                </tr>
        <%}%>
        <% if(cc_r.length == 0){ %>
                <tr> 
                    <td colspan="10" align="center"> &nbsp;��ϵ� ����Ÿ�� �����ϴ�.</td>
                </tr>
        <%}%>
            </table>
        </td>            		            		
	</tr>
</table>
</body>
</html>