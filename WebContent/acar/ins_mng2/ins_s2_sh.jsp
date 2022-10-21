<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	function Search(s_st){
		var fm = document.form1;
		fm.s_st.value = s_st;
		if(fm.gubun2.value == '5' && fm.st_dt.value != '')							fm.st_dt.value 	= ChangeDate3(fm.st_dt.value);
		if(fm.gubun2.value == '5' && fm.end_dt.value != '')							fm.end_dt.value = ChangeDate3(fm.end_dt.value);
		if(fm.gubun2.value == '5' && fm.st_dt.value !='' && fm.end_dt.value=='')	fm.end_dt.value = getTodayBar();
		if(fm.gubun2.value == '3' && fm.s_mon.value != '')							fm.st_dt.value 	= fm.s_mon.value; 
		fm.action="ins_s2_frame.jsp";
		fm.target="d_content";		
		fm.submit();
	}
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') Search(3);
	}
	
	//디스플레이 타입(검색) - 조회기간 선택시
	function cng_input1(){
		var fm = document.form1;
		if(fm.gubun2.options[fm.gubun2.selectedIndex].value == '3'){ //월별
			td_gubun2_1.style.display	= '';
			td_gubun2_2.style.display	= 'none';
		}else if(fm.gubun2.options[fm.gubun2.selectedIndex].value == '5'){ //입력
			td_gubun2_1.style.display	= 'none';
			td_gubun2_2.style.display	= '';
			fm.st_dt.value = '';
			fm.end_dt.value = '';
			fm.st_dt.focus();
		}else{
			td_gubun2_1.style.display	= 'none';
			td_gubun2_2.style.display	= 'none';
		}
	}		

	//디스플레이 타입(검색) -검색조건 선택시
	function cng_input2(){
		var fm = document.form1;
		if(fm.s_kd.options[fm.s_kd.selectedIndex].value == '4'){ //보험사
			td_input.style.display	= 'none';
			td_mng.style.display	= '';
		}else{
			td_input.style.display	= '';
			td_mng.style.display	= 'none';
		}
	}		
//-->
</script>
</head>
<body onload="javascript:document.form1.t_wd.focus();">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun0 = request.getParameter("gubun0")==null?"":request.getParameter("gubun0");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
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
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");	
	String s_st = request.getParameter("s_st")==null?"1":request.getParameter("s_st");
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");	
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");
	
	CommonDataBase c_db = CommonDataBase.getInstance();	
	
	Vector branches = c_db.getBranchList(); //영업소 리스트 조회
	int brch_size = branches.size();
	
%>
<form action="./ins_s_sc.jsp" name="form1" method="POST" target="c_foot">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="idx" value="<%=idx%>">
<input type="hidden" name="s_st" value="<%=s_st%>">
<input type='hidden' name='gubun0' value='<%=gubun0%>'>
<input type='hidden' name='gubun7' value='<%=gubun7%>'>
  <table border=0 cellspacing=0 cellpadding=0 width=98%>
   	<tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>사고관리 > 보험관리 > <span class=style5>보험료관리</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
      <td width="80"><font color="#0099CC"><img src="../../images/arrow2.gif" width="12" height="9">[조&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;회]</font></td>
      <td width="150">사업구분 : 
        <select name="gubun1">
          <option value=""   <%if(gubun1.equals("")){%>selected<%}%>>전체</option>
          <option value="1" <%if(gubun1.equals("1")){%>selected<%}%>>렌트</option>
          <option value="2" <%if(gubun1.equals("2")){%>selected<%}%>>리스</option>
        </select>
      </td>
      <td width="150">영&nbsp;업&nbsp;소&nbsp; : 
        <select name='brch_id'>
          <option value=''>전체</option>
          <%if(brch_size > 0){
				for (int i = 0 ; i < brch_size ; i++){
					Hashtable branch = (Hashtable)branches.elementAt(i);%>
          <option value='<%= branch.get("BR_ID") %>'  <%if(brch_id.equals(String.valueOf(branch.get("BR_ID")))){%>selected<%}%>> 
          <%= branch.get("BR_NM")%> </option>
          <%	}
			}%>
        </select>
      </td>
      <td width="150">조회기간 : 
        <select name="gubun2" onChange="javascript:cng_input1()">
          <option value=""  <%if(gubun2.equals("")){ %>selected<%}%>>전체</option>		
          <option value="1" <%if(gubun2.equals("1")){%>selected<%}%>>당일</option>
          <option value="2" <%if(gubun2.equals("2")){%>selected<%}%>>당월누적</option>
          <option value="3" <%if(gubun2.equals("3")){%>selected<%}%>>당해월별</option>
          <option value="4" <%if(gubun2.equals("4")){%>selected<%}%>>당해년도</option>
          <option value="5" <%if(gubun2.equals("5")){%>selected<%}%>>직접입력</option>
        </select>
      </td>
      <td width="180"> 
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td id='td_gubun2_1' <%if(gubun2.equals("3")){%>style="display:''"<%}else{%>style='display:none'<%}%>> 
              <select name="s_mon">
                <%for(int i=1; i<13; i++){%>
                <option value="<%=i%>" <%if(st_dt.equals(Integer.toString(i))){%>selected<%}%>><%=i%>월</option>
                <%}%>
              </select>
            </td>
            <td id='td_gubun2_2' <%if(gubun2.equals("5")){%>style="display:''"<%}else{%>style='display:none'<%}%>> 
              <input type="text" name="st_dt" size="10" value="<%=st_dt%>" class="text" >
              ~ 
              <input type="text" name="end_dt" size="10" value="<%=end_dt%>" class="text" >
            </td>
          </tr>
        </table>
      </td>
      <td width="51"><a href="javascript:Search(3)"><img src="/acar/images/center/button_search.gif"  align="absmiddle" border="0"></a> 
      <td width="51"><!--<a href="javascript:Search(1)"><img src="/images/search.gif" width="50" height="18" aligh="absmiddle" border="0"></a>--></td>
    </tr>

  </table>
</form>
</body>
</html>