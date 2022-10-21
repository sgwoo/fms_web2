<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.insur.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String s_yy = request.getParameter("s_yy")==null?AddUtil.getDate(1):request.getParameter("s_yy");
	String s_mm = request.getParameter("s_mm")==null?AddUtil.getDate(2):request.getParameter("s_mm");
	
	InsComDatabase ic_db = InsComDatabase.getInstance();
	
	Vector vt = ic_db.getinsRatioList(gubun1, s_yy, s_mm);
	int vt_size = vt.size();
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
function Upd_ratio(save_dt)
{
	var fm = document.form1;
	fm.save_dt.value = save_dt;
	window.open("about:blank", "MK", "left=250, top=50, width=500, height=300, scrollbars=yes, status=yes");				
	fm.action = "ins_ratio_i.jsp";
	fm.target = "MK";
	fm.submit();				
}		
</script>
<script language='javascript'>
<!--
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form action="" name="form1" method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='s_yy' value='<%=s_yy%>'>
<input type='hidden' name='s_mm' value='<%=s_mm%>'>
<input type='hidden' name='save_dt' value=''>
<table border="0" cellspacing="0" cellpadding="0" width=1200>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
	    <td class=line> 
	        <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr align="center"> 
                    <td class=title rowspan="2" width="100" >구분</td>
                    <td class=title colspan="3">손해율</td>
                    <td class=title colspan="3">* 분담금할증한정 특약 제외, 1억초과손해액/무과실사고 제외</td>
                    <td class=title colspan="3">사고율</td>
                </tr>
                <tr align="center"> 
                    <td class=title width="150">경과분담금</td>
                    <td class=title width="150">손해액</td>
                    <td class=title width="100">손해율</td>
                    <td class=title width="150">경과분담금</td>
                    <td class=title width="150">손해액</td>
                    <td class=title width="100">손해율</td>
                    <td class=title width="100">유효대수</td>
                    <td class=title width="100">사고건수</td>
                    <td class=title width="100">사고율</td>                                                         
                </tr>
                <%		
           	    				for (int j = 0 ; j < vt_size ; j++){
    								Hashtable ht = (Hashtable)vt.elementAt(j);  
    								
    								String td_class = "";
    								
    								if(String.valueOf(ht.get("SAVE_DT")).equals("소계")||String.valueOf(ht.get("SAVE_DT")).equals("총합계")){ 
    									td_class = "class=star";
    								}
    								
           	    %>
               <tr> 
                    <td <%=td_class%> align="center"><a href="javascript:Upd_ratio('<%=ht.get("SAVE_DT")%>');"><%=ht.get("SAVE_DT")%></a></td>
                    <td <%=td_class%> align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT1")))%></td>
                    <td <%=td_class%> align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT2")))%></td>
                    <td <%=td_class%> align="right"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(ht.get("RATIO1"))),1)%></font></a></td>                                        	               
                    <td <%=td_class%> align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT3")))%></td>
                    <td <%=td_class%> align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT4")))%></td>
                    <td <%=td_class%> align="right"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(ht.get("RATIO3"))),1)%></font></a></td>
                    <td <%=td_class%> align="right"><%=ht.get("CNT1")%></font></a></td>
                    <td <%=td_class%> align="right"><%=ht.get("CNT2")%></font></a></td>
                    <td <%=td_class%> align="right"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(ht.get("RATIO2"))),1)%></font></a></td>                    
                </tr>
                <%				
	            				}	                		
                %>                        
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
