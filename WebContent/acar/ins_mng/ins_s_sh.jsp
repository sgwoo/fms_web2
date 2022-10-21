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
		if(fm.gubun2.value == '5' && fm.st_dt.value != '')							fm.st_dt.value 	= ChangeDate3(fm.st_dt.value);
		if(fm.gubun2.value == '5' && fm.end_dt.value != '')							fm.end_dt.value = ChangeDate3(fm.end_dt.value);
		if(fm.gubun2.value == '5' && fm.st_dt.value !='' && fm.end_dt.value=='')	fm.end_dt.value = getTodayBar();
		if(fm.gubun2.value == '3' && fm.s_mon.value != '')							fm.st_dt.value 	= fm.s_mon.value; 
		if(fm.gubun3.value == '5' || fm.gubun3.value == '6')						fm.gubun2.value = "";
		fm.action="ins_s_sc.jsp";
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
	
	//등록사유 디스플레이
	function change_type()
	{
		var fm = document.form1;
		drop_type();
		fm.gubun4.options[0] = new Option('전체', '');		
		if(fm.gubun3.value == '1'){
			fm.gubun4.options[1] = new Option('신차', '1');
			fm.gubun4.options[2] = new Option('용도변경', '2');
		}else if(fm.gubun3.value == '2'){
			fm.gubun4.options[1] = new Option('만기', '4');
			fm.gubun4.options[2] = new Option('담보변경', '3');
		}else if(fm.gubun3.value == '3'){
			fm.gubun4.options[1] = new Option('R->L', '1');
			fm.gubun4.options[2] = new Option('L->R', '2');
			fm.gubun4.options[3] = new Option('매각', '3');
			fm.gubun4.options[4] = new Option('말소', '4');						
			fm.gubun4.options[5] = new Option('폐차', '5');			
		}else if(fm.gubun3.value == '5'){
			fm.gubun4.options[1] = new Option('신차', '1');
			fm.gubun4.options[2] = new Option('갱신', '3');
			fm.gubun4.options[3] = new Option('용도변경', '2');
		}else if(fm.gubun3.value == '6'){
			fm.gubun4.options[1] = new Option('용도변경', '1');
			fm.gubun4.options[2] = new Option('매각', '2');
		}
	}	
	function drop_type()
	{
		var fm = document.form1;
		var len = fm.gubun4.length;
		for(var i = 0 ; i < len ; i++){
			fm.gubun4.options[len-(i+1)] = null;
		}
	}			
	//검색하기
	function ins_double(){
		window.open("ins_double.jsp", "double", "left=100, top=100, width=800, height=600, scrollbars=yes");
	}
	
