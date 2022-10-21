<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.admin.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function view_stat(save_dt){
		var fm = document.form1;	
		fm.save_dt.value = replaceString("-","",save_dt);
		fm.target='_blank';
		if(fm.loan_st[0].checked == true){ 				
			fm.action='/fms2/mis/prop_settle.jsp';		
		}else{											
			fm.action='/fms2/mis/prop_settle6.jsp';		
		}		
		fm.submit();		
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String save_dt = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	String gubun = request.getParameter("gubun")==null?"p":request.getParameter("gubun");
	
	
	//비용현황
	Vector deb1s = ad_db.getStatDebtList("stat_bus_prop","p");
	int deb1_size = deb1s.size();
%>
<form name='form1' action='' target='i_view'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='save_dt' value='<%=save_dt%>'>
<table border="0" cellspacing="0" cellpadding="0" width="<%=(deb1_size*80)+200%>">
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
		<td class='line'>			
            <table border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td class="title" width='80' >마감일자</td>
					<td class="title" width='120' >										
					  <input type='radio' name="loan_st" value='1' checked>
        				내근
        			  <input type='radio' name="loan_st" value='2'>
        				외근
					</td>
                      <%if(deb1_size > 0){
            				for(int i = 0 ; i < deb1_size ; i++){
            					StatDebtBean sd = (StatDebtBean)deb1s.elementAt(i);%>			
                        <td width='80' align='center'><a href="javascript:view_stat('<%=sd.getSave_dt()%>');"><%=sd.getSave_dt()%></a></td>
                      <%	}
            			}else{%>
			        <td align='center'>데이타가 없습니다</td>						
                    <%}%>
                </tr>		  
            </table>
		</td>
	</tr>
</table>
</form>
</body>
</html>
