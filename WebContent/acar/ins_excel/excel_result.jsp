<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*"%>

<%
	int start_row = request.getParameter("start_row")==null?0:AddUtil.parseInt(request.getParameter("start_row"));//������
	int value_line = request.getParameter("value_line")==null?0:AddUtil.parseInt(request.getParameter("value_line"));//��������Ÿ�ִ����
	int ment_cnt = request.getParameter("ment_cnt")==null?0:AddUtil.parseInt(request.getParameter("ment_cnt"));
	
	String result[]  	= request.getParameterValues("result");
	String car_no[]  	= request.getParameterValues("car_no");
	String ins_con_no[] = request.getParameterValues("ins_con_no");
%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
<script language="JavaScript" src="/include/info.js"></script>
<SCRIPT LANGUAGE="JavaScript">
<!--
	function pagesetPrint(){
		print();
	}
//-->
</SCRIPT>
<style type="text/css">
<!--
.style1 {color: #999999}
-->
</style>
</HEAD>
<BODY>
<p>
</p>
<form action="" method='post' name="form1">
<table border="0" cellspacing="0" cellpadding="0" width="570">
  <tr>
    <td>&lt; ���� ���� ���� ó�� ��� &gt; </td>
  </tr>
  <tr>
    <td>&nbsp;</td>
  </tr>      
  <tr>
    <td class="line">
	  <table border="0" cellspacing="1" cellpadding="0" width=100%>  
        <tr>
    	  <td width="30" class="title">����</td>
    	  <td width="100" class="title">���ǹ�ȣ</td>
    	  <td width="100" class="title">������ȣ</td>
    	  <td class="title">ó�����</td>
        </tr>
<%	if(ment_cnt >0){
		for(int i=0 ; i < result.length ; i++){%>		
        <tr>
          <td align="center"><%=i+1%></td>
          <td align="center"><%=ins_con_no[i] ==null?"":ins_con_no[i]%></td>
          <td align="center"><%=car_no[i] ==null?"":car_no[i]%></td>
          <td>&nbsp;<%=result[i] ==null?"":result[i]%></td>		  
        </tr>
<%		}
	}%>		
	  </table>
	</td>
  </tr>  
  <tr>
    <td align="center">&nbsp;</td>
  </tr>  
  <tr>  
    <td align="center"><a href='javascript:pagesetPrint()' onMouseOver="window.status=''; return true"><img src="/images/print.gif" width="50" height="18" aligh="absmiddle" border="0"></a>&nbsp;
	<a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src="/images/close.gif" width="50" height="18" aligh="absmiddle" border="0"></a></td>
    </tr>
</table>
</form>
</BODY>
</HTML>