<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, java.util.Collections.*"%>
<%@ page import="acar.common.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>

<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
	<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel='stylesheet' type='text/css' href='/include/table_t.css'>
<script language="JavaScript">
<!--
	function search()
	{
		document.form1.submit();
	}
	
	//은행대출 등록
	function reg_bank_lend(){
		parent.location='bank_reg_frame.jsp?auth_rw='+document.form1.auth_rw.value+'&user_id='+document.form1.user_id.value+'&br_id='+document.form1.br_id.value+'&lend_id=';
	}	
	
	function cng_input(){
		var fm = document.form1;
		
		fm.action ="bank_sh.jsp";
		fm.target="_self";						
		fm.submit();
	}
//-->
</script>
</head>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	String bank_id = request.getParameter("bank_id")==null?"":request.getParameter("bank_id");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	

	CodeBean[] banks = c_db.getLendCptCdAll(gubun); /* 코드 구분:은행명 lend_bank */	
	int bank_size = banks.length;
	
	
	
%>
<body>
<form name='form1' action='/acar/bank_mng/bank_sc.jsp' method='post' target='c_body'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr> 
        <td colspan=2>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp; <span class=style1>재무회계 > 구매자금관리 ><span class=style5>은행대출관리</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr>
    	<td>
    		<table width=100% border=0 cellpadding=0 cellspacing=0>
	    		<tr>
	    			<td width="210px">금융기관 구분 : 
						<select name='gubun' onChange='javascript:cng_input()'>
							<option value=''>전체</option>
							<option value='1' <%if(gubun.equals("1")){%>selected<%}%>>은행</option>
							<option value='2' <%if(gubun.equals("2")){%>selected<%}%>>캐피탈</option>
							<option value='3' <%if(gubun.equals("3")){%>selected<%}%>>저축은행</option>
							<option value='4' <%if(gubun.equals("4")){%>selected<%}%>>기타금융기관</option>
						</select>
					</td>
	    			<td width="230px" id="finance">
						금융사 :
						<select name="bank_id" id="bank_id">
			    			<option value=''>전체</option>
						<%
							//if(gubun.equals("1") || gubun.equals("2") || gubun.equals("3") || gubun.equals("4")) {
								for(int i = 0 ; i < bank_size ; i++) {
									CodeBean bank = banks[i];
							%>
							<option value='<%= bank.getCode()%>' <%if(bank_id.equals(bank.getCode())){%>selected<%}%>><%= bank.getNm()%></option>
							<%}%>
						<%--}--%>
						</select>
    				</td>
    				<td>
						진행여부 : 
						<select name='gubun1'>
			    			<option value='all' <%if(gubun1.equals("all")){%>selected<%}%>>전체</option>
			    			<option value='0'   <%if(gubun1.equals("0")){%>selected<%}%>>진행</option>
			    			<option value='1'   <%if(gubun1.equals("1")){%>selected<%}%>>완료</option>								
				    	</select>&nbsp;&nbsp;&nbsp;&nbsp;
			    		<a href=javascript:search();><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a>
    				</td>
    				<td align="right">
    					<a href=javascript:reg_bank_lend();><img src=/acar/images/center/button_reg.gif border=0 align=absmiddle></a>&nbsp;&nbsp;&nbsp;&nbsp;
    				</td>
	    		</tr>
	      	</table>
    	</td>
    </tr>
</table>
</form>
<script>
// 금융사 정렬 작업 2018.03.06
function is_hangul_char(ch){
	c = ch.charCodeAt(0);
	if( 0x1100<=c && c<=0x11FF ) return true;
	if( 0x3130<=c && c<=0x318F ) return true;
	if( 0xAC00<=c && c<=0xD7A3 ) return true;
	return false;
}

var options = $("#bank_id option");
var arr = options.map(function(_, o) { return { t: $(o).text(), v: o.value }; }).get();

arr.sort(function(o1, o2){
		return o1.t > o2.t ? 1 : o1.t < o2.t ? -1 : 0;
});

var abv;
for(var i=0; i<arr.length; i++){
	if(is_hangul_char((arr[i].t).charAt(0))) {
		abv = i;
		break;
	}
}

var arr_bottom = arr.slice(0, abv);
var arr_middle = arr.slice(abv, arr.length);

var amv;
for(var j=0; j<arr_middle.length; j++){
	if(arr_middle[j].t == "전체") {
		amv = j;
		break;
	}
}

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

tt1 = "";
tt2 = "";
tt3 = "";
arr_top = "";
arr_second = "";
arr_third = "";
arr_middle = "";
arr_bottom = "";

</script>
</body>
</html>