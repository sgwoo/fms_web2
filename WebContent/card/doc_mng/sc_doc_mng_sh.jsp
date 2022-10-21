<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, card.*, acar.user_mng.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
		
	//추가 : 소유자 리스트
	Vector users3 = c_db.getUserList("", "", "EMP");
	int user3_size = users3.size();
	
	//카드종류 리스트 조회
	Vector card_kinds = CardDb.getCardKinds("", "");
	int ck_size = card_kinds.size();
		
	//코드 구분:부서명-가산점적용
	CodeBean[] depts = c_db.getCodeAll2("0002", "");
	int dept_size = depts.length;
	//카드관리자 리스트 조회
	Vector card_m_ids = CardDb.getCardMngIds("card_mng_id", "", "Y");
	int cmi_size = card_m_ids.size();
	//전표승인자 리스트 조회
	Vector card_d_ids = CardDb.getCardMngIds("doc_mng_id", "", "Y");
	int cdi_size = card_d_ids.size();
	String user_nm = "";
	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<style type="text/css">
.height_td {height:33px;}
select {
	width: 104px !important;
}
.input {
	height: 24px !important;
}
</style>
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
function Search(gubun){
	var fm = document.form1;
	if (gubun == "2") {
		fm.search_start.value = "Y";
	}
	fm.action="sc_doc_mng_sc.jsp";
	fm.target="c_foot";		
	fm.submit();
}
function enter() {
	var keyValue = event.keyCode;
	if (keyValue =='13') Search('2');
}	
//직원리스트
function GetUsetList(nm){
	var fm = document.form1;
	te = fm.gubun4;
	te.options[0].value = '';
	te.options[0].text = '전체';
	fm.nm.value = "form1."+nm;
	fm.target = "i_no";
	fm.action = "../card_mng/user_null.jsp";
	fm.submit();
}

//승인여부 체크시 거래일자 매월 초로 자동 입력
Date.prototype.format = function(f) {
    if (!this.valueOf()) return " ";
 
    var weekName = ["일요일", "월요일", "화요일", "수요일", "목요일", "금요일", "토요일"];
    var d = this;
     
    return f.replace(/(yyyy|yy|MM|dd|E|hh|mm|ss|a\/p)/gi, function($1) {
        switch ($1) {
            case "yyyy": return d.getFullYear();
            case "yy": return (d.getFullYear() % 1000).zf(2);
            case "MM": return (d.getMonth() + 1).zf(2);
            case "dd": return d.getDate().zf(2);
            case "E": return weekName[d.getDay()];
            case "HH": return d.getHours().zf(2);
            case "hh": return ((h = d.getHours() % 12) ? h : 12).zf(2);
            case "mm": return d.getMinutes().zf(2);
            case "ss": return d.getSeconds().zf(2);
            case "a/p": return d.getHours() < 12 ? "오전" : "오후";
            default: return $1;
        }
    });
};

String.prototype.string = function(len){var s = '', i = 0; while (i++ < len) { s += this; } return s;};
String.prototype.zf = function(len){return "0".string(len - this.length) + this;};
Number.prototype.zf = function(len){return this.toString().zf(len);};

function first_date(){
	var fm = document.form1;
	var now = new Date();
	var firstDate = new Date(now.getFullYear(), now.getMonth(), 1).format("yyyy-MM-dd");
	var endDate = new Date().format("yyyy-MM-dd");
	//	new Date().format("yyyy-MM-dd");
	
	if(fm.chk2[0].checked == true || fm.chk2[1].checked == true || fm.chk2[2].checked == true|| fm.chk2[3].checked == true) {
		if(fm.st_dt.value == "" && fm.end_dt.value == "") {
			fm.st_dt.value = firstDate;
			fm.end_dt.value= endDate;
		}
	}else{
		fm.st_dt.value = "";
		fm.end_dt.value = "";
	}
}
</script>

</head>
<body onload="javascript=Search('1');">
<form action="" name="form1" method="POST">

  <input type='hidden' name="s_width" value="<%=s_width%>">   
  <input type='hidden' name="s_height" value="<%=s_height%>">     
  <input type='hidden' name="sh_height" value="<%=sh_height%>">   
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type='hidden' name='br_id' value='<%=br_id%>'>
  <input type='hidden' name='user_id' value='<%=user_id%>'>    
  <input type="hidden" name="idx" value="<%=idx%>">
  <input type="hidden" name="type" value="search">  
  <input type="hidden" name="go_url" value="/tax/scd_mng/scd_mng_sc.jsp">      
  <input type="hidden" name="nm" value="">
  <input type="hidden" name="search_start" value="">

