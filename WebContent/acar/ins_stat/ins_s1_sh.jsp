<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String gubun0 = request.getParameter("gubun0")==null?"":request.getParameter("gubun0");
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");	
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");	
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");	
	String gubun7 = request.getParameter("gubun7")==null?"":request.getParameter("gubun7");	
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"2":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"1":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"asc":request.getParameter("asc");	
	String s_st = request.getParameter("s_st")==null?"1":request.getParameter("s_st");
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");	
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	Vector branches = c_db.getBranchList(); //영업소 리스트 조회
	int brch_size = branches.size();
		
			//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	function Search(){
		var fm = document.form1;
		if(fm.gubun2.value == '5' && fm.st_dt.value != '')						fm.st_dt.value = ChangeDate3(fm.st_dt.value);
		if(fm.gubun2.value == '5' && fm.end_dt.value != '')						fm.end_dt.value = ChangeDate3(fm.end_dt.value);
		if(fm.gubun2.value == '5' && fm.st_dt.value !='' && fm.end_dt.value=='')fm.end_dt.value = getTodayBar();
		if(fm.gubun2.value == '3' && fm.s_mon.value != '')						fm.st_dt.value = fm.s_mon.value; 
		fm.action="ins_s1_sc1.jsp";
		fm.target="c_foot";		
		fm.submit();
	}
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') Search();
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
	
	//하단메뉴 이동
	function sub_in(idx){
		var fm = document.form1;
		fm.action="ins_s1_sc"+idx+".jsp";
		fm.target="c_foot";		
		fm.submit();	
	}				
//-->
</script>
</head>
<body>
<form action="./ins_s1_sc1.jsp" name="form1" method="POST" target="c_foot">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type='hidden' name='gubun0' value='<%=gubun0%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='gubun5' value='<%=gubun5%>'>
<input type='hidden' name='gubun6' value='<%=gubun6%>'>
<input type='hidden' name='gubun7' value='<%=gubun7%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort' value='<%=sort%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type="hidden" name="idx" value="<%=idx%>">
<input type="hidden" name="s_st" value="<%=s_st%>">
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
    	<td colspan=5>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>사고관리 > 보험현황 > <span class=style5>보험가입현황</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>    
    <tr>
        <td width=15%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_g_su.gif align=absmiddle>&nbsp;
            <select name="gubun1">
              <option value=""   <%if(gubun1.equals("")){%>selected<%}%>>전체</option>
              <option value="1" <%if(gubun1.equals("1")){%>selected<%}%>>렌트</option>
              <option value="2" <%if(gubun1.equals("2")){%>selected<%}%>>리스</option>
            </select>
        </td>
        <td width=15%><img src=/acar/images/center/arrow_yus.gif align=absmiddle>&nbsp;  
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
        <td width=13%><img src=/acar/images/center/arrow_ggjh.gif align=absmiddle>&nbsp;  
            <select name="gubun2" onChange="javascript:cng_input1()">
              <option value="1" <%if(gubun2.equals("1")){%>selected<%}%>>당일</option>
              <option value="2" <%if(gubun2.equals("2")){%>selected<%}%>>당월누적</option>
              <option value="3" <%if(gubun2.equals("3")){%>selected<%}%>>당해월별</option>
              <option value="4" <%if(gubun2.equals("4")){%>selected<%}%>>당해년도</option>
              <option value="5" <%if(gubun2.equals("5")){%>selected<%}%>>직접입력</option>
            </select>
        </td>
        <td width=16%> 
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
        <td><a href="javascript:Search()"><img src="/acar/images/center/button_search.gif"  align="absmiddle" border="0"></a></td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td colspan=5 style='height:1; background-color:e7e7e8;'></td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr align="center"> 
        <td colspan="5"> 
            <a href="javascript:sub_in(1)"><img src="/acar/images/center/button_ins_nreg.gif"  align="absmiddle" border="0"></a>&nbsp;&nbsp; <a href="javascript:sub_in(2)"><img src="/acar/images/center/button_ins_gsreg.gif"  align="absmiddle" border="0"></a> 
            &nbsp;&nbsp;<a href="javascript:sub_in(3)"><img src="/acar/images/center/button_ins_mgy.gif"  align="absmiddle" border="0"></a>&nbsp;&nbsp; <a href="javascript:sub_in(4)"><img src="/acar/images/center/button_ins_hjhh.gif"  align="absmiddle" border="0"></a> 
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td colspan=5 style='height:1; background-color:e7e7e8;'></td>
    </tr>
</table>
</form>
</body>
</html>