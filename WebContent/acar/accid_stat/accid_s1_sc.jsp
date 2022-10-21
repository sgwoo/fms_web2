<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.account.*, acar.accid.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function AccidentDisp(year, month){
		var fm = document.form1;
		fm.s_st.value = '1';
		if(year == <%=AddUtil.getDate(1)%>){
			if(month != ''){
				fm.gubun2.value = '3';
				fm.st_dt.value = toInt(month);
			}else{
				fm.gubun2.value = '4';
			}		
		}else{
			fm.gubun2.value = '5';
			if(month != ''){
				fm.st_dt.value = year+'-'+month+'-'+'01';
				fm.end_dt.value = year+'-'+month+'-'+getMonthDateCnt(year, month);
			}else{
				fm.st_dt.value = year+'-'+'01-01';
				fm.end_dt.value = year+'-'+'12-31';		
			}
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
	int st_dt = request.getParameter("st_dt")==null?0:AddUtil.parseInt(request.getParameter("st_dt"));
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"3":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"4":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"desc":request.getParameter("asc");
	String s_st = request.getParameter("s_st")==null?"1":request.getParameter("s_st");
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");	
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");	
	int size = 0;
	
	AccidDatabase as_db = AccidDatabase.getInstance();
%>
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
<input type='hidden' name='m_id' value=''>
<input type='hidden' name='l_cd' value=''>
<input type='hidden' name='c_id' value=''>
<input type='hidden' name='accid_id' value=''>
<input type='hidden' name='accid_st' value=''>
<input type='hidden' name='cmd' value=''>
<input type='hidden' name='go_url' value='../accid_stat/accid_s1_frame.jsp'>
<table border="0" cellspacing="0" cellpadding="0" width=100%%>
<%	if(st_dt > 0){
		for(int i=st_dt; i>=st_dt-1; i--){
			String su[] = as_db.getAccidStat1List(br_id, gubun1, gubun2, gubun3, gubun4, gubun5, gubun6, brch_id, i+"0101", i+"1231", s_kd, t_wd, sort, asc, s_st);%>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td class='title' rowspan="5"><a href="javascript:AccidentDisp('<%=i%>', '')"><font size="3"><b><%=i%>년</b></a></td>
                    <td class='title'>월별</td>
                    <td class='title'>전월</td>
                    <td class='title'><a href="javascript:AccidentDisp('<%=i%>', '01')">1월</a></td>
                    <td class='title'><a href="javascript:AccidentDisp('<%=i%>', '02')"">2월</a></td>
                    <td class='title'><a href="javascript:AccidentDisp('<%=i%>', '03')"">3월</a></td>
                    <td class='title'><a href="javascript:AccidentDisp('<%=i%>', '04')"">4월</a></td>
                    <td class='title'><a href="javascript:AccidentDisp('<%=i%>', '05')"">5월</a></td>
                    <td class='title'><a href="javascript:AccidentDisp('<%=i%>', '06')"">6월</a></td>
                    <td class='title'><a href="javascript:AccidentDisp('<%=i%>', '07')"">7월</a></td>
                    <td class='title'><a href="javascript:AccidentDisp('<%=i%>', '08')"">8월</a></td>
                    <td class='title'><a href="javascript:AccidentDisp('<%=i%>', '09')"">9월</a></td>
                    <td class='title'><a href="javascript:AccidentDisp('<%=i%>', '10')"">10월</a></td>
                    <td class='title'><a href="javascript:AccidentDisp('<%=i%>', '11')"">11월</a></td>
                    <td class='title'><a href="javascript:AccidentDisp('<%=i%>', '12')"">12월</a></td>
                    <td class='title'><a href="javascript:AccidentDisp('<%=i%>', '')"">합계</a></td>
                </tr>
                <tr> 
                    <td class='title'>건수</td>
                    <td class='is' align="center"> 
                      <input type="text" name="su0" value="<%=su[0]==null?"0":su[0]%>" size="2" class=whitenum>
                      건 </td>
                    <td align="center"> 
                      <input type="text" name="su1" value="<%=su[1]==null?"0":su[1]%>" size="2" class=whitenum>
                      건 </td>
                    <td align="center"> 
                      <input type="text" name="su2" value="<%=su[2]==null?"0":su[2]%>" size="2" class=whitenum>
                      건 </td>
                    <td align="center"> 
                      <input type="text" name="su3" value="<%=su[3]==null?"0":su[3]%>" size="2" class=whitenum>
                      건 </td>
                    <td align="center"> 
                      <input type="text" name="su4" value="<%=su[4]==null?"0":su[4]%>" size="2" class=whitenum>
                      건 </td>
                    <td align="center"> 
                      <input type="text" name="su5" value="<%=su[5]==null?"0":su[5]%>" size="2" class=whitenum>
                      건 </td>
                    <td align="center"> 
                      <input type="text" name="su6" value="<%=su[6]==null?"0":su[6]%>" size="2" class=whitenum>
                      건 </td>
                    <td align="center"> 
                      <input type="text" name="su7" value="<%=su[7]==null?"0":su[7]%>" size="2" class=whitenum>
                      건 </td>
                    <td align="center"> 
                      <input type="text" name="su8" value="<%=su[8]==null?"0":su[8]%>" size="2" class=whitenum>
                      건 </td>
                    <td align="center"> 
                      <input type="text" name="su9" value="<%=su[9]==null?"0":su[9]%>" size="2" class=whitenum>
                      건 </td>
                    <td align="center"> 
                      <input type="text" name="su10" value="<%=su[10]==null?"0":su[10]%>" size="2" class=whitenum>
                      건 </td>
                    <td align="center"> 
                      <input type="text" name="su11" value="<%=su[11]==null?"0":su[11]%>" size="2" class=whitenum>
                      건 </td>
                    <td align="center"> 
                      <input type="text" name="su12" value="<%=su[12]==null?"0":su[12]%>" size="2" class=whitenum>
                      건 </td>
                    <td align="center"> 
                      <input type="text" name="tot_su" value="" size="3" class=whitenum>
                      건 </td>
                </tr>
                <tr> 
                    <td class='title'>구성비</td>
                    <td class='is' align="center"> -</td>
                    <td align="center"> 
                      <input type="text" name="per1" value="0.0" size="4" class=whitenum>
                      % </td>
                    <td align="center"> 
                      <input type="text" name="per2" value="0.0" size="4" class=whitenum>
                      %</td>
                    <td align="center"> 
                      <input type="text" name="per3" value="0.0" size="4" class=whitenum>
                      %</td>
                    <td align="center"> 
                      <input type="text" name="per4" value="0.0" size="4" class=whitenum>
                      %</td>
                    <td align="center"> 
                      <input type="text" name="per5" value="0.0" size="4" class=whitenum>
                      %</td>
                    <td align="center"> 
                      <input type="text" name="per6" value="0.0" size="4" class=whitenum>
                      %</td>
                    <td align="center"> 
                      <input type="text" name="per7" value="0.0" size="4" class=whitenum>
                      %</td>
                    <td align="center"> 
                      <input type="text" name="per8" value="0.0" size="4" class=whitenum>
                      %</td>
                    <td align="center"> 
                      <input type="text" name="per9" value="0.0" size="4" class=whitenum>
                      %</td>
                    <td align="center"> 
                      <input type="text" name="per10" value="0.0" size="4" class=whitenum>
                      %</td>
                    <td align="center"> 
                      <input type="text" name="per11" value="0.0" size="4" class=whitenum>
                      %</td>
                    <td align="center"> 
                      <input type="text" name="per12" value="0.0" size="4" class=whitenum>
                      %</td>
                    <td align="center"> 
                      <input type="text" name="tot_per" value="100" size="3" class=whitenum>
                      %</td>
                </tr>
                <tr> 
                    <td class='title'>전년대비</td>
                    <td class='is' align="center">-</td>
                    <td align="center"> 
                      <input type="text" name="y_per1" value="0.0" size="4" class=whitenum>
                      %</td>
                    <td align="center"> 
                      <input type="text" name="y_per2" value="0.0" size="4" class=whitenum>
                      %</td>
                    <td align="center"> 
                      <input type="text" name="y_per3" value="0.0" size="4" class=whitenum>
                      %</td>
                    <td align="center"> 
                      <input type="text" name="y_per4" value="0.0" size="4" class=whitenum>
                      %</td>
                    <td align="center"> 
                      <input type="text" name="y_per5" value="0.0" size="4" class=whitenum>
                      %</td>
                    <td align="center"> 
                      <input type="text" name="y_per6" value="0.0" size="4" class=whitenum>
                      %</td>
                    <td align="center"> 
                      <input type="text" name="y_per7" value="0.0" size="4" class=whitenum>
                      %</td>
                    <td align="center"> 
                      <input type="text" name="y_per8" value="0.0" size="4" class=whitenum>
                      %</td>
                    <td align="center"> 
                      <input type="text" name="y_per9" value="0.0" size="4" class=whitenum>
                      %</td>
                    <td align="center"> 
                      <input type="text" name="y_per10" value="0.0" size="4" class=whitenum>
                      %</td>
                    <td align="center"> 
                      <input type="text" name="y_per11" value="0.0" size="4" class=whitenum>
                      %</td>
                    <td align="center"> 
                      <input type="text" name="y_per12" value="0.0" size="4" class=whitenum>
                      %</td>
                    <td align="center"> 
                      <input type="text" name="tot_y_per" value="0.0" size="4" class=whitenum>
                      %</td>
                </tr>
                <tr> 
                    <td class='title'>전월대비</td>
                    <td class='is' align="center">-</td>
                    <td align="center"> 
                      <input type="text" name="m_per1" value="0.0" size="4" class=whitenum>
                      %</td>
                    <td align="center"> 
                      <input type="text" name="m_per2" value="0.0" size="4" class=whitenum>
                      %</td>
                    <td align="center"> 
                      <input type="text" name="m_per3" value="0.0" size="4" class=whitenum>
                      %</td>
                    <td align="center"> 
                      <input type="text" name="m_per4" value="0.0" size="4" class=whitenum>
                      %</td>
                    <td align="center"> 
                      <input type="text" name="m_per5" value="0.0" size="4" class=whitenum>
                      %</td>
                    <td align="center"> 
                      <input type="text" name="m_per6" value="0.0" size="4" class=whitenum>
                      %</td>
                    <td align="center"> 
                      <input type="text" name="m_per7" value="0.0" size="4" class=whitenum>
                      %</td>
                    <td align="center"> 
                      <input type="text" name="m_per8" value="0.0" size="4" class=whitenum>
                      %</td>
                    <td align="center"> 
                      <input type="text" name="m_per9" value="0.0" size="4" class=whitenum>
                      %</td>
                    <td align="center"> 
                      <input type="text" name="m_per10" value="0.0" size="4" class=whitenum>
                      %</td>
                    <td align="center"> 
                      <input type="text" name="m_per11" value="0.0" size="4" class=whitenum>
                      %</td>
                    <td align="center"> 
                      <input type="text" name="m_per12" value="0.0" size="4" class=whitenum>
                      %</td>
                    <td align="center"> -</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <tr> 
        <td><%if(i==st_dt){%><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>전년도</span><%}%></td>
    </tr>	
	<% size++;
		}
	}else{
		for(int i=AddUtil.getDate2(1); i>=2000; i--){
			String su[] = as_db.getAccidStat1List(br_id, gubun1, gubun2, gubun3, gubun4, gubun5, gubun6, brch_id, i+"0101", i+"1231", s_kd, t_wd, sort, asc, s_st);%>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td class='title' rowspan="5"><font size="3"><b><%=i%>년</b></td>
                    <td class='title'>월별</td>
                    <td class='title'>전월</td>
                    <td class='title'><a href="javascript:AccidentDisp('<%=i%>', '01')">1월</a></td>
                    <td class='title'><a href="javascript:AccidentDisp('<%=i%>', '02')"">2월</a></td>
                    <td class='title'><a href="javascript:AccidentDisp('<%=i%>', '03')"">3월</a></td>
                    <td class='title'><a href="javascript:AccidentDisp('<%=i%>', '04')"">4월</a></td>
                    <td class='title'><a href="javascript:AccidentDisp('<%=i%>', '05')"">5월</a></td>
                    <td class='title'><a href="javascript:AccidentDisp('<%=i%>', '06')"">6월</a></td>
                    <td class='title'><a href="javascript:AccidentDisp('<%=i%>', '07')"">7월</a></td>
                    <td class='title'><a href="javascript:AccidentDisp('<%=i%>', '08')"">8월</a></td>
                    <td class='title'><a href="javascript:AccidentDisp('<%=i%>', '09')"">9월</a></td>
                    <td class='title'><a href="javascript:AccidentDisp('<%=i%>', '10')"">10월</a></td>
                    <td class='title'><a href="javascript:AccidentDisp('<%=i%>', '11')"">11월</a></td>
                    <td class='title'><a href="javascript:AccidentDisp('<%=i%>', '12')"">12월</a></td>
                    <td class='title'><a href="javascript:AccidentDisp('<%=i%>', '')"">합계</a></td>
                </tr>
                <tr> 
                    <td class='title'>건수</td>
                    <td class='is' align="center"> 
                      <input type="text" name="su0" value="<%=su[0]==null?"0":su[0]%>" size="2" class=whitenum>
                      건 </td>
                    <td align="center"> 
                      <input type="text" name="su1" value="<%=su[1]==null?"0":su[1]%>" size="2" class=whitenum>
                      건 </td>
                    <td align="center"> 
                      <input type="text" name="su2" value="<%=su[2]==null?"0":su[2]%>" size="2" class=whitenum>
                      건 </td>
                    <td align="center"> 
                      <input type="text" name="su3" value="<%=su[3]==null?"0":su[3]%>" size="2" class=whitenum>
                      건 </td>
                    <td align="center"> 
                      <input type="text" name="su4" value="<%=su[4]==null?"0":su[4]%>" size="2" class=whitenum>
                      건 </td>
                    <td align="center"> 
                      <input type="text" name="su5" value="<%=su[5]==null?"0":su[5]%>" size="2" class=whitenum>
                      건 </td>
                    <td align="center"> 
                      <input type="text" name="su6" value="<%=su[6]==null?"0":su[6]%>" size="2" class=whitenum>
                      건 </td>
                    <td align="center"> 
                      <input type="text" name="su7" value="<%=su[7]==null?"0":su[7]%>" size="2" class=whitenum>
                      건 </td>
                    <td align="center"> 
                      <input type="text" name="su8" value="<%=su[8]==null?"0":su[8]%>" size="2" class=whitenum>
                      건 </td>
                    <td align="center"> 
                      <input type="text" name="su9" value="<%=su[9]==null?"0":su[9]%>" size="2" class=whitenum>
                      건 </td>
                    <td align="center"> 
                      <input type="text" name="su10" value="<%=su[10]==null?"0":su[10]%>" size="2" class=whitenum>
                      건 </td>
                    <td align="center"> 
                      <input type="text" name="su11" value="<%=su[11]==null?"0":su[11]%>" size="2" class=whitenum>
                      건 </td>
                    <td align="center"> 
                      <input type="text" name="su12" value="<%=su[12]==null?"0":su[12]%>" size="2" class=whitenum>
                      건 </td>
                    <td align="center"> 
                      <input type="text" name="tot_su" value="" size="3" class=whitenum>
                      건 </td>
                </tr>
                <tr> 
                    <td class='title'>구성비</td>
                    <td class='is' align="center"> -</td>
                    <td align="center"> 
                      <input type="text" name="per1" value="0.0" size="4" class=whitenum>
                      % </td>
                    <td align="center"> 
                      <input type="text" name="per2" value="0.0" size="4" class=whitenum>
                      %</td>
                    <td align="center"> 
                      <input type="text" name="per3" value="0.0" size="4" class=whitenum>
                      %</td>
                    <td align="center"> 
                      <input type="text" name="per4" value="0.0" size="4" class=whitenum>
                      %</td>
                    <td align="center"> 
                      <input type="text" name="per5" value="0.0" size="4" class=whitenum>
                      %</td>
                    <td align="center"> 
                      <input type="text" name="per6" value="0.0" size="4" class=whitenum>
                      %</td>
                    <td align="center"> 
                      <input type="text" name="per7" value="0.0" size="4" class=whitenum>
                      %</td>
                    <td align="center"> 
                      <input type="text" name="per8" value="0.0" size="4" class=whitenum>
                      %</td>
                    <td align="center"> 
                      <input type="text" name="per9" value="0.0" size="4" class=whitenum>
                      %</td>
                    <td align="center"> 
                      <input type="text" name="per10" value="0.0" size="4" class=whitenum>
                      %</td>
                    <td align="center"> 
                      <input type="text" name="per11" value="0.0" size="4" class=whitenum>
                      %</td>
                    <td align="center"> 
                      <input type="text" name="per12" value="0.0" size="4" class=whitenum>
                      %</td>
                    <td align="center"> 
                      <input type="text" name="tot_per" value="100" size="3" class=whitenum>
                      %</td>
                </tr>
                <tr> 
                    <td class='title'>전년대비</td>
                    <td class='is' align="center">-</td>
                    <td align="center"> 
                      <input type="text" name="y_per1" value="0.0" size="4" class=whitenum>
                      %</td>
                    <td align="center"> 
                      <input type="text" name="y_per2" value="0.0" size="4" class=whitenum>
                      %</td>
                    <td align="center"> 
                      <input type="text" name="y_per3" value="0.0" size="4" class=whitenum>
                      %</td>
                    <td align="center"> 
                      <input type="text" name="y_per4" value="0.0" size="4" class=whitenum>
                      %</td>
                    <td align="center"> 
                      <input type="text" name="y_per5" value="0.0" size="4" class=whitenum>
                      %</td>
                    <td align="center"> 
                      <input type="text" name="y_per6" value="0.0" size="4" class=whitenum>
                      %</td>
                    <td align="center"> 
                      <input type="text" name="y_per7" value="0.0" size="4" class=whitenum>
                      %</td>
                    <td align="center"> 
                      <input type="text" name="y_per8" value="0.0" size="4" class=whitenum>
                      %</td>
                    <td align="center"> 
                      <input type="text" name="y_per9" value="0.0" size="4" class=whitenum>
                      %</td>
                    <td align="center"> 
                      <input type="text" name="y_per10" value="0.0" size="4" class=whitenum>
                      %</td>
                    <td align="center"> 
                      <input type="text" name="y_per11" value="0.0" size="4" class=whitenum>
                      %</td>
                    <td align="center"> 
                      <input type="text" name="y_per12" value="0.0" size="4" class=whitenum>
                      %</td>
                    <td align="center"> 
                      <input type="text" name="tot_y_per" value="0.0" size="4" class=whitenum>
                      %</td>
                </tr>
                <tr> 
                    <td class='title'>전월대비</td>
                    <td class='is' align="center">-</td>
                    <td align="center"> 
                      <input type="text" name="m_per1" value="0.0" size="4" class=whitenum>
                      %</td>
                    <td align="center"> 
                      <input type="text" name="m_per2" value="0.0" size="4" class=whitenum>
                      %</td>
                    <td align="center"> 
                      <input type="text" name="m_per3" value="0.0" size="4" class=whitenum>
                      %</td>
                    <td align="center"> 
                      <input type="text" name="m_per4" value="0.0" size="4" class=whitenum>
                      %</td>
                    <td align="center"> 
                      <input type="text" name="m_per5" value="0.0" size="4" class=whitenum>
                      %</td>
                    <td align="center"> 
                      <input type="text" name="m_per6" value="0.0" size="4" class=whitenum>
                      %</td>
                    <td align="center"> 
                      <input type="text" name="m_per7" value="0.0" size="4" class=whitenum>
                      %</td>
                    <td align="center"> 
                      <input type="text" name="m_per8" value="0.0" size="4" class=whitenum>
                      %</td>
                    <td align="center"> 
                      <input type="text" name="m_per9" value="0.0" size="4" class=whitenum>
                      %</td>
                    <td align="center"> 
                      <input type="text" name="m_per10" value="0.0" size="4" class=whitenum>
                      %</td>
                    <td align="center"> 
                      <input type="text" name="m_per11" value="0.0" size="4" class=whitenum>
                      %</td>
                    <td align="center"> 
                      <input type="text" name="m_per12" value="0.0" size="4" class=whitenum>
                      %</td>
                    <td align="center"> -</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td></td>
    </tr>		
<%		size++;
		}
	}%>
</table>
<input type='hidden' name='size' value='<%=size%>'>
</form>
<script language='javascript'>
<!--
	var fm = document.form1;
	var size = toInt(fm.size.value);
	//합계계산 
	for(i=0; i<size; i++){
		fm.tot_su[i].value = toInt(fm.su1[i].value)+toInt(fm.su2[i].value)+toInt(fm.su3[i].value)+toInt(fm.su4[i].value)+toInt(fm.su5[i].value)+toInt(fm.su6[i].value)+toInt(fm.su7[i].value)+toInt(fm.su8[i].value)+toInt(fm.su9[i].value)+toInt(fm.su10[i].value)+toInt(fm.su11[i].value)+toInt(fm.su12[i].value);
		if(fm.tot_su[i].value > 0){
			//구성비
			fm.per1[i].value = parseFloatCipher3(toInt(fm.su1[i].value) / fm.tot_su[i].value * 100, 1);
			fm.per2[i].value = parseFloatCipher3(toInt(fm.su2[i].value) / fm.tot_su[i].value * 100, 1);
			fm.per3[i].value = parseFloatCipher3(toInt(fm.su3[i].value) / fm.tot_su[i].value * 100, 1);
			fm.per4[i].value = parseFloatCipher3(toInt(fm.su4[i].value) / fm.tot_su[i].value * 100, 1);
			fm.per5[i].value = parseFloatCipher3(toInt(fm.su5[i].value) / fm.tot_su[i].value * 100, 1);
			fm.per6[i].value = parseFloatCipher3(toInt(fm.su6[i].value) / fm.tot_su[i].value * 100, 1);
			fm.per7[i].value = parseFloatCipher3(toInt(fm.su7[i].value) / fm.tot_su[i].value * 100, 1);
			fm.per8[i].value = parseFloatCipher3(toInt(fm.su8[i].value) / fm.tot_su[i].value * 100, 1);
			fm.per9[i].value = parseFloatCipher3(toInt(fm.su9[i].value) / fm.tot_su[i].value * 100, 1);																								
			fm.per10[i].value = parseFloatCipher3(toInt(fm.su10[i].value) / fm.tot_su[i].value * 100, 1);
			fm.per11[i].value = parseFloatCipher3(toInt(fm.su11[i].value) / fm.tot_su[i].value * 100, 1);
			fm.per12[i].value = parseFloatCipher3(toInt(fm.su12[i].value) / fm.tot_su[i].value * 100, 1);
			//전월대비
			if(toInt(fm.su1[i].value) > 0 && toInt(fm.su0[i].value) > 0) fm.m_per1[i].value = Math.round(toInt(fm.su1[i].value) / fm.su0[i].value * 100);
			if(toInt(fm.su2[i].value) > 0 && toInt(fm.su1[i].value) > 0) fm.m_per2[i].value = Math.round(toInt(fm.su2[i].value) / fm.su1[i].value * 100);
			if(toInt(fm.su3[i].value) > 0 && toInt(fm.su2[i].value) > 0) fm.m_per3[i].value = Math.round(toInt(fm.su3[i].value) / fm.su2[i].value * 100);
			if(toInt(fm.su4[i].value) > 0 && toInt(fm.su3[i].value) > 0) fm.m_per4[i].value = Math.round(toInt(fm.su4[i].value) / fm.su3[i].value * 100);
			if(toInt(fm.su5[i].value) > 0 && toInt(fm.su4[i].value) > 0) fm.m_per5[i].value = Math.round(toInt(fm.su5[i].value) / fm.su4[i].value * 100);
			if(toInt(fm.su6[i].value) > 0 && toInt(fm.su5[i].value) > 0) fm.m_per6[i].value = Math.round(toInt(fm.su6[i].value) / fm.su5[i].value * 100);
			if(toInt(fm.su7[i].value) > 0 && toInt(fm.su6[i].value) > 0) fm.m_per7[i].value = Math.round(toInt(fm.su7[i].value) / fm.su6[i].value * 100);
			if(toInt(fm.su8[i].value) > 0 && toInt(fm.su7[i].value) > 0) fm.m_per8[i].value = Math.round(toInt(fm.su8[i].value) / fm.su7[i].value * 100);
			if(toInt(fm.su9[i].value) > 0 && toInt(fm.su8[i].value) > 0) fm.m_per9[i].value = Math.round(toInt(fm.su9[i].value) / fm.su8[i].value * 100);
			if(toInt(fm.su10[i].value) > 0 && toInt(fm.su9[i].value) > 0) fm.m_per10[i].value = Math.round(toInt(fm.su10[i].value) / fm.su9[i].value * 100);
			if(toInt(fm.su11[i].value) > 0 && toInt(fm.su10[i].value) > 0) fm.m_per11[i].value = Math.round(toInt(fm.su11[i].value) / fm.su10[i].value * 100);
			if(toInt(fm.su12[i].value) > 0 && toInt(fm.su11[i].value) > 0) fm.m_per12[i].value = Math.round(toInt(fm.su12[i].value) / fm.su11[i].value * 100);			
																					
		}
	}
	//전년대비
	for(i=0; i<size-1; i++){	
		if(toInt(fm.su1[i].value) > 0 && toInt(fm.su1[i+1].value) > 0) fm.y_per1[i].value = Math.round(fm.su1[i].value / fm.su1[i+1].value * 100);
		if(toInt(fm.su2[i].value) > 0 && toInt(fm.su2[i+1].value) > 0) fm.y_per2[i].value = Math.round(fm.su2[i].value / fm.su2[i+1].value * 100);
		if(toInt(fm.su3[i].value) > 0 && toInt(fm.su3[i+1].value) > 0) fm.y_per3[i].value = Math.round(fm.su3[i].value / fm.su3[i+1].value * 100);
		if(toInt(fm.su4[i].value) > 0 && toInt(fm.su4[i+1].value) > 0) fm.y_per4[i].value = Math.round(fm.su4[i].value / fm.su4[i+1].value * 100);
		if(toInt(fm.su5[i].value) > 0 && toInt(fm.su5[i+1].value) > 0) fm.y_per5[i].value = Math.round(fm.su5[i].value / fm.su5[i+1].value * 100);
		if(toInt(fm.su6[i].value) > 0 && toInt(fm.su6[i+1].value) > 0) fm.y_per6[i].value = Math.round(fm.su6[i].value / fm.su6[i+1].value * 100);
		if(toInt(fm.su7[i].value) > 0 && toInt(fm.su7[i+1].value) > 0) fm.y_per7[i].value = Math.round(fm.su7[i].value / fm.su7[i+1].value * 100);
		if(toInt(fm.su8[i].value) > 0 && toInt(fm.su8[i+1].value) > 0) fm.y_per8[i].value = Math.round(fm.su8[i].value / fm.su8[i+1].value * 100);
		if(toInt(fm.su9[i].value) > 0 && toInt(fm.su9[i+1].value) > 0) fm.y_per9[i].value = Math.round(fm.su9[i].value / fm.su9[i+1].value * 100);
		if(toInt(fm.su10[i].value) > 0 && toInt(fm.su10[i+1].value) > 0) fm.y_per10[i].value = Math.round(fm.su10[i].value / fm.su10[i+1].value * 100);
		if(toInt(fm.su11[i].value) > 0 && toInt(fm.su11[i+1].value) > 0) fm.y_per11[i].value = Math.round(fm.su11[i].value / fm.su11[i+1].value * 100);
		if(toInt(fm.su12[i].value) > 0 && toInt(fm.su12[i+1].value) > 0) fm.y_per12[i].value = Math.round(fm.su12[i].value / fm.su12[i+1].value * 100);
		if(toInt(fm.tot_su[i].value) > 0 && toInt(fm.tot_su[i+1].value) > 0) fm.tot_y_per[i].value = Math.round(fm.tot_su[i].value / fm.tot_su[i+1].value * 100);		
	}

//-->
</script>
</body>
</html>
