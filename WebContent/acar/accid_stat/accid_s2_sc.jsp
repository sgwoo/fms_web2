<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"0":request.getParameter("gubun3");	
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");	
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");	
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"3":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"4":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"desc":request.getParameter("asc");
	String s_st = request.getParameter("s_st")==null?"1":request.getParameter("s_st");
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");	
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");	
%>
<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function AccidentDisp(accid_dt){
		var fm = document.form1;
		var year = accid_dt.substring(0,4);
		var month = accid_dt.substring(4,6);
		fm.s_st.value = '1';		
		if(year == '<%=AddUtil.getDate(1)%>'){
			fm.gubun2.value = '3';
			fm.st_dt.value = toInt(month);
		}else{
			fm.gubun2.value = '5';
			fm.st_dt.value = year+'-'+month+'-'+'01';
			fm.end_dt.value = year+'-'+month+'-'+getMonthDateCnt(year, month);
		}	
		fm.cmd.value = "u";		
		fm.submit();
	}
//-->
</script>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='../accid_mng/accid_s_frame.jsp' method='post' target='d_content'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='gubun5' value='<%=gubun5%>'>
<input type='hidden' name='gubun6' value='<%=gubun6%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort' value='<%=sort%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='s_st' value='<%=s_st%>'>
<input type='hidden' name='idx' value='<%=idx%>'>
<input type='hidden' name='m_id' value=''>
<input type='hidden' name='l_cd' value=''>
<input type='hidden' name='c_id' value=''>
<input type='hidden' name='accid_id' value=''>
<input type='hidden' name='accid_st' value=''>
<input type='hidden' name='cmd' value=''>
<input type='hidden' name='go_url' value='../accid_stat/accid_s2_frame.jsp'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td rowspan="2" class='title' width='10%'>월별</td>
                    <td rowspan="2" class='title' width='9%'>총건수</td>
                    <td rowspan="2" class='title' width='9%'>전월대비</td>
                    <td colspan="5" class='title'>사고구분</td>
                    <td colspan="3" class='title'>피해구분</td>
                    <td colspan="4" class='title'>유형별</td>
                </tr>
                <tr> 
                    <td width='6%' class='title'>피해</td>
                    <td width='6%' class='title'>가해</td>
                    <td width='6%' class='title'>쌍방</td>
                    <td width='6%' class='title'>단독</td>
                    <td width='6%' class='title'>수해</td>
                    <td width='6%' class='title'>인사</td>
                    <td width='6%' class='title'>대물</td>
                    <td width='6%' class='title'>병합</td>
                    <td width='6%' class='title'>차대차</td>
                    <td width='6%' class='title'>차대인</td>
                    <td width='6%' class='title'>차량단독</td>
                    <td width='6%' class='title'>차대열차</td>
                </tr>
            </table>
        </td>
        <td width=16>&nbsp;</td>
    </tr>
    <tr> 
        <td colspan="2"><iframe src="accid_s2_sc_in.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&gubun5=<%=gubun5%>&gubun6=<%=gubun6%>&brch_id=<%=brch_id%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort=<%=sort%>&asc=<%=asc%>&s_st=<%=s_st%>&go_url=<%=go_url%>#idx=<%=idx%>" name="i_no" width="100%" height="500" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe></td>
    </tr>
</table>
</form>
</body>
</html>
