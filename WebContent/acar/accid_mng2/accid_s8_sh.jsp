<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	function Search(s_st){
		var fm = document.form1;
		fm.s_st.value = s_st;
		if(s_st == '1'){
			if(fm.gubun2.value == '5' && fm.st_dt.value != '')						fm.st_dt.value = ChangeDate3(fm.st_dt.value);
			if(fm.gubun2.value == '5' && fm.end_dt.value != '')						fm.end_dt.value = ChangeDate3(fm.end_dt.value);
			if(fm.gubun2.value == '5' && fm.st_dt.value !='' && fm.end_dt.value=='')fm.end_dt.value = getTodayBar();
			if(fm.gubun2.value == '3' && fm.s_mon.value != '')						fm.st_dt.value = fm.s_mon.value; 
		}else if(s_st == '2'){
			if(fm.gubun3.value == '3'){ alert('무상대차 손비는 계획중입니다.'); return; }
		}else if(s_st == '3'){
			if(fm.s_kd.options[fm.s_kd.selectedIndex].value == '7' || fm.s_kd.options[fm.s_kd.selectedIndex].value == '11')	fm.t_wd.value = fm.s_mng.options[fm.s_mng.selectedIndex].value;
		}	
		fm.action="accid_s8_sc.jsp";
		fm.target="c_foot";		
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
	function cng_input3(){
		var fm = document.form1;
		if(fm.s_kd.options[fm.s_kd.selectedIndex].value == '7' || fm.s_kd.options[fm.s_kd.selectedIndex].value == '11'){ //접수자
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
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"3":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"4":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"desc":request.getParameter("asc");
	String s_st = request.getParameter("s_st")==null?"1":request.getParameter("s_st");
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");	
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
		


	Vector branches = c_db.getBranchList(); //영업소 리스트 조회
	int brch_size = branches.size();	
	
			//담당자 리스트
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();	
	
		//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이				
%>
<form action="./accid_s8_sc.jsp" name="form1" method="POST" target="c_foot">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="idx" value="<%=idx%>">
<input type="hidden" name="s_st" value="<%=s_st%>">
<input type="hidden" name="gubun4" value="<%=gubun4%>">
<input type="hidden" name="gubun5" value="<%=gubun5%>">
<input type="hidden" name="gubun6" value="<%=gubun6%>">
<input type="hidden" name="sh_height" value="<%=sh_height%>">
<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
    	<td colspan=5>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>사고 및 보험  > 사고관리 > <span class=style5>시세하락손해관리</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>  	    
    <tr> 
        <td width=21%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_g_su.gif align=absmiddle>&nbsp;
            <select name="gubun1">
              <option value=""   <%if(gubun1.equals("")){%>selected<%}%>>전체</option>
              <option value="1" <%if(gubun1.equals("1")){%>selected<%}%>>렌트</option>
              <option value="2" <%if(gubun1.equals("2")){%>selected<%}%>>리스</option>
            </select>
        </td>
        <td width=16%>
	    <%//if(br_id.equals("S1")){%>
    	  <img src=/acar/images/center/arrow_yus.gif  align=absmiddle>&nbsp;&nbsp;&nbsp;  	  
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
    		<%//}%>		
        </td>
        <td width=13%>&nbsp;        </td>
        <td width=16%>&nbsp; 
        </td>
        <td><!--<a href="javascript:Search(1)"><img src="/images/search.gif" width="50" height="18" aligh="absmiddle" border="0"></a>--></td>
    </tr>
    <tr> 
        <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_g_ig.gif  align=absmiddle>&nbsp;
            <select name="gubun3">
              <option value=""  <%if(gubun3.equals("")){%>selected<%}%>>전체</option>
              <option value="4" <%if(gubun3.equals("4")){%>selected<%}%>>미청구</option>		  		  		  		  
              <option value="0" <%if(gubun3.equals("0")){%>selected<%}%>>미수금</option>
              <option value="1" <%if(gubun3.equals("1")){%>selected<%}%>>수금</option>
            </select>
        </td>
        <td><img src=/acar/images/center/arrow_ggjh.gif  align=absmiddle>&nbsp;
          <select name="gubun2" onChange="javascript:cng_input1()">
            <option value="1" <%if(gubun2.equals("1")){%>selected<%}%>>당일</option>
            <option value="2" <%if(gubun2.equals("2")){%>selected<%}%>>당월누적</option>
            <!--    <option value="3" <%if(gubun2.equals("3")){%>selected<%}%>>당해월별</option> -->
            <option value="4" <%if(gubun2.equals("4")){%>selected<%}%>>당해년도</option>
            <option value="5" <%if(gubun2.equals("5")){%>selected<%}%>>직접입력</option>
          </select>
         
        </td>
        <td colspan="2"><table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td id='td_gubun2_1' <%if(gubun2.equals("3")){%>style="display:''"<%}else{%>style='display:none'<%}%>><select name="s_mon">
                <%for(int i=1; i<13; i++){%>
                <option value="<%=i%>" <%if(st_dt.equals(Integer.toString(i))){%>selected<%}%>><%=i%>월</option>
                <%}%>
              </select>
            </td>
            <td id='td_gubun2_2' <%if(gubun2.equals("5")){%>style="display:''"<%}else{%>style='display:none'<%}%>><input type="text" name="st_dt" size="11" value="<%=st_dt%>" class="text" >
      ~
        <input type="text" name="end_dt" size="11" value="<%=end_dt%>" class="text" >
            </td>
          </tr>
        </table></td>
        <td><!--<a href="javascript:Search(2)"><img src="/images/search.gif" width="50" height="18" aligh="absmiddle" border="0"></a>--></td>
    </tr>
    <tr> 
        <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_gsjg.gif  align=absmiddle>&nbsp;  
            <select name="s_kd" onChange="javascript:cng_input3()">
              <option value=""  <%if(s_kd.equals("")){%> selected <%}%>>전체</option>
              <option value="1" <%if(s_kd.equals("1")){%> selected <%}%>>계약번호</option>
              <option value="2" <%if(s_kd.equals("2")){%> selected <%}%>>상호</option>
              <option value="3" <%if(s_kd.equals("3")){%> selected <%}%>>차량번호</option>		  
              <option value="4" <%if(s_kd.equals("4")){%> selected <%}%>>차명</option>
              <option value="7" <%if(s_kd.equals("7")){%> selected <%}%>>관리담당자</option>
              <option value="5" <%if(s_kd.equals("5")){%> selected <%}%>>사고일자</option>
              <option value="6" <%if(s_kd.equals("6")){%> selected <%}%>>보험접수번호</option>
              <option value="8" <%if(s_kd.equals("8")){%> selected <%}%>>상대보험사</option>		  
              <option value="9" <%if(s_kd.equals("9")){%> selected <%}%>>청구일자</option>		  		  
              <option value="10" <%if(s_kd.equals("10")){%> selected <%}%>>입금일자</option>
			  <option value="11" <%if(s_kd.equals("11")){%> selected <%}%>>청구담당자</option>		  		  		  
            </select>
        </td>
        <td> 
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                    <td id='td_input' <%if(s_kd.equals("7") || s_kd.equals("11")){%> style='display:none'<%}%>> 
                      <input type="text" name="t_wd" size="21" value="<%=t_wd%>" class="text" onKeyDown="javasript:enter()">
                    </td>
                    <td id='td_mng' <%if(s_kd.equals("7") || s_kd.equals("11")){%> style="display:''"<%}else{%>style='display:none'<%}%>> 
                      <select name='s_mng'>
                        <option value="">미지정</option>
                             <%if(user_size > 0){
        								for(int i = 0 ; i < user_size ; i++){
        									Hashtable user = (Hashtable)users.elementAt(i); 
        						%>
        							     <option value='<%=user.get("USER_ID")%>' <%if(t_wd.equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
        			                <%	}
        							}		%>
                         </select> </td>               
                </tr>
            </table>
        </td>
        <td colspan="2"><img src=/acar/images/center/arrow_jr.gif  align=absmiddle>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <select name="sort">
              <option value="1" <%if(sort.equals("1")){%> selected <%}%>>상호</option>
              <option value="2" <%if(sort.equals("2")){%> selected <%}%>>차량번호</option>
              <option value="3" <%if(sort.equals("3")){%> selected <%}%>>차명</option>
              <option value="4" <%if(sort.equals("4")){%> selected <%}%>>사고일자</option>
              <option value="5" <%if(sort.equals("5")){%> selected <%}%>>상대보험사</option>
              <option value="6" <%if(sort.equals("6")){%> selected <%}%>>청구일자</option>
              <option value="7" <%if(sort.equals("7")){%> selected <%}%>>입금일자</option>
            </select>
            <input type='radio' name='asc' value='asc' <%if(asc.equals("asc")){%> checked <%}%> onClick='javascript:Search(3)'>
            오름차순 
            <input type='radio' name='asc' value='desc' <%if(asc.equals("desc")){%> checked <%}%>onClick='javascript:Search(3)'>
            내림차순 </td>
        <td><a href="javascript:Search(3)"><img src="/acar/images/center/button_search.gif"  align="absmiddle" border="0"></a> &nbsp;&nbsp;	  
        </td>
    </tr>
</table>
</form>
</body>
</html>