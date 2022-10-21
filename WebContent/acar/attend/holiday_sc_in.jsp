<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.attend.*"%>
<jsp:useBean id="t_db" scope="page" class="acar.attend.AttendDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src='/include/common.js'></script>
<script language="JavaScript">
<!--
//-->
</script>
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String s_year = request.getParameter("s_year")==null?"":request.getParameter("s_year");
	int i =0;
	
	Vector hols = t_db.getHolidayList(s_year);
	int hol_size = hols.size();
%>
<form action="holiday_sc_a.jsp" name="form1" method="post">
<input type="hidden" name="hol_size" value="<%=hol_size%>">
<table border=0 cellspacing=0 cellpadding=0 width=500>
    <tr>		
        <td> 
            <table border="0" cellspacing="0" cellpadding="0" width=500>
                <tr>
                    <td class=line2></td>
                </tr>
                <tr>					
                    <td class='line' width="800"> 
                        <table  border=0 cellspacing=1 width="500">
                            <tr> 
                                <td class=title width="40">연번</td>
                                <td class=title width='150'>공휴일자</td>
                                <td class=title width='150'>공휴일명</td>
                                <td class=title width='80'>수정</td>
                                <td class=title width='80'>삭제</td>
                            </tr>
                        <%if(hol_size > 0){
        					for(i =0; i < hol_size ; i++){
        						Hashtable hol = (Hashtable)hols.elementAt(i);%>
                            <tr> 
                                <td align="center" width="40"><%=i+1%><input type="hidden" name="seq" value="<%=hol.get("SEQ")%>"></td>
                                <td align="center" width="150"><input type="text" name="hday" value="<%=hol.get("HDAY")%>" size='15' class='text'></td>
                                <td align="center" width="150"><input type="text" name="hday_nm" value="<%=hol.get("HDAY_NM")%>" size='15' class='text'></td>
                                <td align="center" width="80"><a href="javascript:parent.Holiday_modify('수정', '<%=i%>');"><img src=../images/center/button_in_modify.gif border=0 align=absmiddle></a></td>
                                <td align="center" width="80"><a href="javascript:parent.Holiday_modify('삭제', '<%=i%>');"><img src=../images/center/button_in_delete.gif border=0></a></td>
                            </tr>
                        <%	}%>
                            <tr> 
                                <td align="center" width="40"><%=i+1%><input type="hidden" name="seq" value=""></td>
                                <td align="center" width="150"><input type="text" name="hday" value="" size='15' class='text' onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                                <td align="center" width="150"><input type="text" name="hday_nm" value="" size='15' class='text'></td>
                                <td align="center" width="80"><a href="javascript:parent.Holiday_modify('등록', '<%=i%>');"><img src=../images/center/button_in_reg.gif border=0></a></td>
                                <td align="center" width="80">-</td>
                            </tr>				
        				<%}else{%>
                            <tr align="center"> 
                                <td colspan="5">등록된 자료가 없습니다.</td>
                            </tr>
                        <%}%>
                        </table>
        		    </td>
    		    </tr>
	        </table>
	    </td>
    </tr>	
</table>
</form>
</body>
</html>