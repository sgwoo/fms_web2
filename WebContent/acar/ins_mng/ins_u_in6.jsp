<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.accid.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");//권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//사용자 관리번호
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//사용자 소속영업소
	
	String gubun0 = request.getParameter("gubun0")==null?"":request.getParameter("gubun0");
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");	
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");	
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");	
	String gubun7 = request.getParameter("gubun7")==null?"":request.getParameter("gubun7");		
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"1":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");	
	String s_st = request.getParameter("s_st")==null?"1":request.getParameter("s_st");
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");	
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");//계약관리번호
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");//계약번호
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");//자동차관리번호
	String accid_id = request.getParameter("accid_id")==null?"":request.getParameter("accid_id");//사고관리번호
	String mode = request.getParameter("mode")==null?"12":request.getParameter("mode");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	String update_yn = request.getParameter("update_yn")==null?"":request.getParameter("update_yn");
	
	
	AccidDatabase as_db = AccidDatabase.getInstance();
	
	
	Vector accids = as_db.getCarAccidInsList(c_id);
	int accid_size = accids.size();
	

%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	function AccidentDisp(m_id, l_cd, c_id, accid_id, accid_st){
		var fm = document.form1;
		fm.accid_id.value = accid_id;		
		fm.accid_st.value = accid_st;				
		fm.mode.value = "1";
		fm.cmd.value = "u";		
		fm.submit();
	}
//-->
</script>
</head>
<body>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
  <form name='form1' action='../accid_mng/accid_u_frame.jsp' method='post' target='d_content'>
    <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
    <input type='hidden' name='user_id' value='<%=user_id%>'>
    <input type='hidden' name='br_id' value='<%=br_id%>'>
	<input type='hidden' name='gubun0' value='<%=gubun0%>'>
	<input type='hidden' name='gubun1' value='<%=gubun1%>'>
	<input type='hidden' name='gubun2' value='<%=gubun2%>'>
	<input type='hidden' name='gubun3' value='<%=gubun3%>'>
	<input type='hidden' name='gubun4' value='<%=gubun4%>'>
	<input type='hidden' name='gubun5' value='<%=gubun5%>'>
	<input type='hidden' name='gubun6' value='<%=gubun6%>'>
	<input type='hidden' name='gubun7' value='<%=gubun7%>'>
	<input type='hidden' name='brch_id' value='<%=brch_id%>'>
	<input type='hidden' name='st_dt' value='<%=st_dt%>'>
	<input type='hidden' name='end_dt' value='<%=end_dt%>'>
	<input type='hidden' name='s_kd' value='<%=s_kd%>'>
	<input type='hidden' name='t_wd' value='<%=t_wd%>'>
	<input type='hidden' name='sort' value='<%=sort%>'>
	<input type='hidden' name='asc' value='<%=asc%>'>	
	<input type="hidden" name="idx" value="<%=idx%>">
	<input type="hidden" name="s_st" value="<%=s_st%>">
	<input type='hidden' name="go_url" value='<%=go_url%>'>
    <input type='hidden' name='m_id' value='<%=m_id%>'>
    <input type='hidden' name='l_cd' value='<%=l_cd%>'>
    <input type='hidden' name='c_id' value='<%=c_id%>'>
    <input type='hidden' name='mode' value='<%=mode%>'>
    <input type='hidden' name='cmd' value='<%=cmd%>'>
    <input type='hidden' name='accid_id' value=''>
    <input type='hidden' name='accid_st' value=''>	
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>사고 리스트</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                    <td class=title rowspan="2" width=4%>연번</td>
                    <td class=title rowspan="2" width=12%>사고일시</td>
                    <td class=title rowspan="2" width=6%>사고구분</td>
                    <td class=title rowspan="2" width=6%>사고유형</td>
                    <td class=title rowspan="2" width=19%>사고장소</td>
                    <td class=title rowspan="2" width=19%>사고내용</td>
                    <td class=title rowspan="2" width=8%>휴/대차료</td>
                    <td class=title colspan="3">보상결과</td>
                    <td class=title rowspan="2" width=5%>처리</td>			
                </tr>
                <tr> 
                    <td class=title width=7%>대인</td>
                    <td class=title width=7%>대물</td>
                    <td class=title width=7%>자손</td>
                </tr>
          <% 		for (int i = 0 ; i < accid_size ; i++){
			Hashtable accid = (Hashtable)accids.elementAt(i);%>
                <tr valign="middle"> 
                    <td align="center"><%=i+1%></td>
                    <td align="center"><a href="javascript:AccidentDisp('<%=accid.get("RENT_MNG_ID")%>', '<%=accid.get("RENT_L_CD")%>', '<%=accid.get("CAR_MNG_ID")%>', '<%=accid.get("ACCID_ID")%>', '<%=accid.get("ACCID_ST")%>')" onMouseOver="window.status=''; return true"><%=AddUtil.ChangeDate3(String.valueOf(accid.get("ACCID_DT")))%></a></td>
                    <td align="center"><%=accid.get("ACCID_ST_NM")%></td>
                    <td align="center"><%=accid.get("ACCID_TYPE_NM")%></td>
                    <td align="center"><span title='<%=accid.get("ACCID_ADDR")%>'><%=Util.subData(String.valueOf(accid.get("ACCID_ADDR")), 15)%></span></td>
                    <td align="center"><span title='<%=accid.get("ACCID_CONT")%>'><%=Util.subData(String.valueOf(accid.get("ACCID_CONT")), 15)%></span></td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(accid.get("REQ_AMT")))%>원&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(accid.get("HUM_AMT")))%>원&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(accid.get("MAT_AMT")))%>원&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(accid.get("ONE_AMT")))%>원&nbsp;</td>
                    <td align="center"> 
                      <%if(String.valueOf(accid.get("SETTLE_ST")).equals("1")){%>
                      완료 
                      <%}else{%>
                      <font color="#FF6600">진행</font> 
                      <%}%>
                    </td>			
                </tr>
          <%	}%>
          <% 	if(accid_size == 0) { %>
                <tr> 
                    <td colspan=11 align=center>등록된 데이타가 없습니다.</td>
                </tr>
          <%	}%>
            </table>        
        </td>
    </tr>
</form>
</table>
</body>
</html>
