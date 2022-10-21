<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.admin.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function view_stat_debt(save_dt){
		var fm = document.form1;	
		if(save_dt == ''){
			parent.document.form1.view_dt.value = fm.today.value;		
			parent.document.form1.save_dt.value = '';								
			fm.save_dt.value = '';		
		}else{
			parent.document.form1.view_dt.value = save_dt;
			parent.document.form1.save_dt.value = ChangeDate_nb(save_dt);				
			fm.save_dt.value = ChangeDate_nb(save_dt);					
		}
				
		fm.target='i_view_g';
		fm.action='stat_settle_sc_in_view_g.jsp';		
		fm.submit();		
		
		fm.target='i_view_l';
		fm.action='stat_settle_sc_in_view_l.jsp';		
		fm.submit();				
	}
//-->
</script>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String dept_id = request.getParameter("dept_id")==null?"0001":request.getParameter("dept_id");	
	String bus_id2 = request.getParameter("bus_id2")==null?"":request.getParameter("bus_id2");
	
	String save_dt = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	String tot_dly_amt = request.getParameter("tot_dly_amt")==null?"0":request.getParameter("tot_dly_amt");
	String tot_dly_per = request.getParameter("tot_dly_per")==null?"0":request.getParameter("tot_dly_per");
	
	
	//부채현황
	Vector deb1s = ad_db.getStatDebtList("stat_settle");
	int deb1_size = deb1s.size();
%>
<form name='form1' action='stat_settle_sc_in_view_g.jsp' target='i_view_g'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='dept_id' value='<%=dept_id%>'>
<input type='hidden' name='bus_id2' value='<%=bus_id2%>'>
<input type='hidden' name='save_dt' value='<%=save_dt%>'>
<input type='hidden' name='tot_dly_amt' value='<%=tot_dly_amt%>'>
<input type='hidden' name='tot_dly_per' value='<%=tot_dly_per%>'>
<input type='hidden' name='today' value='<%=AddUtil.getDate()%>'>

<table border="0" width="<%=deb1_size*80+80%>" cellspacing="0" cellpadding="0">
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
		<td class='line'>			
            <table border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td class="title" width='80' >마감일자</td>
                  <%if(deb1_size > 0){
        				for(int i = 0 ; i < deb1_size ; i++){
        					StatDebtBean sd = (StatDebtBean)deb1s.elementAt(i);%>			
                    <td width='80' align='center'><a href="javascript:view_stat_debt('<%=sd.getSave_dt()%>');"><%=sd.getSave_dt()%></a></td>
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
