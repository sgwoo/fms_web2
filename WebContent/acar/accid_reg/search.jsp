<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.accid.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");//권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//사용자 관리번호
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//사용자 소속영업소
	
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String rent_st = request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String car_no = request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");
	
	String s_gubun1 = request.getParameter("s_gubun1")==null?"":request.getParameter("s_gubun1");//사고구분
	String s_kd = request.getParameter("s_kd")==null?"2":request.getParameter("s_kd");//검색조건
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");//검색어
	
	//조회
	AccidDatabase as_db = AccidDatabase.getInstance();
	
	Vector accids = as_db.getRentList(br_id, s_gubun1, s_kd, t_wd);
	int accid_size = accids.size();
%> 

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//검색하기
	function search(){
		var fm = document.form1;	
		if(fm.t_wd.value == ''){ alert('검색어를 입력하십시오.'); fm.t_wd.focus(); return; }	
		fm.submit();
	}
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	
	//계약선택
	function Disp(m_id, l_cd, c_id){
		var fm = document.form1;
		opener.parent.c_foot.location.href = "accid_reg_sc.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&s_gubun1=<%=s_gubun1%>&m_id="+m_id+"&l_cd="+l_cd+"&c_id="+c_id+"&rent_st=<%=rent_st%>&car_no=<%=car_no%>&gubun=<%=gubun%>&go_url=<%=go_url%>";
		self.close();
	}	
//-->
</script>
</head>

<body>
<form name='form1' method='post' action='search.jsp'>
<input type='hidden' name="auth_rw" value='<%=auth_rw%>'>
<input type='hidden' name="user_id" value='<%=user_id%>'>
<input type='hidden' name="br_id" value='<%=br_id%>'>
<input type='hidden' name="s_gubun1" value='<%=s_gubun1%>'>
<input type='hidden' name="c_id" value='<%=c_id%>'>
<input type='hidden' name="rent_st" value='<%=rent_st%>'>
<input type='hidden' name="car_no" value='<%=car_no%>'>
<input type='hidden' name="gubun" value='<%=gubun%>'>
<input type='hidden' name="go_url" value='<%=go_url%>'>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td>&nbsp;&nbsp;<img src="/acar/images/center/arrow_gsjg.gif" align=absmiddle>&nbsp;
            <select name='s_kd'>
              <option value='1' <%if(s_kd.equals("1"))%>selected<%%>>상호</option>
              <option value='2' <%if(s_kd.equals("2"))%>selected<%%>>차량번호</option>
            </select>
            <input type="text" name="t_wd" value="<%=t_wd%>" size="15" class=text onKeyDown="javasript:enter()">
            &nbsp;<a href='javascript:search()' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_search.gif" align="absmiddle" border="0"></a> 
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width="6%">연번</td>
                    <td class=title width="7%">구분</td>
                    <td class=title width="16%">계약번호</td>
                    <td class=title width="23%">상호</td>
                    <td class=title width="14%">차량번호</td>
                    <td class=title width="23%">계약기간</td>
                    <td class=title width="11%">해지일자</td>
                </tr>
          <%		for (int i = 0 ; i < accid_size ; i++){
			Hashtable accid = (Hashtable)accids.elementAt(i);%>
                <tr align="center"> 
                    <td><%=i+1%></td>
                    <td> 
                      <%if(accid.get("USE_YN").equals("Y")){%>
                      대여 
                      <%}else{%>
                      해지 
                      <%}%>
                    </td>
                    <td><a href="javascript:Disp('<%=accid.get("RENT_MNG_ID")%>', '<%=accid.get("RENT_L_CD")%>', '<%=accid.get("CAR_MNG_ID")%>')" onMouseOver="window.status=''; return true"><%=accid.get("RENT_L_CD")%></a></td>
                    <td><%=accid.get("FIRM_NM")%></td>
                    <td><%=accid.get("CAR_NO")%></td>
                    <td><%=AddUtil.ChangeDate2(String.valueOf(accid.get("RENT_START_DT")))%>~<%=AddUtil.ChangeDate2(String.valueOf(accid.get("RENT_END_DT")))%></td>
                    <td><%=AddUtil.ChangeDate2(String.valueOf(accid.get("CLS_DT")))%></td>
                </tr>
          <%		}%>
            </table>
        </td>
    </tr>
    <tr> 
        <td align="right"><a href='javascript:window.close()' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_close.gif" align="absmiddle" border="0"></a></td>
    </tr>
</table>
</form>
</body>
</html>
<script language="JavaScript">
	//cng_input()
</script>