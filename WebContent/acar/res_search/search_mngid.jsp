<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.res_search.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String s_brch_id = request.getParameter("s_brch_id")==null?"":request.getParameter("s_brch_id");
	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	
	
	Vector vt = rs_db.getSearchMngIdList(s_brch_id);
	int vt_size = vt.size();
	
	//����������
	Hashtable cont = a_db.getContViewUseYCarCase(c_id);
	
	
	//20121116 ������������ٴ� �������� ������ �ʿ�
%>
<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='javascript'>
<!--
	function select(mng_id,mng_nm){		
		var ofm = opener.document.form1;
		ofm.mng_id.value = mng_id;
		ofm.mng_nm.value = mng_nm;
		self.close();			
	}
//-->
</script>
</head>

<body>
<center>
<form name='form1' action='' method='post'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
    	<td colspan=2>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>����ý��� > <span class=style5>��������� �˻�</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������ ����</span></td>
    </tr>    
    <tr>
        <td class=line2></td>
    </tr>
	<tr>
	    <td class='line'>
	        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                  <tr> 
                    <td width='20%' class='title'>����ȣ</td>
                    <td colspan="3">&nbsp;<%=cont.get("RENT_L_CD")%></td>
                  </tr>                  
                  <tr> 
                    <td width='20%' class='title'>���������</td>
                    <td width='30%'>&nbsp;<%=c_db.getNameById(String.valueOf(cont.get("BUS_ID2")),"USER")%></td>                    
                    <td width='20%' class='title'>���������</td>
                    <td width='30%'>&nbsp;<a href="javascript:select('<%= cont.get("MNG_ID")%>','<%=c_db.getNameById(String.valueOf(cont.get("MNG_ID")),"USER")%>')" onMouseOver="window.status=''; return true"><%=c_db.getNameById(String.valueOf(cont.get("MNG_ID")),"USER")%></a></td>                    
                  </tr>                  
                </table>
	    </td>	    
	</tr>    
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�����Һ� ������������ ����Ʈ ������� ��Ȳ</span></td>
    </tr>    
    <tr>
        <td class=line2></td>
    </tr>
	<tr>
	    <td class='line'>
	        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                  <tr> 
                    <td width='10%' class='title'>����</td>
                    <td width='45%' class='title'>�����</td>
                    <td width='45%' class='title'>����Ʈ ���� ���</td>                    
                  </tr>
                  <%for(int i = 0 ; i < vt_size ; i++){
    			Hashtable ht = (Hashtable)vt.elementAt(i);%>
                  <tr> 
                    <td align='center'><%=i+1%></td>
                    <td align='center'><a href="javascript:select('<%= ht.get("USER_ID")%>','<%= ht.get("USER_NM")%>')" onMouseOver="window.status=''; return true"><%=ht.get("USER_NM")%> <%=ht.get("USER_POS")%></a></td>                    
                    <td align='center'><%=ht.get("CNT")%></td>
                  </tr>    			
    		  <%}%>	
                </table>
	    </td>	    
	</tr>
    <tr>
        <td class=h></td>
    </tr>	
    <tr>
        <td>* Ÿ������ �������Ʈ�� ��ȸ�Ϸ��� ��â�� �ݰ�, ����Ʈ ���ȭ�鿡�� �����Ҹ� ������ �ٽ� ��ȸ�ϼ���.</td>
    </tr>    	
    <tr>
        <td>* 1���� : ����Ʈ ������ ���������</td>
    </tr>    	
    <tr>
        <td>* 2���� : �������� ���������</td>
    </tr>    	
    <tr>
        <td>* 3���� : ��� ����Ʈ���� ��������� ���� ������ �켱���� ����</td>
    </tr>    	
</table>
</form>
</center>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
