<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.stat_bus.*"%>
<jsp:useBean id="sb_db" scope="page" class="acar.stat_bus.StatBusDatabase"/>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	String s_yy = request.getParameter("s_yy")==null?AddUtil.getDate(1):request.getParameter("s_yy");
	String s_mm = request.getParameter("s_mm")==null?AddUtil.getDate(2):request.getParameter("s_mm");
	
	s_yy = AddUtil.replace(s_yy,"-","");
	s_mm = AddUtil.replace(s_mm,"-","");
	
	Vector vt = sb_db.getStatRentUser(s_yy, s_mm);
	int vt_size = vt.size();
	
	int count = 1;
	
	String class_type = "";
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
/* Title 고정 */
function setupEvents()
{
		window.onscroll = moveTitle ;
		window.onresize = moveTitle ; 
}

function moveTitle()
{
    var X ;
    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    
    
}
function init() {
	
	setupEvents();
}
//-->
</script>
<script language='javascript'>
<!--
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onLoad="javascript:init()">
<form action="" name="form1" method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='s_yy' value='<%=s_yy%>'>
<input type='hidden' name='s_mm' value='<%=s_mm%>'>
<table border="0" cellspacing="0" cellpadding="0" width=1480>
    <tr>
        <td colspan=2 class=line2></td>
    </tr>
    <tr id='tr_title' style='position:relative;z-index:1'>
	    <td class=line id='td_title' style='position:relative;'> 
	        <table width="280" border="0" cellspacing="1" cellpadding="0">
                <tr align="center"> 
                    <td class=title width="110">부서</td>
                    <td class=title width="30" style='height:51'>연번</td>
                    <td class=title width="50">성명</td>
                    <td class=title width="90">입사일자</td>               
                </tr>
            </table>
        </td>
	    <td width='1200' class=line>
	        <table width='1200' border="0" cellspacing="1" cellpadding="0">
                <tr align="center"> 
                     <td class=title rowspan="2" width="50"> 총합계</td>
                    <td class=title colspan="7">합계</td>
                    <td class=title colspan="7">일반식</td>
                    <td class=title colspan="7">기본식</td>
                    <td class=title rowspan="2" width="50">전자<br>계약</td>
                    <td class=title rowspan="2" width="50">월렌트</td>
                </tr>
                <tr align="center"> 
                    <td class=title width="50">신규</td>
                    <td class=title width="50">대차</td>
                    <td class=title width="50">증차</td>
                    <td class=title width="50">소계</td>
                    <td class=title width="50">재리스</td>
                    <td class=title width="50">연장</td>
                    <td class=title width="50">계</td>
                    <td class=title width="50">신규</td>
                    <td class=title width="50">대차</td>
                    <td class=title width="50">증차</td>
                    <td class=title width="50">소계</td>
                    <td class=title width="50">재리스</td>
                    <td class=title width="50">연장</td>
                    <td class=title width="50">계</td>
                    <td class=title width="50">신규</td>
                    <td class=title width="50">대차</td>
                    <td class=title width="50">증차</td>
                    <td class=title width="50">소계</td>
                    <td class=title width="50">재리스</td>
                    <td class=title width="50">연장</td>
                    <td class=title width="50">계</td>                                                            
                </tr>
            </table>
	    </td>
    </tr>  			  
    <tr>
	    <td class='line' id='td_con' style='position:relative;'> 
	        <table border="0" cellspacing="1" cellpadding="0" width='280'>
	            <%for (int i = 0 ; i < vt_size ; i++){
    				Hashtable ht = (Hashtable)vt.elementAt(i);
					class_type = "";
					if(String.valueOf(ht.get("BR_NM")).equals("소계")){ class_type = "class=title"; }
					if(String.valueOf(ht.get("BR_NM")).equals("합계")){ class_type = "class=title_p"; }    				
           	    %> 			  				
                <tr> 
                	<%if(String.valueOf(ht.get("BR_NM")).equals("소계") || String.valueOf(ht.get("BR_NM")).equals("합계")){%>
                	<td <%=class_type%> colspan='4'><%= String.valueOf(ht.get("BR_NM"))%></td>
                	<%}else{%>
                    <td align="center" width="110" height="20"><%= String.valueOf(ht.get("BR_NM"))%></td>
                    <td align="center" width="30" height="20"><%=count++%></td>
                    <td align="center" width="50" height="20"><%= String.valueOf(ht.get("USER_NM"))%></font></a></td>
                    <td align="center" width="90" height="20"><%=AddUtil.ChangeDate2( String.valueOf(ht.get("ENTER_DT")))%></td>
                    <%} %>
                </tr>
                <%}%>   	      
            </table>
        </td>   
	    <td class='line' width='1200'>
	        <table border="0" cellspacing="1" cellpadding="0" width='1200'>
	            <%for (int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);
					class_type = "";
					if(String.valueOf(ht.get("BR_NM")).equals("소계")){ class_type = "class=title"; }
					if(String.valueOf(ht.get("BR_NM")).equals("합계")){ class_type = "class=title_p"; }
		        %>
	            <tr> 
	                <td <%=class_type%> align="center" width="50"><%= String.valueOf(ht.get("CNT0"))%></td>
	                <td <%=class_type%> align="center" width="50"><%= String.valueOf(ht.get("CNT1"))%></td>
	                <td <%=class_type%> align="center" width="50"><%= String.valueOf(ht.get("CNT2"))%></td>
	                <td <%=class_type%> align="center" width="50"><%= String.valueOf(ht.get("CNT3"))%></td>
	                <td <%=class_type%> align="center" width="50"><%= String.valueOf(ht.get("CNT4"))%></td>
	                <td <%=class_type%> align="center" width="50"><%= String.valueOf(ht.get("CNT5"))%></td>
	                <td <%=class_type%> align="center" width="50"><%= String.valueOf(ht.get("CNT6"))%></td>
	                <td <%=class_type%> align="center" width="50"><%= String.valueOf(ht.get("CNT7"))%></td>
	                <td <%=class_type%> align="center" width="50"><%= String.valueOf(ht.get("CNT8"))%></td>
	                <td <%=class_type%> align="center" width="50"><%= String.valueOf(ht.get("CNT9"))%></td>
	                <td <%=class_type%> align="center" width="50"><%= String.valueOf(ht.get("CNT10"))%></td>
	                <td <%=class_type%> align="center" width="50"><%= String.valueOf(ht.get("CNT11"))%></td>
	                <td <%=class_type%> align="center" width="50"><%= String.valueOf(ht.get("CNT12"))%></td>
	                <td <%=class_type%> align="center" width="50"><%= String.valueOf(ht.get("CNT13"))%></td>
	                <td <%=class_type%> align="center" width="50"><%= String.valueOf(ht.get("CNT14"))%></td>
	                <td <%=class_type%> align="center" width="50"><%= String.valueOf(ht.get("CNT15"))%></td>
	                <td <%=class_type%> align="center" width="50"><%= String.valueOf(ht.get("CNT16"))%></td>
	                <td <%=class_type%> align="center" width="50"><%= String.valueOf(ht.get("CNT17"))%></td>
	                <td <%=class_type%> align="center" width="50"><%= String.valueOf(ht.get("CNT18"))%></td>
	                <td <%=class_type%> align="center" width="50"><%= String.valueOf(ht.get("CNT19"))%></td>
	                <td <%=class_type%> align="center" width="50"><%= String.valueOf(ht.get("CNT20"))%></td>
	                <td <%=class_type%> align="center" width="50"><%= String.valueOf(ht.get("CNT21"))%></td>
	                <td <%=class_type%> align="center" width="50"><%= String.valueOf(ht.get("CNT23"))%></td>
	                <td <%=class_type%> align="center" width="50"><%= String.valueOf(ht.get("CNT22"))%></td>
                </tr>
                <%}%> 
            </table>
	    </td>
	</tr>
</table>		
</form>
<script language='javascript'>
<!--
//-->
</script>
</body>
</html>
