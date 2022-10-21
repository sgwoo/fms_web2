<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>

<%
String content_seq 	= request.getParameter("content_seq")==null?"":request.getParameter("content_seq");

CommonDataBase c_db = CommonDataBase.getInstance();
String content_code  = "RECALL"; 

Vector attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
int attach_vt_size = attach_vt.size();	
	
%>

<html>
<head><%@ include file="/acar/getNaviCookies.jsp" %>
<title>아마존카 리콜 안내문</title>
<meta http-equiv="Content-Type" content="text/html"; charset="euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	
//-->
</script>
<style type="text/css">
<!--
.style1 {color: #c90909; font-family:Nanumgothic; font-weight:bold;}

-->
</style>
<link href=http://www.amazoncar.co.kr/style.css rel=stylesheet type=text/css>
</head>
<body topmargin=0 leftmargin=0>
<table width=700 border=0 cellspacing=0 cellpadding=0 align=center>
    <tr>
        <td>
            <table width=700 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td width=22>&nbsp;</td>
                    <td width=558><a href=http://www.amazoncar.co.kr target=_blank onFocus=this.blur();><img src=https://fms5.amazoncar.co.kr/mailing/images/logo.gif width=332 height=52 border=0></a></td>
                    <td width=114 valign=baseline>&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td height=7></td>
    </tr>
    
    <tr>
        <td><img src=https://fms5.amazoncar.co.kr/mailing/images/layout_top.gif width=700 height=21></td>
    </tr>

    <tr>
        <td height=5 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>
            <table width=685 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td align=center id="image_site">
                    <%
                    if(attach_vt_size > 0){
						for(int i = 0 ; i < attach_vt_size ; i++){
							Hashtable ht = (Hashtable)attach_vt.elementAt(i);
							String save_folder = String.valueOf(ht.get("SAVE_FOLDER"));
							String save_file   = String.valueOf(ht.get("SAVE_FILE"));
					%>		
							<%-- <img src="https://fms3.amazoncar.co.kr/fms2/attach/view_normal.jsp?SEQ=<%=ht.get("SEQ")%>"> --%>
							<img src="https://fms3.amazoncar.co.kr<%=save_folder%><%=save_file%>" width=620 style="z-index: 1;">
							<%-- <%@ include file='https://fms3.amazoncar.co.kr/fms2/attach/view_normal.jsp' %> --%>
					<%		
						}
					}
                    %>
                    	<!-- <img src=https://fms5.amazoncar.co.kr/mailing/images/201808_bolt_recall.png border=0 width="620"> -->
                    </td>
                </tr>
            </table>
        </td>
    </tr>   
	<tr>
		<td align=center height=130 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif><span class=style1></span></td>
	</tr>

    <tr>
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif><img src=https://fms5.amazoncar.co.kr/mailing/images/line.gif width=667 height=1></td>
    </tr>
    <tr>
        <td height=20 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>&nbsp;</td>
    </tr>
    <tr>
        <td background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>
            <table width=700 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td width=35>&nbsp;</td>
                    <td width=82><img src=https://fms5.amazoncar.co.kr/mailing/images/bottom_logo.png></td>
                    <td width=28>&nbsp;</td>
                    <td width=1 bgcolor=dbdbdb></td>
                    <td width=32>&nbsp;</td>
                    <td width=513><img src=https://fms5.amazoncar.co.kr/mailing/images/bottom_esti_right.gif border=0></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td height=10 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
        <td><img src=https://fms5.amazoncar.co.kr/mailing/images/layout_bottom.gif width=700 height=21></td>
    </tr>
</table>
</body>
</html>

