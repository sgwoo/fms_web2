<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*"%>

<%
	int start_row = request.getParameter("start_row")==null?0:AddUtil.parseInt(request.getParameter("start_row"));//시작행
	int value_line = request.getParameter("value_line")==null?0:AddUtil.parseInt(request.getParameter("value_line"));//실제데이타있는행수
	
	String result[]  	= request.getParameterValues("result");
	String sh_code[] 	= request.getParameterValues("sh_code");
	String cars[]  		= request.getParameterValues("cars");
%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
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
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>계출관리 > <span class=style5>엑셀등록</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td align="right">&nbsp;</td>
    </tr>        
    <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>엑셀 파일 처리 결과</span></td>
    </tr>        
  <tr>
    <td>&nbsp;</td>
  </tr>      
  <tr>
    <td class="line">
	  <table border="0" cellspacing="1" cellpadding="0" width=100%>  
        <tr>
    	  <td width="30" class="title">연번</td>
    	  <td width="100" class="title">차종코드</td>
    	  <td width="100" class="title">차명</td>
    	  <td class="title">처리결과</td>
        </tr>
<%	for(int i=0 ; i < result.length ; i++){%>		
        <tr>
          <td align="center"><%=i+1%></td>
          <td align="center"><%=sh_code[i] ==null?"":sh_code[i]%></td>
          <td align="center"><%=cars[i] ==null?"":cars[i]%></td>
          <td>&nbsp;<%=result[i] ==null?"":result[i]%></td>		  
        </tr>
<%	}%>		
	  </table>
	</td>
  </tr>  
  <tr>
    <td align="center">&nbsp;</td>
  </tr>  
  <tr>  
    <td align="center"><a href='javascript:pagesetPrint()' onMouseOver="window.status=''; return true"><img src="/images/print.gif" width="50" height="18" aligh="absmiddle" border="0"></a>&nbsp;
	</td>
    </tr>
</table>
</form>
</BODY>
</HTML>