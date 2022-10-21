<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, java.io.*,  acar.util.*"%>

<%
	
	String mng_nm 	= request.getParameter("mng_nm")==null?"":request.getParameter("mng_nm");
	String mng_pos 	= request.getParameter("mng_pos")==null?"":request.getParameter("mng_pos");
	String mng_tel 	= request.getParameter("mng_tel")==null?"":request.getParameter("mng_tel");
	
		
%>	

<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<title>산타페 연비보상 관련 안내</title>
<style type="text/css">
<!--

.style1 {color: #c94551; font-weight: bold;}
-->
</style>
<link href=http://www.amazoncar.co.kr/style.css rel=stylesheet type=text/css>
</head>
<body topmargin=0 leftmargin=0>
<table width=763 border=0 cellspacing=0 cellpadding=0 align=center background=http://fms1.amazoncar.co.kr/mailing/images/mail_bground.gif>
    <tr>
        <td>
            <table width=763 border=0 cellspacing=0 cellpadding=0 background=http://fms1.amazoncar.co.kr/mailing/images/mail_top.gif>
            	<tr>
            		<td height=10 colspan=4></td>
            	</tr>
                <tr>
                    <td width=156 align=right><a href=http://www.amazoncar.co.kr target=_blank onFocus=this.blur();><img src=http://fms1.amazoncar.co.kr/acar/images/logo_1.png border=0 width=110  style="padding-top: 10px"></a></td>
                    <td width=13 height=56>&nbsp;</td>
                    <td width=292><img src=http://fms1.amazoncar.co.kr/mailing/images/stitle_gd.gif></td>
                    <td width=302><img src=http://fms1.amazoncar.co.kr/mailing/images/mail_ment.gif></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td><img src=http://fms1.amazoncar.co.kr/mailing/images/mail_top_bar.gif></td>
    </tr>
    <tr>
        <td height=35></td>
    </tr>
    <tr>
        <td align=center><img src=http://fms1.amazoncar.co.kr/mailing/etc/images/santafe_ind.jpg border=0></td>
	</tr>
	<tr>
     	<td height=20></td>
	</tr>
	<tr>
      	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<img src=http://fms1.amazoncar.co.kr/mailing/etc/images/santafe_arrow.gif>&nbsp;&nbsp;<span class=style1>관리담당자</span> &nbsp;- &nbsp;<b><%=mng_nm%>  <%=mng_pos%></b> &nbsp;<b><%=mng_tel%></b></td>
	</tr>
	<tr>
    	<td height=50></td>
	</tr>
	<tr>
      	<td align=center><img src=http://fms1.amazoncar.co.kr/mailing/images/mail_line.gif border=0></td>
	</tr>
    <tr>
        <td height=25></td>
    </tr>
    <tr>
       <!--  <td align=center><img src=http://fms1.amazoncar.co.kr/mailing/images/mail_bottom_info.gif></td> -->
        <td>
        	<div style="float:left; width:200px;margin-left:55px;margin-top:30px;"><img src=http://fms1.amazoncar.co.kr/acar/images/logo_1.png></div>
        	<div style="float:left; width:30px;"><img src=http://fms1.amazoncar.co.kr/mailing/images/bottom_esti_right.gif border=0></div>
        </td>
    </tr>
    <tr>
        <td height=10></td>
    </tr>
    <tr>
        <td><img src=http://fms1.amazoncar.co.kr/mailing/images/mail_dw.gif></td>
    </tr>
</table>
</body>
</html>