<table border=0 cellspacing=0 cellpadding=0 width=100% class="search-area">
	<tr >
		<td colspan=6 style="height: 30px">
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td class="navigation">&nbsp;<span class=style1>재무회계 > 법인전표관리 > <span class=style5>New 카드전표관리</span></span></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td colspan=6  class=h></td>
	</tr>
	<tr>
	  	<!-- 기간구분 -->
	    <td width="8%" class="height_td">&nbsp;
	    	<label><i class="fa fa-check-circle"></i> 기간구분 </label>
	    </td>
	    <td width="35%">
			<select name="gubun1" class="select">
 				<option value="1" <%if(gubun1.equals("1")){%> selected <%}%>>거래일자</option>
				<option value="2" <%if(gubun1.equals("2")){%> selected <%}%>>등록일자</option>
				<option value="3" <%if(gubun1.equals("3")){%> selected <%}%>>승인일자</option>
			</select>&nbsp;
			<input class="input" type="text" name="st_dt" size="10" value="<%-- <%=st_dt%> --%>" class="text" onBlur="javscript:this.value = ChangeDate(this.value);">&nbsp;~&nbsp;
  	  		<input class="input" type="text" name="end_dt" size="10" value="<%-- <%=end_dt%> --%>" class="text" onBlur="javscript:this.value = ChangeDate(this.value);">
		</td>
		<!-- 소유자 -->
		<td width="8%">&nbsp;
			<label><i class="fa fa-check-circle"></i> 소유자 </label>
	    </td>
	    <td width="12%">
		    <%	
		    if(user3_size > 0){
				for (int i = 0 ; i < user3_size ; i++){
					Hashtable user3 = (Hashtable)users3.elementAt(i);	
					
					if(user_id.equals(user3.get("USER_ID"))){
						user_nm = (String)user3.get("USER_NM");
					}
				}
			}
			%>
			<input class="input" type='text' name='gubun7' value='<%=user_nm%>' size="10" <%if(!nm_db.getWorkAuthUser("임원",user_id) && !nm_db.getWorkAuthUser("회계업무",user_id) && !nm_db.getWorkAuthUser("전산팀",user_id)){%>readonly<%}%> >
    	</td>
	     <!-- 사용자 -->
		<td width="8%">&nbsp;
			<label><i class="fa fa-check-circle"></i> 사용자 </label>
	    </td>
	    <td width="29%">			
			<input class="input" type='text' name='gubun4' value='<%-- <%=user_nm%> --%>' size="10">				
		</td>
	</tr>
	<tr>
	
		<!-- 부서명 -->
		<td class="height_td">&nbsp;
			<label><i class="fa fa-check-circle"></i> 부서명 </label>
	    </td>
	    <td>
			<select name='gubun3' class="select" >
				<option value=''>전체</option>
				<%
				for(int i = 0 ; i < dept_size ; i++){
					CodeBean dept = depts[i];%>
				<option value='<%=dept.getCode()%>' <%if(gubun3.equals(dept.getCode())){%>selected<%}%>><%=dept.getNm()%></option>
				<%	
				}%>
			</select>
		</td>
			<!-- 영업소를 카드종류로 -->
			<td>&nbsp;
			<label><i class="fa fa-check-circle"></i> 카드종류  </label>
	    </td>
	    <td>
			<select name='gubun2' class="select" >
			  <option value=''>전체</option>
          <%	if(ck_size > 0){
					for (int i = 0 ; i < ck_size ; i++){
						Hashtable card_kind = (Hashtable)card_kinds.elementAt(i);%>
          <option value='<%= card_kind.get("CARD_KIND") %>' <%if(gubun2.equals(String.valueOf(card_kind.get("CARD_KIND")))){%>selected<%}%>><%= card_kind.get("CARD_KIND") %></option>
          <%		}
				}%>
        </select>        
		
		</td>
		
		<!-- 카드 -->
		<td>&nbsp;
			<label><i class="fa fa-check-circle"></i> 카드 </label>
	    </td>
	    <td>
			<input class="input" type="text" name="t_wd1" class="text" value='<%=t_wd1%>' onKeyDown='javascript:enter()' style='IME-MODE: active' size='15'>&nbsp;
			<span class="style2">(카드번호,소유자구분) </span>
		</td>
		<!-- <td align="right">&nbsp;</td> -->
	</tr>
	<tr>
		<!-- 상세조회 -->
		<td class="height_td">&nbsp;
			<label><i class="fa fa-check-circle"></i> 상세조회 </label>
	    </td>
	    <td>
			<select name='s_kd' class="select">
				<option value='1' <%if(s_kd.equals("1")){%>selected<%}%>>거래처 </option>
				<option value='2' <%if(s_kd.equals("2")){%>selected<%}%>>적요 </option>
				<option value='3' <%if(s_kd.equals("3")){%>selected<%}%>>구분 </option>
				<option value='5' <%if(s_kd.equals("5")){%>selected<%}%>>금액 </option>
			</select>&nbsp;
			<input class="input" type='text' name='t_wd2' size='25' class='text' value='<%=t_wd2%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
		</td>
		<!-- 관리자 -->
		<td>&nbsp;
			<label><i class="fa fa-check-circle"></i> 관리자 </label>
	    </td>
	    <td>
			<select name='gubun5' class="select">
				<option value="0">전체</option>
				<%	
				if(cmi_size > 0){
					for (int i = 0 ; i < cmi_size ; i++){
						Hashtable card_m_id = (Hashtable)card_m_ids.elementAt(i);%>
				<option value='<%= card_m_id.get("USER_ID") %>' <%if(gubun5.equals(String.valueOf(card_m_id.get("USER_ID")))){%>selected<%}%>><%= card_m_id.get("USER_NM") %></option>
				<%}
				}%>
			</select>
		</td>
		<!-- 승인자 -->
		<td>&nbsp;
			<label><i class="fa fa-check-circle"></i> 승인자 </label>
	    </td>
	    <td>
			<select name='gubun6' class="select">
			<option value="0">전체</option>
			<%
			if(cdi_size > 0){
				for (int i = 0 ; i < cdi_size ; i++){
					Hashtable card_d_id = (Hashtable)card_d_ids.elementAt(i);%>
			<option value='<%= card_d_id.get("USER_ID") %>' <%if(gubun6.equals(String.valueOf(card_d_id.get("USER_ID")))){%>selected<%}%>><%= card_d_id.get("USER_NM") %></option>
			<%}
			}%>
			</select>
		</td>
		<!-- <td align="right">&nbsp;</td> -->
	</tr>	
    <tr>
    	<!-- 승인여부 -->
		<td class="height_td">&nbsp;
			<label><i class="fa fa-check-circle"></i> 승인여부 </label>
	    </td>
	    <td style="vertical-align:middle;">
			<input type="radio" name="chk2" value="" <%if(chk2.equals("")){%> checked <%}%> onClick="javascript:first_date();">전체 
			<input type="radio" name="chk2" value="4" <%if(chk2.equals("4")){%> checked <%}%> onClick="javascript:first_date();">취소
			<input type="radio" name="chk2" value="1" <%if(chk2.equals("1")){%> checked <%}%> onClick="javascript:first_date();">승인
			<input type="radio" name="chk2" value="2" <%if(chk2.equals("2")){%> checked <%}%> onClick="javascript:first_date();">미승인
			<input type="radio" name="chk2" value="3" <%if(chk2.equals("3")){%> checked <%}%> onClick="javascript:first_date();">미등록
		</td>
    	<!-- 과세유형 -->
		<td>&nbsp;
			<label><i class="fa fa-check-circle"></i> 과세유형 </label>
	    </td>
	    <td colspan="3">
			<input type="radio" name="chk1" value="" <%if(chk1.equals("")){%> checked <%}%>>전체
			<input type="radio" name="chk1" value="1" <%if(chk1.equals("1")){%> checked <%}%>>일반과세
			<input type="radio" name="chk1" value="2" <%if(chk1.equals("2")){%> checked <%}%>>간이과세
			<input type="radio" name="chk1" value="3" <%if(chk1.equals("3")){%> checked <%}%>>면세
			<input type="radio" name="chk1" value="4" <%if(chk1.equals("4")){%> checked <%}%>>비영리법인(국가기관/단체)
			<input type="button" class="button" value="검색" onclick="javascript:Search('2');">
		</td>	
		<!-- <td align="right">&nbsp;</td> -->
 	</tr>	 
	<tr>
		<td colspan=6  class=h></td>
	</tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