function car_gbu_doc(){
	if(document.form1.gubun3.value == '6'){
		var fm = parent.c_foot.i_no.form1;
		var len = fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck = fm.elements[i];
			if(ck.name == 'pr'){
				if(ck.checked == true){
					cnt++;
					idnum = ck.value;
				}
			}
		}
		if(cnt == 0){ alert("차량을 선택하세요 !"); return; }
		fm.action = "/acar/off_ls_cmplt/car_gbu_doc.jsp";
		fm.target = "_blank";
		fm.submit();
	}else{
		alert('미해지일때만 처리됩니다.');
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
	
			//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
%>
<form action="./ins_s_sc.jsp" name="form1" method="POST" target="c_foot">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="idx" value="<%=idx%>">
<input type="hidden" name="s_st" value="<%=s_st%>">
<input type='hidden' name='gubun0' value='<%=gubun0%>'>
<input type='hidden' name='gubun7' value='<%=gubun7%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
    	<td colspan=5>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>사고 및 보험 > 보험관리 > <span class=style5>보험가입조회</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td width=18%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_g_su.gif align=absmiddle>&nbsp;
            <select name="gubun1">
              <option value=""  <%if(gubun1.equals("")){ %>selected<%}%>>전체</option>
              <option value="1" <%if(gubun1.equals("1")){%>selected<%}%>>렌트</option>
              <option value="2" <%if(gubun1.equals("2")){%>selected<%}%>>리스</option>
            </select>
        </td>
        <td width=16%><img src=/acar/images/center/arrow_yus.gif align=absmiddle>&nbsp;&nbsp;&nbsp;  
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
        <td width=16%><img src=/acar/images/center/arrow_ggjh.gif align=absmiddle>&nbsp;  
            <select name="gubun2" onChange="javascript:cng_input1()">
              <option value=""  <%if(gubun2.equals("")){ %>selected<%}%>>전체</option>
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
                      <input type="text" name="st_dt" size="10"  value="<%=st_dt%>" class="text" >
                      ~ 
                      <input type="text" name="end_dt" size="10" value="<%=end_dt%>" class="text" >
                    </td>
                </tr>
            </table>
        </td>
        <td><!--<a href="javascript:Search(1)"><img src="/images/search.gif" width="50" height="18" aligh="absmiddle" border="0"></a>--></td>
    </tr>
    <tr> 
        <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_g_reg.gif align=absmiddle>&nbsp;
            <select name="gubun3" onChange='javascript:change_type()'>
              <option value=""  <%if(gubun3.equals("")){ %>selected<%}%>>전체</option>
              <option value="1" <%if(gubun3.equals("1")){%>selected<%}%>>신규</option>
              <option value="2" <%if(gubun3.equals("2")){%>selected<%}%>>갱신</option>
              <option value="4" <%if(gubun3.equals("4")){%>selected<%}%>>추가</option>		  
              <option value="3" <%if(gubun3.equals("3")){%>selected<%}%>>변경</option>		  
              <option value="7" <%if(gubun3.equals("7")){%>selected<%}%>>해지</option>
              <option value="5" <%if(gubun3.equals("5")){%>selected<%}%>>미가입</option>
              <option value="6" <%if(gubun3.equals("6")){%>selected<%}%>>미해지</option>	
              <option value="8" <%if(gubun3.equals("8")){%>selected<%}%>>기타</option>		  
            </select>
        </td>
        <td><img src=/acar/images/center/arrow_regsy.gif align=absmiddle>&nbsp;
            <select name="gubun4">
              <option value=""  <%if(gubun4.equals("")){ %>selected<%}%>>전체</option>
              <%if(gubun3.equals("1")){%>
              <option value='1' <%if(gubun4.equals("1")){%>selected<%}%>>신차</option>
              <option value='2' <%if(gubun4.equals("2")){%>selected<%}%>>용도변경</option>
              <%}else if(gubun3.equals("2")){%>
              <option value='4' <%if(gubun4.equals("4")){%>selected<%}%>>만기</option>
              <option value='3' <%if(gubun4.equals("3")){%>selected<%}%>>담보변경</option>
              <%}else if(gubun3.equals("3")){%>
              <option value='1' <%if(gubun4.equals("1")){%>selected<%}%>>R->L</option>
              <option value='2' <%if(gubun4.equals("2")){%>selected<%}%>>L->R</option>
              <option value='3' <%if(gubun4.equals("3")){%>selected<%}%>>매각</option>
              <option value='4' <%if(gubun4.equals("4")){%>selected<%}%>>말소</option>
              <option value='5' <%if(gubun4.equals("5")){%>selected<%}%>>폐차</option>		  		  
              <%}else if(gubun3.equals("5")){%>
              <option value='1' <%if(gubun4.equals("1")){%>selected<%}%>>신차</option>
              <option value='3' <%if(gubun4.equals("3")){%>selected<%}%>>갱신</option>
              <option value='2' <%if(gubun4.equals("2")){%>selected<%}%>>용도변경</option>
              <%}else if(gubun3.equals("6")){%>
              <option value='1' <%if(gubun4.equals("1")){%>selected<%}%>>용도변경</option>
              <option value='2' <%if(gubun4.equals("2")){%>selected<%}%>>매각</option>
              <%}%>
            </select>
        </td>
        <td><img src=/acar/images/center/arrow_g_db.gif align=absmiddle>&nbsp;
            <select name="gubun5" >
              <option value=""  <%if(gubun5.equals("")){ %>selected<%}%>>전체</option>
              <option value="1" <%if(gubun5.equals("1")){%>selected<%}%>>전담보</option>
              <option value="2" <%if(gubun5.equals("2")){%>selected<%}%>>책임보험</option>
    		  <%if(gubun3.equals("7")){%>
              <option value="3" <%if(gubun5.equals("3")){%>selected<%}%>>임의보험</option>
    		  <%}%>		  
            </select>
        </td>
        <td><img src=/acar/images/center/arrow_insst.gif align=absmiddle>&nbsp;
            <select name="gubun6" >
              <option value=""  <%if(gubun6.equals("")){ %>selected<%}%>>전체</option>
              <option value="1" <%if(gubun6.equals("1")){%>selected<%}%>>유효</option>
              <option value="2" <%if(gubun6.equals("2")){%>selected<%}%>>만료</option>
              <option value="3" <%if(gubun6.equals("3")){%>selected<%}%>>중도해지</option>
            </select>
        </td>
        <td>&nbsp;</td>
    </tr>
    <tr> 
        <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_gsjg.gif align=absmiddle>&nbsp;  
            <select name="s_kd">
              <option value=""  <%if(s_kd.equals("")){ %>selected<%}%>>전체</option>
              <option value="1" <%if(s_kd.equals("1")){%>selected<%}%>>차량번호</option>
              <option value="2" <%if(s_kd.equals("2")){%>selected<%}%>>차대번호</option>
              <option value="3" <%if(s_kd.equals("3")){%>selected<%}%>>차명</option>
              <option value="4" <%if(s_kd.equals("4")){%>selected<%}%>>보험회사</option>
              <option value="5" <%if(s_kd.equals("5")){%>selected<%}%>>증권번호</option>
            </select>
        </td>
        <td> 
            <input type="text" name="t_wd" size="22" value="<%=t_wd%>" class="text" onKeyDown="javasript:enter()">
        </td>
        <td colspan="2"><img src=/acar/images/center/arrow_jr.gif align=absmiddle>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  
            <select name="sort">
              <option value="1" <%if(sort.equals("1")){%>selected<%}%>>차량번호</option>
              <option value="2" <%if(sort.equals("2")){%>selected<%}%>>보험시작일</option>
              <option value="3" <%if(sort.equals("3")){%>selected<%}%>>보험만료일</option>
            </select>
            <input type='radio' name='asc' value='asc' <%if(asc.equals("asc")){%> checked <%}%> onClick='javascript:Search(3)'>
            오름차순 
            <input type='radio' name='asc' value='desc' <%if(asc.equals("desc")){%> checked <%}%>onclick='javascript:Search(3)'>
            내림차순 </td>
        <td>
            <a href="javascript:Search(3)" title='검색'><img src="/acar/images/center/button_search.gif" align="absmiddle" border="0"></a>&nbsp;
            <a href="javascript:ins_double()" title='중복리스트'><img src="/acar/images/center/button_list_jb.gif" align="absmiddle" border="0"></a>
            <%if(auth_rw.equals("6")){%>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <a href="javascript:car_gbu_doc()"><img src=../images/center/button_gbbgsc.gif align=absmiddle></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <%}%>
        </td>
    </tr>
</table>
</form>
</body>
</html>