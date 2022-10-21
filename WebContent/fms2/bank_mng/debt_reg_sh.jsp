<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");

	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"1":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"5":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"desc":request.getParameter("asc");

	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 3; //현황 출력 영업소 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//현황 라인수만큼 제한 아이프레임 사이즈
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	CodeBean[] banks = c_db.getCodeAll("0003"); /* 코드 구분:은행명 */	
	int bank_size = banks.length;
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
	<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	
	function Search(){
		var fm = document.form1;
		
		fm.action="debt_reg_sc.jsp";
		fm.target="c_foot";		
		fm.submit();
	}
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') Search();
	}	
		
	
//-->
</script>
<!-- <script language="JavaScript" src="/acar/include/common.js"></script> --><!-- 스크립트 오류로 주석 처리 2018.03.07 -->
</head>
<body>
<form action="./debt_reg_sc.jsp" name="form1" method="POST">
  <input type='hidden' name="s_width" value="<%=s_width%>">   
  <input type='hidden' name="s_height" value="<%=s_height%>">     
  <input type='hidden' name="sh_height" value="<%=sh_height%>">   
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>

<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr> 
        <td colspan=3>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar//images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp; <span class=style1>재무회계 > 구매자금관리 ><span class=style5>은행대출처리</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td colspan=2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_gggub.gif align=absmiddle>
        &nbsp;<select name="gubun1" >
          <option value="1" <%if(gubun1.equals("1")){%> selected <%}%>>계약일&nbsp;</option>
        </select>	
		    &nbsp;<input type="text" name="st_dt" size="12" value="<%=st_dt%>" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
		    &nbsp;~&nbsp;
		    <input type="text" name="end_dt" size="12" value="<%=end_dt%>" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>	  
        </td>
    </tr>    
    <tr> 
        <td width=370>
            <table width="100%" cellspacing=0 border="0" cellpadding="0">
                <tr>
                    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_gsjg.gif align=absmiddle>
                      &nbsp;&nbsp;<select name="bank_id" id="bank_id">
    			<option value=''>전체</option>
<%
	if(bank_size > 0)
	{
		for(int i = 0 ; i < bank_size ; i++)
		{
			CodeBean bank = banks[i];
%>
				<option value='<%= bank.getCode()%>'><%= bank.getNm()%></option>
<%		}
	}
%>	    	</select>&nbsp;
              		
      	            </td>
                </tr>
            </table>
        </td>
        <td><a href="javascript:Search();"><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a></td>
    </tr>    
</table>
</form>
<script>
/* 금융사 정렬 작업 		2018.03.07			start  */
//문자가 한글인지 판별
function is_hangul_char(ch){
	c = ch.charCodeAt(0);
	if( 0x1100<=c && c<=0x11FF ) return true;
	if( 0x3130<=c && c<=0x318F ) return true;
	if( 0xAC00<=c && c<=0xD7A3 ) return true;
	return false;
}

var sort_finance = function(){
	var options = $("#bank_id option");
	var arr = options.map(function(_, o) { return { t: $(o).text(), v: o.value }; }).get();

	// asc 순으로 정렬 작업
	arr.sort(function(o1, o2){
			return o1.t > o2.t ? 1 : o1.t < o2.t ? -1 : 0;
	});
	
	// 특수문자, 영문인 배열중 마지막 값을 획득
	var abv;
	for(var i=0; i<arr.length; i++){
		if(is_hangul_char((arr[i].t).charAt(0))) {
			abv = i;
			break;
		}
	}

	var arr_bottom = arr.slice(0, abv);
	var arr_middle = arr.slice(abv, arr.length);

	// 한글 배열 중 전체가 들어간 값을 획득
	var amv;
	for(var j=0; j<arr_middle.length; j++){
		if(arr_middle[j].t == "전체") {
			amv = j;
			break;
		}
	}

	// 한글, 특수문자, 영문 순으로 다시 정렬한 배열을 교체
	var arr_top = arr_middle.slice(amv, (amv+1));
	var arr_second = arr_middle.slice(0, amv);
	var arr_third = arr_middle.slice((amv+1), amv.length);

	var tt1 = arr_top.concat(arr_second);
	var tt2 = tt1.concat(arr_third);
	var tt3 = tt2.concat(arr_bottom);

	arr = tt3;

	options.each(function(i, o) {
		o.value = arr[i].v;
		$(o).text(arr[i].t);
	});
	
	// 클라이언트 메모리 낭비를 막기위한 초기화 작업
	tt1 = "";
	tt2 = "";
	tt3 = "";
	arr_top = "";
	arr_second = "";
	arr_third = "";
	arr_middle = "";
	arr_bottom = "";
}
/* 금융사 정렬 작업 		2018.03.07			end */

$(document).ready(function(){
	sort_finance();
});
</script>
</body>
</html>
