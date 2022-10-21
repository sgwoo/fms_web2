<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.forfeit_mng.*"%>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	
	
	Vector fines = FineDocDb.getFineDocRegGovList(br_id);
	int fine_size = fines.size();
	
		//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
%>

<html>
<head><title>FMS</title>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//디스플레이 타입
	function cng_dt(){
		var fm = document.form1;
		if(fm.gubun2.options[fm.gubun2.selectedIndex].value == '5'){ //기간
			td_dt1.style.display 	= '';
			td_dt2.style.display 	= 'none';			
		}else{
			td_dt1.style.display 	= 'none';
			td_dt2.style.display 	= '';			
		}
	}			
	
	function search(){
		var fm = document.form1;
		if(fm.st_dt.value != ''){ fm.st_dt.value = ChangeDate3(fm.st_dt.value);	}
		if(fm.end_dt.value != ''){ fm.end_dt.value = ChangeDate3(fm.end_dt.value);	}
		if(fm.st_dt.value !='' && fm.end_dt.value==''){ fm.end_dt.value = fm.st_dt.value; }		
		fm.submit()
	}	
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
		
//-->
</script>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
<body>
<form name='form1' action='settle_doc_mng_sc.jsp' target='c_foot' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
	  <td> <font color="navy">채권관리 -> </font><font color="red">최고장발행대장</font> 
      </td>
    </tr>
    <tr>
	  <td>			
        <table border="0" cellspacing="0" cellpadding="0" width=100%>
          <tr> 
            <td width='20%'>시행일자: 
              <select name="gubun2" onChange='javascript:cng_dt()'>
                <option value="">전체</option>
                <option value="1" <%if(gubun2.equals("1"))%>selected<%%>>전전일</option>
                <option value="2" <%if(gubun2.equals("2"))%>selected<%%>>전일</option>
                <option value="3" <%if(gubun2.equals("3"))%>selected<%%>>당일</option>
                <option value="4" <%if(gubun2.equals("4"))%>selected<%%>>당월</option>
                <option value="5" <%if(gubun2.equals("5"))%>selected<%%>>기간</option>
              </select>
            </td>
            <td width="20%"> 
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td width="200" id=td_dt1 style="display:<%if(!gubun2.equals("5")){%>none<%}else{%>''<%}%>"> 
                    <input type="text" name="st_dt" size="11" value="<%=AddUtil.ChangeDate2(st_dt)%>" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
                    ~ 
                    <input type="text" name="end_dt" size="11" value="<%=AddUtil.ChangeDate2(end_dt)%>" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
                  </td>
                  <td width="200" id=td_dt2 style="display:<%if(gubun2.equals("5")){%>none<%}else{%>''<%}%>">&nbsp; 
                  </td>
                </tr>
              </table>
            </td>
            <td width="60%">&nbsp; </td>
          </tr>
          <tr> 
            <td colspan="2">검색조건: 
              <select name="s_kd">
                <option value=""  <%if(s_kd.equals("")){%> selected <%}%>>전체</option>
                <option value="1" <%if(s_kd.equals("1")){%> selected <%}%>>상호</option>
                <option value="2" <%if(s_kd.equals("2")){%> selected <%}%>>차량번호</option>
              </select>
              &nbsp;&nbsp;<input type="text" name="t_wd" size="30" value="<%=t_wd%>" class="text" onKeyDown="javasript:enter()">
            </td>
            <td><a href='javascript:search()' onMouseOver="window.status=''; return true"><img src="/images/search.gif" width="50" height="18" aligh="absmiddle" border="0"></a></td>
          </tr>
        </table>
      </td>
	</tr>
</table>
</form>
</body>
</html>
