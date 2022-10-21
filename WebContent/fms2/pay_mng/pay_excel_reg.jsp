<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ include file="/acar/cookies.jsp"%>
<%@ include file="/acar/access_log.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
%>
	
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
	<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		theURL = "https://fms3.amazoncar.co.kr/data/doc/"+theURL;
		window.open(theURL,winName,features);
	}
	
	//�׿��� ��ȸ�ϱ�
	function ven_search(){
		var fm = document.form1;	
		window.open("/card/doc_reg/vendor_list2.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&idx=&t_wd=&from_page=/fms2/pay_mng/pay_excel_reg.jsp", "VENDOR_LIST", "left=150, top=150, width=950, height=550, scrollbars=yes");		
	}			
	
//-->
</script>
</head>

<body>

<form name='form1' action='' method='post' enctype="multipart/form-data">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>

<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td colspan=10>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�繫ȸ�� > ���ݰ��� > <span class=style5>
						��ݿ���[����]���</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
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
        <td align="right" class="line">
		    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="100" class='title'>����</td>
                    <td>&nbsp;
                    	 <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
    			        <a href="/fms2/pay_mng/pay_excel.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>" target="_blank"><img src=/acar/images/center/button_igdr.gif align=absmiddle border=0></a>
    			        <%}%>
                </tr>						
            </table>
		</td>
    </tr>
    <tr>
        <td align="right">&nbsp;</td>
    </tr>
    <tr>
        <td>* ����Ȯ���� <b>*.xls</b> �� ���ϸ� �����մϴ�.</td>
    </tr>	  
    <tr>
        <td align="right">&nbsp;</td>
    </tr>
    
    <tr>
        <td align="right">&nbsp;</td>
    </tr>
    <tr>
        <td align="right">&nbsp;</td>
    </tr>
    <tr>
        <td align="right">&nbsp;</td>
    </tr>
    <tr>
        <td align="right">&nbsp;</td>
    </tr>
    <tr>
        <td><a href="javascript:MM_openBrWindow('pay_excel_reg_base_form.xls','popwin_in1','scrollbars=no,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=600,left=50, top=50')" title='���� ����� ���� �⺻��� ���� �ٿ�ޱ�'><img src="/acar/images/center/button_excel_bform.gif"  align="absmiddle" border="0"></a>&nbsp;		
		  : ��ݿ����� ������ �̿��ؼ� ����ϱ� ���� �⺻����Դϴ�.  �ٸ��̸����� �����Ͽ� ���� �ۼ��� ��Ͽ� ����Ͻñ� �ٶ��ϴ�.
		  --> 2017-12-01 ����ڵ� ���� ����ݾ�1~5 �߰���.
		</td>
    </tr>	
    <tr>
        <td align="right">&nbsp;</td>
    </tr>
    <tr>
        <td><a href="javascript:ven_search()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_search_nglc.gif"  align="absmiddle" border="0"></a>&nbsp;		
		  : �׿��� �ŷ�ó �ڵ带 ��ȸ�ϴ� ȭ���� �˾��մϴ�. �������� �ۼ��� �����ϼ���.
		</td>
    </tr>
    <tr>
        <td align="right">&nbsp;</td>
    </tr>
    <tr>
        <td><font color=red>* ��������� �⺻��İ� Ʋ�� ��� ���������� ����� ���� �ʽ��ϴ�.</font></td>
    </tr>
	
  </table>
  </form>

</body>
</html>
